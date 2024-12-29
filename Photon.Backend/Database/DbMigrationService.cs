using Microsoft.EntityFrameworkCore;

namespace Photon.Backend.Database;

public sealed class DbMigrationService(IServiceProvider services) : IHostedService
{
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        using var scope = services.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<PhotonContext>();
        #if DEBUG
        await context.Database.MigrateAsync(cancellationToken);
        #endif
        _ = await context.Users.FirstOrDefaultAsync(cancellationToken: cancellationToken);
    
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}