<#
 .SYNOPSIS
    Obtem os tickets das ligações telefônicas da plataforma Nexcore NCall
 .DESCRIPTION
    Conecta ao FTP da Nexcore e faz o download dos arquivos das ligações telefônicas.
    Deve ser agendado para execução diária, após 07:30
    Este script faz parte do fluxo de dados que alimenta o Azure SQL Server a partir de pipeline no Azure Data Factory
 .EXAMPLE
    .\Get-PhoneCallsTickets.ps1 ; Get-PhoneCallsTickets -StagePath 'C:\Power BI Gateway Files\Nexcore' -FinalPath 'C:\Power BI Gateway Files\Nexcore\Consolidado'
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

function Delete-PreviousFiles { # Apaga os arquivos anteriores
    param (
        [System.IO.FileInfo] $DownloadPath
    )
    Remove-Item ($DownloadPath.FullName + '\*.*') -Recurse
}

function Get-FTPFiles { # Faz o download do arquivo do dia anterior
    param (
        [WinSCP.Session] $FTPSession,
        [WinSCP.SessionOptions] $SessionOptions,
        [String] $RemotePath,
        [String] $RemoteMask,
        [System.IO.FileInfo] $LocalPath,
        [String] $FileGroup
    )
    try {
        # Conecta ao servidor FTP
        $FTPSession.Open($SessionOptions)

        # Lista os arquivos e diretorios do servidor FTP
        $fileInfos =
            $FTPSession.EnumerateRemoteFiles(
                $RemotePath, "*$($FileGroup)*",
                ([WinSCP.EnumerationOptions]::EnumerateDirectories -bor
                    [WinSCP.EnumerationOptions]::AllDirectories))

        # Percorre as pastas do servidor FTP
        foreach ($fileInfo in $fileInfos)
        {
            $localFilePath =
                [WinSCP.RemotePath]::TranslateRemotePathToLocal(
                    $fileInfo.FullName, $RemotePath, $LocalPath)

            if ($fileInfo.IsDirectory)
            {
                # Cria a pasta local
                if (!(Test-Path $localFilePath))
                {
                    New-Item $localFilePath -ItemType directory | Out-Null
                }
            }

            Write-Host "Arquivo $($fileInfo.FullName)..."
            if ( ($fileInfo.LastWriteTime -ge $(Get-Date -Hour 0 -Minute 0 -Second 0)) -and ($fileInfo.FullName -like "*$($FileGroup)*" ))
            {
                Write-Host "Baixando o arquivo $($fileInfo.FullName)..."
                # Transfere o arquivo
                $remoteFilePath = [WinSCP.RemotePath]::EscapeFileMask($fileInfo.FullName)
                $transferResult = $FTPSession.GetFiles($remoteFilePath, $localFilePath)

                # Falha no download?
                if (!$transferResult.IsSuccess)
                {
                    # Exibe o erro e passa para o proximo arquivo
                    Write-Host (
                        "Erro ao baixar arquivo $($fileInfo.FullName): " +
                        "$($transferResult.Failures[0].Message)")
                }
            }
        }

    }
    catch {
       Write-Verbose $_.Exception.Message
       Write-Output "1"
    }
    finally {
        # Disconecta
        #$session.Dispose()
    }
}
function Include-Enterprise { # Inclui o nome da empresa no conteudo do arquivo
    param (
        [System.IO.FileInfo] $FileName
    )
    Write-Host "Incluindo marca em $($FileName.FullName)"
    # Adiciona o nome da pasta (i.e., nome da empresa)
    Import-CSV $FileName.FullName |
        Select-Object *,@{Name='Marca';Expression={$(Split-Path -Path $FileName.DirectoryName -Leaf)}} |
            Export-CSV $($FileName.FullName + ".tmp") -NoTypeInformation -Delimiter ';' -Encoding UTF8
    # Remove as aspas duplas do conteudo do arquivo
    (Get-Content $($FileName.FullName + ".tmp")) | % { $_ -replace '"', ""}  | Out-file $($FileName.FullName + ".tmp")
    # Renomeia o arquivo para seu nome original
    Remove-Item -Path $FileName.FullName
    Move-Item -Path $($FileName.FullName + ".tmp") -Destination $FileName.FullName
}
function Include-Header{ # Inclui a coluna URA nos arquivos antigos
    param(
        [System.IO.FileInfo] $FileName
    )
    # Le o cabecalho do arquivo
    $Header = Get-Content $FileName -TotalCount 1
    # Cabecalho nao contem a coluna URA?
    if (-Not ($Header -Like '*URA*')) {
        $NewHeader = 'Data;Hora;Usuário;Tipo;Origem;Destino;Status;Centro de Custo;Tempo Tarifado;Tempo Decorrido;URA;Campanha;Fila;Tabulacao;Unique ID;Linked ID'
        $Content = Get-Content $FileName | Select-Object -Skip 1
    }
}
function Move-TodayFiles { # Move o arquivo do dia para o diretorio de consolidacao, especificado no Azure DataFactory
    param (
        [System.IO.FileInfo] $StagePath,
        [System.IO.FileInfo] $FinalPath,
        [String] $FileGroup
    )
    # Cria a pasta local
    if (!(Test-Path $FinalPath))
    {
        New-Item $FinalPath -ItemType Directory | Out-Null
    }
    $FilePattern = ($StagePath.FullName + "\*" + $FileGroup + "*.csv")
    Get-ChildItem -Path $FilePattern -File -Recurse |
        Where-Object {$_.LastWriteTime -ge $(Get-Date -Hour 0 -Minute 0 -Second 0)} |
            ForEach-Object { Include-Enterprise $_.FullName ; Move-Item -Path $_.FullName -Destination ($FinalPath.FullName + "\$($FileGroup)" + $(Split-Path -Path $_.DirectoryName -Leaf) + ".csv")}
}

function Get-PhoneCallsTickets {
    param (
        [System.IO.FileInfo] $StagePath,
        [System.IO.FileInfo] $FinalPath
    )
    Try
    {
        # Exemplo do arquivo SessionProperties.ps1
        #
        # @{
        #   Protocol = [WinSCP.Protocol]::Ftp
        #   HostName = "ip_servidor"
        #   UserName = "meu_usuario"
        #   Password = 'minha_senha'
        # }
        Delete-PreviousFiles $FinalPath

        $TicketGroups = @("BilheteLigacoes", "AgentesPorHora", "AgentesPorDia", "FilasPorHora")
        ForEach ($TicketGroup in $TicketGroups) {
            $SessionOptions = Connect-FTPServer -WinSCPNet 'C:\Program Files (x86)\WinSCP\WinSCPnet.dll' -SessionDefinitions $PSScriptRoot\SessionProperties.ps1
            $FTPSession = New-Object WinSCP.Session
            Write-Host "Processando $TicketGroup"
            Get-FTPFiles -FtpSession $FTPSession -SessionOptions $SessionOptions -RemotePath '/' -RemoteMask '.csv' -LocalPath $StagePath -FileGroup $TicketGroup
            Move-TodayFiles -StagePath $StagePath -FinalPath $FinalPath -FileGroup $TicketGroup
        }
    }
    Catch
    {
        Throw "Error: $($_.Exception.Message)"
        exit 1
    }
}

Get-PhoneCallsTickets -StagePath 'C:\Power BI Gateway Files\Nexcore' -FinalPath 'C:\Power BI Gateway Files\Nexcore\Consolidado'