param(
    [Parameter(Mandatory)]
    [String]$siteUrl
)
Connect-SPOService ("{0}-admin.sharepoint.com" -f ($siteUrl.Substring(0, $siteUrl.IndexOf(".sharepoint.com")))) -Credential (Get-Credential)
Get-SPOSite $siteUrl | select *
Read-Host -Prompt "Press Enter to exit"