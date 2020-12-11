# Source: https://kevinmarquette.github.io/2017-04-22-Powershell-installing-remote-software/
$server_folder = '\\10.47.250.4\netlogon\Instaladores\TeamViewer_v13.2'
$installer_file = "TeamViewer.msi"
$installer = "$server_folder\$installer_file"

$register_file = "TeamViewer_Settings.reg"
$register = "$server_folder\$register_file"

$target_computer = 'TESOURARIA03'
$session = New-PSSession -ComputerName $target_computer

Copy-Item -Path $installer -ToSession $session -Destination "C:\Windows\Temp\$installer_file"
Copy-Item -Path $register -ToSession $session -Destination "C:\Windows\Temp\$register_file"


Invoke-Command -Session $session -ScriptBlock {
    Get-Package -Provider Programs -IncludeWindowsInstaller
}
Remove-PSSession $session


# Source: https://blogs.technet.microsoft.com/packagemanagement/2015/04/28/introducing-packagemanagement-in-windows-10/
# Explorando o Gerenciador de Pacotes do Windows 10
Get-Command -Module PackageManagement | Sort-Object Noun, Verb

# Descobrindo pacotes
Find-Package -Name PSReadline -AllVersions

# Instalando pacotes
Install-Package PSReadline -MinimumVersion 1.0.0.13

# Inventário de programas instalados
Get-Package -Provider Programs -IncludeWindowsInstaller