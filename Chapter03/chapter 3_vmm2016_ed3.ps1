 <#    
                    
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |w|w|w|.|r|l|e|v|c|h|e|n|k|o|.|c|o|m|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                    

::System Center Virtual Machine Manager 2016 Cookbook, Third Edition (PACKT)
::Chapter 3, Installing VMM 2016
                                                                                             
 #>

#region Creating service accounts recipe

    #Step 7

        Add-WindowsFeature -Name "RSAT-AD-PowerShell"
        $addn=(Get-ADDomain).DistinguishedName
        $ouname=Read-host "Enter OU’s name (for example, Service Accounts):"
        $vmmsrv=Read-Host “Enter VMM server name:”
        $dname=(Get-AdDomain).Name
        New-AdUser "VMM Service Account" -SamAccountName “vmm-svc” -DisplayName "VMM Service Account" `
         -AccountPassword (ConvertTo-SecureString -AsPlainText "Type account’s password" -Force) `
         -PasswordNeverExpires $true -Enabled $true -Path "OU=$ouname,$addn" 
        New-ADGroup -Name "VMM-ADMINS" -GroupCategory Security -GroupScope Global -Path "OU=$ouname,$addn"
        Add-AdGroupMember VMM-ADMINS -Members vmm-svc
        Invoke-Command -ComputerName $vmmsrv -Credential (Get-credential) `
         -ScriptBlock {net localgroup administra-tors $args[0]\vmm-admins /add} -ArgumentList $dname


#endregion
#region SQL Server Conf File
  
        ;SQL Server 2016 Configuration File
        [OPTIONS]
        ; SQL Server License Terms
        IAcceptSQLServerLicenseTerms="True"
        ; Setup Work Flow: INSTALL, UNINSTALL, or UPGRADE.
        ACTION="Install"
        ; Privacy statement when ran from the command line. 
        SUPPRESSPRIVACYSTATEMENTNOTICE="True"
        ; Microsoft R Open and Microsoft R Server terms
        IACCEPTROPENLICENSETERMS="True"
        ; English Version of SQL Server 
        ENU="True"
        ; Setup UI will be displayed, without any user interac-tion. 
        QUIETSIMPLE="True"
        ; Discover and include product updates during setup. 
        UpdateEnabled="True"
        ; Microsoft Update will be used to check for updates. 
        USEMICROSOFTUPDATE="True"
        ; Specifies features to install, uninstall, or upgrade. 
        FEATURES=SQLENGINE,FULLTEXT,RS
        ; Update Location for SQL Server Setup (MU or share) 
        UpdateSource="MU"
        ; Setup log should be piped to the console. 
        INDICATEPROGRESS="False"
        ; Setup should install into WOW64. 
        X86="False"
        ; Specify a default or named instance
        INSTANCENAME="MSSQLSERVER"
        ; Installation directory for shared components.
        INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server"
        ; Installation directory for the WOW64 shared components. 
        INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server"
        ; Instance ID for the SQL Server features
        INSTANCEID="MSSQLSERVER"
        ; Specifies which mode report server is installed in.  
        RSINSTALLMODE="DefaultNativeMode"
        ; TelemetryUserNameConfigDescription 
        SQLTELSVCACCT="NT Service\SQLTELEMETRY"
        ; TelemetryStartupConfigDescription 
        SQLTELSVCSTARTUPTYPE="Automatic"
        ; Specify the installation directory. 
        INSTANCEDIR="C:\Program Files\Microsoft SQL Server"
        ; Agent account name 
        AGTSVCACCOUNT="RLLAB\sql-svc"
        ; Auto-start service after installation.  
        AGTSVCSTARTUPTYPE="Automatic"
        ; Startup type for the SQL Server service. 
        SQLSVCSTARTUPTYPE="Automatic"
        ; Level to enable FILESTREAM feature at (0, 1, 2 or 3). 
        FILESTREAMLEVEL="0"
        ; Specifies a collation type 
        SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS"
        ; Account for SQL Server service 
        SQLSVCACCOUNT="RLLAB\sql-svc"
        ; SQL Server system administrators. 
        SQLSYSADMINACCOUNTS="RLLAB\rladmin" "RLLAB\sql-admin"
        ; Provision current user as a SQL Administrator
        ADDCURRENTUSERASSQLADMIN="False"
        ; Specify 0 to disable or 1 to enable the TCP/IP proto-col. 
        TCPENABLED="1"
        ; Specify 0 to disable or 1 to enable the Named Pipes protocol. 
        NPENABLED="0"
        ; Add description of input argument FTSVCACCOUNT 
        FTSVCACCOUNT="NT Service\MSSQLFDLauncher"
        ; Startup type for Browser Service. 
        BROWSERSVCSTARTUPTYPE="Automatic"
        ; Specifies which account the report server NT service 
        RSSVCACCOUNT="RLLAB\sql-svc"
        ; Specifies the startup mode of the report server service
        RSSVCSTARTUPTYPE="Automatic"
 
#endregion
#region VMM Conf File
    
    [OPTIONS]
    ProductKey=xxxxx-xxxxx-xxxxx-xxxxx-xxxxx
    UserName=rlevchenko
    CompanyName=rlevchenko
    ProgramFiles=D:\Program Files\Microsoft System Center 2016\Virtual Machine Manager
    CreateNewSqlDatabase=1
    SqlInstanceName= MSSQLSERVER
    SqlDatabaseName=VirtualManagerDB
    RemoteDatabaseImpersonation=1
    SqlMachineName=w2k16-sql
    IndigoTcpPort=8100
    IndigoHTTPSPort=8101
    IndigoNETTCPPort=8102
    IndigoHTTPPort=8103
    WSManTcpPort=5985
    BitsTcpPort=443
    CreateNewLibraryShare=1
    LibraryShareName=MSSCVMMLibrary
    LibrarySharePath=D:\ProgramData\Virtual Machine Manager Library Files
    LibraryShareDescription=Virtual Machine Manager Library Files
    SQMOptIn = 1
    MUOptIn = 0
    VmmServiceLocalAccount = 0
    TopContainerName = "CN=VMMDKM,DC=rllab,DC=com"

#endregion