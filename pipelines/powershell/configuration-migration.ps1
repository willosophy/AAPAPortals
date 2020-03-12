[CmdletBinding()]
param (
    [Parameter(Mandatory = $True)]
    [String]$serverUrl,
    [Parameter(Mandatory = $True)]
    [String]$userName,
    [Parameter(Mandatory = $True)]
    [String]$userPassword,

    [Parameter(Mandatory = $True)]
    #[ValidateScript( { [System.IO.Path]::IsPathRooted($_) })]
    [String]$dataFile,

    [Parameter(Mandatory = $false)]
    #[ValidateScript( { [System.IO.Path]::IsPathRooted($_) })]
    [String]$schemaFile = $null
)

if ([string]::IsNullOrEmpty($schemaFile)) {
    Write-Host "Importing data from $($dataFile) to $($serverUrl)" 
}
else {
    Write-Host "Exporting data from $($dataFile) to $($serverUrl)"
}

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

if ([string]::IsNullOrEmpty($schemaFile)) {
    Write-Host "Beginning data import..."
    Import-CrmDataFile -CrmConnection $connection -DataFile $dataFile -Verbose
}
else {
    Write-Host "Beginning data export..."
    Export-CrmDataFile -CrmConnection $connection -DataFile $dataFile -Verbose -SchemaFile $schemaFile -EmitLogToConsole
}


