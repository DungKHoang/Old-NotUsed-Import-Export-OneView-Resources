##############################################################################
#
#   Export-OVResources.ps1
#
#   - Export resources from OneView instaces or Synergy Composers to CSV files
#
#   VERSION 2.0
#
# (C) Copyright 2013-2018 Hewlett Packard Enterprise Development LP
##############################################################################
<#
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

  .SYNOPSIS
     Export resources to OneView appliance.

  .DESCRIPTION
	 Export resources to OneView appliance.

  .EXAMPLE

     .\Export-OVResources.ps1 -All -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password <admin-password> -OVAuthDomain Local -OneViewModule HPOneView.410
    The script connects to the SynergyComposer or OneView appliance using HPOneView.410 POSH module and exports all OV resources from a set of pre-defined CSV files

    .\ Export-OVResources.ps1 -OVEthernetnetworksCSV .\net.csv 
    Exports Ethernet networks to the net.csv file

    .\Export-OVResources.ps1 -OVFCnetworksCSV .\fc.csv
    Export FC networks to the fc.csv file

    .\Export-OVResources.ps1 -OVLogicalInterConnectGroupCSV .\lig.csv
    Export logical Interconnect groups to the lig.csv file

    .\Export-OVResources.ps1 -OVUplinkSetCSV .\upl.csv
    Export Uplink set to the upl.csv file

    .\Export-OVResources.ps1 -OVEnclosureGroupCSV .\EG.csv
    Export EnclosureGroup to the EG.csv file

    .\Export-OVResources.ps1 -OVEnclosureCSV .\Enc.csv
    Export Enclosure to the Enc.csv file

    .\Export-OVResources.ps1 -OVProfileCSV .\profile.csv -OVProfileConnectionCSV .\connection.csv
    Export server profiles to the profile.csv and connection.csv files

    .\Export-OVResources.ps1 -All
    Export all OV resources to a set of pre-defined CSV files

  .PARAMETER OVApplianceIP                   
    IP address of the  Synergy Composer or OV appliance

  .PARAMETER OVAdminName                     
    Administrator name of the appliance

  .PARAMETER OVAdminPassword                 
    Administrator s password

  .PARAMETER OneViewModule
    OneView POSH module -default is HPOneView.410 

  .PARAMETER All
    Export all resources

  .PARAMETER OVEthernetNetworksCSV
    Path to the CSV file containing Ethernet networks definition

  .PARAMETER OVFCNetworksCSV
    Path to the CSV file containing FC networks definition

  .PARAMETER OVSANManagerCSV
    Path to the CSV file containing SAN Managers definition

  .PARAMETER OVStorageSystemCSV
    Path to the CSV file containing Storage Systems definition

  .PARAMETER OVLogicalInterConnectGroupSV
    Path to the CSV file containing Logical Interconnect Group

  .PARAMETER OVUpLinkSetCSV
    Path to the CSV file containing UplinkSet

  .PARAMETER OVEnclosureGroupCSV
    Path to the CSV file containing Enclosure Group

  .PARAMETER OVEnclosureCSV
    Path to the CSV file containing Enclosure definition

  .PARAMETER OVLogicalEnclosureCSV
    Path to the CSV file containing Logical Enclosure definition

  .PARAMETER OVProfileCSV
    Path to the CSV file containing Server Profile definition

  .PARAMETER OVProfileTemplateCSV
    Path to the CSV file containing Server Profile Template definition

  .PARAMETER OVProfileConnectionCSV
    Path to the CSV file containing Profile Connections definition

  .PARAMETER OVProfileLOCALStorageCSV
    Path to the CSV file containing Profile LOCAL Storage definition

  .PARAMETER OVProfileSANStorageCSV
    Path to the CSV file containing Profile SAN Storage definition

  .PARAMETER OVSANManagerCSV
    Path to the CSV file containing SANManager definition

  .PARAMETER OVStorageSystemCSV
    Path to the CSV file containing Storage System definition

  .PARAMETER OVStorageVolumeTemplateCSV
    Path to the CSV file containing Storage Volume Template definition

  .PARAMETER OVStorageVolumeCSV
    Path to the CSV file containing Storage Volume definition

  .PARAMETER OVAddressPoolCSV
    Path to the CSV file containing Address Pool definition

  .PARAMETER OVwwnnCSV
    Path to the CSV file containing WWnn definition

  .PARAMETER OVIPAddressCSV
    Path to the CSV file containing IP Address definitions

  .PARAMETER OVBackupConfig
    Path to the CSV file containing the scheduled OneView backup configurations, minus the login password to the remote server

  .PARAMETER OVRSConfig
    Path to the CSV file containing the OneView remote support configuration

  .PARAMETER OVProxyCSV
    Path to the CSV file containing the OneView proxy configuration

  .PARAMETER OVLdapCSV
    Path to the CSV file containing the LDAP configuration

  .PARAMETER OVLdapGroupsCSV
    Path to the CSV file containing the configured LDAP Groups
#>


# ------------------ Parameters
Param ( [string]$OVApplianceIP                  = "", 
        [string]$OVAdminName                    = "", 
        [string]$OVAdminPassword                = "",
        [string]$OVAuthDomain                   = "local",
        [string]$OneViewModule                  = "HPOneView.410",

        [switch]$All,

        [string]$OVEthernetNetworksCSV          = "",
        [string]$OVNetworkSetCSV                = "",
        [string]$OVFCNetworksCSV                = "",

        [string]$OVSANManagerCSV                = "",
        [string]$OVStorageSystemCSV             = "",
        [string]$OVStorageVolumeTemplateCSV     = "",
        [string]$OVStorageVolumeCSV             = "",

        [string]$OVLogicalInterConnectGroupCSV  = "",
        [string]$OVUpLinkSetCSV                 = "",
        [string]$OVEnclosureGroupCSV            = "",
        [string]$OVDLServerCSV                  = "",
        [string]$OVEnclosureCSV                 = "",
        [string]$OVLogicalEnclosureCSV          = "",

        [string]$OVProfileCSV                   = "",
        [string]$OVProfileTemplateCSV           = "",
        [string]$OVProfileConnectionCSV         = "",
        [string]$OVProfileLOCALStorageCSV       = "",
        [string]$OVProfileSANStorageCSV         = "",

        [string]$OVAddressPoolCSV               = "",
        [string]$OVwwnnCSV                      = "",
        [string]$OVIPAddressCSV                 = "",
        [string]$OVOSDeploymentCSV              = "",
        [string]$OVTimeLocaleCSV                = "",
        [string]$OVSmtpCSV                      = "",
        [string]$OVAlertsCSV                    = "",
        [string]$OVScopesCSV                    = "",
        [string]$OVUsersCSV                     = "",
        [string]$OVFWReposCSV                   = "",
        [string]$OVBackupConfig                 = "",
        [string]$OVRSConfig                     = "",
        [string]$OVProxyCSV                     = "",
        [string]$OVLdapCSV                      = "",
        [string]$OVLdapGroupsCSV                = ""

        

)


$DoubleQuote    = '"'
$CRLF           = "`r`n"
$Delimiter      = "\"   # Delimiter for CSV profile file
$Sep            = ";"   # Use for multiple values fields
$SepChar        = '|'
$CRLF           = "`r`n"
$OpenDelim      = "={"
$CloseDelim     = "}"
$CR             = "`n"
$Comma          = ','
$HexPattern     = "^[0-9a-fA-F][0-9a-fA-F]:"


# ------------------ Headers
$NSHeader            = "NetworkSet,NSdescription,NSTypicalBandwidth,NSMaximumBandwidth,UplinkSet,LogicalInterConnectGroup,Networks,Native"
$NetHeader           = "NetworkSet,NSTypicalBandwidth,NSMaximumBandwidth,UplinkSet,LogicalInterConnectGroup,NetworkName,Type,vLANID,vLANType,Subnet,TypicalBandwidth,MaximumBandwidth,SmartLink,PrivateNetwork,Purpose"
$FCHeader            = "NetworkName,Description,Type,FabricType,ManagedSAN,vLANID,TypicalBandwidth,MaximumBandwidth,LoginRedistribution,LinkStabilityTime"
$LigHeader           = "LIGName,FrameCount,InterConnectBaySet,InterConnectType,BayConfig,Redundancy,InternalNetworks,IGMPSnooping,IGMPIdleTimeout,FastMacCacheFailover,MacRefreshInterval,NetworkLoopProtection,PauseFloodProtection,EnhancedLLDPTLV,LDPTagging,SNMP,QOSConfiguration"
$UplHeader           = "LIGName,UplinkSetName,UpLinkType,UpLinkPorts,Networks,NativeEthernetNetwork,EthMode,lacpTimer,FcSpeed"
$EGHeader            = "EnclosureGroupName,Description,LogicalInterConnectGroupMapping,EnclosureCount,IPv4AddressType,AddressPool,DeploymentNetworkType,DeploymentNetwork,PowerRedundantMode"
$EncHeader           = "EnclosureGroupName,EnclosureName,EnclosureSN,OAIPAddress,OAAdminName,OAAdminPassword,LicensingIntent,FWBaseLine,FwInstall,MonitoredOnly"
$LogicalEncHeader    = "LogicalEnclosureName,Enclosure,EnclosureGroup,FWBaseLine,FWInstall"
$DLServerHeader      = "ServerName,AdminName,AdminPassword,Monitored,LicensingIntent"
$ProfileHeader       = "ProfileName,Description,AssignmentType,Enclosure,EnclosureBay,Server,ServerTemplate,NotUsed,ServerHardwareType,EnclosureGroup,Affinity,OSDeployName,OSDeployParams,FWEnable,FWBaseline,FWMode,FWInstall,BIOSSettings,BootOrder,BootMode,PXEBootPolicy,MACAssignment,WWNAssignment,SNAssignment,hideUnusedFlexNics"
$PSTHeader           = "ProfileTemplateName,Description,ServerProfileDescription,ServerHardwareType,EnclosureGroup,Affinity,OSDeployName,OSDeployParams,FWEnable,FWBaseline,FWMode,FWInstall,BIOSSettings,BootOrder,BootMode,PXEBootPolicy,MACAssignment,WWNAssignment,SNAssignment,hideUnusedFlexNics"
$ProfilePSTHeader    = "ServerProfileName,Description,ServerProfileTemplate,Server,AssignmentType"
$SANManagerHeader    = "SanManagerName,Type,Username,Password,Port,UseSSL,snmpAuthLevel,snmpAuthProtocol,snmpAuthUsername,snmpAuthPassword,snmpPrivProtocol,snmpPrivPassword"
$StSHeader           = "StorageHostName,StorageFamilyName,StorageAdminName,StorageAdminPassword,StoragePorts,StorageDomainName,StoragePools"
$StVolTemplateHeader = "TemplateName,Description,StoragePool,StorageSystem,Capacity,ProvisionningType,Shared,Dedupe,SnapShotStoragePool,DataProtection,AOEnabled"
$StVolumeHeader      = "VolumeName,Description,StoragePool,StorageSystem,VolumeTemplate,Capacity,ProvisionningType,Shared,Dedupe,SnapShotStoragePool,DataProtection,AOEnabled"
$ConnectionHeader    = "ServerProfileName,ConnectionName,ConnectionID,NetworkName,PortID,RequestedBandwidth,Bootable,BootPriority,UserDefined,ConnectionMACAddress,ConnectionWWNN,ConnectionWWPN,ArrayWWPN,LunID"
$LOCALStorageHeader  = "ProfileName,EnableLOCALstorage,ControllerMode,ControllerInitialize,LogicalDisks,Bootable,DriveType,RAID,NumberofDrives,MinDriveSize,MaxDriveSize"
$SANStorageHeader    = "ProfileName,EnableSANstorage,HostOSType,VolumeName,Lun"
$AddressPoolHeader   = "PoolName,PoolType,RangeType,StartAddress,EndAddress,NetworkID,SubnetMask,Gateway,DnsServers,DomainName"
$wwnnHeader          = "BayName,WWNN,WWPN"
$IPHeader            = "Location,Type,BayNumber,ipAddress"
$OSDSHeader          = "DeploymentServerName,Description,ManagementNetwork,ImageStreamerAppliance"
$TimeHeader          = "Locale,TimeZone,SyncWithHost,NTPServers"
$SmtpHeader          = "SmtpEmail,SmtpPassword,SmtpServer,SmtpPort,SmtpSecurity"
$AlertHeader         = "AlertFilterName,AlertFilter,AlertEmails"
$UserHeader          = "UserName,UserFullName,UserPassword,UserEmail,UserOfficePhone,UserMobilePhone,UserRoles"
$ScopeHeader         = "ScopeName,ScopeDescription,ScopeResources"
$FWRepoHeader        = "FWRepoName,FWRepoUrl,FWRepoUserName,FWRepoPassword"
$BackupHeader        = "remoteServerName,remoteServerDir,userName,password,protocol,scheduleInterval,scheduleDays,scheduleTime,remoteServerPublicKey"
$OVRSHeader          = "Enabled,Company,AutoEnableDevices,MaketingOpIn,InsightOnlineEnabled,FirstName,LastName,Email,Primary,Default,StreetAddress1,StreetAddress2,City,State,PostalCode,CountryCode,TimeZone"
$ProxyHeader         = "ProxyProtocol,ProxyServer,ProxyUser,ProxyPasswd,ProxyPort"
$LDAPHeader          = "LDAPdirname,LDAPprotocol,LDAPbaseDN,LDAPuser,LDAPpass,LDAPbinding,LDAPsvrIP,LDAPsvrPort"
$LDAPGroupHeader     = "LDAPGroupname,LDAPGroupDomain,LDAPGroupRoles,LDAPusername,LDAPpassword"


#------------------- Interconnect Types
$ICTypes         = @{
    "571956-B21" =  "FlexFabric" ;
    "455880-B21" =  "Flex10"     ;
    "638526-B21" =  "Flex1010D"  ;
    "691367-B21" =  "Flex2040f8" ;
    "572018-B21" =  "VCFC20"     ;
    "466482-B21" =  "VCFC24"     ;
    "641146-B21" =  "FEX"
}


#------------------- Functions
function Get-Header-Values([PSCustomObject[]]$ObjList)
{
    ForEach ($obj in $ObjList)
        {
            # --------
            # Get Properties name out PSCustomObject
            $Properties   = $obj.psobject.Properties
            $PropNames    = @()
            $PropValues   = @()

            ForEach ($p in $Properties)
            {
                $PropNames    += $p.Name
                $PropValues   += $p.Value
            }

           $header         = $PropNames -join $Comma
           $ValuesArray   += $($PropValues -join $Comma) + $CR
        }

    return $header, $ValuesArray
}


function Get-NamefromUri([string]$uri)
{
    $name = ""

    if ($Uri)
    {
        try
        {
            $name   = (Send-HPOVRequest $Uri).Name
        }
        catch
        {
            $name = ""
        }
    }

    return $name
}


function Get-TypefromUri([string]$uri)
{
    $type = ""

    if ($Uri)
    {
        try
        {
            $type   = (Send-HPOVRequest $Uri).Type
        }
        catch
        {
            $type = ""
        }
    }

    return $type
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-TimeLocale
##
## -------------------------------------------------------------------------------------------------------------
function Export-TimeLocale ([string]$OutFile)
{
    $ValuesArray        = @()
    $TimeLocale         = Get-HPOVApplianceDateTime -ErrorAction Stop

    if ($TimeLocale)
    {
        $Locale         = $TimeLocale.Locale.Split(".")[0]
        $TimeZone       = $TimeLocale.TimeZone
        $SyncWithHost   = $TimeLocale.SyncWithHost
        $NtpServers     = $TimeLocale.NtpServers
    }

    $ListofNTP  = ""
    if ($NtpServers)
    {
        [array]::sort($NtpServers)
        $ListofNTP = $NtpServers -join $SepChar
    }

    $ValuesArray += "$Locale,$TimeZone,$SyncWithHost,$ListofNTP"

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Date and Locale information to CSV file --> $OVTimeLocaleCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $TimeHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Time and Locale not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-SMTP
##
## -------------------------------------------------------------------------------------------------------------
function Export-SMTP ([string]$OutFile)
{
    $ValuesArray        = @()
    $SmtpData           = Get-HPOVSMTPConfig -ErrorAction Stop

    if ($SmtpData)
    {
        $Email          = $SmtpData.senderEmailAddress
        $Password       = "***Info N/A***"
        $Server         = $SmtpData.smtpServer
        $Port           = $SmtpData.smtpPort
        $Security       = if ($SmtpData.smtpProtocol -eq "PLAINTEXT") { "None" } else { $SmtpData.smtpProtocol }
    }

    #
    # If no SMTP Email addresss is configured, do not collect
    #
    if ($Email)
    {
        $ValuesArray += "$Email,$Password,$Server,$Port,$Security"

        Write-Host -ForegroundColor Cyan "Exporting SMTP information to CSV file            --> $OVSmtpCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $SmtpHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  SMTP not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-LDAP
##
## -------------------------------------------------------------------------------------------------------------
function Export-LDAP ([string]$OutFile)
{
    $ValuesArray    = @()
    $_BuiltInCertAuthorityCerts = @(

            "VeriSign Class 3 Public Primary Certification Authority - G5",
            "VeriSign Universal Root Certification Authority",
            "Symantec Class 3 Secure Server CA - G4",
            "Symantec Class 3 Secure Server SHA256 SSL CA",
            "DigiCert Global CA G2",
            "DigiCert Global Root G2"

    )

    $_BaseCerts = Get-HPOVApplianceTrustedCertificate -CertificateAuthoritiesOnly -ErrorAction SilentlyContinue

    $_CertsToReplicateCol = New-Object System.Collections.ArrayList

    # Prune the certs list to exclude appliance included known cert authorities
    ForEach ($_CertName in (Compare-Object -ReferenceObject $_BuiltInCertAuthorityCerts -DifferenceObject $_BaseCerts.Name -PassThru))
    {
        $_CertToReplicate = $_BaseCerts | ? Name -eq $_CertName
        [void]$_CertsToReplicateCol.Add($_CertToReplicate)
    }

    # At this point the certs we need to replicate are in $_CertsToReplicateCol
    $_CertToReplicate = $null

    foreach ($_CertToReplicate in $_CertsToReplicateCol)
    {
        $_CertBase64    = Send-HPOVRequest -method GET -uri $_CertToReplicate.Uri.OriginalString
        $_CertFileName  = $_CertBase64.certificateDetails.issuer + ".cer"
        Write-Host -ForegroundColor Cyan "Exporting LDAP Trusted Certificate to file        --> $_CertFileName"
        $_CertBase64.certificateDetails.base64Data | Out-File -FilePath "${_CertFileName}"
    }

    $LDAPdirs       = Get-HPOVLdapDirectory
    foreach ($DIR in $LDAPdirs)
    {
        $DIRname        = $DIR.name
        $DIRprotocol    = $DIR.authProtocol
        $DIRbaseDN      = $DIR.baseDN.Replace(",", ".")
        $DIRuser        = $DIR.credential.userName
        $DIRpasswd      = "***Info N/A***"
        $DIRbinding     = $DIR.directoryBindingType

        $DIRservers     = $DIR.directoryServers
        foreach ($DS in $DIRservers)
        {
            $DIRsvrIP   = $DS.directoryServerIpAddress
            $DIRsvrPort = $DS.directoryServerSSLPortNumber
        }

        $ValuesArray += "$DIRname,$DIRprotocol,$DIRbaseDN,$DIRuser,$DIRpasswd,$DIRbinding,$DIRsvrIP,$DIRsvrPort"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting LDAP information to CSV file            --> $OVLdapCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $LDAPHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Active Directory not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-Proxy
##
## -------------------------------------------------------------------------------------------------------------
function Export-Proxy ([string]$OutFile)
{
    $ValuesArray        = @()
    $ProxyData          = Get-HPOVApplianceProxy -ErrorAction Stop

    if ($ProxyData.Server)
    {
        foreach ($PD in $ProxyData)
        {
            $ProxyProtocol  = $PD.Protocol
            $ProxyServer    = $PD.Server
            $ProxyUsername  = if ($PD.Username)         { $PD.Username }        else { $NULL }
            $ProxyPasswd    = "***Info N/A***"
            $ProxyPort      = $PD.Port
        }
        $ValuesArray += "$ProxyProtocol,$ProxyServer,$ProxyUsername,$ProxyPasswd,$ProxyPort"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Proxy Configuration to CSV file         --> $OVProxyCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $ProxyHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Proxy not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-Alerts
##
## -------------------------------------------------------------------------------------------------------------
function Export-Alerts ([string]$OutFile)
{
    $ValuesArray        = @()
    $AlertData          = Get-HPOVSMTPConfig -ErrorAction Stop

    if ($AlertData.alertEmailFilters)
    {
        foreach ($AL in $AlertData.alertEmailFilters)
        {
            $AlertEmails    = $AL.emails
            $AlertFilter    = if ($AL.filter)           { $AL.filter }          else { $NULL }
            $FilterName     = if ($AL.filterName)       { $AL.filterName }      else { "" }

            if ($AlertEmails)
            {
                [array]::sort($AlertEmails)
                $ListofEmails = $AlertEmails -join $SepChar
            }
        }
        $ValuesArray += "$FilterName,$AlertFilter,$ListofEmails"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting SMTP Alerts information to CSV file     --> $OVAlertsCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $AlertHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Alerts not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-Scopes
##
## -------------------------------------------------------------------------------------------------------------
function Export-Scopes ([string]$OutFile)
{
    $ValuesArray        = @()
    $ScopeData          = Get-HPOVScope -ErrorAction Stop

    if ($ScopeData)
    {
        foreach ($SC in $ScopeData)
        {
            $ScopeName          = $SC.Name
            $ScopeDesc          = $SC.Description
            $ScopeResources     = $SC.Members
            $Resources          = ""
            $ScResList          = ""
            $ResName            = ""
            $ResType            = ""

            if ($ScopeResources.Count -ge 1)
            {
                foreach ($RES in $ScopeResources)
                {
                    $ResName    = $RES.Name
                    if ($ResName -like '*,*')
                    {
                        $ResName = ($ResName -replace ",", "\")
                    }

                    $ResType    = $RES.Type
                    if (-not $ResType)
                    {
                        continue
                    }
                    $Resources  = $ResName, $ResType -join $SepChar
                    $ScResList += "$Resources$Sep"
                }
                $ScResList      = $ScResList.Trim($Sep)
            }
            $ValuesArray += "$ScopeName,$ScopeDesc,$ScResList"
        }
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Scope information to CSV file           --> $OVScopesCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $ScopeHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Scopes not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-Users
##
## -------------------------------------------------------------------------------------------------------------
function Export-Users ([string]$OutFile)
{
    $ValuesArray        = @()
    $UserData           = Get-HPOVUser -ErrorAction Stop

    if ($UserData)
    {
        foreach ($US in $UserData)
        {
            $UserName           = $US.userName
            $ExcludeUsers       = "administrator", "HardwareSetup"
            if ($UserName -in $ExcludeUsers)
            {
                Write-Host -ForegroundColor Yellow "  Skipping System User $UserName..."
                continue
            }

            $UserFullName       = $US.fullName
            $UserPassword       = "***Info N/A***"
            $UserPermissions    = $US.permissions
            $UserEmail          = $US.emailAddress
            $UserOfficePhone    = $US.officePhone
            $UserMobilePhone    = $US.mobilePhone

            $UserRoles          = ""
            $RolesList          = ""
            if ($UserPermissions)
            {
                foreach ($ROLE in $UserPermissions)
                {
                    $RoleName   = $ROLE.roleName
                    $ScopeName   = if ($ROLE.scopeUri)  { Get-NamefromUri -uri $ROLE.scopeUri } else { "None" }
                    $UserRoles  = $RoleName, $ScopeName -join $SepChar
                    $RolesList += "$UserRoles$Sep"
                }
                $RolesList      = $RolesList.Trim($Sep)
            }
            $ValuesArray += "$UserName,$UserFullName,$UserPassword,$UserEmail,$UserOfficePhone,$UserMobilePhone,$RolesList"
        }
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting User information to CSV file            --> $OVUsersCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $UserHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Users not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-Groups
##
## -------------------------------------------------------------------------------------------------------------
function Export-Groups ([string]$OutFile)
{
    $ValuesArray        = @()
    $GroupData          = Get-HPOVLdapGroup -ErrorAction Stop

    if ($GroupData)
    {
        foreach ($GR in $GroupData)
        {
            $GroupName          = $GR.egroup
            $GroupDomain        = $GR.loginDomain

            $LDAPdomain         = Get-HPOVLdapDirectory -Name $GroupDomain
            $GroupUsername      = $LDAPdomain.credential.userName
            $GroupPassword      = "***Info N/A***"

            $GroupPerms         = $GR.permissions
            $GroupRolesList     = ""
            foreach ($Perm in $GroupPerms)
            {
                $GroupRoleName  = $Perm.roleName
                $GroupScope     = if ($Perm.scopeUri)  { Get-NamefromUri -uri $Perm.scopeUri } else { "None" }
                $GroupRoles     = $GroupRoleName, $GroupScope -join $SepChar
           
                $GroupRolesList += "$GroupRoles$Sep"
            }
            $GroupRolesList     = $GroupRolesList.Trim($Sep)
            $ValuesArray        += "$GroupName,$GroupDomain,$GroupRolesList,$GroupUsername,$GroupPassword"
        }
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting LDAP Group information to CSV file      --> $OVLdapGroupsCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $LDAPGroupHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  LDAP Groups not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-FWRepos
##
## -------------------------------------------------------------------------------------------------------------
function Export-FWRepos ([string]$OutFile)
{
    $ValuesArray        = @()
    $FWRepoData         = Get-HPOVBaselineRepository -Type External -ErrorAction Stop

    if ($FWRepoData)
    {
        foreach ($FW in $FWRepoData)
        {
            $FWRepoName     = $FW.name
            $FWRepoURL      = $FW.repositoryUrl
            $FWRepoUser     = "***Info N/A***"
            $FWRepoPass     = "***Info N/A***"
        }
        $ValuesArray += "$FWRepoName,$FWRepoUrl,$FWRepoUser,$FWRepoPass"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting FW Repository information to CSV file   --> $OVFWReposCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $FWRepoHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Firmware Repositories not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVNetwork
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVNetwork ([string]$OutFile)
{
    $ValuesArray      = @()
    $ListofNetworks   = Get-HPOVNetwork -Type Ethernet -ErrorAction Stop
    $ListofNetworkSet = Get-HPOVNetworkSet | Sort-Object Name

    foreach ($net in $ListofNetworks )
    {
        $nsName = ""
        $nspBW = ""
        $nsmBW = ""
        # ---------------------- Construct Network Set Names
        foreach ($netset in $ListofNetworkSet)
        {
            if ($netset.NetworkUris -contains $net.uri)
            {
                $Thisnetsetname = $netset.name.Trim()
                $nsName += $Thisnetsetname + $sepchar
                $nspBW  += ( 1/1000 * $netset.TypicalBandwidth).ToString() + $sepchar
                $nsmBW  += ( 1/1000 * $netset.MaximumBandwidth).ToString() + $sepchar

                # ---- Get information on Uplinkset and LogicalInterconnectGroup where a this uplinkset may belong to
                $ThisUplinkSet  = ""
                $ThisLIG        = ""

                if (Get-HPOVServerProfile)
                {
                    $ConnectionList = Get-HPOVServerProfileConnectionList
                    if ($ConnectionList.Network -contains $Thisnetsetname)   # network set used in server profile
                    {
                        $ListofLIGs = Get-HPOVLogicalInterconnectGroup
                        if ($ListofLIGs)
                        {
                            foreach ($LIG in $ListofLIGs)
                            {
                                foreach ($UL in $LIG.UpLinkSets)
                                {
                                    $res = $UL.networkuris -contains $net.uri
                                    if ($res)
                                    {
                                        $ThisUplinkSet = $UL.name
                                        $ThisLIG       = $LIG.Name
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        # Remove last sepchar
        $nsName  = $nsName -replace ".{1}$"
        $nspBW   = $nspBW -replace ".{1}$"
        $nsmBW   = $nsmBW -replace ".{1}$"
        $NSvalue = "$nsName,$nspBW,$nsmBW,"

        # ----------------------- Construct Network information
        $name        = $net.name
        $type        = $net.type.Split("-")[0]   # Value is like ethernet-v30network

        $vLANType    = $net.ethernetNetworkType
        $vLANID      = ""
        if ($vLANType -eq 'Tagged')
        {
            $vLANID      = $net.vLanId
            if ($vLANID -lt 1)
                {
                    $vLANID = ""
                }
        }

        $typicalBW   = (1/1000 * $net.DefaultTypicalBandwidth).ToString()
        $maxBW       = (1/1000 * $net.DefaultMaximumBandwidth).ToString()
        $smartlink   = if ($net.SmartLink) {'Yes'} else {'No'}
        $Private     = if ($net.PrivateNetwork) {'Yes'} else {'No'}
        $purpose     = $net.purpose

        # Valid only for Synergy Composer
        if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
        {
            $ThisSubnet = Get-HPOVAddressPoolSubnet | Where-Object URI -eq $net.subnetURI
            if ($ThisSubnet)
                { $subnet = $ThisSubnet.NetworkID }
            else
                { $subnet = "" }
        }
        else
        { $subnet = ""}

        $ValuesArray += "$nsName,$nspBW,$nsmBW,$ThisUplinkSet,$ThisLIG,$name,$type,$vLANID,$vLANType,$subnet,$typicalBW,$MaxBW,$SmartLink,$Private,$purpose"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Ethernet Networks to CSV file           --> $OVEthernetNetworksCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $NetHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Ethernet Networks not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVFCNetwork
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVFCNetwork ([string]$OutFile)
{
    $ValuesArray     = @()
    $ListofNetworks  = Get-HPOVNetwork | Where-Object Type -like "Fc*"

    foreach ($net in $ListofNetworks )
    {
        $name        = $net.name
        $description = $net.description
        $type        = $net.type.Split("-")[0]   # Value is 'fcoe-networksV300

        $typicalBW   = $net.DefaultTypicalBandwidth /1000
        $maxBW       = $net.DefaultMaximumBandwidth /1000

        if ($type -eq 'fcoe') #FCOE network
        {
            $vLANID      = $net.VLANID
            $fabrictype  = ""
        }
        else  # FC network
        {
            $fabrictype  = $net.fabrictype
            if ($fabrictype -eq 'FabricAttach')
            {
                $autologin   = if ($net.autologinredistribution) {'Auto'} else {'Manual'}
                $linkstab    = $net.linkStabilityTime
            }
        }

        $ManagedSAN  = ""
        if ($net.managedSANuri)
        {
            $ThisManagedSAN = Send-HPOVRequest $net.ManagedSANuri
            $ManagedSAN = $ThisManagedSAN.Name
        }

        $ValuesArray += "$name,$description,$type,$fabrictype,$ManagedSAN,$VLANID,$typicalBW,$MaxBW,$autologin,$linkStab"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting FC Network information to CSV file      --> $OVFCNetworksCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $fcheader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Fibre Channel Networks not configured.  Skip exporting..."
    }
}

## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVNetworkSet
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVNetworkSet ([string]$OutFile)
{
    $ValuesArray       = @()
    $ListofNetworkSets = Get-HPOVNetworkSet | Sort-Object Name

    foreach ($ns in $ListofNetworkSets)
    {
        $NetArray      = @()
        $NativeNetwork = ""

        # ------ Get members of network set
        $ListofNetUris = $ns.networkUris
        if ($ListofNeturis)
        {
            $ListofNeturis | ForEach-Object { $NetArray  += Get-NamefromUri $_ } # Get name of network which is member of the networkset
        }

        [Array]::Sort($NetArray)
        $Networks         = $NetArray -join $Sep

        # ----- Get information of networkset
        $nsname        = $ns.name
        $nsdescription = $ns.description
        $nstypicalBW   = $ns.TypicalBandwidth /1000
        $nsMaxBW       = $ns.MaximumBandwidth /1000
        $nsnativenet   = Get-NamefromUri -uri $ns.nativeNetworkUri

        # ---- Get information on Uplinkset and LogicalInterconnectGroup where this uplinkset may belong
        $ThisUplinkSet  = ""
        $ThisLIG        = ""

        if (Get-HPOVServerProfile)
        {
            $ConnectionList = Get-HPOVServerProfileConnectionList
            if ($ConnectionList.Network -contains $nsname)   # network set used in server profile
            {
                $ListofLIGs = Get-HPOVLogicalInterconnectGroup
                if ($ListofLIGs)
                {
                    foreach ($LIG in $ListofLIGs)
                    {
                        foreach ($UL in $LIG.UpLinkSets)
                        {
                            $res = $UL.networkuris | Where-Object { $ListofNeturis -contains $_}
                            if ($res)
                            {
                                $ThisUplinkSet = $UL.name
                                $ThisLIG       = $LIG.Name
                                break
                            }
                        }
                    }
                }
            }
        }

        $ValuesArray     +=  "$nsname,$nsdescription,$nstypicalBW,$nsMaxBW,$ThisUplinkSet,$ThisLIG,$Networks,$nsnativenet"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Network Set information to CSV file     --> $OVNetworkSetCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $NSHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Network Sets not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVLogicalInterConnectGroup
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVLogicalInterConnectGroup ([string]$OutFile)
{
    $ICModuleTypes            = @{
        "VirtualConnectSE40GbF8ModuleforSynergy"    =  "SEVC40f8" ;
        "Synergy20GbInterconnectLinkModule"         =  "SE20ILM";
        "Synergy10GbInterconnectLinkModule"         =  "SE10ILM";
        "VirtualConnectSE16GbFCModuleforSynergy"    =  "SEVC16GbFC";
        "Synergy12GbSASConnectionModule"            =  "SE12SAS"
    }

    $FabricModuleTypes       = @{
        "VirtualConnectSE40GbF8ModuleforSynergy"    =  "SEVC40f8" ;
        "Synergy12GbSASConnectionModule"            =  "SAS";
        "VirtualConnectSE16GbFCModuleforSynergy"    =  "SEVCFC";
    }

    $ValuesArray = @()
    $Ligs        = Get-HPOVLogicalInterconnectGroup | Sort-Object Name

    if ($Ligs)
    {
        foreach ($LigObj in $Ligs)
        {

            $LIGName                = $ligobj.Name

            $eFastMacCacheFailover  = $LigObj.ethernetSettings.enableFastMacCacheFailover
              $FastMacCacheFailover = if ($eFastMacCacheFailover) { 'Yes' } else { 'No' }

            $macrefreshInterval     = $LigObj.ethernetSettings.macRefreshInterval

            $eIGMPSnooping          = $LigObj.ethernetSettings.enableIGMPSnooping
            $IGMPIdleTimeout        = $LigObj.ethernetSettings.igmpIdleTimeoutInterval
                $IGMPSnooping       = if ($eIGMPSnooping) { 'Yes' } else { 'No' }

            $eNetworkLoopProtection = $LigObj.ethernetSettings.enableNetworkLoopProtection
             $NetworkLoopProtection = if ($eNetworkLoopProtection) { 'Yes' } else { 'No' }

            $ePauseFloodProtection  = $LigObj.ethernetSettings.enablePauseFloodProtection
             $PauseFloodProtection  = if ($ePauseFloodProtection) { 'Yes' } else { 'No' }

            $RedundancyType         = $LigObj.redundancyType

            $eEnableRichTLV         = $LigObj.EthernetSettings.enableRichTLV
             $EnableRichTLV         = if ($eEnableRichTLV)  { 'Yes' } else { 'No' }

            $eLDPTagging            = $LigObj.EthernetSettings.enableTaggedLldp
             $EnableLDPTagging      = if ($eLDPTagging)  { 'Yes' } else { 'No' }

            $Telemetry              = $LigObj.telemetryConfiguration
             $sampleCount           = $Telemetry.sampleCount
             $sampleInterval        = $Telemetry.sampleInterval

            if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
            {
                $FrameCount             = $LigObj.EnclosureIndexes.Count
                $InterconnectBaySet     = $LigObj.interconnectBaySet
            }
            else {
                $FrameCount = $InterconnectBaySet = ""
            }

            # ----------------------------
            #     Find Internal networks
            $IntNetworks            = @()
            $InternalNetworks       = ""
            $InternalNetworkUris    = $LigObj.InternalNetworkUris
            foreach ( $uri in $InternalNetworkUris)
            {
                $IntNetworks += Get-NamefromUri -uri $uri
            }
            if ($IntNetworks)
            {
                $InternalNetworks = $IntNetworks -join $SepChar
            }

            # ----------------------------
            #     Find Interconnect devices
            $Bays         = @()
            $UpLinkPorts  = @()
            $Frames       = @()

            $LigInterConnects = $ligobj.interconnectmaptemplate.interconnectmapentrytemplates
            foreach ($LigInterconnect in $LigInterConnects | Where-Object permittedInterconnectTypeUri -ne $NULL )
            {
                # -----------------
                # Locate the Interconnect device and its position
                $ICTypeuri  = $LigInterconnect.permittedInterconnectTypeUri

                if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
                {
                    $ThisICType = ""
                    if ($ICTypeUri)
                    {
                        $ThisICType = Get-NamefromUri -uri $ICTypeUri
                    }

                    $BayNumber    = ($LigInterconnect.logicalLocation.locationEntries | Where-Object Type -eq "Bay").RelativeValue
                    $FrameNumber  = ($LigInterconnect.logicalLocation.locationEntries | Where-Object Type -eq "Enclosure").RelativeValue
                    $FrameNumber = [math]::abs($FrameNumber)
                    $Bays += "Frame$FrameNumber" + $Delimiter + "Bay$BayNumber"+ "=" +  "$ThisICType"   # Format is Frame##\Bay##=InterconnectType
                }
                else # C7K
                {
                    $PartNumber = (send-hpovRequest $ICTypeuri ).partNumber
                    $ThisICType = $ICTypes[$PartNumber]
                    $BayNumber    = ($LigInterconnect.logicalLocation.locationEntries | Where-Object Type -eq "Bay").RelativeValue
                    $Bays += "$BayNumber=$ThisICType"  # Format is xx=Flex Fabric
                }
            }

            [Array]::Sort($Bays)
            if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
            {
                $BayConfigperFrame = @()
                $CurrentFrame      = ""
                $CurrentBayConfig  = ""

                foreach ($bayconf in $Bays)
                {
                    if ( $bayConf)
                    {
                        $a             = $bayconf.split($Delimiter)
                        $ThisFrame     = $a[0]
                        $ThisBay       = $a[1]

                        if ( -not $CurrentFrame)
                        {
                            $CurrentFrame     = $ThisFrame
                            $CurrentBayConfig = "$CurrentFrame" + $OpenDelim + $ThisBay + $SepChar      # Format is "Frame##={Bay##=InterconnectType|Bay##=InterconnectType"
                        }
                        else {
                            if ($ThisFrame -eq $CurrentFrame)
                            {
                                $CurrentBayConfig += $ThisBay
                            }
                            else {
                                $CurrentBayConfig += $CloseDelim + $CRLF                            # Complete with Close Bracket -->  "Frame##={Bay##=InterconnectType|Bay##=InterconnectType}"
                                $BayConfigperFrame += $CurrentBayConfig
                                $CurrentFrame     = $ThisFrame
                                $CurrentBayConfig = "$CurrentFrame"+ $OpenDelim + $ThisBay + $SepChar    # Start new Frame Frame##={Bay##=aaaaaa"
                            }
                        }
                    }
                }
                # Last element
                $BayConfigperFrame += "$CurrentBayConfig" + $CloseDelim + $CRLF

                # Determining Fabric Module Type. Use element defined in 1st Frame and 1st Bay
                $a                = $BayConfigperFrame[0].Split('{')[-1]    # Separate Frame
                $b                = $a.Split('=')[1]                        # Separate Bay
                $FabricModuleType = $b.Split($SepChar)[0]                   # Get the name
                $ICBaySet         = $BayConfigperFrame.Length               # Not used

                # a/ BayConfigperframe is an array --> Needs to convert to string using -join
                # b/ BayConfig is a cell with multiple lines. Need to surround it with " "
                #
                $BayConfig         = "`"" + $($BayConfigperFrame -join "") + "`""
            }
            else {
                $BayConfig = $Bays -join $SepChar
            }

            $ValuesArray      += "$LIGName,$FrameCount,$InterConnectBaySet,$FabricModuleType,$BayConfig,$RedundancyType,$InternalNetworks,$IGMPSnooping,$IGMPIdleTimeout,$FastMacCacheFailover,$MacRefreshInterval,$NetworkLoopProtection,$PauseFloodProtection,$EnableRichTLV,$EnableLDPTagging"
        }

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting Logical Interconnect Groups to CSV file --> $OVLogicalInterConnectGroupCSV"
            New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $OutFile -Value $LigHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        }
    } else {
        Write-Host -ForegroundColor Yellow "  Logical Interconnect Groups not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVUplinkset
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVUplinkSet([string]$OutFile)
{
    $ValuesArray     = @()
    $ListofLIGs      = Get-HPOVlogicalInterconnectGroup | Sort-Object Name

    if ($ListofLIGs)
    {
        foreach ($LIG in $ListofLIGs)
        {
            # Collect info on UplinkSet
            $LIGName        = $LIG.Name
            $UpLinkSets     = $LIG.UplinkSets | Sort-Object Name

            foreach ($Upl in $UplinkSets)
            {
                $UplinkSetName  = $Upl.name
                $UpLinkType     = $Upl.networkType
                $EthMode        = $Upl.mode
                $NativenetUri   = $Upl.nativeNetworkUri
                #$netTagtype     = $Upl.ethernetNetworkType
                $lacpTimer      = $Upl.lacpTimer

                # ----------------------------
                #     Find native Network
                $NativeNetwork = ""
                if ($NativeNetUri)
                {
                    $Nativenetwork = Get-NamefromUri -uri $NativenetUri
                }

                # ----------------------------
                #     Find networks
                $networkUris = $Upl.networkUris
                $FCSpeed = ""
                switch ($UpLinkType)
                {
                    'Ethernet'      {
                                        $netnames = @()
                                        foreach ($neturi in $networkUris)
                                        {
                                            if ($neturi)
                                            {
                                                $Netnames += Get-NamefromUri -uri $neturi
                                            }
                                        }
                                        $networks = $netnames -join $SepChar
                                    }

                    'FibreChannel'  {
                                        $networks = Get-NamefromUri -uri $networkUris[0]
                                        $FCSpeed = if ($Upl.FCSpeed) { $Upl.FCSpeed } else { 'Auto' }
                                    }
                    Default {}
                }

                # ----------------------------
                #     Find uplink ports
                $SpeedArray  = @()
                $UpLinkArray = @()

                $LigInterConnects = $LIG.interconnectmaptemplate.interconnectmapentrytemplates

                foreach ($LigIC in $LigInterConnects | Where-Object permittedInterconnectTypeUri -ne $NULL )
                {
                    # -----------------
                    # Locate the Interconnect device
                    $PermittedInterConnectType = Send-HPOVRequest $LigIC.permittedInterconnectTypeUri

                    # 1. Find port numbers and port names from permittedInterconnectType
                    $PortInfos     = $PermittedInterConnectType.PortInfos

                    # 2. Find Bay number and Port number on uplinksets
                    $ICLocation    = $LigIC.LogicalLocation.LocationEntries
                    $ICBay         = ($ICLocation | Where-Object Type -eq "Bay").relativeValue
                    $ICEnclosure   = ($IClocation | Where-Object Type -eq "Enclosure").relativeValue

                    foreach ($logicalPort in $Upl.logicalportconfigInfos)
                    {
                        $ThisLocation     = $Logicalport.logicalLocation.locationEntries
                        $ThisBayNumber    = ($ThisLocation | Where-Object Type -eq "Bay").relativeValue
                        $ThisPortNumber   = ($ThisLocation | Where-Object Type -eq "Port").relativeValue
                        $ThisEnclosure    = ($ThisLocation | Where-Object Type -eq "Enclosure").relativeValue
                        $ThisPortName     = ($PortInfos    | Where-Object PortNumber -eq $ThisPortNumber).PortName

                        if (($ThisBaynumber -eq $ICBay) -and ($ThisEnclosure -eq $ICEnclosure))
                        {
                            if ($ThisEnclosure -eq -1)    # FC module
                            {
                                $UpLinkArray     += $("Bay" + $ThisBayNumber +":" + $ThisPortName)   # Bay1:1
                                $s               = $Logicalport.DesiredSpeed
                                $s               = if ($s) { $s } else {'Auto'}
                                $SpeedArray      += $s.TrimStart('Speed').TrimEnd('G')
                                # Don't sort UpLinkArray as it is linked to FCSpeedArray
                            }
                            else  # Synergy Frames or C7000
                            {
                                if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
                                {
                                    $ThisPortName    = $ThisPortName -replace ":", "."    # In $POrtInfos, format is Q1:4, output expects Q1.4
                                    $UpLinkArray     += $("Enclosure" + $ThisEnclosure + ":" + "Bay" + $ThisBayNumber +":" + $ThisPortName)   # Ecnlosure#:Bay#:Q1.3
                                }
                                else # C7000
                                {
                                    $UpLinkArray     += $("Bay" + $ThisBayNumber +":" + $ThisPortName)   # Ecnlosure#:Bay#:Q1.3
                                }
                                [Array]::Sort($UplinkArray)
                            }
                        }
                    }
                $UplinkPorts = $UplinkArray -join $SepChar
                $FCSpeed     = $SpeedArray  -join $SepChar
                }

                $ValuesArray += "$LIGName,$UplinkSetName,$UplinkType,$UpLinkPorts,$Networks,$NativeNetwork,$EthMode,$lacptimer,$FCSpeed"
            }
        }

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting UpLinkSet information to CSV file       --> $OVUpLinkSetCSV"
            New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $OutFile -Value $UplHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        } else {
            Write-Host -ForegroundColor Yellow "  Uplink Sets not configured.  Skip exporting..."
        }
    } else {
        Write-Host -ForegroundColor Yellow "  No LIGs configured, so no Uplink Sets configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVEnclosureGroup
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVEnclosureGroup([string]$OutFile)
{
    $ValuesArray          = @()
    $ListofEncGroups      = Get-HPOVEnclosureGroup | Sort-Object Name

    if ($ListofEncGroups)
    {
        foreach ($EG in $ListofEncGroups)
        {
            $EGName              = $EG.name
            $EGDescription       = $EG.description
            $EGEnclosureCount    = $EG.enclosureCount
            $EGPowerMode         = $EG.powerMode
            $osDeploy            = $EG.osDeploymentSettings
              $DeploySettings    = $osDeploy.deploymentModeSettings
              $EGDeployMode      = $DeploySettings.deploymentMode
              $EGDeployNetwork   = if ($DeploySettings.deploymentNetworkUri) { Get-NamefromUri -uri $DeploySettings.deploymentNetworkUri}
            $EGipV4AddressType   = $EG.ipAddressingMode

            if ($EGipV4AddressType -eq 'ipPool')
            {
                $ipRangeUris         = $EG.ipRangeUris
                if ($ipRangeUris)
                    {
                        $IpPools = @()
                        foreach ($RangeUri in $ipRangeUris)
                        {
                            $IpPools += Get-NamefromUri -uri $RangeUri
                        }
                        [Array]::sort($IpPools)
                        $EGAddressPool = $IpPools -join $Sepchar
                }
            }
            else
            {
                $EGAddressPool = ""
            }

            if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
            {
                $result              = $true
                $ListofICBayMappings = $EG.InterConnectBayMappings

                # Check whether there are differenct ICs in different enclosures
                # We check the EnclosureIndex here.
                # If those values are $NULL, it means either there is only 1 enclosure or all enclosures have the same ICmappings
                # If one of the values is not $NULL, there are differences of ICs in enclosures
                #
                foreach ($IC in $ListofICBayMappings)
                {
                    $result = $result -and ($IC.EnclosureIndex)
                }

                $EnclosureCount   = $EG.enclosureCount

                $Frames = ""
                $ListofICNames = ""
                if ($result)
                {
                    # Either there is only 1 enclosure or multiple enclosures with the same LIG config

                    for ($j=1 ; $j -le 3 ; $j++ )  # Just use the first 3 Interconnect Bay
                    {
                        $ThisIC = $ListofICBayMappings | Where-Object InterConnectBay -eq $j
                        if ($ThisIC)
                        {
                            $ThisName       = Get-NamefromUri -uri $ThisIC.logicalInterconnectGroupURI
                            $ListofICNames += "$ThisName$Sep"
                        }
                        else
                        {
                            $ListofICNames += $Sep
                        }
                    }

                    for ($i=1 ; $i -le $EnclosureCount ; $i++)
                    {
                        $Frames += "Frame$i=$($ListofICNames.TrimEnd($Sep))" + $SepChar
                    }
                    $Frames = $Frames.TrimEnd($SepChar)
                }
                else
                {
                    # Multiple enclosures with different LIG
                    $ListofICBayMappings = $ListofICBayMappings | Sort-Object interconnectBay

                    for ($i=1 ; $i -le $EnclosureCount ; $i++)
                    {
                        $FramesperEnclosure  = ""
                        $ListofICNames       = ""
                        for ($j=1 ; $j -le $ListofICBayMappings.Length; $j++)
                        {
                            $ThisIC = $ListofICBayMappings | Where-Object {($_.interconnectBay -eq $j)}
                            if ($ThisIC)
                            {
                                $ThisName       = Get-NamefromUri -uri $ThisIC.logicalInterconnectGroupURI
                                $ListofICNames += "$ThisName$Sep"
                            }
                            else
                            {
                                $ListofICNames += $Sep
                            }
                        }

                        $FramesperEnclosure += "Frame$i=$($ListofICNames.TrimEnd($Sep))" + $SepChar
                        $Frames             += $FramesperEnclosure
                    }
                }
                $EGLIGMapping = $Frames.TrimEnd($SepChar)
            }
            else # C7000 here
            {
                $ListofICMappings = $EG.InterconnectBayMappings
                $LIGMappingArray = @()

                foreach ($LIC in $ListofICMappings)
                {
                    $ThisLIGUri = $LIC.logicalInterconnectGroupURI
                    if ($ThisLIGUri)
                    {
                        $LIGName          = Get-NamefromUri -Uri $ThisLIGUri
                        $LigICBay         = $LIC.interconnectBay
                        $LIGMappingArray += "$LigICBay=$LIGName"
                    }
                }
                $EGLIGMapping = $LIGMappingArray -join $Sepchar
            }

            $ValuesArray  += "$EGName,$EGDescription,$EGLIGMapping,$EGEnclosureCount,$EGipV4AddressType,$EGAddressPool,$EGDeployMode,$EGDeployNetwork,$EGPowerMode"
        }

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting EnclosureGroup information to CSV file  --> $OVEnclosureGroupCSV"
            New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $OutFile -Value $EGHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        }
    } else {
        Write-Host -ForegroundColor Yellow "  Enclosure Groups not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVEnclosure
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVEnclosure([string]$OutFile)
{
    $ValuesArray     = @()
    $ListofEncs      = Get-HPOVEnclosure | Sort-Object Name

    if ($ListofEncs)
    {
        foreach ($Enc in $ListofEncs)
        {
            $EncName       = $Enc.name
            $EncSN         = $Enc.serialNumber
            $EGName        = Get-NamefromUri $Enc.enclosureGroupUri
            $EncLicensing  = $Enc.licensingIntent
            $EncFWBaseline = $Enc.fwBaselineName

            if ($EncFWBaseline)
            {
                $EncFWBaseline      = $EncFWBaseLine.split(',')[0]
                $uri                = $Enc.fwBaselineUri
                $EncFwInstall       = if ($Enc.isFWManaged) {'Yes'} else {'No'}
				try {
                    $FWUri          = Send-HPOVRequest -uri $uri
                    $EncFwIso       = $FWUri.isoFileName
				}
				catch {
                    $FWUri          = ""
                    $EncFwIso       = ""
				}
            }
            else { $EncFwInstall = 'No' }

            $EncOAIP       = $Enc.activeOaPreferredIP
            $EncOAUser     = "***Info N/A***"
            $EncOAPassword = "***Info N/A***"
            $EncState      = if ($Enc.state -eq 'Monitored') {'Yes'} else {'No'}

            $ValuesArray  += "$EGName,$EncName,$EncSN,$EncOAIP,$EncOAUser,$EncOAPassword,$EncLicensing,$EncFwIso,$EncFwInstall,$EncState"
        }

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting Enclosure information to CSV file       --> $OVEnclosureCSV"
            New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $OutFile -Value $EncHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        }
    } else {
        Write-Host -ForegroundColor Yellow "  Enclosures not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVLogicalEnclosure
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVLogicalEnclosure([string]$OutFile)
{
    $ValuesArray            = @()
    $ListofLogicalEncs      = Get-HPOVLogicalEnclosure | Sort-Object Name

    if ($ListofLogicalEncs)
    {
        foreach ($Enc in $ListofLogicalEncs)
        {
            $EncName       = $Enc.Name
            $EGName        = Get-NamefromUri $Enc.enclosureGroupUri
            $EGenclosures  = ""
            foreach ($encuri in $enc.EnclosureUris)
            {
                $EGenclosures += "$(Get-NamefromUri -uri $encuri)$Sep"
            }
            $EGenclosures  = $EGenclosures.TrimEnd($Sep)

            if ( $Enc.firmware.firmwareBaselineUri)
            {
                $EncFWBaseline = Get-NamefromUri -uri $Enc.firmware.firmwareBaselineUri
            }
            $EncFWInstall = if ($Enc.firmware.forceInstallFirmware) {'Yes'} else {'No'}

            $ValuesArray  += "$EncName,$EGenclosures,$EGName,$EncFWBaseLine,$EncFWInstall"
        }

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting LogicalEnclosure resources to CSV file  --> $OVLogicalEnclosureCSV"
            New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $OutFile -Value $LogicalEncHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        }
    } else {
        Write-Host -ForegroundColor Yellow "  Logical Enclosures not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVDLServer
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVDLServer([string]$OutFile)
{
    $ValuesArray     = @()
    $ListofServers   = Get-HPOVServer | Sort-Object Name

    if ($ListofServers)
    {
        foreach ($server in $ListofServers)
        {
            $IsDL       = $server.model -like '*DL*'

            if ($IsDL)
            {
                $serverName = $server.Name
                $adminName  = "***Info N/A***"
                $adminpassword = "***Info N/A***"

                if ($server.State -eq 'Monitored')
                {
                    $Monitored       = 'Yes'
                    $LicensingIntent = ""
                }
                else
                {
                   $Monitored        = 'No'
                   $LicensingIntent  = $server.LicensingIntent
                }

                $ValuesArray  += "$ServerName,$AdminName,$AdminPassword,$Monitored,$LicensingIntent"
            }
        }

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting DL Server information to CSV file       --> $OVDLServerCSV"
            New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $OutFile -Value $DLServerHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        } else {
            Write-Host -ForegroundColor Yellow "  No DL Servers configured.  Skip exporting..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-ProfileConnection
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVProfileConnection($ProfileName, $ConnectionList)
{
    $ConnectionArray = @()

    foreach ($c in $ConnectionList)
    {
        $sp            = $ProfileName
        $connName      = $c.name
        $cid           = $c.id
        $portid        = $c.portId
        $Type          = $c.functionType
        $net           = Get-NamefromUri $c.networkUri
        $mac           = $c.mac
        $wwpn          = $c.wwpn
        $wwnn          = $c.wwnn
        $boot          = $c.boot.priority
        $target        = $c.boot.targets.ArrayWWPN
        $lun           = $c.boot.targets.lun
        $Bw            = $c.requestedMbps

        if ($boot -eq 'NotBootable')
        {
            $boot     = ""
            $Bootable = 'No'
        }
        else
        {
            $Bootable = 'Yes'
        }

        if ($mac -or $wwpn -or $wwnn)
        {
            $UserDefined = 'Yes'
        }
        else
        {
            $UserDefined = 'No'
        }

        $ConnectionArray  += "$sp,$connName,$cid,$net,$portid,$Bw,$Bootable,$boot,$UserDefined,$mac,$wwnn,$wwpn,$target,$lun"
    }

    ## Add a separator line
    $ConnectionArray  += "##                           $CR"
    return $ConnectionArray
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-ProfileLOCALStorage
##
## -------------------------------------------------------------------------------------------------------------
function Export-ProfileLOCALStorage($ProfileName, $LocalStorageList)
{
    # Use values as defined in POSH 3.0
    $DriveTypeValues = @{
        "SasHDD"  = "SAS";
        "SataHDD" = "SATA";
        "SASSSD"  = "SASSSD";
        "SATASSD" = "SATASSD"
    }

    $StorageConnectionArray = @()
    foreach ($LS in $LocalStorageList)
    {
        $ControllerList          = $LS.Controllers
        foreach ($Controller in $ControllerList)
        {
            $Enable         = 'Yes'
            $ControllerMode = $Controller.Mode
            $ControllerInit = if ($Controller.Initialize) {'Yes'} else {'No'}
            $LDrives        = $controller.LogicalDrives

            $LDNameArr      = @()
            $LDBootArr      = @()
            $LDDriveTypeArr = @()
            $LDRaidArr      = @()
            $LDNumDrivesArr = @()
            $LDMinSizeArr   = @()   # Only for Synergy BigBird
            $LDMaxSizeArr   = @()   # Only for Synergy BigBird

            $LDName = $LDBoot = $LDDriveType = $LDNumDrives = $LDRAID = ""
            foreach ($LD in $LDrives)
            {
                $LDNameArr       += $LD.name
                $LDBootArr       += if ($LD.Bootable ) {'Yes'} else {'No'}
                $LDDriveTypeArr  += if ($LD.DriveTechnology) {$DriveTypeValues[$LD.DriveTechnology]} else {""}
                $LDNumDrivesArr  += $LD.numPhysicalDrives
                $LDRaidArr       += $LD.RAIDLevel
            }

            $LDName        = $LDNameArr -join $sepchar
            $LDBoot        = $LDBootArr -join $sepchar
            $LDDriveType   = $LDDriveTypeArr -join $sepchar
            $LDNumDrives   = $LDNumDrivesArr -join $sepchar
            $LDRAID        = $LDRaidArr -join $sepchar

            $StorageConnectionArray += "$ProfileName,$Enable,$ControllerMode,$ControllerInit,$LDName,$LDBoot,$LDDriveType,$LDRaid,$LDNumDrives"
        }
    }
    return $StorageConnectionArray
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-ProfileSANStorage
##
## -------------------------------------------------------------------------------------------------------------
function Export-ProfileSANStorage($ProfileName, $SANStorageList)
{
    $HostOSList     = @{
        "Citrix Xen Server 5.x/6.x"     = "CitrixXen";
        "AIX"                           = "AIX";
        "IBM VIO Server"                = "IBMVIO";
        "RHE Linux (Pre RHEL 5)"        = "RHEL4";
        "RHE Linux (5.x, 6.x)"          = "RHEL";
        "RHE Virtualization (5.x, 6.x)" = "RHEV";
        "VMware (ESXi)"                 = "VMware";
        "Windows 2003"                  = "Win2k3";
        "Windows 2008/2008 R2"          = "Win2k8";
        "Windows 2012 / WS2012 R2"      = "Win2k12";
        "OpenVMS"                       = "OpenVMS";
        "Egenera"                       = "Egenera";
        "Exanet"                        = "Exanet";
        "Solaris 9/10"                  = "Solaris10";
        "Solaris 11"                    = "Solaris11";
        "NetApp/ONTAP"                  = "ONTAP";
        "OE Linux UEK (5.x, 6.x)"       = "OEL";
        "HP-UX (11i v1, 11i v2)"        = "HPUX11iv2";
        "HP-UX (11i v3)"                = "HPUX11iv3";
        "SuSE (10.x, 11.x)"             = "SUSE";
        "SuSE Linux (Pre SLES 10)"      = "SUSE9";
        "Inform"                        = "Inform"
    }

    $SANConnectionArray = @()
    $UseSAN             = $SANStorageList.manageSanStorage
    $SANEnable          = if ($UseSAN) { 'Yes' } else { 'No' }

    if ($UseSAN)
    {
        $hostOSType         = $HostOSList[$($SANStorageList.hostOSType)]
        $VolumeList         = $SANStorageList.volumeAttachments

        $LunArray           = @()
        $VolNameArray       = @()
        foreach ($vol in $VolumeList)
        {
            $LunArray     += $vol.lun
            if ($vol.volumeuri)
            {
                $VolNameArray += Get-NamefromUri -uri $vol.volumeUri
            } else {
                $VolNameArray += $vol.volume.properties.name
            }
        }
        $LUN      = $LunArray -join $SepChar
        $VolName  = $VolNameArray -join $SepChar
    }

    $SANConnectionArray += "$ProfileName,$SANEnable,$hostOSType,$VolName,$LUN"

    return $SANConnectionArray
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-Profile
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVProfile(  [string]$OutProfile,
                            [string]$OutConnectionFile,
                            [string]$OutLOCALStorageFile,
                            [string]$OutSANStorageFile
                        )
{
     Export-ProfileOrTemplate -CreateProfile -OutProfileTemplate $OutProfile -outConnectionfile $outConnectionfile -OutLOCALStorageFile $OutLOCALStorageFile -OutSANStorageFile $OutSANStorageFile
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-ProfileFROMTemplate
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVProfileFROMTemplate([string]$OutProfileFROMTemplate)
{
    $ValuesArray     = @()
    $OutFile         = $OutprofileFROMTemplate
    $ListofProfiles  = Get-HPOVProfile | Sort-Object Name

    if ($ListofProfiles)
    {
        foreach ($p in $ListofProfiles)
        {
            $pName                = $p.Name
            $pDesc                = $p.Description
            $PTuri                = $p.serverProfileTemplateUri
            $ServerHW             = $p.serverHardwareUri
            $SHT                  = $p.serverHardwareTypeUri      # Not Used
            $pAffinity            = $p.Affinity                   # Not Used

            if ($PTUri)
            {
                $ProfileTemplateName = get-NamefromUri $PTUri

                if ($serverHW)
                {
                    $AssignmentType = "server"
                    $Server         = $DoubleQuote + $(get-NamefromUri $ServerHW) + $DoubleQuote
                }
                else
                {
                    $AssignmentType = 'unassigned'
                    $Server         = ""
                }

                $Value        = "$pName,$pDesc,$ProfileTemplateName,$Server,$AssignmentType"
                $ValuesArray += $Value
            }
            else
            {
                Write-Host -ForegroundColor Yellow "Profile not created from Profile Template. Skip displaying it..."
            }
        }

        if ($ValuesArray)
        {
            Set-Content -Path $OutFile -Value $ProfilePSTHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-ProfileOrTemplate
##
## -------------------------------------------------------------------------------------------------------------
function Export-ProfileOrTemplate(
                [string]$OutProfileTemplate,
                [string]$OutConnectionfile,
                [string]$OutLOCALStorageFile,
                [string]$OutSANStorageFile,
                [switch]$CreateProfile)
{
    $FWModeValues = @{
        "FirmwareOnly"            = "FirmwareOnly";
        "FirmwareAndOSDrivers"    = "FirmwareAndSoftware"
        "FirmwareOnlyOfflineMode" = "FirmwareOffline"
    }

    if ($CreateProfile)
    {
        $ListofProfiles = Get-HPOVServerProfile | Sort-Object Name
    } else {
        $ListofProfiles = Get-HPOVServerProfileTemplate | Sort-Object Name
    }

    if ($ListofProfiles)
    {
        $ValuesArray     = @()
        $OutFile         = $OutprofileTemplate

        #---- Create Profile Connection/Local Storage/SAN Storage files and arrays
        $ConnectionArray = @()
        New-Item $outConnectionfile -ItemType file -Force | Out-Null
        Set-Content -Path $outConnectionfile -Value $ConnectionHeader

        $LocalStorageArray = @()
        New-Item $OutLOCALStorageFile -ItemType file -Force | Out-Null
        Set-Content -Path $OutLOCALStorageFile -Value $LocalStorageHeader

        $SANStorageArray = @()
        New-Item $OutSANStorageFile -ItemType file -Force | Out-Null
        Set-Content -Path $OutSANStorageFile -Value $SANStorageHeader

        foreach ($p in $ListofProfiles)
        {
            $Name                 = $p.name
            $Desc                 = $p.description
            #$EncGroup             = if ($p.enclosureGroupUri) {Get-NamefromUri $p.enclosureGroupUri} else {""}
            #$AssignType           = "Server"

            if ($CreateProfile)
            {
                $EncBay               = $p.EnclosureBay
                $EncName              = if ($p.EnclosureUri) {Get-NamefromUri $p.enclosureUri} else {""}
                $ServerTemplate       = if ($p.serverProfileTemplateUri) {Get-NamefromUri -uri $p.serverProfileTemplateUri} else {""}
                $server               = if ($p.ServerHardwareUri) {Get-NamefromUri $p.ServerHardwareUri} else {""}

                if ($server)
                {
                    $AssignType       = "Server"
                    if ($server.ToCharArray() -contains ',' )
                    {
                        $server = '"' + $server + '"'
                    }
                } elseif ($EncBay -and $EncName) {
                    $AssignType       = "Bay"
                } elseif ($EncGroup) {
                    $AssignType       = "unassigned"
                }
            } else {
                $ServerPDescription   = $p.ServerProfileDescription
            }

            $OSDeploySettingsUri  = $p.osDeploymentSettings.osDeploymentPlanUri
            $HideUnusedFlexNics   = if ($p.hideUnusedFlexNics) { 'Yes' } else { 'No' }
            $Affinity             = if ($p.affinity) { $p.affinity } else { 'Bay' }
            $pfw                  = $p.firmware
            if ($pfw.manageFirmware)
            {
                $FWEnable         = 'Yes'
                $FWInstall        = if ($pfw.forceInstallFirmware) { 'Yes' } else { 'No' }
                $FWBaseline       = ""
                if ($pfw.firmwareBaselineUri )
                {
                    $FWObj        = Send-HPOVRequest -uri $pfw.firmwareBaselineUri
                    $FWBaseline   = $FWObj.baselineShortName -replace "SPP", "$($FWObj.Name) version"
                }
                # Convert internal values into values used by POSH
                $FWMode           = $FWModeValues[$pfw.firmwareInstallType]
            }
            else
            {
                $FWEnable         = "No"
                $FWInstall        = ""
                $FWBaseline       = ""
                $FWMode           = ""
            }

            # Get server - SHT and EnclosureGroup
            $ServerHWType         = ""
            if ($p.serverHardwareTypeUri)
            {
                $ThisSHT = Send-HPOVRequest -uri $p.ServerHardwareTypeUri
                if ($ThisSHT)
                {
                    $Model          = $ThisSHT.model
                    $ServerHWType   = $ThisSHT.name
                    $IsDL           = $Model -like '*DL*'
                }
            }

            $EncGroup           = ""
            #$SANStorageArray    = $ConnectionArray = @()
            if (-not $isDL)
            {
                #### Only for Blade Servers
                #$ServerHWName         = if ($p.serverHardwareUri) { get-namefromUri $p.serverHardwareUri} else {""}
                $EncGroup             = if ($p.EnclosureGroupuri) { Get-NamefromUri $p.enclosureGroupUri }

                # Network and FC Connections
                $pconnections         = $p.connectionSettings.connections
                $ConnectionArray      += Export-OVProfileConnection -ProfileName $Name -ConnectionList $pconnections

                # SAN Storage Connections
                $pSANStorage          = $p.sanStorage
                $SANStorageArray      += Export-ProfileSANStorage -ProfileName $Name -SANStorageList $pSANStorage
            }

            # BootMode
            $pbManageMode         = ""
            $BootMode             = ""
            $PXEBootPolicy        = ""
            $pBootM               = $p.bootMode
            if ($pBootM.manageMode)
            {
                $pbManageMode     = 'Yes'
                $BootMode         = $pBootM.mode
                $PXEBootpolicy    = $pBootM.pxeBootPolicy                             # UEFI - UEFIOptimiZed BIOS
            }

            # Boot order
            $BootOrder            = ""
            $pboot                = $p.boot

            if ($pboot.manageBoot)
                { $BootOrder       = $pboot.order -join $SepChar }

            # Assignemnt Type S/N - MAC - WWN
            $wwnType              = $p.wwnType
            $MacType              = $p.macType
            $SNType               = $p.serialNumberType

            # Local Storage Connections
            #$LocalStorageArry       = @()
            $plocalStorage          = $p.localStorage
            $LocalStorageArray      += Export-ProfileLOCALStorage -ProfileName $Name -LocalStorageList $pLocalStorage

            # Get BIOS Settings
            $pBIOS                = $p.Bios
            $BIOSSettingsArray    = @()
            $ListofBIOSSettings   = @()
            $BIOSSettings         = ""
            if ($pBIOS.manageBios)       # True --> There are overriden Settings
            {
                $ListofBIOSSettings = $pBIOS.overriddenSettings

                if ($ListofBIOSSettings)
                {
                    foreach ($Setting in $ListofBIOSSettings)
                    {
                        $BIOSSetting        = "id=$($Setting.id);value=$($Setting.value)"   # Break into a string
                        $BIOSSettingsArray += $BIOSSetting
                    }
                }
                $BIOSSettings = $BIOSSettingsArray -join $SepChar
            }

            # OS Deployment Settings
            $OSDPName  = ""
            $OSDParams = ""
            if ($OSDeploySettingsUri)
            {
                $OSDeploySettings  = $p.OSDeploymentSettings
                try
                {
                    $OSDPName      = (Send-HPOVRequest -uri $OSDeploySettingsUri -ErrorAction stop).name
                    $Params        = @()
                    foreach ($CA in $OSDeploySettings.osCustomAttributes)
                    {
                        $Params    += $CA.Name + "=" + $CA.Value
                    }
                    $OSDParams     = $Params -Join $SepChar
                }
                catch
                {
                    $OSDPName      = $OSDParams = ""
                }
            }

            if ($CreateProfile)
            {
                $Value        = "$Name,$Desc,$AssignType,$EncName,$EncBay,$server,$ServerTemplate,,$ServerHWType,$EncGroup,$Affinity,$FWEnable,$OSDPName,$OSDParams,$FWBaseline,$FWMode,$FWINstall,$BIOSSettings,$BootOrder,$BootMode,$PXEBootPolicy,$MacType,$WWNType,$SNType,$HideUnusedFlexNics"
            } else {
                $Value        = "$Name,$Desc,$ServerPDescription,$ServerHWType,$EncGroup,$Affinity,$OSDPName,$OSDParams,$FWEnable,$FWBaseline,$FWMode,$FWINstall,$BIOSSettings,$BootOrder,$BootMode,$PXEBootPolicy,$MacType,$WWNType,$SNType,$HideUnusedFlexNics"
            }

            $ValuesArray += $Value
        }

        if ($ValuesArray)
        {
            if ($CreateProfile)
            {
                Write-Host -ForegroundColor Cyan "Exporting Server Profiles to CSV file             --> $OVProfileCSV"
                Write-Host -ForegroundColor Cyan "  and Server Profile Connections to CSV file      --> $OVProfileConnectionCSV"
                Write-Host -ForegroundColor Cyan "  and Server Profile LOCALStorage to CSV file     --> $OVProfileLOCALStorageCSV"
                Write-Host -ForegroundColor Cyan "  and Server Profile SANStorage to CSV file       --> $OVProfileSANStorageCSV"
                Set-Content -Path $OutFile -Value $ProfileHeader
            } else {
                Write-Host -ForegroundColor Cyan "Exporting Server Profile Templates to CSV file    --> $OVProfileTemplateCSV"
                Write-Host -ForegroundColor Cyan "  and SPT Connection resources to CSV File        --> $OVProfileTemplateConnectionCSV"
                Write-Host -ForegroundColor Cyan "  and SPT LOCALStorage resources to CSV file      --> $OVProfileTemplateLOCALStorageCSV"
                Write-Host -ForegroundColor Cyan "  and SPT SANStorage resources to CSV file        --> $OVProfileTemplateSANStorageCSV"
                Set-Content -Path $OutFile -Value $PSTHeader
            }

            Add-Content -Path $OutFile -value $ValuesArray

            #----- Write ConnectionList
            Add-Content -Path $outConnectionfile   -value $ConnectionArray

            #----- Write Local/SAN StorageList
            Add-Content -Path $OutLOCALStorageFile -value $LocalStorageArray
            Add-Content -Path $OutSANStorageFile   -value $SANStorageArray
        }
    } else {
        if ($CreateProfile) {
            Write-Host -ForegroundColor Yellow "  No Server Profiles configured.  Skip exporting..."
        } else {
            Write-Host -ForegroundColor Yellow "  No Server Profiles Templates configured.  Skip exporting..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVSANManager
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVSANManager([string]$Outfile)
{
    $ValuesArray          = @()

    $ListofSANManagers      = Get-HPOVSANManager | Sort-Object Name

    foreach ($SM in $ListofSANManagers)
    {
        $AuthPassword = '***Pwd N/A***'
        $PrivPassword = '***Pwd N/A***'
        $Password     = '***Pwd N/A***'

        $SMName       = $SM.Name
        $SMType       = $SM.ProviderDisplayName

        foreach ($CI in $SM.ConnectionInfo)
        {
            switch ($CI.Name)
            {
                # ------ For HPE and Cisco
                'SnmpPort'          { $Port             = $CI.Value}
                'SnmpUsername'      { $snmpUsername     = $CI.Value}
                'SnmpAuthLevel'     {                $v = $CI.Value

                    if ($v -notlike 'AUTH*')
                    {
                        $AuthLevel = 'None'
                    } else {
                        if ($v -eq 'AUTHNOPRIV')
                        {
                            $AuthLevel = 'AuthOnly'
                        } else {
                            $AuthLevel = 'AuthAndPriv'
                        }
                    }
                }

                'SnmpAuthProtocol'  { $AuthProtocol  = $CI.Value }
                'SnmpPrivProtocol'  { $PrivProtocol  = $CI.Value }

                #---- For Brocade
                'Username'          { $Username  = $CI.Value }
                'UseSSL'            { $UseSSL  = if ($CI.Value) {'Yes'} else {'No'} }
                'Port'              { $Port  = $CI.Value }
            }
        }

        $Password       = if ($Username)        {'***Pwd N/A***'} else {''}
        $AuthPassword   = if ($snmpUsername)    {'***Pwd N/A***'} else {''}
        $PrivPassword   = if ($PrivProtocol)    {'***Pwd N/A***'} else {''}

        $ValuesArray  += "$SMName,$SMType,$Username,$Password,$Port,$UseSSL,$AuthLevel,$AuthProtocol,$snmpUsername,$AuthPassword,$PrivProtocol,$PrivPassword"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting SAN Manager information to CSV file     --> $OVSANManagerCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $SANManagerHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  SAN Managers not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVStorageSystem
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVStorageSystem([string]$Outfile)
{
    $ValuesArray          = @()

    $ListofStorageSystems      = Get-HPOVStorageSystem | Sort-Object Name

    foreach ($StS in $ListofStorageSystems)
    {
        $hostName            = $Sts.hostname
        $Username            = $Sts.Credentials.username
        $Password            = '***Pwd N/A***'
        $family              = $sts.family

        $DomainName          = if ($family -eq 'StoreServ' ) { $Sts.deviceSpecificAttributes.managedDomain } else {''}

        $StoragePorts        = ""
        foreach ($MP in ($Sts.Ports | Sort-Object Name))
        {
            if ($family -eq 'StoreServ')
                { $Thisname    = $MP.actualSanName }
            else
                { $Thisname    = $MP.ExpectedNetworkName  }

            if ($Thisname)
            {
                $Port           = $MP.Name + '=' + $Thisname    # Build Port syntax 0:1:2= VSAN10
                $StoragePorts  += $Port + $SepChar              # Build StorargePort "0:1:2= VSAN10|0:1:3= VSAN11"
            }
        }

        $StoragePools       = ""
        $AllStoragePools    = Send-HPOVRequest -uri $Sts.storagePoolsUri
        foreach ($SP in $AllStoragePools.members)
        {
            $StoragePools += $SP.Name + $SepChar
        }

        # Remove last separation character
        $StoragePorts  = $StoragePorts -replace ".{1}$"
        $StoragePools  = $StoragePools -replace ".{1}$"

        $ValuesArray  += "$hostName,$Family,$Username,$Password,$StoragePorts,$DomainName,$StoragePools"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Storage System information to CSV file  --> $OVStorageSystemCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $StSHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Storage Systems not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVStorageVolumeTemplate
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVStorageVolumeTemplate([string]$Outfile)
{
    $ValuesArray                = @()

    $ListofVolTemplates         = Get-HPOVStorageVolumeTemplate | Sort-Object Name

    foreach ($Template in $ListofVolTemplates)
    {
        $Name            = $Template.name
        $Description     = $Template.description
        $Properties      = $Template.properties
        $Family          = $Template.family

        $ProvisionType   = if ($Properties.provisioningType.default -eq "Full") { "Full" } else { "Thin" }
        $Shared          = if ($Properties.isShareable.default)                 { "Yes"  } else { "No" }
        $Capacity        = if ($Properties.size.default)                        { 1/1GB * $Properties.size.default} else { 0 }

        # StoreVirtual-specific parameters
        $DataProtection  = ""
        $AOEnabled       = ""
        if ($Family -eq "StoreVirtual")
        {
            $DataProtection  = $Properties.dataProtectionLevel.default
            $AOEnabled       = if ($Properties.isAdaptiveOptimizationEnabled.default) { "Yes" } else { "No" }
        }

        # StoreServ-specific parameters
        $Dedupe           = ""
        $SnapShotPoolName = ""
        if ($Family -eq "StoreServ")
        {
            $Dedupe = if ($Properties.isDeduplicated.default) { "Yes" } else { "No" }
            $SnapSPoolUri = $Properties.snapshotPool.default
            if ($SnapSPoolUri)
            {
                $ThisSnapShotPool = Get-HPOVStoragePool | Where-Object uri -eq $SnapSPoolUri
                if ($ThisSnapShotPool)
                {
                    $SnapShotPoolName = $ThisSnapShotPool.Name
                }
            }
        }

        $StpUri          = $Template.StoragePoolUri
        $PoolName        = ""
        if ($StpUri)
        {
            $ThisPool  = Get-HPOVStoragePool | Where-Object URI -eq $StpUri
            if ($ThisPool)
            {
                $PoolName = $ThisPool.name
                $StsUri   = $ThisPool.storageSystemUri
            }
        }

        $StorageSystem = ""
        if ($StsUri)
        {
            $ThisStorageSystem = Get-HPOVStorageSystem | Where-Object Uri -eq $StsUri
            if ($ThisStorageSystem)
            {
                $StorageSystem = $ThisStorageSystem.hostname
            }
        }

        $ValuesArray  += "$Name,$Description,$PoolName,$StorageSystem,$Capacity,$ProvisionType,$Shared,$Dedupe,$SnapShotPoolName,$DataProtection,$AOEnabled"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Storage Volume Templates to CSV file    --> $OVStorageVolumeTemplateCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $StVolTemplateHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Storage Volume Templates not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVStorageVolume
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVStorageVolume([string]$Outfile)
{
    $ValuesArray                = @()

    $ListofVolumes              = Get-HPOVStorageVolume | Sort-Object Name

    foreach ($Vol in $ListofVolumes)
    {
        $Name            = $Vol.Name
        $Description     = $Vol.Description

        $StpUri          = $Vol.StoragePoolUri
        $SnapSPoolUri    = $Vol.deviceSpecificAttributes.snapshotPoolUri
        $VolTemplateUri  = $Vol.volumeTemplateUri
        $Properties      = $Vol.deviceSpecificAttributes

        $Shared          = if ($Vol.isShareable)                 { "Yes" }   else { "No"   }
        $ProvisionType   = if ($Vol.provisioningType -eq "Full") { "Full" }  else { "Thin" }
        $Capacity        = if ($Vol.provisionedCapacity)         { 1/1GB * $Vol.provisionedCapacity } else { 0 }
        $VolumeTemplate  = if ($VolTemplateUri) { Get-NamefromUri -uri $VolTemplateUri } else { '' }

        $PoolName        = ""
        if ($StpUri)
        {
            $ThisPool    = Get-HPOVStoragePool | Where-Object URI -eq $StpUri
            if ($ThisPool)
            {
                $StsUri   = $ThisPool.storageSystemUri
                $PoolName = $ThisPool.name
            }
        }

        $StorageSystem = ""
        if ($StsUri)
        {
            $ThisStorageSystem = Get-HPOVStorageSystem | Where-Object Uri -eq $StsUri
            if ($ThisStorageSystem)
            {
                $StorageSystem = $ThisStorageSystem.hostname
                $Family        = $ThisStorageSystem.family
            }
        }

        # StoreServ-specific Values
        $Dedupe           = ""
        $SnapShotPoolName = ""
        if ($Family -eq "StoreServ")
        {
            $Dedupe = if ($Properties.isDeduplicated) { "Yes" } else { "No" }
            $SnapSPoolUri = $Properties.snapshotPoolUri
            if ($SnapSPoolUri)
            {
                $ThisSnapShotPool = Get-HPOVStoragePool | Where-Object uri -eq $SnapSPoolUri
                if ($ThisSnapShotPool)
                {
                    $SnapShotPoolName = $ThisSnapShotPool.Name
                }
            }
        }

        # StoreVirtual-specific parameters
        $DataProtection  = ""
        $AOEnabled       = ""
        if ($Family -eq "StoreVirtual")
        {
            $DataProtection  = $Properties.dataProtectionLevel
            $AOEnabled       = if ($Properties.isAdaptiveOptimizationEnabled) { "Yes" } else { "No" }
        }

        $ValuesArray  += "$Name,$Description,$PoolName,$StorageSystem,$VolumeTemplate,$Capacity,$ProvisionType,$Shared,$Dedupe,$SnapShotPoolName,$DataProtection,$AOEnabled"
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Storage Volume information to CSV file  --> $OVStorageVolumeCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $StVolumeHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Storage Volumes not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Export-OVAddressPool Function
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVAddressPool([string]$OutFile)
{
    $ValuesArray = @()
    $ListofPools = Get-HPOVAddressPool | Sort-Object Name

    foreach ($p in $ListofPools)
    {
        $PoolType   = $p.PoolType
        $pRangeUris = $p.rangeUris

        foreach ($rangeuri in $pRangeUris)
        {
            $ThisRange = Get-HPOVAddressPoolRange | Where-Object uri -eq $rangeuri
            $PoolName  = $ThisRange.Name
            $RangeType = $ThisRange.rangeCategory
            $Category  = $ThisRange.Category

            if ($RangeType -eq "Custom")
            {
                $StartAddress = $ThisRange.StartAddress
                $EndAddress   = $ThisRange.EndAddress
            }
            else {
                Break
            }

            $NetworkID  = ""
            $SubnetMask = ""
            $Gateway    = ""
            $ListofDNS  = ""
            $Domain     = ""

            if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
            {
                if ($Category -eq 'id-range-IPV4')
                {
                    $ThisSubnet = Get-HPOVAddressPoolSubnet | Where-Object rangeuris -contains $rangeuri
                    if ($ThisSubnet)
                    {
                        $NetworkID  = $ThisSubnet.networkID
                        $SubnetMask = $ThisSubnet.subnetmask
                        $gateway    = $ThisSubnet.gateway
                        $Domain     = $ThisSubnet.domain
                        $dnsservers = $ThisSubnet.dnsServers

                        if ($dnsservers)
                        {
                            [array]::sort($dnsservers)
                            $ListofDNS = $dnsservers -join $SepChar
                        }
                    }
                }
            }
            $ValuesArray += "$PoolName,$PoolType,$RangeType,$StartAddress,$EndAddress,$NetworkID,$SubnetMask,$gateway,$ListofDNS,$domain"
        }
    }

    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting Address Pools information to CSV file   --> $OVAddressPoolCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $AddressPoolHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  Address Pools not configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVWWNN
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVWwnn ([string]$OutFile)
{
    $ValuesArray = @()

    if (Get-HPOVServerProfile)
    {
        $ListofFCConnections = Get-HPOVServerProfileConnectionList
        foreach ( $L in $ListofFCConnections)
        {
            if ($L.wwnn -match $HexPattern)
            {
                $BayName = $L.ServerProfile
                $wwnn    = $L.wwnn
                $wwpn    = $L.wwpn
                $PortId  = $L.PortId
                $PortId  = $PortId.Split($space)[-1]
                $BayName = $BayName + "_" + $PortId

                $ValuesArray      += "$BayName,$wwnn,$wwpn"
            }
        }

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting Wwnn information to CSV file            --> $OVWwnnCSV"
            New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $OutFile -Value $wwnnHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        }
    } else {
        Write-Host -ForegroundColor Yellow "  No Server Profiles configured.  Skip generating WWNN CSV file..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVipAddress
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVipAddress ([string]$OutFile)
{
    $ValuesArray = @()

    $AppNetwork  = (Get-HPOVApplianceNetworkConfig).ApplianceNetworks

    $Type        = "Appliance"
    $appName     = $appNetwork.hostname
    $appIP       = $appNetwork.virtIPv4addr
    $app1IP      = $appNetwork.app1Ipv4Addr
    $app2IP      = $appNetwork.app2Ipv4Addr

    $ValuesArray      += "$appName,$Type,,$appIP"
    $ValuesArray      += "$appName,$Type,Maintenance IP address 1,$app1IP"
    $ValuesArray      += "$appName,$Type,Maintenance IP address 2,$app2IP"
    $ValuesArray      += ",,,"

    ## ------------
    ##  Enclosures : IP from Device Bays and InterConnect Bays
    ## -------------
    $ListofEnclosures = Get-HPOVEnclosure
    foreach ($Encl in $ListofEnclosures)
    {
        $enclName         = $Encl.Name

        ## Device Bay IP
        $Type             = "Device Bay"
        $ListofDeviceBays = $Encl.DeviceBays
        foreach ($Bay in $ListofDeviceBays)
        {
            $BayNo        = $Bay.bayNumber
            $ipv4Setting  = $Bay.ipv4Setting
            if ($ipv4Setting)
            {
                $BayIP         = $Bay.ipv4Setting.ipAddress
                $ValuesArray  += "$enclName,$type,$BayNo,$BayIP"
            }
        }

        ## InterConnect Bay IP
        $Type                   = "InterConnect Bay"
        $ListofInterconnectBays = $Encl.InterconnectBays
        foreach ($IC in $ListofInterConnectBays)
        {
            $ICBayNo     =  $IC.bayNumber
            $ipv4Setting =  $IC.ipv4Setting
            if ($ipv4Setting)
            {
                $ICIP          =  $IC.ipv4Setting.ipAddress
                $ValuesArray  += "$enclName,$type,$ICBayNo,$ICIP"
            }
        }

        ## Next enclosure - Adding a blank line to the output file
        $ValuesArray += ",,,"
    }
    if ($ValuesArray)
    {
        Write-Host -ForegroundColor Cyan "Exporting IP Address information to CSV file      --> $OVIPAddressCSV"
        New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $OutFile -Value $IPHeader
        Add-Content -Path $OutFile -Value $ValuesArray
    } else {
        Write-Host -ForegroundColor Yellow "  IP Addresses configured.  Skip exporting..."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVOSDeployment
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVOSDeployment ([string]$OutFile)
{
    if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
	{
        $ValuesArray        = @()
        $ListofOSDeployment = Get-HPOVOSDeploymentServer

        foreach ($OSDS in $ListofOSDeployment)
        {
            # Get name and description
            $OSName         = $OSDS.name
            $Desc           = $OSDS.description

            # Get Management network
            try
            {
                $MgmtNet    = (Send-HPOVRequest -Uri $OSDS.mgmtNetworkUri -ErrorAction stop).name
            }
            catch
            {
                $MgmtNet    = ""
            }

            # Get Appliance name
            try
            {
                $OSappliancename    = (Send-HPOVRequest -Uri $OSDS.primaryActiveAppliance -ErrorAction stop).cimEnclosureName
            }
            catch
            {
                $OSappliancename    = ""
            }

            $ValuesArray      += "$OSName,$Desc,$MgmtNet,$OSappliancename"
        }

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting OS Deployment information to CSV file   --> $OVOSDeploymentCSV"
            New-Item $OutFile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $OutFile -Value $OSDSHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        } else {
            Write-Host -ForegroundColor Yellow "  OS Deployment Servers not configured.  Skip exporting..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-BackupConfig
##
## -------------------------------------------------------------------------------------------------------------
function Export-BackupConfig([string]$Outfile)
{
    $ValuesArray                = @()
    $Backup_Config              = Get-HPOVAutomaticBackupConfig

    if ($Backup_Config.enabled)
    {
        $protocol               = $Backup_Config.protocol
        $remoteServerDir        = $Backup_Config.remoteServerDir
        $remoteServerName       = $Backup_Config.remoteServerName
        $scheduleInterval       = $Backup_Config.scheduleInterval
        $scheduleDays           = $Backup_Config.scheduleDays
        $scheduleTime           = $Backup_Config.scheduleTime
        $userName               = $Backup_Config.userName
        $remoteServerPublicKey  = $Backup_Config.remoteServerPublicKey
        $password               = "***Pwd N/A***"

        $ValuesArray            += "$remoteServerName,$remoteServerDir,$userName,$password,$protocol,$scheduleInterval,$scheduleDays,$scheduleTime,$remoteServerPublicKey"

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting Remote Backup config to CSV file        --> $OVBackupConfig"
            New-Item $Outfile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $Outfile -Value $BackupHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        }
    } else {
        Write-Host -ForegroundColor Yellow "  Remote Backups not configured.  Skip exporting..."
    }
}

## -------------------------------------------------------------------------------------------------------------
##
##      Function Export-OVRSConfig
##
## -------------------------------------------------------------------------------------------------------------
function Export-OVRSConfig([string]$Outfile)
{
    $ValuesArray                = @()
    $OVRS_Config                = Get-HPOVRemoteSupport

    if ($OVRS_Config.enableRemoteSupport)
    {
        $enabled                = $OVRS_Config.enableRemoteSupport
        $company                = $OVRS_Config.companyName
        $autoEnableDevices      = $OVRS_Config.autoEnableDevices
        $marketingOptIn         = $OVRS_Config.marketingOptIn
        $insightOnlineEnabled   = $OVRS_Config.InsightOnlineEnabled

        $OVRS_Contact           = Get-HPOVRemoteSupportContact

        $firstName              = $OVRS_Contact.firstName
        $lastName               = $OVRS_Contact.lastName
        $email                  = $OVRS_Contact.email
        $primaryPhone           = $OVRS_Contact.primaryPhone
        $default                = $OVRS_Contact.default

        $OVRS_DefaultSite       = Get-HPOVRemoteSupportDefaultSite

        $streetAddress1         = $OVRS_DefaultSite.streetAddress1
        $streetAddress2         = $OVRS_DefaultSite.streetAddress2
        $city                   = $OVRS_DefaultSite.city
        $provinceState          = $OVRS_DefaultSite.provinceState
        $postalCode             = $OVRS_DefaultSite.postalCode
        $countryCode            = $OVRS_DefaultSite.countryCode
        $timeZone               = $OVRS_DefaultSite.timeZone

        $ValuesArray            += "$enabled,$company,$autoEnableDevices,$marketingOptIn,$insightOnlineEnabled,$firstName,$lastName,$email,$primaryPhone,$default,$streetAddress1,$streetAddress2,$city,$provinceState,$postalCode,$countryCode,$timeZone"

        if ($ValuesArray)
        {
            Write-Host -ForegroundColor Cyan "Exporting OVRS config to CSV file        --> $OVRSConfig"
            New-Item $Outfile -ItemType file -Force -ErrorAction Stop | Out-Null
            Set-Content -Path $Outfile -Value $OVRSHeader
            Add-Content -Path $OutFile -Value $ValuesArray
        }
    } else {
        Write-Host -ForegroundColor Yellow "  OVRS not configured.  Skip exporting..."
    }
}


# -------------------------------------------------------------------------------------------------------------
#
#       Main Entry
#
# -------------------------------------------------------------------------------------------------------------

# ---------------- Unload any earlier versions of the HPOneView POSH modules
#
Remove-Module -ErrorAction SilentlyContinue HPOneView.120
Remove-Module -ErrorAction SilentlyContinue HPOneView.200
Remove-Module -ErrorAction SilentlyContinue HPOneView.300
Remove-Module -ErrorAction SilentlyContinue HPOneView.310
Remove-Module -ErrorAction SilentlyContinue HPOneView.400

if (-not (get-module $OneViewModule))
{
    Import-Module -Name $OneViewModule
}

# ---------------- Connect to Synergy Composer
#
if ( (-not $OVApplianceIP) -or (-not $OVAdminName))
{
	$OVApplianceIP      = Read-Host 'Synergy Composer IP Address'
	$OVAdminName        = Read-Host 'Administrator Username'
	$OVAdminPassword    = Read-Host 'Administrator Password' -AsSecureString

    $global:ApplianceConnection = Connect-HPOVMgmt -appliance $OVApplianceIP -user $OVAdminName -password $OVAdminPassword  -AuthLoginDomain $OVAuthDomain -errorAction stop

    if (-not $ConnectedSessions)
    {
        Write-Host "Login to Synergy Composer or OV appliance failed.  Exiting."
        Exit
    }
}

if ($ConnectedSessions)
{
    $OVProfileTemplateConnectionCSV = ""
    $OVProfileTemplateLOCALStorageCSV = ""
    $OVProfileTemplateSANStorageCSV = ""

    if ($All)
    {
        $OVEthernetNetworksCSV                  = "EthernetNetworks.csv"
        $OVNetworkSetCSV                        = "NetworkSet.csv"
        $OVFCNetworksCSV                        = "FCNetworks.csv"

        $OVLogicalInterConnectGroupCSV          = "LogicalInterConnectGroup.csv"
        $OVUplinkSetCSV                         = "UpLinkSet.csv"

        $OVEnclosureGroupCSV                    = "EnclosureGroup.csv"
        $OVEnclosureCSV                         = "Enclosure.csv"
        $OVLogicalEnclosureCSV                  = "LogicalEnclosure.csv"
        $OVDLServerCSV                          = "DLServers.csv"

        $OVProfileCSV                           = "Profiles.csv"
        $OVProfileTemplateCSV                   = "ProfileTemplate.csv"
        $OVProfileConnectionCSV                 = "ProfileConnection.csv"
        $OVProfileLOCALStorageCSV               = "ProfileLOCALStorage.csv"
        $OVProfileSANStorageCSV                 = "ProfileSANStorage.csv"

        $OVProfileTemplateConnectionCSV         = "ProfileTemplateConnection.csv"
        $OVProfileTemplateLOCALStorageCSV       = "ProfileTemplateLOCALStorage.csv"
        $OVProfileTemplateSANStorageCSV         = "ProfileTemplateSANStorage.csv"

        $OVSanManagerCSV                        = "SANManager.csv"
        $OVStorageSystemCSV                     = "StorageSystems.csv"
        $OVStorageVolumeTemplateCSV             = "StorageVolumeTemplate.csv"
        $OVStorageVolumeCSV                     = "StorageVolume.csv"

        $OVAddressPoolCSV                       = "AddressPool.csv"
        $OVWwnnCSV                              = "Wwnn.csv"
        $OVIPAddressCSV                         = "IPAddress.csv"
        $OVOSDeploymentCSV                      = "OSDeployment.csv"

        $OVTimeLocaleCSV                        = "TimeLocale.csv"
        $OVSmtpCSV                              = "SMTP.csv"
        $OVAlertsCSV                            = "Alerts.csv"
        $OVScopesCSV                            = "Scopes.csv"
        $OVUsersCSV                             = "Users.csv"
        $OVFWReposCSV                           = "FWRepositories.csv"
        $OVBackupConfig                         = "BackupConfigurations.csv"
        $OVRSConfig                             = "OVRSConfiguration.csv"
        $OVProxyCSV                             = "Proxy.csv"
        $OVLdapCSV                              = "LDAP.csv"
        $OVLdapGroupsCSV                        = "LDAPGroups.csv"
    }


    if (-not [string]::IsNullOrEmpty($OVFWReposCSV))
    {
        Export-FWRepos -Outfile $OVFWReposCSV
    }

    if (-not [string]::IsNullOrEmpty($OVTimeLocaleCSV))
    {
        Export-TimeLocale -Outfile $OVTimeLocaleCSV
    }

    if (-not [string]::IsNullOrEmpty($OVProxyCSV))
    {
        Export-Proxy -Outfile $OVProxyCSV
    }

    if (-not [string]::IsNullOrEmpty($OVSmtpCSV))
    {
        Export-SMTP -Outfile $OVSmtpCSV
    }

    if (-not [string]::IsNullOrEmpty($OVLdapCSV))
    {
        Export-LDAP -Outfile $OVLdapCSV
    }

    if (-not [string]::IsNullOrEmpty($OVAlertsCSV))
    {
        Export-Alerts -Outfile $OVAlertsCSV
    }

    if (-not [string]::IsNullOrEmpty($OVAddressPoolCSV))
    {
        Export-OVAddressPool -Outfile $OVAddressPoolCSV
    }

    if (-not [string]::IsNullOrEmpty($OVwwnnCSV))
    {
        Export-OVWwnn -Outfile $OVWwnnCSV
    }

    if (-not [string]::IsNullOrEmpty($OVIPAddressCSV))
    {
        Export-OVIPAddress -Outfile $OVIPAddressCSV
    }

    if (-not [string]::IsNullOrEmpty($OVOSDeploymentCSV))
    {
        Export-OVOSDeployment -Outfile $OVOSDeploymentCSV
    }

    if (-not [string]::IsNullOrEmpty($OVEthernetNetworksCSV))
    {
        Export-OVNetwork -OutFile $OVEthernetNetworksCSV
    }

    if (-not [string]::IsNullOrEmpty($OVNetworkSetCSV))
    {
        Export-OVNetworkSet -OutFile $OVNetworkSetCSV
    }

    if (-not [string]::IsNullOrEmpty($OVFCNetworksCSV))
    {
        Export-OVFCNetwork -OutFile $OVFCNetworksCSV
    }

    if (-not [string]::IsNullOrEmpty($OVSANManagerCSV))
    {
        Export-OVSANManager -OutFile $OVSANManagerCSV
    }

    if (-not [string]::IsNullOrEmpty($OVStorageSystemCSV))
    {
        Export-OVStorageSystem -OutFile $OVStorageSystemCSV
    }

    if (-not [string]::IsNullOrEmpty($OVStorageVolumeTemplateCSV))
    {
        Export-OVStorageVolumeTemplate -OutFile $OVStorageVolumeTemplateCSV
    }

    if (-not [string]::IsNullOrEmpty($OVStorageVolumeCSV))
    {
        Export-OVStorageVolume -OutFile $OVStorageVolumeCSV
    }

    if (-not [string]::IsNullOrEmpty($OVScopesCSV))
    {
        Export-Scopes -Outfile $OVScopesCSV
    }

    if (-not [string]::IsNullOrEmpty($OVUsersCSV))
    {
        Export-Users -Outfile $OVUsersCSV
    }

    if (-not [string]::IsNullOrEmpty($OVLdapGroupsCSV))
    {
        Export-Groups -Outfile $OVLdapGroupsCSV
    }

    if (-not [string]::IsNullOrEmpty($OVLogicalInterConnectGroupCSV))
    {
        Export-OVLogicalInterConnectGroup -OutFile $OVLogicalInterConnectGroupCSV
    }

    if (-not [string]::IsNullOrEmpty($OVUplinkSetCSV))
    {
        Export-OVUpLinkSet -OutFile $OVUplinkSetCSV
    }

    if (-not [string]::IsNullOrEmpty($OVEnclosureGroupCSV))
    {
        Export-OVEnclosureGroup -OutFile $OVEnclosureGroupCSV
    }

    if (-not [string]::IsNullOrEmpty($OVEnclosureCSV))
    {
        Export-OVEnclosure -OutFile $OVEnclosureCSV
    }

    if (-not [string]::IsNullOrEmpty($OVLogicalEnclosureCSV))
    {
        Export-OVLogicalEnclosure -OutFile $OVLogicalEnclosureCSV
    }

    if (-not [string]::IsNullOrEmpty($OVDLServerCSV))
    {
        Export-OVDLServer -OutFile $OVDLServerCSV
    }

    if (-not [string]::IsNullOrEmpty($OVBackupConfig))
    {
        Export-BackupConfig -Outfile $OVBackupConfig
    }

    if (-not [string]::IsNullOrEmpty($OVRSConfig))
    {
        Export-OVRSConfig -Outfile $OVRSConfig
    }

    if ( -not [string]::IsNullOrEmpty($OVProfileCSV)             -and `
         -not [string]::IsNullOrEmpty($OVProfileConnectionCSV)   -and `
         -not [string]::IsNullOrEmpty($OVProfileLOCALStorageCSV) -and `
         -not [string]::IsNullOrEmpty($OVProfileSANStorageCSV) )
    {
        Export-ProfileorTemplate -CreateProfile -OutprofileTemplate $OVProfileCSV -outConnectionfile $OVProfileConnectionCSV -OutLOCALStorageFile $OVProfileLOCALStorageCSV -OutSANStorageFile $OVProfileSANStorageCSV

        $OVProfileConnectionCSV = ""
        $OVProfileLOCALStorageCSV = ""
        $OVProfileSANStorageCSV = ""
    }

    if ( -not [string]::IsNullOrEmpty($OVProfileTemplateCSV)             -and `
         -not [string]::IsNullOrEmpty($OVProfileTemplateConnectionCSV)   -and `
         -not [string]::IsNullOrEmpty($OVProfileTemplateLOCALStorageCSV) -and `
         -not [string]::IsNullOrEmpty($OVProfileTemplateSANStorageCSV) )
    {
        Export-ProfileorTemplate -OutprofileTemplate $OVProfileTemplateCSV -OutConnectionfile $OVProfileTemplateConnectionCSV -OutLOCALStorageFile $OVProfileTemplateLOCALStorageCSV -OutSANStorageFile $OVProfileTemplateSANStorageCSV

        $OVProfileTemplateConnectionCSV = ""
        $OVProfileTemplateLOCALStorageCSV = ""
        $OVProfileTemplateSANStorageCSV = ""
    }


    Write-Host -ForegroundColor Cyan "`nDisconnecting from OneView/Synergy...`n"
    Write-Host -ForegroundColor Cyan "----------------------------------------------------------------------"
    Write-Host -ForegroundColor Cyan "The script does not export credentials of OneView/Synergy resources."
    Write-Host -ForegroundColor Cyan "Before importing resources, update credentials in the following files:"
    Write-Host -ForegroundColor Cyan "  - SANManager.csv"
    Write-Host -ForegroundColor Cyan "  - StorageSystems.csv"
    Write-Host -ForegroundColor Cyan "  - Enclosure.csv"
    Write-Host -ForegroundColor Cyan "  - DLServers.csv"
    Write-Host -ForegroundColor Cyan "  - SMTP.csv"
    Write-Host -ForegroundColor Cyan "  - Users.csv"
    Write-Host -ForegroundColor Cyan "  - FWRepositories.csv"
    Write-Host -ForegroundColor Cyan "  - BackupConfigurations.csv"
    Write-Host -ForegroundColor Cyan "  - Proxy.csv"
    Write-Host -ForegroundColor Cyan "  - LDAP.csv"
    Write-Host -ForegroundColor Cyan "  - LDAPGroups.csv"
    Write-Host -ForegroundColor Cyan "----------------------------------------------------------------------`n"
    Disconnect-HPOVMgmt
}