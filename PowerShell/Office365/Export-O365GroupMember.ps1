<#
.SYNOPSIS
  
.DESCRIPTION
   
.INPUTS
  None
.OUTPUTS
  CSV File
.NOTES
  Version:        1.0
  Author:         Anderson Soethe
  Creation Date:  20200302
  Purpose/Change: Initial version
  
.EXAMPLE
  Export-O365DistrMembers $FileName $DistrName 
#>

function Export-O365DistrMembers {
  param (
    $FileName,$DistrName
  )
    Write-Host "Processing Data..."
    $Members = Get-DistributionGroupMember -Identity $DistrName -ErrorAction Stop | Select-Object DisplayName, PrimarySmtpAddress
    Write-Host "Builded and Exported with sucess"
    $Members | Export-Csv -Path $Filename -Encoding UTF8 -Delimiter ";" -NoTypeInformation
}

$FileName = Read-Host "Informe um para para o arquivo CSV"
$DistrName = Read-Host "Informe o nome da Lista de Distribuição"

Export-O365DistrMembers $FileName $DistrName 

