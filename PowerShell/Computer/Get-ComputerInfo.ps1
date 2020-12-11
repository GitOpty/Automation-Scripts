Informações sobre sistema de 949882865

Informações básicas
	Nome do computador:	ELISON
	Nome de usuário:	HOBRASIL\elison
	Domínio:	HOBRASIL.LOCAL
	Tempo de inicialização:	31.10.2018 10:15:18

Processador & Memória
	Processador:	Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz
	Memória física:	8 GiB

Sistema operacional
	Nome:	Microsoft Windows 10 Pro
	Versão:	10.0.17134
	Pacote de serviço:

Dispositivos
	C:	919.15 GiB NTFS - 779.36 GiB vazio
	E:	59.48 GiB NTFS - 6.40 GiB vazio

Placa de rede
	Nome:	Microsoft Wi-Fi Direct Virtual Adapter #2
	Endereços IP:	192.168.137.1
	Máscara de sub-rede:	255.255.255.0
	Gateway padrão:
	Largura de banda:	108.30 Mbit/s

	Nome:	Realtek PCIe GBE Family Controller
	Endereços IP:	10.47.0.199
	Máscara de sub-rede:	255.255.252.0
	Gateway padrão:	10.47.0.1
	Largura de banda:	1000.00 Mbit/s

Import-Module Get-TeamViewerID
$computador = 'COMPRAS01'
Test-Connection -ComputerName $Computador
Get-InternetConnection
Get-TeamViewerID -Hostname $computador -Copy $true

# Informações da BIOS
$Win32_BIOS = Get-CimInstance -ClassName Win32_BIOS -ComputerName $computador
$Win32_ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $computador

# Informações do processador
$Win32_Processor = Get-CimInstance -ClassName Win32_Processor -ComputerName $computador

# Hotfixes instalados
$hotfixes = Get-CimInstance -ClassName Win32_QuickFixEngineering -ComputerName $computador | `
    Select-Object HotFixID, Description, @{Name = 'InstalledOn'; Expression = {Get-Date ($_.InstalledOn) -Format 'dd/MM/yyyy'}} | `
    Sort-Object -Property InstalledOn

$resultado = [PSCustomObject]@{
    Computador  = $Win32_BIOS.PSComputerName ;
    Fabricante  = $Win32_BIOS.Manufacturer ;
    Modelo      = $Win32_ComputerSystem.Model ;
    Tag         = $Win32_BIOS.SerialNumber ;
    Processador = $Win32_Processor.Name ;
    Hotfixes    = $hotfixes
}

$resultado | ConvertTo-Json



#Listar os hotfixes instalados

#Listar informações de versão do sistema operacional
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computador | Select-Object -Property BuildNumber, BuildType, OSType, ServicePackMajorVersion, ServicePackMinorVersion
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computador | Select-Object -Property Build*, OSType, ServicePack*
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName COMPRAS01 | Select-Object -Property Build*, OSType, ServicePack*

#Listar proprietário e usuários locais
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computador | Select-Object -Property NumberOfLicensedUsers, NumberOfUsers, RegisteredUser
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName COMPRAS01 | Select-Object -Property *user*

#Obter o espaço em disco disponível
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $computador
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $computador | Measure-Object -Property FreeSpace, Size -Sum | Select-Object -Property Property, Sum

#Obter informações de sessão de logon
Get-CimInstance -ClassName Win32_LogonSession -ComputerName $computador

#Obter o usuário conectado a um computador
Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName -ComputerName $computador

#Obter a hora local de um computador
Get-CimInstance -ClassName Win32_LocalTime -ComputerName $computador

#Exibir o status do serviço
Get-CimInstance -ClassName Win32_Service -ComputerName $computador | Format-Table -Property Status, Name, DisplayName -AutoSize -Wrap
Get-WmiObject -Class Win32_SystemDriver -ComputerName CN04 | Where-Object -FilterScript {$_.State -eq "Running"} | Where-Object -FilterScript {$_.StartMode -eq "Auto"} | Format-Table -Property Name, DisplayName
Get-WmiObject -Class Win32_SystemDriver -ComputerName CN04 | Where-Object -FilterScript { ($_.State -eq 'Running') -and ($_.StartMode -eq 'Manual') } | Format-Table -Property Name, DisplayName

#Espaço em disco do computador
Get-PSDrive -PSProvider FileSystem
[System.IO.DriveInfo]::GetDrives() | Format-Table

#Obter endereço IP do computador
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName $computador | Format-Table -Property IPAddress

#Obter informações da placa de rede
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName $computador
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName CN04 | Select-Object -Property [a-z]* -ExcludeProperty IPX*, WINS*

#Executando ping
Get-WmiObject -Class Win32_PingStatus -Filter "Address='csi.requestia'" -ComputerName CN04 | Format-Table -Property Address, ResponseTime, StatusCode -Autosize
'8.8.8.8', 'csi.requestia.com', 'office.com' | ForEach-Object -Process {Get-WmiObject -Class Win32_PingStatus -Filter ("Address='" + $_ + "'") -ComputerName .} | Select-Object -Property Address, ResponseTime, StatusCode
1..254| ForEach-Object -Process {Get-WmiObject -Class Win32_PingStatus -Filter ("Address='10.0.0." + $_ + "'") -ComputerName .} | Select-Object -Property Address, ResponseTime, StatusCode

#Listando as impressoras instaladas no computador
Get-WmiObject -Class Win32_Printer -ComputerName $computador

#Verificando porta aberta
Test-NetConnection -ComputerName TESOURARIA03 -Port 80

Resolve-DnsName -Name hobrasil.com.br -Type A
Resolve-DnsName -Name hobrasil.com.br -Type MX

#Listando grupos do AD aos quais o usuário pertence
Get-ADPrincipalGroupMembership "sergio.queiroz" | Select Name
Get-ADGroupMember "Domain Admins" | Select Name
Get-ADUser "denise.devigili" -Properties MemberOf | Select -ExpandProperty MemberOf


#Executando o PowerShell como administrador
Start-Process powershell -Verb runAs

#Status do servico Windows Remote Management
Get-Service WinRM

#Habilitando acesso remoto no Firewall
Enable-PSRemoting -Force

# Listando hosts confiáveis
Get-Item WSMan:\localhost\Client\TrustedHosts

#Adicionando computador à lista de hosts confiáveis
winrm s winrm/config/client '@{TrustedHosts="RemoteComputer"}'
#ou
Set-Item WSMan:\localhost\Client\TrustedHosts -value SERGIO.hobrasil


#Efetuar conexão PowerShell remota (Ctrl + Shift + R)
Enter-PSSession -ComputerName ANA -Credential hobrasil\sergio.queiroz

#Reiniciando serviço do WinRM
Restart-Service WinRM

#Inicia o serviço de registro remoto em todos os computadores
Import-Module AzureAD
$Credential = Get-Credential
Connect-AzureAD -Credential $Credential
$Computers = Get-AzureADDevice
foreach ($computer in $computers) {
    if (Test-Connection -count 1 -computer $computer.DisplayName -quiet) {
        Write-Host "Updating system" $computer.DisplayName "....." -ForegroundColor Green
        Set-Service –Name RemoteRegistry –Computer $computer.DisplayName -StartupType Automatic
        Get-Service RemoteRegistry -ComputerName $computer.DisplayName | start-service
    }
    else {
        Write-Host "System Offline " $computer.DisplayName "....." -ForegroundColor Red
        echo $computer.DisplayName #>> C:\scripts\Inventory\offlineRemoteRegStartup.txt
    }
}

Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName `
    $env:computername | Select-Object PSComputername, LastBootUpTime, `
@{Name = "Uptime"; Expression = {(Get-Date) - $_.LastBootUpTime}}

New-PSDrive -Name Docs -PSProvider FileSystem `
    -Root $env:USERPROFILE\documents

$s = "powershell"
$arr = $s.ToCharArray()
$arr[-1.. - $arr.count] -join ""

$s[-1.. - $s.length] -join ""

# Top 5 processes
ps | sort -p ws | select -last 5

# Installed apps
Get-WmiObject -Class Win32_Product -ComputerName . | Format-Wide -Column 1

# IP Address
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Format-Table -Property IPAddress

# More detailed IP Address
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*

# Network cards with DCHP enabled
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=true" -ComputerName .

# Enable DCHCP on all network adapters
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=true -ComputerName . | ForEach-Object -Process {$_.EnableDHCP()}

# Install an MSI package
(Get-WMIObject -ComputerName TARGETMACHINE -List | Where-Object -FilterScript {$_.Name -eq "Win32_Product"}).Install(\\MACHINEWHEREMSIRESIDES\path\package.msi)

# Upgrade an MSI package
(Get-WmiObject -Class Win32_Product -ComputerName . -Filter "Name='name_of_app_to_be_upgraded'").Upgrade(\\MACHINEWHEREMSIRESIDES\path\upgrade_package.msi)

# Remove an MSI package
(Get-WmiObject -Class Win32_Product -Filter "Name='product_to_remove'" -ComputerName . ).Uninstall()

# Add a printer:
(New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\printerserver\hplaser3")

# Remove a printer:
(New-Object -ComObject WScript.Network).RemovePrinterConnection("\\printerserver\hplaser3 ")

function Get-Uptime {

     $os = Get-WmiObject win32_operatingsystem
     $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
     $Display = "" + $Uptime.Days + "days / " + $Uptime.Hours + "hours / " + $Uptime.Minutes + "minutes"
     Write-Output $Display
    }

    function Get-Time {return $(Get-Date | ForEach {$_.ToLongTimeString()})}

     function rdp ($IPAddr) {
     Start-Process -FilePath mstsc -ArgumentList "/admin /w:1024 /h:768 /v:$IPAddr"
    }

Get-Service | Where-Object {$_.Status -eq 'Running'}

Get-ComputerRestorePoint

Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 2 -MaxSamples 3
$DiskReads = "\LogicalDisk(C:)\Disk Reads/sec"
$DiskReads | Get-Counter -Computer Server01, Server02 -MaxSamples 10

Measure-Command { Mount-SPContentDatabase –Name wss_content_portal –WebApplication http://portal.contoso.com }

Get-Process | measure VirtualMemorySize -Sum

# Get events from the security event log
Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    StartTime = (Get-Date).AddHours(-1)
    EndTime = Get-Date
}

#Retrive a list of all log names
Get-WinEvent -ListLog *

ForEach($log in Get-WinEvent -ListLog *){
    Get-WinEvent -FilterHashtable @{
        LogName = $log.LogName
        StartTime = (Get-Date).AddHours(-1)
        EndTime = Get-Date
    }
}

# Installing PowerShell on remote computer
$s = New-PSSession -ComputerName <deviceIP> -Credential administrador
Copy-Item .\PowerShell-6.1.0-win-arm32.zip -Destination U:\Users\Administrator\Donwloads -ToSession $s
Enter-PSSession $s
Set-Location U:\Users\Administrator\Donwloads
.\Install-PowerShellRemoting.ps1 -PowerShellHome .

# Enumerate shares
Get-SmbShare
Get-SmbShare -Special $False
Get-SmbShare -Name C$ | Select-Object -Property *

# Shares from file server
$FileServAD = Get-ADComputer -SearchBase "OU=File Servers,OU=Servers,DC=corp,dc=ad" -Filter * | Select-Object -ExpandProperty Name
Invoke-Command -ComputerName $FileServAD -ScriptBlock {Get-SmbShare -Special $false} | Format-Table -Property Name,Path,Description,PSComputerName