using FluentResults;
using Photon.Backend.Database.Models.DTOs;
using Photon.Backend.VOs;

namespace Photon.Backend.Repositories;

public sealed class DbUserRepository : IUserRepository
{
    public Task<Result<User>> GetUserAsync(UserId userId)
    {
        return Task.FromResult(Result.Ok(new User()
        {
            Username = Username.From("clown"),

            Id = UserId.From("clowna"),
            Email = Email.From("example@example.com")
        }));
    }

    public Task<Result<User>> GetUserAsync(Email email)
    {

        return Task.FromResult(Result.Ok(new User()
        {
            Username = Username.From("clown"),

            Id = UserId.From("clowna"),
            Email = Email.From("example@example.com")
        }));
    }

    public Task<Result<User>> CreateUserAsync(Username username, Email email)
    {
        return Task.FromResult(Result.Ok(new User()
        {
            Username = Username.From("clown"),

            Id = UserId.From("clowna"),
            Email = Email.From("example@example.com")
        }));
    }

    public Task<Result> UpdateUserAsync(Username username)
    {
        return Task.FromResult(Result.Ok());
    }

    public Task<Result> DeleteUserAsync(UserId userId)
    {
        return Task.FromResult(Result.Ok());
    }
}