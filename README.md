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
<br>

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
- ne : not equel
- eq : equal
- gt : greate than
- lt : lesser than
- ...



**Command combination with pipeline**
```ps1
Get-Service | Out-File -Path "C:\Service.txt"
```
Add the ```Get-Service``` result into the filename ```C:\Service.txt```. 
The pipeline allows to send the previous command result to the next one.

### Functions

In PowerShell, function are defining with the following pattern : 
```ps1
Function MyFunct {
    Write-Host $args[0]
}
```
This function will write in the console the argument passed as parameter, it can be call like :
```ps1
MyFunct "Text"
```