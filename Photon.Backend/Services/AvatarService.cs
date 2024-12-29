using System.Security.Claims;
using Google.Protobuf;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using Microsoft.AspNetCore.Authorization;
using Photon.Backend.Protos;
using Photon.Backend.Repositories;
using Photon.Backend.VOs;

namespace Photon.Backend.Services;

public sealed class AvatarService(IAvatarRepository avatarRepository) : Avatars.AvatarsBase
{
    public override async Task Get(GetAvatarRequest request, IServerStreamWriter<ImageData> responseStream, ServerCallContext context)
    {
        var userId = request.Id;
        var bytesResult = await avatarRepository.GetAvatarAsync(UserId.From(userId));
        if (!bytesResult.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.NotFound, bytesResult.Errors
                .Select(e => e.Message)
                .Aggregate((x, y) => $"{x}\n{y}")));
        }
        
        var bytes = bytesResult.Value;
        Console.WriteLine(bytes.Length);
        var chunkSize = 1024;
        for (var i = 0; i < bytes.Length; i += chunkSize)
        {
            var chunk = bytes[i..Math.Min(i + chunkSize, bytes.Length)];
            await responseStream.WriteAsync(new ImageData { Data = ByteString.CopyFrom(chunk) });
        }
    }

    [Authorize]
    public override async Task<Empty> Set(IAsyncStreamReader<ImageData> requestStream, ServerCallContext context)
    {
        var userId = context.GetHttpContext().User.Claims.First(x => x.Type == ClaimTypes.NameIdentifier).Value;
        var userIdVo = UserId.From(userId);
        var bytes = new List<byte>();
        await foreach (var data in requestStream.ReadAllAsync())
        {
            bytes.AddRange(data.Data.ToByteArray());
        }
        
        var result = await avatarRepository.SetAvatarAsync(userIdVo, bytes.ToArray());
        if (!result.IsSuccess)
        {
            throw new RpcException(new Status(StatusCode.Internal, result.Errors
                .Select(e => e.Message)
                .Aggregate((x, y) => $"{x}\n{y}")));
        }

        return new Empty();
    }
}