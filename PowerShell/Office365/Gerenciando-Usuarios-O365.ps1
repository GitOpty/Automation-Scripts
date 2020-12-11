Connect-MsolService
Get-MsolUser -UserPrincipalName 'karla.nascimento@hobrasil.com.br' | Select-Object *
Set-MsolUser `
    -UserPrincipalName 'karla.nascimento@hobrasil.com.br' `
    -City 'Joinville' `
    -Country 'Brasil' `
    -Department 'Tecnologia da Informação' `
    -DisplayName 'Karla Thaisy da Costa Nascimento' `
    -FirstName 'Karla' `
    -LastName 'Nascimento' `
    -PhoneNumber '(47) 3305-9470' `
    -PostalCode '89216-215' `
    -State 'SC' `
    -StreetAddress 'Rua Evaristo da Veiga, 156' `
    -Title 'Estagiária' `
    -UsageLocation 'BR'

#Set-MsolUser `
#    -UserPrincipalName 'karla.nascimento@hobrasil.com.br' `
#    -BlockCredential $false

Get-Content Accounts.txt | ForEach-Object { Set-MsolUser -UserPrincipalName $_ -BlockCredential $true }

Get-Content -Path 'C:\Users\sergio.queiroz\Documents\OneDrive - Opty\Scripts Powershell\20180910 Senior Colaboradores.csv' -TotalCount 1
(Get-Content -Path 'C:\Users\sergio.queiroz\Documents\OneDrive - Opty\Scripts Powershell\20180910 Senior Colaboradores.csv' -TotalCount 10)[-1]
Import-Csv -Path 'C:\Users\sergio.queiroz\Documents\OneDrive - Opty\Scripts Powershell\20180910 Senior Colaboradores.csv' -Delimiter ';' | Format-Table
(Import-Csv -Path 'C:\Users\sergio.queiroz\Documents\OneDrive - Opty\Scripts Powershell\20180910 Senior Colaboradores.csv' -Delimiter ';').StreetAddress -Like '*Evaristo da Veiga*'
(Import-Csv -Path 'C:\Users\sergio.queiroz\Documents\OneDrive - Opty\Scripts Powershell\20180910 Senior Colaboradores.csv' -Delimiter ';') | Where { $_.StreetAddress -Like '*Evaristo da Veiga*' } | Select DisplayName, StreetAddress | Sort -Property "DisplayName"
(Import-Csv -Path 'C:\Users\sergio.queiroz\Documents\OneDrive - Opty\Scripts Powershell\20180910 Senior Colaboradores.csv' -Delimiter ';') | Where { $_.DisplayName -Like '*Allan*' }



function Get-NewCSVFiles {
    $start = Get-Date -Month 10 -Day 1 -Year 2018
    #   $allpix = Get-ChildItem -Path $env:UserProfile\*.csv -Recurse
    $allpix = Get-ChildItem -Path .\*.csv -Recurse
    $allpix | where {$_.LastWriteTime -gt $Start}
}

Get-NewCSVFiles

Function Convert-FullNameToEmail {
    Param
    (
        [String]$FullName,
        [PSDefaultValue(Help = 'hobrasil.com.br')]
        [String]$Domain = 'hobrasil.com.br'
    )
	
    $Names = $FullName.Split(" ").ToLower()
    
    return $Names[0] + "." + $Names[$Names.Count - 1] + "@" + $Domain	
}

$UserPrincipalName = Convert-FullNameToEmail -FullName "Gabriela Schemmer Catarina"

Function Set-O365UserContactInformation {
    <#
    .SYNOPSIS
    Set user contact information at Office 365 Admin Center

    .DESCRIPTION
    Updates contact information at Office 365 Admin Center, based on Senior HR (payroll software) exported data

    .PARAMETER

    .EXAMPLE

    .INPUTS
    #>
}

Connect-MsolService
$Users = (Import-Csv -Path 'C:\Users\sergio.queiroz\Documents\OneDrive - Opty\Scripts Powershell\20180910 Senior Colaboradores.csv' -Delimiter ';') | Where { $_.StreetAddress -Like '*Evaristo*Veiga*156*' }
$Users | ForEach-Object -Begin {"Início do processamento: " + (Get-Date)} -Process { 
    $FullName = $_.DISPLAYNAME
    $Email = Convert-FullNameToEmail $_.DISPLAYNAME
    "Processando $FullName ($email) ..."
    Set-MsolUser `
        -UserPrincipalName $email `
        -City $_.CITY `
        -Country 'Brasil' `
        -Department $_.DEPARTMENT `
        -DisplayName $_.DISPLAYNAME `
        -FirstName $_.FIRST_MANE `
        -LastName $_.LAST_NAME `
        -PhoneNumber $_.PHONENUMBER `
        -PostalCode $_.POSTALCODE `
        -State $_.STATE `
        -StreetAddress $_.STREETADDRESS `
        -Title $_.TITLE `
        -UsageLocation $_.USAGELOCATION
} -End {"Fim do processamento: " + (Get-Date)}

(Invoke-WebRequest https://httpbin.org/get).Content

Invoke-RestMethod https://httpbin.org/get -Method GET
