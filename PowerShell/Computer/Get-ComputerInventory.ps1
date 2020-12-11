# Resultado final com todos os dados coletados
$Result = @()

# Busca todos os computadores do Active Directory
$Date = [DateTime]::Today.AddDays(-45)
$Computers = Get-ADComputer -Filter 'LastLogonDate -ge $Date' -Properties Name, DistinguishedName, IPv4Address, LastLogonDate, PasswordLastSet

ForEach ($Computer in $Computers) {

    # Limpa dados
    $TeamviewerID = ''
    $User = ''
    $Tag = ''
    $Win32_Processor = ''
    $Win32_ComputerSystem = ''
    $Win32_LogicalDisk = ''
    $UpTime = ''

    #Write-Host "Tentando conectar a $($Computer.Name) ..."
    If (Test-Connection $Computer.Name -Quiet) {
        # Obtem o ID do TeamViewer
        $TeamviewerID = Get-TeamViewerID -Hostname $Computer.Name

        # Ultimo usuario que logou
        $User = (Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName -ComputerName $Computer.Name).UserName

        # Tag Dell
        $Tag = (Get-CimInstance Win32_Bios -ComputerName $Computer.Name).SerialNumber

        # Processador
        $Win32_Processor = (Get-CimInstance Win32_Processor -ComputerName $Computer.Name).Name

        # Fabricante e memória
        $Win32_ComputerSystem = Get-CimInstance -Class Win32_ComputerSystem -ComputerName $Computer.Name | `
            Select-Object Manufacturer, `
            Model, `
        @{Expression = {$_.TotalPhysicalMemory / 1GB}; Label = "MemoryGB"}

        # Disco
        $Win32_LogicalDisk = (Get-CimInstance -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $Computer.Name).Size / 1GB

        # Endereço IP
        $IPAddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName $Computer.Name).IPAddress[0]

        # Tempo ligada
        $Win32_OperatingSystem = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer.Name
        $UpTime = (Get-Date) - ($Win32_OperatingSystem.ConvertToDateTime($Win32_OperatingSystem.LastBootupTime))

        # Tamanho total da pasta de usuários
        # Get-ChildItem -Path \\OCT14\c$\Users -Recurse -File | Measure-Object -Property Length -Sum
    }

    # Organizando as informacoes, preservando a ordem das propriedades
    # (https://adamtheautomator.com/powershell-tutorial-mini-course)
    $ResultItem = [ordered] @{
        Nome         = $Computer.Name
        TeamviewerID = $TeamviewerID
        ADQuery      = $Computer.DistinguishedName
        IP           = $IPAddress
        UltimoLogon  = $Computer.LastLogonDate
        Usuario      = $User
        Tag          = $Tag
        Processador  = $Win32_Processor
        Fabricante   = $Win32_ComputerSystem.Manufacturer
        Modelo       = $Win32_ComputerSystem.Model
        MemoriaGB    = $Win32_ComputerSystem.MemoryGB
        DiscoGB      = $Win32_LogicalDisk
        TempoLigada  = "" + $UpTime.Days + " dias " + $UpTime.Hours + " horas " + $UpTime.Minutes + " minutos"
    }
    [PSCustomObject] $ResultItem
    # Write-Host $ResultItem | Format-Table
    $Result += $ResultItem
}

$CSVFilename = "InventarioDominio-" + (Get-Date -Format "yyyyMMdd") + ".csv"
$Result | Export-Csv -Path $CSVFilename -Encoding UTF8 -Delimiter ";" -NoTypeInformation

# Obtem o ID do Teamviewer, a partir do registro do Windows
Function Get-TeamViewerID {

    param(
        [string] $Hostname,
        [switch] $Copy
    )


    #Variables
    $Target = $Hostname
    If (!$Target) {$Target = $env:COMPUTERNAME}


    #Start Remote Registry Service
    If ($Target -ne $env:COMPUTERNAME) {
        $Service = Get-Service -Name "Remote Registry" -ComputerName $Target -ErrorAction SilentlyContinue
        $Service.Start()
    }


    #Suppresses errors (comment to disable error suppression)
    $ErrorActionPreference = "SilentlyContinue"


    #Attempts to pull clientID value from remote registry and display it if successful
    $RegCon = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Target)
    $RegKey = $RegCon.OpenSubKey("SOFTWARE\\WOW6432Node\\TeamViewer")
    $ClientID = $RegKey.GetValue("clientID")


    #If previous attempt was unsuccessful, attempts the same from a different location
    If (!$clientid) {
        $RegKey = $RegCon.OpenSubKey("SOFTWARE\\WOW6432Node\\TeamViewer\Version9")
        $ClientID = $RegKey.GetValue("clientID")
    }


    #If previous attempt was unsuccessful, attempts the same from a different location
    If (!$clientid) {
        $RegKey = $RegCon.OpenSubKey("SOFTWARE\\TeamViewer")
        $ClientID = $RegKey.GetValue("clientID")
    }


    #Stop Remote Registry service
    If ($Target -ne $env:COMPUTERNAME) {
        $Service.Stop()
    }


    #Display results
    Write-Host
    If (!$clientid) {Write-Host "ERROR: Unable to retrieve clientID value via remote registry!" -ForegroundColor Red}
    Else {Write-Host "TeamViewer client ID for $Target is $Clientid." -ForegroundColor Yellow}
    Write-Host


    #Copy to clipboard
    If ($copy -and $ClientID) {$ClientID | clip}
    return $ClientID
}