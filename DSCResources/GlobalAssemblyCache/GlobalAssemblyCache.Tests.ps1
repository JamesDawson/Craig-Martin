$sut = 'GlobalAssemblyCache.psm1'
Import-Module "$PSScriptRoot\$sut"

Describe 'GlobalAssemblyCache DSC Resource' {

    InModuleScope 'GlobalAssemblyCache' {

        Context 'Preparing DSC resource parameters for use with the powershell-gac module' {
    
            It 'should return only the -Name parameter when other parameters are omitted' {
                
                $res = getSpecifiedAssemblyParameters -Name 'MyAssembly'

                $res.Keys.Count | Should Be 1
                $res.Name | Should Be 'MyAssembly'
            }

            It 'should return all parameters that are specified with values' {
                
                $res = getSpecifiedAssemblyParameters -Name 'MyAssembly' -Version '1.0.0' -Architecture 'Amd64'

                $res.Keys.Count | Should Be 3
                $res.Name | Should Be 'MyAssembly'
                $res.Version | Should Be '1.0.0'
                $res.ProcessorArchitecture | Should Be 'Amd64'
            }

            It 'should not return a parameter when it is specified but empty' {
                
                $res = getSpecifiedAssemblyParameters -Name 'MyAssembly' -Version '' -Architecture 'X86'

                $res.Keys.Count | Should Be 2
                $res.Keys.Contains('Version') | Should Be $false
            }
    
        }

    }


}