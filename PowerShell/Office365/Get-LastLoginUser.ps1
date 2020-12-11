.\Connect-Exchange.ps1
.\Connect-O365.ps1

$Users = Get-MsolUser -EnabledFilter All -MaxResults 5000 | Where-Object {$_.IsLicensed -eq $true}
# $licensetype = Get-MsolAccountSku | Where {$_.ConsumedUnits -ge 1}
$data = (Get-Date).AddDays(-90) 

$ResultItem = @()

foreach ($User in $Users) {
       
        $UserLastLogon = Get-Mailbox -Identity $User.UserPrincipalName| Get-MailboxStatistics | Where-Object {$_.LastLogonTime -lt $data}
   
    
            try {
                $ResultItem += New-Object PSObject -Property @{ 
                    DisplayName = $UserLastLogon.DisplayName 
                    UserPrincipalName = $User.UserPrincipalName
                    LastLogon = $UserLastLogon.LastLogonTime.ToString("dd/MM/yyyy")
                    Marca =  $User.Office
                }
                Write-Host $User.UserPrincipalName $UserLastLogon.LastLogonTime
            }
            catch {
                $ErrosMessage = $_.Exception.Message                
            }
            Finally {
                Write-Host $User.UserPrincipalName $ErrosMessage                 
            }
         
}

$ResultItem| Export-Csv -Encoding UTF8 -Delimiter ";" LastLogin.csv -NoTypeInformation -Append -Force

