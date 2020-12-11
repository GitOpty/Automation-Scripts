function Set-O365UsersPassword {
    param (
        [Parameter(Mandatory)]
        [ValidateScript( {
                if (Test-Path -Path $_ -PathType Leaf) {
                    $true
                }
                else {
                    throw "Arquivo $($_) não encontrado."
                }
            })]
        [string]$Arquivo,
        
        [switch]$whatIf = $False
    )
    Connect-MsolService

    Import-CSV -Path $Arquivo | ForEach-Object {
        if ($whatIf) {
            Set-MsolUserPassword -UserPrincipalName $_ -NewPassword 'Opty@2019' -ForceChangePassword $True
        }
        Else {
            Write-Host "Senha de $_ será alterada para Opty@2019"
        }
    }
    
}

Set-O365UsersPassword -Arquivo "$PSScriptRoot\ListagemEmails.csv"