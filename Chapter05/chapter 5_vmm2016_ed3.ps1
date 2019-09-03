 <#    
                    
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |w|w|w|.|r|l|e|v|c|h|e|n|k|o|.|c|o|m|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                    

::System Center Virtual Machine Manager 2016 Cookbook, Third Edition (PACKT)
::Chapter 5, Configuring Fabric Resources in VMM
                                                                                             
 #>

#region Designing for Converged Networks recipe

    #Simple Converged Networks example

        New-NetLbfoTeam -Name HV -TeamMembers pNIC1,pNIC2 ` 
        -TeamingMode SwitchIndependent -LoadBalancingAlgorithm ` Dynamic
        New-VMSwitch -InterfaceAlias HV -Name VM `
        -MinimumBandwidthMode Weight -AllowManagementOS 0
        Add-VMNetworkAdapter -Name CSV -SwitchName VM -ManagementOS
        Add-VMNetworkAdapter -Name MGM -SwitchName VM -ManagementOS
        Set-VMNetworkAdapterVlan -ManagementOS `
        -VMNetworkAdapterName "MGMT" -Access -VlanId 5
        Set-VMNetworkAdapterVlan -ManagementOS `
        -VMNetworkAdapterName "CSV" -Access -VlanId 10 
        Set-VMNetworkAdapter -ManagementOS -Name CSV `
        -MinimumumBandwidthMode 50
        Set-VMNetworkAdapter -ManagementOS -Name MGM `
        -MinimumumBandwidthMode 50

    #SET Switch

        New-VMSwitch -Name SET -NetAdapterName "pNIC1","pNIC2" `
        -MinimumBandwidthMode Weight `
        -EnableEmbeddedTeaming $True
        Set-VMSwitchTeam -SwitchName SET -LoadBalancingAlgorithm ` Dynamic
        Set-VMSwitch -SwitchName SET -NetAdapterName “pNIC1”


    #DCB Example

        Install-WindowsFeature Data-Center-Bridging
        New-NetQosPolicy "SMB" -NetDirectPortMatchCondition 445 `
         -PriorityValue8021Action 3
        Enable-NetQosFlowControl -Priority 3
        Disable-NetQosFlowControl -Priority 0,1,2,4,5,6,7
        Enable-NetAdapterQos -InterfaceAlias "ST-A"
        New-NetQosTrafficClass "SMB" -Priority 3 `
        -BandwidthPercentage 40 -Algorithm ETS

#endregion
#region Deploying a Network Controller using VMM

    #Step 4

        Install-WindowsFeature RSAT-AD-PowerShell
        New-ADGroup -Name NC-Clients -GroupScope DomainLocal `
        -GroupCategory Security
        New-ADGroup -Name NC-Admins -GroupScope DomainLocal `
        -GroupCategory Security
        New-AdUser NC_Admin -SamAccountName nc.admin `
        -AccountPassword (ConvertTo-SecureString -AsPlainText `
        "P@ssw0rd1" -Force) -PasswordNeverExpires $true -Enabled $true
        Add-ADGroupMember NC-Admins -Members nc.admin
        Add-ADGroupMember NC-Clients -Members nc.admin
        New-SCVMHostGroup SDN -ParentHostGroup "All Hosts"
     
    #Step 14

        [NewRequest]
        Subject = "CN=nc-vm01.rllab.com"
        KeyLength =  2048
        KeySpec = 1
        Exportable = True
        ExportableEncrypted=True
        ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
        HashAlgorithm = SHA256
        MachineKeySet = True
        SMIME = False
        UseExistingKeySet = False
        RequestType = PKCS10
        KeyUsage = 0xA0
        Silent = True
        FriendlyName = "NC Certificate"
        [EnhancedKeyUsageExtension]
        OID=1.3.6.1.5.5.7.3.1
        [Extensions]
        2.5.29.17 = "{text}" 
        _continue_ = "dns=nc-vm01.rllab.com&"

     #Step16

        certreq -new c:\cert\nc_certconf.inf c:\cert\nc_cert.req
        certreq -submit -config SVC01\Root-CA -attrib "Certificate-Template:WebServer" c:\cert\nc_cert.req c:\cert\nc_cert.cer
        certutil -addstore -f MY C:\cert\nc_cert.cer
        certutil -repairstore MY nc-vm01.rllab.com
        Certutil -privatekey -exportPFX -p P@ssw0rd1 My nc-vm01.rllab.com c:\cert\nc_srv.pfx
        certutil –privatekey –delstore MY nc-vm01.rllab.com
        certutil "-ca.cert" -config SVC01\Root-CA c:\cert\rootca.cer 


#endregion
