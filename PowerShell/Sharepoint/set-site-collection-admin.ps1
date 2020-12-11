param(
    [Parameter(Mandatory)]
    [String]$siteUrl,
    [Parameter(Mandatory)]
    [String]$loginName
)
Connect-SPOService ("{0}-admin.sharepoint.com" -f ($siteUrl.Substring(0, $siteUrl.IndexOf(".sharepoint.com")))) -Credential (Get-Credential)
$supress = Set-SPOUser -Site $siteUrl -LoginName $loginName -IsSiteCollectionAdmin $true
$obj = New-Object PSObject
$obj | Add-Member "SiteUrl" $siteUrl
$obj | Add-Member "LoginName" $loginName
$obj | Add-Member "IsSiteAdmin" (Get-SPOUser -Site $siteUrl -LoginName $loginName | select IsSiteAdmin).IsSiteAdmin
 
$obj | out-host
Read-Host -Prompt "Press Enter to exit"