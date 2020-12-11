param(
    [Parameter(Mandatory)]
    [String]$tenant
)
Connect-SPOService ("https://{0}-admin.sharepoint.com" -f $tenant) -Credential (Get-Credential)
$themes = Get-SPOTheme
foreach ($theme in $themes) {
    Remove-SPOTheme -name $theme.Name
}
Read-Host -Prompt "Press Enter to exit"