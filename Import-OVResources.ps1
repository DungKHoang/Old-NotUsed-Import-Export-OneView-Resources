## -------------------------------------------------------------------------------------------------------------
##
##
##      Description: Creator functions
##
## DISCLAIMER
## The sample scripts are not supported under any HP standard support program or service.
## The sample scripts are provided AS IS without warranty of any kind. 
## HP further disclaims all implied warranties including, without limitation, any implied 
## warranties of merchantability or of fitness for a particular purpose. 
##
##    
## Scenario
##     	Automate setup of objects in OneView
##		
##
## Input parameters:
##         OVApplianceIP                      = IP address of the OV appliance
##		   OVAdminName                        = Administrator name of the appliance
##         OVAdminPassword                    = Administrator's password
##         OVEthernetNetworksCSV              = path to the CSV file containing Ethernet networks definition
##         OVFCNetworksCSV                    = path to the CSV file containing FC networks definition
##         OVSANManagerCSV                    = path to the CSV file containing SAN Manager definition
##         OVLogicalInterConnectCGroupSV      = path to the CSV file containing Logical Interconnect Group
##         OVUpLinkSetCSV                     = path to the CSV file containing UplinkSet
##         OVEnclosureGroupCSV                = path to the CSV file containing Enclosure Group
##         OVEnclosureCSV                     = path to the CSV file containing Enclosure definition
##         OVLogicalEnclosure                 = path to the CSV file containing Logical Enclosure definition
##         OVProfileConnectionCSV             = path to the CSV file containing Profile Connections definition
##         OVProfileCSV                       = path to the CSV file containing Server Profile definition
##         OVAddressPoolCSV                   = path to the CSV file containing Address Pool definition
##         OVOSDeploymentCSV                  = path to the CSV file containing OS Deployment Server definition
##
## History: 
##         August-15-2014: Update for v1.10
##         Sep-20-2014   : Add Storage management 
##         Feb-27-2015   : Update for v1.20
##         March-2015    : Review HPOV profile creation
##                          - Remove Floppy from Boot Order
##                          - Check for existing profile AND server assigned before creating profile
##                          - NEED to WORK on EUFI 
##
##        January-2016   : Minor corrections - Validate that it works against OneView 2.0
##                         - Add SAN Manager
##                         - Add StorageSystem
##                         - Add Storage Volume Template
##
##        January 2016   : -Fix issues with names of Enclosure Group containing spaces in Create-Enclosure function
##                         - Add logic to handle Server Profile NAme
##                         - Add logic to handle unassigned profile
##                         - Add paramater ForceAdd to fore importing the enclosure
##                         - Update StorageSystem before creating storage profiles
##                         - Validate on DCS 2.0
##
##        March 2016 :     - Remove old code with task.uri in Create-Ethernetnetwokrs create FC networks, create Storage volume and templates 
##                         - Add $global: applianceconnection to save the ApplinaceConnection object
##                         - Remove -ligname old parameter and replace it with -Resource in Create-UpLinkset
##                         - Add Appliance connection param in create StorageVolume Template and Create StorageVolume
##
##       April 2016:       - Add  logic to create/configure NetworkSet. 
##                         - Add logic to handle scenario where a network belongs to multiple network sets
##    
##       May 2016:         - Review Create-HPOVProfile function
##
##      Sep 2016           - Add checking for NULL string in Create-EnclosureGroup
##
##      Oct 2016           - Update to OneView 3.0 and Synergy
##   
##      Dec 2016           - Add Server Profile template
##                         - Add logic for C7000 
##                 
##      May 2017 - v3.01    - Use network objects and nativenetwork objects rather than string in Create-HPOVUplinkset function
##                             to match with changes in library 3.0.1293.3770
##  
##                         - Add AuthLoginDomain to Connect-HPOVMgmt  
##                         -Add routine to check update LIG and uplinkset when adding network to networkset if the latter is already used in server profile 
##
##      June 2017 - v3.1   - Update with changes in library 3.10
##                         - Update routine to add network with SubnetID
##                         - Validate whether SubnetID is already associated with network
##                         - Validate whether ManagedSAN exists before creating FC networks with Managed SAN
##                         - Change in Create-OVVolumeTemplate parameter ProvisionType instead of -Full
##                         - Update Create-OVStorageSystem to include iSCSI storage D9440 for Synergy
##                         - Add ControllerID attribute when creating logical disk controller
##                         - Add function to creaate OS Deployment Server for Synergy
##
##      Jul 2017 - v3.1    - Add Create-OVLogicalEnclosure
##                         - Review Create-OVEnclosureGroup function
##                         - Review Create-OVEnclosure to remove FWiso, change FwInstall and add MonitoredOnly
##                         - Add quotes around names and description for Create-OVAddressPool, Create-OVEnclosureGroup...
##
##      Aug 2017 - v3.1    - Add Try{} and catch {} in get-HPOVNetwork
##                         - Remove addition of quotes around network name
##                         - Fix subnet attached to network
##                         - Add Try{} and catch{} in Connect-HPOVMgmt
##
##      Oct 2017 - v3.1    - Review SANManager, Storagesystem, volume template and volumes functions based on Al Amin feedback
##
##   Version : 3.1
##
##
## -------------------------------------------------------------------------------------------------------------
<#
  .SYNOPSIS
     Import resources to OneView appliance.
  
  .DESCRIPTION
	 Import resources to OneView appliance.
        
  .EXAMPLE

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVEthernetnetworksCSV .\net.csv 
        The script connects to the OneView appliance and exports Ethernet networks to the net.csv file

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVFCnetworksCSV .\fc.csv 
    The script connects to the OneView appliance and exports FC networks to the net.csv file

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 `
        -OVLogicalInterConnectGroupCSV .\lig.csv 
    The script connects to the OneView appliance and exports logical Interconnect group to the lig.csv file

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVUplinkSetCSV .\upl.csv 
    The script connects to the OneView appliance and exports Uplink set to the upl.csv file

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVEnclosureGroupCSV .\EG.csv 
    The script connects to the OneView appliance and exports EnclosureGroup to the EG.csv file

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OVEnclosureCSV .\Enc.csv 
    The script connects to the OneView appliance and exports Enclosure to the Enc.csv file

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1  `
        -OVProfileCSV .\profile.csv -OVProfileConnectionCSV .\connection.csv 
    The script connects to the OneView appliance and exports server profile to the profile.csv and connection.csv files

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1  -All
    The script connects to the OneView appliance and exports all OV resources to a set of pre-defined CSV files.

    .\ Import-OVResources.ps1  -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password P@ssword1 -OneViewmodule HPOneView.110
    The script uses the POSH OneView library v1.10 to connect to the OneView appliance


  .PARAMETER OVApplianceIP                   
    IP address of the OV appliance

  .PARAMETER OVAdminName                     
    Administrator name of the appliance

  .PARAMETER OVAdminPassword                 
    Administrator s password
    
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

  .PARAMETER OVOSDeploymentCSV
    Path to the CSV file containing Deployment Server definition

  .PARAMETER OneViewModule
    Module name for POSH OneView library.

  .PARAMETER OVAuthDomain
    Authentication Domain to login in OneView.
	


  .Notes
    NAME:  Import-OVResources
    LASTEDIT: 01/11/2017
    KEYWORDS: OV  Export
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>
  
## -------------------------------------------------------------------------------------------------------------


Param ( [string]$OVApplianceIP="10.254.13.202", 
        [string]$OVAdminName="Administrator", 
        [string]$OVAdminPassword="P@ssword1",
        [string]$OneViewModule =  "HPONeView.310" ,                                      # D:\OV30-Scripts\posh-hponeview-master\HPOneView.300.psd1",
        [string]$OVAuthDomain  = "local",

        [string]$OVEthernetNetworksCSV ="",                                               #D:\Oneview Scripts\OV-EthernetNetworks.csv",
        [string]$OVFCNetworksCSV ="",                                                     #D:\Oneview Scripts\OV-FCNetworks.csv",
        
        [string]$OVLogicalInterConnectGroupCSV ="",                                       #D:\Oneview Scripts\OV-LogicalInterConnectGroup.csv",
        [string]$OVUpLinkSetCSV ="",                                                        #c:\OV30-Scripts\ex-upl.csv",                                                      
        [string]$OVEnclosureGroupCSV = "" ,                                                 #D:\Oneview Scripts\OV-EnclosureGroup.csv",
        [string]$OVEnclosureCSV ="",                                                      #D:\Oneview Scripts\OV-Enclosure.csv",
        [string]$OVLogicalEnclosureCSV ="",                                                      #D:\Oneview Scripts\OV-LogicalEnclosure.csv",
        
        [string]$OVServerCSV = "",
        
        
        [string]$OVProfileCSV = "" ,                                                        #c:\OV30-Scripts\c7000\c7000-profile.csv" ,                                                      #D:\Oneview Scripts\OV-Profile.csv",
        [string]$OVProfileTemplateCSV = "",                                                 #c:\OV30-Scripts\c7000-export\ProfileTemplate.csv",
        [string]$OVProfileConnectionCSV = "",                                               #"c:\OV30-Scripts\c7000\ProfileConnection.csv",   
        [string]$OVProfileLOCALStorageCSV = "",                                             # "c:\OV30-Scripts\c7000\C7000-ProfileLOCALStorage.csv",  
        [string]$OVProfileSANStorageCSV = "",                                               #c:\OV30-Scripts\c7000\C7000-ProfileSANStorage.csv",

        [string]$OVProfileFROMTemplateCSV = "",
    

        [string]$OVSanManagerCSV ="",                                                     #D:\Oneview Scripts\OV-FCNetworks.csv",
        [string]$OVStorageSystemCSV ="",  
                                                        
        [string]$OVStorageVolumeTemplateCSV= "",                                            #c:\ov30-scripts\synergy\StorageVolumeTemplate.csv",
        [string]$OVStorageVolumeCSV= "",

        [string]$OVAddressPoolCSV = "",

        [string]$OVOSDeploymentCSV  = "",

        [int]$BayStart,
        [int]$BayEnd,

        [string]$sepchar = "|"
)


$DoubleQuote    = '"'
$CRLF           = "`r`n"
$Delimiter      = "\"   # Delimiter for CSV profile file
$Sep            = ";"   # USe for multiple values fields
$SepChar        = '|'
$CRLF           = "`r`n"
$OpenDelim      = "={"
$CloseDelim     = "}" 
$CR             = "`n"
$Comma          = ','
$Equal          = '='


[string]$HPOVMinimumVersion = "3.0.1210.3013"


Function Write-Log ([string]$text, [bool]$time=$true, [string]$ForegroundColor="Green")
{
    $logfolder = "C:\HPCS"
    if(!(test-path "$($logfolder)\Logs")){new-item -path "$($logfolder)" -name Logs -type directory | out-null}
    $logpath = "$($logfolder)\Logs\Install.log"
    $datetime = (get-date).ToString()
    if(!(test-path $logpath)){Out-File -FilePath $logpath -Encoding ASCII -Force -InputObject "Log file created at $datetime"}
	if ($errorCount -ne $error.Count){
        $errorCount = $error.Count - $errorCount        
        0..$($errorCount-1)|%{
			Out-File -FilePath $logpath -Encoding ASCII -Append -InputObject "************ An exception was caught ****************"
            Out-File -FilePath $logpath -Encoding ASCII -Append -InputObject $error[$_]
			Out-File -FilePath $logpath -Encoding ASCII -Append -InputObject "*****************************************************"
            pause;exit
        }
    }
    if($time -eq $true){$output = "$datetime`t$text"}else{$output = "$text"}
    Out-File -FilePath $logpath -Encoding ASCII -Append -InputObject $output
    write-log -ForegroundColor $ForegroundColor -Object $output
}

Function Get-OVTaskError ($Taskresult)
{
        if ($Taskresult.TaskState -eq "Error")
        {
            $ErrorCode     = $Taskresult.TaskErrors.errorCode
            $ErrorMessage  = $Taskresult.TaskErrors.Message
            $TaskStatus    = $Taskresult.TaskStatus

            write-host -foreground Yellow $TaskStatus
            write-host -foreground Yellow "Error Code --> $ErrorCode"
            write-host -foreground Yellow "Error Message --> $ErrorMessage"
        }
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


# **************************************************************
# 
#   IP Helper Functions
#
# **************************************************************
function Get-IPrange
{
<# 
  .SYNOPSIS  
    Get the IP addresses in a range 
  .EXAMPLE 
   Get-IPrange -start 192.168.8.2 -end 192.168.8.20 
  .EXAMPLE 
   Get-IPrange -ip 192.168.8.2 -mask 255.255.255.0 
  .EXAMPLE 
   Get-IPrange -ip 192.168.8.3 -cidr 24 
#> 
 
param 
( 
  [string]$start, 
  [string]$end, 
  [string]$ip, 
  [string]$mask, 
  [int]$cidr 
) 
 
function IP-toINT64 () { 
  param ($ip) 
 
  $octets = $ip.split(".") 
  return [int64]([int64]$octets[0]*16777216 +[int64]$octets[1]*65536 +[int64]$octets[2]*256 +[int64]$octets[3]) 
} 
 
function INT64-toIP() 
{ 
      param ([int64]$int) 

      return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )
} 
 
    if ($ip) {$ipaddr = [Net.IPAddress]::Parse($ip)} 
    if ($cidr) {$maskaddr = [Net.IPAddress]::Parse((INT64-toIP -int ([convert]::ToInt64(("1"*$cidr+"0"*(32-$cidr)),2)))) } 
    if ($mask) {$maskaddr = [Net.IPAddress]::Parse($mask)} 
    if ($ip) {$networkaddr = new-object net.ipaddress ($maskaddr.address -band $ipaddr.address)} 
    if ($ip) {$broadcastaddr = new-object net.ipaddress (([system.net.ipaddress]::parse("255.255.255.255").address -bxor $maskaddr.address -bor $networkaddr.address))} 
 
    if ($ip) 
    { 
      $startaddr = IP-toINT64 -ip $networkaddr.ipaddresstostring 
      $endaddr = IP-toINT64 -ip $broadcastaddr.ipaddresstostring 
    } 
    else { 
      $startaddr = IP-toINT64 -ip $start 
      $endaddr = IP-toINT64 -ip $end 
    } 
 
 
    for ($i = $startaddr; $i -le $endaddr; $i++) 
    { 
      INT64-toIP -int $i 
    }

}


Function ConvertTo-Subnet ([string]$MaskLength)
{
 
    [IPAddress] $ip = 0
    $ip.Address = ([UInt32]::MaxValue -1) -shl (32 - $MaskLength) -shr (32 - $MaskLength)
    return $ip.IPAddressToString
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function AddTo-NetworkSet
##
## -------------------------------------------------------------------------------------------------------------
Function AddTo-NetworkSet {

##
## INternal function to add Networks to NetworkSet
Param   ([string] $ListNetworkSet, [string] $TypicalBandwidth, [string] $MaxBandwidth, [string] $NetworkName,[string]$LIG, [string]$UpLinkSet )


    $NetworkSetL   = $ListNetworkSet 
    $NSTBandwidthL = $TypicalBandwidth
    $NSMBandwidthL = $MaxBandwidth
    
    #------------------ Add to NetworkSet if defined
    # Need NetworkSetL NSTBandwidthL NSMBandwidthL NetworkName
    #
    if ($NetworkSetL)
    {
        write-host -ForegroundColor Cyan "Checking relationship of network $NetworkName with NetworkSet ..."
        $NetworkSetList = $networkSetL.Split($sepChar)
        if ($NSTBandwidthL)
            {$NSTBandwidthList = $NSTBandwidthL.Split($sepChar)}
        if ($NSMBandwidthL)
            {$NSMBandwidthList = $NSMBandwidthL.Split($sepChar)}
    }
    
    foreach ($NetworkSetName in $NetworkSetList)
    {
        $ListofNetworks         = @()
        $ListofUnTaggedNetworks = @()
        
        try 
        {
            $ThisNetwork         = get-hpovnetwork -name $NetworkName -ErrorAction Stop
        }
        Catch [HPOneView.NetworkResourceException]
        {
            $ThisNetwork        = $NULL
        }
      

        if ($NetworkSetName)
        {
            try 
            {
                $ThisNetworkSet = get-HPOVNetworkSet -Name $NetworkSetName -ErrorAction stop
            }
            Catch
            {
                $ThisNetworkSet        = $NULL
            }

            if ($ThisNetworkSet)
            {   # Networkset already exist - Just add the new network

                ### ----------------------------------------------------
                ### Before adding to network set we need to add the new network to UplinkSet if the network set is used in server profile
                ###
                if ($LIG -and $UpLinkSet)
                {
                    $Uplinkset = $uplinkset.Trim()
                    $LIG       = $LIG.Trim()

                    $ThisLIG   = Get-HPOVLogicalInterconnectGroup |where name -eq $LIG
                    if ($ThisLIG)
                    { 
                        write-host -ForegroundColor Cyan "Adding network $NetworkName to UplinkSet $uplinkset...."
                        $ThisULset = $ThisLIG.UplinkSets | where Name -eq $UpLinkSet
                        if ($ThisULSet)
                        {
                            $ThisULSet.networkUris += $ThisNetwork.uri
                        }
                        
                        write-host -ForegroundColor Cyan "Updating Logical Interconnect group $LIG...."
                        Set-HPOVResource $ThisLIG | Wait-HPOVTaskComplete

                        $ThisLI = Get-HPOVLogicalInterconnect | where logicalInterconnectGroupUri -match $ThisLIG.uri
                        if ($ThisLI)
                        { 
                            $ThisLI | Update-HPOVLogicalInterconnect -Confirm:$false | Wait-HPOVTaskComplete
                        }

                    }

                    
                }
                else
                {
                    write-host -ForegroundColor Yellow " WARNING!!! Either Logical Interconnect Group not specified Or Uplinkset not specified..."
                    write-host -ForegroundColor Yellow " Add new network to existing network set may fail if network set is used in profile..."
                    
                }
            

                write-host -ForegroundColor Cyan "Adding $NetworkName to networkset $NetworkSetName ..."
                $ThisNetworkSet.NetworkUris += $ThisNetwork.uri
                if ($ThisNetwork.ethernetNetworkType -eq 'Untagged')
                    { $ThisNetworkSet.NativeNetworkUri += $ThisNetwork.uri }

                Set-HPOVNetworkSet -NetworkSet $ThisNetworkSet  | Wait-HPOVTaskComplete  

            } 
            else # Create NetworkSet first
            {
                write-host -ForegroundColor Cyan "Creating NetworkSet $NetworkSetName first..."
                
                $ndx = [array]::Indexof($NetworkSetList,$NetworkSetName)
                $NSTbwCmd = $NSMbwCmd = ""
                
                if ($NSTBandwidthList)
                {
                    $NSTBandwidth = 1000 * $NSTBandwidthList[$ndx]
                    $NSTbwCmd = "-typicalBandwidth `$NSTBandwidth "
                }
                if ($NSMBandwidthList)
                {
                    $NSMBandwidth = 1000 * $NSMBandwidthList[$ndx]
                    $NSMbwCmd = " -maximumBandwidth `$NSMBandwidth "
                }
                
                $ListofNetworks = $ThisNetwork.Uri
                if ($ThisNetwork.ethernetNetworkType -eq 'Untagged')
                    {$ListofUnTaggedNetworks = $ThisNetwork.Uri}
                
                $NSnetCmd         = " -networks `$ListofNetworks "
                $NSnetUntaggedCmd = " -unTaggedNetwork `$ListofUnTaggedNetworks "

                $NSCmd = "New-HPOVNetworkSet -name `$NetworkSetName $NSTbwCmd $NSMbwCmd $NSnetCmd $NSnetUntaggedCmd"
                $Result = Invoke-Expression $NSCmd
                $ThisNetworkSet = Get-HPOVNetworkSet -name $NetworkSetName

            } 
             
        }
    }
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVEthernetNetworks
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVEthernetNetworks 
{

<#
  .SYNOPSIS
    Configure Networking in OneView
  
  .DESCRIPTION
	Configure Networking in Oneview
        
  .EXAMPLE
    Create-OVEthernetNetworks.ps1  -OVEthernetNetworksCSV c:\Ov-Networks.CSV 



  .PARAMETER OVEthernetNetworksCSV
    Name of the CSV file containing network definition
	

  .Notes
    NAME:  Create-OVEthernetNetworks
    LASTEDIT: 01/13/2016
    KEYWORDS: OV Networks
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
Param ([string]$OVEthernetNetworksCSV ="D:\Oneview Scripts\OV-EthernetNetworks.csv")

    if ( -not (Test-path $OVEthernetNetworksCSV))
    {
        write-host "No file specified or file $OVEthernetNetworksCSV does not exist."
        return
    }
    # Read the CSV Users file
    $tempFile = [IO.Path]::GetTempFileName()
    type $OVEthernetNetworksCSV | where { ($_ -notlike ",,,,,,,,*") -and ($_ -notlike '"*') -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line
    
    $CurrentNetworkSet = ""
    $ListofNetworks    = @()

    $ListofNets    = import-csv $tempfile | Sort NetworkSet
  
    foreach ($N in $ListofNets)
    {
        $NetworkSetL    = $N.NetworkSet
        $NSTBandwidthL  = $N.NSTypicalBandwidth
        $NSMBandwidthL  = $N.NSMaximumBandwidth

        # ---- Used to update LIG and Uplink set if network set is already used in server profile
        $LIG            = $N.LogicalInterConnectGroup
        $ULSet          = $N.UplinkSet




        $NetworkName   = $N.NetworkName
        $vLanID        = $N.vLanID
        $Type          = if ($N.Type) {$N.Type} else {'Ethernet'} 
        $PBandwidth    = 1000 * $N.TypicalBandwidth
        $MBandwidth    = 1000 * $N.MaximumBandwidth
        
        $Purpose       = if ( $N.Purpose) { $N.Purpose} else { 'General'}
 
        $SmartLink     = ($N.SmartLink -like 'Yes')   # $True or $false 

        $PLAN          = ($N.PrivateNetwork -like 'Yes') # $True or $false

        $vLANType      = if ($N.vLANType) {$N.vLANType} else {'Tagged'}

        $SubnetID      = $N.Subnet
        $SubnetIDCmd   = ""

        if ( $SubnetID)
        {
            $ThisSubnetID = get-HPOVAddressPoolSubnet | where networkID -eq $SubnetID
            if ( ($ThisSubnetID) -and (-not ($ThisSubnetID.associatedResources)) ) # SubnetID exists and not associated to any existing network
            {
                $subnetIDCmd = " -subnet `$ThisSubnetID "
               
            }
            else
            {
                write-host -foreground Yellow " SubnetID $SubnetID already associated to another network. Creating network wthout SubnetID...." 
            }

        }

        if ($vLANType -eq 'Tagged')
        {
            if (($vLANID) -and ($vLANID -gt 0))
                { $vLANIDCmd = " -vLanID `$VLANID " }
        }
        else 
        {
            $vLANIDCmd = ""
        }
            
        
        if ($PBandwidth)
            { $PBWCmd = " -typicalBandwidth `$PBandwidth " }

        if ($MBandwidth)
            { $MBWCmd = " -maximumBandwidth `$MBandwidth " }
        

        if ($NetworkName)
        {
            
            try 
            {
                $ThisNetwork = get-HPOVNetwork -Name $NetworkName -ErrorAction stop
            }
            Catch [HPOneView.NetworkResourceException]
            {
                $ThisNetwork   = $NULL
            }
            
            if ($ThisNetwork -eq $NULL)
            {
                # Create network
    
                write-host -foreground Cyan "-------------------------------------------------------------"
                write-host -foreground Cyan "Creating network $NetworkName...."
                write-host -foreground Cyan "-------------------------------------------------------------"

                $Cmds = "New-HPOVNetwork -name `$NetworkName -type `$Type -privateNetwork `$PLAN -smartLink `$SmartLink -VLANType `$VLANType" `
                        + $vLANIDCmd + $pBWCmd + $mBWCmd + $subnetIDCmd + " -purpose `$purpose "            
                
                $ThisNetwork = Invoke-Expression $Cmds 
                        
            }
            else
            {
                write-host -ForegroundColor Yellow "Network $NetworkName already existed, Skip creating it..."
            }

                AddTo-NetworkSet -ListNetworkSet $NetworkSetL -TypicalBandwidth $NSTBandwidthL -MaxBandwidth $NSMBandwidthL -NetworkName $NetworkName -LIG $LIG -uplinkset $ULSet
        } 
        else
        {
                write-host -ForegroundColor Yellow "Network name not specified, Skip creating it..."
        }  


    }


}



## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVFCNetworks
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVFCNetworks {
<#
  .SYNOPSIS
    Configure FC Networking in OneView
  
  .DESCRIPTION
	Configure FC Networking in Oneview
        
  .EXAMPLE
    Create-OVFCNetworks  -OVFCNetworksCSV c:\Ov-FCNetworks.CSV 


  .PARAMETER OVFCNetworksCSV
    Name of the CSV file containing network definition


  .Notes
    NAME:  Create-OVFCNetworks
    LASTEDIT: 02/05/2014
    KEYWORDS: OV FC Networks
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
Param ([string]$OVFCNetworksCSV ="D:\Oneview Scripts\OV-FCNetworks.csv")

    if ( -not (Test-path $OVFCNetworksCSV))
    {
        write-host "No file specified or file $OVFCNetworksCSV does not exist."
        return
    }


    # Read the CSV Users file
    $tempFile = [IO.Path]::GetTempFileName()
    type $OVFCNetworksCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
    $script:ListofFCNets = import-csv $tempfile

    foreach ($N in $script:ListofFCNets)
    {

        $NetworkName     = $N.NetworkName
            if ($NEtworkName -like '* *')    # Contains spaces
            { $NetworkName = '"' + $NetworkName + '"'}
        $Description     = $N.Description
        $FabricType      = $N.FabricType
        $Type            = $N.Type
        $PBandwidth      = 1000 * $N.TypicalBandwidth
        $MBandwidth      = 1000 * $N.MaximumBandwidth
        $LRedistribution = if ( $N.LoginRedistribution -eq 'Manual')  {$False} else {$True}
        $LinkStability   = if ( $N.LinkStabilityTime )  {$N.LinkStabilityTime}   else { 30 }
        $ManagedSAN      = $N.ManagedSAN
        $vLANID          = $N.vLANId



        if ( ($Type -eq 'FCOE') -and ($vLANID -eq $NULL) )
        {
            write-host -foreground YELLOW "TYpe is FCOE but no VLAN specified. Sip creating this network $NetworkName "
        }
        else {
                $FCNetCmds = "New-HPOVNetwork -name $NetworkName  -type $Type -typicalBandwidth $PBandwidth -maximumBandwidth $MBandwidth "

                if ( $Type -eq 'FC')   # Fibre Channel Storage
                {
                    $FCOECmds = ""
                    $FCCmds   = " -FabricType `$FabricType " 
                    if ($FabricType -eq 'FabricAttach')
                        { $FCCmds += " -AutoLoginRedistribution `$LRedistribution -LinkStabilityTime `$LinkStability "}
                }
                else                   # FCOE Storage
                {
                    $FCOECmds = " -vLANID `$VLANID "
                    $FCcmds   = ""
                }

                $FCNetCmds += $FCOECmds + $FCcmds

                ##  Managed SAN section

                if ($ManagedSAN)
                {
                    $ThisManagedSAN = Get-HPOVManagedSAN | where name -eq $ManagedSAN
                    if ($ThisManagedSAN)
                    {
                        $FCNetCmds += " -ManagedSAN $ManagedSAN "
                    }

            
                }

                try 
                {
                    $ThisNetwork = get-HPOVNetwork -Name $NetworkName -ErrorAction stop
                }
                Catch [HPOneView.NetworkResourceException]
                {
                    $ThisNetwork   = $NULL
                }
                
                if ($ThisNetwork -eq $NULL)
                {
                    # Create network
                    write-host -foreground Cyan "-------------------------------------------------------------"
                    write-host -foreground Cyan "Creating FC network $NetworkName...."
                    write-host -foreground Cyan "-------------------------------------------------------------"


                    Invoke-Expression $FCNetCmds 

                }
                else
                {
                    write-host -ForegroundColor Yellow "Network $NetworkName already existed, Skip creating it..."
                }           
        }



    }

}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-LogicalInterConnectGroup
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVLogicalInterConnectGroup {
<#
  .SYNOPSIS
    Configure Logical Interconnect Group in OneView
  
  .DESCRIPTION
	Configure Logical Interconnect Group in Oneview
        
  .EXAMPLE
    Create-OVLogicalInterConnectGroup  -OVLogicalInterConnectGroupCSV c:\OV-LogicalInterconnectGroup.CSV 


  .PARAMETER OVLogicalInterConnectGroupCSV
    Name of the CSV file containing network definition
	


  .Notes
    NAME:  Create-OVLogicalInterConnectGroup
    LASTEDIT: 02/05/2014
    KEYWORDS: OV LogicalInterConnectGroup
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
Param ([string]$OVLogicalInterConnectGroupCSV ="D:\Oneview Scripts\OV-LogicalInterConnectGroup.csv")

#------------------- Interconnect Types
$ICModuleTypes = $ListofICTypes           = @{
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



    if ( -not (Test-path $OVLogicalInterConnectGroupCSV))
    {
        write-host "No file specified or file $OVLogicalInterConnectGroupCSV does not exist."
        return
    }



    # Read the CSV Users file
    $tempFile = [IO.Path]::GetTempFileName()
    type $OVLogicalInterConnectGroupCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
    $ListofLGs = import-csv $tempfile

    foreach ($L in $ListofLGs)
    {
        $LGName      = $L.LIGName
        $FrameCount  = $L.FrameCount
        $ICBaySet    = $L.InterConnectBaySet
        $ConfigType  = $L.InterConnectType
        # ----- InterConnect Module and Bay Set
        $ICType      = ""
        if ($ConfigType)
        {
            $IC     = $ConfigType -replace " ", ""
            $ICType = $FabricModuleTypes[$IC]



        }


        $Bays        = @{}
        $Frames      = @{}
        
        if ($L.BayConfig)
        {
            # Split multiple lines
            $BayConfigList   = $L.BayConfig.Split($CRLF,[System.StringSplitOptions]::RemoveEmptyEntries)
           
            # Process configs per frame
            if ($ConfigType -eq '')  # If empty --> C7000
            {   # With 1 frame, we expect the syntax:  1='VC10'| 2='VC10'.... no Frame 
                $BayConfigList = $BayConfigList.Split($SepChar) 
                foreach($Config in $BayconfigList)
                {
                    
                    $Key,$Value= $Config.Split('=') 
                    $Key =[int32]$Key
                    if (-not $Value)
                        { $Value =""}

                    $Bays.Add($Key,$Value) 
                }

                #----- For C7000 Bays = Frames as there is only 1 frame
                $Frames = $Bays

                # -----------------------------------
                #  Parameters that are valid for C7000 only
                
                # Add FastMacCache parameters
                #
                $FastMacCacheParam = "" 
                if ( $L.FastMacCacheFailover -like 'Yes')
                {
            
                    if ($L.MacRefreshInterval)
                        { $FastMacCacheIntervalParam = " -macRefreshInterval $($L.MacReFreshInterval) " }
                    else
                        { $FastMacCacheIntervalParam = ""}

                    $FastMacCacheParam = " -enableFastMacCacheFailover `$True "+ $FastMacCacheIntervalParam
                }

                # Add PauseFloodProtection parameter
                #
                if ($L.PauseFloodProtection -like 'No')
                    { $PauseFloodProtectionParam = " -enablePauseFloodProtection `$False " }
                else
                    { $PauseFloodProtectionParam = "" }

                # -------
                $RedundancyParam       = ""
                $FabricModuleTypeParam = ""
                $FrameCountParam       = $ICBaySetParam = ""

            }
            else # Multi Frames scenarios
            {
                    foreach ($Lconfig in $BayConfigList)
                    {
                        $Bays              = @{}
                        $OneFrame, $Config = $LConfig.Split('{')

                        # Store Bay COnfigs
                        $Config        = $Config -replace " ", ""  # Remove blank space
                        $Config        = $Config -replace ".{1}$"  # Replace closing bracket '}'
                        $BayLists      = $Config.Split( $SepChar)
                        foreach ($BayConfig in $BayLists)
                        {
                            $Key,$Value= $BayConfig.Split('=') 
                            $Value = $ICModuleTypes[$Value]
                            

                            if (-not $Value)
                                { $Value =""}
                            $Bays.Add($Key,$Value) 
                        }

                        # Process frame
                        $OneFrame = $OneFrame -replace " ", "" # Remove blank space
                        $Key = $OneFrame -replace ".{1}$"  # Replace '='
                        $Value = $Bays

                        $Frames.Add($Key,$Value)
                    }

                    # Parameters that are valid to SynergY multi-frames
                    # Add Redundnacy parameters
                    #        
                    $RedundancyParam = ""
                    if ($FrameCount -eq 3) 
                        {$L.Redundancy = "HighlyAvailable"}

                    if ($L.Redundancy)
                    {
                        $RedundancyParam = " -FabricRedundancy $($L.Redundancy) "
                    } 
                    

                    $FabricModuleTypeParam = " -FabricModuleType $ICType " 
                    $FrameCountParam       = " -FrameCount $FrameCount "
                    $ICBaySetParam         = " -InterConnectBaySet $ICBaySet "


                    # Parameters that are valid to C7000  only   ---> Nullify here
                    $FastMacCacheParam = $PauseFloodProtectionParam =  "" 
            }
        }




            


        # Add Igmp parameters
        #        
        if ($L.IGMPSnooping -like 'Yes') 
        { 

            if ($L.IGMPIdletimeOut)
                { $IGMPIdleTimeoutParam = " -IgmpIdleTimeOutInterval $($L.IgmpIdleTimeout) " }
            else
                { $IGMPIdleTimeoutParam = ""}


            $IgmpCmds = "-enableIGMP `$True "+ $IGMPIdleTimeoutParam                  
        }
        else
        {   $IgmpParam = "" }




        # Add NetworkLoopProtection parameter
        #
        if ($L.NetworkLoopProtection -like 'No')
            { $NetworkLoopProtectionParam = " -enableNetworkLoopProtection `$False " }
        else
            { $NetworkLoopProtectionParam = "" }



        # Add EnhancedLLDPTLV parameter
        #
        if ($L.EnhancedLLDPTLV -like 'No')
            { $EnhancedLLDPTLVParam = " -enableEnhancedLLDPTLV `$False " }
        else
            { $EnhancedLLDPTLVParam = " -enableEnhancedLLDPTLV `$True " }



        # Add EnableLLDPTagging parameter
        #
        if ($L.LDPTagging -like 'No')
            { $LDPTaggingParam = " -EnableLLDPTagging `$False " }
        else
            { $LDPTaggingParam = " -EnableLLDPTagging `$True " }


        $LGExisted =  Get-HPOVLogicalInterConnectGroup | where Name -like $LGName
        if ($LGExisted -eq $NULL)
        {
            # Create Logical InterConnect

           
            
            write-host -foreground Cyan "-------------------------------------------------------------"
            write-host -foreground Cyan "Creating Logical InterConnect Group $LGName...."
            write-host -foreground Cyan "-------------------------------------------------------------"

            $Cmds = "New-HPOVLogicalInterConnectGroup -name `$LGName  " + " -Bays `$Frames " + `
                    $FabricModuleTypeParam + $RedundancyParam + $FrameCountParam + $ICBaySetParam  + `          # Those are for Synergy only                 
                    $IgmpParam + $FastMacCacheParam + $NetworkLoopProtectionParam + $PauseFloodProtectionParam + `
                    $EnhancedLLDPTLVParam + $LDPTaggingParam

            Invoke-Expression $Cmds 
            


        }
        else
        {
            write-host -ForegroundColor Yellow "Logical InterConnect $LGName already existed, Skip creating it..."
        }


    }

}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVUpLinkSet
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVUpLinkSet {
<#
  .SYNOPSIS
    Configure UpLinkSet in OneView
  
  .DESCRIPTION
	Configure UpLinkSetin Oneview
        
  .EXAMPLE
    .\Create-OVUpLinkSet  -OVUpLinkSetCSV c:\OV-UpLinkSet.CSV 


  .PARAMETER OVUpLinkSetCSV
    Name of the CSV file containing UpLink Set definition
	


  .Notes
    NAME:  Create-OVUpLinkSet
    LASTEDIT: 10/24/2016
    KEYWORDS: OV UpLinkSet
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
Param ([string]$OVUpLinkSetCSV ="D:\Oneview Scripts\OV-UpLinkSet.csv")


        if ( -not (Test-path $OVUpLinkSetCSV))
        {
            write-host "No file specified or file $OVUpLinkSetCSV does not exist."
            return
        }


        # Read the CSV Users file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVUpLinkSetCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
        $ListofUpLinks = import-csv $tempfile

        foreach ($UL in $ListofUpLinks)
        {
            $LGName                   = $UL.LIGName

            $UpLinKSetName            = $UL.UpLinkSetName
            $UpLinkSetType            = $UL.UpLinkType
         
            $UpLinkSetPorts           = if ($UL.UplinkPorts) { ($UL.UpLinkPorts.Split($SepChar)).Trim() }
    
            $UpLinkSetNetworks        = if ( $UL.Networks) { ($UL.Networks.Split($SepChar)).Trim()}
                   
            
            $UpLinkSetNativeNetwork   = if ( $UL.NativeEthernetNetwork) { $UL.NativeEthernetNetwork.Trim()}
            $UpLinkSetEthMode         = if ($UL.EthernetMode) {$UL.EthernetMode.Trim()} else { 'Auto'} 
            $UpLinkSetLACPTimer       = if ($UL.LACPTimer) {$UL.LACPTimer.Trim()} else {'Short'}
            $UplinkSetPrimaryPort     = $UL.PrimaryPort

            $UpLinkSetFCSpeed         = $UL.FCuplinkSpeed

            
            if ($UpLinkSetNativeNetwork) 
            {
                if (!($UpLinkSetNetworks -contains $UpLinkSetNativeNetwork))
                {
                    write-host -ForegroundColor Yellow " Native network specified --> $UpLinkSetNativeNetwork is not member of list of networks $UpLinkSetNetworks"
                    write-host -ForegroundColor Yellow "Ignoring Native network"
                    $UpLinkSetNativeNetwork    = ""
                    $UpLinkSetNativeNetworkObj = $NULL
                }
                else 
                {
                    $UpLinkSetNativeNetworkObj = Get-HPOVNetwork -name $UpLinkSetNativeNetwork    
                }
            }

            ## Get network objects rather than string
            $UpLinkSetNetworksArray  = @()
            Foreach ($net in $UpLinkSetNetworks)
            {
                
                try 
                {
                    $netmember = Get-HPOVNetwork -name $net -ErrorAction stop
                }
                Catch [HPOneView.NetworkResourceException]
                {
                    $netmember = $NULL
                }
                if ($netmember)
                    { $UpLinkSetNetworksArray += $netmember}
            }

        
            $LGExisted = $ThisLIG =  Get-HPOVLogicalInterConnectGroup | where Name -eq $LGName
            if ($LGExisted -ne $NULL)
            {
                ## Check for existing uplinksets
                $UplinkSets = $ThisLIG.UpLinkSets
                $ULArray    = @()
                foreach ($uplink in $UpLinkSets)
                {
                    $ULArray += $uplink.name
                }

                $UpLinkSetName = $UpLinKSetName.trim()
                if ($ULArray -contains $UplinkSetName)
                {
                    write-host -ForegroundColor YELLOW "Uplink Set $UplinkSetname already existed in LIG --> $LGName"
                }
                else 
                {
                    switch ($UpLinkSetType)
                        {
                            'Ethernet'      { if (($UpLinkSetEthMode -ne ' Auto') -and ($UpLinkSetLACPTimer))
                                                { 
                                                    $NetPropertyCmds = " -EthMode $UpLinkSetEthMode "
                                                    if ($UplinkSetPrimaryPort)
                                                        { $NetPropertyCmds += " -PrimaryPort $UplinkSetPrimaryPort " }
                                                }
                                            else 
                                                { $NetPropertyCmds = " -EthMode $UpLinkSetEthMode -LacpTimer $UpLinkSetLACPTimer " }

                                            if ( $UpLinkSetNativeNetwork)
                                                {$NetPropertyCmds  += " -NativeEthNetwork `$UpLinkSetNativeNetworkObj "}
                                            }

                            'FibreChannel'  { if ( !($UplinkSetFCSpeed) -or !( @(2,4,8) -contains $UplinkSetFCSpeed ))  
                                                { $UplinkSetFCSpeed = 'Auto'}
                                            $NetPropertyCmds = " -fcUplinkSpeed $UplinkSetFCSpeed "
                                            }

                            default         { $NetPropertyCmds = "" }
                        }






                    write-host -foreground Cyan "-------------------------------------------------------------"
                    write-host -foreground Cyan "Creating UpLinkSet $UpLinKSetName on LIG $LGName...."
                    write-host -foreground Cyan "-------------------------------------------------------------"
                    
                    if ($UpLinkSetNetworksArray)
                    {
                        $ULNetworkCmds = " -Networks `$UpLinkSetNetworksArray  "
                    } 
                    else
                    {
                        $ULNetworkCmds = ""
                        write-host -foreground YELLOW " Network list is empty. UplinkSet is created without network..."
                        
                    }

                    if ($UpLinkSetPorts)
                    {
                        $ULPortCmds = " -UplinkPorts `$UpLinkSetPorts  "
                    } 
                    else
                    {
                        $ULPortCmds = ""
                        write-host -foreground YELLOW " Uplink Ports list is empty. UplinkSet is created without uplink ports..."
                       
                    }
                   
                    $Cmds = "New-HPOVUplinkSet -Resource `$ThisLIG -name `$UpLinkSetName -Type `$UpLinkSetType   " `
                            + $ULNetworkCmds + $ULPortCmds + $NetPropertyCmds                
                    Invoke-Expression $Cmds | wait-HPOVTaskComplete | fl
                }

                


            }
            else
            {
                write-host -ForegroundColor Yellow "Logical InterConnect Group $LGName not existed, Please create it first..."
            }


        }
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVEnclosureGroup
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVEnclosureGroup {
<#
  .SYNOPSIS
    Configure Enclosure Group in OneView
  
  .DESCRIPTION
	Configure Enclosure Group in Oneview
        
  .EXAMPLE
    .\Create-OVEnclosureGroup  -OVEnclosureGroupCSV c:\OV-EnclosureGroup.CSV 


  .PARAMETER OVEnclosureGroupCSV
    Name of the CSV file containing Enclosure Group definition
	

  .Notes
    NAME:  Create-OVEnclosureGroup
    LASTEDIT: 02/05/2014
    KEYWORDS: OV EnclosureGroup
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
Param ( [string]$OVEnclosureGroupCSV ="D:\Oneview Scripts\OV-EnclosureGroup.csv")



        if ( -not (Test-path $OVEnclosureGroupCSV))
        {
            write-host "No file specified or file $OVEnclosureGroupCSV does not exist."
            return
        }


        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVEnclosureGroupCSV | where { ($_ -notlike ",,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
        $ListofEnclosureGroup = import-csv $tempfile

        foreach ($EG in $ListofEnclosureGroup)
        {
            $EGName              = $EG.EnclosureGroupName 
            $EGDescription       = $EG.Description
            $EGEnclosureCount    = $EG.Enclosurecount
            $EGipv4Type          = if ($EG.IPv4AddressType) { $EG.IPv4AddressType } else {"DHCP"} 
            $EGAddressPool       = $EG.AddressPool

            $EGDeployMode        = $EG.DeploymentNetworkType
            $EGDeployNetwork     = $EG.DeploymentNetwork

            $EGPowerMode         = $EG.PowerRedundantMode

            $EGLIGMapping        = $EG.LogicalInterConnectGroupMapping
            
          

            if ( $EGName)
            {

#region LIG Mapping               
                $LIGHash        = @{}
                if ($EGLIGMapping)
                {
                    $LIGList         = $EGLIGMapping.Split($SepChar)

                    foreach($Config in $LIGList)
                    {    
                        if ($Config -like "*=*")
                        {      
                            $Key,$LIGName= $Config.Split($Equal)
                            $Key =  $Key.Trim()
                            
                            $LIGName = $LIGName.Trim() 
                            
                            # Check LIG existence
                        
                            if ( $LIGName)
                            {
                                $LIGNameArray = $LiGName.Split($Sep)
          
                                $LIGObjArray  = @()
                                
                                foreach ($LName in $LIGNameArray)
                                {
                                    if ($LName)
                                    {
                                        $ThisLIG = Get-HPOVLogicalInterConnectGroup | where name -eq $LName
                                                        
                                        if ($ThisLIG)
                                        {
                                        $LIGObjArray  += $ThisLIG 
                                        
                                        }
                                        else
                                        {
                                            write-host -ForegroundColor Yellow "Logical InterConnect Group $LName does not exist. Skip including it...." 
                                        }
                                    }
                                }
                           
                                if ($Key -match '^\d')                 # Validate whether LIGmapping is for C7000 1=Flex-10,2= Flex10....
                                {
                                    $Key = [int32]$Key
                                    $LIGObj = $LIGObjArray[0]
                                }
                                else  # This is for Synergy  @{FRame1=$LIG1,$SALig; Frame2=$LIG2,$SASLig}
                                { 
                                    $LIGOBj  =$LIGObjArray
                                }
                                $LIGHash.Add($Key,$LIGObj)

                            }
                            else
                            {
                                write-host -ForegroundColor Yellow "Logical InterConnect Group $LIGName is not specified. Skip including it...." 
                            }
                        }
                        else  # Only 1 LIG
                        {
                            $LIGHash = Get-HPOVLogicalInterConnectGroup -name $Config
                        }
                        
              
                    }

                    $LIGMappingParam = " -LogicalInterconnectGroupMapping `$LIGHash  "   
                }
                else # LIGMapping is NULL
                {
                    write-host -ForegroundColor Yellow "No Logical Interconnect Group Mapping. Skip creating it..."
                    $LIGMappingParam = ""
                }


#endregion LIG Mapping
  
                

                $DescParam      = if ($Description) { " -Description $EGDescription " } else {""} 


#region Synergy specific parameters
                if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
                {
                    $Skip = $false
                    $EGipv4Type = if ($EGipv4Type -eq 'ipPool') { 'AddressPool'} else {$EGipv4Type}
                    $ipv4AddressPoolParam = " -IPv4AddressType $EGipv4Type "
                    if  ($EGipv4Type -eq 'AddressPool')  
                    {
                        $AddressPool = Get-HPOVAddressPoolRange -type 'IPv4' | where name -eq $EGAddressPool
                        if ($AddressPool)
                        {
                            $ipv4AddressPoolParam += " -AddressPool `$AddressPool"
                        }
                        else 
                        {
                            write-host -ForegroundColor Yellow "IP Address Type is set to $EGipv4Type but there is no address pool named $EGAddressPool . SKip creating Enclosure Group $EGName"
                            $Skip = $True    
                            
                        }

                    }

                    $PowerModeParam = if ($PowerMode) { " -PowerRedundantMode $PowerMode " } else { ""} 

                    if ($EGEnclosureCount) 
                        { $EGEnclosureCount = [int32]$EGEnclosureCount } 
                    else { $EGEnclosureCount =  1 }

                    $EncCountParam  = " -EnclosureCount $EGEnclosureCount "

                }
                else 
                {   # C7000
                    $Skip = $false
                    $ipv4AddressPoolParam = ""
                    $EncCountParam = $PowerModeParam =  ""

                }


#endregion Synergy specific parameters

                if (-not $Skip)
                {
                    $Cmds = "New-HPOVEnclosureGroup -name $EGName $DescParam $EncCountParam $PowerModeParam $LiGMappingParam  $ipv4AddressPoolParam "

                    $EncGroupExisted =  Get-HPOVEnclosureGroup | where name  -eq $EGName 

                    if (-not $EncGroupExisted )
                    {
                        # Create Enclosure Group

                        write-host -foreground Cyan "-------------------------------------------------------------"
                        write-host -foreground Cyan "Creating Enclosure Group $EGName ...."
                        write-host -foreground Cyan "-------------------------------------------------------------"
            
                        $ThisEG = Invoke-Expression $Cmds 


                        # There is no task uri to check for error
                    }
                    else
                    {
                        write-host -ForegroundColor Yellow "EnclosureGroup $EGName already existed, Skip creating it..."
                    }   
                }



            } # endif $EGName

            else
            {
                    write-host -ForegroundColor Yellow "Enclosure Group Name is empty.Please provide a name..."
            }  
              

        }
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVEnclosure
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVEnclosure {
<#
  .SYNOPSIS
    Import Enclosure in OneView
  
  .DESCRIPTION
	Import Enclosure in Oneview
        
  .EXAMPLE
    .\Create-OVEnclosure  -OVEnclosureCSV c:\OV-Enclosure.CSV  


  .PARAMETER OVEnclosureCSV
    Name of the CSV file containing Enclosure  definition
	


  .Notes
    NAME:  Create-OVEnclosure
    LASTEDIT: 02/05/2014
    KEYWORDS: OV Enclosure
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
Param ( [string]$OVEnclosureCSV ="D:\Oneview Scripts\OV-Enclosure.csv")


        if ( -not (Test-path $OVEnclosureCSV))
        {
            write-host "No file specified or file $OVEnclosureCSV does not exist."
            return
        }


        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVEnclosureCSV | where { ($_ -notlike ",,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
        $ListofEnclosure = import-csv $tempfile

        foreach ($Encl in $ListofEnclosure)
        {
            $OAIP              = $Encl.OAIPAddress
            $OAADminName       = $Encl.OAADminName 
            $OAADminPassword   = $Encl.OAADminPassword

            $EnclGroupName     = $Encl.EnclosureGroupName
            $Licensing         = $Encl.LicensingIntent
            $FWBaseline        = $Encl.FWBaseline

            $FWForceInstallCmd = if ($Encl.FwInstall -eq 'Yes') { " -ForceInstallFirmware " } else { "" }
            $ForceAddCmd       = if (!($Encl.ForceAdd) -or ($Encl.ForceAdd -ieq 'Yes')){ " -Confirm:`$true "} else {" -Confirm:`$false "}

            $MonitoredCmd      = if ($Encl.MonitoredOnly -eq "Yes") {" -Monitored "} else { ""}

            ## TBD - to validate Licensing intent

            if ( -not ( [string]::IsNullOrEmpty($OAIP) -or [string]::IsNullOrEmpty($OAAdminName) -or [string]::IsNullOrEmpty($OAAdminPassword)`
                       -or [string]::IsNullOrEmpty($EnclGroupName) -or [string]::IsNullOrEmpty($Licensing)))

                         
            {
                ## TBD _ Validate whether we can ping OA?

                $FWCmds = ""
                if ( -not ([string]::IsNullOrEmpty($FWBaseLine)))
                {
                    $FWCmds = " -fwBaselineIsoFilename `$FWBaseLine  $FWForceInstallCmd "
                }
                $EnclGroupName = "`'$EnclGroupName`'"
                $Cmds = "New-HPOVEnclosure -applianceConnection `$global:ApplianceConnection -oa $OAIP -username $OAAdminName -password $OAAdminPassword -enclGroupName $EnclGroupName -license $Licensing $FWCmds $ForceAddCmd $MonitoredCmd"
 
                $EncExisted =  Get-HPOVEnclosure | where {($_.activeOaPreferredIP -eq $OAIP ) -or ($_.standbyOaPreferredIP -eq $OAIP )}
            

                if ($EncExisted -eq $NULL)
                {

                    write-host -foreground Cyan "-------------------------------------------------------------"
                    write-host -foreground Cyan "Importing Enclosure $OAIP ...."
                    write-host -foreground Cyan "-------------------------------------------------------------"
            
                    
                  Invoke-Expression $Cmds | wait-HPOVTaskComplete

                }
                else
                {
                    write-host -ForegroundColor Yellow "Enclosure $OAIP already existed, Skip creating it..."
                }



            }
            
            else
            {
                    write-host -ForegroundColor Yellow "The following information is not correct `n `
                        Value: OAIP --> $OAIP --- OA Name is empty or OA credentials not provided `n `
                        or Value: Enclosure Group --> $EnclGroupName  ---  Enclosure Group Name is empty `n`
                        or Value: License --> $Licensing --- Licensing Intent is not specified as OneView or OneViewNoiLO `n `
                        Please provide correct information and re-run the script again."
            }   
        }

}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVLogicalEnclosure
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVLogicalEnclosure {
<#
  .SYNOPSIS
    Create Logical Enclosure in OneView
  
  .DESCRIPTION
	Create Logical Enclosure in Oneview
        
  .EXAMPLE
    .\Import-OVResources.ps1  -OVLogicalEnclosureCSV c:\LogicalEnclosure.CSV  


  .PARAMETER OVLogicalEnclosureCSV
    Name of the CSV file containing Logical Enclosure  definition
	


  .Notes
    NAME:  Create-OVLogicalEnclosure
    LASTEDIT: 07/25/2017
    KEYWORDS: OV Logical Enclosure
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
Param ( [string]$OVLogicalEnclosureCSV ="D:\Oneview Scripts\OV-LogicalEnclosure.csv")

        if ( -not (Test-path $OVLogicalEnclosureCSV))
        {
            write-host "No file specified or file $OVLogicalEnclosureCSV does not exist."
            return
        }


        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVLogicalEnclosureCSV | where { ($_ -notlike ",,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
        $ListofLogicalEnclosure = import-csv $tempfile

        foreach ($LE in $ListofLogicalEnclosure)
        {
            $Name           = $LE.LogicalEnclosureName
            $EnclName       = $LE.Enclosure
            $EncGroup       = $LE.EnclosureGroup
            $FWBaseline     = $LE.FWBaseline
            $FWInstall      = if ($FWBaseline) { $LE.FWInstall -eq 'Yes'} else {$False} 
            #$ForceAdd       = $LE.ForceAdd -eq 'Yes'

            if ($EnclName)
            {
                $EnclosureArray = $EnclName.Split($Sep)
                $ThisEnclosure  = Get-HPOVEnclosure | where name -eq $EnclosureArray[0]
                if ($ThisEnclosure)
                {
                    if ($EncGroup)
                    {
                        
                        $ThisEnclosureGroup = Get-HPOVEnclosureGroup | where  Name -eq $EncGroup
                        if ($ThisEnclosureGroup)
                        {
                            $FWCmds = ""
                            if ($FWBaseline)
                            {
                                $ThisFWBaseline = Get-HPOVBaseline -file $FWBaseline
                                if ( $ThisFWBaseline)
                                {
                                    $FWCmds = " -FirmwareBaseline `$ThisFWBaseLine  "
                                    if ($FWInstall)
                                    { $FWCmds += " -ForceFirmwareBaseline "}
                                }
                            }
                            else
                            {
                                write-host -ForegroundColor Yellow "FW BaseLine not specified. Will not include FW Base line in Logical Enclosure..."           
                            }
                                 
                            $ThisLogicalEnclosure = Get-HPOVLogicalEnclosure  | where name -eq $Name 
                            if ($ThisLogicalEnclosure -eq $NULL)
                            {   
                                $Cmds  = "New-HPOVLogicalEnclosure -name $Name -Enclosure `$ThisEnclosure -EnclosureGroup `$ThisEnclosureGroup "
                                $Cmds += $FWCmds
                                
                                write-host -foreground Cyan "-------------------------------------------------------------"
                                write-host -foreground Cyan "Creating Logical Enclosure for enclosure $EnclName ...."
                                write-host -foreground Cyan "-------------------------------------------------------------"                   
                                Invoke-Expression $Cmds 
                            }
                            else
                            {
                                write-host -ForegroundColor Yellow "Logical Enclosure $Name already exists. Skip creating Logical Enclosure..."           
                            }
                        }
                        else
                        {
                            write-host -ForegroundColor Yellow "Enclosure Group $EncGroup does not exist, Skip creating logical enclosure..."           
                        }
                    }
                    else 
                    {
                        write-host -ForegroundColor Yellow "Enclosure Group name is empty, Skip creating logical enclosure..."        
                    }
                }
                else
                {
                    write-host -ForegroundColor Yellow "Enclosure $EnclName does not exist, Skip creating logical enclosure..."    
                }
            }
            else 
            {
                write-host -ForegroundColor Yellow "Enclosure name is empty. Skip creating logical enclosure ..."
            }
        }



}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVServer
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVServer {
<#
  .SYNOPSIS
    Import Server Hardware in OneView
  
  .DESCRIPTION
	Import Server Hardware in Oneview
        
  .EXAMPLE
    .\Import-OVResources.ps1  -OVServerCSV c:\OVServer.CSV  


  .PARAMETER OVEnclosureCSV
    Name of the CSV file containing Server Hardware definition
	


  .Notes
    NAME:  Import Server Hardware
    LASTEDIT: 01/10/2017
    KEYWORDS: OV Server
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>
Param ( [string]$OVServerCSV ="D:\Oneview Scripts\OV-Server.csv")


        if ( -not (Test-path $OVServerCSV))
        {
            write-host "No file specified or file $OVServerCSV does not exist."
            return
        }


        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVServerCSV | where { ($_ -notlike ",,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
        $ListofServers = import-csv $tempfile

        foreach ($s in $ListofServers)
        {
            $Server             = $s.ServerName
            if ($Server)
            {
                $ThisServer = Get-HPOVServer | where name -eq $server
                if (-not $ThisServer)
                {
                    $ADminName          = $s.AdminName 
                    $ADminPassword      = $s.AdminPassword
                    $Licensing          = $s.LicensingIntent
                    $IsMonitored        = ($s.Monitored -eq 'Yes') -or ($Licensing -eq "")
                    
                
                    write-host -foreground Cyan "----------------------------------------------------------"
                    write-host -foreground Cyan " Add Server $Server to OneView Appliance"
                    write-host -foreground Cyan "----------------------------------------------------------" 

                    if ($IsMonitored)
                    {
                        Add-HPOVServer -Hostname $server -Username $AdminName -Password $AdminPassword -Monitored| Wait-HPOVTaskComplete | FL
                    }
                    else 
                    {
                    Add-HPOVServer -Hostname $server -Username $AdminName -Password $AdminPassword -LicensingIntent $Licensing | Wait-HPOVTaskComplete | FL  
                    }
                }
                else
                {
                    write-host -foreground YELLOW " Server $server already present in OneView. Skip adding server"
                }


            }
            else 
            {
                write-host -foreground YELLOW " Server name or IP address not provided. Skip adding server"
            }
        }
            
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVProfileConnection
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVProfileConnection {
<#
  .SYNOPSIS
    Create ProfileConnection in OneView
  
  .DESCRIPTION
	Create ProfileConnection in OneView and return a hash table of Server ProfileName and connection list
        
  .EXAMPLE
    .\Create-OVProfileConnection  -OVProfileConnectionCSV c:\OV-ProfileConnection.CSV 
    


  .PARAMETER OVProfileConnectionCSV
    Name of the CSV file containing Server Profile Connection definition
	


  .Notes
    NAME:  Create-OVProfileConnection
    LASTEDIT: 05/20/2014
    KEYWORDS: OV Profile Connection
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
 Param ( [string]$ProfileConnectionCSV ="D:\Oneview Scripts\OV-ProfileConnection.csv", [string]$ProfileName="")

         if ( -not (Test-path $ProfileConnectionCSV))
        {
            write-host "No file specified or file $ProfileConnectionCSV does not exist."
            return
        }


        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $ProfileConnectionCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

        $ConnectionList = @()     # List of Connections to be associated with a given server profile


        $ListofConnections  = import-csv $tempfile

        foreach ($Conn in $ListofConnections)
        {
            $ServerProfileName  =   $DoubleQuote + $Conn.ServerProfileName.Trim() + $DoubleQuote  
            if ( $ServerProfileName -eq $ProfileName)
            {             
                $ConnName           = $Conn.ConnectionName

                $ConnID             = $Conn.ConnectionID
                $NetworkName        = $Conn.NetworkName
                $PortID             = $Conn.PortID
                $RequestedBandWidth = $Conn.RequestedBandWidth
                $UserDefined        = if ( $Conn.UserDefined -eq ' Yes' ) { $True} else {$false}          
                if ($UserDefined)
                {
                    $ConnMAC         = $Conn.ConnectionMACAddress
                    $MACCmds         = if ($ConnMAC ) { " -mac $ConnMAC "} else { "" }

                    $ConnWWNN        = $Conn.ConnectionWWNN
                    $WWNNCmds        = if ($ConnWWNN) { " -wwnn $ConnWWN " } else { ""}

                    $ConnWWPN        = $Conn.ConnectionWWPN
                    $WWPNCmds        = if ($ConnWWPN) { " -wwpn $ConnWWPN " } else { ""}

                    $UserDefinedCmds = " -userDefined $MacCmds $WWNNCmds $WWPNCmds "
                }
                else 
                {
                        $MacCmds = $WWNNCmds = $WWPNCmds = $UserDefinedCmds = ""
                }

                $BootPriorityCmds = ""
                $Bootable           = if ($Conn.Bootable -eq 'Yes' ) { $true } else { $False}
                if ($Bootable)
                {
                    $BootPriority       = $Conn.BootPriority  
                    if ($BootPriority)
                    {
                        $BootPriorityCmds = " -bootable -priority $BootPriority "
                    }
                    else
                    {
                        write-host -foreground YELLOW " Bootable is set to YES but BootPriority is not specified. Ignore Bootable settings"
                    }
                }

                $BootVolumeSource   = $Conn.BootVolumeSource



                if ($NetworkName)
                {

                    # Configure network
                    
                    try 
                    {
                        $objNetwork = get-HPOVNetwork -Name $NetworkName -ErrorAction stop
                    }
                    Catch [HPOneView.NetworkResourceException]
                    {
                        $objNetwork   = $NULL
                    }

                    if ($objNetwork -eq $NULL)
                    {
                        # Try network set
                        
                        try 
                        {
                            $objNetwork = get-HPOVNetworkSet -Name $NetworkName -ErrorAction stop
                        }
                        Catch [HPOneView.NetworkResourceException]
                        {
                            $objNetwork   = $NULL
                        }
                    
                    }
                    if ($objNetwork -ne $NULL)
                    {
                        # Configure PortID parameter

                        $PortIDCmds = "" 
                        if ( $PortID)
                            { $PortIDCmds = " -portID `$PortID "}  

                        # Configure RequestBandWidth parameter
                        $RequestBWCmds = "" 
                        if ($RequestedBandWidth)
                            { $RequestBWCmds = " -requestedBW $RequestedBandWidth "}  

                        

                        # Configure Boot Priority parameter 
                        $BootVolumeSourceCmds = "" 
                        if ($BootVolumeSource )
                        { 
                            $BootVolumeSourceCmds = " -bootvolumesource $BootVolumeSource "
                        }

                        $Cmds  = "New-HPOVProfileConnection -connectionID $ConnID -network `$objNetwork   "
                        $Cmds +=  $PortIDCmds + $RequestBWCmds + $UserDefinedCmds + $BootPriorityCmds + $BootVolumeSourceCmds 
                    
                        $Connection = Invoke-Expression $Cmds 
                        $ConnectionList += $Connection
                    }
                    else
                    {
                        write-host -ForegroundColor YELLOW "Cannot find network name or network set $NetworkName for this connection. Skip creating Network Connection..."
                    }

                    

                
                }
                else
                {
                    write-host -foreground YELLOW "The following information is not provided: `n `
                                - Network Name to connect to `n `
                                Please provide information and re-run the command. "                   
                }

            }
            else
            {
                # write-host -foreground YELLOW "Server Profile name specified in $ProfileConnectionCSV  does not match with $OVProfileName . Skip creating this network connection"  
                               
            }
        }
        
 

 
        return $ConnectionList
 }

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVProfileLOCALStorage
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVProfileLOCALStorage {
<#
  .SYNOPSIS
    Create ProfileLOCALStorage in OneView
  
  .DESCRIPTION
	Create ProfileLOCALStorage in OneView and return a hash table of Server ProfileName and connection list
        
  .EXAMPLE
    .\Create-OVProfileLOCALStorage  -OVProfileStorageCSV c:\OV-ProfileStorage.CSV -OVProfileName ThisProfile
    

  .PARAMETER OVProfileLOCALStorageCSV
    Name of the CSV file containing Server Profile Connection definition

  .PARAMETER OVProfileName
    Profile Name


  .Notes
    NAME:  Create-OVProfileLOCALStorage
    LASTEDIT: 01/20/2016
    KEYWORDS: OV Profile Local Storage
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>

 Param ( [string]$ProfileLOCALStorageCSV ="", [string]$ProfileName="")

         if ( -not (Test-path $ProfileLOCALStorageCSV))
        {
            write-host "No file specified or file $ProfileLOCALStorageCSV does not exist."
            return
        }


        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $ProfileLOCALStorageCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

        $script:StorageVolList = @()     # List of Storage Volumes to be associated with a given server profile


#region Check profile or template 
        #$ProfileName = $DoubleQuote  + $ProfileName.Trim() + $DoubleQuote 
        if ($ProfileName -eq "")
        {
            write-host -foreground YELLOW " No Server profile nor template provided. Skip creating Local Storage for profiles.."
            return $NULL
        }
$a= @"
        $ThisProfile = Get-HPOVServerProfileTemplate -name  $OVProfileName
        if ($ThisProfile -eq $NULL)
            {  $ThisProfile = Get-HPOVServerProfile -name  $OVProfileName } # It's not a template then try profile
        
        if ($ThisProfile -eq $NULL)
        {
            write-host -foreground YELLOW " Server profile or template does not exist. Skip creating Local Storage for profiles.."
            return $NULL
        }

       $ThisSHT = Send-HPOVRequest -uri $SHT}

        #$DriveTechnologies   = $ThisSHT.storagecapabilities.driveTechnologies    # @( SasHdd, SataHdd, SasSsd, SataSsd )
        $RaidLevels          = $ThisSHT.storagecapabilities.raidLevels           # @( RAID0, RAID1, RAID1ADM , RAID10, RAID5, RAID6)
        $controllerModes     = $ThisSHT.storagecapabilities.controllerModes      # @(RAID, HBA)
        $maximumDrives       = $ThisSHT.storagecapabilities.maximumDrives
"@
#endregion Check profile or template 

        $ListofControllers = @()
        $ProfileStorageParam = ""
        # As of POSH 3.0.1170.1173, use values as defined in POSH
        $DriveTechnologies   = @('SAS','SATA','SASSSD','SATASSD','Auto')
   
 

        $ListofLocalStorage  = import-csv $tempfile
        $ListofLocalStorage  = $ListofLocalStorage | where { $($DoubleQuote + $_.profileName + $DoubleQuote) -eq $ProfileName }
                
        foreach ($LS in $ListofLocalStorage)  
        {
            $EnableLOCALStorage  = if ($LS.EnableLOCALStorage -eq 'Yes') { $True} else {$False}
            $ControllerID        = $LS.ControllerID
            $ControllerMode      = $LS.ControllerMode
            $ControlInit         = if ($LS.ControllerInitialize -eq 'Yes') { $True} else {$False}
            $LDisks              = $LS.LogicalDisks
            $ListofLogicalDisks  = @()
            if ($LDisks)
            {
                $ListofVols      = $LDisks.Split($SepChar)
                for ($Index=0;$Index -lt $ListofVols.Count;$Index++)
                {
                    $DiskName        = $ListofVols[$Index].Trim()
                    $Bootable       = if ($LS.Bootable) 
                                        { 
                                            $a = $LS.Bootable.Split($SepChar)
                                            if ($a[$Index].Trim() -eq 'Yes') { $True} else {$false}
                                        } 
                                        else 
                                        { $False }

                    $DriveType       = if ($LS.DriveType)
                                        { $LS.DriveType.Split($SepChar)[$Index].Trim() }

                    $NumberofDrives  = if ($LS.NumberofDrives)
                    { $LS.NumberofDrives.Split($SepChar)[$Index].Trim() }          # to be checked against maximumDrives

                    $RAIDLevel       = if ($LS.RAID)
                                        { $LS.RAID.Split($SepChar)[$Index].Trim() } 

                    $MinDriveSize    = if ($LS.MinDriveSize)
                                        { $LS.MinDriveSize.Split($SepChar)[$Index].Trim() }             # Only for Synergy BigBird

                    $MaxDriveSize    = if ($LS.MaxDriveSize)
                                        { $LS.MaxDriveSize.Split($SepChar)[$Index].Trim() }            # Only for Synergy BigBird
                    
                    $ListofLogicalDisks += New-HPOVServerProfileLogicalDisk -Name $DiskName -RAID $RAIDLevel  -NumberofDrives $NumberofDrives -DriveType $DriveType -Bootable $Bootable

$b=@"
                    $Check =    ($NumberofDrives -le $maximumDrives) -and ` 
                                ($RaidLevels -contains $RAIDLevel) -and `
                                ($DriveTechnologies -contains $DriveType) 
                                
                    
                    if ($Check)
                    {
                        $ListofLogicalDisks += New-HPOVServerProfileLogicalDisk -Name $DiskName -RAID $RAIDLevel  -NumberofDrives $NumberofDrives -DriveType $DriveType -Bootable $Bootable
                    }
                    else 
                    {
                        write-host -ForegroundColor CYAN "Local storage settings for this profile $OVProfileName are not compatible with server capabilities. `n"
                
                        write-host -ForegroundColor CYAN " Check DriveType or RaidLevel or Number of Drives. `n"

                        write-host -ForegroundColor CYAN " a/ DriveType --> $DriveType while Capabilities are --> $($DriveTEchnologies -join '|' )"
                        write-host -ForegroundColor CYAN " b/ Number of Drives --> $NumberofDrives while Capabilities are --->$maximumDrives "
                        write-host -ForegroundColor CYAN " c/ RAID --> $RAIDLevel while Capabilities are ---> $($RAIDLevels -join '|'  )"
                    }
"@
                }
            }
                        
            $ListofControllers += New-HPOVServerProfileLogicalDiskController -Mode $ControllerMode -ControllerID $ControllerID -Initialize:$ControlInit -LogicalDisk $ListofLogicalDisks
        }

        return $EnableLocalStorage,$ListofControllers 

}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVProfileSANStorage
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVProfileSANStorage {
<#
  .SYNOPSIS
    Create ProfileSANStorage in OneView
  
  .DESCRIPTION
	Create ProfileSANStorage in OneView and return a hash table of Server ProfileName and connection list
        
  .EXAMPLE
    .\Create-OVProfileSANStorage  -OVProfileSANStorageCSV c:\OV-ProfileStorage.CSV -OVProfileName ThisProfile
    

  .PARAMETER OVProfileSANStorageCSV
    Name of the CSV file containing Server Profile Connection definition

  .PARAMETER OVProfileName
    Profile Name


  .Notes
    NAME:  Create-OVProfileSANStorage
    LASTEDIT: 12/29/2016
    KEYWORDS: OV Profile SAN Storage
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>

 Param ( [string]$ProfileSANStorageCSV ="", [string]$ProfileName="",[switch]$Createprofile)

         if ( -not (Test-path $ProfileSANStorageCSV))
        {
            write-host "No file specified or file $ProfileSANStorageCSV does not exist."
            return
        }


        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $ProfileSANStorageCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

        $StorageVolList = @()     # List of Storage Volumes to be associated with a given server profile

        #$ProfileName = $DoubleQuote  + $ProfileName.Trim() + $DoubleQuote 
        if ($ProfileName -eq "")
        {
            write-host -foreground YELLOW " No Server profile nor template provided. Skip creating Local Storage for profiles.."
            return $NULL
        }



        $ListofSANStorage  = import-csv $tempfile
        $ListofSANStorage  = $ListofSANStorage | where { $($DoubleQuote + $_.profileName + $DoubleQuote) -eq $ProfileName }
        foreach ($SL in $ListofSANStorage)
        {
            $EnableSAN      = if ($SL.EnableSANStorage -eq 'Yes') { $True} else {$False}
            $HostOSType     = $SL.HostOSType
            $VolNameArray   = $SL.VolumeName.Split($SepChar)
            $LUNArray       = $SL.Lun.Split($SepChar)

            $VoltoAttachArr = @()
            if ($EnableSAN)
            {
                for ($index=0;$index -lt $VolNameArray.Count; $index++)
                {
                    $ThisLUN       = $LUNArray[$Index]
                    $ThisVolName   = $VolNameArray[$Index].Trim()

                    if ($ThisVolName)
                    {
                        $ThisVol       = Get-HPOVStorageVolume -name $ThisVolName
                        if ($ThisVol)
                        {
                                if ($ThisLUN)
                                {
                                    $VolAttach = New-HPOVServerProfileAttachVolume -Volume $ThisVol -LunID $ThisLUN -LunIDType 'Manual' 
                                }
                                else
                                {
                                    if ($CreateProfile)
                                    {
                                        $VolAttach = New-HPOVServerProfileAttachVolume -Volume $ThisVol  -LunIDType 'Auto' 
                                    }
                                    else 
                                    {
                                        write-host -ForegroundColor Yellow "No LUN ID provided for this volume $THisVolName. Skip attaching this volume. `n When creating server profile template, specify LUN ID for volumes  "    
                                    }
                                }
                                $VoltoAttachArr += $VolAttach 
                        }
                        else 
                        {
                            write-host -foreground YELLOW " This volume specified as $ThisVolName does not exist. Please create if first..."
                        }
                    }


                }
            }

            
        }

        return $EnableSAN,$HostOSType,$VoltoAttachArr
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVProfileTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVProfileTemplate {
<#
  .SYNOPSIS
    Create Server Profile Template in OneView
  
  .DESCRIPTION
	Create Server Profile Template in OneView
        
  .EXAMPLE
    .\Create-OVProfileTemplate -OVProfileConnectionCSV c:\OV-ProfileConnection.CSV -OVProfileTemplate c:\OV-ProfileTemplate.csv
    


  .PARAMETER OVProfileConnectionCSV
    Name of the CSV file that contains definitions of Connections (Ethernet or Fibre Channel) associated to server profile Template

  .PARAMETER OVProfileTemplateCSV
    Name of the CSV file that contains definitions of server profile Template
	


  .Notes
    NAME:  Create-OVProfileTemplate
    LASTEDIT: 12/10/2016
    KEYWORDS: OV Profile Template
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
 Param ( [string]$OVProfileConnectionCSV  ,
         [string]$OVProfileTemplateCSV            , 
         [string]$OVProfileLOCALStorageCSV,
         [string]$OVProfileSANStorageCSV  )           

         Create-ProfileORTemplate  -OVProfileTemplateCSV $OVProfileTemplateCSV -OVProfileConnectionCSV $OVProfileConnectionCSV -OVProfileLOCALStorageCSV  $OVProfileLOCALStorageCSV -OVProfileSANStorageCSV  $OVProfileSANStorageCSV 
}

Function Create-ProfileorTemplate {

 Param ( [string]$OVProfileConnectionCSV  ,
         [string]$OVProfileTemplateCSV            , 
         [string]$OVProfileLOCALStorageCSV,
         [string]$OVProfileSANStorageCSV  ,
         [switch]$CreateProfile     )           # use to distinguish create profile vs create profiletemplate

        if ( -not (Test-path $OVProfileTemplateCSV))
        {
            write-host -foreground YELLOW "No file specified or file $OVProfileTemplateCSV does not exist."
            return
        }



        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVProfileTemplateCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

        $ListofProfileTemplate  = import-csv $tempfile

        foreach ($SPT in $ListofProfileTemplate)
        {
            $Proceed = $True

            if ($CreateProfile)
            {
               $ProfileName     = '"' + $SPT.ProfileName.Trim() + '"'       # We use ProfileCSV instead of Template.csv
               $EncName         = $SPT.Enclosure
               $Bay             = $SPT.EnclosureBay   
               $AssignType      = $SPT.AssignmentType
               $Server          = $SPT.Server.Trim() -replace '"',''
               $ServerTemplate  = $SPT.ServerTemplate
               $ProfileTemplateName = $ProfileName
               if ($ServerTemplate)
               {
                   $TemplatetoCreateFrom = get-hpovserverprofileTemplate -name $ServerTemplate
                   if ($TemplatetoCreateFrom )
                   {
                       $ServerTemplateToCreateFromCmds = " -ServerProfileTemplate `$TemplatetoCreateFrom "
                       
                   }
                   else
                   {
                       $Proceed = $False
                       write-host -foreground YELLOW " Server profile Template $ServerTemplate does not exist. Can't create profile from this template"
                   }
                   #Create-ProfileFROMTemplate -SP $SPT
                   
               }

            }            
            else # Profile Template here
            {
                $ProfileTemplateName    = $DoubleQuote + $SPT.ProfileTemplateName.Trim() + $DoubleQuote
                $ServerPDescription     = $DoubleQuote + $SPT.ServerProfileDescription + $DoubleQuote
            }

            $Description            = $DoubleQuote + $SPT.Description + $DoubleQuote 

            $SHType                 = $SPT.ServerHardwareType
            $EnclGroup              = $SPT.EnclosureGroup
            $Affinity               = if ($SPT.Affinity) { $SPT.Affinity} else {'Bay'}

            $BootMode               = if ($SPT.BootMode) { $SPT.BootMode} else {'BIOS'}
            $BootOrderArray         = if ($SPT.BootOrder) { $SPT.BootOrder.Split($SepChar) } else {$NULL}

            $BIOSSettings           = $SPT.BIOSSettings
            
            $FWEnable               = if ($SPT.FWEnable -eq 'Yes') { $True } else { $False}
            $FWMode                 = $SPT.FWMode
            $FWInstall              = if ($SPT.FWInstall  -eq 'Yes') { $True } else { $False}
            $Baseline               = $SPT.FWBaseline

            write-host -foreground Cyan "-------------------------------------------------------------"
            write-host -foreground Cyan "Creating profile or template $ProfileTemplateName            "
            write-host -foreground Cyan "-------------------------------------------------------------"


            # Validate SHT 
            $SHTCmds = ""
            if ( $SHType)
            {
                $BIOSsettingID = @()
                $ThisSHT = Get-HPOVServerHardwareType -name $SHType
                if ($ThisSHT )
                {
                    $Model   = $ThisSHT.Model
                    $IsDL    = $Model -like '*DL*'
                    $ThisSHT.BIOSSettings | % { $BIOSsettingID += $_.ID}  # Collect BIOSSettings ID
                    $SHTCmds = " -Serverhardwaretype `$ThisSHT "
                }
                else
                {
                    write-host -foreground YELLOW " Server Hardware Type $SHType does not exist.Can't create profile or template "
                    $Proceed = $CreateProfile      # Set to same Boolean value as CreateProfile as we will need to check SHT again if creating server profile
                }
            }
            else
            {
                write-host -foreground YELLOW " Server Hardware Type $SHType is not specified. Can't create profile or template"  
                $Proceed = $False
            }

            # Check Name 

            if ($CreateProfile)
            {
                if ($server)
                {
                    $ServerObj      = get-HPOVServer -name $server
                    if ($ServerObj.state -eq 'ProfileApplied')
                    {
                        write-host -foreground YELLOW " Server $Server already has profile assigned. Skip creating profile for $ProfileName"
                        $Proceed = $False
                    }
                    else 
                    {
                        switch ($AssignType)
                        {
                            "server"    { 
                                            $AssignTypeCmds = " -AssignmentType server "
                                            if (-not $server) 
                                            {
                                                write-host -foreground YELLOW " Assignment type is set to server but server is not specified. Can't create profile for $ProfileName"
                                                $Proceed = $False
                                            }
                                            else 
                                            {
                                                $ServerObj      = get-HPOVServer -name $server
                                                if ( $ServerObj)
                                                {
                                                    $ServerCmds = " -server `$ServerObj "    
                                                }
                                                else 
                                                {
                                                    write-host -foreground YELLOW " server does not exist. Can't create profile for $ProfileName"
                                                    $Proceed = $False                                            
                                                }
                                            }
                                            
                                        }

                            "bay"       {
                                            $AssignTypeCmds = " -AssignmentType bay "
                                            if (-not $Bay)
                                            {
                                                write-host -foreground YELLOW " Assignment type is set to bay but bay number is not specified. Can't create profile for $ProfileName"
                                                $Proceed = $False
                                            }  
                                        }

                            "unassigned" { 
                                            $AssignTypeCmds = " -AssignmentType unassigned "

                                            #If the profile is not based on a template, the SHT is required
                                            if ( (-not $ProfileTemplate ) -and (-not $SHType)) 
                                            {
                                                write-host -foreground YELLOW " Assignment type is set to unassigned but profile template or server hardware type is not specified. Can't create profile for $ProfileName"
                                                $Proceed = $False
                                            }
                                            else 
                                            {
                                                # TO BE Defined 
                                                write-host " Not implemented yet. TO create profiel from Tempalte"
                                                $Proceed = $false
                                            }

                                            if (-not $server) 
                                            {
                                                write-host -foreground YELLOW " Assignment type is set to unassigned but server is not specified. Can't create profile for $ProfileName"
                                                $Proceed = $False
                                            }  
                                            else 
                                            {
                                                $ServerObj      = get-HPOVServer -name $server
                                                if ( $ServerObj)
                                                {
                                                    $ServerCmds = " -server `$ServerObj "    
                                                }
                                                else 
                                                {
                                                    write-host -foreground YELLOW " server does not exist. Can't create profile for $ProfileName"
                                                    $Proceed = $False                                            
                                                }
                                            }

                                        }

                        }           
                    }

                }
                else 
                {
                    
                    if ($AssignType -eq "Bay")        
                    { 
                        $AssignTypeCmds = " -AssignmentType bay "
                        if (-not $Bay)
                        {
                            write-host -foreground YELLOW " Assignment type is set to bay but bay number is not specified. Can't create profile for $ProfileName"
                            $Proceed = $False
                        }  

                        if (-not $EncName) 
                        {
                            write-host -foreground YELLOW " Assignment type is set to bay but enclosure name is not specified. Can't create profile for $ProfileName"
                            $Proceed = $False
                        }  
                        else 
                        {
                            $ThisEnclosure = get-HPOVEnclosure -name $EncName
                            if ($ThisEnclosure)
                            {
                                $EnclosureBayCmds = " -Enclosure `$ThisEnclosure -EnclosureBay $Bay " 
                            }
                            else
                            {  
                                write-host -foreground YELLOW " Enclosure $EncName does not exist. Can't create profile for $ProfileName"
                                $Proceed = $False
                            }

                        }

                        if (-not $SHType) 
                        {
                            write-host -foreground YELLOW " Assignment type is set to bay but server hardware type is not specified. Can't create profile for $ProfileName"
                            $Proceed = $False
                        }   # SHTCMds already defined above 
                          
                    } 
                }





                if ($ProfileName)
                {
                    $ProfileTemplateName = $ProfileName
                }
                else    # Name not specified - Try to use Enclosure Name and Bay Number
                {
                    if ($isDL)
                    {
                        $ProfileTemplateName = "Default Profile for DL"
                    }
                    else {
                        $ProfileTemplateName = "$EncName, Bay $Bay"
                    }

                }
                $ThisProfileTemplate = Get-HPOVServerProfile | where { $($DoubleQuote + $_.name + $DoubleQuote) -eq $ProfileTemplateName }

            }
            else # Profile Template here
            {
                $ThisProfileTemplate = Get-HPOVServerProfileTemplate | where { $($DoubleQuote + $_.name + $DoubleQuote) -eq $ProfileTemplateName }
            }

            if (-not $ThisProfileTemplate)
            {

                #Specific parameters for Blade Servers
                $ConnectionsCmds = $SANStorageCmds = $AffinityCmds = $egCmds = "" 

                
                if (-not $isDL)
                {
                    # Build Network Connections parameters

                    if ( $OVProfileConnectionCSV -and (Test-path $OVProfileConnectionCSV))    # Connections list provided
                    {
                        $ProfilesNConnections = Create-OVProfileConnection -ProfileConnectionCSV $OVProfileConnectionCSV -ProfileName $ProfileTemplateName
                        if ($ProfilesNConnections)
                        {
                            $ConnectionsCmds = " -Connections `$ProfilesNConnections " 
                        }
                        else
                        {
                            write-host -ForegroundColor Yellow "Cannot find Profile Connections for this profile $ProfileTemplateName. Will create profile without ProfileConnections"
                            $ConnectionsCmds = ""
                        }

                    }
                    else
                    {
                        write-host -ForegroundColor Yellow "Connections list is empty. Profile will be created without any network/FC connection."
                    }

                    
                    # Build SAN Storage parameters
                    
                    if ( $OVProfileSANStorageCSV -and (Test-path $OVProfileSANStorageCSV))    # SAN Storage list provided 
                    {
                    $Enable,$HostOSType,$VolAttach = Create-OVProfileSANStorage -ProfileSANStorageCSV $OVProfileSANStorageCSV -ProfileName $ProfileTemplateName -createProfile:$CreateProfile
                
                        if ($VolAttach -and $Enable -and $HostOSType)
                        {
                            $SANStorageCmds = " -SANStorage -HostOSType $HostOSType -StorageVolume `$VolAttach"
                        }
                        else
                        {
                            write-host -ForegroundColor Yellow "Either SANStorage is not enabled or HostOSType or StorageVolume not defined in CSV file. Will create profile without SAN Storage"
                            $SANStorageCmds = ""
                        }                    
                    }                        
                    else
                    {
                        write-host -ForegroundColor Yellow "Cannot find SAN Storage list for this profile $ProfileTemplateName. Will create profile without SAN Storage"
                        $SANStorageCmds = ""
                    }

                   # Build Affinity parameter
                    
                    if ($Affinity)
                    { 
                        $AffinityCmds = " -affinity $Affinity " 
                    } 

                    # Build EnclosureGroup parameter
                    
                    if ($enclGroup)
                    {
                        $ThisEnclosureGroup = Get-HPOVEnclosureGroup | where name -eq $EnclGroup
                        if ($ThisEnclosureGroup)
                        { 
                            $egCmds             = " -EnclosureGroup `$ThisEnclosureGroup  " 
                        }
                        else
                        {
                            write-host -foreground YELLOW " Enclosure Group $enclGroup does not exist."
                            
                        }
                    }
                    else
                    {
                        write-host -foreground YELLOW " Enclosure Group $enclGroup is not specified. "
                        
                    }                    

                    if ($CreateProfile -and ($AssignType -eq 'Bay')) 
                    {
                        $egCmds  = ""
                    }

                }


                # Build LOCAL Storage parameters
                $LOCALStorageCmds = ""

                if ( $OVProfileLOCALStorageCSV -and (Test-path $OVProfileLOCALStorageCSV))    # LOcal Storage list provided 
                {
                   $Enable, $StorageController = Create-OVProfileLOCALStorage -ProfileLOCALStorageCSV $OVProfileLOCALStorageCSV -ProfileName $ProfileTemplateName 

                    if ($StorageController -and $Enable)
                    {
                        $LOCALStorageCmds = " -LocalStorage -StorageController `$StorageController"
                    }
                    else
                    {
                        write-host -ForegroundColor Yellow "Either LocalStorage is not enabled or LocalStorage Controllers not defined in CSV file. Will create profile without LOCAL Storage"
                        $LOCALStorageCmds = ""
                    }                    
                }                        
                else
                {
                    write-host -ForegroundColor Yellow "Cannot find LOCAL Storage list for this profile $ProfileTemplateName. Will create profile without LOCAL Storage"
                    $LOCALStorageCmds = ""
                }

 

                # Build BootMode parameter
                
                if ($Model -notlike '*Gen8*')
                {
                    $BootModeCmds = " -bootmode $BootMode "       
                }
                else 
                {
                    write-host -foreground YELLOW " Server Hardware Model $Model does not support BootMode. Ignore BootMode Value  "
                    $BootModeCmds = ""   
                }


                # Build BootOrder parameter
                $BootOrderCmds = ""
                if ($BootOrderArray -ne $NULL )
                    { $BootOrderCmds = " -ManageBoot -bootOrder `$BootOrderArray " }                   

                # Build Description parameter
                $DescCmds = ""
                if ($Description)
                    { $DescCmds = " -description $Description " }

               ### N/A Yet
                $ServerDescCmds = ""
                if ($ServerPDescription)
                    { $ServerDescCmds = " -description $ServerPDescription "}

                # Validate Firmware Settings
                $FWCmds = ""
                if ($FWEnable)
                {
                    if ($Baseline)
                    {
                        $Baseline    = $Baseline.Trim() 
                        $FWVersion   = ($Baseline -split(' '))[-1]    # Get version 2016.10.0
                        $FWObj       = Get-HPOVBaseline | where version -eq $FWVersion
                        if ($FwObj)
                        {
                            $FWCmds = " -firmware -Baseline `$FWObj "

                            #if ( @('FirmwareOnly', 'FirmwareAndOSDrivers' ,'FirmwareOffline') -contains $FWMode)
                            if ($FWMode)
                                { $FWCMds += " -FirmwareMode $FWMode " }   

                            if ($FWInstall)
                                { $FWCmds += " -forceInstallFirmware "} 
                        }

                    }                
                    
                }
                

                # Build Profile TemplateName
                $ProfileTemplateNameCmds = ""
                if ($ProfileTemplateName)
                    {$ProfileTemplateNameCmds  = " -name  $ProfileTemplateName " }

            
                # Buid BIOSSettings
                $BIOSSettingsArray = @()
                if ($BIOSSettings)
                {
                    $BIOSSettingsList = $BIOSSettings.Split($SepChar)
                    foreach ($BSetting in $BIOSSettingsList)
                    {
                        if ($BSetting)
                        {
                            $id,$value          = $BSetting.Split(';')
                            $id                 = $id.Split('=')[1].Trim()
                            $value              = $value.split('=')[1].trim()
                            if ($BIOSsettingID -contains $id)
                            {
                                $newsetting         = @{id=$id;value=$value}
                                $BIOSSettingsArray += $newsetting
                            }
                            else 
                            {
                                write-host -foreground YELLOW " This BIOSsetting ID $id is not supported for this server hardware type $SHType. Ignore setting"    
                            }
                        }
                    }
                    if ($BIOSSettingsArray)
                    {
                        $BIOSettingsCmds = " -BIOS -BIOSSettings `$BIOSSettingsArray "
                    }
                    else 
                    {
                        write-host -foreground YELLOW "No valid BIOSsetting found. Ignore BIOS configuration"
                        $BIOSettingsCmds = ""
                    }
                }
                else
                { 
                    $BIOSettingsCmds = ""
                }

                # Create command to build profile template

                if ($Proceed)
                {
                    if ($CreateProfile)
                    {
                        $ProfileCmds  = "New-HPOVServerProfile " + $ProfileTemplateNameCmds + $DescCmds 
                        $ProfileCmds += $AssignTypeCmds + $ServerCmds 
                       
                        if ($ServerTemplate)
                        {
                            write-host -foreground Cyan " Creating profile from Server Template ....."
                            $ProfileCmds += $ServerTemplateToCreateFromCmds 

                        }
                        else
                        {
                            $ProfileCmds   +=  $EnclosureBayCmds
                            $ProfileCmds   += $SHTCmds +  $egCmds + $AffinityCmds
                            $ProfileCmds   += $BootOrderCmds + $BootModeCmds
                            $ProfileCmds   += $ConnectionsCmds + $LOCALStorageCmds + $SANStorageCmds
                            $ProfileCmds   +=  $FWCmds  + $BIOSettingsCmds 
                        }
                        if ($serverobj)
                        {
                            $ServerObj | Stop-HPOVServer -Force -confirm:$False | Wait-HPOVTaskComplete
                        }
                        
                        Invoke-Expression $ProfileCmds | Wait-HPOVTaskComplete | FL
                    }
                    else    # Create profile template here
                    {
                        if ($ProfileTemplateNameCmds)
                        {            
                            $ProfileTemplateCmds   = "New-HPOVServerProfileTemplate " + $ProfileTemplateNameCmds + $DescCmds 
                            $ProfileTemplateCmds   += $SHTCmds +  $egCmds + $AffinityCmds
                            $ProfileTemplateCmds   += $BootOrderCmds + $BootModeCmds
                            $ProfileTemplateCmds   += $ConnectionsCmds + $LOCALStorageCmds + $SANStorageCmds
                            $ProfileTemplateCmds   +=  $FWCmds  + $BIOSettingsCmds 
                        
                        Invoke-Expression $ProfileTemplateCmds | Wait-HPOVTaskComplete | fl                            
                        }
                        else
                        {
                            write-host -foreground YELLOW "$ProfileTemplateName not specified. Can't create server profile template "
                        }
                    }

                }
                else
                {
                    write-host -foreground YELLOW " Correct errors and re-run the command again" 
                }                
            }   
            else
            {
                 write-host -foreground YELLOW "Server Profile Template or Server Profile  --> $ProfileTemplateName already exists. Skip creation of Profile."
            }

        }
}


Function Create-ProfileFROMTemplate ([pscustomobject]$SP)
{
            $ProfileName     = $SP.ProfileName 
            $Description     = $SP.Description 
            $ServerHW        = $SP.Server
            $SPTemplate      = $SP.ServerProfileTemplate
            $AssignmentType  = if ($SP.AssignmentType) {$SP.AssignmentType} else {'Bay'} 

            if ($ProfileName)
            {
                $TemplateCheck = $False
                # Validate the Server Profile Template

                if ( $SPTemplate)
                {
                    $ThisProfileTemplate = get-HPOVServerProfileTemplate | where name -eq $SPTemplate
                    if ($ThisProfileTemplate)
                    { 
                        $TemplateCheck = $True
                    }
                    else  
                    { 
                        write-host -foreground YEllow " Server Profile Template $SPTemplate does not exist. Can't create Server Profile from Template"
                        $TemplateCheck = $False 
                    }
                } 
                else 
                { 
                    write-host -foreground YEllow " Server Profile Template is not specified. Can't create Server Profile from Template"
                    $TemplateCheck = $False 
                }

                # Validate Server Hardware
                $HWCheck = $False
                if ($ServerHW)
                {
                    $ThisServerHW = Get-HPOVServer | where name -eq $ServerHW
                    if ( $ThisServerHW)
                    { 
                        if ($ThisServerHW.State -eq 'NoProfileApplied')
                        {
                            $HWCheck = $True
                        }
                        else 
                        {
                            write-host -foreground YEllow " The Server Hardware $ServerHW already has profile. Skip creating profile" 
                            $HWCheck = $False  
                        }
                    }
                    else  
                    { 
                        write-host -foreground YEllow " The Server Hardware $ServerHW does not exist. Please check name with Get-HPOVServer. Can't create Server Profile from Template"
                        $HWCheck = $False 
                    }
                }
                else
                { 
                    write-host -foreground YEllow " Server Hardware is not specified. Can't create Server Profile from Template"
                    $HWCheck = $False 
                }



                if ($HWCheck -and $TemplateCheck)
                {
                    write-host -foreground CYAN "  ------------------------------------------------------------ "
                    write-host -foreground CYAN "  Creating profile $Profilename for server $ServerHW "
                    New-HPOVServerProfile -Name $ProfileName  -Description $Description  -ServerProfileTemplate $ThisProfileTemplate -Server $ThisServerHW -AssignmentType $AssignmentType | wait-HPOVTaskComplete 
                    
                    write-host -foreground CYAN " Updating profile $Profilename from template $TemplateName "
                    Get-HPOVServerProfile -name $ProfileName |  Update-HPOVServerProfile -confirm:$false
                    write-host -foreground CYAN " ------------------------------------------------------------ "
                }
                else
                {
                        write-host -foreground YEllow " Missing information to create server profile from Template. Check Profile Template or Server Hardware"

                }

            }
            else
            {
                    write-host -foreground YEllow " Name of profile not specified. Skip creating profile"

            }


}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVProfileFROMTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVProfileFROMTemplate {
<#
  .SYNOPSIS
    Create Server Profile from Template in OneView
  
  .DESCRIPTION
	Create Server Profile from Template in OneView
        
  .EXAMPLE
    .\Create-OVProfilefromTemplate  -OVProfile c:\OV-ProfilefromTemplate.csv


  .PARAMETER OVProfilefromTemplateCSV
    Name of the CSV file that contains definitions of server profiles
	


  .Notes
    NAME:  Create-OVProfilefromTemplate
    LASTEDIT: 12/10/2016
    KEYWORDS: OV ProfilefromTemplate
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
 Param ( [string]$OVProfilefromTemplateCSV )  

        if ( -not (Test-path $OVProfilefromTemplateCSV))
        {
            write-host "No file specified or file $OVProfilefromTemplateCSV does not exist."
            return
        }



        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVProfilefromTemplateCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

        $ListofProfile  = import-csv $tempfile

        foreach ($SP in $ListofProfile)
        {
            $ProfileName     = $SP.ProfileName 
            $Description     = $SP.Description 
            $ServerHW        = $SP.Server
            $SPTemplate      = $SP.ServerTemplate
            $AssignmentType  = if ($SP.AssignmentType) {$SP.AssignmentType} else {'Bay'} 

            if ($ProfileName)
            {
                $TemplateCheck = $False
                # Validate the Server Profile Template

                if ( $SPTemplate)
                {
                    $ThisProfileTemplate = get-HPOVServerProfileTemplate | where name -eq $SPTemplate
                    if ($ThisProfileTemplate)
                    { 
                        $TemplateCheck = $True
                    }
                    else  
                    { 
                        write-host -foreground YEllow " Server Profile Template $SPTemplate does not exist. Can't create Server Profile from Template"
                        $TemplateCheck = $False 
                    }
                } 
                else 
                { 
                    write-host -foreground YEllow " Server Profile Template is not specified. Can't create Server Profile from Template"
                    $TemplateCheck = $False 
                }

                # Validate Server Hardware
                $HWCheck = $False
                if ($ServerHW)
                {
                    $ThisServerHW = Get-HPOVServer | where name -eq $ServerHW
                    if ( $ThisServerHW)
                    { 
                        if ($ThisServerHW.State -eq 'NoProfileApplied')
                        {
                            $HWCheck = $True
                        }
                        else 
                        {
                            write-host -foreground YEllow " The Server Hardware $ServerHW already has profile. Skip creating profile" 
                            $HWCheck = $False  
                        }
                    }
                    else  
                    { 
                        write-host -foreground YEllow " The Server Hardware $ServerHW does not exist. Please check name with Get-HPOVServer. Can't create Server Profile from Template"
                        $HWCheck = $False 
                    }
                }
                else
                { 
                    write-host -foreground YEllow " Server Hardware is not specified. Can't create Server Profile from Template"
                    $HWCheck = $False 
                }



                if ($HWCheck -and $TemplateCheck)
                {
                    write-host -foreground CYAN "  ------------------------------------------------------------ "
                    write-host -foreground CYAN "  Creating profile $Profilename for server $ServerHW "
                    New-HPOVServerProfile -Name $ProfileName  -Description $Description  -ServerProfileTemplate $ThisProfileTemplate -Server $ThisServerHW -AssignmentType $AssignmentType | wait-HPOVTaskComplete 
                    
                    write-host -foreground CYAN " Updating profile $Profilename from template $TemplateName "
                    Get-HPOVServerProfile -name $ProfileName |  Update-HPOVServerProfile -confirm:$false
                    write-host -foreground CYAN " ------------------------------------------------------------ "
                }
                else
                {
                        write-host -foreground YEllow " Missing information to create server profile from Template. Check Profile Template or Server Hardware"

                }

            }
            else
            {
                    write-host -foreground YEllow " Name of profile not specified. Skip creating profile"

            }


        } ## Endfor

}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVProfile
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVProfile {
<#
  .SYNOPSIS
    Create Server Profile  in OneView
  
  .DESCRIPTION
	Create Server Profile in OneView
        
  .EXAMPLE
    .\Create-OVProfile -OVProfileConnectionCSV c:\OV-ProfileConnection.CSV -OVProfile c:\OV-Profile.csv
    


  .PARAMETER OVProfileConnectionCSV
    Name of the CSV file that contains definitions of Connections (Ethernet or Fibre Channel) associated to server profiles

  .PARAMETER OVProfileCSV
    Name of the CSV file that contains definitions of server profiles
	


  .Notes
    NAME:  Create-OVProfile
    LASTEDIT: 05/21/2014
    KEYWORDS: OV Profile
   
  .Link
     Http://www.hp.com
 
 #Requires PS -Version 3.0
 #>
 Param ( [string]$OVProfileConnectionCSV  ,
         [string]$OVProfileCSV            , 
         [string]$OVProfileLOCALStorageCSV,
         [string]$OVProfileSANStorageCSV     )           

         Create-ProfileorTemplate -OVProfileTemplateCSV $OVProfileCSV -OVProfileConnectionCSV $OVProfileConnectionCSV -OVProfileLOCALStorageCSV $OVProfileLOCALStorageCSV -OVProfileSANStorageCSV $OVProfileSANStorageCSV -createprofile
        
}

#Region StorageSystemandVolume

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVStorageSystem
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVStorageSystem {
<#
  .SYNOPSIS
    Import a storage system
  
  .DESCRIPTION
	Add storgae system to OneView
        
  .EXAMPLE
    .\Creator.ps1  -OVStorageSystemCSV c:\OV-StorageSystem.CSV 


  .PARAMETER OVStorageSystemCSV
    Name of the CSV file containing Storage System definition
	

  .Notes
    NAME:  Create-OVStorageSystem
    LASTEDIT: 10/05/2016
    KEYWORDS: OV StorageSystem
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>

Param ( [string]$OVStorageSystemCSV, [string]$OVFCNetworksCSV)

        if ( ! [string]::IsNullOrEmpty($OVFCNetworksCSV) -and (Test-path $OVFCNetworksCSV) )
            {
              
                Create-OVFCNetworks -OVFCNetworksCSV $OVFCNetworksCSV 
            
                ## Update FC networks associated to StorageSystemPorts
                ##
                foreach ($N in $script:ListofFCNets)
                {
                    $FCNet        = $N.NetworkName
                    $FCSwitchName = $N.FCSwitchName
                    if ($FCSwitchName)
                    {
                        $ManagedSAN = Get-HPOVManagedSan -Name $FCSwitchName
                        if ($ManagedSAN)
                        {
                            $SANUri  = $ManagedSAN.uri
                            $ThisNet = Get-HPOVNetwork -name $FCNet
                            if ($ThisNet.ManagedSanURI -ne $SANUri)
                            {
                                write-host -foreground Cyan "-------------------------------------------------------------"
                                write-host -foreground Cyan "Affiliating the FC Network $FCNet with the SAN $FCSwitchName "
                                write-host -foreground Cyan "-------------------------------------------------------------"
                            
                                $UpdateNetwork = Get-HPOVNetwork -name $FCNet | Set-HPOVNetwork -managedSan $ManagedSAN | Wait-HPOVTaskComplete
                            }
                            else
                            {
                                write-host -ForegroundColor Yellow " FC network $FCNet already managed by SAN $FCSwitchName. Skip updating FC network..." 
                            }


                        }

                    }

                }  #end foreach FC Network
                
            }
        else
            {
                write-host -ForegroundColor Yellow "No file specified for FC Network or file $OVFCNetworksCSV does not exist."
                write-host -ForegroundColor Yellow " Skip creating FC networks....." 
            }



        if (!( $OVStorageSystemCSV -and (Test-path $OVStorageSystemCSV)))
        {
            write-host "No file specified or file $OVStorageSystemCSV does not exist."
            return
        }



        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVStorageSystemCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

        $ListofStorageSystem  = import-csv $tempfile

        foreach ($StS in $ListofStorageSystem)
        {
            $StorageHostName         = $StS.StorageHostName
            $StorageFamilyName       = $Sts.StorageFamilyName

            $StorageAdminname        = $StS.StorageAdminName
            $StorageAdminPassword    = $StS.StorageAdminPassword

            $IsStoreServ             = $StorageFamilyName -eq 'StoreServ'
            $IsStoreVirtual          = $StorageFamilyName -eq 'StoreVirtual'
                  
            if ($IsStoreServ)
            {
                $StorageDomainName   = $StS.StorageDomainName
                $StoragePorts        = $Sts.StoragePorts
                $PortsArray          = if ($StoragePorts) { $StoragePorts.Split($sepChar).Trim() } else {@()}
            }
            else
            {   
                $StorageVIPS         = $StS.StorageVIPS
                $VIPSArray           =  if ($StorageVIPS) { $StorageVIPS.Split($SepChar).Trim() } else {@()}
            }


            $StoragePools            = $StS.StoragePools

            $PoolsArray              = if ($StoragePools) { $StoragePools.Split($sepChar).Trim()} else { @() }   
           


            
            if ( -not ( [string]::IsNullOrEmpty($StorageHostName) -or [string]::IsNullOrEmpty($StorageAdminName) ) )
            {
                
                $StorageSystemLists = Get-HPOVStorageSystem  
                foreach ($StorageSystem in $StorageSystemLists)
                {
                    # Change to library v3.10
                    #$sHostName = $StorageSystem.Credentials.ip_hostname
                    $sHostName = $StorageSystem.hostname
                    if ($sHostName -ieq $StorageHostName)
                          { break}
                    else  {$sHostName = "" }
                }

                if ($sHostName)
                {
                    write-host -foreground Yellow "Storage System $StorageHostName already exists. Skip adding storage system."
                }
                Else
                {
                    
                    $DomainParam = $PortsParam = $VIPSparam = $FamilyParam = $PortsParam = ""
                    $StorageSystemPorts = $StorageSystemVIPS = @()

                    if ($StorageFamilyName)
                        { $FamilyParam = " -Family $StorageFamilyName " }


                    if ($IsStoreServ)
                    {
                        # Add param for StorageSystemPorts
                        if ( -not [string]::IsNullOrEmpty($StorageDomainName))
                        {
                            $DomainParam = " -domain $StorageDomainName" 
                        }
                        else
                        {
                            $DomainParam = " -domain `'NO DOMAIN`' "
                        }

                        # Add param for StorageSystemPorts
                        $StorageSystemPorts = @{}
                        foreach ($p in $PortsArray)
                        {
                            $a= $p.Split("=").Trim()
                            $Port = $a[0]
                            $Netw = $a[1] 
                            $StorageSystemPorts.Add($port,$netw)
                        }

                        if ($StorageSystemPorts.Count -ne 0)
                        {
                            $PortsParam = " -ports `$StorageSystemPorts "
                        }

                    }

                    if ($IsStoreVirtual)
                    {
                        # Add Param for VIPS
                        $StorageSystemVIPS = @{}
                        foreach ($v in $VIPSArray)
                        {
                            $a   = $v.Split('=').Trim()
                            $IP  = $a[0]
                            $Net = $a[1]

                            try 
                            {
                                $ThisNet = get-HPOVNetwork -Name $Net -ErrorAction stop
                            }
                            Catch [HPOneView.NetworkResourceException]
                            {
                                $ThisNet   = $NULL
                            }
                    
                          
                            if ($IP)
                            {
                                $StorageSystemVIPS.Add($IP, $ThisNet)
                            }
                            else
                            {
                                write-host -foreground YEllow " Either VIPS IP address is not specified or network name $net does not exist. Skip creating VIPS..." 
                            }
                        }

                        if ($StorageSystemVIPS)
                        {
                            $VIPSparam = " -VIPS `$StorageSystemVIPS "
                        }



                    }


                    $Cmds= "Add-HPOVStorageSystem -hostname $StorageHostName -username $StorageAdminName  -password $StorageAdminPassword $FamilyParam $DomainParam $PortsParam $VIPSparam "
              
                    


                    write-host -foreground Cyan "-------------------------------------------------------------"
                    write-host -foreground Cyan "Adding storage system $StorageHostName                       "
                    write-host -foreground Cyan "-------------------------------------------------------------"                                


                    try 
                    {
                         Invoke-Expression $Cmds | Wait-HPOVTaskComplete
                    }
                    catch 
                    {
                        write-host -foreground YELLOW " Cannot add storage system $StorageHostName. Check credential,connectivity and state of storage system"   
                    }
                           



                    #Wait for the storage system to be fully discovered in OneView
                    start-sleep -seconds 60
                    
                    if ($PoolsArray)
                    {
                        ##
                        ## Add StoragePools
                        ##
                        ## Change to 3.10 library - Now IP address is exposed through HostName
                        #$ThisStorageSystem = Get-HPOVStorageSystem | where {$_.credentials.ip_hostname -eq $StorageHostName}

                        $ThisStorageSystem = Get-HPOVStorageSystem | where hostname -eq $StorageHostName
                        $UnManagedPools    = @()

                        if (($ThisStorageSystem) -and ($ThisStorageSystem.deviceSpecificAttributes.ManagedDomain))
                        {
                            ## Change to 3.10 library - Now need StoragePoolUri

                            #$UnManagedPools = $ThisStorageSystem.UnManagedPools.GetEnumerator() | select -ExpandProperty name

                            $spuri           = $ThisStorageSystem.storagePoolsUri
                            $StoragePools    = Send-HPOVRequest -uri $spuri
                            $UnManagedPools  = $StoragePools.Members | where isManaged -eq $False 
                            
                            if ($UnManagedPools)
                            {
                              $UnManagedPools  = $UnManagedPools.Name 
                              $UnManagedPools  = $UnManagedPools.Trim()
                            }

                          

                            foreach ($PoolName in $PoolsArray)
                            {
                                if ( $UnManagedPools.contains($PoolName))
                                {
                                    write-host -foreground Cyan "-------------------------------------------------------------"
                                    write-host -foreground Cyan "Adding Storage Pool $PoolName to StorageSystem $($ThisStorageSystem.Name) "
                                    write-host -foreground Cyan "-------------------------------------------------------------"
                                    $task = Add-HPOVStoragePool -StorageSystem $ThisStorageSystem -poolName $PoolName | Wait-HPOVTaskComplete
                                }
                                else
                                {
                                    write-host -ForegroundColor Yellow " Storage Pool Name $PoolName does not exist or already in Managed pools" 
                                }


                            }
                        }
                        
                        else
                        {
                            write-host -ForegroundColor Yellow " Storage System $StorageHostName does not exist or is un-managed. Cannot add storage pools...." 
                        }


                    }
                    else
                    {
                       write-host -ForegroundColor Yellow " Storage Pool Name is empty. Skip adding storage pool.... "
                    }





                }

            }
            else
            {
                write-host -foreground Yellow "Storage Name or username provided is empty. Skip adding storage system." 
            }


        }

}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVSANManager
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVSANManager {
<#
  .SYNOPSIS
    Add SAN MAnagers in OneView
  
  .DESCRIPTION
	Add SAN MAnagers in OneView
        
  .EXAMPLE
    Create-OVSANManager  -OVSANMAnagerCSV c:\Ov-SANManager.CSV 


  .PARAMETER OVSANManagerCSV
    Name of the CSV file containing SAN Manager definition


  .Notes
    NAME:  Create-OVSANManager
    LASTEDIT: 10/4/2016
    KEYWORDS: OV SAN Managers
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>
Param ([string]$OVSANManagerCSV ="D:\Oneview Scripts\OV-SANManager.csv")

    if ( -not (Test-path $OVSANManagerCSV))
    {
        write-host "No file specified or file $OVSANManagerCSV does not exist."
        return
    }


    # Read the CSV Users file
    $tempFile = [IO.Path]::GetTempFileName()
    type $OVSANManagerCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
    $ListofSANManagers = import-csv $tempfile

    foreach ($N in $ListofSANManagers)
    {
        $SANName       = $N.SANManagerName
        $ThisSanManager = Get-HPOVSanManager | where Name -eq $SANName
        if ( $ThisSanManager )
        {
            write-host -ForegroundColor Yellow "SAN Manager $SANName already existed, Skip creating it..."
        }

        else # SAN Name does not exist
        {
            $Type          = $N.Type

            switch ($Type)
            {
                { @('Brocade','BNA','Brocade Network Advisor') -contains $_ } 
                    {
                        $Username      = $N.Username
                        $Password      = $N.Password
                        $Port          = $N.Port
                        $UseSSL        =  ($N.UseSSL -ieq "Yes") 

                        # Add San Manager
                        write-host -foreground Cyan "-------------------------------------------------------------"
                        write-host -foreground Cyan "Adding SAN MAnager $SANName - Type: $Type ...."
                        write-host -foreground Cyan "-------------------------------------------------------------"
                        if ($useSSL)
                        {
                            Add-HPOVSANManager -hostname $SANName -Type $Type -Username $Username -password $Password -port $port -useSSL | wait-HPOVTaskComplete | FL
                        }
                        else 
                        {
                             Add-HPOVSANManager -hostname $SANName -Type $Type -Username $Username -password $Password -port $port  | wait-HPOVTaskComplete | FL
                           
                        }
                }

                { @("HPE","Cisco") -contains $_ } 
                    {
                        $Port          = $N.Port
                        
                        
                        $AuthLevel     = $N.snmpAuthLevel
                        $AuthProtocol  = $N.snmpAuthProtocol
                        $AuthPassword  = $N.snmpAuthPassword
                        $AuthUserName  = $N.snmpAuthUsername

                        $PrivProtocol  = $N.snmpPrivProtocol
                        if ($PrivProtocol -eq 'aes')
                            { $PrivProtocol = 'aes-128'}
                        $PrivPassword  = $N.snmpPrivPassword

                        if ($AuthLevel -eq "AuthOnly" -and 
                            (-not $AuthProtocol -or 
                            -not $AuthPassword))  
                        {
                            write-host -ForegroundColor Yellow "snmp Authentication is set to AuthOnly but no snmp password nor snmp protocol is provided. Skip adding SAN Manager $SANName...."    
                            break;
                        }

                        if ($AuthLevel -eq "AuthAndPriv" -and (
                            -not $AuthProtocol -or 
                            -not $AuthPassword -or 
                            -not $PrivProtocol -or 
                            -not $PrivPassword )) 
                        {
                            write-host -ForegroundColor Yellow "snmp Authentication is set to AuthAndPriv but no snmp Auth/Privpassword nor snmp Auth/Privprotocol is provided. Skip adding SAN Manager $SANName...."    
                            break;
                        }

                        
                        # Add San Manager
                        write-host -foreground Cyan "-------------------------------------------------------------"
                        write-host -foreground Cyan "Adding SAN MAnager $SANName - Type: $Type ...."
                        write-host -foreground Cyan "-------------------------------------------------------------"

                        $AuthCmds = " -snmpAuthLevel $AuthLevel -snmpUsername $AuthUsername -snmpAuthProtocol $AuthProtocol -snmpAuthPassword $AuthPassword "
                        $PrivCmds = ""
                        if ($PrivProtocol)
                            { $PrivCmds = " -snmpPrivProtocol $PrivProtocol  -snmpPrivPassword `$PrivPassword  " }


                        $Cmds = " Add-HPOVSANManager -hostname $SANName -Type $Type -port $port " + $AuthCmds 

                        if ($AuthLevel -eq "AuthAndPriv" )
                            { $Cmds += $PrivCmds }

                        Invoke-Expression $Cmds | wait-HPOVTaskComplete

                    }

            }
        }
        

    }

}



## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVStorageVolumeTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVStorageVolumeTemplate {
<#
  .SYNOPSIS
    Create OVStorageVolumeTemplate in OneView
  
  .DESCRIPTION
	Create OVStorageVolumeTemplate in OneView
        
  .EXAMPLE
    Create-OVStorageVolumeTemplate  -OVStorageVolumeTemplateCSV c:\OVStorage.CSV 


  .PARAMETER OVStorageVolumeTemplate
    Name of the CSV file containing Storage Volume Template definition


  .Notes
    NAME:  Create-OVStorageVolumeTemplate
    LASTEDIT: 10/06/2016
    KEYWORDS: OV Storage Volume Template
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>
Param ([string]$OVStorageVolumeTemplateCSV ="D:\Oneview Scripts\OVStorageVolumeTemplate.csv")

    if ( -not (Test-path $OVStorageVolumeTemplateCSV))
    {
        write-host "No file specified or file $OVStorageVolumeTemplateCSV does not exist."
        return
    }


    # Read the CSV Users file
    $tempFile = [IO.Path]::GetTempFileName()
    type $OVStorageVolumeTemplateCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
    $ListofStorageVolumeTemplates = import-csv $tempfile

    foreach ($SVT in $ListofStorageVolumeTemplates)
    {

        $Name          = $SVT.TemplateName
        $Description   = $SVT.Description
        $StoragePool   = $SVT.StoragePool
        $StsSystem     = $SVT.StorageSystem
        $SnapShotStP   = $SVT.SnapShotStoragePool
        $Capacity      = $SVT.Capacity

        $SharedParam   = if ($SVT.Shared -ieq 'Yes') { ' -shared' }  else {''}    
            
        $ProvType      = $SVT.ProvisionningType
        $ProvTypeParam = if ($ProvType) { " -ProvisionType $ProvType " } else { " -ProvisionType Thin "}
       
        $Description   = "`"" + $Description + "`""   # Surrounded with Quotes
        $StorageSystemParam = ""
        if ($StsSystem)
        {
            # Change to 3.10 library - Use Hostname instead of Credentials

            #$StorageSystem = get-hpovStorageSystem | where {$_.credentials.ip_hostname -eq $StsSystem}
            $StorageSystem = get-hpovStorageSystem | where hostname -eq $StsSystem
            
            if ($StorageSystem)
            {
                
                $StorageSystemParam = "  -StorageSystem `$StorageSystem" 
            }

        }
        if ($StoragePool)
        {
            $ThisSnapShotStoragePool = Get-HPOVStoragePool | where Name -eq $SnapShotStP
            if ($ThisSnapShotStoragePool)
                # Change for 3.10 library - StorageSystem is mandatory and StoragePool is object
                # {  $SnapShotParam = " -SnapShotStoragePool $SnapShotStp  " }
                {  $SnapShotParam = " -SnapShotStoragePool `$ThisSnapShotStoragePool  " }
            
            $ThisPool = Get-HPOVStoragePool | where Name -eq $StoragePool
            if ($ThisPool -and $Name)   # Name must be defined and Storage Pool must exist
            {
                $ThisTemplate = get-HPOVStorageVolumeTemplate | where Name -eq  $Name
                if ($ThisTemplate)
                {
                    write-host -ForegroundColor Yellow "Storage Volume Template $Name already existed, Skip creating it..."
                }
                else
                {
                 
                    write-host -foreground Cyan "-------------------------------------------------------------"
                    write-host -foreground Cyan "Creating Storage Volume Template $Name...."
                    write-host -foreground Cyan "-------------------------------------------------------------"

                    $ApplConnectParam = " -applianceConnection `$global:ApplianceConnection "

                    # Change for 3.10 library - StorageSystem is mandatory and StoragePool is object
                    #$SVTCmds = "New-HPOVStorageVolumeTemplate -Name $Name -description $Description -storagePool $StoragePool -capacity $Capacity  " `
                    #            + " $SnapShotParam $StorageSystemParam $SharedParam $provTypeParam $ApplConnectParam " 

                    $SVTCmds = "New-HPOVStorageVolumeTemplate -Name $Name -description $Description -storagePool `$ThisPool -capacity $Capacity  " `
                                + " $SnapShotParam $StorageSystemParam $SharedParam $provTypeParam $ApplConnectParam " 
               
                    $ThisSVT = Invoke-Expression $SVTCmds 
                    
                }

             }
             else
             {
                write-host -ForegroundColor Yellow "Template Name is empty or Storage Pool not specified nor existed..."
             }

        } #end Storagepool Not NULL
        else
        {
            write-host -ForegroundColor Yellow "Storage Pool not specified. Skip creating volumetemplate"
        }
    

    }
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVStorageVolume
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVStorageVolume {
<#
  .SYNOPSIS
    Create OVStorageVolume in OneView
  
  .DESCRIPTION
	Create OVStorageVolume in OneView
        
  .EXAMPLE
    Create-OVStorageVolume  -OVStorageVolumeCSV c:\OVStorageVolume.CSV 


  .PARAMETER OVStorageVolume
    Name of the CSV file containing Storage Volume  definition


  .Notes
    NAME:  Create-OVStorageVolume
    LASTEDIT: 01/13/2016
    KEYWORDS: OV Storage Volume 
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>
Param ([string]$OVStorageVolumeCSV,
       [string]$OVStorageVolumeTemplateCSV)

    if ( -not (Test-path $OVStorageVolumeCSV))
    {
        write-host "No file specified or file $OVStorageVolumeCSV does not exist."
        return
    }

    # Create Volume Templates if needed
    write-host -foreground Cyan "-------------------------------------------------------------"
    write-host -foreground Cyan "A - Creating Storage Volume Templates ......"
    write-host -foreground Cyan "-------------------------------------------------------------"
    if ($OVStorageVolumeTemplateCSV)
         {   Create-OVStorageVolumeTemplate -OVStorageVolumeTemplateCSV $OVStorageVolumeTemplateCSV }
    else {
            write-host "No file specified or storage volume template file $OVStorageVolumeTemplateCSV does not exist. Skip creating volume templates..."
        }


    write-host -foreground Cyan "-------------------------------------------------------------"
    write-host -foreground Cyan "B - Creating Storage Volumes ......"
    write-host -foreground Cyan "-------------------------------------------------------------"

    # Read the CSV Users file
    $tempFile = [IO.Path]::GetTempFileName()
    type $OVStorageVolumeCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
    $ListofStorageVolumes = import-csv $tempfile

    foreach ($SV in $ListofStorageVolumes)
    {
        $VolName       = $SV.VolumeName 
        $Description   = $SV.Description
        $StoragePool   = $SV.StoragePool
        $StsSystem     = $SV.StorageSystem
        
        $VolTemplate   = $SV.VolumeTemplate

        $Capacity      = $SV.Capacity
        $ProvTypeParam = if ($SV.ProvisionningType -ieq 'Thick') { ' -full' } else { ''}
        $SharedParam   = if ($SV.Shared -ieq 'Yes') { ' -shared' }  else {''}        

        
        if ($VolTemplate)
        {
            $ProvTypeParam    = ""
            $DescParam        = ""
            $stsSystemParam   = ""
            $StsPoolParam     = ""
            # Change to 3.10 library - Use object
            $ThisVolTemplate  = get-hpovstorageVolumeTemplate -name $VolTemplate
            #$VolTemplateParam = " -VolumeTemplate $VolTemplate "
            $VolTemplateParam = " -VolumeTemplate `$ThisVolTemplate " 
        }
        else
        {
            $VolTemplateParam = ""

            # Configure Desc param
            $DescParam = " -description `'$Description`'" 
            


            # Configure StorageSystem Param

            $StsSystemParam = ""
            if ($StsSystem)
            {
                # Change to 3.10 library - Use Hostname instead of Credentials

                #$StorageSystem = get-hpovStorageSystem | where {$_.credentials.ip_hostname -eq $StsSystem}
                $StorageSystem = get-hpovStorageSystem | where hostname -eq $StsSystem
                
                if ($StorageSystem)
                {
                    # Change to 3.10 library - Use object
                    #$StorageSystemName = $StorageSystem.Name
                    #$StsSystemParam = "  -StorageSystem `$StorageSystemName " 
                    $StsSystemParam = "  -StorageSystem `$StorageSystem " 
                }

            }
            
            # Configure StoragePool Param
            $StsPoolParam = $ThisPool = ""
              
            if ($StoragePool)
            { 
                $ListofPools = Get-HPOVStoragePool
                $ThisPool = Get-HPOVStoragePool | where name -eq  $StoragePool 
                 
                if ( $ThisPool )
                {
                    # Change to 3.10 library - Use object
                    #$stsPoolParam = " -StoragePool `$StoragePool " 
                    $stsPoolParam = " -StoragePool `$ThisPool " 
                }

            }
            
        }
            
        # either VolName must not be Null or Template not null or StoragePool not null
        if (!$VolName) 
        {
            write-host -ForegroundColor Yellow "Volume Name is empty or Storage Pool not specified nor existed..."
        }
        else # VolName specified
        {
            $SVCmds  = ""
             
            $ListofVols = Get-HPOVStorageVolume 
            $ThisVolume = $ListofVols  -match $VolName
            if ( $ThisVolume)
            {
                write-host -ForegroundColor Yellow "Volume $VolName already exists. Skip creating volumes...."
            }
            else
            {
                # Put VolName between quotes as it may have spaces
                $VolName = "`'$VolName`'" 

                if (!$VolTemplate)
                {
                    if (!$stsPoolParam)
                    {
                        write-host -ForegroundColor Yellow "Volume Template not specified and StoragePool not specified/not existed. Not enough information to create volumes. Skip it....."
                        
                    }
                    else # Use StoragePool 
                    {
                        $SVCmds = "New-HPOVStorageVolume -volumeName $VolName -applianceConnection `$global:ApplianceConnection  $descparam  $SharedParam  $stsPoolparam $stsSystemParam $ProvTypeparam -capacity $Capacity" 
 
                    }

                }
                else # Volume Template not NULL
                {
                    $ThisVolTemplate = Get-HPOVStorageVolumeTemplate -templateName $VolTemplate
                    if ( $ThisVolTemplate) # Volume Template exists 
                    {
                        $SVCmds = "New-HPOVStorageVolume -volumeName $VolName $VolTemplateParam -capacity $Capacity $SharedParam -applianceConnection `$global:ApplianceConnection  "               
                    }
                    else
                    {
                        write-host -ForegroundColor Yellow "Volume Template does not exist. Please create it first"
                    }

                                   
                } #end else Volume Template not NULL


                if ( $SVCmds)
                { 
                    write-host -foreground Cyan "-------------------------------------------------------------"
                    write-host -foreground Cyan "Creating Storage Volume $VolName...."
                    write-host -foreground Cyan "-------------------------------------------------------------"

                    Invoke-Expression $SVCmds | Wait-HPOVTaskComplete 
                }

            } # end else Volume exists



        } # End VolName empty

    

    }
}

#Endregion StorageSystemandVolume


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVAddressPool
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVAddressPool {
<#
  .SYNOPSIS
    Create Address Pool in OneView
  
  .DESCRIPTION
	Create Address Pool in OneView 
        
  .EXAMPLE
    .\Create-OVAddressPool  -OVAddressPoolCSV c:\OV-AddressPool.CSV
    

  .PARAMETER OVAddressPoolCSV
    Name of the CSV file containing Address Pool definition
	


  .Notes
    NAME:  Create-OVAddressPool
    LASTEDIT: 11/08/2016
    KEYWORDS: OV Address Pool
   
  .Link
     Http://www.hpe.com
 
 #Requires PS -Version 3.0
 #>

 Param ( [string]$OVAddressPoolCSV ="")

         if ( -not (Test-path $OVAddressPoolCSV))
        {
            write-host "No file specified or file $OVAddressPoolCSV does not exist."
            return
        }


        # Read the CSV  file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVAddressPoolCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

        $ListofAddressPool = import-csv -path $tempfile

        
        foreach ($AP in $ListofAddressPool)
        {
            $PoolName      = "'" + $AP.PoolName  + "'"
            $PoolType      = $AP.PoolType
            $RangeType     = $AP.RangeType 
            $StartAddress  = $AP.StartAddress
            $EndAddress    = $AP.EndAddress
            $NetworkID     = $AP.NetworkID
            $SubnetMask    = $AP.SubnetMask
            $Gateway       = $AP.Gateway
            $ListofDNS     = $AP.Dnsservers
            $DomainName    = $AP.DomainName

            
            if ($PoolType -eq "IPV4")  
            {
                if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
                {
                    if ($NetworkID -and $SubnetMask)
                    { 
                        $ThisSubnet = Get-HPOVAddressPoolSubnet | where NetworkId -eq $NetworkID 
                        if ($ThisSubnet -eq $NULL)
                        { # Create Subnet first
                            $CreateSubnetCmd = $DNScmd = ""
                            if ($NetworkID)  { $CreateSubnetCmd = "New-HPOVAddressPoolSubnet -networkID $NetworkID "} 
                            if ($subnetMask) { $CreateSubnetCmd += " -subnetmask $SubnetMask "} else {$CreateSubnetCmd = "" }
                            if ($Gateway)    { $CreateSubnetCmd += " -Gateway $gateway "}
                            if ($ListofDNS)  { $DnsServers = $ListofDNS.split($sepchar) ; $CreateSubnetCmd += " -DNSServers `$dnsservers "}
                            if ($DomainName) { $CreateSubnetCmd += " -domain $DomainName "} 
                            
                            if ( $CreateSubnetCmd) 
                                { 
                                    $ThisSubnet = invoke-expression $CreateSubnetCmd
                                } 
                        ### ????
                        }

                        if ($ThisSubnet)
                        {
                            $ThisPool = Get-HPOVAddressPoolRange | where name -eq $PoolName
                            if ($ThisPool -eq $NULL)
                            {
                                $createPoolCmd = "New-HPOVAddressPoolRange -IPV4Subnet `$Thissubnet "
                                if ($PoolName)      { $createPoolCmd += " -name $PoolName" }
                                if ($StartAddress)  { $createPoolCmd += " -start $StartAddress " }
                                if ($endAddress)    { $createPoolCmd += " -end $endAddress " }
                            }
                            else
                            {
                                write-host -foreground YELLOW "Pool Range $PoolName already exists. Skip creating it..."
                                $CreatePoolCmd = ""
                            }


                        }
                    }
                }
                else 
                { 
                    write-host -foreground YELLOW "Appliance is not a Synergy Composer. Skip creating IPV4 Address pool"
                }   
            }
            else # vWWN, vMAC, vSN
            {
                $ThisPool = Get-HPOVAddressPoolRange | where { ($_.StartAddress -eq $StartAddress) -and ($_.EndAddress -eq $EndAddress) }
                if ($ThisPool -eq $NULL)
                {
                    if ($RangeType -eq "Custom")
                        { $AddressCmd = " -PoolType $PoolType -RangeType $RangeType -Start $StartAddress -End $EndAddress " }
                
                    else 
                        { $AddressCmd = " -PoolType $PoolType -RangeType $RangeType  " }
                
                    $CreatePoolCmd = "New-HPOVAddressPoolRange $AddressCmd "
                }
                else
                {                        
                    write-host -foreground YELLOW "Pool Range $PoolName already exists. Skip creating it..."
                    $CreatePoolCmd = ""
                }
            }
            
            if ($CreatePoolCmd)
            {
                write-host -foreground CYAN "Creating Pool Range of type $PoolType"
                
                invoke-expression $CreatePoolCmd
            } 
            
            
        }


}



## -------------------------------------------------------------------------------------------------------------
##
##                     Function Create-OVDeploymentServer
##
## -------------------------------------------------------------------------------------------------------------

Function Create-OVDeploymentServer ([string]$OVOSDeploymentCSV)
{
        if ( -not (Test-path $OVOSDeploymentCSV))
        {
            write-host "No file specified or file $OVOSDeploymentCSV does not exist."
            return
        }


        # Read the CSV Users file
        $tempFile = [IO.Path]::GetTempFileName()
        type $OVOSDeploymentCSV | where { ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempfile   # Skip blank line

    
        $ListofOSDeploymentServers = import-csv $tempfile

        foreach ($OS in $ListofOSDeploymentServers)
        {
            $OSDeploymentServerName = $OS.DeploymentServerName
            $OSDescription          = $OS.Description
            $OSMgtNetwork           = $OS.ManagementNetwork
            $OSImageStreamer        = $OS.ImageStreamerAppliance.Trim('"')

            $ListofImageStreamer    = Get-HPOVImageStreamerAppliance | where ClusterUri -eq $NULL | where name -eq $OSImageStreamer 
            $ThisOSDeploymentServer = Get-HPOVOSDeploymentServer | where name -eq $OSDeploymentServerName

            if (  ($ListofImageStreamer -ne $NULL)  -and ($ThisOSDeploymentServer -eq $NULL) )  # if there is an ImageStreamer appliance and there  is no OS Deployment yet
            {

                $ApplianceNetConfig  = (Get-HPOVApplianceNetworkConfig).ApplianceNetworks

                $IPAddress           = $ApplianceNetConfig.virtIpv4Addr
                $IPSubnet            = $ApplianceNetConfig.ipv4Subnet
                $IPGateway           = $ApplianceNetConfig.ipv4Gateway

                $MaintIP1            = $ApplianceNetConfig.app1IPv4Addr
                $MaintIP2            = $ApplianceNetConfig.app2IPv4Addr

                $IPRange             =  Get-IPRange -ip $IPAddress -mask $IPSubnet

                $SubnetID            = [string]$IPRange[0]

                if ($MaintIP1 -and $MaintIP2)
                {
                    $ThisSubnetID        = get-HPOVAddressPoolSubnet | where networkID -eq $SubnetID
                    if ( ($ThisSubnetID) -and ($ThisSubnetID.subnetmask -eq $IPSubnet) -and ($ThisSubnetID.gateway -eq $IPGateway) )
                    {
                        $SubnetIDuri    = $ThisSubnetID.uri
                        $ThisMgtNetwork = Get-HPOVNetwork | where name -eq $OSMgtNetwork | where subneturi -eq $SubnetIDuri
                        if ($ThisMgtNetwork)
                        {
                      
                            #write-host " Results are: "
                            #write-host " a/ Subnet ID $SubnetID"
                            #write-host " b/ Managament network is $ThisMgtNetName "
                            #write-host " c/ Maintenace IP: $MaintIP1 --- $MaintIP2 "
                            #write-host " d/ Image Streamer are : $($ListofImageStreamer[0].Name) and  $($ListofImageStreamer[1].Name)"
                    
                    
                            write-host -foreground Cyan "-------------------------------------------------------------"
                            write-host -foreground Cyan "Adding OS Deployment Server  --> $OSDeploymentServerName ...."
                            write-host -foreground Cyan "-------------------------------------------------------------"
            
                
                            New-HPOVOSDeploymentServer -InputObject $ListofImageStreamer -Name $OSDeploymentServerName -Description $OSDescription -ManagementNetwork $ThisMgtNetwork | wait-HPOVTaskComplete | fl
            

                        }
                        else
                        {
                            write-host -ForegroundColor YELLOW "Subnet $SubnetID is not asociated with any network used for Streamer. Skip adding OS deployment server...."
                        }    
          
                    }
                    else
                    {
                        write-host -ForegroundColor YELLOW " Either SubnetID $SubnetID does not exist `n Or Subnet $IPSubnet does not match with AddressPoolsubnet $SubnetID `n Or gateway $IPgateway does not match with AddressPoolsubnet $SubnetID"
                        write-host -ForegroundColor YELLOW " Review addresspoolsubnet or appliance network settings and submit the request again....Skip adding OS Deployment Server.." 
                    }

                }
                else
                {
                    write-host -ForegroundColor YELLOW "Maintenance IP addresses are not fully configured in the appliance. Skip adding OS deployment server...."
                }

            }
    
            else
            {
                write-host -ForegroundColor YELLOW " Either there is no Image Streamer in the frame or the OS Deployment $OSDeploymentServerName already exists...Skip adding OS Deployment Server.."
            }



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
   
       $LoadedModule = get-module -listavailable $OneviewModule


       if ($LoadedModule -ne $NULL)
       {
            $LoadedModule = $LoadedModule.Name.Split('.')[0] + "*"
            remove-module $LoadedModule
       }

       import-module $OneViewModule
       

        # ---------------- Connect to OneView appliance
        #
        try 
        {
            
            write-host "`n Connect to the OneView appliance..."
            $global:ApplianceConnection = Connect-HPOVMgmt -appliance $OVApplianceIP -user $OVAdminName -password $OVAdminPassword -AuthLoginDomain $OVAuthDomain
        }
        catch 
        {
            write-host -foreground Yellow " Cannot connect to OneView.... Please check Host name, username and password for OneView.  "
        }  
            if ( ! [string]::IsNullOrEmpty($OVEthernetNetworksCSV) -and (Test-path $OVEthernetNetworksCSV) )
                {
                    Create-OVEthernetNetworks -OVEthernetNetworksCSV $OVEthernetNetworksCSV 
                }



            if ( ! [string]::IsNullOrEmpty($OVLogicalInterConnectGroupCSV) -and (Test-path $OVLogicalInterConnectGroupCSV) )
                {
                    Create-OVLogicalInterConnectGroup -OVLogicalInterConnectGroupCSV $OVLogicalInterConnectGroupCSV 
                }

            if ( ! [string]::IsNullOrEmpty($OVUpLinkSetCSV) -and (Test-path $OVUpLinkSetCSV) )
                {
                    Create-OVUplinkSet -OVUpLinkSetCSV $OVUplinkSetCSV 
                }

            
            if ( ! [string]::IsNullOrEmpty($OVEnclosureGroupCSV) -and (Test-path $OVEnclosureGroupCSV) )
                {
                    Create-OVEnclosureGroup -OVEnclosureGroupCSV $OVEnclosureGroupCSV 
                }

            if ( ($OVEnclosureCSV) -and (Test-path $OVEnclosureCSV) )
                {
                Create-OVEnclosure -OVEnclosureCSV $OVEnclosureCSV 
        
                }

            if ( ($OVLogicalEnclosureCSV) -and (Test-path $OVLogicalEnclosureCSV) )
                {
                
                Create-OVLogicalEnclosure -OVLogicalEnclosureCSV $OVLogicalEnclosureCSV 
        
                }

            if ( $OVServerCSV -and (Test-path $OVServerCSV) )
                    {
                    Create-OVServer -OVServerCSV $OVServerCSV 
            
                    }

            #Region Create Profiles        
            if ( ! [string]::IsNullOrEmpty($OVProfileCSV) -and (Test-path $OVProfileCSV) )
                    {
                        Create-OVProfile -OVProfileCSV $OVProfileCSV -OVProfileConnectionCSV $OVProfileConnectionCSV -OVProfileLOCALStorageCSV  $OVProfileLOCALStorageCSV -OVProfileSANStorageCSV  $OVProfileSANStorageCSV 
                    }


            if ( ($OVProfileConnectionCSV) -and (Test-path $OVProfileConnectionCSV) )
                {
                    #Create-OVProfileConnection  -ProfileConnectionCSV $OVProfileConnectionCSV -ProfileName "Template-BL460c-Gen9-1-Enc1" 
                }

            if ( $OVProfileTemplateCSV -and (Test-path $OVProfileTemplateCSV) )
                {
                    Create-OVProfileTemplate -OVProfileTemplateCSV $OVProfileTemplateCSV -OVProfileConnectionCSV $OVProfileConnectionCSV -OVProfileLOCALStorageCSV  $OVProfileLOCALStorageCSV -OVProfileSANStorageCSV  $OVProfileSANStorageCSV 
                }

            if ( $OVProfileFROMTemplateCSV -and (Test-path $OVProfileFROMTemplateCSV) )
                {
                    Create-OVProfileFROMTemplate -OVProfilefromTemplateCSV $OVProfileFROMTemplateCSV 
                }
           #endregion Create Profiles


            if ( ! [string]::IsNullOrEmpty($OVStorageSystemCSV) -and (Test-path $OVStorageSystemCSV) )
                {
                    Create-OVStorageSystem -OVStorageSystemCSV $OVStorageSystemCSV -OVFCNetworksCSV $OVFCNetworksCSV
                    $OVFCNetworksCSV = ""
                }

            if ( ! [string]::IsNullOrEmpty($OVFCNetworksCSV) -and (Test-path $OVFCNetworksCSV) )
                {
                    Create-OVFCNetworks -OVFCNetworksCSV $OVFCNetworksCSV 
                }  
                    
                
            if ( ! [string]::IsNullOrEmpty($OVSanManagerCSV) -and (Test-path $OVSanManagerCSV) )
                {
                Create-OVSanManager -OVSanManagerCSV $OVSanManagerCSV 
                }

            if ( ! [string]::IsNullOrEmpty($OVStorageVolumeTemplateCSV) -and (Test-path $OVStorageVolumeTemplateCSV) )
                {
                Create-OVStorageVolumeTemplate -OVStorageVolumeTemplateCSV $OVStorageVolumeTemplateCSV
                }

            if ( ! [string]::IsNullOrEmpty($OVStorageVolumeCSV) -and (Test-path $OVStorageVolumeCSV) )
                {
                Create-OVStorageVolume -OVStorageVolumeCSV $OVStorageVolumeCSV -OVStorageVolumeTemplateCSV $OVStorageVolumeTemplateCSV 
                }

            if ( ! [string]::IsNullOrEmpty($OVAddressPoolCSV) -and (Test-path $OVAddressPoolCSV) )
                {
                Create-OVAddressPool -OVAddressPoolCSV $OVAddressPoolCSV 
                }  

            if ( ! [string]::IsNullOrEmpty($OVOSDeploymentCSV ) -and (Test-path $OVOSDeploymentCSV ) )
                {
                Create-OVDeploymentServer -OVOSDeploymentCSV $OVOSDeploymentCSV 
                } 

            if ( ! [string]::IsNullOrEmpty($OVProfileSANStorageCSV) -and (Test-path $OVProfileSANStorageCSV) )
            {
            
                #Create-OVProfileSANStorage -ProfileSANStorageCSV $OVProfileSANStorageCSV -profileName 'Encl2-Bay12 Profile'
            }

            if ( ! [string]::IsNullOrEmpty($OVProfileLOCALStorageCSV) -and (Test-path $OVProfileLOCALStorageCSV) )
            {
                #Create-OVProfileLOCALStorage -ProfileLOCALStorageCSV $OVProfileLOCALStorageCSV -profileName 'Encl2-Bay12 Profile'
            }
            
            if ( $OVProfileConnectionCSV -and (Test-path $OVProfileConnectionCSV) )
            {
                #Create-OVProfileConnection -ProfileConnectionCSV $OVProfileConnectionCSV -profileName 'Template-BL460c-Gen8-1-Enc1'
            }


            



            # Clean up
            write-host -foreground Cyan "-----------------------------------------"
            write-host -foreground Cyan " Disconnect the OneView appliance........"
            write-host -foreground Cyan "-----------------------------------------"
            Disconnect-HPOVMgmt

     