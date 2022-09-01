# PowerShell Utilities

## What is PowerShell ?

### Introduction

PowerShell is an object **oriented programmation language** and a shell interpreter developped in C#.

PowersShell is based on **.NET Framework**. Since the version **7.0** PowerShell can be installed and used on other OS such as Linux, Mac.

There is major differences since PowerShell Core (7.0) and PowerShell (5.1) as the 7.0 version is based on an higher .NET Framework version.

The main strenghts of PowerShell are his capabilities to interact easily with objects and the simplicity of usage of the commands that PowerShell provide named cmdlets.

As PowerShell is a programmation language, we are able to create and automate many actions. The extension of a script file is *.ps1*

Extension   | Name                           | Rôle                                          |
----------- | ------------------------------ | --------------------------------------------- |
*.ps1*      | PowerShell Script              | Runnable script                               |
*.psm1*     | PowerShell Module              | Importable functions list                     |
*.psd1*     | PowerShell Configuration file  | Importable configuration providing variables  |
*.ps1xml*   | PowerShell XML File            | Configure how objects output are displayed    |

### Running PowerShell

- powershell.exe (PowerShell 5.1 and prior)
- pwsh.exe (PowerShell Core 7.0 and later)
- powershell_ise.exe (PowerShell ISE)

## PowerShell language

### Variable scope

In PowerShell variable are defining with the dollar character: `$VariableName`. As a programmation language there is variable scope in PowerShell, here is a list of variables scopes:

Pattern        | PowerShell Scope      | Scope Detail           | Utilities              |
-------------- | --------------------- | ---------------------- | ---------------------- | 
```$MyVar```         | Local                 | Current block          | Variable inside current scope *(Default scope)* |
```$global:MyVar```  | Global                | Global for current session        | Variable accessible inside session |
```$script:MyVar```  | Script                | Global for current script         | Variable accessible from current script only |
```$using:MyVar```   | Script Block          | Callable inside a Script Block  | Calling variable inside specific scope (Parallel foreach, Invoke-Command, Start-Job)

### Automatic Variables

PowerShell provide some automatic variables that can be really useful in many cases. Here is a list of some of them:

Variable       | Output                 | Type            |
-------------- | ---------------------- | --------------- |
```$Error```         | Return all registered errors     | Array       |
```$True``` | Return True  | Boolean         |
```$False``` | Return False | Boolean
```$Null``` | Return nothing or set a value to null | None
```$Home```          | Return user directory | String          |
```$Matches```       | Return the element that matched when match argument have been used | Object |
```$MyInvocation```  | Return information about executed command or script like path of execution | Object |
```$Args``` | Return all provided arguments to a script or function | Array | 
```$PSCommandPath``` | Return the path of the executed script or function | String |
```$PSScriptRoot``` | Return parent folder of the executed script | String |
```$PSVersionTable``` | Return the PowerShell version information | Object |
```$PSItem``` | Return active object from pipeline value | All |
```$_``` | Return active object from pipeline value | All |
```$Profile``` | Return the user active PowerShell profile | String |

### Basic commands

**Printing value**
```ps1
Write-Host $Home
```

```ps1
C:\Users\Username
```

**Basic condition**
```ps1
$A = 2
$B = 2

If($A -eq $B) {
    Write-Host "A is equal B"
}
```
```ps1
A is equal B
```
The condition operator in PowerShell are specifc :
- ne : not equal
- eq : equal
- gt : greater than
- lt : lesser than
- ...



**Command combination with pipeline**
```ps1
Get-Service | Out-File -Path "C:\Service.txt"
```
Add the ```Get-Service``` result into the filename ```C:\Service.txt```. 
The pipeline allows to send the previous command result to the next one. In this case the value is send as the ```-InputObject``` parameter to ```Out-File``` command.


### Functions

#### **Good practises**

To declare a function in PowerShell you have to name your function will the following syntax : ```Verb-Noun```. You can check the different authorized verb with the command :
```ps1
Get-Verb
```

#### **Basic functions**
```ps1
Function Write-Text {
    Write-Host $args[0]
}
```
The ```$args``` parameter is accessible from any functions, script blocks.
This function will write in the console the argument passed as parameter, it can be calls like :
```ps1
Write-Text "Text"
```
```ps1
Text
```

#### **Advanced functions**

Functions in PowerShell are structured with different statements.
- ```Param``` : where all the function parameter will be define
- ```Begin``` : code that will be executed at the begginin of the function
- ```Process``` : main code of the function
- ```End``` : code executed at the end of the function

Exemple :
```ps1
Function Get-String {
    Param(
        #Déclaration du paramètre String
        [String]$String,

        #Déclaration du paramètre Output
        [Switch]$Output
    )

    Begin {
        Write-Host "Function will start"
    }

    Process {
        If($Output) {
            Write-Host $String
        }

        Else {
            Write-Host "Nothing to do !"
        }
    }

    End {
        Write-Host "Function ended"
    }
}
```
Execution with Output parameter
```ps1
Get-String -String Power -Output
```
```
Function will start
Power
Function ended
```
Execution without Output parameter
```ps1
Get-String -String Power
```
```
Function will start
Nothing to do !
Function ended
```

#### **Advanced parameters**

The parameters in functions can be configured. Here is a list of some of possible configuration :

| Parameter configuration | Type           | Rôle |
| ----------------------- | -------------- | ------- |
| Mandatory               | True / False   | Define if a parameter have to be specified or not |
| ValueFromPipeline       | True / False | Define if a parameter can be send througt pipeline |
| ValidateSet             | String / Int | Define which a list of values that the parameter can take |
| ValidateScript          | ScriptBlock | Script result have to return true else the function won't be executed |
| Position                | Int | Define the positionning of the argument passed while calling the function |
| ParameterSetName | String | Define a parameter set name for a parameter |

#### **ParameterSet and Parameters**
```ps1
Function Edit-Parameters {
    [CmdletBinding(DefaultParameterSetName="Test")]
    [Alias("epa")]

    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline,ParameterSetName="Test")]
        [Parameter(ParameterSetName="Test2")]
        [String]
        $MyString,

        [Parameter(Mandatory=$True,ParameterSetName="Test")]
        [Int32]
        $Number,

        [Parameter(Mandatory=$True,ParameterSetName="Test2")]
        [String]
        $Letter
    )

    Process {
        If($PSCmdlet.ParameterSetName -eq "Test") {
            Write-Host "ParamSet: " $PSCmdlet.ParameterSetName
            Write-Host "String: " $MyString
            Write-Host "Number: " $Number
        }

        Else {
            Write-Host "ParamSet: " $PSCmdlet.ParameterSetName
            Write-Host "String" $String 
            Write-Host "Letter" $Letter
        }
    }
}
```
In a first approach this function seems more complicated but not really. You can see a specific option set above parameter name ```CmdletBinding``` this option makes our function operate like a C# compiled function. We can the parameter inside ```DefaultParameterSetName``` that tell which variables will have to be provided if function is called without parameters. An alias parameter have been set too ```epa``` it allows to call the function by writting it alias name.  

Exemple :
```ps1
Edit-Parameters
```
```ps1
#Arguments to supply on function call

cmdlet Edit-Parameters at command pipeline position 1
Supply values for the following parameters:
MyString: "ABCDEF"
Number: 100

#Result

ParamSet:  Test
String:  "ABCDEF"
Number:  100
```
We can use the command ```Get-Help``` that provide information on how works a specific command :
```ps1
Get-Help Edit-Parameters
```
We can see in the syntax part the description of how to call our function. In our case as we have two parameters set our function have two way of be called. In this exemple that means that ```-Number``` parameter from parameterSet ```Test``` cannot be specified with parameter ```-Letter``` which is in other parameter set named ```Test2```. As the parameter ```MyString``` is in both parameter sets the parameter will have to be specified in both function call. 
```
NAME
    Edit-Parameters

SYNTAX
    Edit-Parameters [-Number] <int> -MyString <string> [<CommonParameters>]

    Edit-Parameters -Letter <string> [-MyString <string>] [<CommonParameters>]


ALIASES
    None


REMARKS
    None
```

#### **Comment based help**

As you can see ```Get-Help``` command provides information easyly readable for an user. But we can specify a parameter to display more informations :
```ps1
Get-help Edit-Parameters -Full
```
And here as we can see we a lot more informations about our function. The good thing in PowerShell is that you can personalize it to provide more informations for users.
```
NAME
    Edit-Parameters

SYNTAX
    Edit-Parameters [-Number] <int> -MyString <string> [<CommonParameters>]

    Edit-Parameters -Letter <string> [-MyString <string>] [<CommonParameters>]


PARAMETERS
    -Letter <string>

        Required?                    true
        Position?                    Named
        Accept pipeline input?       false
        Parameter set name           Test2
        Aliases                      None
        Dynamic?                     false
        Accept wildcard characters?  false

    -MyString <string>

        Required?                    false
        Position?                    Named
        Accept pipeline input?       false
        Parameter set name           Test2, Test
        Aliases                      None
        Dynamic?                     false
        Accept wildcard characters?  false

    -Number <int>

        Required?                    true
        Position?                    0
        Accept pipeline input?       false
        Parameter set name           Test
        Aliases                      None
        Dynamic?                     false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).


INPUTS
    System.String


OUTPUTS
    System.Object

ALIASES
    None


REMARKS
    None
```
We will take the previous function to show an exemple. To personalize the help message we are using multi-line comment ```<# #>``` with specific keywords. To complete the comment for parameters there is two way of doing it, the first one is to add in the multi line comment ```.PARAMETER ParamName``` for each parameter or the second way directly to add a one line comment in the parameter intruction block, the two way are shown below. The comment block have to be write above the function without space between function name and comment block else it won't work properly :
```ps1
<#
    .SYNOPSIS
    Will return two provided values

    .DESCRIPTION
    Will return two provided values
    Take any strings and any numbers

    .PARAMETER MyString
    Specify a string to return

    .EXAMPLE
    Edit-Parameters -MyString <String> -Number <Int32>

    .EXAMPLE
    Edit-Parameters -MyString <String> -Letter <String>

    .LINK
    https://github.com/Goldenlagen/PowerShell_Modules
#>
Function Edit-Parameters {
    [CmdletBinding(DefaultParameterSetName="Test")]
    [Alias("epa")]

    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline,ParameterSetName="Test")]
        [Parameter(ParameterSetName="Test2")]
        [String]
        $MyString,

        [Parameter(Mandatory=$True,ParameterSetName="Test")]
        [Int32]
        #Specify a number to return
        $Number,

        [Parameter(Mandatory=$True,ParameterSetName="Test2")]
        #Specify a string to return
        [String]
        $Letter
    )

    Process {
        If($PSCmdlet.ParameterSetName -eq "Test") {
            Write-Host "ParamSet: " $PSCmdlet.ParameterSetName
            Write-Host "String: " $MyString
            Write-Host "Number: " $Number
        }

        Else {
            Write-Host "ParamSet: " $PSCmdlet.ParameterSetName
            Write-Host "String" $String 
            Write-Host "Letter" $Letter
        }
    }
}
```
```ps1
Get-Help Edit-Parameters -Full
```
Here is the result when calling ```Get-Help``` with argument ````-Full``` we can see all the comment help block that we provided that are now listed :
```
NAME
    Edit-Parameters

SYNOPSIS
    Will return two provided values


SYNTAX
    Edit-Parameters -MyString <String> -Number <Int32> [<CommonParameters>]

    Edit-Parameters [-MyString <String>] -Letter <String> [<CommonParameters>]


DESCRIPTION
    Will return two provided values
    Take any strings and any numbers


PARAMETERS
    -MyString <String>
        Specify a string to return

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       true (ByValue)
        Accept wildcard characters?  false

    -Number <Int32>
        Specify a number to return

        Required?                    true
        Position?                    named
        Default value                0
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Letter <String>
        Specify a string to return

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

    -------------------------- EXAMPLE 1 --------------------------

    Edit-Parameters -MyString <String>-Number <Int32>






    -------------------------- EXAMPLE 2 --------------------------

    Edit-Parameters -MyString <String>-Letter <String>







RELATED LINKS
    https://github.com/Goldenlagen/PowerShell_Modules

```