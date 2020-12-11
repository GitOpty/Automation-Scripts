<#
    .SYNOPSIS
    Altera o email principal do usuario no Office 365

    .DESCRIPTION
    Altera o dominio do email principal dos usuarios do Office 365

    .EXAMPLES
    Edit-O365Logon -Department "CENTRO DE SOLUÇÕES INTEGRADAS"
    Edit-O365Logon -Department "CENTRO DE SOLUÇÕES INTEGRADAS" -Domain "hobrasil.com.br"
    Edit-O365Logon -Department "CENTRO DE SOLUÇÕES INTEGRADAS" -Update

    .AUTHOR
    Sergio Carvalho Queiroz (sergio.queiroz@hobrasil.com.br)
#>
function Edit-O365Logon {
    Param 
    (
        [String] $Department,
        [PSDefaultValue(Help = 'opty.com.br')]
        [String] $NewDomain = 'opty.com.br',
        [switch] $Update
    )

    Connect-MsolService
    #$users = Get-MsolUser -UserPrincipalName "karla.nascimento@hobrasil.com.br" | `
    $users = Get-MsolUser -EnabledFilter EnabledOnly -Department $Department | `
        Select-Object DisplayName, UserPrincipalName | `
        Sort-Object -Property DisplayName

    $users | ForEach-Object -Begin {"Início do processamento: " + (Get-Date -Format F)} -Process {
        $NewMail = $_.UserPrincipalName.Split("@")[0] + "@$NewDomain"
        Write-Host "Alterando " $_.UserPrincipalName " para $NewMail"
        If ($Update) {
            Set-MsolUserPrincipalName -UserPrincipalName $_.UserPrincipalName -NewUserPrincipalName $NewMail
        }
    } -End {"Fim do processamento: " + (Get-Date -Format F)}
}

Edit-O365Logon -Department "CENTRO DE SOLUÇÕES INTEGRADAS" -Update