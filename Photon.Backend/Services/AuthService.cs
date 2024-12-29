
using System.Diagnostics;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using FluentResults;
using FluentValidation;
using Google.Apis.Auth;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Octokit;
using Photon.Backend.Protos;
using Photon.Backend.Repositories;
using Photon.Backend.VOs;
using Status = Grpc.Core.Status;

namespace Photon.Backend.Services;

internal sealed class AuthService(
    AuthService.LoginRequestValidator validator,
    IAvatarRepository avatarRepository,
    IUserRepository userRepository,
    HttpClient client,
    GitHubClient gitHubClient,
    IConfiguration configuration,
    ILogger<AuthService> logger
    ) : Auth.AuthBase
{
    private sealed record UserDetails(Username Username, Email Email, Uri Avatar);
    
    // ReSharper disable once ClassNeverInstantiated.Global
    internal sealed class LoginRequestValidator : AbstractValidator<LoginRequest>
    {
        public LoginRequestValidator()
        {
            RuleFor(x => x.Token).NotNull().NotEmpty();
        }
    }

    public override async Task<Empty> Login(LoginRequest request, ServerCallContext context)
    {
        var validationResult = await validator.ValidateAsync(request);

        if (!validationResult.IsValid)
        {
            var errors = validationResult.Errors.Select(x => x.ErrorMessage);
            throw new RpcException(new Status(StatusCode.InvalidArgument, string.Join(", ", errors)));
        }
        
        var token = request.Token!;
        var userDetailsResult = request.LoginType switch
        {
            LoginType.Google => await GetDetailsGoogle(token),
            LoginType.Discord => await GetDetailsDiscord(token),
            LoginType.Github => await GetDetailsGithub(token),
            _ => throw new RpcException(new Status(StatusCode.InvalidArgument, "Invalid login type"))
        };
        
        if (!userDetailsResult.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.InvalidArgument, 
                userDetailsResult.Errors
                    .Select(x => x.Message)
                    .Aggregate((x, y) => x + ", " + y)));
        }
        
        var (username, email, avatar) = userDetailsResult.Value;
        
        var userResult = await userRepository.GetUserAsync(email);
        if (userResult.IsSuccess)
        {
            var claims = new List<Claim>
            {
                new(ClaimTypes.NameIdentifier, userResult.Value.Id.Value),
                new(ClaimTypes.Email, userResult.Value.Email.Value)
            };
            
            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            await context.GetHttpContext().SignInAsync(new ClaimsPrincipal(claimsIdentity));
            return new Empty();
        }

        userResult = await userRepository.CreateUserAsync(username, email);
        if (!userResult.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.Internal, "Failed to create user"));
        }
        var user = userResult.Value;
        // download avatar and set it
        var avatarData = await client.GetByteArrayAsync(avatar);
        var avatarResult = await avatarRepository.SetAvatarAsync(user.Id, avatarData);
        if (!avatarResult.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.Internal, "Failed to set avatar"));
        }
        
        var claims2 = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.Id.Value),
            new(ClaimTypes.Email, user.Email.Value)
        };
        
        var claimsIdentity2 = new ClaimsIdentity(claims2, CookieAuthenticationDefaults.AuthenticationScheme);
        await context.GetHttpContext().SignInAsync(new ClaimsPrincipal(claimsIdentity2));
        return new Empty();
    }

    private async Task<Result<UserDetails>> GetDetailsGithub(string code) 
    {
        var ts = Stopwatch.GetTimestamp();
        var tokenRequest =
            new OauthTokenRequest(configuration["Github:ClientId"], configuration["Github:ClientSecret"], code);
        var token = await gitHubClient.Oauth.CreateAccessToken(tokenRequest);
        
        if (token.Error is not null)
            return Result.Fail(token.ErrorDescription + " " + token.ErrorUri);
        
        var credentials = new Credentials(token.AccessToken, AuthenticationType.Bearer); 
        gitHubClient.Credentials = credentials;
        
        var userTask = gitHubClient.User.Current();
        var emailTask = gitHubClient.User.Email.GetAll();
        
        await Task.WhenAll(userTask, emailTask);
        
        var user = userTask.Result;
        var email = emailTask.Result.FirstOrDefault(x => x.Primary)?.Email!;
        
        logger.LogInformation("Github login took {time} ms", (Stopwatch.GetTimestamp() - ts) / (double) Stopwatch.Frequency * 1000);
        
        return new UserDetails(Username.From(user.Name), Email.From(email), new Uri(user.AvatarUrl));
    }

    private async Task<Result<UserDetails>> GetDetailsDiscord(string code)
    {
        var ts = Stopwatch.GetTimestamp();
        client.BaseAddress = new Uri("https://discord.com/");
        
        var data = new Dictionary<string, string>
        {
            ["grant_type"] = "authorization_code",
            ["code"] = code,
            ["redirect_uri"] = configuration["Discord:RedirectUri"]!
        };
        
        var content = new FormUrlEncodedContent(data);
        
        var byteArray = Encoding.ASCII.GetBytes($"{configuration["Discord:ClientId"]}:{configuration["Discord:ClientSecret"]}");
        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        client.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Basic", Convert.ToBase64String(byteArray));
        
        var response = await client.PostAsync("api/v10/oauth2/token", content);
        var responseString = await response.Content.ReadAsStringAsync();
        var responseContent = JsonSerializer.Deserialize<DiscordTokenResponse>(responseString);
        var token = responseContent?.AccessToken;
        
        if (token is null)
            return Result.Fail("Invalid code");
        
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        
        var userResponse = await client.GetAsync("api/v10/users/@me");
        var userContent = await userResponse.Content.ReadFromJsonAsync<DiscordUserResponse>();
        
        if (userContent?.Username is null)
            return Result.Fail("Invalid token");
        
        var (id, username, email, avatar) = userContent;
        var details = new UserDetails(Username.From(username), Email.From(email), 
            new Uri("https://cdn.discordapp.com/avatars/" + id + "/" + avatar + ".png"));
        
        logger.LogInformation("Discord login took {time} ms", (Stopwatch.GetTimestamp() - ts) / (double) Stopwatch.Frequency * 1000);
        return details;
    }

    private async Task<Result<UserDetails>> GetDetailsGoogle(string token)
    {
        try
        {
            var ts = Stopwatch.GetTimestamp();
            var payload = await GoogleJsonWebSignature.ValidateAsync(token);
            var email = Email.From(payload.Email);
            var username = Username.From(payload.Name);
            var avatar = new Uri(payload.Picture);
            logger.LogInformation("Google login took {time} ms", (Stopwatch.GetTimestamp() - ts) / (double) Stopwatch.Frequency * 1000);
            return new UserDetails(username, email, avatar);
        }
        catch (Exception e)
        {
            return Result.Fail(e.Message);
        }
    }
    
    private record DiscordTokenResponse(
        [property: JsonPropertyName("access_token")] string AccessToken,
        [property: JsonPropertyName("token_type")] string TokenType,
        [property: JsonPropertyName("expires_in")] int ExpiresIn,
        [property: JsonPropertyName("refresh_token")] string RefreshToken,
        [property: JsonPropertyName("scope")] string Scope);
    
    private record DiscordUserResponse(
        [property: JsonPropertyName("id")] ulong Id, 
        [property: JsonPropertyName("username")] string Username,
        [property: JsonPropertyName("email")] string Email,
        [property: JsonPropertyName("avatar")] string Avatar);
}