Function Get-CompanyDomain {
    Param 
    (
        [String] $Company
    )
    $CompanyDomain = @{
        'CLINICA OFTALMOLOGICA DE VILLAS LTDA'     = 'opty.com.br'
        'CLINICA SUL DE OFTALMOLOGIA LTDA - EPP'   = 'opty.com.br'
        'CONTACT-GEL LTDA'                         = 'opty.com.br'
        'HOB HOSPITAL OFTALM DE BRASILIA LTDA'     = 'hobr.com.br'
        'HOB HOSPITAL OFTALMO. DE BRASILIA LTDA'   = 'hobr.com.br'
        'HOB TAGUATINGA LTDA - EPP'                = 'hobr.com.br'
        'HOSPITAL DE OLHOS RUY CUNHA LTDA'         = 'dayhorc.com.br'
        'HOSPITAL DE OLHOS SADALLA AMIN GHANEM LT' = 'sadalla.com.br'
        'HOSPITAL DE OLHOS SANTA LUZIA LTDA'       = 'hosl-al.com'
        'INOB - INST. DE OLHOS E M. DE BRAS. LTDA' = 'inob.com.br'
        'INSTITUTO DE OLHOS DE EUNAPOLIS SC LTDA'  = 'dayhorc.com.br'
        'INSTITUTO DE OLHOS LTDA'                  = 'dayhorc.com.br'
        'IPC ADMINISTRAÇÃO DE BENS PRÓPRIOS'       = 'opty.com.br'
        'SILVA CUNHA COMERCIO LENTES CONTATO LTDA' = 'opty.com.br'
        'TOPAZIO COM VAREJ DE LENTES E SERV LTDA'  = 'opty.com.br'
    }
    Return $CompanyDomain.Item($Company.ToUpper())
}
#Get-CompanyDomain -Company "INOB - Inst. de Olhos e M. de Bras. Ltda"

Function Convert-FullnameToEmail {
    Param
    (
        [String]$Fullname,
        [PSDefaultValue(Help = 'hobrasil.com.br')]
        [String]$Domain = 'hobrasil.com.br'
    )
	
    $Names = $FullName.Split(" ").ToLower()
    
    return $Names[0] + "." + $Names[$Names.Count - 1] + "@" + $Domain	
}
Function Get-CompanyWorkers {
    Param 
    (
        [parameter(Mandatory = $true)]
        [String] $CSVFilename,
        [String] $Company = '*',
        [String] $Status = '*',
        [String] $Department = '*',
        [String] $City = '*',
        [String] $State = '*',
        [Switch] $InactivesOnly
    )
    If ($InactivesOnly) {
        $Workers = (Import-Csv -Path $CSVFilename -Encoding UTF8 -Delimiter ';') | Where-Object { $_.STATUS -ne "Trabalhando" `
                -and $_.COMPANYNAME -like $Company `
                -and $_.DEPARTMENT -like $Department `
                -and $_.CITY -like $City `
                -and $_.STATE -like $State}
    }
    Else {
        $Workers = (Import-Csv -Path $CSVFilename -Encoding UTF8 -Delimiter ';') | Where-Object { $_.COMPANYNAME -like $Company `
                -and $_.STATUS -like $Status `
                -and $_.DEPARTMENT -like $Department `
                -and $_.CITY -like $City `
                -and $_.STATE -like $State}
    }
    Return $Workers | Sort-Object -Property DISPLAYNAME
}

Function Update-WorkersO365ContactInfo {
    Param 
    (
        [PSObject] $Workers,
        [Switch] $Update
    )
    $AffectedUsers = @()
    $Workers | ForEach-Object -Begin {"Início do processamento: " + (Get-Date) ; Connect-MsolService} -Process { 
        $Domain = Get-CompanyDomain -Company $_.COMPANYNAME
        $Email = Convert-FullNameToEmail -FullName $_.DISPLAYNAME -Domain $Domain
        Write-Host ("Processando {0}, {1}, {2} ..." -f $_.DISPLAYNAME, $_.TITLE, $_.STATUS)
        If ($Update) {
            $User = Get-MsolUser -UserPrincipalName $Email -ErrorAction SilentlyContinue
            If ($User -ne $null) {
                $AffectedUsers += $User  
                Write-Host ("Atualizando {0}, {1}" -f $Email, ($User.Licenses).AccountSkuId)
                Set-MsolUser `
                    -UserPrincipalName $email `
                    -FirstName $_.FIRST_MANE `
                    -LastName $_.LAST_NAME `
                    -DisplayName $_.DISPLAYNAME `
                    -Title $_.TITLE `
                    -Department $_.DEPARTMENT `
                    -Office $_.COMPANYNAME `
                    -PhoneNumber $_.PHONENUMBER `
                    -StreetAddress $_.STREETADDRESS `
                    -City $_.CITY `
                    -State $_.STATE `
                    -PostalCode $_.POSTALCODE `
                    -Country 'Brasil' `
                    -UsageLocation $_.USAGELOCATION `
                    -ErrorAction SilentlyContinue
            }
        }
    } -End {"Fim do processamento: " + (Get-Date)}    
    Return $AffectedUsers
}

Function Disable-WorkersO365Credentials {
    Param 
    (
        [PSObject] $Workers,
        [Switch] $Disable
    )
    $AffectedUsers = @()
    $Workers | ForEach-Object -Begin {"Início do processamento: " + (Get-Date)} -Process { 
        $Domain = Get-CompanyDomain -Company $_.COMPANYNAME
        $Email = Convert-FullNameToEmail -FullName $_.DISPLAYNAME -Domain $Domain
        Write-Host ("Processando {0}, {1}, {2} ..." -f $_.DISPLAYNAME, $_.TITLE, $_.STATUS)
        If ($Disable) {
            $User = Get-MsolUser -UserPrincipalName $Email -ErrorAction SilentlyContinue
            If ($User -ne $null) {
                $AffectedUsers += $User
                Write-Host ("Bloqueando {0}, {1}" -f $Email, ($User.Licenses).AccountSkuId)
                Set-MsolUser `
                    -UserPrincipalName $email `
                    -BlockCredential $true `
                    -ErrorAction SilentlyContinue
            }
        }
    } -End {"Fim do processamento: " + (Get-Date)}    
    Return $AffectedUsers
}

Function Remove-WorkersO365Licenses {
    Param 
    (
        [PSObject] $Workers,
        [Switch] $Remove
    )
    $AffectedUsers = @()
    $Workers | ForEach-Object -Begin {"Início do processamento: " + (Get-Date)} -Process { 
        $Domain = Get-CompanyDomain -Company $_.COMPANYNAME
        $Email = Convert-FullNameToEmail -FullName $_.DISPLAYNAME -Domain $Domain
        Write-Host ("Processando {0}, {1}, {2} ..." -f $_.DISPLAYNAME, $_.TITLE, $_.STATUS)
        If ($Remove) {
            $User = Get-MsolUser -UserPrincipalName $Email -ErrorAction SilentlyContinue
            If ($User -ne $null -and $_.STATUS -eq "Demitido") {
                $AffectedUsers += $User
                $User.Licenses.AccountSkuId | ForEach-Object {
                    Write-Host ("Revogando licença  {0}, {1}" -f $Email, $_)
                    Set-MsolUserLicense `
                        -UserPrincipalName $email `
                        -RemoveLicenses $_ `
                        -ErrorAction SilentlyContinue

                }
            }
        }
    } -End {"Fim do processamento: " + (Get-Date)}    
    Return $AffectedUsers
}

$CSVFilename = (Get-Date -Format "yyyyMMdd") + " Senior Workers.csv"
$InactiveWorkers = Get-CompanyWorkers -CSVFilename $CSVFilename -Company "INOB - Inst. de Olhos e M. de Bras. Ltda" -InactivesOnly
$InactiveWorkers = Get-CompanyWorkers -CSVFilename $CSVFilename -InactivesOnly
$InactiveWorkers | Format-Table -AutoSize
$UpdatedAccounts = Update-WorkersO365ContactInfo -Workers $InactiveWorkers -Update
$UpdatedAccounts | Format-Table -AutoSize
$DisabledAccounts = Disable-WorkersO365Credentials -Workers $InactiveWorkers -Disable
$DisabledAccounts | Format-Table -AutoSize
$RemovedLicenses = Remove-WorkersO365Licenses -Workers $InactiveWorkers -Remove
$RemovedLicenses | Format-Table -AutoSize
#Get-Mailbox -Identity "sergio.queiroz@opty.com.br"


#Get-MsolUser -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin –Force

Get-MsolAccountSku
Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -eq "reseller-account:O365_BUSINESS_PREMIUM"} | Format-Table -AutoSize