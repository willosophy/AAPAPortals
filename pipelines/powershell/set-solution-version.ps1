# Update solution version to current date and time
[CmdletBinding()]
param (
    $solutionXmlFullPath
)

[xml]$xml = Get-Content $solutionXmlFullPath
$myXml.ImportExportXml.SolutionManifest.Version = [string](get-date -Format yyyy.MM.dd.HHmmss)
$myXml.Save($solutionXmlFullPath)