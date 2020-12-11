###################################################################
# https://winscp.net/eng/docs/library_example_recursive_download_custom_error_handling#powershell
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/expand-archive?view=powershell-6

# Use Generate Session URL function to obtain a value for -sessionUrl parameter.
$remotePath = "/"
$localPath = "$env:USERPROFILE\Documents"

try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

    # Setup session options from URL
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "34.197.80.109"
        UserName = "sftpuser"
        PrivateKeyPassphrase = "sftpHO@20190411"
        SshPrivateKeyPath = "$env:USERPROFILE\Documents\sftpuserPrivate.ppk"
        SshHostKeyFingerprint = "ssh-rsa 1024 qx844DYjTRTN8gNCw2ykXmlCTecivZpmophsvHyZJCA="
    }
    #$sessionOptions.ParseUrl($sessionUrl)

    $session = New-Object WinSCP.Session

    try
    {
        # Connect
        $session.SessionLogPath = "$env:USERPROFILE\Documents\export_requestia.log"
        $session.Open($sessionOptions)

        # Enumerate files and directories to download
        $fileInfos =
            $session.EnumerateRemoteFiles(
                $remotePath, $Null,
                ([WinSCP.EnumerationOptions]::EnumerateDirectories -bor
                    [WinSCP.EnumerationOptions]::AllDirectories))

        foreach ($fileInfo in $fileInfos)
        {
            $localFilePath =
                [WinSCP.RemotePath]::TranslateRemotePathToLocal(
                    $fileInfo.FullName, $remotePath, $localPath)

            if ($fileInfo.IsDirectory)
            {
                # Create local subdirectory, if it does not exist yet
                if (!(Test-Path $localFilePath))
                {
                    New-Item $localFilePath -ItemType directory | Out-Null
                }
            }
            else
            {
                Write-Host "Downloading file $($fileInfo.FullName)..."
                # Download file
                $remoteFilePath = [WinSCP.RemotePath]::EscapeFileMask($fileInfo.FullName)
                $transferResult = $session.GetFiles($remoteFilePath, $localFilePath)

                # Did the download succeeded?
                if (!$transferResult.IsSuccess)
                {
                    # Print error (but continue with other files)
                    Write-Host (
                        "Error downloading file $($fileInfo.FullName): " +
                        "$($transferResult.Failures[0].Message)")
                }
            }
        }
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }

    # Unzip downloaded file
    Expand-Archive -LiteralPath $localFilePath -DestinationPath "$env:USERPROFILE\Documents\export_requestia"

    # Rename to a format that Power BI can read
    Remove-Item -Path "$env:USERPROFILE\Documents\export_requestia" -Include *.csv -Recurse
    Get-ChildItem -Filter "*dat" -Path "$env:USERPROFILE\Documents\export_requestia" -Recurse | Move-Item -Path {$_.FullName} -Destination "$env:USERPROFILE\Documents\export_requestia"
    Get-ChildItem -Filter "*dat" -Path "$env:USERPROFILE\Documents\export_requestia" -Recurse | Rename-Item -NewName {[IO.Path]::ChangeExtension($_.name, "csv")}

    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
