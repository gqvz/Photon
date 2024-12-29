using FluentResults;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Hybrid;
using NanoidDotNet;
using Photon.Backend.Database;
using Photon.Backend.Database.Models;
using Photon.Backend.Database.Models.DTOs;
using Photon.Backend.VOs;

namespace Photon.Backend.Repositories;

public sealed class DbUserRepository(
    HybridCache cache,
    PhotonContext dbContext,
    ILogger<DbUserRepository> logger,
    Mapper mapper
    ) : IUserRepository
{
    public async Task<Result<User>> GetUserAsync(UserId userId)
    {
        var entity = await cache.GetOrCreateAsync(
            "user:id:" + userId,
            state: userId,
            async (id, ct) => 
                await dbContext
                    .Users
                    .FirstOrDefaultAsync(user => user.Id == id, ct));
        
        
        return entity == null 
            ? Result.Fail(new Error($"User {userId} not found")) 
            : Result.Ok(mapper.Map(entity));
    }

    public async Task<Result<User>> GetUserAsync(Email email)
    {
        var entity = await cache.GetOrCreateAsync(
            "user:email:" + email,
            state: email,
            async (id, ct) => await dbContext.Users.Where(user => user.Email == id)
                .FirstOrDefaultAsync(ct));


        if (entity == null)
        {
            logger.LogInformation("User with email {email} not found", email);
            return Result.Fail(new Error($"User with email {email} not found"));
        }

        var result = Result.Ok(mapper.Map(entity));
        return result;
    }
    public async Task<Result<User>> CreateUserAsync(Username username, Email email)
    {
        var id = await Nanoid.GenerateAsync(alphabet: Nanoid.Alphabets.LettersAndDigits, size: 6)!;
        
        var user = new UserEntity
        {
            Id = UserId.From(id),
            Username = username,
            Email = email
        };
        
        try
        {
            await dbContext.Users.AddAsync(user);
            await dbContext.SaveChangesAsync();
            await cache.SetAsync("user:id:" + user.Id, user);
            await cache.SetAsync("user:email:" + user.Email, user);
        }
        catch (Exception e)
        {
            logger.LogError("Error when creating user: {error}", e.Message);
            return Result.Fail(new Error("Failed to create user"));
        }
        
        return Result.Ok(mapper.Map(user));
    }

    public async Task<Result> UpdateUserAsync(UserId userId, Username? username = null, NotificationToken? notificationToken = null)
    {
        var userResult = await GetUserAsync(userId);
        if (userResult.IsFailed)
        {
            return Result.Fail(new Error($"User {userId} not found"));
        }

        var user = userResult.Value;
        if (username is not null)
            user.Username = username.Value;

        if (notificationToken is not null)
            user.NotificationToken = notificationToken.Value;
        
        
        try
        {
            await dbContext.Users
                .Where(u => u.Id == userId)
                .ExecuteUpdateAsync(calls => calls
                    .SetProperty(u => u.Username, username ?? user.Username)
                    .SetProperty(u => u.NotificationToken, notificationToken ?? user.NotificationToken));
            
            await cache.SetAsync("user:id:" + userId, user);
            await cache.SetAsync("user:email:" + user.Email, user);
        }
        catch (Exception e)
        { 
            logger.LogError("Error when updating user: {error}", e.Message);
            return Result.Fail(new Error("Failed to update user"));
        }
        
        return Result.Ok();
    }

    public async Task<Result> DeleteUserAsync(UserId userId)
    {
        var userResult = await GetUserAsync(userId);
        if (userResult.IsFailed)
        {
            return Result.Fail(new Error($"User {userId} not found"));
        }
        var user = userResult.Value;
        try
        {
            await dbContext.Users.Where(u => u.Id == userId).ExecuteDeleteAsync();
            await cache.RemoveAsync(["user:id:" + userId, "user:email:" + user.Email]);
        }
        catch (Exception e)
        {
            logger.LogError("Error when deleting user: {error}", e.Message);
            return Result.Fail(new Error("Failed to delete user"));
        }

        return Result.Ok();
    }
}