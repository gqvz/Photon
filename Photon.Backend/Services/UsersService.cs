using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using Microsoft.AspNetCore.Authorization;
using Photon.Backend.Protos;

namespace Photon.Backend.Services;

[Authorize]
public class UsersService : Users.UsersBase
{
    public override Task<User> Me(Empty request, ServerCallContext context)
    {
        return Task.FromResult(new User
        {
            Id = "real",
            Name = "real",
            Email = "real"
        });
    }
}