Function Use-AtThePowerOf {
    [Alias('atp')]
    <#
        .SYNOPSIS
        Returns the computing of a number at the power of provided indice

        .DESCRIPTION
        Returns the computing of a number at the power of provided indice
        take number and indice as parameter
        
        .EXAMPLE
        PS C:\> 10 | atp 2
        
        .EXAMPLE
        PS C:\> atp 10 2

        .EXAMPLE
        PS C:\> atp -EntryNumber 10 -PowerIndice 2
        #>

    Param(
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        #Specify the number to process
        [Int32]
        $EntryNumber,

        [Parameter(Mandatory,Position=1)]
        #Specify the indice to process with
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
    [Alias('gsbf')]
    <#
        .SYNOPSIS
        Returns services list

        .DESCRIPTION
        Returns services list 
        take some service properties as parameter
        
        .EXAMPLE
        PS C:\> gsbf

        .OUTPUTS
        System.Object. Get-ServiceByFilter return an object 
        containing service data
    #>

    Param(
        [Parameter(Position=0)]
        #Specify character to filter on
        [String]
        $NameLike = "*",

        [Parameter(Position=1)]
        #Specify service start mode to filter on
        [ValidateSet('Manual','Auto','Disabled', '*')]
        [String]
        $StartModeLike = "*",

        [Parameter(Position=2)]
        #Specify service state to filter on
        [ValidateSet('Stopped','Running', '*')]
        [String]
        $StateLike = "*",

        [Parameter(Position=3)]
        #Specify service status to filter on
        [ValidateSet('OK','KO','UNKNOWN', '*')]
        [String]
        $StatusLike = "*",

        [Parameter(Position=4,ValueFromPipeline)]
        #Specify the number of output row to display
        [Int32]
        $LimitAs = 20,

        [Parameter()]
        #Specify the column on which the output will be sorted
        [ValidateSet('ProcessId','Name','StartMode','State')]
        [String]
        $SortBy = "ProcessId",

        [Parameter()]
        #Specify folder path where output will be send
        [String]
        $OutFolder,

        [Parameter()]
        #Specify which columns will be selected in output file
        [System.Collections.ArrayList]
        $ColumnsToOutput = @('*')
    )

    Process {
        $ServicesObject = Get-CimInstance -Class Win32_Service | Where-Object {
            $_.Name -like "$NameLike*" -and
            $_.State -like "$StateLike" -and
            $_.StartMode -like "$StartModeLike" -and
            $_.Status -like "$StatusLike"
        } | Sort-Object -Property $SortBy

        If($Null -ne $OutFolder) {
            $OutFolder = "$OutFolder\ServiceData.csv"
            New-Item -Path $OutFolder -Force
            $ServicesObject | Select-Object $ColumnsToOutput -First $LimitAs | Export-Csv -Delimiter ';' -Path $OutFolder -Force | Out-Null
        }

        Return $ServicesObject | Select-Object -First $LimitAs
    }
}