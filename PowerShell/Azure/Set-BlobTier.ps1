.\Connect-AzAccount.ps1

#Get-AzStorageAccount | Select StorageAccountName, Location

$ContainerName = "testescript"
$MaxReturn = 100000
$Token = $null
$Context = "rghobpentacanprodbr"

$Blobs = Get-AzureStorageBlob -Context $Context -Container $ContainerName -MaxCount $MaxReturn -ContinuationToken $Token