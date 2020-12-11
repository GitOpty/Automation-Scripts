param(
    [Parameter(Mandatory)]
    [String]$siteUrl,
    [Parameter(Mandatory)]
    [String]$libraryInternalName,
    [Parameter(Mandatory)]
    [String]$drivePath
)
$connection = Connect-PnPOnline $siteUrl -Credentials (Get-Credential) -ReturnConnection 
$files = Get-ChildItem $drivePath
Write-Host ("Uploading {0} files" -f $files.Length)
     
foreach ($file in $files)
{
    Add-PnPFile -Path $file.FullName -Folder $libraryInternalName -Values @{ "Title" = $file.Name; } -Connection $connection
}
Read-Host -Prompt "Press Enter to exit"