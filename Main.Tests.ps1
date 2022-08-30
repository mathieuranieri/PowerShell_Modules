BeforeAll {
    # DON'T use $MyInvocation.MyCommand.Path
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    Write-Host "Initialize Test"
}

Describe "Add-Funct" {
    It "Returns an ArrayList" {

        $Expected = 'Collections.ArrayList'

        $Actual = 1..10 | Add-Funct

        If(($Actual.GetType()).Name -eq $Expected) {
            Write-Host "Test Successfull"
        } 
        
        # Else {
        #     $throw '$Actual not expected'
        # }
    }
}