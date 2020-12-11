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
        accountNumber = '2212-0'
        region = 'Sul'
        enterprise = 'Sadalla'
        bank = 'CEF'
    },

@{
        accountNumber = '3992-6'
        region = 'Sul'
        enterprise = 'Sadalla'
        bank = 'BB'
    },

@{
        accountNumber = '10042-0'
        region = 'Sul'
        enterprise = 'Sadalla'
        bank = 'Bradesco'
    },

@{
        accountNumber = '130596-4'
        region = 'Sul'
        enterprise = 'Sadalla'
        bank = 'Bradesco'
    },

@{
        accountNumber = '13001550-8'
        region = 'Sul'
        enterprise = 'Sadalla'
        bank = 'Santander'
    },

@{
        accountNumber = '20739-X'
        region = 'Sul'
        enterprise = 'IPC'
        bank = 'BB'
    },

@{
        accountNumber = '13065250-2'
        region = 'Sul'
        enterprise = 'Jaraguá'
        bank = 'Santander'
    },

@{
        accountNumber = '2388-4'
        region = 'Sul'
        enterprise = 'Laser'
        bank = 'BB'
    },

@{
        accountNumber = '13065289-4'
        region = 'Sul'
        enterprise = 'Yoshii'
        bank = 'Santander'
    },

@{
        accountNumber = '644-0'
        region = 'Sul'
        enterprise = 'Yoshii'
        bank = 'Bradesco'
    },

@{
        accountNumber = '51527-2'
        region = 'Sul'
        enterprise = 'Yoshii'
        bank = 'Unicred'
    },

@{
        accountNumber = '13004348-3'
        region = 'Centro Oeste'
        enterprise = 'Clínicas do Brasil'
        bank = 'Santander'
    },

@{
        accountNumber = '13006714-3'
        region = 'Centro Oeste'
        enterprise = 'CTG'
        bank = 'Santander'
    },

@{
        accountNumber = '215000-X'
        region = 'Centro Oeste'
        enterprise = 'HOB'
        bank = 'BB'
    },

@{
        accountNumber = '94339-8'
        region = 'Centro Oeste'
        enterprise = 'HOB'
        bank = 'Bradesco'
    },

@{
        accountNumber = '604546-1'
        region = 'Centro Oeste'
        enterprise = 'HOB'
        bank = 'BRB'
    },

@{
        accountNumber = '2621-9'
        region = 'Centro Oeste'
        enterprise = 'HOB'
        bank = 'CEF'
    },

@{
        accountNumber = '45777-2'
        region = 'Centro Oeste'
        enterprise = 'HOB'
        bank = 'Itaú'
    },

@{
        accountNumber = '13000888-2'
        region = 'Centro Oeste'
        enterprise = 'HOB'
        bank = 'Santander'
    },

@{
        accountNumber = '113652-6'
        region = 'Centro Oeste'
        enterprise = 'HOB'
        bank = 'Sicoob'
    },

@{
        accountNumber = '13000702-9'
        region = 'Centro Oeste'
        enterprise = 'HOB-TGA'
        bank = 'Santander'
    },

@{
        accountNumber = '9933-3'
        region = 'Centro Oeste'
        enterprise = 'HOG'
        bank = 'Bradesco'
    },

@{
        accountNumber = '5669-0'
        region = 'Centro Oeste'
        enterprise = 'HOG'
        bank = 'BRB'
    },

@{
        accountNumber = '1926-5'
        region = 'Centro Oeste'
        enterprise = 'HOG'
        bank = 'CEF'
    },

@{
        accountNumber = '13001659-0'
        region = 'Centro Oeste'
        enterprise = 'HOG'
        bank = 'Santander'
    },

@{
        accountNumber = '116594-1'
        region = 'Centro Oeste'
        enterprise = 'HOG'
        bank = 'Sicoob'
    },

@{
        accountNumber = '405847-X'
        region = 'Centro Oeste'
        enterprise = 'Inob'
        bank = 'BB'
    },

@{
        accountNumber = '216242-3'
        region = 'Centro Oeste'
        enterprise = 'Inob'
        bank = 'Bradesco'
    },

@{
        accountNumber = '600076-9'
        region = 'Centro Oeste'
        enterprise = 'Inob'
        bank = 'BRB'
    },

@{
        accountNumber = '50883-5'
        region = 'Centro Oeste'
        enterprise = 'Inob'
        bank = 'CEF'
    },

@{
        accountNumber = '13001658-3'
        region = 'Centro Oeste'
        enterprise = 'Inob'
        bank = 'Santander'
    },

@{
        accountNumber = '13056233-7'
        region = 'Centro Oeste'
        enterprise = 'Opty Rio'
        bank = 'Santander'
    },

@{
        accountNumber = '13065287-8'
        region = 'Centro Oeste'
        enterprise = 'Saúde do Brasil'
        bank = 'Santander'
    },

@{
        accountNumber = '13065987-5'
        region = 'Centro Oeste'
        enterprise = 'Saúde Latam'
        bank = 'Santander'
    },

@{
        accountNumber = '205208-3'
        region = 'Nordeste'
        enterprise = 'Eunápolis'
        bank = 'BB'
    },

@{
        accountNumber = '23520-2'
        region = 'Nordeste'
        enterprise = 'Eunápolis'
        bank = 'BB'
    },

@{
        accountNumber = '50248-8'
        region = 'Nordeste'
        enterprise = 'Eunápolis'
        bank = 'Unicred'
    },

@{
        accountNumber = '1539-7'
        region = 'Nordeste'
        enterprise = 'Eunápolis'
        bank = 'CEF'
    },

@{
        accountNumber = '3075-5'
        region = 'Nordeste'
        enterprise = 'Eunápolis'
        bank = 'CEF'
    },

@{
        accountNumber = '35942-4'
        region = 'Nordeste'
        enterprise = 'Eunápolis'
        bank = 'Bradesco'
    },

@{
        accountNumber = '13004383-0'
        region = 'Nordeste'
        enterprise = 'Eunápolis'
        bank = 'Santander'
    },

@{
        accountNumber = '144808-0'
        region = 'Nordeste'
        enterprise = 'DH-HBA'
        bank = 'Bradesco'
    },

@{
        accountNumber = '17764-4'
        region = 'Nordeste'
        enterprise = 'DH-HBA'
        bank = 'BB'
    },

@{
        accountNumber = '118866-6'
        region = 'Nordeste'
        enterprise = 'DH-ITB'
        bank = 'BB'
    },

@{
        accountNumber = '1008-1'
        region = 'Nordeste'
        enterprise = 'DH-ITB'
        bank = 'Sicred'
    },

@{
        accountNumber = '607-6'
        region = 'Nordeste'
        enterprise = 'DH-ITB'
        bank = 'Bradesco'
    },

@{
        accountNumber = '164-5'
        region = 'Nordeste'
        enterprise = 'DH-ITB'
        bank = 'CEF'
    },

@{
        accountNumber = '3076-3'
        region = 'Nordeste'
        enterprise = 'DH-ITB'
        bank = 'CEF'
    },


@{
        accountNumber = '13000405-6'
        region = 'Nordeste'
        enterprise = 'DH-ITB'
        bank = 'Santander'
    },


@{
        accountNumber = '1740-0'
        region = 'Nordeste'
        enterprise = 'DH-ITG'
        bank = 'CEF'
    },

@{
        accountNumber = '3077-1'
        region = 'Nordeste'
        enterprise = 'DH-ITG'
        bank = 'CEF'
    },

@{
        accountNumber = '51002-5'
        region = 'Nordeste'
        enterprise = 'DH-ITG'
        bank = 'BB'
    },

@{
        accountNumber = '37505-5'
        region = 'Nordeste'
        enterprise = 'DH-ITG'
        bank = 'Bradesco'
    },

@{
        accountNumber = '13065347-7'
        region = 'Nordeste'
        enterprise = 'Silva Cunha'
        bank = 'Santander'
    },

@{
        accountNumber = '14423-1'
        region = 'Nordeste'
        enterprise = 'Topazio'
        bank = 'BB'
    },

@{
        accountNumber = '243000-2'
        region = 'Nordeste'
        enterprise = 'Topazio'
        bank = 'BB'
    },

@{
        accountNumber = '13004384-7'
        region = 'Nordeste'
        enterprise = 'Topazio'
        bank = 'Santander'
    },

@{
        accountNumber = '71185-3'
        region = 'Nordeste'
        enterprise = 'HOSL'
        bank = 'Bradesco'
    },

@{
        accountNumber = '3080-1'
        region = 'Nordeste'
        enterprise = 'HOSL'
        bank = 'CEF'
    },

@{
        accountNumber = '3000-7'
        region = 'Nordeste'
        enterprise = 'HOSL'
        bank = 'Unicred'
    },

@{
        accountNumber = '16797-1'
        region = 'Nordeste'
        enterprise = 'HOSL'
        bank = 'BRN'
    },

@{
        accountNumber = '113739-5'
        region = 'Nordeste'
        enterprise = 'HOSL'
        bank = 'BB'
    },

@{
        accountNumber = '13003023-2'
        region = 'Nordeste'
        enterprise = 'HOSL'
        bank = 'Santander'
    },

@{
        accountNumber = '40053-X'
        region = 'Nordeste'
        enterprise = 'IOF'
        bank = 'BB'
    },

@{
        accountNumber = '5700-2'
        region = 'Nordeste'
        enterprise = 'IOF'
        bank = 'Bradesco'
    },

@{
        accountNumber = '29447-0'
        region = 'Nordeste'
        enterprise = 'IOF'
        bank = 'Bradesco'
    },

@{
        accountNumber = '116-2'
        region = 'Nordeste'
        enterprise = 'IOF'
        bank = 'CEF'
    },

@{
        accountNumber = '728-4'
        region = 'Nordeste'
        enterprise = 'IOF'
        bank = 'CEF'
    },

@{
        accountNumber = '10977-5'
        region = 'Nordeste'
        enterprise = 'IOF'
        bank = 'Itaú'
    },

@{
        accountNumber = '13004382-3'
        region = 'Nordeste'
        enterprise = 'IOF'
        bank = 'Santander'
    },

@{
        accountNumber = '156536-2'
        region = 'Nordeste'
        enterprise = 'Oftalmoclin'
        bank = 'BB'
    },

@{
        accountNumber = '140329-0'
        region = 'Nordeste'
        enterprise = 'Oftalmoclin'
        bank = 'Bradesco'
    },

@{
        accountNumber = '4878-9'
        region = 'Nordeste'
        enterprise = 'Oftalmoclin'
        bank = 'CEF'
    },

@{
        accountNumber = '13000554-8'
        region = 'Nordeste'
        enterprise = 'Oftalmoclin'
        bank = 'Santander'
    },

@{
        accountNumber = '13039547-4'
        region = 'Nordeste'
        enterprise = 'Salvador DH'
        bank = 'Santander'
    },

@{
        accountNumber = '29666-0'
        region = 'Sudeste'
        enterprise = 'Ecobarra'
        bank = 'Bradesco'
    },

@{
        accountNumber = '107188-2'
        region = 'Sudeste'
        enterprise = 'Ecobarra'
        bank = 'BB'
    },

@{
        accountNumber = '107188-2'
        region = 'Sudeste'
        enterprise = 'Eye Center'
        bank = 'BB'
    },

@{
        accountNumber = '18163-3'
        region = 'Sudeste'
        enterprise = 'Eye Center'
        bank = 'Bradesco'
    },

@{
        accountNumber = '13000647-6'
        region = 'Sudeste'
        enterprise = 'Eye Center'
        bank = 'Santander'
    },

@{
        accountNumber = '6555-2'
        region = 'Sudeste'
        enterprise = 'Eye Center'
        bank = 'Bradesco'
    },

@{
        accountNumber = '16109-8'
        region = 'Sudeste'
        enterprise = 'Eye Center'
        bank = 'Bradesco'
    },

@{
        accountNumber = '13001515-4'
        region = 'Sudeste'
        enterprise = 'Hcloe'
        bank = 'Santander'
    },

@{
        accountNumber = '1001-0'
        region = 'Sudeste'
        enterprise = 'Hcloe'
        bank = 'Itaú'
    },

@{
        accountNumber = '17949-3'
        region = 'Sudeste'
        enterprise = 'Hcloe'
        bank = 'BB'
    },

@{
        accountNumber = '44046-9'
        region = 'Sudeste'
        enterprise = 'Hcloe'
        bank = 'Bradesco'
    },

@{
        accountNumber = '2307-8'
        region = 'Sudeste'
        enterprise = 'Hcloe'
        bank = 'Bradesco'
    },

@{
        accountNumber = '105184-9'
        region = 'Sudeste'
        enterprise = 'Lummem'
        bank = 'BB'
    },

@{
        accountNumber = '1815-7'
        region = 'Sudeste'
        enterprise = 'Lummem'
        bank = 'Bradesco'
    },

@{
        accountNumber = '509-1'
        region = 'Sudeste'
        enterprise = 'Lummem'
        bank = 'CEF'
    },

@{
        accountNumber = '9930-6'
        region = 'Sudeste'
        enterprise = 'Lummem'
        bank = 'Itaú'
    },

@{
        accountNumber = '117617-X'
        region = 'Sudeste'
        enterprise = 'Lummem'
        bank = 'BB'
    },

@{
        accountNumber = '19470-1'
        region = 'Sudeste'
        enterprise = 'Lummem'
        bank = 'Itaú'
    },

@{
        accountNumber = '13049622-7'
        region = 'Sudeste'
        enterprise = 'SPEC'
        bank = 'Santander'
    },

@{
        accountNumber = '102187-7'
        region = 'Sudeste'
        enterprise = 'SPEC'
        bank = 'BB'
    },

@{
        accountNumber = '27872-1'
        region = 'Sudeste'
        enterprise = 'SPEC'
        bank = 'Itaú'
    },

@{
        accountNumber = '45500-8'
        region = 'Sudeste'
        enterprise = 'SPEC'
        bank = 'Bradesco'
    }

)

foreach ($account in $accounts) {
    $account | ForEach-Object {
        $allFiles = Get-Files -root '\\10.47.251.5\Accesstage' -partialFileName $_.accountNumber
        Move-Files -files $allFiles -region $_.region -enterprise $_.enterprise -bank $_.bank -account $_.accountNumber
    }
}