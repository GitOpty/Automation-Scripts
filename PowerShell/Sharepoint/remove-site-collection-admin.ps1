param(
    [Parameter(Mandatory)]
    [String]$siteUrl,
    [Parameter(Mandatory)]
    [String]$loginName
)
Remove-PnPSiteCollectionAdmin -Owners $loginName -Connection (Connect-PnPOnline $siteUrl -Credentials (Get-Credential) -ReturnConnection)
$obj = New-Object PSObject
$obj | Add-Member "SiteUrl" $siteUrl
$obj | Add-Member "LoginName" $loginName
$obj | Add-Member "IsSiteAdmin" (Get-SPOUser -Site $siteUrl -LoginName $loginName | select IsSiteAdmin).IsSiteAdmin
 
$obj | out-host
Read-Host -Prompt "Press Enter to exit"