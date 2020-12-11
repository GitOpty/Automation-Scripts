param(
    [Parameter(Mandatory)]
    [String]$tenant,
    [Parameter(Mandatory)]
    [String[]]$listTitles,
    [Parameter(Mandatory)]
    [String]$siteGroupName,
    [Parameter(Mandatory)]
    [String[]]$rolesToAdd,
    [Parameter(Mandatory)]
    [String[]]$rolesToRemove
)
$cred = Get-Credential
Connect-SPOService ("https://{0}-admin.sharepoint.com" -f $tenant) -Credential $cred
$sites = Get-SPOSite -Limit All
foreach ($site in $sites)
{
    Write-Host $site.Url
    $web = Get-PnPWeb -Connection (Connect-PnPOnline $site.Url -Credentials $cred -ReturnConnection)
        
    foreach ($listTitle in $listTitles)
    {
        $list = Get-PnPList $listTitle -Web $web
        if ($list -eq $null) {
            Write-Host "There is no library called" $listTitle
            continue 
        }
        Write-Host "Setting permissions for" $listTitle
        $list.BreakRoleInheritance($true, $true)
        $list.Update()
        $list.Context.Load($list)
        $list.Context.ExecuteQuery()
        $group = Get-SPOSiteGroup -Site $site | where {$_.Title -like ("*{0}" -f $siteGroupName) }
        foreach ($roleToAdd in $rolesToAdd) {
            Set-PnPGroupPermissions -Identity $group.Title -List $listTitle -AddRole $roleToAdd
        }
        foreach ($roleToRemove in $rolesToRemove) {
            Set-PnPGroupPermissions -Identity $group.Title -List $listTitle -RemoveRole $roleToRemove
        }
    }
}
Read-Host -Prompt "Press Enter to exit"