using Vogen;

namespace Photon.Backend.VOs;

[ValueObject<string>(Conversions.EfCoreValueConverter | Conversions.SystemTextJson)]
public readonly partial struct NotificationToken
{
    private static Validation Validate(string input)
    {
        var isValid = input.All(ch => char.IsLetterOrDigit(ch) || ch is '-' or '_' or '.' or ' ' or ':');
        return isValid ? Validation.Ok : Validation.Invalid("NotificationToken must contain only characters, digits, '_', '-' ':' or '.'.");
    }
    private static string NormalizeInput(string input) => input.Trim();
}