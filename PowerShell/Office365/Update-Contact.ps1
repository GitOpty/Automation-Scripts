".\Connect-O365.ps1"



#importa CSV
$Contatos = Import-Csv -Path C:\csv\LicencasOffice365.csv -Delimiter ";"

#Conecta no Office 365
#Connect-MsolService
#Cria o laço com o Objeto
$Contatos | ForEach-Object -Process {
    Write-Host $_
    #Busca o Usuario no CSV
    $User = Get-MsolUser -UserPrincipalName $_.UserPrincipalName 
    #Verifica se o usuarios está Cadastrado
    if ($User -ne  $null) {
        Set-MsolUser `
            -UserPrincipalName $_.UserPrincipalName `
            -Office $_.Office

    }
}

