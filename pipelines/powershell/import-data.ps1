[CmdletBinding()]
param (
    $serverUrl,
    $userName,
    $userPassword,
    $dataFile
)

Write-Host "Importing data from $($dataFile) to $($serverUrl)"

if (Get-Module -ListAvailable -Name Microsoft.Xrm.Data.PowerShell ) {
    Write-Host "Microsoft.Xrm.Data.PowerShell module exists skipping install."
    Import-Module Microsoft.Xrm.Data.PowerShell -Force
} 
else {
    Write-Host "Microsoft.Xrm.Data.PowerShell module does not exist installing now."
    Install-Module Microsoft.Xrm.Data.PowerShell -Force 
    Import-Module Microsoft.Xrm.Data.PowerShell -Force 
}

if (Get-Module -ListAvailable -Name Microsoft.Xrm.Tooling.ConfigurationMigration ) {
    Write-Host "Microsoft.Xrm.Tooling.ConfigurationMigration module exists skipping install."
    Import-Module Microsoft.Xrm.Tooling.ConfigurationMigration -Force 
} 
else {
    Write-Host "Microsoft.Xrm.Tooling.ConfigurationMigration module does not exist installing now."
    Install-Module -Name Microsoft.Xrm.Tooling.ConfigurationMigration -Force
    Import-Module Microsoft.Xrm.Tooling.ConfigurationMigration -Force
}

# Convert to SecureString
#[securestring]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force
[pscredential] $credOject = New-Object System.Management.Automation.PSCredential ($userName, (ConvertTo-SecureString $userPassword -AsPlainText -Force)) -Verbose

$connection = Connect-CrmOnline -ServerUrl $serverUrl -Credential $credOject
Write-Host "Now connected to $($connection.ConnectedOrgFriendlyName)"

Write-Host "Beginning data import..."
Import-CrmDataFile -CrmConnection $connection -DataFile $dataFile -Verbose
