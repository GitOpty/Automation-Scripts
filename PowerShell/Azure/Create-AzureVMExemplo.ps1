Login-AzureRmAccount

Set-AzureRmContext -SubscriptionId "ID da Assinatura"

#Localização
Get-AzureRmLocation
$loc="brazilsouth"
Get-AzureRMVMImagePublisher -Location $loc | Where-Object {$_.PublisherName -like '*Windows*'} | Select-Object -ExpandProperty PublisherName Select PublisherName -like

#Tipo da máquina
$pub="Nome do Fornecedor da Imagem"
Get-AzureRMVMImageOffer -Location $loc -Publisher $pub | Select Offer

#Imagem do SO
$offer="Nome da Imagem"
Get-AzureRMVMImageSku -Location $loc -Publisher $pub -Offer $offer | Select Skus

#Versão
$sku="tipo da versão do SO"

#Tamanho
Get-AzureRmVMSize -Location $loc
$vmsize="Tamanho da Maquina"

Get-AzureRmDisk

#IP Publico
$rg='Nome do Grupo de Recurso'
$ippub='Nome de identificação do IP'
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $rg -Location $loc -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name $ippub

# NSG | Portas 3389(RDP) e 80 (HTTP)
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name Permitir_RDP  -Protocol Tcp `
    -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
    -DestinationPortRange 3389 -Access Allow

 $nsgRuleWeb = New-AzureRmNetworkSecurityRuleConfig -Name Permitir_WWW  -Protocol Tcp `
    -Direction Inbound -Priority 1001 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
    -DestinationPortRange 80 -Access Allow


#Politica de Segurança de rede
$nsgname='Nome da Politica de Rede'
$nsg = New-AzureRmNetworkSecurityGroup -Name $nsgname -ResourceGroupName $rg -Location $loc -SecurityRules $nsgRuleRDP,$nsgRuleWeb


#Placa de Rede
$nicname='Nome da Placa de rede'

Get-AzureRmVirtualNetwork -ResourceGroupName AZR-EUA

$vnet = "NomedaRede" 

$vnetinfo = Get-AzureRmVirtualNetwork -Name $vnet -ResourceGroupName $rg | Get-AzureRmVirtualNetworkSubnetConfig -Name "SubRede"

$nic = New-AzureRmNetworkInterface -Name $nicname -ResourceGroupName $rg -Location $loc  -SubnetId $vnetinfo.Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

#Credencias da maquina local
$usr = "Usuário"

$pwd =  ConvertTo-SecureString -String "Senha" -AsPlainText -Force

$credinfo = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $usr, $pwd

#Configura a VM
$vmname='NomedaVM'
$vmConfig = New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize | Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmname -Credential $credinfo | Set-AzureRmVMSourceImage -PublisherName $pub -Offer $offer -Skus $sku -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id

#Cria a VM
New-AzureRmVM -ResourceGroupName $rg -Location $loc -VM $vmConfig