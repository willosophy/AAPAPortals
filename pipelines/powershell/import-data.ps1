

if (Get-Module -ListAvailable -Name SomeModule) {
    Write-Debug "Module exists"
    Import-Module Microsoft.Xrm.Data.PowerShell
} 
else {
    Write-Debug "Module does not exist"
    Install-Module Microsoft.Xrm.Data.PowerShell -Force
    Import-Module Microsoft.Xrm.Data.PowerShell
}