# SecurityIssues.ps1
# This file contains security-related PSScriptAnalyzer rule violations
# Focus on Security-specific rules defined in py-psscriptanalyzer constants.py

# PSAvoidUsingPlainTextForPassword - Using plain text passwords
function Set-Credentials {
    param(
        [string]$Username,
        [string]$Password # Should use SecureString
    )
    
    # PSAvoidUsingConvertToSecureStringWithPlainText - Plain text conversion is insecure
    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($Username, $securePassword)
    
    # Return credential object
    return $credential
}

# PSAvoidUsingUserNameAndPasswordParams - Should use PSCredential instead
function Connect-RemoteServer {
    param(
        [string]$ComputerName,
        [string]$UserName, # Should use PSCredential type
        [string]$Password  # Should use PSCredential type
    )
    
    # PSAvoidUsingInvokeExpression - Poses security risks with dynamic code
    $command = "Enter-PSSession -ComputerName $ComputerName -Credential (New-Object PSCredential('$UserName', (ConvertTo-SecureString '$Password' -AsPlainText -Force)))"
    Invoke-Expression $command
}

# PSUsePSCredentialType - Should use PSCredential instead of username/password
function Connect-Database {
    param(
        [string]$ServerName,
        [string]$Username,   # Should use PSCredential
        [string]$Password    # Should use PSCredential
    )
    
    # Connect to database using username and password
    $connectionString = "Server=$ServerName;User ID=$Username;Password=$Password"
    
    # Using the connection string
    Write-Output "Connecting with: $connectionString"
}

# PSAvoidUsingComputerNameHardcoded - Avoid hardcoding computer names
function Get-RemoteLogs {
    # Hardcoded computer name
    $server = "PRODSERVER01"
    
    # Get logs from server
    Get-EventLog -LogName System -ComputerName $server
}

# PSAvoidUsingUnencryptedNetworkResources - Avoid using unencrypted network resources
function Download-Content {
    # Using unencrypted HTTP instead of HTTPS
    $webClient = New-Object System.Net.WebClient
    $content = $webClient.DownloadString("http://example.com/data.txt")
    
    return $content
}

# PSAvoidUsingBrokenHashAlgorithms - Avoid using broken hash algorithms
function Get-FileHash {
    param(
        [string]$FilePath,
        [string]$Algorithm = "MD5" # MD5 is considered broken/weak
    )
    
    # Using potentially broken hash algorithm
    $hashValue = Get-FileHash -Path $FilePath -Algorithm $Algorithm
    return $hashValue
}

# PSAvoidGlobalAliases - Global aliases should be avoided
New-Alias -Name "gh" -Value Get-Help -Scope Global

# PSAvoidGlobalFunctions - Global functions should be avoided
function global:Get-GlobalData {
    # Function with global scope
    Get-ChildItem -Path "C:\Data"
}

# UseProcessBlockForPipelineCommand - Missing process block
function Format-Output {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]$InputData
    )
    
    # Missing process block
    # Should use: process { ... }
    
    return "Processed: $InputData"
}
