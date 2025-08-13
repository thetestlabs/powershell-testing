# MixedSeverity.ps1
# This file contains a mix of Error/Warning/Information level PSScriptAnalyzer rule violations
# Shows Error (red), Warning (orange), and Information (cyan) severity issues

# ====== ERROR SEVERITY ISSUES ======

# PSAvoidUsingPlainTextForPassword - Error severity
function Set-InsecureCredential {
    param(
        [string]$Username,
        [string]$Password # Should use SecureString - Error level
    )
    
    $credential = New-Object System.Management.Automation.PSCredential($Username, (ConvertTo-SecureString $Password -AsPlainText -Force))
    return $credential
}

# PSAvoidUsingInvokeExpression - Error severity
function Execute-Command {
    param([string]$Command)
    
    # Potential security risk - Error level
    $dangerousCommand = "Remove-Item C:\*"
    # Invoke-Expression $dangerousCommand  # Commented to prevent actual execution
    Invoke-Expression $Command
}

# PSAvoidUsingPositionalParameters - Error severity in strict environments
function Get-Files {
    # Using cmdlets with positional parameters - Error level
    Get-ChildItem "C:\Windows" -Recurse | Where-Object Length -gt 1MB
}

# ====== WARNING SEVERITY ISSUES ======

# PSAvoidUsingCmdletAliases - Warning severity
function Search-Files {
    # Using aliases instead of full cmdlet names - Warning level
    gci . -Recurse | ? Name -like "*.log" | % { $_.FullName }
}

# PSAvoidUsingWriteHost - Warning severity
function Display-Message {
    # Using Write-Host instead of proper output streams - Warning level
    Write-Host "This is a message" -ForegroundColor Green
}

# PSProvideCommentHelp - Warning severity
function Update-Configuration {
    # Missing comment-based help - Warning level
    param([string]$Path)
    
    # PSUseDeclaredVarsMoreThanAssignments - Warning level
    $unusedVariable = "Never used"
    
    # Function body
    $config = Get-Content $Path
    $config | Set-Content $Path
}

# PSUseConsistentIndentation - Warning severity
function Test-Indentation {
    param(
        [string]$Name
    )

    if ($Name) {
        Write-Output $Name
    }
    else {
        Write-Output "No name"
    }
}

# ====== INFORMATION SEVERITY ISSUES ======

# PSUseSingularNouns - Information severity
function Get-Users {
    # Using plural nouns in function names - Information level
    Get-LocalUser
}

# PSUseConsistentWhitespace - Information severity
function Test-SpacingIssues {
    $result = 1 + 2 # Inconsistent spacing around operators - Information level
    return$result
}

# PSUseCorrectCasing - Information severity
function test-incorrectcasing {
    # Incorrect casing in function name - Information level
    get-process | select-object name, id
}

# PSAvoidUsingDoubleQuotesForConstantString - Information severity
$greeting = "Hello" # Should use single quotes for constant strings - Information level

# PSPossibleIncorrectUsageOfAssignmentOperator - Information severity
$status = "Active"
if ($status = "Inactive") {
    Write-Output "User is inactive"
}

# Function without help documentation - Information severity
function Get-SystemData {
    Get-ComputerInfo
}
