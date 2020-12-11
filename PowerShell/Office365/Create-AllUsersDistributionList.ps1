. ".\Connect-O365.ps1"
. ".\Get-O365Domains.ps1"
. ".\Get-O365Users.ps1"
. ".\Connect-Exchange.ps1" # Function for manipulate distribution groups is unavailable with Connect-MsolService

# Checks if super mail distribution lists already exists
$DistributionList = Get-DistributionGroup -Identity "Somos Opty" -ErrorAction SilentlyContinue
If ($DistributionList){
    Remove-DistributionGroup -Identity "Somos Opty" -Confirm:$false
}

# Creates super mail distribution list
New-DistributionGroup -Name "Somos Opty" -Alias 'somosopty' -PrimarySmtpAddress 'somosopty@opty.com.br'

# Lists all domains in tenant
$domains = Get-O365Domains

foreach ($domain in $domains) {
    Write-Host "Dominio: $($domain.Name)"
    If ($domain.Name -eq 'corpoclinico.opty.com.br'){
        $ListIdentity = "Oftalmologistas"
        $ListAlias = 'oftalmologistas'
        $ListAddress = "oftalmologistas@$($domain.Name)"
    } else {
        $ListIdentity = "Colaboradores $($domain.Name)"
        $ListAlias = 'colaboradores'
        $ListAddress = "colaboradores@$($domain.Name)"
    }
    Write-Host "Lista: $ListAddress"

    # Checks if mail distribution lists already exists
    $DistributionList = Get-DistributionGroup -Identity $ListIdentity -ErrorAction SilentlyContinue
    If ($DistributionList){
        Remove-DistributionGroup -Identity $ListIdentity -Confirm:$false
    }

    # Creates mail distribution list
    New-DistributionGroup -Name $ListIdentity -Alias $ListAlias -PrimarySmtpAddress $ListAddress #-Members $members

    # Lists all active users from domain
    $Users = Get-O365Users -Domain $domain.Name

    # Add member in mail distribution list
    $Users | ForEach-Object -Process {
        Write-Host "Lista: $ListAddress - Membro: $($_.UserPrincipalName)"
        Add-DistributionGroupMember -Identity $ListIdentity -Member $_.UserPrincipalName
    }

    # Add list to super mail distribution list
    Add-DistributionGroupMember -Identity "Somos Opty" -Member $ListAddress

}

If ($Session) {Remove-PSSession $Session}