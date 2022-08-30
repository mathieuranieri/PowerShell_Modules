Function Use-AtThePowerOf {
    Param(
        [Parameter(Mandatory,Position=0)]
        [Int32]
        $EntryNumber,

        [Parameter(Mandatory,Position=1)]
        [Int32]
        $PowerIndice
    )

    Process {
        $Result = $EntryNumber

        If($PowerIndice -eq 0) {
            $Result = 1
        }

        If($PowerIndice -notin @(0, 1)) {
            2..$PowerIndice | Foreach-Object {
                $Result = $Result * $EntryNumber
            }    
        }

        Return $Result
    }
}

Function Get-ServiceByFilter {
    <#
    .SYNOPSIS
    Returns services list

    .DESCRIPTION
    Returns services list 
    take some service properties as parameter
    
    .EXAMPLE
    PS C:\> <Int> | fsvc <String> <String> <String> <String> -SortBy <String>
    
    .EXAMPLE
    PS C:\> fsvc * * * * <Int> -SortBy <String>

    .EXAMPLE
    PS C:\> fsvc * * * *

    .EXAMPLE
    PS C:\> fsvc
    #>
    Param(
        [Parameter(Position=0)]
        [String]
        $NameLike = "*",

        [Parameter(Position=1)]
        [ValidateSet('Manual','Auto','Disabled', '*')]
        [String]
        $StartModeLike = "*",

        [Parameter(Position=2)]
        [ValidateSet('Stopped','Running', '*')]
        [String]
        $StateLike = "*",

        [Parameter(Position=3)]
        [ValidateSet('OK','KO','UNKNOWN', '*')]
        [String]
        $StatusLike = "*",

        [Parameter(Position=4,ValueFromPipeline)]
        [ValidateRange(1,100)]
        [Int32]
        $LimitAs = 100,

        [Parameter()]
        [ValidateSet('ProcessId','Name','StartMode','State')]
        [String]
        $SortBy = "ProcessId"
    )

    Process {
        $ServicesObject = Get-CimInstance -Class Win32_Service | Where-Object {
            $_.Name -like "$NameLike*" -and
            $_.State -like "$StateLike" -and
            $_.StartMode -like "$StartModeLike" -and
            $_.Status -like "$StatusLike"
        } | Sort-Object -Property $SortBy

        Return $ServicesObject | Select-Object -First $LimitAs
    }
}

New-Alias -Name "**" -Value Use-AtThePowerOf -Force
New-Alias -Name "fsvc" -Value Get-ServiceByFilter -Force

