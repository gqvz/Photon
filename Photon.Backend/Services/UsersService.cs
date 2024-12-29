using System.Security.Claims;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using Microsoft.AspNetCore.Authorization;
using Photon.Backend.Protos;
using Photon.Backend.Repositories;
using Photon.Backend.VOs;

namespace Photon.Backend.Services;

[Authorize]
public class UsersService(
    IUserRepository userRepository
    ) : Users.UsersBase
{
    public override async Task<User> Me(Empty request, ServerCallContext context)
    {
        var claims = context.GetHttpContext().User.Claims;
        var userId = claims.First(x => x.Type == ClaimTypes.NameIdentifier).Value;
        var userIdVo = UserId.From(userId);
        var userResult = await userRepository.GetUserAsync(userIdVo);
        if (!userResult.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.NotFound, userResult.Errors
                .Select(e => e.Message)
                .Aggregate((x, y) => $"{x}\n{y}")));
        }
        var user = userResult.Value;
        
        return new User
        {
            Email = user.Email.Value,
            Name = user.Username.Value,
            Id = user.Id.Value
        };
    }

    public override async Task<Empty> UpdateUsername(UpdateUsernameRequest request, ServerCallContext context)
    {
        var claims = context.GetHttpContext().User.Claims;
        var userId = claims.First(x => x.Type == ClaimTypes.NameIdentifier).Value;
        var userIdVo = UserId.From(userId);
        var username = Username.From(request.Name);
        var result = await userRepository.UpdateUserAsync(userIdVo, username);
        if (!result.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.Internal, result.Errors
                .Select(e => e.Message)
                .Aggregate((x, y) => $"{x}\n{y}")));
        }

        return new Empty();
    }

    public override async Task<User> GetUser(GetUserRequest request, ServerCallContext context)
    {
        var userId = UserId.From(request.Id);
        var userResult = await userRepository.GetUserAsync(userId);
        if (!userResult.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.NotFound, userResult.Errors
                .Select(e => e.Message)
                .Aggregate((x, y) => $"{x}\n{y}")));
        }
        
        var user = userResult.Value;
        return new User
        {
            Email = "hidden",
            Name = user.Username.Value,
            Id = user.Id.Value
        };
    }

    public override async Task<Empty> UpdateFCMToken(UpdateFCMTokenRequest request, ServerCallContext context)
    {
        Console.WriteLine(request.Token);
        var claims = context.GetHttpContext().User.Claims;
        var userId = claims.First(x => x.Type == ClaimTypes.NameIdentifier).Value;
        var userIdVo = UserId.From(userId);
        
        var token = NotificationToken.From(request.Token);
        var result = await userRepository.UpdateUserAsync(userIdVo, notificationToken: token);
        if (!result.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.Internal, result.Errors
                .Select(e => e.Message)
                .Aggregate((x, y) => $"{x}\n{y}")));
        }

        return new Empty();
    }
}