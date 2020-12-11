$adminUPN = "sergio.queiroz@opty.com.br"
$orgName = "hospitaldeolhos93"
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."

Connect-MsolService
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $userCredential
$UrlPrefix = 'https://$orgName-my.sharepoint.com/personal/'

$Users = Get-MsolUser -EnabledFilter EnabledOnly -All
$UserCount = 0
$ODBCount = 0
$Stream = [System.IO.StreamWriter] 'OneDriveSizes.txt'

foreach ($User in $Users) {
    [string]::Format("{0}", $User.UserPrincipalName)
    foreach ($Plan in $User.Licenses.ServiceStatus) {
        [string]::Format("{0}, {1}", $Plan.ServicePlan.ServiceName, $Plan.ProvisioningStatus)
        if ( ($Plan.ServicePlan.ServiceName -like 'SHAREPOINTDESKLESS') -and ($Plan.ProvisioningStatus -eq 'Success') ) {
            $UserCount++
            try {
                $Url = $UrlPrefix + $User.UserPrincipalName.Replace(".", "_").Replace("@", "_")
                $OneDrive = Get-SPOSite $Url
                $UPN = $User.UserPrincipalName
                $ODBCurrentUsage = $OneDrive.StorageUsageCurrent
                $ODBStorageQuota = $OneDrive.StorageQuota
                $ODBLastContentModifiedDate = $OneDrive.LastContentModifiedDate
                $Stream.WriteLine("$UPN, $ODBCurrentUsage, $ODBStorageQuota, $ODBLastContentModifiedDate")
                $ODBCount++
            }
            catch {
                [string]::Format("{0}, N/A, N/A, N/A", $User.UserPrincipalName)
            }
        }
    }
}
[string]::Format("OneDrives: {0}`nProfiles: {1}", $OneDriveCount, $UserCount)
$Stream.Close()