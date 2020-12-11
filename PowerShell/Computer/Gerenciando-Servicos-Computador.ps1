#Encerrando processos que não estão respondendo
Get-Process | Where-Object -FilterScript {$_.Responding -eq $false} | Stop-Process

#Encerrando outras instâncias do processo
Get-Process -Name powershell | Where-Object -FilterScript {$_.Id -ne $PID} | Stop-Process -PassThru

#Listando serviços dos quais um determinando serviço depende
Get-Service -Name LanmanWorkstation -RequiredServices

#Listando serviços que dependem de um determinado servico
Get-Service -Name LanmanWorkstation -DependentServices

#Listando interdependências entre serviços
Get-Service -Name * | Where-Object {$_.RequiredServices -or $_.DependentServices} | Format-Table -Property Status, Name, RequiredServices, DependentServices -auto

#Reiniciando um serviço remoto
Invoke-Command -ComputerName Server01 {Restart-Service Spooler}