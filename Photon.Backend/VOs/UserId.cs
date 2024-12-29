using Vogen;

namespace Photon.Backend.VOs;

[ValueObject<string>(Conversions.EfCoreValueConverter | Conversions.SystemTextJson)]
public readonly partial struct UserId
{
    private static Validation Validate(string input)
    {
        var isValid = input.Length == 6 && input.All(char.IsLetterOrDigit);
        return isValid ? Validation.Ok : Validation.Invalid("UserId must be 6 characters long.");
    }
    
    private static string NormalizeInput(string input) => input.Trim();
}