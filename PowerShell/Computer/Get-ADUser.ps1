$HRExportFilePath = "C:\tmp\HRExport"

#This variable is used to fill the username in case a name is less than 3 characters
$nameFillerCharacter = "-"

#Assuming one name per line, format "FirstName LastName"
$users = Get-Content $HRExportFilePath
foreach ($user in $users) {
    $user = "Elison Padilha Feliciano"
    $names = ($user.ToLower()).Split(' ')
    [string]$firstNameTrunc = ""
    [string]$lastNameTrunc = ""
    for ($i = 0; $i -lt 3; $i++) {
        if (($names[0])[$i]) {$firstNameTrunc += $names[0][$i]}
        else {$firstNameTrunc += $nameFillerCharacter}
        if (($names[1])[$i]) {$lastNameTrunc += $names[1][$i]}
        else {$lastNameTrunc += $nameFillerCharacter}
    }

    [string]$uniqueSuffix = Get-Random -Minimum 100 -Maximum 999
    $NewUsername = $firstNameTrunc + $lastNameTrunc + $uniqueSuffix
    $NewUsername = $names[0] + '.' + $names[2]
    while (Get-ADUser $NewUsername) {
        [string]$uniqueSuffix = Get-Random -Minimum 100 -Maximum 999
        $NewUsername = $firstNameTrunc + $lastNameTrunc + $uniqueSuffix
    }

    "Unique username found for $user : $NewUsername"
    #new-aduser -Name $user -AccountPassword "password" -SamAccountName $NewUsername -GivenName $names[0] -    Surname $names[1] blah blah
}