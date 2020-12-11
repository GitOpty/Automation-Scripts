# . .\Get-FilesByDate.ps1; Get-FilesByDate -FileTypes *.xlsx
# . .\Get-FilesByDate.ps1; Get-FilesByDate -FileTypes *.xlsx -Month 6 -Year 2019 -Path $HOME
Function Get-FilesByDate {
    Param (
        [String[]] $FileTypes = @('*.doc', '*.docx'), # Array of file types. Default MS Word files
        [Parameter(Mandatory=$true)]
        [Int] $Month,
        [Parameter(Mandatory=$true)]
        [Int] $Year,
        [Parameter(Mandatory=$true)]
        [String[]] $Path # Array of file paths
    )
    # Limit the search to include only file types supplied via $filetypes variable
    Get-ChildItem -Path $Path -Include $FileTypes -Recurse |
        Where-Object {
            $_.LastWriteTime.Month -eq $Month -and $_.LastWriteTime.Year -eq $Year
        }
}
