
# Lists all domains in tenant
function Get-FullMailBoxes {
    
    . ".\Connect-O365.ps1"
    . ".\Get-O365Domains.ps1"
    . ".\Get-O365Users.ps1"
    . ".\Connect-Exchange.ps1" # Function for manipulate distribution groups is unavailable with Connect-MsolService
    

    $domains = Get-O365Domains
     foreach ($domain in $domains) {
        Write-Host "Dominio: $($domain.Name)"
        # Export all active users from domain to O365ActiveUsers-[Domain]-yyyyMMdd.csv
        $Users = Get-O365Users -Domain $domain.Name | Where-Object -FilterScript {$_.isLicensed -eq "True"}
        $PercentEmptyBox = 85
        # $CSVFilename = "FullMailBoxesReport-" + $domain.Name + ".csv"
        $Report = @()
        
        foreach ($User in $Users) {
                $ExchUser =  Get-Mailbox -Identity $User.UserPrincipalName  -RecipientTypeDetails UserMailBox | Select-Object DisplayName, UserPrincipalName,TotalItemSize, ProhibitSendReceiveQuota, DistinguishedName
                
                $MailboxStats = Get-MailboxStatistics -Identity $User.UserPrincipalName | Select-Object ItemCount, TotalItemSize
                Write-Host "$($User.UserPrincipalName) : $($MailboxStats.TotalItemSize)"
                $ErrorText = $Null
                
                [INT64]$QuotaUsed = [System.Convert]::ToInt64(((($MailboxStats.TotalItemSize.ToString().split("(")[-1]).split(")")[0]).split(" ")[0]-replace '[,]',''))
                
                [INT64]$MboxesQuota = [System.Convert]::ToInt64(((($ExchUser.ProhibitSendReceiveQuota.ToString().split("(")[-1]).split(")")[0]).split(" ")[0]-replace '[,]',''))
                
                
                $MboxesQuotaGB = [System.Math]::Round(($MboxesQuota),2)
                $QuotaPercentUsed = [System.Math]::Round(($QuotaUsed/$MboxesQuotaGB)*100,2)
                $QuotaUsedGB = [System.Math]::Round(($QuotaUsed),2)
                IF($QuotaPercentUsed -gt $PercentEmptyBox){
                    Write-Host "Tamanho maximo da caixa de $($User.UserPrincipalName) esta proximo do limite. Uso: $($QuotaPercentUsed)% "   -ForegroundColor Red
                    $ErrorText = "Caixa de correio acima do Limite"
    
                    $ReportLine = [PSCustomObject][Ordered]@{
                        UserName = $ExchUser.DisplayName
                        Mailbox = $ExchUser.UserPrincipalName
                        MboxesQuotaGB = $MboxesQuotaGB
                        Items = $MailboxStats.ItemCount
                        MboxesSizeGB = $QuotaUsedGB
                        QuotaPercentUsed = $QuotaPercentUsed
                        ErrorText = $ErrorText
                    }
                    
                    $Report += $ReportLine
                }else{
                    Write-Host "Size OK! $($QuotaPercentUsed)% : $($QuotaUsed)"
                }
                          
                Write-Host($Report)
                    $Report | ConvertTo-Json
            }
            
        }

    return $Report
}

