Import-Module ActiveDirectory
Get-ADComputer
Connect-AzureAD
Get-AzureADDevice -All $true | Sort-Object DisplayName
Get-AzureADDevice -Filter DeviceOSType -Like '*Windows*' | Sort-Object DisplayName
Get-AzureADDevice -ObjectId "d8f3a3a0-f21f-402f-839d-30e9bcad417a" | fl


# Gets time stamps for all computers in the domain that have NOT logged in since after specified date
# Mod by Tilo 2013-08-27
import-module activedirectory 
$domain = "hobrasil.local" 
$DaysInactive = 90 
$time = (Get-Date).Adddays( - ($DaysInactive))
 
# Get all AD computers with lastLogonTimestamp less than our time
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp |
 
# Output hostname and lastLogonTimestamp into CSV
select-object Name, @{Name = "Stamp"; Expression = {[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv OLD_Computer.csv -notypeinformation




$30DaysAgo = (Get-Date).AddDays(-30)

$Computers = @("SERGIO")

$ReliabilityStabilityMetrics = Get-CimInstance -ClassName win32_reliabilitystabilitymetrics -filter "TimeGenerated > '$30DaysAgo'" -ComputerName $Computers | Select-Object PSComputerName, SystemStabilityIndex, TimeGenerated

$ReliabilityRecords = Get-CimInstance -ClassName win32_reliabilityRecords -filter "TimeGenerated > '$30DaysAgo'" -ComputerName $Computers | Select-Object PSComputerName, EventIdentifier, LogFile, Message, ProductName, RecordNumber, SourceName, TimeGenerated

$ReliabilityStabilityMetrics | Export-CSV $env:USERPROFILE\Documents\ReliabilityStabilityMetrics.csv -Encoding ASCII -Delimiter ';' -NoTypeInformation
$ReliabilityRecords | Export-CSV $env:USERPROFILE\Documents\ReliabilityRecords.csv -Encoding ASCII -Delimiter ';' -NoTypeInformation