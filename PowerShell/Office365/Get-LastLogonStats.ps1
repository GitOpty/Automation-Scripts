################################################################################################################################################################
# Script accepts 3 parameters from the command line
#
# Office365Username - Mandatory - Administrator login ID for the tenant we are querying
# Office365Password - Mandatory - Administrator login password for the tenant we are querying
# UserIDFile - Optional - Path and File name of file full of UserPrincipalNames we want the Last Logon Dates for.  Seperated by New Line, no header.
#
#
# To run the script
#
# .\Get-LastLogonStats.ps1 -Office365Username admin@xxxxxx.onmicrosoft.com -Office365Password Password123 -InputFile c:\Files\InputFile.txt
#
# NOTE: If you do not pass an input file to the script, it will return the last logon time of ALL mailboxes in the tenant.  Not advisable for tenants with large
# user count (< 3,000)
#
# Author: 				Alan Byrne
# Version: 				1.0
# Last Modified Date: 	16/08/2012
# Last Modified By: 	Alan Byrne
################################################################################################################################################################

#Accept input parameters
Param(
    [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
    [string] $Office365Username,
    [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
    [string] $Office365Password,
    [Parameter(Position = 2, Mandatory = $false, ValueFromPipeline = $true)]
    [string] $UserIDFile
)

.\Connect-O365.ps1
.\Connect-Exchange.ps1
# $Office365Username = 'sergio.queiroz@opty.com.br'
# $Office365Password = 'uW%8C7Ot'
#Constant Variables
$OutputFile = "LastLogonDate.csv"   #The CSV Output file that is created, change for your purposes


#Main
Function Main {

    #Remove all existing Powershell sessions
    Get-PSSession | Remove-PSSession

    #Call ConnectTo-ExchangeOnline function with correct credentials
    ConnectTo-ExchangeOnline -Office365AdminUsername $Office365Username -Office365AdminPassword $Office365Password

    #Prepare Output file with headers
    Out-File -FilePath $OutputFile -InputObject "UserPrincipalName,LastLogonDate" -Encoding UTF8

    #Check if we have been passed an input file path
    if ($userIDFile -ne "") {
        #We have an input file, read it into memory
        $objUsers = import-csv -Header "UserPrincipalName" $UserIDFile
    }
    else {
        #No input file found, gather all mailboxes from Office 365
        $objUsers = get-mailbox -ResultSize Unlimited | select UserPrincipalName
    }

    #Iterate through all users
    Foreach ($objUser in $objUsers) {
        #Connect to the users mailbox
        $objUserMailbox = get-mailboxstatistics -Identity $($objUser.UserPrincipalName) | Select LastLogonTime

        #Prepare UserPrincipalName variable
        $strUserPrincipalName = $objUser.UserPrincipalName

        #Check if they have a last logon time. Users who have never logged in do not have this property
        if ($objUserMailbox.LastLogonTime -eq $null) {
            #Never logged in, update Last Logon Variable
            $strLastLogonTime = "Never Logged In"
        }
        else {
            #Update last logon variable with data from Office 365
            $strLastLogonTime = $objUserMailbox.LastLogonTime
        }

        #Output result to screen for debuging (Uncomment to use)
        #write-host "$strUserPrincipalName : $strLastLogonTime"

        #Prepare the user details in CSV format for writing to file
        $strUserDetails = "$strUserPrincipalName,$strLastLogonTime"

        #Append the data to file
        Out-File -FilePath $OutputFile -InputObject $strUserDetails -Encoding UTF8 -append
    }

    #Clean up session
    Get-PSSession | Remove-PSSession
}

###############################################################################
#
# Function ConnectTo-ExchangeOnline
#
# PURPOSE
#    Connects to Exchange Online Remote PowerShell using the tenant credentials
#
# INPUT
#    Tenant Admin username and password.
#
# RETURN
#    None.
#
###############################################################################
function ConnectTo-ExchangeOnline {
    Param(
        [Parameter(
            Mandatory = $true,
            Position = 0)]
        [String]$Office365AdminUsername,
        [Parameter(
            Mandatory = $true,
            Position = 1)]
        [String]$Office365AdminPassword

    )

    #Encrypt password for transmission to Office365
    $SecureOffice365Password = ConvertTo-SecureString -AsPlainText $Office365Password -Force

    #Build credentials object
    $Office365Credentials = New-Object System.Management.Automation.PSCredential $Office365Username, $SecureOffice365Password

    #Create remote Powershell session
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Office365credentials -Authentication Basic -AllowRedirection

    #Import the session
    Import-PSSession $Session -AllowClobber | Out-Null
}


# Start script
. Main


$Users = Import-Csv -Path '.\LastUsers.csv' -Delimiter ';'

$Sku = @{
    "O365_BUSINESS_ESSENTIALS"           = "Office 365 Business Essentials"
    "O365_BUSINESS_PREMIUM"              = "Office 365 Business Premium"
    "SPE_F1"                             = "Microsoft 365 F1"
    "DESKLESSPACK"                       = "Office 365 F1"
    "DESKLESSWOFFPACK"                   = "Office 365 (Plan K2)"
    "LITEPACK"                           = "Office 365 (Plan P1)"
    "EXCHANGESTANDARD"                   = "Office 365 Exchange Online Only"
    "STANDARDPACK"                       = "Enterprise Plan E1"
    "STANDARDWOFFPACK"                   = "Office 365 (Plan E2)"
    "ENTERPRISEPACK"                     = "Enterprise Plan E3"
    "ENTERPRISEPACKLRG"                  = "Enterprise Plan E3"
    "ENTERPRISEWITHSCAL"                 = "Enterprise Plan E4"
    "STANDARDPACK_STUDENT"               = "Office 365 (Plan A1) for Students"
    "STANDARDWOFFPACKPACK_STUDENT"       = "Office 365 (Plan A2) for Students"
    "ENTERPRISEPACK_STUDENT"             = "Office 365 (Plan A3) for Students"
    "ENTERPRISEWITHSCAL_STUDENT"         = "Office 365 (Plan A4) for Students"
    "STANDARDPACK_FACULTY"               = "Office 365 (Plan A1) for Faculty"
    "STANDARDWOFFPACKPACK_FACULTY"       = "Office 365 (Plan A2) for Faculty"
    "ENTERPRISEPACK_FACULTY"             = "Office 365 (Plan A3) for Faculty"
    "ENTERPRISEWITHSCAL_FACULTY"         = "Office 365 (Plan A4) for Faculty"
    "ENTERPRISEPACK_B_PILOT"             = "Office 365 (Enterprise Preview)"
    "STANDARD_B_PILOT"                   = "Office 365 (Small Business Preview)"
    "VISIOCLIENT"                        = "Visio Pro Online"
    "POWER_BI_ADDON"                     = "Office 365 Power BI Addon"
    "POWER_BI_INDIVIDUAL_USE"            = "Power BI Individual User"
    "POWER_BI_STANDALONE"                = "Power BI Stand Alone"
    "POWER_BI_STANDARD"                  = "Power-BI Standard"
    "PROJECTESSENTIALS"                  = "Project Lite"
    "PROJECTCLIENT"                      = "Project Professional"
    "PROJECTONLINE_PLAN_1"               = "Project Online"
    "PROJECTONLINE_PLAN_2"               = "Project Online and PRO"
    "ProjectPremium"                     = "Project Online Premium"
    "ECAL_SERVICES"                      = "ECAL"
    "EMS"                                = "Enterprise Mobility Suite"
    "RIGHTSMANAGEMENT_ADHOC"             = "Windows Azure Rights Management"
    "MCOMEETADV"                         = "PSTN conferencing"
    "SHAREPOINTSTORAGE"                  = "SharePoint storage"
    "PLANNERSTANDALONE"                  = "Planner Standalone"
    "CRMIUR"                             = "CMRIUR"
    "BI_AZURE_P1"                        = "Power BI Reporting and Analytics"
    "INTUNE_A"                           = "Windows Intune Plan A"
    "PROJECTWORKMANAGEMENT"              = "Office 365 Planner Preview"
    "ATP_ENTERPRISE"                     = "Exchange Online Advanced Threat Protection"
    "EQUIVIO_ANALYTICS"                  = "Office 365 Advanced eDiscovery"
    "AAD_BASIC"                          = "Azure Active Directory Basic"
    "RMS_S_ENTERPRISE"                   = "Azure Active Directory Rights Management"
    "AAD_PREMIUM"                        = "Azure Active Directory Premium"
    "MFA_PREMIUM"                        = "Azure Multi-Factor Authentication"
    "STANDARDPACK_GOV"                   = "Microsoft Office 365 (Plan G1) for Government"
    "STANDARDWOFFPACK_GOV"               = "Microsoft Office 365 (Plan G2) for Government"
    "ENTERPRISEPACK_GOV"                 = "Microsoft Office 365 (Plan G3) for Government"
    "ENTERPRISEWITHSCAL_GOV"             = "Microsoft Office 365 (Plan G4) for Government"
    "DESKLESSPACK_GOV"                   = "Microsoft Office 365 (Plan K1) for Government"
    "ESKLESSWOFFPACK_GOV"                = "Microsoft Office 365 (Plan K2) for Government"
    "EXCHANGESTANDARD_GOV"               = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
    "EXCHANGEENTERPRISE_GOV"             = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
    "SHAREPOINTDESKLESS_GOV"             = "SharePoint Online Kiosk"
    "EXCHANGE_S_DESKLESS_GOV"            = "Exchange Kiosk"
    "RMS_S_ENTERPRISE_GOV"               = "Windows Azure Active Directory Rights Management"
    "OFFICESUBSCRIPTION_GOV"             = "Office ProPlus"
    "MCOSTANDARD_GOV"                    = "Lync Plan 2G"
    "SHAREPOINTWAC_GOV"                  = "Office Online for Government"
    "SHAREPOINTENTERPRISE_GOV"           = "SharePoint Plan 2G"
    "EXCHANGE_S_ENTERPRISE_GOV"          = "Exchange Plan 2G"
    "EXCHANGE_S_ARCHIVE_ADDON_GOV"       = "Exchange Online Archiving"
    "EXCHANGE_S_DESKLESS"                = "Exchange Online Kiosk"
    "SHAREPOINTDESKLESS"                 = "SharePoint Online Kiosk"
    "SHAREPOINTWAC"                      = "Office Online"
    "YAMMER_ENTERPRISE"                  = "Yammer for the Starship Enterprise"
    "EXCHANGE_L_STANDARD"                = "Exchange Online (Plan 1)"
    "MCOLITE"                            = "Lync Online (Plan 1)"
    "SHAREPOINTLITE"                     = "SharePoint Online (Plan 1)"
    "OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ" = "Office ProPlus"
    "EXCHANGE_S_STANDARD_MIDMARKET"      = "Exchange Online (Plan 1)"
    "MCOSTANDARD_MIDMARKET"              = "Lync Online (Plan 1)"
    "SHAREPOINTENTERPRISE_MIDMARKET"     = "SharePoint Online (Plan 1)"
    "OFFICESUBSCRIPTION"                 = "Office ProPlus"
    "YAMMER_MIDSIZE"                     = "Yammer"
    "DYN365_ENTERPRISE_PLAN1"            = "Dynamics 365 Customer Engagement Plan Enterprise Edition"
    "ENTERPRISEPREMIUM_NOPSTNCONF"       = "Enterprise E5 (without Audio Conferencing)"
    "ENTERPRISEPREMIUM"                  = "Enterprise E5 (with Audio Conferencing)"
    "MCOSTANDARD"                        = "Skype for Business Online Standalone Plan 2"
    "PROJECT_MADEIRA_PREVIEW_IW_SKU"     = "Dynamics 365 for Financials for IWs"
    "STANDARDWOFFPACK_IW_STUDENT"        = "Office 365 Education for Students"
    "STANDARDWOFFPACK_IW_FACULTY"        = "Office 365 Education for Faculty"
    "EOP_ENTERPRISE_FACULTY"             = "Exchange Online Protection for Faculty"
    "EXCHANGESTANDARD_STUDENT"           = "Exchange Online (Plan 1) for Students"
    "OFFICESUBSCRIPTION_STUDENT"         = "Office ProPlus Student Benefit"
    "STANDARDWOFFPACK_FACULTY"           = "Office 365 Education E1 for Faculty"
    "STANDARDWOFFPACK_STUDENT"           = "Microsoft Office 365 (Plan A2) for Students"
    "DYN365_FINANCIALS_BUSINESS_SKU"     = "Dynamics 365 for Financials Business Edition"
    "DYN365_FINANCIALS_TEAM_MEMBERS_SKU" = "Dynamics 365 for Team Members Business Edition"
    "FLOW_FREE"                          = "Microsoft Flow Free"
    "POWER_BI_PRO"                       = "Power BI Pro"
    "O365_BUSINESS"                      = "Office 365 Business"
    "DYN365_ENTERPRISE_SALES"            = "Dynamics Office 365 Enterprise Sales"
    "RIGHTSMANAGEMENT"                   = "Rights Management"
    "PROJECTPROFESSIONAL"                = "Project Professional"
    "VISIOONLINE_PLAN1"                  = "Visio Online Plan 1"
    "EXCHANGEENTERPRISE"                 = "Exchange Online Plan 2"
    "DYN365_ENTERPRISE_P1_IW"            = "Dynamics 365 P1 Trial for Information Workers"
    "DYN365_ENTERPRISE_TEAM_MEMBERS"     = "Dynamics 365 For Team Members Enterprise Edition"
    "CRMSTANDARD"                        = "Microsoft Dynamics CRM Online Professional"
    "EXCHANGEARCHIVE_ADDON"              = "Exchange Online Archiving For Exchange Online"
    "EXCHANGEDESKLESS"                   = "Exchange Online Kiosk"
    "SPZA_IW"                            = "App Connect"
    "WINDOWS_STORE"                      = "Windows Store for Business"
    "MCOEV"                              = "Microsoft Phone System"
    "VIDEO_INTEROP"                      = "Polycom Skype Meeting Video Interop for Skype for Business"
    "SPE_E5"                             = "Microsoft 365 E5"
    "SPE_E3"                             = "Microsoft 365 E3"
    "ATA"                                = "Advanced Threat Analytics"
    "MCOPSTN2"                           = "Domestic and International Calling Plan"
    "FLOW_P1"                            = "Microsoft Flow Plan 1"
    "FLOW_P2"                            = "Microsoft Flow Plan 2"
}

$LicenseList = @()
ForEach ($Usuario in $Users) {
    $User = Get-MsolUser -UserPrincipalName palomafernandes@dayhorc.com.br
    If ($User.Licenses.AccountSkuId -ne $null) {
        $User.Licenses.AccountSkuId | `
            ForEach-Object -Process {
            $LicenseItem = $_ -split ":" | Select-Object -Last 1
            $LicenseName = $Sku.Item("$LicenseItem")
            $License = New-Object -TypeName PSObject -Property @{
                UserPrincipalName = $User.UserPrincipalName
                Name              = $User.DisplayName
                LicenseItem       = $LicenseName
            }
            $LicenseList += $License
        }
    }
	$LicenseList
}
Out-File -FilePath 'LastUserLicense.csv' -InputObject $LicenseList -Encoding UTF8 