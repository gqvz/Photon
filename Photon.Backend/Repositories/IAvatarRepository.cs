using FluentResults;
using Photon.Backend.VOs;

namespace Photon.Backend.Repositories;

public interface IAvatarRepository
{
    public Task<Result<byte[]>> GetAvatarAsync(UserId userId);
    
    public Task<Result> SetAvatarAsync(UserId userId, byte[] avatar);
    
    public Task<Result> DeleteAvatarAsync(UserId userId);
}
