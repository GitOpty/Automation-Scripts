function Get-Files {
    param (
        $root,
        $partialFileName
    )
    # Search all files in root directory that matches partial file name
    $files = Get-ChildItem -Path $root -Recurse -File |
    Where-Object {($_.Name -like "*$($partialFileName)*")}
    return $files
}

function Move-Files {
    param (
        $files,
        $region,
        $enterprise,
        $bank,
        $account
    )
    
    foreach ($file in $files) {
        # Format destination path structuring as business rule manner
        $year = $file.LastWriteTime.Year.ToString()
        $month = $file.LastWriteTime.Month.ToString("d2")
    
        $dirName = "$($root)\$($region)\$($enterprise)\$($bank)\$($account)\$($year)\$($month)"
    
        # Creates destination directory if doesn't exists
        if (!(Test-Path $dirName)) {
            New-Item $dirName -ItemType Directory
        }
    
        # Move file
        $file | Move-Item -Destination $dirName
    }
}

$accounts = @(
    @{
        accountNumber = '23884'
        region = 'SUL'
        enterprise = 'LASER'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '23078'
        region = 'SUDESTE'
        enterprise = 'HCLOE'
        bank = 'BRADESCO'
    },
    @{
        accountNumber = '39926'
        region = 'SUL'
        enterprise = 'SADALLA'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '100420'
        region = 'SUL'
        enterprise = 'SADALLA'
        bank = 'BRADESCO'
    },
    @{
        accountNumber = '160156'
        region = 'CENTRO OESTE'
        enterprise = 'TAGUATINGA'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '177644'
        region = 'NORDESTE'
        enterprise = 'RUY CUNHA'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '179493'
        region = 'SUDESTE'
        enterprise = 'HCLOE'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '235202'
        region = 'NORDESTE'
        enterprise = 'EUNAPOLIS'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '510025'
        region = 'NORDESTE'
        enterprise = 'RUY CUNHA'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '943398'
        region = 'CENTRO OESTE'
        enterprise = 'HOB'
        bank = 'BRADESCO'
    },
    @{
        accountNumber = '1137395'
        region = 'NORDESTE'
        enterprise = 'SANTA LUIZ'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '2162423'
        region = 'CENTRO OESTE'
        enterprise = 'INOB'
        bank = 'BRADESCO'
    },
    @{
        accountNumber = '2237709'
        region = 'CENTRO OESTE'
        enterprise = 'TAGUATINGA'
        bank = 'BRADESCO'
    },
    @{
        accountNumber = '130007029'
        region = 'CENTRO OESTE'
        enterprise = 'TAGUATINGA'
        bank = 'SANTANDER'
    },
    @{
        accountNumber = '130008882'
        region = 'CENTRO OESTE'
        enterprise = 'HOB'
        bank = 'SANTANDER'
    },
    @{
        accountNumber = '130015508'
        region = 'SUL'
        enterprise = 'SADALLA'
        bank = 'SANTANDER'
    },
    @{
        accountNumber = '130016583'
        region = 'CENTRO OESTE'
        enterprise = 'INOB'
        bank = 'SANTANDER'
    },
    @{
        accountNumber = '130016590'
        region = 'CENTRO OESTE'
        enterprise = 'HOG-Clinica Oftalmologica'
        bank = 'SANTANDER'
    },
    @{
        accountNumber = '130016617'
        region = 'CENTRO OESTE'
        enterprise = 'Allvision'
        bank = 'SANTANDER'
    },
    @{
        accountNumber = '130067143'
        region = 'CENTRO OESTE'
        enterprise = 'CONTACT GEL'
        bank = 'SANTANDER'
    },
    @{
        accountNumber = '20739X'
        region = 'SUL'
        enterprise = 'IPC'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '215000X'
        region = 'CENTRO OESTE'
        enterprise = 'HOB'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '40053X'
        region = 'NORDESTE'
        enterprise = 'Instituto de Olhos'
        bank = 'BANCO DO BRASIL'
    },
    @{
        accountNumber = '405847X'
        region = 'CENTRO OESTE'
        enterprise = 'INOB'
        bank = 'BANCO DO BRASIL'
    }
    

)

foreach ($account in $accounts) {
    $account | ForEach-Object {
        $allFiles = Get-Files -root 'C:\inbox2' -partialFileName $_.accountNumber
        Move-Files -files $allFiles -region $_.region -enterprise $_.enterprise -bank $_.bank -account $_.accountNumber
    }
}





