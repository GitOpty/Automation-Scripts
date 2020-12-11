function Get-TinyURL
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True,ParameterSetName = 'URI')] [string] $Uri,
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True,ParameterSetName = 'ReadClipboard')] [switch] $ReadClipboard,
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)] [switch] $WriteClipboard = $False

    )

    Process
    {

        If ($ReadClipboard -or $WriteClipboard)
        {
            $null = Add-Type -AssemblyName System.Windows.Forms
        }

        If ($ReadClipboard)
        {
            $Uri = [system.windows.forms.clipboard]::GetData('System.String')
        }


        $tinyURL = Invoke-WebRequest -Uri "http://tinyurl.com/api-create.php?url=$Uri" |
        Select-Object -ExpandProperty Content


        If ($WriteClipboard)
        {
            [system.windows.forms.clipboard]::SetData('System.String',$tinyURL)
        }

        $hash = @{
            Uri     = $Uri
            TinyURL = $tinyURL
        }

        New-Object -TypeName PsObject -Property $hash
    }
}