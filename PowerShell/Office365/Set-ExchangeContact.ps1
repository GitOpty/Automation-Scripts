. ".\Connect-O365.ps1"
    . ".\Get-O365Domains.ps1"
    . ".\Get-O365Users.ps1"
    . ".\Connect-Exchange.ps1"

#Import-Csv

Import-Csv .\ExternalContacts.csv -Delimiter ";"|%{New-MailContact -Name $_.Name -DisplayName $_.Name -ExternalEmailAddress $_.ExternalEmailAddress -FirstName $_.FirstName -LastName $_.LastName}

Import-Csv .\ExternalContacts.csv -Delimiter ";"| foreach {Add-DistributionGroupMember -Identity "Assistentes@sadalla.com.br" –Member $_.UserPrincipalName}