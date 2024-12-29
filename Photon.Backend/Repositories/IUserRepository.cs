using FluentResults;
using Photon.Backend.Database.Models.DTOs;
using Photon.Backend.VOs;

namespace Photon.Backend.Repositories;

public interface IUserRepository
{
    public Task<Result<User>> GetUserAsync(UserId userId);
    
    public Task<Result<User>> GetUserAsync(Email email);
    
    public Task<Result<User>> CreateUserAsync(Username username, Email email);
    
    public Task<Result> UpdateUserAsync(UserId userId, Username? username = null, NotificationToken? notificationToken = null);
    
    public Task<Result> DeleteUserAsync(UserId userId);
}