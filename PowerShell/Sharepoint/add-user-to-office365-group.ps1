param(
    [Parameter(Mandatory)]
    [String]$siteUrl,
    [Parameter(Mandatory)]
    [String]$loginName,
    [Parameter(Mandatory)]
    [String]$membershipType #e.g. Owner or Member
)
$cred = Get-Credential
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $session
Connect-PnPOnline $siteUrl -Credentials $cred
$groupId = (Get-PnPSite -Includes GroupId).GroupId.ToString()
# Owners also need to be members
if ($membershipType.ToLower() -eq "owner" -or $membershipType.ToLower() -eq "owners")
{
    Add-UnifiedGroupLinks -Identity $groupId -LinkType "Member" -Links $loginName -Confirm:$false
}
Add-UnifiedGroupLinks -Identity $groupId -LinkType $membershipType -Links $loginName
Remove-PSSession $session
Read-Host -Prompt "Press Enter to exit"