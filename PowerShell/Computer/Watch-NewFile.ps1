# Source: https://mcpmag.com/articles/2019/05/01/monitor-windows-folder-for-new-files.aspx?oly_enc_id=1350G7977323C5F

# Instantiate a file system watcher
$watcher = New-Object System.IO.FileSystemWatcher

# Sets to monitor all subfolders
$watcher.IncludeSubdirectories = $true

# Defines folder to watch and set the watcher to raise events when one happens
$watcher.Path = "C:\Users\sergio.queiroz\Downloads"
$watcher.EnableRaisingEvents = $true

# Defines the action: every time an event fires shows a message
$action = {
    $path = $event.SourceEventArgs.FullPath
    $changeType = $event.SourceEventArgs.ChangeType
    Write-Host "$path was $changetype at $(Get-Date)"
}

# Register this event
Register-ObjectEvent $watcher 'Created' -Action $action

# Unregister this event
# Get-EventSubscriber | Unregister-Event