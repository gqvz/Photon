using Photon.Backend.VOs;

namespace Photon.Backend.Database.Models.DTOs;

public sealed class User
{
    public UserId Id { get; set; }
    
    public Username Username { get; set; }
    
    public Email Email { get; set; }
}