Set-ExecutionPolicy -ExecutionPolicy Bypass
Clear-Host

function AddRemoteUser ($User, $Name, $Pass) {
    New-LocalUser -Name $User -Password  (ConvertTo-SecureString -String $Pass -AsPlainText -Force) -PasswordNeverExpires 
    Get-LocalUser -Name $User | Set-LocalUser -FullName $Name
    Get-LocalUser -Name $User | Add-LocalGroupMember -Group 'Usuários da área de trabalho remota'
}

$Name = Read-Host "Informe o Nome do Colaborador: "
$User = Read-Host "Informe o Usário: "
$Name = Read-Host "Informe a Senha: " -AsSecureString

AddRemoteUser $Name $User $Pass

