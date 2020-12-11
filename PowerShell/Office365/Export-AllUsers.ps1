. ".\Connect-O365.ps1"
. ".\Get-O365Domains.ps1"
. ".\Get-O365Users.ps1"

# Lists all domains in tenant
$domains = Get-O365Domains

foreach ($domain in $domains) {
    Write-Host "Dominio: $($domain.Name)"
    # Export all active users from domain to O365ActiveUsers-[Domain]-yyyyMMdd.csv
    $Users = Get-O365Users -Domain $domain.Name -Export
}
