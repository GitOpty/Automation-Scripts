# . .\Get-BiggerFiles.ps1; Get-BiggerFiles
function Get-BiggerFiles {
    Param(
        [PSDefaultValue(Help = '1000000')]
        $Size = 1000000
    )
    Get-ChildItem $HOME -Recurse| Where-Object {
      $_.Length -gt $Size -and !$_.PSIsContainer
    } | Sort-Object -Property Length -Descending | Format-Table
  }