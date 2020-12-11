#Source: https://www.morgantechspace.com/2018/06/how-to-install-and-connect-sharepoint-online-powershell-module.html
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
$AdminSiteURL = "https://hospitaldeolhos93-admin.sharepoint.com"
#Connect to SharePoint Online Admin Site
Connect-SPOService -Url $AdminSiteURL

#Retrieves all personal sites
Get-SPOSite -IncludePersonalSite $true -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'" |
    Select Owner, StorageUsageCurrent, Url

#Export all personal sites and storage details to csv file
$Result = @()
#Get all OneDrive for Business sites
$oneDriveSites = Get-SPOSite -IncludePersonalSite $true -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'"
$oneDriveSites | ForEach-Object {
    $site = $_
    $Result += New-Object PSObject -property @{ 
        UserName          = $site.Owner
        Size_inMB         = $site.StorageUsageCurrent
        StorageQuota_inGB = $site.StorageQuota / 1024
        WarningSize_inGB  = $site.StorageQuotaWarningLevel / 1024
        OneDriveSiteUrl   = $site.URL
    }
}
$Result | Select UserName, Size_inMB, StorageQuota_inGB, WarningSize_inGB, OneDriveSiteUrl |
    Export-CSV "C:\\OneDrive-for-Business-Size-Report.csv" -NoTypeInformation -Encoding UTF8
