param(
    [Parameter(Mandatory)]
    [String]$tenant,
    [Parameter(Mandatory)]
    [String]$siteTitle,
    [Parameter(Mandatory)]
    [String]$siteUrlName,
    [Parameter(Mandatory)]
    [String]$siteDescription,
    [Parameter(Mandatory)]
    [String]$siteDesign, # Possible values: Topic, Showcase, Blank
    [Parameter(Mandatory)]
    [String[]]$principals
)
Connect-SPOService ("https://{0}-admin.sharepoint.com" -f $tenant) -Credential (Get-Credential)
$siteUrl = "https://{0}.sharepoint.com/sites/{1}" -f $tenant, $siteUrlName
New-PnPSite -Type CommunicationSite -Title $siteTitle -Url $siteUrl -Description $siteDescription -SiteDesign $siteDesign
Register-SPOHubSite $siteUrl -Principals $principals
Read-Host -Prompt "Press Enter to exit"