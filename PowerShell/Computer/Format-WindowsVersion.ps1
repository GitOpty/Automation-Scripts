# Exemplo de uso
# Get-WMIObject Win32_OperatingSystem | Select-Object -ExpandProperty Version | .\Format-WindowsVersion.ps1 -ShowBuild
# Get-WMIObject Win32_OperatingSystem | Select-Object -ExpandProperty Version | .\Format-WindowsVersion.ps1 -WhatIf
# Get-WMIObject Win32_OperatingSystem | Select-Object -ExpandProperty Version | .\Format-WindowsVersion.ps1 -Confirm
[CmdletBinding(SupportsShouldProcess)]

param (
    [ValidatePattern('^(\d+\.){3}\d+$')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [String]
    $VersionString,

    [Switch]
    $ShowBuild
)

Process {
    Write-Verbose "Processing version string $_"

    if ($PSCmdlet.ShouldProcess($_, 'Convert')) {
        Write-Verbose "Converting System.Version object"
        $version = [Version] $_
    }

    if ($PSCmdlet.ShouldProcess($_, 'Derivate OS')) {
        Write-Verbose "Derivating actual OS from object"
        $os = switch ($version.Major, $version.Minor -join '.') {
            '10.0' { "Windows 10/Windows Server 2016" }
            '6.3' { "Windows 8.1/Windows Server 2012R2" }
            '6.2' { "Windows 8/Windows Server 2012" }
            '6.1' { "Windows 7/Windows Server 2008R2" }
            '6.0' { "Windows Vista/Windows Server 2008" }
            '5.2' { "Windows XP Professional/Windows Server 2003R2" }
            Default { "Windows XP/Windows Server 2003 or older" }
        }

        if ($ShowBuild) {
            $os + " Build " + $version.Build
        }
        else {
            $os
        }
    }

}