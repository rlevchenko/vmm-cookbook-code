 <#    
                    
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |w|w|w|.|r|l|e|v|c|h|e|n|k|o|.|c|o|m|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                    

::System Center Virtual Machine Manager 2016 Cookbook, Third Edition (PACKT)
::Chapter 1, VMM 2016 Architecture
                                                                                             
 #>

#region Troubleshooting recipe

    msiexec /I "<MSIPackageName.msi>" /L*V "<path\logfilename>.log"
    msiexec /I "C:\setup\vmmAgent.msi" /L*V vmmagent.log
    winrm qc -q
    winrm set winrm/config/service/auth @{CredSSP="True"}
    winrm set winrm/config/winrs @{AllowRemoteShellAccess="True"}
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="2048"}
    winrm enum wmi/root/cimv2/Win32_ComputerSystem -r:http://servername:5985 [–u:YOURDOMAIN\AdminUser]
    winrm enum wmi/root/virtualization/v2/msvm_computersystem -r:http://servername:5985 [–u:YOURDOMAIN\AdminUser]
    winrm invoke GetVersion wmi/root/scvmm/AgentManagement -r:servername [–u:YOURDOMAIN\AdminUser] @{}

    logman create trace VMMDebug -v mmddhhmm -o $env:SystemDrive\VMMlogs\DebugTrace_$env:computername.ETL -cnf 01:00:00 -p Microsoft-VirtualMachineManager-Debug -nb 10 250 -bs 16 -max 512


#endregion