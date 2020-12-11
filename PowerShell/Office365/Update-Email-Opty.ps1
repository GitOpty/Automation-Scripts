. ".\Connect-O365.ps1"

#importa CSV
$Contatos = Import-Csv -Path C:\csv\Email.csv -Delimiter ";"

#Conecta no Office 365
#Connect-MsolService
#Cria o laço com o Objeto
$Contatos | ForEach-Object -Process {
    Write-Host $_
    #Busca o Usuario no CSV
    $User = Get-MsolUser -UserPrincipalName $_.Email
    #Verifica se o usuarios está Cadastrado
    if ($User -ne  $null) {
        Set-MsolUserPrincipalName -UserPrincipalName $_.Email -NewUserPrincipalName $_.New_Email
            

    }
}

