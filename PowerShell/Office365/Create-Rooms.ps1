################################################################################
#  Script: create-rooms.ps1
#  Description:*** RUN THIS SCRIPT FROM A WINDOWS POWERSHELL SESSION ***
#This script creates es in Office 365.
# Syntax:Create-Rooms.ps1 -inputfile "file name.csv"
#
# Dependencies: Input file should contain 3 columns: RoomName, RoomSMTPAddress, RoomCapacity
#
################################################################################
param( $inputFile )
Function Usage
{
$strScriptFileName = ($MyInvocation.ScriptName).substring(($MyInvocation.ScriptName).lastindexofany("\") + 1).ToString()
@"
NAME:
$strScriptFileName
EXAMPLE:
C:\PS> .\$strScriptFileName -inputfile `"file name.csv`"
"@
}
If (-not $inputFile) {Usage;Exit}
#Get MSO creds and initialize session
If ($cred -eq $NULL) {$Global:cred = Get-Credential}
#
If ($ExchRemoteCmdlets.AccessMode -ne "ReadWrite")
{
Write-Host
Write-Host Connecting to Office 365...
Write-Host
$NewSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -Authentication Basic -AllowRedirection
$Global:ExchRemoteCmdlets = Import-PSSession $NewSession
}
#Import the CSV file
$csv = Import-CSV $inputfile
#Create Rooms contained in the CSV file
$csv | foreach-object{
New-mailbox -Name $_.RoomName -room -primarysmtpaddress $_.RoomSMTPAddress -resourcecapacity $_.RoomCapacity
}
##### END OF CREATE-ROOMS.PS1