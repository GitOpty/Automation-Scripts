$Time = Measure-Command {

    Restart-Computer -ComputerName $ComputerName -Wait -For powershell -Timeout 1200 -ErrorAction Stop

} | Select-Object -ExpandProperty TotalSeconds

$RoundedTime = [math]::Round($Time,2)

[PSCustomObject]@{

    ComputerName = $ComputerName

    Seconds = $RoundedTime

}