<#
    .SYNOPSIS
    Generate email address from full name 

    .DESCRIPTION
    Senior payroll software doesn't stores updated email address from employees. This information is necessary for Office 365 automation

    .EXAMPLES
    $email = Convert-FullNameToEmail -FullName "Sergio Carvalho Queiroz"

    .AUTHOR
    Sergio Carvalho Queiroz (sergio.queiroz@hobrasil.com.br)
#>
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

$UserPrincipalName = Convert-FullNameToEmail -FullName "Karla Thaisy da Costa Nascimento"

<#
    .SYNOPSIS
    Set user contact information at Office 365 Admin Center

    .DESCRIPTION
    Updates contact information at Office 365 Admin Center, based on Senior HR (payroll software) exported data

    .AUTHOR
    Sergio Carvalho Queiroz (sergio.queiroz@hobrasil.com.br)
#>
Connect-MsolService
$Users = (Import-Csv -Path '20181019 Senior Colaboradores.csv' -Delimiter ';') | Where { $_.StreetAddress -Like '*Evaristo*Veiga*156*' }
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

<#
    .SYNOPSIS
    Blocks access from employees' list

    .AUTHOR
    Sergio Carvalho Queiroz (sergio.queiroz@hobrasil.com.br)
#>
$Users = (Import-Csv -Path '20181019 Senior Colaboradores.csv' -Delimiter ';') | Where { $_.Status -eq 'Demitido' }
$Users | ForEach-Object { Set-MsolUser -UserPrincipalName $_ -BlockCredential $true }