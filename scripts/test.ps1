# Bad example with multiple issues
function Get-Users {
    param(
        [string]$Password
    )
    
    # Using alias instead of full cmdlet
    ls C:\Users | where Name -like "*test*"
    
    # Hardcoded credential (security issue)
    $cred = New-Object PSCredential("admin", (ConvertTo-SecureString "password123" -AsPlainText -Force))
    
    # Missing help documentation
    Write-Host "Getting users..."
}