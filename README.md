# PowerShell

## Summary
---
- [What is PowerShell](#what-is-powershell)
    - [Introduction](#Introduction)
    - [Running PowerShell](#Running-PowerShell)
- [PowerShell language](#PowerShell-language)
    - [Variable Scope](#Variable-Scope)
    - [Automatic Variables](###Automatic-Variables)
    - [Basic notions](#Basic-notions)
        - [Printing Values](#Printing-Values)
        - [Conditions](#Condtions)
        - [Loops](#Loops)
        - [Pipeline](#Pipeline)
        - [Array](#Array)
        - [Object](#Objects)
    - [Functions](#Functions)
        - [Good Practises](#Good-practises)
        - [Basic Functions](#Basic-functions)
        - [Advanced Functions](#Advanced-Functions)
        - [Advanced Parameters](#Advanced-Parameters)
        - [ParameterSet](#ParameterSet)
        - [Comment based help](#Comment-based-help)
    - [Modules](#Modules)
        - [Modules in PowerShell](#Modules-in-PowerShell)
        - [Modules Manifest](#Modules-manifest)
    - [Configuration Files](#Configuration-Files)

## What is PowerShell
---
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
---
In PowerShell variable are defining with the dollar character: `$VariableName`. As a programmation language there is variable scope in PowerShell, here is a list of variables scopes:

Pattern        | PowerShell Scope      | Scope Detail           | Utilities              |
-------------- | --------------------- | ---------------------- | ---------------------- | 
```$MyVar```         | Local                 | Current block          | Variable inside current scope *(Default scope)* |
```$global:MyVar```  | Global                | Global for current session        | Variable accessible inside session |
```$script:MyVar```  | Script                | Global for current script         | Variable accessible from current script only |
```$using:MyVar```   | Script Block          | Callable inside a Script Block  | Calling variable inside specific scope (Parallel foreach, Invoke-Command, Start-Job)

### Automatic Variables
---
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

### Basic notions
---
#### **Printing values**
```ps1
Write-Host $Home
```

```ps1
C:\Users\Username
```

#### **Conditions**
```ps1
$A = 2
$B = 2

If($A -eq $B) {
    Write-Host "A is equal B"
}
Else {
    Write-Host "A not equal B"
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

#### **Loops**
There is two ways of looping on an object in PowerShell, ```Foreach``` and ```Foreach-Object```

```ps1
$Array = @("A", "B", "C", "D", "E")

Foreach($Element in $Array ) {
    Write-Host $Element
}

$Array | Foreach-Object {
    Write-Host $_
}
```

#### **Pipeline**
```ps1
Get-Service | Out-File -Path "C:\Service.txt"
```
Add the ```Get-Service``` result into the filename ```C:\Service.txt```. 
The pipeline allows to send the previous command result to the next one. In this case the value is send as the ```-InputObject``` parameter to ```Out-File``` command.

#### **Array**

An array in PowerShell can be declared as two different way, the first one is an object of type array that have a fixed size, element cannot be removed or added. The second one is an ArrayList where you can add or remove element :
```ps1
#Array => List of element
$MyArray = @()
$MyArray += 10 #Adding value 10
$MyArray[0] = $null #Removing 1st element

#ArrayList => Collection of element
$MySecondArray = New-Object System.Collections.ArrayList
$MySecondArray.Add(10) #Adding value 10
$MySecondArray.Remove(10) # Remove first occurence of 10
$MySecondArray.RemoveAt(0) # Remove by element index
```

#### **Objects**

An object in PowerShell is containing different elements. There is different types of object :
```ps1
#Key - Value object
$Hashtable = @{Name = 'Test'}
$Hashtable.Add('Name2', 'Test2') #Add
$Hashtable.Remove('Name2') #Remove

#PSCustomObject - Owned properties
$CustomObject = [PSCustomObject]@{Name = 'Test'}
$CustomObject | Add-Member -Name 'Name2' -MemberType NoteProperty -Value 'Test2' #Add
$CustomObject.PSObject.Properties.Remove("Name2") #Remove
```

### Functions
---
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
- ```Begin``` : code that will be executed at the beggining of the function
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
In this case we added a parameter of type ```switch``` that set his value to true if provided else to false.

#### **Advanced parameters**

The parameters in functions can be configured. Here is a list of some of possible configuration :

| Parameter configuration | Type           | Rôle |
| ----------------------- | -------------- | ------- |
| Mandatory               | Boolean   | Define if a parameter have to be specified or not |
| ValueFromPipeline       | Boolean| Define if a parameter can be send througt pipeline |
| ValidateSet             | String / Int | Define which a list of values that the parameter can take |
| ValidateScript          | ScriptBlock | Script result have to return true else the function won't be executed |
| Position                | Int | Define the positionning of the argument passed while calling the function |
| ParameterSetName | String | Define a parameter set name for a parameter |

#### **ParameterSet**
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
In a first approach this function seems more complicated but not really. You can see a specific option set above parameter name ```CmdletBinding``` this option makes our function operate like a C# compiled function. 

We can see the parameter ```DefaultParameterSetName``` that indicates which variables will have to be provided by default if function is called without parameters. 
An alias parameter have been set too ```epa``` it allows to call the function by writting it alias name.  

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
We can see in the syntax part the description of how to call our function. In our case as we have two parameters set our function have two way of be called. 

In this exemple that means that ```-Number``` parameter from parameterSet ```Test``` cannot be specified with parameter ```-Letter``` which is in other parameter set named ```Test2```. 

As the parameter ```MyString``` is in both parameter sets the parameter will have to be specified in both function call. 
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
We will take the previous function to show an exemple. To personalize the help message we are using multi-line comment ```<# #>``` with specific keywords. 

To complete the comment for parameters there is two way of doing it, the first one is to add the information in the multi line comment ```.PARAMETER ParamName``` for each parameter, and the second way is to directly add a one line comment in the parameter intruction block of the function, the two way are shown below. 

The comment block have to be write above the function without space between function name and comment block else it won't work properly :
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
Here is the result when calling ```Get-Help``` with argument ```-Full``` we can see all the comment help block that we provided that are now listed :
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

### Modules
---
#### **Modules in PowerShell**

In PowerShell we can create our own modules. A module is a little library that provides some cmdlet or functions.

To check which modules are loaded in the current PowerShell session you can use the following command : 
```ps1
Get-Module
```
To install a module you can use the command :
```ps1
Install-Module -Name ModuleName
```
Modules have to be create in specific folders to be imported. PowerShell is using an environment variable name ```$Env:PSModulePath```.
```ps1
$Env:PSModulePath -Split ';'
```
Here we can see four modules location where we can store our modules.
```
C:\Users\User\OneDrive\Documents\PowerShell\Modules
C:\Program Files\PowerShell\Modules
C:\program files\powershell\7\Modules
C:\Program Files\WindowsPowerShell\Modules
C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
```
To create of PowerShell module you have to create a folder and a powershell module file (.psm1) with the same name: ```C:\Program Files\PowerShell\Modules\MyModule\MyModule.psm1```.

There is a different type module which is a dynamic module that will exist only in memory with the command :
```ps1
New-Module -Name MyModule -ScriptBlock {function Test {Write-Host "Test"}}
```

When you create your module you are able to create some functions inside and export them at then end.
```ps1
Function Get-Name {
    Param(
        [Parameter(Mandatory)]
        [String]
        $Name
    )

    Process {
        Return $Name
    }
}

Function Get-Age {
    Param(
        [Parameter(Mandatory)]
        [Int]
        $Age
    )

    Process {
        Return $Age
    }
}

Export-ModuleMember -Function Get-Name, Get-Age
```
Now that our module is created we will import it with the following command :
```ps1
Import-Module -Name MyModule
```
We can check if the functions have been exported correctly with :
```ps1
(Get-Module -Name MyModule).ExportedCommands
```
```
Key      Value
---      -----
Get-Age  Get-Age
Get-Name Get-Name
```
We can now use the module functions as if they were PowerShell commands :
```ps1
Get-Age 10
Get-Name "MyName"
```
```
10
MyName
```

#### **Modules manifest**

The module manifest is PowerShell module configuration (.psd1), it must be stored in the module folder and have the same name.

This file allow to configure module with different parameters. 

To create a module manifest you can use the following command. The module manifest have to be in the same folder as the module and have the same name :
```ps1
New-ModuleManifest -RootModule MyModule -Path "C:\Program Files\PowerShell\7\Modules\MyModule\MyModule.psd1"
```
Here is the content of the module manifest ```MyModule.psd1``` :
```ps1
#
# Module manifest for module 'MyModule'
#
# Generated by: mathi
#
# Generated on: 02/09/2022
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'MyModule'

# Version number of this module.
ModuleVersion = '0.0.1'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '0d13baf9-1432-4883-ad62-dccc24c75401'

# Author of this module
Author = 'mathi'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) mathi. All rights reserved.'

# Description of the functionality provided by this module
# Description = ''

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
```
We can check that the manifest have been taken into account while importing the module. Before his creation the module file was imported ```MyModule.psm1``` but now the module manifest is imported ```MyModule.psd1```. 

You can specify ```-Force``` option to reload the module in current session else if the module is alredy loaded and that you made a modification and doing an import without this option the module won't be reloaded.
```ps1
Import-Module MyModule -Force
Get-Module -Name MyModule | Select-Object Version, Name
```
In the previous command we used the pipeline and the command ```Select-Object``` that is used to select properties from an inputed object. 
As we can now see the module is now versionned :
```
Version Name
------- ----
0.0.1   MyModule
```
We are able to modify every module manifest parameter to configure our module, the most used parameters are the following :
| Parameter  | Input  | Role                         |
| ---------- | ------ | ---------------------------- |
| RootModule | String | Defining the related module  |
| ModuleVersion | String | Defining module version   |
| Author | String | Name of the module creator   |
| Description | String | Describing what module does |
| PowerShell Minimum Version | String | Minimum version of PowerShell to use |
| Requires Modules | String / Array | Defining module to import before importing our module (care) 
| RequiredAssemblies | String / Array | Defining assemblies (.dll) to import before importing our module |
| NestedModules | String / Array | Defining modules to import in our module |
| FunctionsToExport | String / Array | Set which module function will be exported (default all) |
| CmdletToExport | String / Array | Set which module cmdlet will be exported (default all) |
| VariablesToExport | String / Array | Set which module variables will be exported (default all) |
| AliasToExport | String / Array | Set which module alias will be exported (default all) |


If the manifest is configured properly you are able to publish your module on a the PowerShell Gallery. You need to have Nugget package provider installed: 
```ps1
Install-PackageProvider -Name "NuGet"
```
To check that you have the package provider installed :
```ps1
Get-PackageProvider
```
The package provider are the place where the module file will be search for installation. To publish your PowerShell module you have to use the.

To publish our module on the PowerShell Gallery we can use the following command :
```ps1
Publish-Module -Name "MyModule" -NuGetApiKey "YourApiKey"
```

#### Configuration files

Configuration file in PowerShell (.psd1) are really useful in somes case to store some data that will be used many times. 

A configuration file can be stored everywhere but it's generaly better to store it in the related module folder :
```ps1
New-Item -Path "C:\Program Files\PowerShell\7\Modules\MyModule\Configuration.psd1" -ItemType File
```
Here is what will put inside our configuration file :
```ps1
@{
    Name = 'Test'
    Id = 10
    Letters = @('A', 'B', 'C')
    Values = @{
        Value1 = 'ABC'
        Value2 = 'DEF'
    }
}
```
We can try to import our configuration file with the following command by storing the value inside a variable :
```ps1
$Configuration = Import-LocalizedData -FileName "Configuration.psd1" -BaseDirectory "C:\Program Files\PowerShell\7\Modules\MyModule"

# Printing content of variable
$Configuration

Name                           Value
----                           -----
Letters                        {A, B, C}
Id                             10
Values                         {Value1, Value2}
Name                           Test
```
As we can now see, it is possible to access the variable defined in our configuration module, the variable ```$Configuration``` is now an object that have accessible properties.
```ps1
$Configuration.Letters #Arrray
A
B
C

$Configuration.Values # Object
Name                           Value
----                           -----
Value1                         ABC
Value2                         DEF

$Configuration.Values.Value1 #Accessing Values object
ABC

$Configuration.Name #String
Test

$Configuration.Id #Int
10
```

### Classes

Powershell classes are loaded **one time by session**. You can define a class like this
```ps1
#Car.psm1

Class Car {
    #Class attributes
    [String]$Model,
    [Int32]$Year

    #Intialize a constructor
    Car([String]ModelValue, [Int32]ReleaseDate) {
        $this.Model = $ModelValue
        $this.Year = $ReleaseDate
    }

    #Define a method with the output type
    [String]GetCarInfo() {
        Return $this.Model + " " $this.Year
    }
}
```
Powershell classes can be created in **ps1** script file or **psm1** module file. The way of calling is different for both.
| Script | Module |
| ------ | ------ |
| ps1    | psd1   |
| . ./scriptName | using module moduleName |

For inheritance using moduleName is quite better.

```ps1
#Bus.ps1
using module Car.psm1

Class Bus : Car {
    [String]$Size

    Bus ([Int32]$BusSize, [String]$BusName, [Int32]$BusYear) : Base($BusName, $BusYear) {
        this.Size = $BusSize
    }
}
```

Then you call a class by the following way :
```ps1
. .\Car.ps1

# 1st way of calling our class
$CarObject = [Car]::New(100, 'Renault', 2002)

# 2nd way of calling our class
$CarObject = New-Object -TypeName Car -ArgumentList 100, 'Renault', 2002

$CarObject.Model
```