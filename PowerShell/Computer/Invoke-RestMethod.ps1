$uriGet = "https://httpbin.org/uuid"
$uriPost = "https://httpbin.org/delay"

Invoke-RestMethod -Method Get -Uri $uriGet
Invoke-RestMethod -Method Get -Uri "$($uriGet)&name=World!"

$body = @{ name = "Max Power" } | ConvertTo-Json
Invoke-RestMethod -Method Post -Body $body -Uri $uriPost