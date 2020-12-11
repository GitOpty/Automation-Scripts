Function Start-Pinging ($FilePath) {
    $InputFile = Import-Csv -Path $FilePath
    $InputFile = '10.47.0.1'
    $ping = New-Object System.Net.Networkinformation.Ping
    $timeout = 2
	
    $Results = Foreach ($i in $InputFile) {
        $PingResults = $ping.Send($i.IPAddress, $timeout)
        $PingResults = $ping.Send('10.47.0.1', $timeout)
        If ($PingResults.status -eq "success") {
            $status = "up"
            #$hostname = ([system.net.dns]::GetHostByAddress($i.IPAddress)).hostname
            $hostname = ([system.net.dns]::GetHostByAddress('10.47.0.1')).hostname
        }
        Else {
            $status = "down"
            $hostname = $null
        }
		
        [pscustomobject][ordered]@{
            "IP Address" = '10.47.2.154'#$i.IPAddress
            Hostname     = $hostname
            Status       = $status
        }
    }

    $results | Export-Csv -Path "PathToDestinationFile.csv" -NoTypeInformation
}

# List all computers in domain
Get-ADComputer -Server 10.47.250.4 -Filter * -Properties * | Select-Object Name, CanonicalName, DistinguishedName, DNSHostName, OperatingSystem, LastLogonDate

# Create a local administrator account
$Username = "CSI.Tecnologia"
$Password = ConvertTo-SecureString "pwd@0pty" -AsPlainText -Force

$adsi = [ADSI]"WinNT://$env:TESOURARIA03"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    New-LocalUser $Username -Password $Password -FullName "CSI Tecnologia" -Description "Administrador local CSI" -AccountNeverExpires -PasswordNeverExpires
}
else {
    Write-Host "Setting password for existing local user $Username."
    $UserAccount = Get-LocalUser -Name $Username
    $UserAccount | Set-LocalUser -Password $Password -AccountNeverExpires -PasswordNeverExpires
}
Add-LocalGroupMember -Group "Administradores" -Member $Username
