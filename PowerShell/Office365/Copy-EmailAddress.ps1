##########################################################################
# Script: showproxies.ps1
# Copies all accounts in Office 365 that contain/don't contain a specific
# proxyaddress to a .CSV file (addresses.csv)
#
# Change the following variable to the proxy address string you want to find:
# $proxyaddr = "onmicrosoft.com"
################################################################################
$proxyaddr = "onmicrosoft.com"
# Create an object to hold the results
$addresses = @()
# Get every mailbox in the Exchange Organisation
$Mailboxes = Get-Mailbox -ResultSize Unlimited
# Loop through the mailboxes
ForEach ($mbx in $Mailboxes) {
    # Loop through every address assigned to the mailbox
    Foreach ($address in $mbx.EmailAddresses) {
       # If it contains XXX,  Record it
        if ($address.ToString().ToLower().contains($proxyaddr)) {
            # This is an email address. Add it to the list
            $obj = "" | Select-Object Alias,EmailAddress
            $obj.Alias = $mbx.Alias
            $obj.EmailAddress = $address.ToString() #.SubString(10)
            $addresses += $obj
      }
    }
}
# Export the final object to a csv in the working directory

$addresses | Export-Csv addresses.csv -NoTypeInformation
# Open the csv with the default handler
Invoke-Item addresses.csv

##### END OF SHOWPROXIES.PS1