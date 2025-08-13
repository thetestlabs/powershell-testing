# ConfigurationIssues.ps1
# This file demonstrates issues with DSC configurations and PowerShell workflows
# Focused on PSDSCRule violations from py-psscriptanalyzer constants.py

# PSDSCDscExamplesPresent - Missing DSC examples
# PSDSCDscTestsPresent - Missing DSC tests
# Configuration missing proper documentation
configuration BadWebServerConfig {
    param(
        [string]$ServerName,
        [string]$AdminPassword = "PlainTextPassword123!"  # PSAvoidUsingPlainTextForPassword
    )
    
    # PSUseDeclaredVarsMoreThanAssignments
    $unusedConfigVar = "This is never used"
    
    Node $ServerName {
        # PSDSCUseVerboseMessageInDSCResource - Missing verbose messages
        WindowsFeature IIS {
            Ensure = "Present"
            Name = "IIS-WebServerRole"
        }
        
        # Missing DependsOn relationship
        File WebContent {
            DestinationPath = "C:\inetpub\wwwroot\index.html"
            Contents = "<html><body>Hello World</body></html>"
            Ensure = "Present"
            # Missing DependsOn = "[WindowsFeature]IIS"
        }
        
        # PSAvoidUsingComputerNameHardcoded
        Registry DisableUAC {
            Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            ValueName = "EnableLUA"
            ValueData = "0"
            ValueType = "DWORD"
            Ensure = "Present"
        }
    }
}

# PSDSCStandardDSCFunctionsInResource - Missing standard DSC functions
# Missing Get/Set/Test-TargetResource functions
function MyCustomDSCResource {
    param(
        [string]$Name
    )
    
    # Missing standard DSC functions
    # Should have:
    # - Get-TargetResource
    # - Set-TargetResource
    # - Test-TargetResource
}

# PSDSCReturnCorrectTypesForDSCFunctions - Incorrect return types
function Get-TargetResource {
    param(
        [parameter(Mandatory = $true)]
        [String]$Name
    )
    
    # Should return a hashtable but returns a string
    return "Resource State"
}

# PSDSCUseIdenticalParametersForDSC - Inconsistent parameters
function Get-TargetResourceParams {
    param(
        [parameter(Mandatory = $true)]
        [String]$Name,
        [String]$Path
    )
    
    return @{
        Name = $Name
        Path = $Path
    }
}

function Set-TargetResourceParams {
    param(
        [parameter(Mandatory = $true)]
        [String]$Name
        # Missing [String]$Path parameter that's in Get-TargetResource
    )
    
    # Implementation
}

# PSDSCUseIdenticalMandatoryParametersForDSC - Inconsistent mandatory parameters
function Get-TargetResourceMandatory {
    param(
        [parameter(Mandatory = $true)]
        [String]$Name,
        [parameter(Mandatory = $true)]
        [String]$Path
    )
    
    return @{
        Name = $Name
        Path = $Path
    }
}

function Set-TargetResourceMandatory {
    param(
        [parameter(Mandatory = $true)]
        [String]$Name,
        [parameter(Mandatory = $false)] # Should be Mandatory=$true to match Get function
        [String]$Path
    )
    
    # Implementation
}
    
foreach -parallel ($computer in $ComputerNames) {
    # PSAvoidUsingInvokeExpression in workflow
    $command = "Get-Service -ComputerName $computer"
    InlineScript {
        Invoke-Expression $using:command
    }
        
    # PSAvoidUsingCmdletAliases in workflow
    InlineScript {
        ps | where { $_.ProcessName -like "w*" } | select Name, CPU
    }
}
    
# PSAvoidUsingClearHost
InlineScript {
    Clear-Host
}
}

# Script with configuration data issues
$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName      = "SERVER01"  # PSAvoidUsingComputerNameHardcoded
            Role          = "WebServer"
            
            # PSAvoidUsingPlainTextForPassword in configuration data
            AdminPassword = "AnotherPlainTextPassword"
            
            # PSUseSecureConnectionForWinRM - insecure settings
            WinRMPort     = 5985  # Should use 5986 for HTTPS
            UseSSL        = $false
        },
        @{
            NodeName        = "SERVER02"
            Role            = "DatabaseServer"
            
            # Missing proper certificate thumbprint
            CertificateFile = "C:\cert.cer"  # Plain text certificate path
        }
    )
}

# Function to apply configuration with issues
function Start-BadConfiguration {
    [CmdletBinding()]
    param(
        [string]$ConfigName,
        [string]$OutputPath = "C:\DSC"  # PSAvoidUsingComputerNameHardcoded path
    )
    
    # PSUseShouldProcessForStateChangingFunctions
    BadWebServerConfig -ConfigurationData $ConfigurationData -OutputPath $OutputPath
    
    # PSAvoidUsingInvokeExpression for DSC
    $mofFiles = Get-ChildItem -Path $OutputPath -Filter "*.mof"
    foreach ($mof in $mofFiles) {
        # PSAvoidUsingPositionalParameters
        Start-DscConfiguration $OutputPath -Wait -Verbose -Force
    }
    
    # PSAvoidUsingWriteHost
    Write-Host "Configuration applied successfully" -ForegroundColor Green
}

# PowerShell Desired State Configuration with authentication issues
configuration BadSecurityConfig {
    param(
        [PSCredential]$Credential
    )
    
    # PSReviewUnusedParameter - Credential parameter defined but not used
    
    Node "localhost" {
        # PSAvoidUsingPlainTextForPassword equivalent
        User LocalAdmin {
            UserName = "LocalAdmin"
            Password = "PlainPassword123!"  # Should use PSCredential
            Ensure = "Present"
            PasswordNeverExpires = $true
        }
        
        # PSAvoidUsingDeprecatedManifestFields equivalent
        Service Spooler {
            Name = "Spooler"
            State = "Running"
            StartupType = "Automatic"
            # Missing dependencies or proper configuration
        }
    }
}

# Invoke configurations with issues
try {
    # PSAvoidUsingCmdletAliases
    $servers = @("SERVER01", "SERVER02") | foreach { $_ }
    
    # PSMisleadingBacktick
    Start-BadConfiguration `
        -ConfigName "WebServer" `
        -OutputPath "C:\DSC\Output"
    
    # PSUseLiteralInitializerForHashtable - inefficient hashtable creation
    $configParams = New-Object hashtable
    $configParams.Add("ConfigName", "Security")
    $configParams.Add("OutputPath", "C:\DSC\Security")
}
catch {
    # PSAvoidUsingEmptyCatchBlock
    Write-Error "Configuration failed"
    throw
}

# Export configuration functions
Export-ModuleMember -Function Start-BadConfiguration
