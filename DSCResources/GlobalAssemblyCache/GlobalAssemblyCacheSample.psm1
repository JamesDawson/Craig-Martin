Configuration GlobalAssemlyCacheSample
{   
    Node "CraigRegWeb1"
    {

        ### Make sure the GAC has the PowerShell Workflow for FIM
        GlobalAssemblyCache FimWorkflowLibrary
        {
            Ensure       = "Present"
            Name         = "FimExtensions.FimActivityLibrary"
            Version      = "2.0.0.0"
            AssemblyFile = "C:\tfs\Output\FimExtensions.FimActivityLibrary.dll"
        }
        
        # Exmaples of working with assemblies with the same simple name, but different metadata
        GlobalAssemblyCache Azure_MSSHRTMI_X86
        {
            Ensure       = "Present"
            Name         = "msshrtmi"
            Architecture = "X86"
            AssemblyFile = "C:\libs\msshrtmi\x86\msshrtmi.dll"
        }
               
        GlobalAssemblyCache Azure_MSSHRTMI_X64
        {
            Ensure       = "Present"
            Name         = "msshrtmi"
            Architecture = "Amd64"
            AssemblyFile = "C:\libs\msshrtmi\x64\msshrtmi.dll"
        }        
    }
}

GlobalAssemlyCacheSample

## Load the PowerShell GAC module (http://powershellgac.codeplex.com/)
# Import-Module gac

## Add an assembly to the GAC - use this to test that DSC can validate it
# Add-GacAssembly -Path C:\tfs\Output\FimExtensions.FimActivityLibrary.dll

### Remove the assembly from the GAC - use this to test that DSC can put it back
# Get-GacAssembly -Name FimExtensions.FimActivityLibrary | Remove-GacAssembly



