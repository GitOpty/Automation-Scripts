Function Get-O365Domains {
    $Domains = Get-MsolDomain
    Return $Domains | Sort-Object -Property Name
}

#. .\Connect-O365.ps1