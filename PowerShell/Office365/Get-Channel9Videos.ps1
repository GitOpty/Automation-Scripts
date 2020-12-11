### Download de videos
$uri = Invoke-RestMethod 'https://channel9.msdn.com/Events/Visual-Studio/Connect-event-2015/RSS'

$videoURIs = $uri.group.content.url | Where-Object -FilterScript { $_ -like "*_high.mp4" }

for ($i = 0; $i -le $videoURIs.Count; $i++) {
    $fileName = "$(($uri[$i].title).Replace('[!,;:?]','')).mp4"

    Invoke-WebRequest -Uri $videoURIs[$i] -OutFile $(Join-Path -Path 'C:\users\sergio.queiroz\Desktop\' -ChildPath $fileName) -Verbose
}


### Sintetizador de voz
Add-Type -Assembly 'System.Speech'

$voice = New-Object -TypeName 'System.Speech.Synthesis.SpeechSynthesizer'

$voice.SelectVoiceByHints('Female')
$voice.Speak('Hey, Alex. Her name is Jennifer') | Out-Null


### Computadores inativos no AD
$days = (get-date).AddDays(–45)
Get-ADComputer -Filter { PasswordLastSet -le $days } -Properties PasswordLastSet | Format-Table

