using System.Text.RegularExpressions;
using Vogen;

namespace Photon.Backend.VOs;

[ValueObject<string>(Conversions.EfCoreValueConverter | Conversions.SystemTextJson)]
public readonly partial struct Email
{
    public static readonly Regex EmailRegex = MyRegex();
    private static Validation Validate(string input)
    {
        // why am i validating the email if im getting them from legit sources??
        var isValid = EmailRegex.IsMatch(input);
        return isValid ? Validation.Ok : Validation.Invalid("[todo: describe the validation]");
    }
    private static string NormalizeInput(string input) => input.Trim();
    
    
    [GeneratedRegex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", RegexOptions.Compiled)]
    private static partial Regex MyRegex();
}