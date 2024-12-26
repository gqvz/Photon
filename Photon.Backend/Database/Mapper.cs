using Photon.Backend.Database.Models;
using Photon.Backend.Database.Models.DTOs;
using Riok.Mapperly.Abstractions;

namespace Photon.Backend.Database;

[Mapper]
public partial class Mapper
{
    public partial User Map(UserEntity entity);
    public partial UserEntity Map(User dto);
}