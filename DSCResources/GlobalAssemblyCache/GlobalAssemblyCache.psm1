<#
.Synopsys
The Get-TargetResource cmdlet.
#>
function Get-TargetResource
{
    param
    (
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $Version,

        [parameter(Mandatory = $true)]
        [ValidateSet("", "None", "MSIL", "X86", "Amd64")]
        [AllowEmptyString()]
        [System.String]
        $Architecture,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $PublicKeyToken
    )

    $splat = getSpecifiedAssemblyParameters $Name $Version $Architecture $PublicKeyToken
    $gac = Get-GacAssembly @splat

    if ($gac -ne $null)
    {
        return @{
            Ensure  = "Present";
            Name    = $gac.Name
            Version = $gac.Version
            ProcessorArchitecture = $gac.ProcessorArchitecture
            PublicKeyToken = $gac.PublicKeyToken
        }
    }
    else
    {
        return @{
            Ensure  = "Absent";
            Name    = $Name
            Version = $Version
            ProcessorArchitecture = $Architecture
            PublicKeyToken = $PublicKeyToken
        }
    }
}

<#
.Synopsys
The Set-TargetResource cmdlet.
#>
function Set-TargetResource
{    
    param
    (
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $Version,

        [parameter(Mandatory = $true)]
        [ValidateSet("", "None", "MSIL", "X86", "Amd64")]
        [AllowEmptyString()]
        [System.String]
        $Architecture,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $PublicKeyToken,

        [ValidateNotNullOrEmpty()]
        [System.String]
        $AssemblyFile
    )

    $splat = getSpecifiedAssemblyParameters $Name $Version $Architecture $PublicKeyToken
    $gac = Get-GacAssembly @splat

    if ($Ensure -eq 'Present')
    {
        Write-Verbose "Ensure -eq 'Present'"
        if ($gac -eq $null)
        {
            Write-Verbose "GAC item is missing, so adding it: $AssemblyFile"
            Add-GacAssembly -Path $AssemblyFile
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        Write-Verbose "Ensure -eq 'Absent'"
        if ($gac -ne $null)
        {
            Write-Verbose "GAC item is present, so removing it: $Name"
            $gac | Remove-GacAssembly
        }
    }
}

<#
.Synopsys
The Test-TargetResource cmdlet is used to validate if the resource is in a state as expected in the instance document.
#>
function Test-TargetResource
{
    param
    (
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $Version,

        [parameter(Mandatory = $true)]
        [ValidateSet("", "None", "MSIL", "X86", "Amd64")]
        [AllowEmptyString()]
        [System.String]
        $Architecture,

        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [System.String]
        $PublicKeyToken,

        [ValidateNotNullOrEmpty()]
        [System.String]
        $AssemblyFile
    )

    $splat = getSpecifiedAssemblyParameters $Name $Version $Architecture $PublicKeyToken
    $gac = Get-GacAssembly @splat

    if ($Ensure -eq 'Present')
    {
        if ($gac -eq $null)
        {
            return $false
        }
        else
        {
            return $true
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($gac -ne $null)
        {
            return $false
        }
        else
        {
            return $true
        }
    }

    if (Test-Path $AssemblyFile)
    {
        return $true
    }
}

function getSpecifiedAssemblyParameters
{
    [CmdletBinding()]
    param
    (
        [string] $Name,
        [string] $Version,
        [string] $Architecture,
        [string] $PublicKeyToken
    )

    # Name is always mandatory
    $params = @{ Name = $Name }

    # These are optional parameters, but Get-GacAssembly doesn't allow the parameters to be null if they are specified
    if (![String]::IsNullOrEmpty($Version)) { $params += @{ Version = $Version } }
    if (![String]::IsNullOrEmpty($Architecture)) { $params += @{ ProcessorArchitecture = $Architecture } }
    if (![String]::IsNullOrEmpty($PublicKeyToken)) { $params += @{ PublicKeyToken = $PublicKeyToken } }

    return $params
}



