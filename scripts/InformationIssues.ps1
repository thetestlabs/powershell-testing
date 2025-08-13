# InformationIssues.ps1
# This file contains PSScriptAnalyzer rule violations that typically result in Information level messages
# These are style issues rather than security or functional problems

# PSProvideCommentHelp - Function without comment-based help (can be Information level)
function Get-ServerInfo {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,
        [string]$LogPath = "C:\Logs"
    )
    
    # PSUseCorrectCasing - Incorrect cmdlet casing
    get-computerinfo -ComputerName $ComputerName
    write-output "Server information retrieved"
    set-location $LogPath
}

# PSAvoidUsingDoubleQuotesForConstantString - Information
function Test-StringQuotes {
    $greeting = "Hello" # Should use single quotes for constant string
    $name = "World" # Should use single quotes for constant string
    $message = "Welcome" # Should use single quotes for constant string
    $status = "Active" # Should use single quotes for constant string
    
    return $message
}

# PSUseConsistentWhitespace - Information
function Test-Spacing {
    # Missing space after function name and opening brace
    
    # Inconsistent spaces around operators
    $result = 1 + 2 - 3 + 4
    
    if ($result -gt 0) {
        # Missing spaces in conditional
        return$result # Missing space after return keyword
    }
}

# PSPossibleIncorrectUsageOfAssignmentOperator - Assignment instead of comparison
function Test-AssignmentOperator {
    param([string]$UserName)
    
    # This should be -eq for comparison, not =
    if ($UserName = "admin") {
        Write-Output "Admin user detected"
    }
    
    # Another example with assignment operator
    $Status = "Stopped"
    if ($Status = "Running") {
        Write-Output "Service is running"
    }
}

# PSAvoidTrailingWhitespace - Lines with trailing spaces (added intentionally)
function Test-TrailingSpaces {
    $data = "sample"    
    $info = "information"   
    $result = "output"     
}

# PSUseConsistentIndentation - Information
function Test-Indentation {
    param(
        [string]$Name,
        [int]$Value
    ) # Inconsistent parameter indentation
    
    if ($Name) {
        Write-Output $Name # Inconsistent indentation
    }
    else {
        Write-Output "No name"
    }
}

# PSUseCorrectCasing - Information level
function incorrect-casing {
    # Cmdlet names should use proper Pascal casing
    foreach ($item in get-childitem) {
        write-verbose $item.Name
        start-process $item.FullName
    }
}

# PSUseSingularNouns - Information level
function Get-Users {
    # Function name uses plural noun
    return Get-LocalUser
}

# PSAlignAssignmentStatement - Information
function Test-Alignment {
    $short = "Short value"
    $veryLongVariableName = "Long value" # These should be aligned
    $number = 42
    $anotherLongVariableName = 100 # These should be aligned
}

# PSPlaceCloseBrace - Information
function Test-BracePlacement {
    if ($true) {
        # Code
    }
    else {
        # Else on same line as closing brace
    }
}

# PSAvoidSemicolonsAsLineTerminators - Information
function Test-Semicolons {
    $var = "value"; # Unnecessary semicolon
    Get-Process; # Unnecessary semicolon
    Write-Output $var;
}

# PSProvideCommentHelp - Another function without help
function Start-BackgroundTask {
    param([scriptblock]$ScriptBlock)
    
    Start-Job -ScriptBlock $ScriptBlock
}

# Lines with trailing whitespace (Information-level issue)
$global:config = @{
    Server   = "localhost"    
    Database = "TestDB"   
    Timeout  = 30     
}
