param(
    [Parameter(Mandatory)]
    [String]$tenant,
    [Parameter(Mandatory)]
    [String]$hideThemes
)
switch ($hideThemes)
{
    "true" { $hide = $true }
    "false" { $hide = $false }
}
Connect-SPOService ("https://{0}-admin.sharepoint.com" -f $tenant) -Credential (Get-Credential)
Set-SPOHideDefaultThemes -HideDefaultThemes:$hide
if (Get-SPOHideDefaultThemes) {
    Write-Host "Default themes are now hidden."
}
else {
    Write-Host "Default themes are now visible."
}
Read-Host -Prompt "Press Enter to exit"