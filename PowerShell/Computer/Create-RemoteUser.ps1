New-LocalUser -Name .temp -Password  (ConvertTo-SecureString -String 'Senha' -AsPlainText -Force) -PasswordNeverExpires 
Get-LocalUser -Name 'usuário' | Set-LocalUser -FullName 'Nome Completo'
Get-LocalUser -Name 'usuário' | Add-LocalGroupMember -Group 'Usuários da área de trabalho remota'