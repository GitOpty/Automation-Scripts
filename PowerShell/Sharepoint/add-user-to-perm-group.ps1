param(
    [Parameter(Mandatory)]
    [String]$siteUrl,
    [Parameter(Mandatory)]
    [String]$loginName,
    [Parameter(Mandatory)]
    [String]$siteGroupName # e.g. Owners, Members, Visitors
)
Connect-SPOService ("{0}-admin.sharepoint.com" -f ($siteUrl.Substring(0, $siteUrl.IndexOf(".sharepoint.com")))) -Credential (Get-Credential)
$group = Get-SPOSiteGroup -Site $siteUrl | where {$_.Title -like ("*{0}" -f $siteGroupName) }
Add-SPOUser -Site $siteUrl -LoginName $loginName -Group $group.Title
Read-Host -Prompt "Press Enter to exit"