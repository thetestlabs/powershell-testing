# PowerShell Testing Repository

This repository contains PowerShell scripts and modules with **intentional errors** designed to test the PSScriptAnalyzer pre-commit hook.

## Purpose

This repository serves as a comprehensive test suite for the [psscriptanalyzer-pre-commit](https://github.com/thetestlabs/psscriptanalyzer-pre-commit) hook, containing examples of various PSScriptAnalyzer rule violations.

## Structure

```
powershell-testing/
├── scripts/
│   ├── BadScript.ps1           # Variable, naming, and basic issues
│   ├── AdvancedIssues.ps1      # Advanced functions and DSC issues  
│   └── ConfigurationIssues.ps1 # DSC configurations and workflows
├── modules/
│   ├── BadModule.psm1          # Security and performance issues
│   └── BadModule.psd1          # Module manifest issues
├── functions/
│   └── BadFunctions.psm1       # Parameter and pipeline issues
└── classes/
    └── BadClasses.ps1          # PowerShell class design issues
```

## PSScriptAnalyzer Rules Covered

This test repository includes violations for the following categories of PSScriptAnalyzer rules:

### Security Issues

- PSAvoidUsingPlainTextForPassword
- PSAvoidUsingConvertToSecureStringWithPlainText
- PSAvoidUsingUserNameAndPasswordParams
- PSUsePSCredentialType
- PSAvoidUsingBrokenHashAlgorithms

### Performance Issues

- PSAvoidUsingInvokeExpression
- PSAvoidUsingWMICmdlets
- PSUseLiteralInitializerForHashtable
- PSUsePipelineForOutput

### Best Practices

- PSUseApprovedVerbs
- PSUseSingularNouns
- PSProvideCommentHelp
- PSUseShouldProcessForStateChangingFunctions
- PSUseVerboseNameForParameter
- PSUseCorrectCasing

### Code Style

- PSUseConsistentIndentation
- PSUseConsistentWhitespace
- PSAvoidLongLines
- PSAvoidTrailingWhitespace
- PSAlignAssignmentStatement
- PSAvoidUsingDoubleQuotesForConstantString

### Variable Usage

- PSUseDeclaredVarsMoreThanAssignments
- PSReviewUnusedParameter
- PSAvoidGlobalVars
- PSAvoidAssignmentToAutomaticVariable

### Cmdlet Usage

- PSAvoidUsingCmdletAliases
- PSAvoidUsingPositionalParameters
- PSAvoidUsingWriteHost
- PSAvoidUsingClearHost
- PSUseCompatibleCmdlets

### Error Handling

- PSAvoidUsingEmptyCatchBlock
- PSUseCmdletCorrectly

### Naming and Parameters

- PSReservedParams
- PSAvoidDefaultValueSwitchParameter
- PSUseOutputTypeCorrectly

### DSC Specific

- PSUseIdenticalMandatoryParametersForDSC
- PSDSCReturnCorrectTypesForDSCFunctions

### Module Manifest

- PSMissingModuleManifestField
- PSAvoidUsingDeprecatedManifestFields
- PSUseToExportFieldsInManifest

### Miscellaneous

- PSMisleadingBacktick
- PSAvoidUsingComputerNameHardcoded
- PSUseBOMForUnicodeEncodedFile

## Testing the Pre-commit Hook

1. Install the pre-commit hook:

   ```bash
   pre-commit install
   ```

2. Run against all files:

   ```bash
   pre-commit run --all-files
   ```

3. Test specific severity levels:

   ```bash
   pre-commit run psscriptanalyzer --all-files
   ```

4. Test formatting:

   ```bash
   pre-commit run psscriptanalyzer-format --all-files
   ```

## GitHub Actions Testing

This repository includes comprehensive CI/CD testing via GitHub Actions (`.github/workflows/test-pre-commit.yml`) that validates the pre-commit hooks across:

- **Operating Systems**: Windows, macOS, Linux
- **Python Versions**: 3.9, 3.10, 3.11, 3.12, 3.13
- **PowerShell Variants**: PowerShell Core, Windows PowerShell, Homebrew installations

The workflow includes:

- **Matrix testing** across all OS/Python combinations
- **Hook isolation testing** to test individual hooks separately
- **PowerShell executable detection testing** to verify cross-platform compatibility
- **Compatibility reporting** with automated troubleshooting guidance

## Troubleshooting

If you encounter assembly loading errors like:

```text
System.IO.FileLoadException: The given assembly name was invalid.
File name: 'System.Runtime.Numerics, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11ﾠ'
```

This indicates a .NET runtime compatibility issue. Try these solutions:

1. **Update PowerShell**:
   - macOS: `brew upgrade powershell`
   - Linux: Follow [PowerShell installation guide](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux)
   - Windows: Update via Microsoft Store or download latest release

2. **Reinstall PSScriptAnalyzer**:

   ```bash
   pwsh -c 'Uninstall-Module PSScriptAnalyzer -Force; Install-Module PSScriptAnalyzer -Force'
   ```

3. **Clear PowerShell module cache**:

   ```bash
   # macOS/Linux
   rm -rf ~/.local/share/powershell/Modules/PSScriptAnalyzer
   
   # Windows
   Remove-Item -Path "$env:USERPROFILE\.local\share\powershell\Modules\PSScriptAnalyzer" -Recurse -Force
   ```

4. **Check .NET compatibility**:

   ```bash
   pwsh -c '[System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription'
   ```

## Expected Behavior

When you run PSScriptAnalyzer against these files, you should see:

- **Errors**: Critical issues that could cause runtime failures
- **Warnings**: Code that violates best practices or could cause issues
- **Information**: Style suggestions and minor improvements

The files are designed to trigger multiple rules simultaneously to provide comprehensive testing coverage.

## Usage Notes

⚠️ **Warning**: These files contain intentionally bad PowerShell code and should **never** be used in production environments. They are for testing purposes only.

## File Descriptions

- **BadScript.ps1**: Basic script issues including variable usage, naming conventions, and deprecated cmdlets
- **AdvancedIssues.ps1**: Advanced function features, DSC resources, and complex parameter scenarios  
- **ConfigurationIssues.ps1**: DSC configurations, workflows, and configuration data problems
- **BadModule.psm1**: Module-specific issues including security vulnerabilities and performance problems
- **BadModule.psd1**: Module manifest with missing fields and deprecated settings
- **BadFunctions.psm1**: Function design issues, parameter problems, and pipeline misuse
- **BadClasses.ps1**: PowerShell class design violations and object-oriented programming issues
