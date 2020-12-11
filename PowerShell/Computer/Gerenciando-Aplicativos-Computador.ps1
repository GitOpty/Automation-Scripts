#Listando aplicativos do Windows Installer
Get-WmiObject -Class Win32_Product -ComputerName .

#Listando aplicativos desinstaláveis
New-PSDrive -Name Uninstall -PSProvider Registry -Root HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
(Get-ChildItem -Path Uninstall:).Count
Get-ChildItem -Path Uninstall: | ForEach-Object -Process { $_.GetValue('DisplayName') }

#Instalando aplicativos
(Get-WMIObject -ComputerName PC01 -List | Where-Object -FilterScript {$_.Name -eq 'Win32_Product'}).Install(\\AppSrv\dsp\NewPackage.msi)

#Removendo aplicativos
(Get-WmiObject -Class Win32_Product -Filter "Name='Qlik Sense DemoApps'" -ComputerName . ).Uninstall()

#Atualizando aplicativos
(Get-WmiObject -Class Win32_Product -ComputerName . -Filter "Name='OldAppName'").Upgrade(\\AppSrv\dsp\OldAppUpgrade.msi)