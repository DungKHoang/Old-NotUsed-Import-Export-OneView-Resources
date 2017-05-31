## -------------------------------------------------------------------------------------------------------------
##
##
##      Description: Export
##
## DISCLAIMER
## The sample scripts are not supported under any HPE standard support program or service.
## The sample scripts are provided AS IS without warranty of any kind. 
## HP further disclaims all implied warranties including, without limitation, any implied 
## warranties of merchantability or of fitness for a particular purpose. 
##
##    
## Scenario
##     	Export OneView resources
##	
## Description
##      The script export OneView resources to CSV files    
##		
##
## Input parameters:
##         OVApplianceIP                      = IP address of the OV appliance
##		   OVAdminName                        = Administrator name of the appliance
##         OVAdminPassword                    = Administrator's password
##         OVEthernetNetworksCSV              = path to the CSV file containing Ethernet networks definition
##         OVFCNetworksCSV                    = path to the CSV file containing FC networks definition
##
##         OVSANManagerCSV                    = path to the CSV file containing SAN Managers definition
##         OVStorageSystemCSV                 = path to the CSV file containing Storage System definition
##
##         OVLogicalInterConnectCGroupSV      = path to the CSV file containing Logical Interconnect Group
##         OVUpLinkSetCSV                     = path to the CSV file containing UplinkSet
##         OVEnclosureGroupCSV                = path to the CSV file containing Enclosure Group
##         OVEnclosureCSV                     = path to the CSV file containing Enclosure definition
##         OVProfileConnectionCSV             = path to the CSV file containing Profile Connections definition
##         OVProfileCSV                       = path to the CSV file containing Server Profile definition
##         All                                = if present, the script will export all resources into CSv files ( default names will be used)
##
## History: 
##         March 2015 - Created from creator.ps1
##
##         Oct 2016    - v3.0 for Synergy
##
##         April 2017 - Include Vincent Berger's modifications
##
##         May 2017 - v3.1   - Add AuthLoginDomain to Connect-HPOVMgmt  
##
##         June 2017 - v3.2  - Align with Import-OVResources.ps1
##                         
##   Version : 3.2
##
##   Version : 3.2 - June 2017
##
## Contact : Dung.HoangKhac@hpe.com
##
##
## -------------------------------------------------------------------------------------------------------------
<#
  .SYNOPSIS
     Export resources to OneView appliance.
  
  .DESCRIPTION
	 Export resources to OneView appliance.
        
  .EXAMPLE

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVEthernetnetworksCSV .\net.csv 
        The script connects to the OneView appliance and exports Ethernet networks to the net.csv file

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVFCnetworksCSV .\fc.csv 
    The script connects to the OneView appliance and exports FC networks to the net.csv file

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 `
        -OVLogicalInterConnectGroupCSV .\lig.csv 
    The script connects to the OneView appliance and exports logical Interconnect group to the lig.csv file

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVUplinkSetCSV .\upl.csv 
    The script connects to the OneView appliance and exports Uplink set to the upl.csv file

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVEnclosureGroupCSV .\EG.csv 
    The script connects to the OneView appliance and exports EnclosureGroup to the EG.csv file

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVEnclosureCSV .\Enc.csv 
    The script connects to the OneView appliance and exports Enclosure to the Enc.csv file

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1  `
        -OVProfileCSV .\profile.csv -OVProfileConnectionCSV .\connection.csv 
    The script connects to the OneView appliance and exports server profile to the profile.csv and connection.csv files

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1  -All
    The script connects to the OneView appliance and exports all OV resources to a set of pre-defined CSV files.

    .\ Export-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OneViewmodule HPOneView.110
    The script uses the POSH OneView library v1.10 to connect to the OneView appliance


  .PARAMETER OVApplianceIP                   
    IP address of the OV appliance

  .PARAMETER OVAdminName                     
    Administrator name of the appliance

  .PARAMETER OVAdminPassword                 
    Administrator s password

  .PARAMETER All
    if present, export all resources

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

  .PARAMETER OneViewModule
    Module name for POSH OneView library.
	
  .PARAMETER OVAuthDomain
    Authentication Domain to login in OneView.

  .Notes
    NAME:  Export-OVResources
    LASTEDIT: 06/01/2017
    KEYWORDS: OV  Export
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>
  


## -------------------------------------------------------------------------------------------------------------

Param ( [string]$OVApplianceIP   = "" , 
        [string]$OVAdminName     = "", 
        [string]$OVAdminPassword = "",
        [string]$OVAuthDomain    = "local",

        [switch]$All,
       

        [string]$OVEthernetNetworksCSV ="",                                               #D:\Oneview Scripts\OV-EthernetNetworks.csv",
        [string]$OVNetworkSetCSV ="",
        [string]$OVFCNetworksCSV ="",                                                     #D:\Oneview Scripts\OV-FCNetworks.csv",

        [string]$OVSANManagerCSV = "",                                                    #D:\Oneview Scripts\OV-SANManager.csv'
        [string]$OVStorageSystemCSV = "",                                                 #D:\Oneview Scripts\OV-StorageSystem.csv'
        [string]$OVStorageVolumeTemplateCSV = "",                                         #D:\Oneview Scripts\OV-StorageVolumeTemplate.csv'
        [string]$OVStorageVolumeCSV = "",                                                 #D:\Oneview Scripts\OV-StorageVolume.csv'

        [string]$OVLogicalInterConnectGroupCSV ="",                                       #D:\Oneview Scripts\OV-LogicalInterConnectGroup.csv",
        [string]$OVUpLinkSetCSV ="",                                                      #D:\Oneview Scripts\OV-UpLinkSet.csv",
        [string]$OVEnclosureGroupCSV ="" ,                                                 #"\C:\OV30-Scripts\c7000-export\enclosuregroup.csv",
        [string]$OVServerCSV = "" ,

        [string]$OVProfileCSV = "" ,                                                      #D:\Oneview Scripts\OV-Profile.csv",
        [string]$OVProfileTemplateCSV = "" ,                                               #D:\Oneview Scripts\OV-Profile.csv", 
        [string]$OVProfileConnectionCSV ="", 
        [string]$OVProfileLOCALStorageCSV ="", 
        [string]$OVProfileSANStorageCSV ="", 
        

        [string]$OVAddressPoolCSV ="",                                                    #D:\Oneview Scripts\OV-AddressPool.csv",

        [string]$OneViewModule = "HPOneView.300"

        )


$Delimiter = "\"   # Delimiter for CSV profile file
$Sep       = ";"   # USe for multiple values fields
$SepChar   = '|'
$CRLF      = "`r`n"
$OpenDelim = "={"
$CloseDelim = "}" 
$CR         = "`n"
$Comma      = ','

# ------------------ Headers

#$NSHeader          = "NetworkSet,NSdescription,NSTypicalBandwidth,NSMaximumBandwidth,Networks,Native"

$NetHeader           = "NetworkSet,NSTypicalBandwidth,NSMaximumBandwidth,NetworkName,Type,vLANID,vLANType,Subnet,TypicalBandwidth,MaximumBandwidth,SmartLink,PrivateNetwork,Purpose"
                       

$FCHeader            = "NetworkName,Description,Type,FabricType,ManagedSAN,vLANID,TypicalBandwidth,MaximumBandwidth,LoginRedistribution,LinkStabilityTime"
                        
$LigHeader           = "LIGName,InterConnectType,BayConfig,Redundancy,InternalNetworks,IGMPSnooping,IGMPIdleTimeout,FastMacCacheFailover,MacRefreshInterval,NetworkLoopProtection,PauseFloodProtection,EnhancedLLDPTLV,LDPTagging,SNMP,QOSConfiguration"

$UplHeader           = "LIGName,UplinkSetName,UpLinkType,UpLinkPorts,Networks,NativeEthernetNetwork,EthMode,TagType,lacpTimer,FcSpeed"

$EGHeader            = "EnclosureGroupName,Description,LogicalInterConnectGroupMapping,EnclosureCount,IPv4AddressType,AddressPool,DeploymentNetworkType,DeploymentNetwork,PowerRedundantMode"
 
$EncHeader           = "EnclosureGroupName,EnclosureName,OAIPAddress,OAAdminName,OAAdminPassword,LicensingIntent,FWBaseLine,FWiso,FWManaged" 
                        
$ServerHeader        = "ServerName,AdminName,AdminPassword,Monitored,LicensingIntent"

$ProfileHeader       = "ProfileName,Description,AssignmentType,Enclosure,EnclosureBay,Server,ServerTemplate,ServerHardwareType,EnclosureGroup,Affinity,FWEnable,FWBaseline,FWMode,FWInstall,BIOSSettings,BootOrder,BootMode,PXEBootPolicy,MACAssignment,WWNAssignment,SNAssignment,hideUnusedFlexNics" 

$PSTHeader           = "ProfileTemplateName,Description,ServerProfileDescription,ServerHardwareType,EnclosureGroup,Affinity,FWEnable,FWBaseline,FWMode,FWInstall,BIOSSettings,BootOrder,BootMode,PXEBootPolicy,MACAssignment,WWNAssignment,SNAssignment,hideUnusedFlexNics" 

$ProfilePSTHeader    = "ServerProfileName,Description,ServerProfileTemplate,Server,AssignmentType"

$SANManagerHeader    = "SanManagerName,Type,Username,Password,Port,UseSSL,snmpAuthLevel,snmpAuthProtocol,snmpAuthUsername,snmpAuthPassword,snmpPrivProtocol,snmpPrivPassword"

$StSHeader           = "StorageHostName,StorageAdminName,StorageAdminPassword,StoragePorts,StorageDomainName,StoragePools"

$StVolTemplateHeader = "TemplateName,Description,StoragePool,StorageSystem,Capacity,ProvisionningType,Shared,SnapShotStoragePool"

$StVolumeHeader      = "VolumeName,Description,StoragePool,StorageSystem,VolumeTemplate,Capacity,ProvisionningType,Shared"

# OLD$ConnectionHeader   = "ServerProfileName,ConnectionID,ConnectionType,NetworkName,PortID,RequestedBandwidth,BootPriority,ConnectionMACAddress,ConnectionWWNN,ConnectionWWPN,ArrayWWPN,LunID"

$ConnectionHeader    = "ServerProfileName,ConnectionName,ConnectionID,NetworkName,PortID,RequestedBandwidth,Bootable,BootPriority,UserDefined,ConnectionMACAddress,ConnectionWWNN,ConnectionWWPN,ArrayWWPN,LunID"

$LOCALStorageHeader  = "ProfileName,EnableLOCALstorage,ControllerMode,ControllerInitialize,LogicalDisks,Bootable,DriveType,RAID,NumberofDrives,MinDriveSize,MaxDriveSize" 

$SANStorageHeader    = "ProfileName,EnableSANstorage,HostOSType,VolumeName,Lun"        

$AddressPoolHeader   = "PoolName,PoolType,RangeType,StartAddress,EndAddress,NetworkID,SubnetMask,Gateway,DnsServers,DomainName"

$WarningText = @"
***WarninG***
Profile CSV file use '$Delimiter' as delimiter for CSV. 
When importing to Excel,use this character as delimiter.
***WarninG*** 

"@

#------------------- Interconnect Types
$ICTypes           = @{
    "571956-B21" =  "FlexFabric" ;
    "455880-B21" =  "Flex10"     ;
    "638526-B21" =  "Flex1010D"  ;
    "691367-B21" =  "Flex2040f8" ;
    "572018-B21" =  "VCFC20"     ;
    "466482-B21" =  "VCFC24"     ;
    "641146-B21" =  "FEX"
}     

[string]$HPOVMinimumVersion = "3.0.1210.3013"



Function Get-Header-Values([PSCustomObject[]]$ObjList)
{
    foreach ($obj in $ObjList)
        {
            # --------
            # Get Properties name out PSCustomObject

            $Properties   = $obj.psobject.Properties
            $PropNames    = @()
            $PropValues   = @()

            foreach ($p in $Properties)
            {
                $PropNames    += $p.Name
                $PropValues   += $p.Value

            }

           $header         = $PropNames -join $Comma   
           $ValuesArray   += $($PropValues -join $Comma) + $CR

        }
    return $header, $ValuesArray

}


Function Get-NamefromUri([string]$uri)
{
    $name = ""

    if (-not [string]::IsNullOrEmpty($Uri))
        { $name   = (Send-HPOVRequest $Uri).Name }

    return $name

}

function Check-HPOVVersion {
    #Check HPOV version
    #Encourage people to run the latest version

    $arrMinVersion = $HPOVMinimumVersion.split(".")
    $arrHPOVVersion=((Get-HPOVVersion ).OneViewPowerShellLibrary).split(".")
    if ( ($arrHPOVVersion[0] -gt $arrMinVersion[0]) -or
        (($arrHPOVVersion[0] -eq $arrMinVersion[0]) -and ($arrHPOVVersion[1] -gt $arrMinVersion[1])) -or
        (($arrHPOVVersion[0] -eq $arrMinVersion[0]) -and ($arrHPOVVersion[1] -eq $arrMinVersion[1]) -and ($arrHPOVVersion[2] -gt $arrMinVersion[2])) -or
        (($arrHPOVVersion[0] -eq $arrMinVersion[0]) -and ($arrHPOVVersion[1] -eq $arrMinVersion[1]) -and ($arrHPOVVersion[2] -eq $arrMinVersion[2]) -and       ($arrHPOVVersion[3] -ge $arrMinVersion[3])) )
        {
        #HPOVVersion the same or newer than the minimum required
        }
    else {
        Write-Error "You are running an old version of POSH-HPOneView. Update your HPOneView POSH from: https://github.com/HewlettPackard/POSH-HPOneView/releases"
        exit 1 #Write-Error should cause script to exit
        }
}


# region Network

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVNetwork - Export Ethernet networks 
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVNetwork ([string]$OutFile )  
{

    $ListofNetworks = Get-HPOVNetwork | where Type -like "Ethernet*"

    $ListofNetworkSet = Get-HPOVNetworkSet | sort Name

    foreach ($net in $ListofNetworks )
    {
        $nsName = $nspBW = $nsmBW = ""
        # ---------------------- Construct Network Set Names
        foreach ($netset in $ListofNetworkSet)
        {
            if ($netset.NetworkUris -contains $net.uri)
            {
                $nsName += $netset.name.Trim() + $sepchar
                $nspBW  += ( 1/1000 * $netset.TypicalBandwidth).ToString() + $sepchar
                $nsmBW  += ( 1/1000 * $netset.MaximumBandwidth).ToString() + $sepchar
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
        $vLANID      = $net.vLanId
        $vLANType    = $net.ethernetNetworkType
       

        $typicalBW   = (1/1000 * $net.DefaultTypicalBandwidth).ToString()    
        $maxBW       = (1/1000 * $net.DefaultMaximumBandwidth).ToString()   
        $smartlink   = if ($net.SmartLink) {'Yes'} else {'No'}
        $Private     = if ($net.PrivateNetwork) {'Yes'} else {'No'}
        $purpose     = $net.purpose

        # Valid only for Synergy Composer
        

			if ($Global:applianceconnection.ApplianceType -eq 'Composer')
			{
                $ThisSubnet = Get-hPOVAddressPoolSubnet | where URI -eq $net.subnetURI
                if ($ThisSubnet)
                    { $subnet = $ThisSubnet.NetworkID }
                else 
                    { $subnet = "" }
            }
            else 
                { $subnet = ""}
            
        
                       #"NetworkSet,NSTypicalBandwidth,NSMaximumBandwidth,Name,Type,vLANID,vLANType,Subnet,TypicalBandwidth,MaximumBandwidth,SmartLink,PrivateNetwork,Purpose"
        $ValuesArray += "$nsName,$nspBW,$nsmBW,$name,$type,$vLANID,$vLANType,$subnet,$typicalBW,$MaxBW,$SmartLink,$Private,$purpose" + $CR
    }

    if ($ValuesArray -ne $NULL)
    {
        $a= New-Item $OutFile  -type file -force
        Set-content -Path $OutFile -Value $Netheader
        Add-content -path $OutFile -Value $ValuesArray

    }

    

}



## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVFCNetwork - Export Fibre Channel networks
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVFCNetwork ([string]$OutFile )  
{

    $ListofNetworks = Get-HPOVNetwork | where Type -like "Fc*"


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

                        #"NetworkName,Description,Type,FabricType,ManagedSAN,vLANID,TypicalBandwidth,MaximumBandwidth,LoginRedistribution,LinkStabilityTime"

        $ValuesArray += "$name,$description,$type,$fabrictype,$ManagedSAN,$VLANID,$typicalBW,$MaxBW,$autologin,$linkStab" + $CR
    }

    if ($ValuesArray -ne $NULL)
    {
        $a = New-Item $OutFile  -type file -force
        Set-content -Path $OutFile -Value $fcheader
        Add-content -path $OutFile -Value $ValuesArray

    }


    

}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVNetworkSet - Export Ethernet network sets 
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVNetworkSet ([string]$OutFile)
{

    $ListofNetworkSets = Get-HPOVNetworkSet  | sort Name

    
    $ValuesArray       = @()

    foreach ($ns in $ListofNetworkSets)
    {
        $netArray      = @()
        $NativeNetwork = ""

        # ------ Get members of network set

        $ListofNetUris = $ns.networkUris
        if ($ListofNeturis -ne $NULL)
        {
            $ListofNeturis | % { $NetArray  += Get-NamefromUri $_ } # Get name of network which is member of the networkset
        }

        [Array]::Sort($NetArray)
        $Networks         = $NetArray -join $Sep 
                                          
        
        # ----- Get information of networkset

        $nsname        = $ns.name
        $nsdescription = $ns.description
        $nstypicalBW   = $ns.TypicalBandwidth /1000
        $nsMaxBW       = $ns.MaximumBandwidth /1000
        $nsnativenet   = Get-NamefromUri -uri $ns.NativeNetworkUri



        # ---- Added to array
                            #"NetworkSet,NSdescription,NStypicalbandwidth,NSmaximubandwidth,Networks,Native,"
        $ValuesArray     +=  "$nsname,$nsdescription,$nstypicalBW,$nsMaxBW,$Networks,$nsnativenet" + $CR


       
    }

    if ($ValuesArray -ne $NULL)
    {
        $a = New-Item $OutFile  -type file -force
        Set-content -Path $OutFile -Value $Nsheader
        Add-content -path $OutFile -Value $ValuesArray   

    }


    
}

# endregion Network

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVLogicalInterConnectGroup
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVLogicalInterConnectGroup ([string]$OutFile)
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
    $Ligs        = Get-hpovlogicalInterconnectGroup | Sort Name

    if ($Ligs -ne $NULL)
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
            $sampleCount            = $Telemetry.sampleCount
            $sampleInterval         = $Telemetry.sampleInterval

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
                { $InternalNetworks = $IntNetworks -join $SepChar }

            # ----------------------------
            #     Find Interconnect devices

            $Bays         = @()
            $UpLinkPorts  = @()
            $Frames       = @()

            $LigInterConnects = $ligobj.interconnectmaptemplate.interconnectmapentrytemplates
            foreach ($LigInterconnect in $LigInterConnects | where permittedInterconnectTypeUri -ne $NULL )
            {
                # -----------------
                # Locate the Interconnect device and its position

                $ICTypeuri  = $LigInterconnect.permittedInterconnectTypeUri

                if ($global:applianceconnection.ApplianceType -eq 'Composer')
                {

                    $ThisICType = ""
                    if ( $ICTypeUri)
                        { $ThisICType = Get-NamefromUri -uri $ICTypeUri }

                    $BayNumber    = ($LigInterconnect.logicalLocation.locationEntries | where Type -eq "Bay").RelativeValue
                    $FrameNumber  = ($LigInterconnect.logicalLocation.locationEntries | where Type -eq "Enclosure").RelativeValue
                    $FrameNumber = [math]::abs($FrameNumber) 
                    $Bays += "Frame$FrameNumber" + $Delimiter + "Bay$BayNumber"+ "=" +  "$ThisICType"   # Format is Frame##\Bay##=InterconnectType 

                }
                else # C7K
                {
                    $PartNumber = (send-hpovRequest $ICTypeuri ).partNumber
                    $ThisICType = $ICTypes[$PartNumber]


                    $BayNumber    = ($LigInterconnect.logicalLocation.locationEntries | where Type -eq "Bay").RelativeValue

                    $Bays += "$BayNumber=$ThisICType"                                     # Format is xx=Flex Fabric


                }
            }
            
            [Array]::Sort($Bays)
            if ($global:applianceconnection.ApplianceType -eq 'Composer')
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
                        else 
                        {
                            if ($ThisFrame -eq $CurrentFrame)
                            {
                                $CurrentBayConfig += $ThisBay
                            }
                            else 
                            {
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
                $b                = $a.Split('=')[1]                               # Separate Bay
                $FabricModuleType = $b.Split($SepChar)[0]           # Get the name


                $ICBaySet         = $BayConfigperFrame.Length # Not used 


                # a/ BayConfigperframe is an array --> Needs to convert to string using -join
                # b/ BayConfig is a cell with multiple lines. Need to surround it with " "
                #
                $BayConfig         = "`"" + $($BayConfigperFrame -join "") + "`""  
            }
            else # C7K
            {
                $BayConfig = $Bays -join $SepChar
            }



 

                                 #LIGName,InterConnectType,BayConfig,Redundancy,InternalNetworks,IGMPSnooping,IGMPIdleTimeout,FastMacCacheFailover,MacRefreshInterval,NetworkLoopProtection,PauseFloodProtection,EnhancedLLDPTLV,LDPTagging,SNMP,QOSConfiguration"  
            $ValuesArray      += "$LIGName,$FabricModuleType,$BayConfig,$RedundancyType,$InternalNetworks,$IGMPSnooping,$IGMPIdleTimeout,$FastMacCacheFailover,$MacRefreshInterval,$NetworkLoopProtection,$PauseFloodProtection,$EnableRichTLV,$EnableLDPTagging,," +$CR 
            
        }

        if ($ValuesArray -ne $NULL)
        {
            $a = New-Item $OutFile  -type file -force
            Set-content -Path $OutFile -Value $LigHeader
            add-content -Path $OutFile -value $ValuesArray
            
        }

    }

    
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVUplinkset
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVUplinkSet([string]$OutFile)
{

    $ValuesArray     = @()
    $ListofLIGs      = Get-hpovlogicalInterconnectGroup | sort Name

    if ($ListofLIGs -ne $NULL)
    {
        foreach ($LIG in $ListofLIGs)
        {
            # Collect info on UplinkSet

            $LIGName        = $LIG.Name

            $UpLinkSets     = $LIG.UplinkSets | sort Name
            foreach ($upl in $UplinkSets)
            {
                $UplinkSetName  = $Upl.Name
                $UpLinkType     = $Upl.networkType
                $EthMode        = $Upl.Mode

                $NativenetUri   = $Upl.NativeUri
                $netTagtype     = $Upl.ethernetNetworkType

                $FCSpeed        = 'Auto' # ??
                $PrimPort       = $Upl.PrimaryPort # ??


                $lacpTimer      = $Upl.lacpTimer 
                if ([string]::IsNullOrWhiteSpace($lacpTimer))
                    {$lacpTimer = 'Short' }



                # ----------------------------
                #     Find native Network
                $NativeNetwork = "" 
                if ($NativeNetUri)
                    { $Nativenetwork = Get-NamefromUri -uri $NativenetUri}


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
                                            if ( $neturi -ne $NULL)
                                            {
                                                $Netnames += Get-NamefromUri -uri $neturi
                                            }
                                        }
                                        $networks = $netnames -join $SepChar
                                    }


                    'FibreChannel'  {   
                                        $networks = Get-NamefromUri -uri $networkUris[0]
                                        $FCSpeed = if ($Upl.FCSpeed) { $Upl.FCSpeed } else {' Auto'} 
                                    }
                    Default {}
                }



                # ----------------------------
                #     Find uplink ports
                
                $SpeedArray  = @()
                $UpLinkArray = @()

                $LigInterConnects = $LIG.interconnectmaptemplate.interconnectmapentrytemplates
                
                foreach ($LigIC in $LigInterConnects | where permittedInterconnectTypeUri -ne $NULL )
                {
                    # -----------------
                    # Locate the Interconnect device 

                    $PermittedInterConnectType = send-hpovrequest $LigIC.permittedInterconnectTypeUri

                    # 1. Find port numbers and port names from permittedInterconnectType
                
                    $PortInfos     = $PermittedInterConnectType.PortInfos
                 
                    # 2. Find Bay number and Port number on uplinksets
                    $ICLocation    = $LigIC.LogicalLocation.LocationEntries  
                    $ICBay         = ($ICLocation |where Type -eq "Bay").RelativeValue
                    $ICEnclosure   = ($IClocation  |where Type -eq "Enclosure").RelativeValue
      

 


                    foreach($logicalPort in $Upl.logicalportconfigInfos)
                    {

                            $ThisLocation     = $Logicalport.LogicalLocation.LocationEntries
                            $ThisBayNumber    = ($ThisLocation |where Type -eq "Bay").RelativeValue
                            $ThisPortNumber   = ($Thislocation  |where Type -eq "Port").RelativeValue
                            $ThisEnclosure    = ($Thislocation  |where Type -eq "Enclosure").RelativeValue
                            $ThisPortName     = ($PortInfos | where PortNumber -eq $ThisPortNumber).PortName

                            if (( $ThisBaynumber -eq $ICBay) -and ($ThisEnclosure -eq $ICEnclosure))
                            {
                                if ($ThisEnclosure -eq -1)    # FC module
                                {
                                    $UpLinkArray     += $("Bay" + $ThisBayNumber +":" + $ThisPortName)   # Bay1:1
                                    $s               = $Logicalport.DesiredSpeed
                                    $s               = if ($s) { $s } else {'Auto'}
                                    $SpeedArray      += $s.TrimStart('Speed').TrimEnd('G')

                                }
                                else  # Synergy Frames or C7000
                                {
                                    if ($global:applianceconnection.ApplianceType -eq 'Composer')
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
                $FCSpeed     = $SpeedArray -join $SepChar

                }
            

                               #"LIGName,UplinkSetName,plinkType,UpLinkPorts,Networks,NativeEthernetNetwork,EthMode,TagType,lacpTimer,FcSpeed" 
                $ValuesArray += "$LIGName,$UplinkSetName,$UplinkType,$UpLinkPorts,$Networks,$NativeEthernetNetwork,$EthMode,$netTagType,$lacptimer,$FCSpeed" +$CR
            }

        }

        if ($ValuesArray -ne $NULL)
        {
            $a = New-Item $OutFile  -type file -force
            Set-content -Path $OutFile -Value $UplHeader
            add-content -Path $OutFile -value $ValuesArray
        }
    }
        
    
}



## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVEnclosureGroup
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVEnclosureGroup([string]$OutFile)
{
    $ValuesArray          = @()

    $ListofEncGroups      = Get-hpovEnclosureGroup | sort Name

    if ($ListofEncGroups -ne $NULL)
    {
        foreach ($EG in $ListofEncGroups)
        {
            $EGName              = $EG.Name
            $EGDescription       = $EG.Description

            $EGEnclosureCount    = $EG.Enclosurecount

            $EGPowerMode         = $EG.PowerMode

            $osDeploy            = $EG.osDeploymentSettings
              $DeploySettings    = $osDeploy.deploymentModeSettings
              $EGDeployMode      = $DeploySettings.deploymentMode
              $EGDeployNetwork   = if ($DeploySettings.deploymentNetworkUri) { Get-NamefromUri -uri $DeploySettings.deploymentNetworkUri}

            $EGipV4AddressType   = $EG.ipAddressingMode
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

                if ($global:applianceconnection.ApplianceType -eq 'Composer')
                {

                    $AssociatedLIG       = $EG.associatedLogicalInterconnectGroups
                    if ( $EG.EnclosureCount -eq 1)
                    {
                        if ($AssociatedLIG -is [system.array])
                        {  # 1 Frame - Multiple LIGs
                            $ICArray = @()
                            foreach ($LigURI in $AssociatedLIG)
                                { $ICArray += Get-NamefromUri -uri $LigURI}
                            $EGLIGMapping = "Frame1 = " + $($ICArray -join $Sep)

                        }
                        else 
                        {   # 1 frame - 1 LIG
                            $EGLIGMapping    = Get-NamefromUri -uri $AssociatedLIG    
                        }
                        
                    }
                    else 
                    {
                        # Multiple frames
                        $ICArray = @()
                        for ($i=1; $i -le $EG.EnclosureCount; $i++)
                        {
                            $FrameIndex      = "Frame$i"
                            $ListofAssoLIGs  = $EG.InterConnectBayMappings | where EnclosureIndex -eq $i


                            if ($ListofAssoLIGs)
                            {
                                $AL = $ListofAssoLIGs[0]
                                $ICName      = Get-NamefromUri -uri $AL.LogicalInterConnectGroupURI
                                $ICArray    += "$FrameIndex = $ICName"
                            }
                        }

                        #--- Process Associated LIGs with EnclosureIndex NULL
                        ##   In this scenario, all frames/enclsoures will have this LIG
                        $ListofAssoLIGsNullIndex = $EG.InterConnectBayMappings | where EnclosureIndex -eq $NULL
                        if ($ListofAssoLIGsNullIndex)
                        {
                            $AL = $ListofAssoLIGsNullIndex[0]
                            $ICName      = Get-NamefromUri -uri $AL.LogicalInterConnectGroupURI
                            for ($i=1; $i -le $EG.EnclosureCount; $i++)
                            {
                                $ThisFrameIndex  = "Frame$i"
                                $Found = $false
                                for($j=0; $j -lt $ICArray.Count; $j++)
                                {
                                    if ($ICArray[$j] -like "$ThisFrameIndex*")
                                    {
                                        $ICArray[$j] += $Sep + $ICName
                                        $Found = $true
                                    }
                                }
                                if (-not $Found)
                                {
                                    $ICArray += "$ThisFrameIndex = $ICName"
                                }

                            }
                        }
                        [Array]::Sort($ICArray)
                        $delimiter = " $SepChar "
                        $EGLigMapping =  $ICArray -join $Delimiter    
                    }
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
           

            #                 EnclosureGroupName,Description,LogicalInterConnectGroupMapping,EnclosureCount,IPv4AddressType,AddressPool,DeploymentNetworkType,DeploymentNetwork,PowerRedundantMode
            $ValuesArray  += "$EGName,$EGDescription,$EGLIGMapping,$EGEnclosureCount,$EGipV4AddressType,$EGAddressPool,$EGDeployMode,$EGDeployNetwork,$EGPowerMode" + $CR 
        }

        if ($ValuesArray -ne $NULL)
        {
            $a = New-Item $OutFile  -type file -force
            Set-content -Path $OutFile -Value $EGHeader
            add-content -Path $OutFile -value $ValuesArray
        }
    }

    
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVEnclosure
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVEnclosure([string]$OutFile)
{
    $ValuesArray     = @()
    $ListofEncs      = Get-hpovEnclosure | sort Name

    if ($ListofEncs -ne $NULL)
    {
        foreach ($Enc in $ListofEncs)
        {
            $EncName       = $Enc.Name
            $EGName        = Get-NamefromUri $Enc.enclosureGroupUri

            $EncLicensing  = $Enc.licensingIntent

            $EncFWBaseline = $Enc.fwBaselineName
            if ($EncFWBaseline)
            {
                $EncFWBaseline = $EncFWBaseLine.split(',')[0]
                $uri           = $Enc.fwBaselineUri
                $FWuri         = if ($uri.Startswith('/')) { send-hpovrequest $uri } else {""}
                $EncFwIso  = $FWUri.isoFileName
                $EncFWManaged  = if ($Enc.isFwManaged) {'Yes'} else {'No'}  
            }
            else { $EncFWManaged = 'No' }
   

            $EncOAIP       = $Enc.activeOaPreferredIP
            $EncOAUser     = "***Info N/A***"
            $EncOAPassword = "***Info N/A***"

                             #EnclosureGroupName,EnclosureName,OAIPAddress,OAAdminName,OAAdminPassword,LicensingIntent,FWBaseLine,FWiso,FWManaged" 

            $ValuesArray  += "$EGName,$EncName,$EncOAIP,$EncOAUser,$EncOAPassword,$EncLicensing,$EncFWBaseLine,$EncFwIso,$EncFWManaged" + $CR  	

        }

        if ($ValuesArray -ne $NULL)
        {
            $a = New-Item $OutFile  -type file -force
            Set-content -Path $OutFile -Value $EncHeader
            add-content -Path $OutFile -value $ValuesArray
        }

    }

}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVServer
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVServer([string]$OutFile)
{
    $ValuesArray     = @()
    $ListofServers   = Get-HPOVServer | sort Name

    if ($ListofServers)
    {
        foreach ($s in $ListofServers)
        {
            $IsDL       = $s.Model -like '*DL*'
            if ($isDL)
            {
                $serverName = $s.Name
                $adminName  = $adminpassword = "***Info N/A***"
              
                if ($s.State -eq 'Monitored')
                {
                    $Monitored       = 'Yes'
                    $LicensingIntent = ""
                }
                else 
                {
                   $Monitored        = 'No' 
                   $LicensingIntent  = $s.LicensingIntent
                }
                
                                 #ServerName,AdminName,AdminPassword,Monitored,LicensingIntent
                $ValuesArray  += "$ServerName,$AdminName,$AdminPassword,$Monitored,$LicensingIntent" + $CR
                
                
            }

        }

        if ($ValuesArray -ne $NULL)
        {
            $a = New-Item $OutFile  -type file -force
            Set-content -Path $OutFile -Value $ServerHeader
            add-content -Path $OutFile -value $ValuesArray
        }
    }
}
## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-ProfileConnection
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVProfileConnection($ProfileName, $ConnectionList)
{
    $ConnectionArray = @()

    foreach ($c in $ConnectionList)
    {
        $sp            = $ProfileName
        $connName      = $s.Name
        $cid           = $c.id 
        $portid        = $c.portId
        $Type          = $c.functionType
        $net           = get-namefromUri $c.NetworkUri
        $mac           = $c.mac
        $wwpn          = $c.wwpn 
        $wwnn          = $c.wwnn            
        $boot          = $c.boot.Priority
        $target        = $c.arrayTarget
        $lun           = $c.lun
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
                             #ServerProfileName,ConnectionName,ConnectionID,NetworkName,PortID,RequestedBandwidth,Bootable,BootPriority,UserDefined,ConnectionMACAddress,ConnectionWWNN,ConnectionWWPN,ArrayWWPN,LunID
        $ConnectionArray  += "$sp,$connName,$cid,$net,$portid,$Bw,$Bootable,$boot,$UserDefined,$mac,$wwnn,$wwpn,$target,$lun" + $CR


    }

    ## Add a separator line
    $ConnectionArray  += "##                           $CR"
    
    return $ConnectionArray

}



## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-ProfileLOCALStorage
##
## -------------------------------------------------------------------------------------------------------------

Function Export-ProfileLOCALStorage($ProfileName, $LocalStorageList)
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

            
                                        # ProfileName,EnableLOCALstorage,ControllerMode,ControllerInitialize,LogicalDisks,Bootable,DriveType,RAID,NumberofDrives,MinDriveSize,MaxDriveSize
            $StorageConnectionArray += "$ProfileName,$Enable,$ControllerMode,$ControllerInit,$LDName,$LDBoot,$LDDriveType,$LDRaid,$LDNumDrives"  + $CR
             
        }
    
    
    }
    return $StorageConnectionArray
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-ProfileSANStorage
##
## -------------------------------------------------------------------------------------------------------------

Function Export-ProfileSANStorage($ProfileName, $SANStorageList)
{
    $HostOSList     = @{
    "Citrix Xen Server 5.x/6.x"="CitrixXen";
    "AIX"="AIX" ;
    "IBM VIO Server"="IBMVIO"   ;
    "RHE Linux (Pre RHEL 5)"="RHEL4"     ;
    "RHE Linux (5.x, 6.x)"="RHEL"      ;
    "RHE Virtualization (5.x, 6.x)"="RHEV"
    "ESX 4.x/5.x"="VMware"    ;
    "Windows 2003"="Win2k3"    ;
    "Windows 2008/2008 R2"="Win2k8"    ;
    "Windows 2012 / WS2012 R2"="Win2k12"   ;
    "OpenVMS"="OpenVMS"   ;
    "Egenera"="Egenera"  ;
    "Exanet"="Exanet"    ;
    "Solaris 9/10"="Solaris10" ;
    "Solaris 11"="Solaris11" ;
    "NetApp/ONTAP"="ONTAP"     ;
    "OE Linux UEK (5.x, 6.x)"="OEL"       ;
    "HP-UX (11i v1, 11i v2)"="HPUX11iv2" ;
    "HP-UX (11i v3)"="HPUX11iv3" ;
    "SuSE (10.x, 11.x)"="SUSE"      ;
    "SuSE Linux (Pre SLES 10)"="SUSE9"     ;
    }

    $SANConnectionArray = @()
    $UseSAN             = $SANStorageList.manageSanStorage
    $SANEnable          = if ($useSAN) { 'Yes'} else {'No'}

    if ($useSAN)
    {
        $hostOSType         = $HostOSList[$($SANStorageList.HostOSType)]
        $VolumeList         = $SANStorageList.volumeAttachments

        $LunArray  = $VolNameArray = @()
        foreach ($vol in $VolumeList)
        {
            $LunArray     += $vol.lun
            $VolNameArray += Get-NamefromUri -uri $vol.volumeUri
        }
        $LUN      = $LunArray -join $SepChar
        $VolName  = $VolNameArray -join $SepChar
    }


                           # ProfileName,EnableSANstorage,HostOSType,VolumeName,LunID

    $SANConnectionArray += "$ProfileName,$SANENable,$hostOSType,$VolName,$LUN"

    return $SANCOnnectionArray
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-Profile
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVProfile(  [string]$OutProfile,
                            [string]$OutConnectionFile,
                            [string]$OutLOCALStorageFile,
                            [string]$OutSANStorageFile
                        )
{
     Export-ProfileOrTemplate -createProfile -OutProfileTemplate $OutProfile -outConnectionfile $outConnectionfile -OutLOCALStorageFile $OutLOCALStorageFile -OutSANStorageFile $OutSANStorageFile

}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-ProfileFROMTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVProfileFROMTemplate([string]$OutProfileFROMTemplate)
{


    $ValuesArray     = @()
    $OutFile         = $OutprofileFROMTemplate
    $ListofProfiles  = Get-hpovProfile | sort Name

    if ($ListofProfiles -ne $NULL)
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

                                #ServerProfileName,Description,ServerProfileTemplate,Server,AssignmentType
                $Value        = "$pName,$pDesc,$ProfileTemplateName,$Server,$AssignmentType"
                $ValuesArray += $Value + $CR

            }
            else
            {
                write-host -foreground YELLOW "Profile not created from Profile Template. Skip displaying it..." 
            }
        }
        
        
        
        if ($ValuesArray -ne $NULL)
        {
            Set-content -Path $OutFile -Value $ProfilePSTHeader
            add-content -Path $OutFile -value $ValuesArray


        }
    }

    
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVProfileTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVProfileTemplate(
                [string]$OutProfileTemplate,
                [string]$outConnectionfile,
                [string]$OutLOCALStorageFile,
                [string]$OutSANStorageFile)
{
    Export-ProfileOrTemplate -OutProfileTemplate $OutProfileTemplate -outConnectionfile $outConnectionfile -OutLOCALStorageFile $OutLOCALStorageFile -OutSANStorageFile $OutSANStorageFile

}

Function Export-ProfileOrTemplate(
                [string]$OutProfileTemplate,
                [string]$outConnectionfile,
                [string]$OutLOCALStorageFile,
                [string]$OutSANStorageFile,
                [switch]$CreateProfile)
{


    # Convert stored values of FWMode into values used in POSH 3.0
    $FWModeValues = @{ 
        "FirmwareOnly"            = "FirmwareOnly";
        "FirmwareAndOSDrivers"    = "FirmwareAndSoftware"
        "FirmwareOnlyOfflineMode" = "FirmwareOffline"
    }



    #---- Create Profile Connection/Local Storage/SAN Storage files and arrays

    $ConnectionArray = @()
    $a= New-Item $outConnectionfile  -type file -force
    Set-content -path $outConnectionfile -Value $ConnectionHeader


    $LocalStorageArray = @()
    $a= New-Item $OutLOCALStorageFile  -type file -force
    Set-content -path $OutLOCALStorageFile -Value $LocalStorageHeader

    $SANStorageArray = @()
    $a= New-Item $OutSANStorageFile  -type file -force
    Set-content -path $OutSANStorageFile -Value $SANStorageHeader


    $ValuesArray     = @()
    $OutFile         = $OutprofileTemplate

    if ($CreateProfile)
    {
        $ListofProfiles  = Get-hpovServerProfile | sort Name
    }
    else 
    {
        $ListofProfiles  = Get-hpovServerProfileTemplate | sort Name
    }

    if ($ListofProfiles -ne $NULL)
    {
        foreach ($p in $ListofProfiles)
        {
            $Name                 = $p.Name
            $Desc                 = $p.Description
            $EncGroup             = if ($p.enclosureGroupUri) {get-namefromUri $p.enclosureGroupUri} else {""}
            $AssignType           = "Server"

            if ($CreateProfile)
            {
                $EncBay               = $p.EnclosureBay 
                $EncName              = if ($p.EnclosureUri) {get-namefromUri $p.enclosureUri} else {""}
                $ServerTemplate       = if ($p.serverProfileTemplateUri) {get-namefromUri -uri $p.serverProfileTemplateUri} else {""}
                $server               = if ($p.ServerHardwareUri) {get-namefromUri $p.ServerHardwareUri} else {""}
                  
                if ($server)
                {
                    $AssignType         = "server"
                    if ($server.ToCharArray() -contains ',' )
                    {
                        $server = '"' + $server + '"'
                    }
                }

                elseif ($EncBay -and $EncName)
                    {
                        $AssignType          = "Bay"
                    }
                    elseif ($EncGroup)
                        {
                            $AssignType          = "unassigned"
                        }

               # $ProfileName     = '"' + $SPT.ProfileName.Trim() + '"'       # We use ProfileCSV instead of Template.csv
              

            }
            else 
            {
                $ServerPDescription   = $p.ServerProfileDescription
            }

            
            
            $HideUnusedFlexNics  = if($p.hideUnusedFlexNics) { 'Yes' } else { 'No'}
            $Affinity             = if ($p.Affinity) { $p.Affinity} else {'Bay'}

            $pfw                  = $p.firmware
            if ($pfw.manageFirmware)
            {
                $FWEnable         = 'Yes'
                $FWInstall        = if ($pfw.forceInstallFirmware) { 'Yes' } else { 'No'}
                $FWBaseline       = ""
                if ($pfw.firmwareBaselineUri )
                {
                    $FWObj       = send-HPOVRequest -uri $pfw.firmwareBaselineUri
                    $FWBaseline  = $FWObj.baselineShortName -replace "SPP", "$($FWObj.Name) version" 
                }
                # Convert internal values into values used by POSH
                $FWMode           = $FWModeValues[$pfw.firmwareInstallType]
            }
            else
            {
                $FWEnable         = 'No'
                $FWInstall        = $FWBaseline = $FWMode = ""
            }

            # Get server - SHT and EnclosureGroup
            $ServerHWType         = ""
            if ($p.ServerHardwareTypeUri)
            {
                $ThisSHT = send-hpovRequest -uri $p.ServerHardwareTypeUri
                if ($ThisSHT)
                {
                    $Model          = $ThisSHT.Model
                    $ServerHWType   = $ThisSHT.Name
                    $IsDL           = $Model -like '*DL*'
                }
            
            }

            $EncGroup           = ""
            #$SANStorageArray    = $ConnectionArray = @()
            if (-not $isDL)
            {    #### Only for Blade Servers
                #$ServerHWName         = if ($p.serverHardwareUri) { get-namefromUri $p.serverHardwareUri} else {""}
                $EncGroup             = if ($p.EnclosureGroupuri) { get-namefromUri $p.enclosureGroupUri } 

                # Network and FC Connections
                $pconnections         = $p.connections
                $ConnectionArray      += Export-OVProfileConnection -ProfileName $Name -ConnectionList $p.Connections
                
                # SAN Stroage Connections
                $pSANStorage          = $p.sanStorage
                $SANStorageArray      += Export-ProfileSANStorage -ProfileName $Name -SANStorageList $pSANStorage
            }

            # BootMode
            $pbManageMode = $BootMode = $PXEBootPolicy = ""
            $pbootM               = $p.BootMode
            if ($pBootM.ManageMode)
            {
                $pbManageMode     = 'Yes'
                $BootMode         = $pBootM.Mode  
                $PXEBootpolicy    = $pBootM.pxeBootPolicy                             # UEFI - UEFIOptimiZed BIOS 
            }

            # Boot order
            $BootOrder            = ""
            $pboot                = $p.Boot
            
            if ($pboot.ManageBoot)
                { $BootOrder       = $pboot.Order -join $SepChar }
            
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
            $BIOSSettingsArray    = $ListofBIOSSettings = @()
            $BIOSSettings         = ""

            if ($pBIOS.ManageBIOS)       # True --> There are overriden Settings
            {             
                
                $ListofBIOSSettings = $pBIOS.overriddenSettings
                                      

                if ($ListofBIOSSettings)
                {
                    foreach ($Setting in $ListofBIOSSettings)
                    {
                        $BIOSSetting = "id=$($Setting.id);value=$($Setting.value)"   # Break into a string
                        $BIOSSettingsArray += $BIOSSetting
                    }
                }
                $BIOSSettings = $BIOSSettingsArray -join $SepChar
            }

            if ($createProfile)
            {
                                #ProfileTemplateName,Description,ServerProfileDescription,ServerHardwareType,EnclosureGroup,Affinity,FWEnable,FWBaseline,FWMode,FWInstall,BIOSSettings,BootOrder,BootMode,PXEBootPolicy,MACAssignment,WWNAssignment,SNAssignment,hideUnusedFlexNics"             
                            #ProfileName,Description,AssignmentType,Enclosure,EnclosureBay,Server,ServerTemplate,ServerHardwareType,EnclosureGroup,Affinity,FWEnable,FWBaseline,FWMode,FWInstall,BIOSSettings,BootOrder,BootMode,PXEBootPolicy,MACAssignment,WWNAssignment,SNAssignment,hideUnusedFlexNics
                $Value        = "$Name,$Desc,$AssignType,$EncName,$EncBay,$server,$ServerTemplate,$ServerHWType,$EncGroup,$Affinity,$FWEnable,$FWBaseline,$FWMode,$FWINstall,$BIOSSettings,$BootOrder,$BootMode,$PXEBootPolicy,$MacType,$WWNType,$SNType,$HideUnusedFlexNics" 

            }
            else 
            {
                                #ProfileTemplateName,Description,ServerProfileDescription,ServerHardwareType,EnclosureGroup,Affinity,FWEnable,FWBaseline,FWMode,FWInstall,BIOSSettings,BootOrder,BootMode,PXEBootPolicy,MACAssignment,WWNAssignment,SNAssignment,hideUnusedFlexNics"             
                $Value        = "$Name,$Desc,$ServerPDescription,$ServerHWType,$EncGroup,$Affinity,$FWEnable,$FWBaseline,$FWMode,$FWINstall,$BIOSSettings,$BootOrder,$BootMode,$PXEBootPolicy,$MacType,$WWNType,$SNType,$HideUnusedFlexNics" 

            }
                           
            $ValuesArray += $Value + $CR

        
        }

        if ($ValuesArray -ne $NULL)
        {
            if ($CreateProfile)
            {
                Set-content -Path $OutFile -Value $ProfileHeader
            }
            else 
            {
                Set-content -Path $OutFile -Value $PSTHeader    
            }
            
            add-content -Path $OutFile -value $ValuesArray
            
            #----- Write ConnectionList
            add-content -Path $outConnectionfile -value $ConnectionArray

            #----- Write Local/SAN StorageList
            add-content -Path $OutLOCALStorageFile -value $LocalStorageArray
            add-content -Path $OutSANStorageFile -value $SANStorageArray
        }
    }

}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVSANManager
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVSANManager([string]$Outfile)
{
    $ValuesArray          = @()

    $ListofSANManagers      = Get-hpovSANManager | sort Name


    foreach ($SM in $ListofSANManagers)
    {
        # *********** No show for password
        $AuthPassword = $PrivPassword = $Password = '***Pwd N/A***'

        $SMName              = $SM.Name
        $SMType              = $SM.ProviderDisplayName

                         
        foreach ($CI in $SM.ConnectionInfo)
        {
        Switch ($CI.Name)
        {

            # ------ For HPE and Cisco 
            'SnmpPort'          { $Port          = $CI.Value}
            'SnmpUsername'      { $snmpUsername  = $CI.Value}
            'SnmpAuthLevel'     { 
                                    $v = $CI.Value

                                    if ($v -notlike 'AUTH*')
                                        { $AuthLevel     = 'None'}
                                    else 
                                        {
                                            if ($v -eq 'AUTHNOPRIV')
                                                {$AuthLevel = 'AuthOnly'}
                                            else
                                                {$AuthLevel = 'AuthAndPriv'}
                                        }
                                }  

            'SnmpAuthProtocol'  { $AuthProtocol  = $CI.Value}
            'SnmpPrivProtocol'  { $PrivProtocol  = $CI.Value}

            #---- For Brocade 
            'Username'          { $Username  = $CI.Value}
            'UseSSL'            { $UseSSL  = if ($CI.Value) { 'Yes'} else {'No'}   }
            'Port'              { $Port  = $CI.Value}
        }


        }

        #                 SanManagerName,Type,Username,Password,Port,UseSSL,snmpAuthLevel,snmpAuthProtocol,snmpAuthUsername,snmpAuthPassword,snmpPrivProtocol,snmpPrivPassword
        $ValuesArray  += "$SMName,$SMType,$Username,$Password,$Port,$UseSSL,$AuthLevel,$AuthProtocol,$snmpUsername,$AuthPassword,$PrivProtocol,$PrivPassword" + $CR 
    }

    if ($ValuesArray -ne $NULL)
    {
        $a = New-Item $OutFile  -type file -force
        Set-content -Path $OutFile -Value $SANManagerHeader
        add-content -Path $OutFile -value $ValuesArray
    }
    
}



## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVStorageSystem
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVStorageSystem([string]$Outfile)
{
    $ValuesArray          = @()

    $ListofStorageSystems      = Get-hpovStorageSystem | sort Name


    foreach ($StS in $ListofStorageSystems)
    {

        $hostName            = $Sts.Credentials.ip_hostname
        $Username            = $Sts.Credentials.username
        $DomainName          = $Sts.ManagedDomain
        $Password            = '***Pwd N/A***'

        $StoragePorts        = ""                         
        foreach ($MP in ($Sts.ManagedPorts| sort PortName)) 
        {
            $Port           = $MP.PortName + '=' + $MP.ExpectedNetworkName    # Build Port syntax 0:1:2= VSAN10
            $StoragePorts  += $Port + $SepChar                                # Build StorargePort "0:1:2= VSAN10|0:1:3= VSAN11"

        }

        $StoragePools       = ""
        foreach ($SP in $Sts.ManagedPools)
        {
            $StoragePools += $SP.Name + $SepChar
        }

        # Remove last sepchar
        $StoragePorts  = $StoragePorts -replace ".{1}$"
        $StoragePools  = $StoragePools -replace ".{1}$"


        #                 StorageHostName,StorageAdminName,StorageAdminPassword,StoragePorts,StorageDomainName,StoragePools
        $ValuesArray  += "$hostName,$Username,$Password,$StoragePorts,$DomainName,$StoragePools" + $CR 
    }

    if ($ValuesArray -ne $NULL)
    {
        $a = New-Item $OutFile  -type file -force
        Set-content -Path $OutFile -Value $StSHeader
        add-content -Path $OutFile -value $ValuesArray
    }
    
}



## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVStorageVolumeTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVStorageVolumeTemplate([string]$Outfile)
{
    $ValuesArray                = @()

    $ListofVolTemplates         = Get-hpovStorageVolumeTemplate | sort Name

    
    foreach ($Template in $ListofVolTemplates)
    {
        $name            = $Template.Name
        $description     = $Template.Description

        $SnapSPoolUri    = $Template.SnapShotPoolUri
        $StsUri          = $Template.StorageSystemUri 
  

        $p               = $Template.Provisioning

            $ProvisionType = if ($p.ProvisionType -eq 'Full') { "Thick"}            else {"Thin"}
            $Shared        = if ($p.Shareable)                { 'Yes'  }            else {'No'}
            $Capacity      = if ($p.Capacity)                 { 1/1GB * $p.Capacity } else { 0 }

            $StpUri        = $p.StoragePoolUri
            $PoolName      = "" 
            if ($StpUri)
            {
                $ThisPool  = Get-HPOVStoragePool | where URI -eq $StpUri
                if ($ThisPool)
                    { $PoolName = $ThisPool.Name}
            }   

        if ($SnapSPoolUri)
        {
            $SnapShotPoolName = ""
            $ThisSnapShotPool = get-hpovstoragePool | where uri -eq $SnapSPoolUri
            if ($ThisSnapShotPool)
                { $SnapShotPoolName = $ThisSnapShotPool.Name}
        }

        $StorageSystem = ""

        if ($StsUri)
        {
            $ThisStorageSystem = get-hpovStorageSystem | where Uri -eq $StsUri
            if ($ThisStorageSystem)
            {

                $StorageSystem = $ThisStorageSystem.credentials.ip_hostname
            }
        }
        
        #                 TemplateName,Description,StoragePool,StorageSystem,Capacity,ProvisionningType,Shared,SnapShotStoragePool
        $ValuesArray  += "$Name,$Description,$PoolName,$StorageSystem,$Capacity,$ProvisionType,$Shared,$SnapShotPoolName" + $CR 
    }

    if ($ValuesArray -ne $NULL)
    {
        $a = New-Item $OutFile  -type file -force
        Set-content -Path $OutFile -Value $StVolTemplateHeader 
        add-content -Path $OutFile -value $ValuesArray
    }

}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVStorageVolumeTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVStorageVolume([string]$Outfile)
{
    $ValuesArray                = @()

    $ListofVolumes              = Get-hpovStorageVolume | sort Name

    
    foreach ($Vol in $ListofVolumes)
    {
        $name            = $Vol.Name
        $description     = $Vol.Description

        $StpUri          = $Vol.StoragePoolUri
        $SnapSPoolUri    = $Vol.SnapShotPoolUri
        $StsUri          = $Vol.StorageSystemUri 
  
        $Shared          = if ($Vol.Shareable)                { 'Yes'  }            else {'No'}
        $ProvisionType   = if ($Vol.ProvisionType -eq 'Full') { "Thick"}            else {"Thin"}
        $Capacity        = if ($Vol.provisionedCapacity)                 { 1/1GB * $Vol.provisionedCapacity } else { 0 }


        $PoolName      = "" 
        if ($StpUri)
        {
            $ThisPool  = Get-HPOVStoragePool | where URI -eq $StpUri
            if ($ThisPool)
                { $PoolName = $ThisPool.Name}
        }   

        if ($SnapSPoolUri)
        {
            $SnapShotPoolName = ""
            $ThisSnapShotPool = get-hpovstoragePool | where uri -eq $SnapSPoolUri
            if ($ThisSnapShotPool)
                { $SnapShotPoolName = $ThisSnapShotPool.Name}
        }

        $StorageSystem = ""

        if ($StsUri)
        {
            $ThisStorageSystem = get-hpovStorageSystem | where Uri -eq $StsUri
            if ($ThisStorageSystem)
            {

                $StorageSystem = $ThisStorageSystem.credentials.ip_hostname
            }
        }

        $VolumeTemplate = " **** "
        
        #                 VolumeName,Description,StoragePool,StorageSystem,VolumeTemplate,Capacity,ProvisionningType,Shared
        $ValuesArray  += "$Name,$Description,$PoolName,$StorageSystem,$VolumeTemplate,$Capacity,$ProvisionType,$Shared" + $CR 
    }

    if ($ValuesArray -ne $NULL)
    {
        $a = New-Item $OutFile  -type file -force
        Set-content -Path $OutFile -Value $StVolumeHeader 
        add-content -Path $OutFile -value $ValuesArray
    }

}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Export-OVAddressPool
##
## -------------------------------------------------------------------------------------------------------------

Function Export-OVAddressPool([string]$OutFile)
{


    $ValuesArray                = @()

    $ListofPools              = Get-hpovAddressPool| sort Name

    foreach ($p in $ListofPools)
    {
        
        $PoolType         = $p.PoolType
        $pRangeUris       = $p.rangeUris

        foreach ($rangeuri in $pRangeUris)
        {
            $ThisRange     = Get-HPOVAddressPoolRange | where uri -eq $rangeuri
            $PoolName      = $ThisRange.Name
            $RangeType     = $ThisRange.rangeCategory
            $Category      = $ThisRange.Category
            if ($RangeType -eq "Generated")
            {
                $StartAddress  = $EndAddress = "" 
                
            }
            else 
            {
                $StartAddress  = $ThisRange.StartAddress
                $EndAddress    = $ThisRange.EndAddress
            }
            if ($Category -eq 'id-range-IPV4')
            {
                $ThisSubnet  = Get-HPOVAddressPoolSubnet | where rangeuris -contains $rangeuri
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
            else 
            {
                $NetworkID = $SubnetMask = $Gateway = $ListofDNS = $Domain = ""
            }

            #                PoolName,PoolType,RangeType,StartAddress,EndAddress,NetworkID,SubnetMask,Gateway,DnsServers,DomainName
            $ValuesArray += "$PoolName,$PoolType,$RangeType,$StartAddress,$EndAddress,$NetworkID,$SubnetMask,$gateway,$ListofDNS,$domain" + $CR 
            
        }

    }

    if ($ValuesArray)
    {
        $a = New-Item $OutFile  -type file -force
        Set-content -Path $OutFile -Value $AddressPoolHeader
        add-content -Path $OutFile -value $ValuesArray
    }
}


# -------------------------------------------------------------------------------------------------------------
#
#                  Main Entry
#
#
# -------------------------------------------------------------------------------------------------------------

       # -----------------------------------
       #  Check HPOVVersion
       #Check-HPOVVersion

       # -----------------------------------
       #    Always reload module
   
       #$OneViewModule = $OneViewModule.Split('\')[-1]   # In case we specify a full path to PSM1 file

       $LoadedModule = get-module -listavailable $OneviewModule


       if ($LoadedModule -ne $NULL)
       {
            $LoadedModule = $LoadedModule.Name.Split('.')[0] + "*"
            remove-module $LoadedModule
       }

       import-module $OneViewModule



        # ---------------- Connect to OneView appliance
        #
        write-host -foreground Cyan "$CR Connect to the OneView appliance..."
         Connect-HPOVMgmt -appliance $OVApplianceIP -user $OVAdminName -password $OVAdminPassword  -AuthLoginDomain $OVAuthDomain

       if ($All)
       {

            $OVEthernetNetworksCSV          = "Ethernetnetworks.csv"
            $OVNetworkSetCSV                = "netset.csv"
            $OVFCNetworksCSV                = "FCNetworks.csv"
            
            $OVLogicalInterConnectGroupCSV  = "LogicalInterConnectGroup.csv"
            $OVUplinkSetCSV                 = "UpLinkSet.csv"
            
            $OVEnclosureGroupCSV            = "EnclosureGroup.csv"
            $OVEnclosureCSV                 = "Enclosure.csv"
            $OVServerCSV                    = "Server.csv"

            $OVProfileCSV                   = "Profile.csv"
            $OVProfileTemplateCSV           = "Profiletemplate.csv"
            $OVProfileconnectionCSV         = "Profileconnection.csv"
            $OVProfileLOCALStorageCSV       = "ProfileLOCALStorage.csv"
            $OVProfileSANStorageCSV         = "ProfileSANStorage.csv"

            $OVSanManagerCSV                = "SANManager.csv"
            $OVStorageSystemCSV             = "StorageSystems.csv"
            $OVStorageVolumeTemplateCSV     = "StorageVolumeTemplate.csv"
            $OVStorageVolumeCSV             = "StorageVolume.csv"
            
            $OVAddressPoolCSV               = "AddressPool.CSV"
       }  
        

       # ------------------------------ 

       if (-not [string]::IsNullOrEmpty($OVEthernetNetworksCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting network resources to CSV file --> $OVEthernetNetworksCSV"
            Export-OVNetwork        -OutFile $OVEthernetNetworksCSV 
       }

              if (-not [string]::IsNullOrEmpty($OVNetworkSetCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting network set resources to CSV file --> $OVNetworkSetCSV"
            Export-OVNetworkSet        -OutFile $OVNetworkSetCSV 
       }

       if (-not [string]::IsNullOrEmpty($OVFCNetworksCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting FC network resources to CSV file --> $OVFCNetworksCSV"
            Export-OVFCNetwork      -OutFile $OVFCNetworksCSV 
       }

       if (-not [string]::IsNullOrEmpty($OVSANManagerCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting SAN Manager resources to CSV file --> $OVSANManagerCSV"
            Export-OVSANManager      -OutFile $OVSANManagerCSV 
       }

       if (-not [string]::IsNullOrEmpty($OVStorageSystemCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting Storage System resources to CSV file --> $OVStorageSystemCSV"
            Export-OVStorageSystem      -OutFile $OVStorageSystemCSV 
       }

       if (-not [string]::IsNullOrEmpty($OVStorageVolumeTemplateCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting Storage Volume Templates to CSV file --> $OVStorageVolumeTemplateCSV"
            Export-OVStorageVolumeTemplate      -OutFile $OVStorageVolumeTemplateCSV
       }

       if (-not [string]::IsNullOrEmpty($OVStorageVolumeCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting Storage Volumes to CSV file --> $OVStorageVolumeCSV"
            Export-OVStorageVolume     -OutFile $OVStorageVolumeCSV
       }

       if (-not [string]::IsNullOrEmpty($OVLogicalInterConnectGroupCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting Logical Interconnect Group resources to CSV file --> $OVLogicalInterConnectGroupCSV"
            Export-OVLogicalInterConnectGroup -OutFile $OVLogicalInterConnectGroupCSV 
       }

       if (-not [string]::IsNullOrEmpty($OVUplinkSetCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting UpLinkSet resources to CSV file --> $OVUpLinkSetCSV"
            Export-OVUpLinkSet      -OutFile  $OVUplinkSetCSV
       }

       if (-not [string]::IsNullOrEmpty($OVEnclosureGroupCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting EnclosureGroup resources to CSV file --> $OVEnclosureGroupCSV"
            Export-OVEnclosureGroup -OutFile  $OVEnclosureGroupCSV
       }


       if ($OVEnclosureCSV)
       { 
            write-host -ForegroundColor Cyan "Exporting Enclosure resources to CSV file --> $OVEnclosureCSV"
            Export-OVEnclosure      -OutFile $OVEnclosureCSV
       } 

       if ($OVServerCSV)
       { 
            write-host -ForegroundColor Cyan "Exporting Server resources to CSV file --> $OVServerCSV"
            Export-OVServer      -OutFile $OVServerCSV
       } 

       if (-not [string]::IsNullOrEmpty($OVProfileCSV))
       { 
            if (-not ($OVProfileConnectionCSV))
                { $OVProfileConnectionCSV = "Profileconnection.csv"}

            if (-not ($OVProfileLOCALStorageCSV))
                { $OVProfileLOCALStorageCSV = "ProfileLOCALStorage.csv"}

            if (-not ($OVProfileSANStorageCSV))
                { $OVProfileSANStorageCSV = "ProfileSANStorage.csv"}

            write-host -ForegroundColor Cyan "Exporting Profile --> $OVProfileCSV $CR and ProfileConnection --> $OVProfileConnectionCSV $CR and LOCALStorage --> $OVProfileLOCALStorageCSV  $CR and SANStorage --> $OVProfileSANStorageCSV"
            Export-ProfileorTemplate -CreateProfile       -OutprofileTemplate $OVProfileCSV    -outConnectionfile $OVProfileConnectionCSV  -OutLOCALStorageFile  $OVProfileLOCALStorageCSV -OutSANStorageFile  $OVProfileSANStorageCSV 
      
       }


       if ($OVProfileTemplateCSV)
       { 
            if (-not ($OVProfileConnectionCSV))
                { $OVProfileConnectionCSV = "Profileconnection.csv"}

            if (-not ($OVProfileLOCALStorageCSV))
                { $OVProfileLOCALStorageCSV = "ProfileLOCALStorage.csv"}

            if (-not ($OVProfileSANStorageCSV))
                { $OVProfileSANStorageCSV = "ProfileSANStorage.csv"}

            write-host -ForegroundColor Cyan "Exporting Profile Template --> $OVProfileTemplateCSV $CR and TemplateConnection --> $OVProfileConnectionCSV $CR and LOCALStorage --> $OVProfileLOCALStorageCSV  $CR and SANStorage --> $OVProfileSANStorageCSV"
            Export-ProfileorTemplate        -OutprofileTemplate $OVProfileTemplateCSV    -outConnectionfile $OVProfileConnectionCSV  -OutLOCALStorageFile  $OVProfileLOCALStorageCSV -OutSANStorageFile  $OVProfileSANStorageCSV 
      
     }


       if (-not [string]::IsNullOrEmpty($OVAddressPoolCSV))
       { 
            write-host -ForegroundColor Cyan "Exporting Address Pools to CSV file --> $OVAddressPoolCSV "
            Export-OVAddressPool      -Outfile $OVAddressPoolCSV            
       }
       if (-not [string]::IsNullOrEmpty($OVProfileSANStorageCSV))
       { 
            
           # Export-OVAddressPool      -Outfile $OVProfileSANSCSV            
       }


        write-host -foreground Cyan "$CR Disconnect from the OneView appliance..."
        Disconnect-HPOVMgmt

        write-host -foreground Cyan "--------------------------------------------------------------"
        write-host -foreground Cyan "The script does not export credentials of OneView resources. "
        write-host -foreground Cyan "If applied, review the following files to update credentials: "
        write-host -foreground Cyan "  - SANManager.csv"
        write-host -foreground Cyan "  - StorageSystems.csv"
        write-host -foreground Cyan "  - Enclosure.csv"
        write-host -foreground Cyan "  - Server.csv"
        write-host -foreground Cyan "--------------------------------------------------------------"



