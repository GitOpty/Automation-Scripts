. ".\Connect-O365.ps1"

function SendEmail {
    param (
        
        $From , $To, $Subject, $Cc, $Body, $Anexo
    )
    
}

    $SmtpServer = "smtp.office365.com"
    $SmtpPort = "587"

    
    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SmtpServer -Port $SmtpPort -UseSsl `
    -Credential ($CredentialsFile) -DeliveryNotificationOption OnSuccess