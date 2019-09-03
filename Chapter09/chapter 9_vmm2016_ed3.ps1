 <#    
                    
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |w|w|w|.|r|l|e|v|c|h|e|n|k|o|.|c|o|m|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                    

::System Center Virtual Machine Manager 2016 Cookbook, Third Edition (PACKT)
::Chapter 9, Managing Clouds, Fabric Updates, Resources, Clusters and new Features of 2016
                                                                                             
 #>

#region Deploying Windows Azure Pack recipe

        $VMMpool='democorp\spf-vmm'
        $Provider='democorp\spf-pws'
        $Usage=’democorp\spf-uws’
        $Adminpool=’democorp\spf-aws’
        net localgroup administrators $vmmpool /add
        net localgroup spf_vmm $vmmpool /add
        net localgroup spf_provider $provider /add
        net localgroup spf_vmm $provider /add
        net localgroup spf_admin $provider /add
        net localgroup administrators $provider /add
        net localgroup spf_usage $usage /add
        net localgroup administrators $usage /add
        net localgroup spf_admin $adminpool /add
        net localgroup administrators $adminpool /add

#endregion