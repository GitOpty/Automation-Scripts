<#
 .SYNOPSIS
    Conecta ao serviço do Office 365

 .DESCRIPTION
    Este script conecta ao servico do Office 365, a partir de credenciais armazenadas em arquivo
    Deve ser executado no inicio de todos os scripts que manipulam o O365
 .EXAMPLE
    .\Connect-O365.ps1
#>

$CredentialsFilePath = "$PSScriptRoot\credentials.xml"

If (-Not (Test-Path $CredentialsFilePath)) {
    # Solicita as credenciais de acesso ao Office365 e salva hash, caso arquivo não exista
    $Credentials = Get-Credential
    $Credentials | Export-Clixml -Path $CredentialsFilePath
}
# Le as credenciais de acesso a partir do arquivo
$CredentialsFile = Import-Clixml -Path $CredentialsFilePath

Connect-MsolService -Credential $CredentialsFile
