 <#    
                    
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |w|w|w|.|r|l|e|v|c|h|e|n|k|o|.|c|o|m|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                    

::System Center Virtual Machine Manager 2016 Cookbook, Third Edition (PACKT)
::Chapter 4, Installing a HA VMM Server
                                                                                             
 #>

#region Deploying HA Library Server recipe

    Install-WindowsFeature File-Services,Failover-Clustering –IncludeManagementTools
    Test-Cluster –Node w2k16lib01, w2k16lib02
    New-Cluster –Name vmmLibHA –Node w2k16lib01, w2k16lib02
    (Get-ClusterNetwork | ? Address -like 10.16.1.*).Name = "Cluster-Network" 
    (Get-ClusterNetwork | ? Name -notlike Internal*).Name = "Network-Traffic" 
    (Get-ClusterNetwork ClusterNetwork).Role = 3 
    (Get-ClusterNetwork NetworkTraffic).Role = 1
    Get-ClusterNetwork | Select *
    Get-ClusterResource | ? OwnerGroup -like Available* | Add-ClusterSharedVolume 

#endregion