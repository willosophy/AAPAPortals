# Update solution version to current date and time
[CmdletBinding()]
param (
    [String]$solutionXmlFullPath,
    [String]$versionNumber
)

Write-Host "File path: $solutionXmlFullPath"
$isValidPath = Test-Path -Path $solutionXmlFullPath

Write-Host "Is valid path: $isValidPath"

[xml]$xml = Get-Content $solutionXmlFullPath

if (-not ([string]::IsNullOrEmpty($versionNumber)))
{
    Write-Host "Custom verion set to: $versionNumber"
    $xml.ImportExportXml.SolutionManifest.Version = $versionNumber
} else {
    $version = [string](get-date -Format yyyy.MM.dd.HHmmss)
    Write-Host "Verion will be: $version"
    $xml.ImportExportXml.SolutionManifest.Version = $version
}

$xml.Save($solutionXmlFullPath)