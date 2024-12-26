using System.ComponentModel.DataAnnotations;
using Photon.Backend.VOs;
using Riok.Mapperly.Abstractions;

namespace Photon.Backend.Database.Models;

public sealed class UserEntity
{
    [Key]
    [MapperIgnore]
    public ulong DbId { get; set; }
    
    public required UserId Id { get; set; }
    
    public required Username Username { get; set; }
    
    public required Email Email { get; set; }
}