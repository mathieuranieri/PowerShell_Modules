# PowerShell Utilities

## What is PowerShell ?

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

## PowerShell language

### Variable scope

In PowerShell variable are defining with the dollar character: `$VariableName`. As a programmation language there is variable scope, here is a list of different PowerShell variables:

Pattern        | PowerShell Scope      | Scope Detail           | Utilities              |
-------------- | --------------------- | ---------------------- | ---------------------- | 
```$MyVar```         | Local                 | Current block          | Variable inside current scope *(Default scope)* |
```$global:MyVar```  | Global                | Global for current session        | Variable accessible inside session |
```$script:MyVar```  | Script                | Global for current script         | Variable accessible from current script only |
```$using:MyVar```   | Script Block          | Callable inside a Script Block  | Calling variable inside specific scope (Parallel foreach, Invoke-Command, Start-Job)
