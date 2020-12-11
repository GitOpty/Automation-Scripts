##########################################################################
#      Script:  remove-proxy.ps1
#Description:*** RUN THIS SCRIPT FROM A WINDOWS POWERSHELL SESSION ***
#This script will remove a secondary email address from many users
#
# Syntax:remove-proxy.ps1 -inputfile "filename.csv"
#
# Dependencies:Input file should contain 2 columns: Username, Emailsuffix
#               Example:  Username=tim, Emailsuffix=fabrikam.com
#Script will remove the address tim@fabrikam.com from the mailbox for Tim.
#NOTE: Address must be secondary; it will not remove primary email address.
#
################################################################################
param( $inputFile )
Function Usage
{
$strScriptFileName = ($MyInvocation.ScriptName).substring(($MyInvocation.ScriptName).lastindexofany
("\") + 1).ToString()
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
$NewSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri
https://ps.outlook.com/powershell -Credential $cred -Authentication Basic -AllowRedirection
$Global:ExchRemoteCmdlets = Import-PSSession $NewSession
}
#Import the CSV file and change primary smtp address
$csv = Import-CSV $inputfile
$csv | foreach-object{
# Set variable for email address to remove
$removeaddr = $_.username + "@" + $_.emailsuffix
Write-Host ("Processing User: " + $_.UserName +" - Removing " + $removeaddr)
Set-Mailbox $_.Username -EmailAddresses @{Remove=$removeaddr}
}
##### END OF REMOVE-PROXY.PS1