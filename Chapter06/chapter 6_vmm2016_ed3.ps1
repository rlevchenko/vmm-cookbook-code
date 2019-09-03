 <#    
                    
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |w|w|w|.|r|l|e|v|c|h|e|n|k|o|.|c|o|m|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                    

::System Center Virtual Machine Manager 2016 Cookbook, Third Edition (PACKT)
::Chapter 6, Configuring Guarded Fabric in VMM
                                                                                             
 #>

#region Deploying Host Guardian Service recipe

    #Step 1

        Get-Certificate -SubjectName "CN=rlevchenko.com" -CertStoreLocation cert:\LocalMachine\My -Template "HGS" 
        Get-Certificate -SubjectName "CN=rlevchenko.com" -CertStoreLocation cert:\LocalMachine\My -Template "HGS" 
        Export-PfxCertificate -Cert (Get-ChildItem -Path Cert:\LocalMachine\my\809FE7B7837580FB204E089BC8E001CD97B2E750) -FilePath c:\certs\hgs_sign.pfx -Password (ConvertTo-SecureString -String "P@ssw0rd1" -Force -AsPlainText) -Force
        Export-PfxCertificate -Cert (Get-ChildItem -Path Cert:\LocalMachine\my\1424F501458AB279D1F799E96A2504ABA0C45DAB) -FilePath c:\certs\hgs_encr.pfx -Password (ConvertTo-SecureString -String "P@ssw0rd1" -Force -AsPlainText) -Force


    #Step 4

        $certpassword= ConvertTo-SecureString -AsPlainText 'P@ssw0rd1' -Force
        Initialize-HgsServer -HgsServiceName 'HGS' -SigningCertificatePath 'c:\certs\hgs_sign.pfx' -SigningCertificatePassword $certpassword -EncryptionCertificatePath 'c:\cert\hgs_encr.pfx' -EncryptionCertificatePassword $certpassword -TrustActiveDirectory


    #Step 7

        Get-Certificate -SubjectName "CN=hgs.rlhgs.loc" -CertStoreLocation cert:\LocalMachine\My -Template "HGS"
        Export-PfxCertificate -Cert (Get-ChildItem -Path Cert:\LocalMachine\my\53ed0d54fc77939598c692a69c186fcfd562dd8b) -FilePath c:\certs\hgs_ssl.pfx -Password (ConvertTo-SecureString -String "P@ssw0rd1" -Force -AsPlainText) -Force
        $sslpwd = ConvertTo-SecureString -String "P@ssw0rd1" -Force -AsPlainText 
        Set-HgsServer -Http -Https -HttpsCertificatePath 'C:\cert\hgs_ssl.pfx' -HttpsCertificatePassword $sslpwd


#endregion
#region Configuring Additional HGS Cluster Nodes recipe

    #Step 2

        $adsafepass=ConvertTo-SecureString -AsPlainText 'Pass1' -Force
        $admpasswd=ConvertTo-SecureString -AsPlainText 'Pass1#!' -Force
        $creds=New-Object System.Management.Automation.PSCredential ("administrator@rlhgs.loc", $admpasswd)
        Install-HgsServer -HgsDomainName 'rlhgs.loc' -HgsDomainCredential $creds -SafeModeAdministratorPassword $adsafepass -Restart

#endregion
#region Preparing Shielded Helper VHD recipe
    
    #Step 2

        New-VM -VMName HelperVM -Generation 2 -MemoryStartupBytes 2048Mb -NewVHDPath D:\vms\rlevchenko\HelperVM\helper.vhdx -NewVHDSizeBytes 40Gb 
        Set-VM -VMName HelperVM -ProcessorCount 2
        Add-VMDvdDrive -VMName HelperVM -Path D:\vms\rlevchenko\HelperVM\ws2016.iso
        Get-VM -VMName HelperVM | Start-VM
        Get-VM -VMName HelperVM | Stop-VM

    #Step 6

        $ShieldingHelperVhd = Get-SCVirtualHardDisk -Name Helper.vhdx
        Set-SCVMMServer -ShieldingHelperVhd $ShieldingHelperVhd -RunAsynchronously 


#endregion
#region Preparing and protecting a template disk recipe

    #Step 3

        Get-Certificate -SubjectName "CN=sign.rlevchenko.com" -CertStoreLocation cert:\LocalMachine\My -Template "Sign"
        Export-PfxCertificate -Cert (Get-ChildItem -Path Cert:\LocalMachine\my\EF19A28D32AA64827070D3B33D1B52F0C96B70FE) -FilePath c:\cert\sign.pfx -Password (ConvertTo-SecureString -String "P@ssw0rd1" -Force -AsPlainText) -Force
        Import-PfxCertificate -CertStoreLocation Cert:\LocalMachine\My -FilePath C:\cert\sign.pfx -Password (ConvertTo-SecureString -AsPlainText "P@ssw0rd1" -Force)

#endregion
#region Creating and importing a shielded data file recipe
    
    #Step 1

        Get-Certificate -DNSName '*.democorp.ru' -CertStoreLocation cert:\LocalMachine\My -Template "RDP"
        Export-PfxCertificate -Cert (Get-ChildItem -Path Cert:\LocalMachine\my\8E23434F29BA067CDCE4E489FB77DDAEC93B9CCF) -FilePath c:\cert\rdp_cert.pfx -Password (ConvertTo-SecureString -String "P@ssw0rd1" -Force -AsPlainText) -Force 
    
    #Step 2    

        $LocalAdmPassword = ConvertTo-SecureString -AsPlainText "P@ssw0rd1" -Force
        $RDPCertPassword = ConvertTo-SecureString -AsPlainText "P@ssw0rd1" -Force
        New-ShieldingDataAnswerFile -AdminPassword $LocalAdmPassword -RDPCertificatePassword $RDPCertPassword -RDPCertificateFilePath C:\cert\rdp_cert.pfx -ProductKey UserSupplied -StaticIP -Path C:\sh_data\unattend.xml

    #Step 3

        $disk=Get-SCVirtualHardDisk -Name "template_disk.vhdx"
        $VSC = Get-SCVolumeSignatureCatalog -VirtualHardDisk $Disk
        $VSC.WriteToFile("C:\sh_data\templateDisk.vsc")


#endregion