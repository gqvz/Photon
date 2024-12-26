using FluentValidation;
using Google.Apis.Auth;
using Newtonsoft.Json;
using Octokit;
using Photon.Backend;
using Photon.Backend.Database;
using Photon.Backend.Repositories;
using Photon.Backend.Services;
using Serilog;
using Serilog.Templates;
using StackExchange.Redis.Extensions.Core.Configuration;
using StackExchange.Redis.Extensions.Newtonsoft;

var builder = WebApplication.CreateBuilder(args);

const string consoleLogFormat =
    "[{@t:yyyy-MM-dd HH:mm:ss.fff}] " +  
    "[{@l}] " +
    "[{Coalesce(SourceContext, '<none>')}]: {@m}\n{@x}";

const string fileLogFormat =
    "[{@t:yyyy-MM-dd HH:mm:ss.fff}] " +
    "[{@l}] " +
    "[{Coalesce(SourceContext, '<none>')}]: {@m}\n{@x}";

builder.Host.UseSerilog((_, configuration) =>
{
    configuration
        .MinimumLevel.Information()
        .Enrich.FromLogContext()
        .WriteTo.Console(formatter: new ExpressionTemplate(consoleLogFormat, theme: LoggerTheme.Theme))
        .WriteTo.Map(
            _ => $"{DateOnly.FromDateTime(DateTimeOffset.UtcNow.DateTime):yyyy-MM-dd}",
            (v, cf) =>
            {
                cf.File(
                    new ExpressionTemplate(fileLogFormat),
                    $"./Logs/{v}.log",
                    // 32 megabytes
                    fileSizeLimitBytes: 33_554_432,
                    flushToDiskInterval: TimeSpan.FromMinutes(2.5),
                    rollOnFileSizeLimit: true,
                    retainedFileCountLimit: 50
                );
            },
            sinkMapCountLimit: 1);
});

builder.Services.AddGrpc();
builder.Services.AddGrpcSwagger();
builder.Services.AddSwaggerGen();

builder.Services.AddStackExchangeRedisExtensions<NewtonsoftSerializer>(serviceCollection =>
{
    var configuration = serviceCollection.GetRequiredService<IConfiguration>();
    return
    [
        new RedisConfiguration
        {
            AbortOnConnectFail = true,
            Hosts = new[]
            {
                new RedisHost
                {
                    Host = configuration["Redis:Host"] ?? throw new Exception("Redis host is not set"),
                    Port = int.Parse(configuration["Redis:Port"] ?? throw new Exception("Redis port is not set"))
                }
            },
            AllowAdmin = true,
            ConnectTimeout = 5000,
            Database = 0,
            Ssl = false,
            Password = configuration["Redis:Password"]
        }
    ];
});
builder.Services.AddSingleton<GitHubClient>(_ => new GitHubClient(new ProductHeaderValue("Photon")));
builder.Services.AddHttpClient();
builder.Services.AddAuthentication().AddCookie(options =>
{
    options.Events.OnRedirectToLogin = context => Results.Unauthorized().ExecuteAsync(context.HttpContext);
    options.Events.OnRedirectToAccessDenied = context => Results.Forbid().ExecuteAsync(context.HttpContext);
    
    options.Cookie.Name = "Photon.Auth";
    options.Cookie.HttpOnly = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    options.Cookie.SameSite = SameSiteMode.Strict;
    options.Cookie.MaxAge = TimeSpan.FromDays(7);
    options.SlidingExpiration = true;
});
builder.Services.AddAuthorization();

builder.Services.AddTransient<Mapper>();

builder.Services.AddOpenApi();
builder.Services.AddValidatorsFromAssembly(typeof(Program).Assembly, includeInternalTypes: true);

builder.Services.AddTransient<IAvatarRepository, FileAvatarRepository>();
builder.Services.AddTransient<IUserRepository, DbUserRepository>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapGrpcService<AuthService>();
app.MapGrpcService<UsersService>();
app.Run();