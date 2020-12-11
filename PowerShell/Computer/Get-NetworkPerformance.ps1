## Hosts monitorados
$Hosts = @(
  @{Server = 'Tasy HTML5'; URI = 'cloud.brasiliaholding.tasy.com.br'}
  @{Server = 'Tasy Java'; URI = 'ec2-54-207-64-132.sa-east-1.compute.amazonaws.com'}
  @{Server = 'Office 365'; URI = 'www.office.com'}
  @{Server = 'Google'; URI = 'www.google.com'}
  @{Server = 'Nexcore'; URI = 'nuvemhobr.nexcore.com.br'}
  @{Server = 'Senior'; URI = 'SRV-RONDA'}
  @{Server = 'File Server'; URI = 'OPTY-CSI-FSPS'}
  @{Server = 'AD'; URI = 'OPTY-CSI-ADDS01'}
)
While($true) {
  ForEach($HostName in $Hosts){
    ## Resolve o endereço IP dos hosts monitorados
    $Ip = [System.Net.Dns]::GetHostAddresses(($HostName.URI))[0].IPAddressToString
    Write-Host $HostName.URI, $Ip
    ## Adiciona host no resultado
    $HostResult = @{
      "Server" = $HostName.Server;
      "URI" = $HostName.URI;
      "IP" = $Ip;
      "Timestamp" = (Get-Date -Format s)
    }
    ## Pinga o host
    $pings = Test-Connection $ip -Count 4 -ea 0
    ## Calcula o tempo médio de resposta
    If ($pings) {
      $HostResult["Status"] = "Up"
      $HostResult["AverageResponseTime"] = ($pings | Measure-Object -Property ResponseTime -Average).Average
    } Else {
      $HostResult["Status"] = "Down"
    }
    ## Endpoint do stream dataset no Power BI Service
    $endpoint = "https://api.powerbi.com/beta/1b4ff8a1-90f8-4ca6-854d-c5c61aff2ecb/datasets/9602e727-a4be-446c-bf6c-e86d5e480249/rows?key=zMO061ZnEFXTvXg2xw%2BVyBt8oHd6gH07zda5mYb%2FcKulQsaFReOIGNdZlEwEcDqV1JF3%2FgGrc7LE3fgpkXaxHA%3D%3D"
    ## Monta a mensagem de payload
    $payload = @{
      "Server" = $HostResult["Server"]
      "URI" = $HostResult["URI"]
      "IP" = $HostResult["IP"]
      "Timestamp" = $HostResult["TimeStamp"]
      "AverageResponseTime" = $HostResult["AverageResponseTime"]
      "Status" = $HostResult["Status"]
    }
    ## Atualiza o stream dataset no Power BI Service
    Invoke-RestMethod -Method Post -Uri "$endpoint" -Body (ConvertTo-Json @($payload))
  }
}
