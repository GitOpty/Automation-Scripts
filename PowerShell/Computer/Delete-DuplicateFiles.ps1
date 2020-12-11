Function Get-FolderName
{
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
[void]$FolderBrowser.ShowDialog()
$FolderBrowser.SelectedPath
}

Function Set-Shortcut {
param ( [string]$SourceLnk, [string]$DestinationPath )
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($SourceLnk)
    $Shortcut.TargetPath = $DestinationPath
    $Shortcut.Save()
    }

##Set your path

#$mypath = Get-FolderName
$mypath = "C:\Users\sergio.queiroz\Downloads"

##Remove unique record by size (different size = different hash)
$RUBySize = Get-ChildItem -path $mypath -Recurse -Include "*.*" | ? {( ! $_.ISPScontainer)} | Group Length | ? {$_.Count -gt 1} | Select -Expand Group | Select FullName, Length

##Remove unique record by hash (generates SHA-1 hash and removes unique records)
$RUByHash = foreach ($i in $RUBySize) {Get-FileHash -Path $i.Fullname -Algorithm MD5}
$RUByHash = $RUByHash | Sort-Object Hash

##Throw output with duplicity files

#Filter empty folders and output an dialog box
If ($RUByHash.count -eq 0) {
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$objForm = New-Object System.Windows.Forms.Form
$objForm.Text = "No Duplicates found"
$objForm.Size = New-Object System.Drawing.Size(300,100)
$objForm.StartPosition = "CenterScreen"
$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter")
    {$x=$objTextBox.Text;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
    {$objForm.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(120,10)
$OKButton.Size = New-Object System.Drawing.Size(40,30)
$OKButton.Text = "OK"
$OKButton.Add_Click({$x=$objTextBox.Text;$objForm.Close()})
$objForm.Controls.Add($OKButton)

$objForm.Topmost = $True
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()
}


#Handle file dupicates
If ($RUByHash.count -gt 0) {

# Gather File stats
$Title1= $RUByHash.count| Out-String
$Savings = ($RUBySize |select -Skip 1 | Measure-Object -property length -sum).Sum

#Output GridView display
$RUByHash|Out-GridView  -Title "$Title1 Duplicate Files with a potential  savings of $Savings bytes" -PassThru

#Delete or not delete duplicate files
#$RUByHash|Remove-Item -Confirm
}

#Check hashes for all items and if they match, compare creation date time. Then delete the newer item while keeping the older item
$File_To_Delete = @()
$count = $RUByHash.Count
for ( $i = 0; $i -le $count; $i++) {
    for ( $j = $i +1; $j -le $count; $j++) {

        #Check if hashes are equal
        if($RUByHash[$i].Hash -eq $RUByHash[$j].Hash) {
            #Getting dates to compare
            $date1 = (Get-ChildItem $RUByHash[$i].Path).CreationTime
            $date2 = (Get-ChildItem $RUByHash[$j].Path).CreationTime

            if($date1 -le $date2) {
                $File_To_Delete += $RUByHash[$j].Path
                $shortcutname = $RUByHash[$j].Path.Substring(0, $RUByHash[$j].Path.LastIndexOf('.'))
                $shortcutname += ".lnk"
                $shortcutpath = $RUByHash[$i].Path
                set-shortcut "$shortcutname" "$shortcutpath"
            }
        }
    }
}

$File_To_Delete = $File_To_Delete | Select -Unique
$File_To_Delete|Remove-Item -Confirm