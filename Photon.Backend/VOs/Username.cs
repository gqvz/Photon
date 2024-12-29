using Vogen;

namespace Photon.Backend.VOs;

[ValueObject<string>(Conversions.EfCoreValueConverter | Conversions.SystemTextJson)]
public readonly partial struct Username
{
    private static Validation Validate(string input)
    {
        var isValid = input.Length is > 0 and < 33 && input.All(ch => char.IsLetterOrDigit(ch) || ch is '-' or '_' or '.' or ' ');
        return isValid ? Validation.Ok : Validation.Invalid("Username must be between 1 and 32 characters long and contain only characters, digits, '_', '-' or '.'.");
    }
    private static string NormalizeInput(string input) => input.Trim();
}