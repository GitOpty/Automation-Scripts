<# 
Busca todas as Maquinas Virtuais do tenant
Get-AzureRmResource -ResourceType Microsoft.Compute/virtualMachines

Busca todos os tamanhos disponiveis na região
Get-AzureRmVmSize -Location $VirtualMachine.Location

Busca Tenant Id
Get-AzureRmTenant

Exemplo
Resize-AzureRMVM ('Vmname', 'VmNewSize')
#>

#$CredentialsFilePath = "$PSScriptRoot\azcredentials.xml"
$CredentialsFilePath = "azcredentials.xml"

If (-Not (Test-Path $CredentialsFilePath)) {
    # Solicita as credenciais de acesso ao Office365 e salva hash, caso arquivo não exista
    $Credentials = Get-Credential
    $Credentials | Export-Clixml -Path $CredentialsFilePath
}
# Le as credenciais de acesso a partir do arquivo
$CredentialsFile = Import-Clixml -Path $CredentialsFilePath

$TenantID = ''

Connect-AzureRmAccount -Credential $CredentialsFile -TenantId $TenantID

function Resize-AzureRMVM ($VM, $VMNewSize) {

    $VirtualMachine = Get-AzureRmVM | Where-Object {$_.name -eq $VM}

    $VirtualMachine.HardwareProfile.Vmsize = $VMNewSize

    $VirtualMachine | Update-AzureRmVM
}


