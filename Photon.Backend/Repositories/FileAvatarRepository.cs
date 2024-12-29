using FluentResults;
using Photon.Backend.VOs;
using SixLabors.ImageSharp;

namespace Photon.Backend.Repositories;

public sealed class FileAvatarRepository : IAvatarRepository
{
    public const string AvatarDirectory = "Work/Avatars";
    public async Task<Result<byte[]>> GetAvatarAsync(UserId userId)
    {
        var id = userId.Value;
        var path = Path.Combine(AvatarDirectory, $"{id}.png");
        if (!File.Exists(path))
        {
            return Result.Fail(new Error($"Avatar for user {id} not found"));
        }
        
        return Result.Ok(await File.ReadAllBytesAsync(path));
    }

    public async Task<Result> SetAvatarAsync(UserId userId, byte[] avatar)
    {
        var id = userId.Value;
        var path = Path.Combine(AvatarDirectory, $"{id}.png"); 
        var image = Image.Load(avatar);
        await image.SaveAsPngAsync(path);
        return Result.Ok();
    }

    public Task<Result> DeleteAvatarAsync(UserId userId)
    {
        var id = userId.Value;
        var path = Path.Combine(AvatarDirectory, $"{id}.png");
        if (!File.Exists(path))
        {
            return Task.FromResult(Result.Fail(new Error($"Avatar for user {id} not found")));
        }
        
        File.Delete(path);
        return Task.FromResult(Result.Ok());
    }
}