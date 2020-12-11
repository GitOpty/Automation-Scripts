param(
    [Parameter(Mandatory)]
    [String]$siteUrl,
    [Parameter(Mandatory)]
    [String]$fileName
)
Connect-PnPOnline -Url $siteUrl -Credentials (Get-Credential)
Get-PnPProvisioningTemplate -Out ("{0}\{1}.xml"-f $PSScriptRoot, $fileName)
Read-Host -Prompt "Press Enter to exit"