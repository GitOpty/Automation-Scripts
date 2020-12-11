# Store credentials
$Cred = Get-Credential

# Connect to Exchange Online and create a session
$Session = New-PSSession `
    -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://ps.outlook.com/powershell `
    -Credential $Cred `
    -Authentication Basic `
    -AllowRedirection


# Download Exchange Online Powershell cmdlets
$EXOLSession = Import-PSSession $Session

#
Set-User -Identity 'allan.pacheco@opty.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'acaciano.carvalho@hobr.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'alex.izumi@hobr.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'cristiano.carvalho@hobr.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'eduardo@dayhorc.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'gilberto.alves@hobr.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'hugo.fernandes@hobr.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'jonney.carvalho@hosl-al.com' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'luis.jr@hobr.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'mauricio@dayhorc.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'murilo.cruz@olhosfreitas.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'renilson.carvalho@hobr.com.br' -Manager 'sergio.queiroz@opty.com.br'
Set-User -Identity 'rodrigo.albuquerque@hosl-al.com' -Manager 'sergio.queiroz@opty.com.br'


# Count of cmdlets
$EXOLSession.ExportedFunctions.Count

# Get a list of cmdlets
Get-Command -Module $EXOLSession | Out-Host -Paging

# Get Mailbox statistics by folder
Get-MailboxFolderStatistics -Identity sergio.queiroz@opty.com.br -FolderScope Inbox | Select Name, FolderSize, ItemsinFolder, ItemsinFolderandSubfolders

# Enabling archiving
Enable-Mailbox -Identity sergio.queiroz@opty.com.br -Archive

# Grant permission to another user to open mailbox
Add-MailboxPermission –User sergio.queiroz@opty.com.br -Identity karla.nascimento@opty.com.br -AccessRights FullAccess -InheritanceType All

# Deny permission to open mailbox
Remove-MailboxPermission –User sergio.queiroz@opty.com.br -Identity karla.nascimento@opty.com.br -AccessRights FullAccess

#### Report for all mailboxes in org
$mailboxes = @(Get-Mailbox -ResultSize Unlimited)
$report = @()

foreach ($mailbox in $mailboxes) {
    $inboxstats = Get-MailboxFolderStatistics $mailbox -FolderScope Inbox | Where {$_.FolderPath -eq "/Inbox"}

    $mbObj = New-Object PSObject
    $mbObj | Add-Member -MemberType NoteProperty -Name "Display Name" -Value $mailbox.DisplayName
    $mbObj | Add-Member -MemberType NoteProperty -Name "Inbox Size (Mb)" -Value $inboxstats.FolderandSubFolderSize.ToMB()
    $mbObj | Add-Member -MemberType NoteProperty -Name "Inbox Items" -Value $inboxstats.ItemsinFolderandSubfolders
    $report += $mbObj
}

$report

# To finish, remove it
Remove-PSSession $Session

##### Create Compliance Search - Export Email

$SearchName = "Grandes Arquivos - karla.nascimento"
New-ComplianceSearch -ExchangeLocation $term365.UserPrincipalName -Name $SearchName

# Start Compliance Search and wait to complete

Start-ComplianceSearch $SearchName
do {
    Start-Sleep -s 5
    $complianceSearch = Get-ComplianceSearch $SearchName
}
while ($complianceSearch.Status -ne 'Completed')

# Create Compliance Search in exportable format
New-ComplianceSearchAction -SearchName $SearchName -Export -ArchiveFormat PerUserPST -EnableDedupe $true
$ExportName = $SearchName + "_Export"

#Wait for Export to complete
do {
    Start-Sleep -s 5
    $complete = Get-ComplianceSearchAction -Identity $ExportName
}
while ($complete.Status -ne 'Completed')


####
New-ComplianceSearch -Name "Search All-Financial Report" -ExchangeLocation all -ContentMatchQuery 'sent>=01/01/2015 AND sent<=06/30/2015 AND subject:"financial report"'
Start-ComplianceSearch -Identity "Search All-Financial Report"

### Para criar um certificado de Root CA basta especificar a Certificate Store e o DNS Name:
$Certificado = New-SelfSignedCertificate -CertStoreLocation cert:\localmachine\my -DnsName 'Root CA'

### Exportando um certificado para formato PFX:
$senha = ConvertTo-SecureString -String 'SenhadoCertificado' -Force -AsPlainText
Export-PfxCertificate -cert $Certificado -FilePath root_ca.pfx -Password $senha