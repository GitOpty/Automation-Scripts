<#
 .SYNOPSIS
    Obtem os Extratos Bancarios fornecidos pela GetNet
 .DESCRIPTION
    Conecta ao FTP da GetNet e faz o download dos Extratos Bancarios.
    Deve ser agendado para execução diária, após 08:30
 .EXAMPLE
#>

function Connect-FTPServer { # Conecta ao servidor FTP utilizando a biblioteca do WinSCP. Requer a biblioteca do WinSCP
    Param(
        [System.IO.FileInfo] $WinSCPNet,
        [System.IO.FileInfo] $SessionDefinitions
    )
    Try {
        Add-Type -Path $WinSCPNet
        $SessionProperties = (Get-Content $SessionDefinitions | Out-String)
        $SessionProps = Invoke-Expression $SessionProperties
        $SessionOptions = New-Object WinSCP.SessionOptions -Property $SessionProps
    }
    Catch {
        Throw "Error: $($_.Exception.Message)"
        exit 1
    }
    Return $SessionOptions
}

function Get-FTPFiles {
    param (
        
    )
    try
    {
        # Connect
        $session.Open($sessionOptions)

        #Diretorio de Origem
        $directory = $session.ListDirectory("/publico")

        # Download de todos os arquivos do dia
        foreach ($fileInfo in $directory.Files)
        {
            Write-Host ("$($fileInfo.Name) with size $($fileInfo.Length), " +
                "permissions $($fileInfo.FilePermissions) and " +
                "last modification at $($fileInfo.LastWriteTime)")
            If((-Not $fileInfo.IsDirectory) -and ($fileInfo.LastWriteTime -ge $(Get-Date -Hour 0 -Minute 0 -Second 0 )) ){
                $session.GetFiles($fileInfo.Name, $downloadPath, $False, $transferOptions)
                
            }
        }
        MoveFiles $downloadPath
        # Throw on any error
        $transferResult.Check()
 
        # Print results
        foreach ($transfer in $transferResult.Transfers)
        {
            Write-Host "Download of $($transfer.FileName) succeeded"
        }

        
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
}



function MoveFiles {
    param (
        $downloadPath
    )
    Get-ChildItem -Path $downloadPath -File |
    Where-Object {$_.Name -match '4948075'} |
    ForEach-Object { Move-Item -Path $_.FullName -Destination $($downloadPath + "HOB_4948075\" + $_.Name) -Force }    

    Get-ChildItem -Path $downloadPath -File |
        Where-Object {$_.Name -match '1089079'} |
        ForEach-Object { Move-Item -Path $_.FullName -Destination $($downloadPath + "HOG_1089079\" + $_.Name) -Force }
     
    Get-ChildItem -Path $downloadPath -File |
        Where-Object {$_.Name -match '4083202'} |
        ForEach-Object { Move-Item -Path $_.FullName -Destination $($downloadPath + "HOSL_4083202\" + $_.Name) -Force }

    Get-ChildItem -Path $downloadPath -File |
        Where-Object {$_.Name -match '4948081'} |
        ForEach-Object { Move-Item -Path $_.FullName -Destination $($downloadPath + "HP_4948081\" + $_.Name) -Force }

    Get-ChildItem -Path $downloadPath -File |
        Where-Object {$_.Name -match '1067140'} |
        ForEach-Object { Move-Item -Path $_.FullName -Destination $($downloadPath + "INOB_1067140\" + $_.Name) -Force }

    Get-ChildItem -Path $downloadPath -File |
        Where-Object {$_.Name -match '1215878'} |
        ForEach-Object { Move-Item -Path $_.FullName -Destination $($downloadPath + "TAG_1215878\" + $_.Name) -Force } #>
            
}


try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
 
    # Setup session options
    $sessionOptions = Connect-FTPServer -WinSCPNet 'C:\Program Files (x86)\WinSCP\WinSCPnet.dll' -SessionDefinitions "C:\Automation Scripts\Automation-Scripts\PowerShell\Automation-Ftp-Download\SessionProperties.ps1"

    $downloadPath = "C:\Users\anderson.santos\Opty\Financeiro_CSI - 09 - Extrato eletronico\"

    # $directoryMapping = @{
    #     "4948075" = "HOB_4948075"
    #     "1089079" = "HOG_1089079"
    #     "4083202" = "HOSL_4083202"
    #     "4948081" = "HP_4948081"
    #     "1067140" = "INOB_1067140"
    #     "1215878  = "TAG_1215878"
    # }
 
    $session = New-Object WinSCP.Session
 
    try
    {
        # Connect
        $session.Open($sessionOptions)

        #Diretorio de Origem
        $directory = $session.ListDirectory("/publico")

        # Download de todos os arquivos do dia
        foreach ($fileInfo in $directory.Files)
        {
            Write-Host ("$($fileInfo.Name) with size $($fileInfo.Length), " +
                "permissions $($fileInfo.FilePermissions) and " +
                "last modification at $($fileInfo.LastWriteTime)")
            If((-Not $fileInfo.IsDirectory) -and ($fileInfo.LastWriteTime -ge $(Get-Date -Hour 0 -Minute 0 -Second 0 )) ){
                $session.GetFiles($fileInfo.Name, $downloadPath, $False, $transferOptions)
                
            }
        }
        # MoveFiles $downloadPath
        # Throw on any error
        $transferResult.Check()
 
        # Print results
        foreach ($transfer in $transferResult.Transfers)
        {
            Write-Host "Download of $($transfer.FileName) succeeded"
        }

        
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
