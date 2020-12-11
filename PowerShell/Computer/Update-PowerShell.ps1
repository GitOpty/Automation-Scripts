$randomFileName = [System.IO.Path]::GetRandomFileName()
$tmpMsiPath = Microsoft.PowerShell.Management\Join-Path ([System.IO.Path]::GetTempPath()) "$randomFileName.msi"
Microsoft.PowerShell.Utility\Invoke-RestMethod -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.0.0-preview.4/PowerShell-7.0.0-preview.4-win-x64.msi -OutFile $tmpMsiPath
try
{
    Microsoft.PowerShell.Management\Start-Process -Wait -Path $tmpMsiPath
}
finally
{
    Microsoft.PowerShell.Management\Remove-Item $tmpMsiPath
}