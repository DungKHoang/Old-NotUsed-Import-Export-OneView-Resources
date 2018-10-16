##############################################################################
#
#   Import-OVResources.ps1
#
#   - Import resources to a OneView instance or Synergy Composer via CSV files
#
#   VERSION 1.0
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
     Import resources to OneView appliance.

  .DESCRIPTION
	 Import resources to OneView appliance.

  .EXAMPLE
    .\Import-OVResources.ps1 -All -OVApplianceIP 10.254.1.66 -OVAdminName Administrator -password <admin-password> -OVAuthDomain Local -OneViewModule HPOneView.410
    The script connects to the SynergyComposer or OneView appliance using HPOneView.410 POSH module and imports all OV resources from a set of pre-defined CSV files

    .\Import-OVResources.ps1 -OVEthernetnetworksCSV .\net.csv
    Import Ethernet networks from the net.csv file

    .\Import-OVResources.ps1 -OVFCnetworksCSV .\fc.csv
    Import FC networks from the fc.csv file

    .\Import-OVResources.ps1 -OVLogicalInterConnectGroupCSV .\lig.csv
    Import logical Interconnect Groups from the lig.csv file

    .\Import-OVResources.ps1 -OVUplinkSetCSV .\upl.csv
    Import Uplink Sets from the upl.csv file

    .\Import-OVResources.ps1 -OVEnclosureGroupCSV .\EG.csv
    Import EnclosureGroup from the EG.csv file

    .\Import-OVResources.ps1 -OVEnclosureCSV .\Enc.csv
    Import Enclosure from the Enc.csv file

    .\Import-OVResources.ps1 -OVProfileCSV .\profile.csv -OVProfileConnectionCSV .\connection.csv
    Import Server Profiles from the profile.csv and connection.csv files


  .PARAMETER OVApplianceIP                   
    IP address of the  Synergy Composer or OV appliance

  .PARAMETER OVAdminName                     
    Administrator name of the appliance

  .PARAMETER OVAdminPassword                 
    Administrator s password

  .PARAMETER OneViewModule
    OneView POSH module -default is HPOneView.410 

  .PARAMETER All
    Import all resources

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

  .PARAMETER OVLicense
    ASCII text file containing one or more OneView/Synergy FC licenses

  .PARAMETER DisableVSN
    Switch parameter to disable Virtual Serial Number Pools

  .PARAMETER OVBackupConfig
    Path to the CSV file containing the scheduled OneView backup configurations, minus the login password to the remote server

  .PARAMETER OVRSConfig
    Path to the CSV file containing the OneView Remote Support configuration

  .PARAMETER OVProxyCSV
    Path to the CSV file containing the OneView Proxy configuration

  .PARAMETER OVLdapCSV
    Path to the CSV file containing the OneView LDAP configuration

  .PARAMETER OVLdapGroupsCSV
    Path to the CSV file containing the LDAP Group configuration

#>
## -------------------------------------------------------------------------------------------------------------


Param ( [string]$OVApplianceIP                  = "", 
        [string]$OVAdminName                    = "", 
        [string]$OVAdminPassword                = "",
        [string]$OVAuthDomain                   = "local",
        [string]$OneViewModule                  = "HPOneView.410",
        
        [switch]$All,
        [switch]$DisableVSN,

        [string]$OVEthernetNetworksCSV              = "",
        [string]$OVFCNetworksCSV                    = "",
        [string]$OVNetworkSetCSV                    = "",

        [string]$OVLogicalInterConnectGroupCSV      = "",
        [string]$OVUpLinkSetCSV                     = "",
        [string]$OVEnclosureGroupCSV                = "",
        [string]$OVEnclosureCSV                     = "",
        [string]$OVLogicalEnclosureCSV              = "",

        [string]$OVDLServerCSV                      = "",

        [string]$OVProfileCSV                       = "",
        [string]$OVProfileConnectionCSV             = "",
        [string]$OVProfileLOCALStorageCSV           = "",
        [string]$OVProfileSANStorageCSV             = "",

        [string]$OVProfileTemplateCSV               = "",
        [string]$OVProfileTemplateConnectionCSV     = "",
        [string]$OVProfileTemplateLOCALStorageCSV   = "",
        [string]$OVProfileTemplateSANStorageCSV     = "",

        [string]$OVProfileFROMTemplateCSV           = "",

        [string]$OVSANManagerCSV                    = "",
        [string]$OVStorageSystemCSV                 = "",
        [string]$OVStorageVolumeTemplateCSV         = "",
        [string]$OVStorageVolumeCSV                 = "",

        [string]$OVAddressPoolCSV                   = "",
        [string]$OVWwnnCSV                          = "",
        [string]$OVIPAddressCSV                     = "",

        [string]$OVOSDeploymentCSV                  = "",

        [string]$OVLicense                          = "",
        [string]$OVTimeLocaleCSV                    = "",
        [string]$OVSmtpCSV                          = "",
        [string]$OVAlertsCSV                        = "",
        [string]$OVScopesCSV                        = "",
        [string]$OVUsersCSV                         = "",
        [string]$OVFWReposCSV                       = "",
        [string]$OVBackupConfig                     = "",
        [string]$OVRSConfig                         = "",
        [string]$OVProxyCSV                         = "",
        [string]$OVLdapCSV                          = "",
        [string]$OVLdapGroupsCSV                    = "",

        [int]$BayStart,
        [int]$BayEnd
)


$DoubleQuote    = '"'
$CRLF           = "`r`n"
$Delimiter      = "\"
$Sep            = ";"
$SepChar        = '|'
$CRLF           = "`r`n"
$OpenDelim      = "={"
$CloseDelim     = "}"
$CR             = "`n"
$Comma          = ','
$Equal          = '='


function Get-NamefromUri([string]$uri)
{
    $name = ""

    if (-not [string]::IsNullOrEmpty($Uri))
    {
        $name = (Send-HPOVRequest $Uri).Name
    }

    return $name
}


## -------------------------------------------------------------------------------------------------------------
##
##      IP Helper Functions
##
## -------------------------------------------------------------------------------------------------------------
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

    Param (
            [string]$start,
            [string]$end,
            [string]$ip,
            [string]$mask,
            [int]$cidr
    )

    function IP-toINT64 ()
    {
        Param ($ip)

        $octets = $ip.split(".")
        return [int64]([int64]$octets[0]*16777216 +[int64]$octets[1]*65536 +[int64]$octets[2]*256 +[int64]$octets[3])
    }

    function INT64-toIP()
    {
        Param ([int64]$int)

        return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring())
    }

    if ($ip) { $ipaddr = [Net.IPAddress]::Parse($ip) }
    if ($cidr) { $maskaddr = [Net.IPAddress]::Parse((INT64-toIP -int ([convert]::ToInt64(("1"*$cidr+"0"*(32-$cidr)),2)))) }
    if ($mask) { $maskaddr = [Net.IPAddress]::Parse($mask) }
    if ($ip) { $networkaddr = New-Object net.ipaddress ($maskaddr.address -band $ipaddr.address) }
    if ($ip) { $broadcastaddr = New-Object net.ipaddress (([system.net.ipaddress]::parse("255.255.255.255").address -bxor $maskaddr.address -bor $networkaddr.address)) }

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


## -------------------------------------------------------------------------------------------------------------
##
##      Function AddTo-NetworkSet
##
##      Internal function to add Networks to NetworkSet
##
## -------------------------------------------------------------------------------------------------------------
function AddTo-NetworkSet
{
    Param (
            [string]$ListNetworkSet,
            [string]$TypicalBandwidth,
            [string]$MaxBandwidth,
            [string]$NetworkName,
            [string]$LIG,
            [string]$UpLinkSet
    )

    $NetworkSetL   = $ListNetworkSet
    $NSTBandwidthL = $TypicalBandwidth
    $NSMBandwidthL = $MaxBandwidth

    #------------------ Add to NetworkSet if defined
    # Need NetworkSetL NSTBandwidthL NSMBandwidthL NetworkName
    #
    if ($NetworkSetL)
    {
        Write-Host -ForegroundColor Cyan "Checking relationship of network $NetworkName with NetworkSet ..."
        $NetworkSetList = $networkSetL.Split($SepChar)
        if ($NSTBandwidthL)
        {
            $NSTBandwidthList = $NSTBandwidthL.Split($SepChar)
        }

        if ($NSMBandwidthL)
        {
            $NSMBandwidthList = $NSMBandwidthL.Split($SepChar)
        }
    }

    foreach ($NetworkSetName in $NetworkSetList)
    {
        $ListofNetworks         = @()
        $ListofUnTaggedNetworks = @()

        try
        {
            $ThisNetwork        = Get-HPOVNetwork -name $NetworkName -ErrorAction Stop
        }
        catch [HPOneView.NetworkResourceException]
        {
            $ThisNetwork        = $NULL
        }

        if ($NetworkSetName)
        {
            try
            {
                $ThisNetworkSet = Get-HPOVNetworkSet -Name $NetworkSetName -ErrorAction stop
            }
            Catch
            {
                $ThisNetworkSet = $NULL
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

                    $ThisLIG   = Get-HPOVLogicalInterconnectGroup | Where-Object name -eq $LIG
                    if ($ThisLIG)
                    {
                        Write-Host -ForegroundColor Cyan "Adding network $NetworkName to UplinkSet $uplinkset...."
                        $ThisULset = $ThisLIG.UplinkSets | Where-Object Name -eq $UpLinkSet
                        if ($ThisULSet)
                        {
                            $ThisULSet.networkUris += $ThisNetwork.uri
                        }

                        Write-Host -ForegroundColor Cyan "Updating Logical Interconnect group $LIG...."
                        Set-HPOVResource $ThisLIG | Wait-HPOVTaskComplete

                        $ThisLI = Get-HPOVLogicalInterconnect | Where-Object logicalInterconnectGroupUri -match $ThisLIG.uri
                        if ($ThisLI)
                        {
                            $ThisLI | Update-HPOVLogicalInterconnect -Confirm:$false | Wait-HPOVTaskComplete
                        }
                    }
                } else {
                    Write-Host -ForegroundColor Yellow "  WARNING!!! Either Logical Interconnect Group not specified Or Uplinkset not specified..."
                    Write-Host -ForegroundColor Yellow "  Add new network to existing network set may fail if network set is used in profile..."
                }

                if ($ThisNetworkSet.NetworkUris -contains $ThisNetwork.uri)
                {
                    Write-Host -ForegroundColor Yellow "  NetworkSet $NetworkSetName already contains $NetworkName. Skip adding it..."
                } else {
                    Write-Host -ForegroundColor Cyan "Adding $NetworkName to networkset $NetworkSetName ..."

                    $ThisNetworkSet.NetworkUris += $ThisNetwork.uri
                    if ($ThisNetwork.ethernetNetworkType -eq 'Untagged')
                    {
                        $ThisNetworkSet.NativeNetworkUri += $ThisNetwork.uri
                    }

                    Set-HPOVNetworkSet -NetworkSet $ThisNetworkSet | Wait-HPOVTaskComplete
                }
            } else {
                Write-Host -ForegroundColor Cyan "Creating NetworkSet $NetworkSetName first..."

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
                {
                    $ListofUnTaggedNetworks = $ThisNetwork.Uri
                }

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
##      Function Disable-VSN
##
## -------------------------------------------------------------------------------------------------------------
function Disable-VSN
{
    <#
      .SYNOPSIS
        Disable Virtual Serial Number Pools

      .DESCRIPTION
        Disable Virtual Serial Number Pools

    #>

    $VSNPool = Get-HPOVAddressPool -Type VSN
    if ($VSNPool)
    {
        $DisablePools = $false
        foreach ($VP in $VSNPool)
        {
            if ($VP.enabled)
            {
                $DisablePools = $true
                #
                # If we detect any VSN pools are enabled, disable all of them
                #
                break
            }
        }

        if ($DisablePools)
        {
            Send-HPOVRequest -uri "/rest/id-pools/vsn" -method PUT -body @{'type' = 'Pool'; 'enabled' = 'false'}
        } else {
            Write-Host -ForegroundColor Yellow "  All Virtual Serial Number Pools already disabled, skipping..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Add-License
##
## -------------------------------------------------------------------------------------------------------------
function Add-License
{
    <#
      .SYNOPSIS
        Add OneView or Synergy FC Licenses

      .DESCRIPTION
        Add OneView or Synergy FC Licesnse from Licenses.txt file

      .PARAMETER OVLicense
        Name of the ASCII file containing OneView Licenses
    #>

    Param (
            [string]$OVLicense
    )

    $LicExists = Get-HPOVLicense
    if ($LicExists)
    {
        Write-Host -ForegroundColor Yellow "  Licenses are installed.  Skip importing licenses."
    } else {
        New-HPOVLicense -File $OVLicense
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Add-Firmware-Bundle
##
## -------------------------------------------------------------------------------------------------------------
function Add-Firmware-Bundle
{
    <#
      .SYNOPSIS
        Import Service Pack for ProLiant to OneView

      .DESCRIPTION
        Import Service Pack for ProLiant to OneView

      .PARAMETER OVFWBundleISO
        ISO Image of Service Pack for ProLiant
    #>

    Param (
            [string]$OVFWBundleISO
    )

    $FWBundleExists = Get-HPOVBaseline
    if ($FWBundleExists)
    {
        Write-Host -ForegroundColor Yellow "  Firmware Bundle is installed.  Skip importing FW Bundle."
    } else {
        Add-HPOVBaseline -File $OVFWBundleISO | Wait-HPOVTaskComplete
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-TimeLocale
##
## -------------------------------------------------------------------------------------------------------------
function Import-TimeLocale
{
    <#
      .SYNOPSIS
        Import Service Pack for ProLiant to OneView

      .DESCRIPTION
        Import Service Pack for ProLiant to OneView

      .PARAMETER OVTimeLocaleCSV
        CSV file containing Time and Locale information
    #>

    Param (
            [string]$OVTimeLocaleCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVTimeLocaleCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $DateLocaleList = Import-Csv -path $tempFile

    foreach ($TimeLocale in $DateLocaleList)
    {
        $Locale         = $TimeLocale.Locale
        $TimeZone       = $TimeLocale.TimeZone
        $SyncWithHost   = if ($TimeLocale.SyncWithHost -eq "TRUE") { $True } else { $False }
        $NtpServers     = $TimeLocale.NtpServers
    }

    $TimeConfig = ""
    $TimeConfig = Get-HPOVApplianceDateTime

    if ($TimeConfig.NtpServers)
    {
        Write-Host -ForegroundColor Yellow "  NTP Servers already configured, skipping..."
    } else {
        if ($TimeConfig.SyncWithHost -eq $SyncWithHost)
        {
            Write-Host -ForegroundColor Yellow "  Time already configured to SyncWithHost, skipping..."
        } else {
            $ListofNTP  = ""
            if ($NtpServers)
            {
                $ListofNTP = $NtpServers.split($SepChar)
                Write-Host -ForegroundColor Cyan "Configuring NTP Servers $ListofNTP..."
                Set-HPOVApplianceDateTime -Locale $Locale -NTPServers $ListofNTP
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-SMTP
##
## -------------------------------------------------------------------------------------------------------------
function Import-SMTP
{
    <#
      .SYNOPSIS
        Import SMTP settings

      .DESCRIPTION
        Import SMTP settings

      .PARAMETER OVSmtpCSV
        CSV file containing SMTP information
    #>

    Param (
            [string]$OVSmtpCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVSmtpCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $SmtpList = Import-Csv -path $tempFile

    if ($SmtpList)
    {
        $SmtpConfigured = Get-HPOVSMTPConfig
        if ($SmtpConfigured.senderEmailAddress)
        {
            Write-Host -ForegroundColor Yellow "  SMTP Email already configured, skipping..."
        } else {
            foreach ($SM in $SmtpList)
            {
                $Email          = $SM.SmtpEmail
                $Password       = $SM.SmtpPassword
                $Server         = $SM.SmtpServer
                $Port           = $SM.SmtpPort
                $Security       = $SM.SmtpSecurity
            }
            Set-HPOVSmtpConfig -SenderEmailAddress $Email -Server $Server -Port $Port -ConnectionSecurity $Security
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-LDAP
##
## -------------------------------------------------------------------------------------------------------------
function Import-LDAP
{
    <#
      .SYNOPSIS
        Import LDAP settings

      .DESCRIPTION
        Import LDAP settings

      .PARAMETER OVLdapCSV
        CSV file containing LDAP server and domain configuration
    #>

    Param (
            [string]$OVLdapCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVLdapCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $LDAPList = Import-Csv -path $tempFile

    # Import any Base64 Certificates in local directory *.cer files
    foreach ($_CertFile in Get-ChildItem -Path "*.cer")
    {
        $_CertName = $_CertFile.Name.TrimEnd(".cer")
        if (-not (Get-HPOVApplianceTrustedCertificate -Name $_CertName -ErrorAction SilentlyContinue))
        {
            Get-ChildItem -Path $_CertFile.Name | Add-HPOVApplianceTrustedCertificate -ErrorAction SilentlyContinue
        } else {
            Write-Host -ForegroundColor Yellow "  Certificate $_CertName is already present, skipping..."
        }
    }

    if ($LDAPList)
    {
        foreach ($LDIR in $LDAPList)
        {
            $LDdirname          = $LDIR.LDAPdirname
            $LdapConfigured     = Get-HPOVLdapDirectory -Name $LDdirname -ErrorAction SilentlyContinue

            if ($LdapConfigured)
            {
                Write-Host -ForegroundColor Yellow "  LDAP Directory $LDdirname is already configured, skipping..."
            } else {
                $LDprotocol     = $LDIR.LDAPprotocol
                $LDbaseDN       = $LDIR.LDAPbaseDN.Replace(".", ",")
                $LDuser         = $LDIR.LDAPuser
                $LDpass         = $LDIR.LDAPpass
                $LDbinding      = $LDIR.LDAPbinding
                $LDsvrIP        = $LDIR.LDAPsvrIP
                $LDsvrPort      = $LDIR.LDAPsvrPort

                if ($LDprotocol -eq "AD")
                {
                    $LDProtoCmd = " -AD "
                } else {
                    $LDProtoCmd = " -OpenLDAP "
                }

                if ($LDbinding -eq "SERVICE_ACCOUNT")
                {
                    $LDbindCmd  = " -ServiceAccount "
                } else {
                    $LDbindCmd  = ""
                }

                $SecurePass     = ConvertTo-SecureString -String $LDpass -AsPlainText -Force

                # Configure LDAP Server
                $LDAPSvr        = New-HPOVLdapServer -Hostname $LDsvrIP -SSLPort $LDsvrPort -TrustLeafCertificate

                # Configure LDAP Directory
                $Cmds = "New-HPOVLdapDirectory -Name `$LDdirname -BaseDN `$LDbaseDN -Servers `$LDAPSvr -Username `$LDuser -Password `$SecurePass " + $LDProtoCmd + $LDbindCmd
                Invoke-Expression $Cmds -ErrorAction Stop
            }
        }
        # Enable Local login
        Enable-HPOVLdapLocalLogin -Confirm: $false
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-Proxy
##
## -------------------------------------------------------------------------------------------------------------
function Import-Proxy
{
    <#
      .SYNOPSIS
        Import Proxy settings

      .DESCRIPTION
        Import Proxy settings

      .PARAMETER OVProxyCSV
        CSV file containing Proxy server configuration
    #>

    Param (
            [string]$OVProxyCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVProxyCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ProxyList = Import-Csv -path $tempFile

    if ($ProxyList)
    {
        $ProxyConfigured = Get-HPOVApplianceProxy
        if ($ProxyConfigured.Server)
        {
            Write-Host -ForegroundColor Yellow "  Proxy already configured, skipping..."
        } else {
            $ProtoCmd   = ""
            $UserCmd    = ""
            $PassCmd    = ""
            foreach ($PL in $ProxyList)
            {
                if ($PL.ProxyProtocol -eq "HTTPS")
                {
                    $ProtoCmd   = " -Https `$True "
                }

                if ($PL.ProxyUser)
                {
                    $UserCmd    = " -Username `$PL.ProxyUser "
                    $PassCmd    = " -Password (ConvertTo-SecureString -String `$PL.ProxyPasswd -AsPlainText -Force) "
                }

                $Server         = $PL.ProxyServer
                $Port           = $PL.ProxyPort

                $Cmds = "Set-HPOVApplianceProxy -Hostname `$Server -Port `$Port " + $ProtoCmd + $UserCmd + $PassCmd
                Invoke-Expression $Cmds -ErrorAction Stop
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-Alerts
##
## -------------------------------------------------------------------------------------------------------------
function Import-Alerts
{
    <#
      .SYNOPSIS
        Import SMTP Alert settings

      .DESCRIPTION
        Import SMTP Alert settings

      .PARAMETER OVAlertsCSV
        CSV file containing SMTP Alert information
    #>

    Param (
            [string]$OVAlertsCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVAlertsCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $AlertList = Import-Csv -path $tempFile

    if ($AlertList)
    {
        $AlertsConfigured = Get-HPOVSMTPConfig
        if ($AlertsConfigured.alertEmailFilters)
        {
            Write-Host -ForegroundColor Yellow "  SMTP Alerts already configured, skipping..."
        } else {
            foreach ($AL in $AlertList)
            {
                $AlertName      = $AL.AlertFilterName
                $AlertFilter    = $AL.AlertFilter
                $AlertEmails    = $AL.AlertEmails

                $ListofEmails  = ""
                if ($AlertEmails)
                {
                    $ListofEmails = $AlertEmails.split($SepChar)

                    if ($AlertFilter)
                    {
                        Add-HPOVSmtpAlertEmailFilter -Name $AlertName -Emails $ListofEmails -Filter $AlertFilter
                    } else {
                        Add-HPOVSmtpAlertEmailFilter -Name $AlertName -Emails $ListofEmails
                    }
                }
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-Scopes
##
## -------------------------------------------------------------------------------------------------------------
function Import-Scopes
{
    <#
      .SYNOPSIS
        Import Scope definitions

      .DESCRIPTION
        Import Scope definitions

      .PARAMETER OVScopesCSV
        CSV file containing Scope definitions
    #>

    Param (
            [string]$OVScopesCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVScopesCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ScopeList = Import-Csv -path $tempFile

    if ($ScopeList)
    {
        foreach ($SCOPE in $ScopeList)
        {
            $ScopeName      = $SCOPE.ScopeName
            $ScopeDesc      = $SCOPE.ScopeDescription
            $ScopeExists    = Get-HPOVScope -Name $ScopeName -ErrorAction SilentlyContinue
            if ($ScopeExists)
            {
                Write-Host -ForegroundColor Yellow "  Scope $ScopeName already exists. Skip creating scope..."
                continue
            } else {
                Write-Host -ForegroundColor Cyan "Creating Scope $ScopeName ...."
                $ThisScope      = New-HPOVScope -Name $ScopeName -Description $ScopeDesc
            }

            if ($ThisScope)
            {
                $ScopeArray     = @()
                $ScopeArray     = $SCOPE.ScopeResources.Split($Sep)
            }

            $ScopeResourceArray = @()
            foreach ($RES in $ScopeArray)
            {
                $ScopeMember    = $RES.Split($SepChar)
                $ScopeResName   = $ScopeMember[0]
                $ScopeResType   = $ScopeMember[1]

                if ($ScopeResName -like "*\ *")
                {
                    $ScopeResName = ($ScopeResName -replace "\\", ",")
                }

                Write-Host -ForegroundColor Cyan "Attempting to add resource to Scope $ScopeName - Type: $ScopeResType, Name: $ScopeResName"

                switch ($ScopeResType)
                {
                    { @('DriveEnclosureV2') -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVDriveEnclosure -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @('Enclosure') -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVEnclosure -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("EthernetNetwork", "FCNetwork", "FCoENetwork") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVNetwork -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("Interconnect") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVInterconnect -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("LogicalEnclosure") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVLogicalEnclosure -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("LogicalInterconnect") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVLogicalInterconnect -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("LogicalInterconnectGroup") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVLogicalInterconnectGroup -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("NetworkSet") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVNetworkSet -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("OSDeploymentPlan") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVOSDeploymentPlan -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("ServerHardware") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVServer -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("ServerProfile") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVServerProfile -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("ServerProfileTemplate") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVServerProfileTemplate -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("StoragePool") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVStoragePool -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("StorageVolume") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVStorageVolume -Name $ScopeResName -ErrorAction SilentlyContinue
                        }

                    { @("StorageVolumeTemplate") -contains $_ }
                        {
                            $ScopeResourceArray += Get-HPOVStorageVolumeTemplate -Name $ScopeResName -ErrorAction SilentlyContinue
                        }
                }
            }

            if ($ScopeResourceArray)
            {
                Get-HPOVScope -Name $ScopeName | Add-HPOVResourceToScope -InputObject $ScopeResourceArray
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-Users
##
## -------------------------------------------------------------------------------------------------------------
function Import-Users
{
    <#
      .SYNOPSIS
        Import SMTP Alert settings

      .DESCRIPTION
        Import SMTP Alert settings

      .PARAMETER OVUsersCSV
        CSV file containing User information
    #>

    Param (
            [string]$OVUsersCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVUsersCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $UserList = Import-Csv -path $tempFile

    if ($UserList)
    {
        foreach ($USER in $UserList)
        {
            #
            # Exclude administrator and HardwareSetup users.
            #
            $UserName       = $USER.UserName
            $ExcludeUsers  = "administrator", "HardwareSetup"
            if ($UserName -in $ExcludeUsers)
            {
                Write-Host -ForegroundColor Yellow "  Skipping System User $UserName..."
                continue
            }

            $UserExists     = Get-HPOVUser -Name $UserName -ErrorAction SilentlyContinue
            if ($UserExists)
            {
                Write-Host -ForegroundColor Yellow "  User $UserName already exists. Skipping user..."
                continue
            } else {
                Write-Host -ForegroundColor Cyan "Creating User $UserName ...."
            }

            $UserFullName   = if ($USER.UserFullName) { $USER.UserFullName } else { $false }
            $UserPassword   = $USER.UserPassword
            $UserEmail      = if ($USER.UserEmail) { $USER.UserEmail } else { $false }
            $UserOffPhone   = if ($USER.UserOfficePhone) { $USER.UserOfficePhone } else { $false }
            $UserMobPhone   = if ($USER.UserMobilePhone) { $USER.UserMobilePhone } else { $false }

            $UFNcmd         = ""
            if ($UserFullName)
            {
                if ($UserFullName -like '* *')
                {
                    $UserFullName = $DoubleQuote + $UserFullName + $DoubleQuote
                }
                $UFNcmd = " -FullName $UserFullName"
            }

            $UEmailcmd      = ""
            if ($UserEmail)
            {
                if ($UserEmail -like '* *')
                {
                    $UserEmail = $DoubleQuote + $UserEmail + $DoubleQuote
                }
                $UEmailcmd  = " -EmailAddress " + $UserEmail
            }

            $UOffPhcmd      = ""
            if ($UserOffPhone)
            {
                if ($UserOffPhone -like '* *')
                {
                    $UserOffPhone = $DoubleQuote + $UserOffPhone + $DoubleQuote
                }
                $UOffPhcmd  = " -OfficePhone " + $UserOffPhone
            }

            $UMobPhcmd      = ""
            if ($UserMobPhone)
            {
                if ($UserMobPhone -like '* *')
                {
                    $UserMobPhone = $DoubleQuote + $UserMobPhone + $DoubleQuote
                }
                $UMobPhcmd  = " -MobilePhone " + $UserMobPhone
            }

            #
            # Roles and Scopes processing
            #
            $Rolecmd        = ""
            $Scopecmd       = ""
            $ScopeName      = ""
            $RoleArray      = @()
            $UserRoles      = if ($USER.UserRoles) { $USER.UserRoles.split($Sep) }
            foreach ($ROLE in $UserRoles)
            {
                $a= $ROLE.Split($SepChar).Trim()
                $RoleName   = $a[0]
                $RoleScope  = $a[1]

                if ($RoleScope -eq "None" )
                {
                    $RoleArray += $RoleName
                    $Rolecmd    = " -Roles `$RoleArray"
                } else {
                    $ScopeExists    = Get-HPOVScope -Name $RoleScope -ErrorAction SilentlyContinue
                    if ($ScopeExists)
                    {
                        $ScopeName   = $RoleName
                        $Scopecmd    = " -ScopePermissions @{Role = `$ScopeName; Scope = `$ScopeExists}"
                    }
                }
            }

            if ($UserExists)
            {
                $Cmds = "Set-HPOVUser -UserName `$UserName" `
                      + $UFNcmd + $UEmailcmd + $UOffPhcmd + $UMobPhcmd + $Rolecmd + $Scopecmd
                Invoke-Expression $Cmds -ErrorAction Stop
            } else {
                $Cmds = "New-HPOVUser -UserName `$UserName -Password `$UserPassword" `
                      + $UFNcmd + $UEmailcmd + $UOffPhcmd + $UMobPhcmd+ $Rolecmd + $Scopecmd
                Invoke-Expression $Cmds -ErrorAction Stop
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-Groups
##
## -------------------------------------------------------------------------------------------------------------
function Import-Groups
{
    <#
      .SYNOPSIS
        Import LDAP Groups

      .DESCRIPTION
        Import LDAP Groups

      .PARAMETER OVUsersCSV
        CSV file containing LDAP Group information
    #>

    Param (
            [string]$OVLdapGroupsCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVLdapGroupsCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $GroupList = Import-Csv -path $tempFile

    if ($GroupList)
    {
        foreach ($GR in $GroupList)
        {
            $LDAPgroup      = $GR.LDAPGroupname
            $GroupExists    = Get-HPOVLdapGroup -Name $LDAPgroup -ErrorAction SilentlyContinue
            if ($GroupExists)
            {
                Write-Host -ForegroundColor Yellow "  Group '$LDAPgroup' already exists. Skipping group..."
                continue
            } else {
                Write-Host -ForegroundColor Cyan "Creating Group $LDAPgroup ...."
            }

            $LDAPdomain     = Get-HPOVLdapDirectory -Name $GR.LDAPGroupDomain
            $LDAPgroupObj   = Show-HPOVLdapGroups -Directory $LDAPdomain -GroupName $LDAPgroup
            $LDAPuser       = $GR.LDAPusername
            $LDAPpasswd     = $GR.LDAPpassword
            $SecurePass     = if ($LDAPpasswd -ne "***Info N/A***") { ConvertTo-SecureString -String $LDAPpasswd -AsPlainText -Force } else { "" }

            #
            # Roles and Scopes processing
            #
            $Rolecmd        = ""
            $Scopecmd       = ""
            $ScopeName      = ""
            $RoleArray      = @()
            $GroupRoles     = if ($GR.LDAPGroupRoles) { $GR.LDAPGroupRoles.split($Sep) }
            foreach ($ROLE in $GroupRoles)
            {
                $a= $ROLE.Split($SepChar).Trim()
                $RoleName   = $a[0]
                $RoleScope  = $a[1]

                if ($RoleScope -eq "None" )
                {
                    $RoleArray += $RoleName
                    $Rolecmd    = " -Roles `$RoleArray"
                } else {
                    $ScopeExists    = Get-HPOVScope -Name $RoleScope -ErrorAction SilentlyContinue
                    if ($ScopeExists)
                    {
                        $ScopeName   = $RoleName
                        $Scopecmd    = " -ScopePermissions @{Role = `$ScopeName; Scope = `$ScopeExists}"
                    }
                }
            }

            $Cmds = "New-HPOVLdapGroup -Directory `$LDAPdomain -Group `$LDAPgroupObj -Username `$LDAPuser -Password `$SecurePass " + $Rolecmd + $Scopecmd
            Invoke-Expression $Cmds -ErrorAction Stop
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-FWRepos
##
## -------------------------------------------------------------------------------------------------------------
function Import-FWRepos
{
    <#
      .SYNOPSIS
        Import External Firmware Repositories to OneView

      .DESCRIPTION
        Import External Firmware Repositories to OneView

      .PARAMETER OVFWReposCSV
        CSV file containing External FW Repository information
    #>

    Param (
            [string]$OVFWReposCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVFWReposCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $FWRepoList = Import-Csv -path $tempFile

    foreach ($FW in $FWRepoList)
    {
        $FWRepoName     = $FW.FWRepoName
        $FWRepoUrl	    = [uri]$FW.FWRepoUrl
        $FWRepoUser	    = if ($FW.FWRepoUserName -ne "***Info N/A***") { $FW.FWRepoUserName } else { "" }
        $FWRepoPass     = $FW.FWRepoPassword
        $SecurePass     = if ($FWRepoPass -ne "***Info N/A***") { ConvertTo-SecureString -String $FWRepoPass -AsPlainText -Force } else { "" }

        $FWRepoExists   = Get-HPOVBaselineRepository -Type External -ErrorAction SilentlyContinue
        if ($FWRepoExists)
        {
            Write-Host -ForegroundColor Yellow "  External Firmware Repository already configured, skipping..."
        } else {
            $Hostname   = $FWRepoUrl.Authority
            $Directory  = $FWRepoUrl.AbsolutePath
            $Scheme     = $FWRepoUrl.Scheme

            if ($Scheme -eq "http")
            {
                $HttpCmd = " -Http"
            } else {
                $HttpCmd = ""
            }

            if ($FWRepoName -like '* *')
            {
                $FWRepoName = $DoubleQuote + $FWRepoName + $DoubleQuote
            }

            if ($FWRepoUser)
            {
                $UserCmd = " -Username `$FWRepoUser "
            } else {
                $UserCmd = ""
            }

            if ($SecurePass)
            {
                $PassCmd = " -Password `$SecurePass "
            } else {
                $PassCmd = ""
            }

            if ($Directory -like '/*')
            {
                $Directory = $Directory.TrimStart('/')
            }
            $DirCmd = " -Directory `$Directory "

            $Cmds  = "New-HPOVExternalRepository -Name `$FWRepoName -Hostname `$Hostname" + $UserCmd + $PassCmd + $DirCmd + $HttpCmd
            Invoke-Expression $Cmds -ErrorAction Stop
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVAddressPool
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVAddressPool
{
    <#
      .SYNOPSIS
        Configure Address Pools

      .DESCRIPTION
        Configure Address Pools in OneView or Synergy Composer

      .PARAMETER OVAddressPoolCSV
        Name of the CSV file containing Address Pool definitions
    #>

    Param (
            [string]$OVAddressPoolCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVAddressPoolCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofAddressPool = Import-Csv -path $tempFile

    foreach ($AP in $ListofAddressPool)
    {
        $PoolName      = $AP.PoolName
        if ($PoolName -like '* *')
        {
            $PoolName  =   $DoubleQuote + $PoolName.Trim() + $DoubleQuote
        }

        $PoolType      = $AP.PoolType
        $RangeType     = $AP.RangeType
        $StartAddress  = $AP.StartAddress
        $EndAddress    = $AP.EndAddress
        $NetworkID     = $AP.NetworkID
        $SubnetMask    = $AP.SubnetMask
        $Gateway       = $AP.Gateway
        $ListofDNS     = $AP.DnsServers
        $DomainName    = $AP.DomainName

        if ($PoolType -eq "IPV4")
        {
            if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
            {
                if ($NetworkID -and $SubnetMask)
                {
                    $ThisSubnet = Get-HPOVAddressPoolSubnet | Where-Object NetworkId -eq $NetworkID
                    if ($ThisSubnet -eq $NULL)
                    {
                        $CreateSubnetCmd = ""
                        $DNScmd          = ""
                        if ($NetworkID)  { $CreateSubnetCmd = "New-HPOVAddressPoolSubnet -networkID $NetworkID " }
                        if ($subnetMask) { $CreateSubnetCmd += " -subnetmask $SubnetMask "} else { $CreateSubnetCmd = "" }
                        if ($Gateway)    { $CreateSubnetCmd += " -Gateway $gateway " }
                        if ($ListofDNS)  { $DnsServers = $ListofDNS.split($SepChar) ; $CreateSubnetCmd += " -DNSServers `$dnsservers " }
                        if ($DomainName) { $CreateSubnetCmd += " -domain $DomainName " }

                        if ($CreateSubnetCmd)
                        {
                            $ThisSubnet = Invoke-Expression $CreateSubnetCmd
                        }
                    }

                    if ($ThisSubnet)
                    {
                        $ThisPool = Get-HPOVAddressPoolRange | Where-Object name -eq $PoolName
                        if ($ThisPool)
                        {
                            Write-Host -ForegroundColor Yellow "  Pool Range $PoolName already exists. Skip creating it..."
                            $CreatePoolCmd = ""
                        }
                        else {
                            $CreatePoolCmd = "New-HPOVAddressPoolRange -IPV4Subnet `$Thissubnet "
                            if ($PoolName)      { $CreatePoolCmd += " -name $PoolName" }
                            if ($StartAddress)  { $CreatePoolCmd += " -start $StartAddress " }
                            if ($endAddress)    { $CreatePoolCmd += " -end $endAddress " }
                        }
                    }
                }
            }
            else {
                Write-Host -ForegroundColor Yellow "  Appliance is not a Synergy Composer. Skip creating IPV4 Address pool"
            }
        }
        else {
            $ThisPool = Get-HPOVAddressPoolRange | Where-Object { ($_.StartAddress -eq $StartAddress) -and ($_.EndAddress -eq $EndAddress) }
            if (-not $ThisPool)
            {
                if ($RangeType -eq "Custom")
                {
                    $AddressCmd = " -PoolType $PoolType -RangeType $RangeType -Start $StartAddress -End $EndAddress "
                }
                else {
                    $AddressCmd = " -PoolType $PoolType -RangeType $RangeType  "
                }
                $CreatePoolCmd = "New-HPOVAddressPoolRange $AddressCmd "
            }
            else {
                Write-Host -ForegroundColor Yellow "  Pool Range $PoolName already exists. Skip creating it..."
                $CreatePoolCmd = ""
            }
        }

        if ($CreatePoolCmd)
        {
            Write-Host -ForegroundColor Cyan "Creating Pool Range of type $PoolType"
            Invoke-Expression $CreatePoolCmd
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVEnclosure
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVEnclosure
{
    <#
      .SYNOPSIS
        Import and rename Enclosures in OneView

      .DESCRIPTION
        Import and rename Enclosures in Oneview

      .PARAMETER OVEnclosureCSV
        Name of the CSV file containing Enclosure definitions

    #>

    Param (
            [string]$OVEnclosureCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVEnclosureCSV | Where-Object {
        ($_ -notlike ",,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofEnclosure = Import-Csv $tempFile

    foreach ($Encl in $ListofEnclosure)
    {
        $EncName           = $Encl.EnclosureName
        $EncSN             = $Encl.EnclosureSN
        $OAIP              = $Encl.OAIPAddress
        $OAADminName       = $Encl.OAADminName
        $OAADminPassword   = $Encl.OAADminPassword
        $EnclGroupName     = $Encl.EnclosureGroupName
        $Licensing         = $Encl.LicensingIntent
        $FWBaseline        = $Encl.FWBaseline
        $FWForceInstallCmd = if ($Encl.FwInstall -eq 'Yes') { " -ForceInstallFirmware " } else { "" }
        $ForceAddCmd       = if (!($Encl.ForceAdd) -or ($Encl.ForceAdd -ieq 'Yes')) { " -Confirm:`$true " } else { " -Confirm:`$false " }
        $MonitoredCmd      = if ($Encl.MonitoredOnly -eq "Yes") { " -Monitored " } else { "" }

        #
        # C7000 enclosures will likely have an associated OA IP
        # Synergy enclosures will not.  Check for both.
        #
        if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
        {
            $EncExists = Get-HPOVEnclosure | Where-Object { ($_.serialNumber -eq $EncSN) }
            if ($EncExists)
            {
                $ThisEncName = $EncExists.name
                $ThisEncSN   = $EncExists.serialNumber
                if ( ($ThisEncName -eq $ThisEncSN) -and ($ThisEncName -ne $EncName) )
                {
                    #
                    # Synergy Frame is present but the name does not match the
                    # name in the CSV file.  Rename the frame to match.
                    #
                    Write-Host -ForegroundColor Cyan "Renaming Synergy Frame $ThisEncName to $EncName"
                    Set-HPOVEnclosure -Name $EncName -Enclosure $EncExists | Wait-HPOVTaskComplete
                } else {
                    Write-Host -ForegroundColor Yellow "  Synergy Frame $ThisEncName is already renamed.  Skipping..."
                }
            } else {
                Write-Host -ForegroundColor Yellow "  Synergy Frame $EncName not found.  Skipping rename..."
            }
        } else {
            ## TBD - to validate Licensing intent
            if ( -not ( [string]::IsNullOrEmpty($OAIP) -or              `
                        [string]::IsNullOrEmpty($OAAdminName) -or       `
                        [string]::IsNullOrEmpty($OAAdminPassword) -or   `
                        [string]::IsNullOrEmpty($EnclGroupName) -or     `
                        [string]::IsNullOrEmpty($Licensing) ) )
            {
                ## TBD _ Validate whether we can ping OA?
                $FWCmds = ""
                if ( -not ([string]::IsNullOrEmpty($FWBaseLine)) )
                {
                    $FWCmds = " -fwBaselineIsoFilename `$FWBaseLine  $FWForceInstallCmd "
                }
                $EnclGroupName = "`'$EnclGroupName`'"
                $Cmds = "New-HPOVEnclosure -applianceConnection `$global:ApplianceConnection -oa $OAIP -username $OAAdminName -password $OAAdminPassword -enclGroupName $EnclGroupName -license $Licensing $FWCmds $ForceAddCmd $MonitoredCmd"

                $EncExists = Get-HPOVEnclosure | Where-Object {($_.activeOaPreferredIP -eq $OAIP) -or ($_.standbyOaPreferredIP -eq $OAIP)}
                if ($EncExists)
                {
                    Write-Host -ForegroundColor Yellow "  Enclosure $OAIP already existed, skip creating it..."
                } else {
                    Write-Host -ForegroundColor Cyan "Importing Enclosure $OAIP ...."
                    Invoke-Expression $Cmds | Wait-HPOVTaskComplete
                }
            } else {
                Write-Host -ForegroundColor Yellow "  The following information is not correct `n `
                            Value: OAIP --> $OAIP --- OA Name is empty or OA credentials not provided `n `
                            or Value: Enclosure Group --> $EnclGroupName  ---  Enclosure Group Name is empty `n`
                            or Value: License --> $Licensing --- Licensing Intent is not specified as OneView or OneViewNoiLO `n `
                            Please provide correct information and re-run the script again."
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVSANManager
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVSANManager
{
    <#
      .SYNOPSIS
        Add SAN Managers in OneView

      .DESCRIPTION
        Add SAN Managers in OneView

      .PARAMETER OVSANManagerCSV
        Name of the CSV file containing SAN Manager definitions
    #>

    Param (
            [string]$OVSANManagerCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVSANManagerCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofSANManagers = Import-Csv $tempFile

    foreach ($N in $ListofSANManagers)
    {
        $SANName        = $N.SANManagerName
        $ThisSanManager = Get-HPOVSanManager | Where-Object name -eq $SANName

        if ($ThisSanManager)
        {
            Write-Host -ForegroundColor Yellow "  SAN Manager $SANName already exists, skip creating it..."
        } else {
            $Type          = $N.Type
            switch ($Type)
            {
                { @('Brocade','BNA','Brocade Network Advisor') -contains $_ }
                    {
                        $Username      = $N.Username
                        $Password      = $N.Password
                        $Port          = $N.Port
                        $UseSSL        =  ($N.UseSSL -ieq "Yes")

                        Write-Host -ForegroundColor Cyan "Adding SAN Manager $SANName - Type: $Type ...."
                        if ($useSSL)
                        {
                            Add-HPOVSANManager -hostname $SANName -Type $Type -Username $Username -password $Password -port $port -useSSL | Wait-HPOVTaskComplete | Format-List
                        } else {
                            Add-HPOVSANManager -hostname $SANName -Type $Type -Username $Username -password $Password -port $port | Wait-HPOVTaskComplete | Format-List
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
                        if ($PrivProtocol -eq 'aes'-or 'AES128')
                        {
                            $PrivProtocol = 'aes-128'
                        }

                        $PrivPassword  = $N.snmpPrivPassword

                        if ($AuthLevel -eq "AuthOnly" -and (
                            -not $AuthProtocol -or
                            -not $AuthPassword ))
                        {
                            Write-Host -ForegroundColor Yellow "  SNMP Authentication is set to AuthOnly but no SNMP password nor SNMP protocol is provided. Skip adding SAN Manager $SANName...."
                            break;
                        }

                        if ($AuthLevel -eq "AuthAndPriv" -and (
                            -not $AuthProtocol -or
                            -not $AuthPassword -or
                            -not $PrivProtocol -or
                            -not $PrivPassword ))
                        {
                            Write-Host -ForegroundColor Yellow "  SNMP Authentication is set to AuthAndPriv but no SNMP Auth/Privpassword nor SNMP Auth/Privprotocol is provided. Skip adding SAN Manager $SANName...."
                            break;
                        }

                        Write-Host -ForegroundColor Cyan "Adding SAN Manager $SANName - Type: $Type ...."

                        $AuthCmds = " -snmpAuthLevel $AuthLevel -snmpUsername $AuthUsername -snmpAuthProtocol $AuthProtocol -snmpAuthPassword $AuthPassword "
                        $PrivCmds = ""
                        if ($PrivProtocol)
                        {
                            $PrivCmds = " -snmpPrivProtocol $PrivProtocol  -snmpPrivPassword `$PrivPassword  "
                        }

                        $Cmds = " Add-HPOVSANManager -hostname $SANName -Type $Type -port $port " + $AuthCmds

                        if ($AuthLevel -eq "AuthAndPriv")
                        {
                            $Cmds += $PrivCmds
                        }

                        Invoke-Expression $Cmds | Wait-HPOVTaskComplete
                    }
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVEthernetNetworks
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVEthernetNetworks
{
    <#
      .SYNOPSIS
        Add Etheret Networks in OneView

      .DESCRIPTION
        Add Ethernet Networks in OneView

      .PARAMETER OVEthernetNetworksCSV
        Name of the CSV file containing Ethernet Network definitions
    #>

    Param (
            [string]$OVEthernetNetworksCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVEthernetNetworksCSV | Where-Object {
        ($_ -notlike ",,,,,,,,*") -and ($_ -notlike '"*') -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $CurrentNetworkSet   = ""
    $ListofNetworks      = @()

    $ListofNets          = Import-Csv $tempFile | Sort-Object NetworkSet

    foreach ($N in $ListofNets)
    {
        $NetworkSetL     = $N.NetworkSet
        if ($NetworkSetL -like '* *')
        {
            $NetworkSetL = $DoubleQuote + $NetworkSetL + $DoubleQuote
        }
        $NSTBandwidthL   = $N.NSTypicalBandwidth
        $NSMBandwidthL   = $N.NSMaximumBandwidth

        # ---- Used to update LIG and Uplink set if network set is already used in server profile
        $LIG             = $N.LogicalInterConnectGroup
        $ULSet           = $N.UplinkSet
        $NetworkName     = $N.NetworkName
        $vLanID          = $N.vLanID
        $Type            = if ($N.Type) { $N.Type } else { 'Ethernet' }
        $PBandwidth      = 1000 * $N.TypicalBandwidth
        $MBandwidth      = 1000 * $N.MaximumBandwidth
        $Purpose         = if ($N.Purpose) { $N.Purpose } else { 'General' }
        $SmartLink       = ($N.SmartLink -like 'Yes')
        $PLAN            = ($N.PrivateNetwork -like 'Yes')
        $vLANType        = if ($N.vLANType) { $N.vLANType } else { 'Tagged' }
        $SubnetID        = $N.Subnet
        $SubnetIDCmd     = ""

        if ($SubnetID)
        {
            $ThisSubnetID = Get-HPOVAddressPoolSubnet | Where-Object networkID -eq $SubnetID
            if ( ($ThisSubnetID) -and (-not ($ThisSubnetID.associatedResources)) )
            {
                $subnetIDCmd = " -subnet `$ThisSubnetID "
            }
            else {
                Write-Host -ForegroundColor Yellow "  SubnetID $SubnetID already associated to another network. Creating network without SubnetID...."
            }
        }

        if ($vLANType -eq 'Tagged')
        {
            if (($vLANID) -and ($vLANID -gt 0))
            {
                $vLANIDCmd = " -vLanID `$VLANID "
            }
        } else {
            $vLANIDCmd = ""
        }

        if ($PBandwidth)
        {
            $PBWCmd = " -typicalBandwidth `$PBandwidth "
        }

        if ($MBandwidth)
        {
            $MBWCmd = " -maximumBandwidth `$MBandwidth "
        }

        if ($NetworkName)
        {
            try
            {
                $ThisNetwork = Get-HPOVNetwork -Name $NetworkName -ErrorAction Stop
            }
            Catch [HPOneView.NetworkResourceException]
            {
                $ThisNetwork = $NULL
            }

            if ($ThisNetwork)
            {
                Write-Host -ForegroundColor Yellow "  Network $NetworkName already existed, Skip creating it..."
            }
            else {

                Write-Host -ForegroundColor Cyan "Creating Network $NetworkName...."
                $Cmds = "New-HPOVNetwork -name `$NetworkName -type `$Type -privateNetwork `$PLAN -smartLink `$SmartLink -VLANType `$VLANType" `
                        + $vLANIDCmd + $pBWCmd + $mBWCmd + $subnetIDCmd + " -purpose `$purpose "

                $ThisNetwork = Invoke-Expression $Cmds
            }
            AddTo-NetworkSet -ListNetworkSet $NetworkSetL -TypicalBandwidth $NSTBandwidthL -MaxBandwidth $NSMBandwidthL -NetworkName $NetworkName -LIG $LIG -uplinkset $ULSet
        }
        else {
            Write-Host -ForegroundColor Yellow "  Network name not specified, Skip creating it..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVFCNetworks
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVFCNetworks
{
    <#
      .SYNOPSIS
        Add Fibre Channel Networks in OneView

      .DESCRIPTION
        Add Fibre Channel Networks in OneView

      .PARAMETER OVFCNetworksCSV
        Name of the CSV file containing Fibre Channel Network definitions
    #>

    Param (
            [string]$OVFCNetworksCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVFCNetworksCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofFCNets = Import-Csv $tempFile

    foreach ($N in $ListofFCNets)
    {
        $NetworkName     = $N.NetworkName
        $Description     = $N.Description
        $FabricType      = $N.FabricType
        $Type            = $N.Type
        $PBandwidth      = 1000 * $N.TypicalBandwidth
        $MBandwidth      = 1000 * $N.MaximumBandwidth
        $LRedistribution = if ( $N.LoginRedistribution -eq 'Manual') { $False } else { $True }
        $LinkStability   = if ( $N.LinkStabilityTime ) { $N.LinkStabilityTime } else { 30 }
        $ManagedSAN      = $N.ManagedSAN
        $vLANID          = $N.vLANId

        if ( ($Type -eq 'FCOE') -and ($vLANID -eq $NULL) )
        {
            Write-Host -ForegroundColor Yellow "  Type is FCoE but no VLAN is specified. Skip creating this network $NetworkName "
        }
        else {
            $FCNetCmds = "New-HPOVNetwork -name `$NetworkName -type $Type -typicalBandwidth $PBandwidth -maximumBandwidth $MBandwidth "

            if ( $Type -eq 'FC')
            {
                $FCOECmds = ""
                $FCCmds   = " -FabricType `$FabricType "
                if ($FabricType -eq 'FabricAttach')
                {
                    $FCCmds += " -AutoLoginRedistribution `$LRedistribution -LinkStabilityTime `$LinkStability "
                }
            } else {
                $FCOECmds = " -vLANID `$VLANID "
                $FCCmds   = ""
            }

            $FCNetCmds += $FCOECmds + $FCCmds

            if ($ManagedSAN)
            {
                $ThisManagedSAN = Get-HPOVManagedSan | Where-Object name -eq $ManagedSAN
                if ($ThisManagedSAN)
                {
                    $FCNetCmds += " -ManagedSAN $ManagedSAN "
                }
            }

            try
            {
                $ThisNetwork = Get-HPOVNetwork -Name $NetworkName -ErrorAction Stop
            }
            Catch [HPOneView.NetworkResourceException]
            {
                $ThisNetwork = $NULL
            }

            if ($ThisNetwork)
            {
                Write-Host -ForegroundColor Yellow "  Network $NetworkName already existed, Skip creating it..."
            } else {
                Write-Host -ForegroundColor Cyan "Creating FC Network $NetworkName...."
                Invoke-Expression $FCNetCmds
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVStorageSystem
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVStorageSystem
{
    <#
      .SYNOPSIS
        Import 3PAR and StoreServe Storage Systems

      .DESCRIPTION
        Import 3PAR and StoreServe Storage Systems

      .PARAMETER OVStorageSystemCSV
        Name of the CSV file containing Storage System definitions

    #>

    Param (
            [string]$OVStorageSystemCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVStorageSystemCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofStorageSystem = Import-Csv $tempFile

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
            $PortsArray          = if ($StoragePorts) { $StoragePorts.Split($SepChar).Trim() } else {@() }
        } else {
            $StorageVIPS         = $StS.StorageVIPS
            $VIPSArray           = if ($StorageVIPS) { $StorageVIPS.Split($SepChar).Trim() } else {@() }
        }

        $StoragePools            = $StS.StoragePools
        $PoolsArray              = if ($StoragePools) { $StoragePools.Split($SepChar).Trim()} else { @() }

        if ( -not ( [string]::IsNullOrEmpty($StorageHostName) -or [string]::IsNullOrEmpty($StorageAdminName) ) )
        {
            $StorageSystemLists = Get-HPOVStorageSystem
            foreach ($StorageSystem in $StorageSystemLists)
            {
                $sHostName = $StorageSystem.hostname
                if ($sHostName -ieq $StorageHostName)
                {
                    break
                } else {
                    $sHostName = ""
                }
            }

            if ($sHostName)
            {
                Write-Host -ForegroundColor Yellow "  Storage System $StorageHostName already exists. Skip adding storage system."
            } else {
                $DomainParam = ""
                $PortsParam  = ""
                $VIPSparam   = ""
                $FamilyParam = ""
                $PortsParam  = ""
                $StorageSystemPorts = @()
                $StorageSystemVIPS  = @()

                if ($StorageFamilyName)
                {
                    $FamilyParam = " -Family $StorageFamilyName "
                }

                if ($IsStoreServ)
                {
                    if ( -not [string]::IsNullOrEmpty($StorageDomainName) )
                    {
                        $DomainParam = " -domain $StorageDomainName"
                    } else {
                        $DomainParam = " -domain `'NO DOMAIN`' "
                    }

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
                    $StorageSystemVIPS = @{}
                    foreach ($v in $VIPSArray)
                    {
                        $a   = $v.Split('=').Trim()
                        $IP  = $a[0]
                        $Net = $a[1]

                        try
                        {
                            $ThisNet = Get-HPOVNetwork -Name $Net -ErrorAction Stop
                        }
                        catch [HPOneView.NetworkResourceException]
                        {
                            $ThisNet   = $NULL
                        }

                        if ($IP)
                        {
                            $StorageSystemVIPS.Add($IP, $ThisNet)
                        } else {
                            Write-Host -ForegroundColor Yellow "  Either VIPS IP address is not specified or network name $net does not exist. Skip creating VIPS..."
                        }
                    }

                    if ($StorageSystemVIPS.Count)
                    {
                        $VIPSparam = " -VIPS `$StorageSystemVIPS "
                    } else {
                        #
                        # Empty VIPS array.  Manually construct an entry
                        # using the IP and Network in the StoragePorts
                        #
                        foreach ($p in $Sts.StoragePorts)
                        {
                            $a   = $p.Split('=').Trim()
                            $IP  = $a[0]
                            $Net = $a[1]
                        }
                        $ThisNet = Get-HPOVNetwork -Name $Net -ErrorAction Stop
                        $StorageSystemVIPS.Add($IP, $ThisNet)
                        $VIPSparam = " -VIPS `$StorageSystemVIPS "
                    }
                }

                $Cmds= "Add-HPOVStorageSystem -hostname $StorageHostName -username $StorageAdminName -password $StorageAdminPassword $FamilyParam $DomainParam $PortsParam $VIPSparam "
                Write-Host -ForegroundColor Cyan "Adding $StorageFamilyName storage system $StorageHostName"

                try
                {
                    Invoke-Expression $Cmds | Wait-HPOVTaskComplete
                }
                catch
                {
                    Write-Host -ForegroundColor Yellow "  Cannot add storage system $StorageHostName. Check credential, connectivity and state of storage system"
                }

                #Wait for the storage system to be fully discovered in OneView
                #Start-Sleep -Seconds 60

                if ($PoolsArray)
                {
                    $ThisStorageSystem = Get-HPOVStorageSystem | Where-Object hostname -eq $StorageHostName
                    $UnManagedPools    = @()

                    if (($ThisStorageSystem) -and ($ThisStorageSystem.deviceSpecificAttributes.ManagedDomain))
                    {
                        $spuri           = $ThisStorageSystem.storagePoolsUri
                        $StoragePools    = Send-HPOVRequest -uri $spuri
                        $UnManagedPools  = $StoragePools.Members | Where-Object isManaged -eq $False

                        if ($UnManagedPools)
                        {
                            $UnManagedPools  = $UnManagedPools.Name
                            $UnManagedPools  = $UnManagedPools.Trim()
                        }

                        foreach ($PoolName in $PoolsArray)
                        {
                            if ($UnManagedPools.contains($PoolName))
                            {
                                Write-Host -ForegroundColor Cyan "Adding Storage Pool $PoolName to StorageSystem $($ThisStorageSystem.Name)"

                                $task = Add-HPOVStoragePool -StorageSystem $ThisStorageSystem -poolName $PoolName | Wait-HPOVTaskComplete
                            } else {
                                Write-Host -ForegroundColor Yellow "  Storage Pool Name $PoolName does not exist or already in Managed pools"
                            }
                        }
                    } else {
                        Write-Host -ForegroundColor Yellow "  Storage System $StorageHostName does not exist, is un-managed, or has no un-managed pools. Cannot add storage pools...."
                    }
                } else {
                    Write-Host -ForegroundColor Yellow "  Storage Pool Name is empty. Skip adding storage pool...."
                }
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Storage Name or username provided is empty. Skip adding storage system."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVStorageVolumeTemplate
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVStorageVolumeTemplate
{
    <#
      .SYNOPSIS
        Create Storage Volume Templates in OneView

      .DESCRIPTION
        Create Storage Volume Templates in OneView

      .PARAMETER OVStorageVolumeTemplateCSV
        Name of the CSV file containing Storage Volume Template definitions

    #>

    Param (
            [string]$OVStorageVolumeTemplateCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVStorageVolumeTemplateCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofStorageVolumeTemplates = Import-Csv $tempFile

    foreach ($SVT in $ListofStorageVolumeTemplates)
    {
        $Name          = $SVT.TemplateName
        if ($Name -like '* *')
        {
            $Name           = $DoubleQuote + $Name.Trim() + $DoubleQuote
        }
        $Description        = $SVT.Description
        $StoragePool        = $SVT.StoragePool
        $StsSystem          = $SVT.StorageSystem
        $SnapShotStP        = $SVT.SnapShotStoragePool
        $Capacity           = $SVT.Capacity
        $Dedupe             = $SVT.Dedupe
        $ProvType           = $SVT.ProvisionningType
        $Protection         = $SVT.DataProtection
        $AOEnabled          = $SVT.AOEnabled

        $DescriptionParam   = ""
        $StorageSystemParam = ""
        $SnapShotParam      = ""
        $StoragePoolParam   = ""
        $ProtectionParam    = ""
        $AOEnabledParam     = ""

        $SharedParam        = if ($SVT.Shared -ieq "Yes")   { " -Shared" }                          else { "" }
        $ProvTypeParam      = if ($ProvType)                { " -ProvisionType $ProvType" }         else { " -ProvisionType Thin" }
        $DedupeParam        = if ($Dedupe -eq "Yes")        { " -EnableDeduplication `$True"}       else { "" }
        $ProtectionParam    = if ($Protection)              { " -DataProtectionLevel $Protection"}  else { "" }
        #
        # Adaptive Optimization flag is not working properly when reqeusting no AO
        #
        $AOEnabledParam     = if ($AOEnabled -eq "Yes")     { " -EnableAdaptiveOptimization"}       else { "" }

        if ($Description)
        {
            $DescriptionParam = " -Description `"$Description`""   # Surrounded with Quotes
        }

        if ($StsSystem)
        {
            $StorageSystem = Get-HPOVStorageSystem | Where-Object hostname -eq $StsSystem
            if ($StorageSystem)
            {
                $StorageSystemParam = " -StorageSystem `$StorageSystem"
            }
        }

        if ($StoragePool)
        {
            $ThisSnapShotStoragePool = Get-HPOVStoragePool -StorageSystem $StorageSystem | Where-Object Name -eq $SnapShotStP
            if ($ThisSnapShotStoragePool)
            {
                $SnapShotParam = " -SnapShotStoragePool `$ThisSnapShotStoragePool"
            }

            $ThisPool = Get-HPOVStoragePool -StorageSystem $StorageSystem | Where-Object Name -eq $StoragePool
            if ($ThisPool)
            {
                $StoragePoolParam = " -StoragePool `$ThisPool"
            }

            if ($ThisPool -and $Name)
            {
                $ThisTemplate = Get-HPOVStorageVolumeTemplate | Where-Object Name -eq $Name
                if ($ThisTemplate)
                {
                    Write-Host -ForegroundColor Yellow "  Storage Volume Template $Name already exists, skip creating it..."
                } else {
                    Write-Host -ForegroundColor Cyan "Creating Storage Volume Template $Name...."
                    $SVTCmds = "New-HPOVStorageVolumeTemplate -Name $Name $DescriptionParam $StoragePoolParam -Capacity $Capacity $SnapShotParam $StorageSystemParam $SharedParam $ProvTypeParam $DedupeParam $ProtectionParam $AOEnabledParam"
                    $ThisSVT = Invoke-Expression $SVTCmds
                }
            } else {
                Write-Host -ForegroundColor Yellow "  Template Name is empty or Storage Pool not specified nor existed..."
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Storage Pool not specified, skip creating volumetemplate..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVStorageVolume
##
## -------------------------------------------------------------------------------------------------------------

function Create-OVStorageVolume
{
    <#
      .SYNOPSIS
        Create Storage Volumes in OneView

      .DESCRIPTION
        Create Storage Volumes in OneView

      .PARAMETER OVStorageVolumeCSV
        Name of the CSV file containing Storage Volume definitions

    #>

    Param (
            [string]$OVStorageVolumeCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVStorageVolumeCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofStorageVolumes = Import-Csv $tempFile

    foreach ($SV in $ListofStorageVolumes)
    {
        $VolName       = $SV.VolumeName
        if ($VolName -like '* *')
        {
            $VolName   =   $DoubleQuote + $VolName.Trim() + $DoubleQuote
        }
        $Description        = $SV.Description
        $StoragePool        = $SV.StoragePool
        $StsSystem          = $SV.StorageSystem
        $VolTemplate        = $SV.VolumeTemplate
        $Capacity           = $SV.Capacity
        $SnapShotStP        = $SV.SnapShotStoragePool
        $Dedupe             = $SV.Dedupe
        $ProvType           = $SV.ProvisionningType
        $Protection         = $SV.DataProtection
        $AOEnabled          = $SV.AOEnabled
        $Shared             = $SV.Shared

        $ProvTypeParam      = if ($ProvType)                { " -ProvisionType `$ProvType" }         else { " -ProvisionType Thin" }
        $SharedParam        = if ($Shared -ieq "Yes")       { " -Shared" }                           else { "" }
        $DedupeParam        = if ($Dedupe -ieq "Yes")       { " -EnableDeduplication `$True" }       else { "" }
        $ProtectionParam    = if ($Protection)              { " -DataProtectionLevel `$Protection" } else { "" }
        $AOEnabledParam     = if ($AOEnabled -ieq "Yes")    { " -EnableAdaptiveOptimization" }       else { "" }
        $DescParam          = if ($Description)             { " -Description `$Description" }        else { "" }
        $StsSystemParam     = ""
        $StsPoolParam       = ""
        $StsSystemParam     = ""
        $VolTemplateParam   = ""
        $ThisPool           = ""
        $SVCmds             = ""

        if ($VolTemplate)
        {
            $ThisVolTemplate  = Get-HPOVStorageVolumeTemplate -name $VolTemplate
            if ($ThisVolTemplate)
            {
                $VolTemplateParam = " -VolumeTemplate `$ThisVolTemplate"
            }
        }

        if ($StsSystem)
        {
            $StorageSystem = Get-HPOVStorageSystem | Where-Object hostname -eq $StsSystem
            if ($StorageSystem)
            {
                $StsSystemParam = " -StorageSystem `$StorageSystem"
            }
        }

        if ($StoragePool)
        {
            $ThisPool = Get-HPOVStoragePool -StorageSystem $StorageSystem | Where-Object name -eq $StoragePool
            if ($ThisPool)
            {
                $StsPoolParam = " -StoragePool `$ThisPool"
            }
        }

        $ThisVolume = Get-HPOVStorageVolume | Where-Object name -eq $VolName
        if ($ThisVolume)
        {
            Write-Host -ForegroundColor Yellow "  Volume $VolName already exists, skip creating volume...."
        } else {
            $VolName = "`'$VolName`'"

            if (!$VolTemplate)
            {
                if (!$StsPoolParam)
                {
                    Write-Host -ForegroundColor Yellow "  Volume Template and StoragePool not specified or does not exist. Not enough information to create volume, skipping volume $VolName..."
                } else {
                    $SVCmds = "New-HPOVStorageVolume -VolumeName $VolName $DescParam $SharedParam $StsPoolParam $StsSystemParam $ProvTypeParam -Capacity $Capacity $DedupeParam $ProtectionParam $AOEnabledParam"
                }
            } else {
                $ThisVolTemplate = Get-HPOVStorageVolumeTemplate -templateName $VolTemplate
                if ($ThisVolTemplate)
                {
                    $SVCmds = "New-HPOVStorageVolume -VolumeName $VolName $DescParam $VolTemplateParam $ProvTypeParam -Capacity $Capacity $DedupeParam $ProtectionParam $AOEnabledParam"
                } else {
                    Write-Host -ForegroundColor Yellow "  Volume Template does not exist. Please create it first."
                }
            }

            if ($SVCmds)
            {
                Write-Host -ForegroundColor Cyan "Creating Storage Volume $VolName...."
                Invoke-Expression $SVCmds | Wait-HPOVTaskComplete
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVDeploymentServer
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVDeploymentServer
{
    <#
      .SYNOPSIS
        Import OS Deployment Servers

      .DESCRIPTION
        Import OS Deployment Servers

      .PARAMETER OVOSDeploymentCSV
        Name of the CSV file containing OS Deployment Server definitions

    #>

    Param (
            [string]$OVOSDeploymentCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVOSDeploymentCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofOSDeploymentServers = Import-Csv $tempFile

    foreach ($OS in $ListofOSDeploymentServers)
    {
        $OSDeploymentServerName = $OS.DeploymentServerName
        $OSDescription          = $OS.Description
        $OSMgtNetwork           = $OS.ManagementNetwork
        $OSImageStreamer        = $OS.ImageStreamerAppliance.Trim($DoubleQuote)

        $ListofImageStreamer    = Get-HPOVImageStreamerAppliance | Where-Object clusterUri -eq $NULL | Where-Object cimEnclosureName -eq $OSImageStreamer
        $ThisOSDeploymentServer = Get-HPOVOSDeploymentServer | Where-Object name -eq $OSDeploymentServerName
        if ($ThisOSDeploymentServer)
        {
            Write-Host -ForegroundColor Yellow "  OS Deployment Server '$OSDeploymentServerName' already exists, skip adding OS Deployment Server..."
        } else {
            if ($ListofImageStreamer)
            {
                $ApplianceNetConfig = (Get-HPOVApplianceNetworkConfig).ApplianceNetworks

                $IPAddress          = $ApplianceNetConfig.virtIpv4Addr
                $IPSubnet           = $ApplianceNetConfig.ipv4Subnet
                $IPGateway          = $ApplianceNetConfig.ipv4Gateway

                $MaintIP1           = $ApplianceNetConfig.app1IPv4Addr
                $MaintIP2           = $ApplianceNetConfig.app2IPv4Addr

                $IPRange            = Get-IPRange -ip $IPAddress -mask $IPSubnet
                $SubnetID           = [string]$IPRange[0]

                if ($MaintIP1 -and $MaintIP2)
                {
                    $ThisSubnetID   = Get-HPOVAddressPoolSubnet | Where-Object networkID -eq $SubnetID
                    if ( ($ThisSubnetID) -and ($ThisSubnetID.subnetmask -eq $IPSubnet) -and ($ThisSubnetID.gateway -eq $IPGateway) )
                    {
                        $SubnetIDuri    = $ThisSubnetID.uri
                        $ThisMgtNetwork = Get-HPOVNetwork | Where-Object name -eq $OSMgtNetwork | Where-Object subneturi -eq $SubnetIDuri
                        if ($ThisMgtNetwork)
                        {
                            Write-Host -ForegroundColor Cyan "Adding OS Deployment Server  --> $OSDeploymentServerName ...."
                            New-HPOVOSDeploymentServer -InputObject $ListofImageStreamer -Name $OSDeploymentServerName -Description $OSDescription -ManagementNetwork $ThisMgtNetwork | Wait-HPOVTaskComplete | Format-List
                        } else {
                            Write-Host -ForegroundColor Yellow "  Subnet $SubnetID is not associated with any network used for Image Streamer. Skip adding OS Deployment server..."
                        }
                    } else {
                        Write-Host -ForegroundColor Yellow "  Either SubnetID $SubnetID does not exist `n Or Subnet $IPSubnet does not match with AddressPoolsubnet $SubnetID `n Or gateway $IPgateway does not match with AddressPoolsubnet $SubnetID"
                        Write-Host -ForegroundColor Yellow "  Review addresspoolsubnet or appliance network settings and submit the request again....Skip adding OS Deployment Server.."
                    }
                } else {
                    Write-Host -ForegroundColor Yellow "  Maintenance IP addresses are not fully configured in the appliance. Skip adding OS Deployment server...."
                }
            } else {
                Write-Host -ForegroundColor Yellow "  There is no Image Streamer in the frame, skip adding OS Deployment Server..."
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-LogicalInterConnectGroup
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVLogicalInterConnectGroup
{
    <#
      .SYNOPSIS
        Configure Logical Interconnect Groups in OneView or Synergy Composer

      .DESCRIPTION
        Configure Logical Interconnect Groups in OneView or Synergy Composer

      .PARAMETER OVLogicalInterConnectGroupCSV
        Name of the CSV file containing Logical Interconnect Group definitions

    #>

    Param (
            [string]$OVLogicalInterConnectGroupCSV
    )

    #------------------- Interconnect Types
    $ICModuleTypes      = $ListofICTypes = @{
        "VirtualConnectSE40GbF8ModuleforSynergy"    =  "SEVC40f8";
        "Synergy20GbInterconnectLinkModule"         =  "SE20ILM";
        "Synergy10GbInterconnectLinkModule"         =  "SE10ILM";
        "VirtualConnectSE16GbFCModuleforSynergy"    =  "SEVC16GbFC";
        "Synergy12GbSASConnectionModule"            =  "SE12SAS"
    }

    $FabricModuleTypes  = @{
        "VirtualConnectSE40GbF8ModuleforSynergy"    =  "SEVC40f8";
        "Synergy12GbSASConnectionModule"            =  "SAS";
        "VirtualConnectSE16GbFCModuleforSynergy"    =  "SEVCFC";
    }

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVLogicalInterConnectGroupCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofLGs = Import-Csv $tempFile

    foreach ($L in $ListofLGs)
    {
        $LGName      = $L.LIGName
        if ($LGName  -like '* *')
        {
            $LGName = $DoubleQuote + $LGName  + $DoubleQuote
        }

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
            $BayConfigList = $L.BayConfig.Split($CRLF,[System.StringSplitOptions]::RemoveEmptyEntries)

            # Process configs per frame
            if ($ConfigType -eq '')  # If empty --> C7000
            {   # With 1 frame, we expect the syntax:  1='VC10'| 2='VC10'.... no Frame
                $BayConfigList = $BayConfigList.Split($SepChar)
                foreach($Config in $BayconfigList)
                {
                    $Key, $Value = $Config.Split('=')
                    $Key = [int32]$Key
                    if (-not $Value)
                    {
                        $Value = ""
                    }
                    $Bays.Add($Key,$Value)
                }

                #----- For C7000 Bays = Frames as there is only 1 frame
                $Frames = $Bays

                # -----------------------------------
                # Parameters that are valid for C7000 only
                #
                # Add FastMacCache parameters
                #
                $FastMacCacheParam = ""
                if ( $L.FastMacCacheFailover -like 'Yes')
                {
                    if ($L.MacRefreshInterval)
                    {
                        $FastMacCacheIntervalParam = " -macRefreshInterval $($L.MacReFreshInterval) "
                    } else {
                        $FastMacCacheIntervalParam = ""
                    }
                    $FastMacCacheParam = " -enableFastMacCacheFailover `$True "+ $FastMacCacheIntervalParam
                }

                # Add PauseFloodProtection parameter
                #
                if ($L.PauseFloodProtection -like 'No')
                {
                    $PauseFloodProtectionParam = " -enablePauseFloodProtection `$False "
                } else {
                    $PauseFloodProtectionParam = ""
                }

                # -------
                $RedundancyParam        = ""
                $FabricModuleTypeParam  = ""
                $FrameCountParam        = $ICBaySetParam = ""
            }
            else # Multi Frames scenarios
            {
                foreach ($Lconfig in $BayConfigList)
                {
                    $Bays               = @{}
                    $OneFrame, $Config  = $LConfig.Split('{')

                    # Store Bay Configs
                    $Config             = $Config -replace " ", ""  # Remove blank space
                    $Config             = $Config -replace ".{1}$"  # Replace closing bracket '}'
                    $BayLists           = $Config.Split($SepChar)

                    foreach ($BayConfig in $BayLists)
                    {
                        $Key,$Value= $BayConfig.Split('=')
                        $Value = $ICModuleTypes[$Value]

                        if (-not $Value)
                        {
                            $Value = ""
                        }
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
                {
                    $L.Redundancy       = "HighlyAvailable"
                }

                if ($L.Redundancy)
                {
                    $RedundancyParam    = " -FabricRedundancy $($L.Redundancy) "
                }

                $FabricModuleTypeParam  = " -FabricModuleType $ICType "
                $FrameCountParam        = " -FrameCount $FrameCount "
                $ICBaySetParam          = " -InterConnectBaySet $ICBaySet "

                # Parameters that are valid to C7000  only   ---> Nullify here
                $FastMacCacheParam = $PauseFloodProtectionParam =  ""
            }
        }

        # Add Igmp parameters
        #
        if ($L.IGMPSnooping -like 'Yes')
        {
            if ($L.IGMPIdletimeOut)
            {
                $IGMPIdleTimeoutParam = " -IgmpIdleTimeOutInterval $($L.IgmpIdleTimeout) "
            } else {
                $IGMPIdleTimeoutParam = ""
            }

            $IgmpCmds = "-enableIGMP `$True "+ $IGMPIdleTimeoutParam
        }
        else {
            $IgmpParam = ""
        }

        # Add NetworkLoopProtection parameter
        #
        if ($L.NetworkLoopProtection -like 'No')
        {
            $NetworkLoopProtectionParam = " -enableNetworkLoopProtection `$False "
        } else {
            $NetworkLoopProtectionParam = ""
        }

        # Add EnhancedLLDPTLV parameter
        #
        if ($L.EnhancedLLDPTLV -like 'No')
        {
            $EnhancedLLDPTLVParam = " -enableEnhancedLLDPTLV `$False "
        } else {
            $EnhancedLLDPTLVParam = " -enableEnhancedLLDPTLV `$True "
        }

        # Add EnableLLDPTagging parameter
        #
        if ($L.LDPTagging -like 'No')
        {
            $LDPTaggingParam = " -EnableLLDPTagging `$False "
        } else {
            $LDPTaggingParam = " -EnableLLDPTagging `$True "
        }

        $LGExists = Get-HPOVLogicalInterconnectGroup | Where-Object Name -like $LGName
        if ($LGExists)
        {
            Write-Host -ForegroundColor Yellow "  Logical InterConnect $LGName already exists, skip creating it..."
        } else {
            Write-Host -ForegroundColor Cyan "Creating Logical InterConnect Group $LGName...."
            $Cmds = "New-HPOVLogicalInterConnectGroup -name `$LGName  " + " -Bays `$Frames " + `
                    $FabricModuleTypeParam + $RedundancyParam + $FrameCountParam + $ICBaySetParam  + `
                    $IgmpParam + $FastMacCacheParam + $NetworkLoopProtectionParam + $PauseFloodProtectionParam + `
                    $EnhancedLLDPTLVParam + $LDPTaggingParam
            Invoke-Expression $Cmds
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVUpLinkSet
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVUpLinkSet
{
    <#
      .SYNOPSIS
        Configure UpLink Sets in OneView

      .DESCRIPTION
        Configure UpLink Sets in Oneview

      .PARAMETER OVUpLinkSetCSV
        Name of the CSV file containing UpLink Set definitions

    #>

    Param (
            [string]$OVUpLinkSetCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVUpLinkSetCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofUpLinks = Import-Csv $tempFile

    foreach ($UL in $ListofUpLinks)
    {
        $LGName                   = $UL.LIGName
        $UpLinKSetName            = $UL.UpLinkSetName
        $UpLinkSetType            = $UL.UpLinkType
        $UpLinkSetPorts           = if ($UL.UplinkPorts) { ($UL.UpLinkPorts.Split($SepChar)).Trim() }
        $UpLinkSetNetworks        = if ($UL.Networks) { ($UL.Networks.Split($SepChar)).Trim() }
        $UpLinkSetNativeNetwork   = if ($UL.NativeEthernetNetwork) { $UL.NativeEthernetNetwork.Trim() }
        $UpLinkSetEthMode         = if ($UL.EthernetMode) { $UL.EthernetMode.Trim() } else { 'Auto' }
        $UpLinkSetLACPTimer       = if ($UL.LACPTimer) { $UL.LACPTimer.Trim() } else { 'Short' }
        $UplinkSetPrimaryPort     = $UL.PrimaryPort
        $UpLinkSetFCSpeed         = $UL.FCuplinkSpeed

        if ($UpLinkSetNativeNetwork)
        {
            if ( -not ($UpLinkSetNetworks -contains $UpLinkSetNativeNetwork) )
            {
                Write-Host -ForegroundColor Yellow "  Native network specified --> $UpLinkSetNativeNetwork is not member of list of networks $UpLinkSetNetworks"
                Write-Host -ForegroundColor Yellow "  Ignoring Native network"
                $UpLinkSetNativeNetwork    = ""
                $UpLinkSetNativeNetworkObj = $NULL
            } else {
                $UpLinkSetNativeNetworkObj = Get-HPOVNetwork -name $UpLinkSetNativeNetwork
            }
        }

        ## Get network objects rather than string
        $UpLinkSetNetworksArray  = @()
        foreach ($net in $UpLinkSetNetworks)
        {
            try
            {
                $netmember = Get-HPOVNetwork -name $net -ErrorAction stop
            }
            catch [HPOneView.NetworkResourceException]
            {
                $netmember = $NULL
            }

            if ($netmember)
            {
                $UpLinkSetNetworksArray += $netmember
            }
        }

        $LGExists = $ThisLIG =  Get-HPOVLogicalInterConnectGroup | Where-Object Name -eq $LGName
        if ($LGExists)
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
                Write-Host -ForegroundColor Yellow "  Uplink Set $UplinkSetname already exists in LIG --> $LGName.  Skipping..."
            } else {
                switch ($UpLinkSetType)
                {
                    'Ethernet'      { if (($UpLinkSetEthMode -ne ' Auto') -and ($UpLinkSetLACPTimer))
                                        {
                                            $NetPropertyCmds = " -EthMode $UpLinkSetEthMode "
                                            if ($UplinkSetPrimaryPort)
                                            {
                                                $NetPropertyCmds += " -PrimaryPort $UplinkSetPrimaryPort "
                                            }
                                        } else {
                                            $NetPropertyCmds = " -EthMode $UpLinkSetEthMode -LacpTimer $UpLinkSetLACPTimer "
                                        }
                                        if ( $UpLinkSetNativeNetwork)
                                        {
                                            $NetPropertyCmds  += " -NativeEthNetwork `$UpLinkSetNativeNetworkObj "
                                        }
                                    }

                    'FibreChannel'  { if ( !($UplinkSetFCSpeed) -or !( @(2,4,8) -contains $UplinkSetFCSpeed ))
                                        {
                                            $UplinkSetFCSpeed = 'Auto'
                                        }
                                        $NetPropertyCmds = " -fcUplinkSpeed $UplinkSetFCSpeed "
                                    }
                    default         {
                                        $NetPropertyCmds = ""
                                    }
                }
                Write-Host -ForegroundColor Cyan "Creating UpLinkSet $UpLinKSetName on LIG $LGName...."

                if ($UpLinkSetNetworksArray)
                {
                    $ULNetworkCmds = " -Networks `$UpLinkSetNetworksArray  "
                } else {
                    $ULNetworkCmds = ""
                    Write-Host -ForegroundColor Yellow "  Network list is empty. UplinkSet is created without network..."
                }

                if ($UpLinkSetPorts)
                {
                    $ULPortCmds = " -UplinkPorts `$UpLinkSetPorts  "
                } else {
                    $ULPortCmds = ""
                    Write-Host -ForegroundColor Yellow "  Uplink Ports list is empty. UplinkSet is created without uplink ports..."
                }

                $Cmds = "New-HPOVUplinkSet -Resource `$ThisLIG -name `$UpLinkSetName -Type `$UpLinkSetType   " `
                        + $ULNetworkCmds + $ULPortCmds + $NetPropertyCmds

                Invoke-Expression $Cmds | Wait-HPOVTaskComplete | Format-List
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Logical InterConnect Group $LGName does not exist, please create it first..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVEnclosureGroup
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVEnclosureGroup
{
    <#
      .SYNOPSIS
        Configure Enclosure Groups in OneView

      .DESCRIPTION
        Configure Enclosure Groups in Oneview

      .PARAMETER OVEnclosureGroupCSV
        Name of the CSV file containing Enclosure Group definitions
    #>

    Param (
            [string]$OVEnclosureGroupCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVEnclosureGroupCSV | Where-Object {
        ($_ -notlike ",,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofEnclosureGroup = Import-Csv $tempFile

    foreach ($EG in $ListofEnclosureGroup)
    {
        $EGName              = $EG.EnclosureGroupName
        if ($EGName -like '* *')
        {
            $EGName = $DoubleQuote + $EGName + $DoubleQuote
        }
        $EGDescription       = $EG.Description
        $EGEnclosureCount    = $EG.Enclosurecount
        $EGipv4Type          = if ($EG.IPv4AddressType) { $EG.IPv4AddressType } else { "DHCP" }
        $EGAddressPool       = $EG.AddressPool
        $EGDeployMode        = $EG.DeploymentNetworkType
        $EGDeployNetwork     = $EG.DeploymentNetwork
        $EGPowerMode         = $EG.PowerRedundantMode
        $EGLIGMapping        = $EG.LogicalInterConnectGroupMapping

        if ($EGName)
        {
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

                        if ($LIGName)
                        {
                            $LIGNameArray = $LiGName.Split($Sep)
                            $LIGObjArray  = @()

                            foreach ($LName in $LIGNameArray)
                            {
                                if ($LName)
                                {
                                    $ThisLIG = Get-HPOVLogicalInterConnectGroup | Where-Object name -eq $LName
                                    if ($ThisLIG)
                                    {
                                        $LIGObjArray += $ThisLIG
                                    } else {
                                        Write-Host -ForegroundColor Yellow "  Logical InterConnect Group $LName does not exist. Skip including it...."
                                    }
                                }
                            }

                            if ($Key -match '^\d')  # Validate whether LIGmapping is for C7000 1=Flex-10,2= Flex10....
                            {
                                $Key = [int32]$Key
                                $LIGObj = $LIGObjArray[0]
                            } else {                # This is for Synergy  @{FRame1=$LIG1,$SALig; Frame2=$LIG2,$SASLig}
                                $LIGOBj  =$LIGObjArray
                            }
                            $LIGHash.Add($Key,$LIGObj)
                        } else {
                                Write-Host -ForegroundColor Yellow "  Logical InterConnect Group $LIGName is not specified. Skip including it...."
                        }
                    } else {
                        $LIGHash = Get-HPOVLogicalInterConnectGroup -name $Config
                    }
                }
                $LIGMappingParam = " -LogicalInterconnectGroupMapping `$LIGHash  "
            } else {
                Write-Host -ForegroundColor Yellow "  No Logical Interconnect Group Mapping. Skip creating it..."
                $LIGMappingParam = ""
            }

            $DescParam = if ($Description) { " -Description $EGDescription " } else { "" }

            if ($global:ApplianceConnection.ApplianceType -eq 'Composer')
            {
                $Skip = $false
                $EGipv4Type = if ($EGipv4Type -eq 'ipPool') { 'AddressPool' } else { $EGipv4Type }
                $ipv4AddressPoolParam = " -IPv4AddressType $EGipv4Type "
                if  ($EGipv4Type -eq 'AddressPool')
                {
                    $AddressPool = Get-HPOVAddressPoolRange -type 'IPv4' | Where-Object name -eq $EGAddressPool
                    if ($AddressPool)
                    {
                        $ipv4AddressPoolParam += " -AddressPool `$AddressPool"
                    } else {
                        write-host -ForegroundColor Yellow "  IP Address Type is set to $EGipv4Type but there is no address pool named $EGAddressPool . SKip creating Enclosure Group $EGName"
                        $Skip = $True
                    }
                }

                $PowerModeParam = if ($PowerMode) { " -PowerRedundantMode $PowerMode " } else { "" }

                if ($EGEnclosureCount)
                {
                    $EGEnclosureCount = [int32]$EGEnclosureCount
                } else {
                    $EGEnclosureCount =  1
                }
                $EncCountParam  = " -EnclosureCount $EGEnclosureCount "
            } else {   # C7000
                $Skip = $false
                $ipv4AddressPoolParam = ""
                $EncCountParam = $PowerModeParam =  ""
            }

            if (-not $Skip)
            {
                $Cmds = "New-HPOVEnclosureGroup -name $EGName $DescParam $EncCountParam $PowerModeParam $LiGMappingParam  $ipv4AddressPoolParam "

                $EncGroupExists = Get-HPOVEnclosureGroup | Where-Object name -eq $EGName
                if ($EncGroupExists)
                {
                    Write-Host -ForegroundColor Yellow "  EnclosureGroup $EGName already exists, skip creating it..."
                } else {
                    Write-Host -ForegroundColor Cyan "Creating Enclosure Group $EGName ...."
                    $ThisEG = Invoke-Expression $Cmds
                }
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Enclosure Group Name is empty. Please provide a name..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVLogicalEnclosure
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVLogicalEnclosure
{
    <#
      .SYNOPSIS
        Create Logical Enclosures in OneView

      .DESCRIPTION
    	Create Logical Enclosures in Oneview

      .PARAMETER OVLogicalEnclosureCSV
        Name of the CSV file containing Logical Enclosure definitions
    #>

    Param (
            [string]$OVLogicalEnclosureCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVLogicalEnclosureCSV | Where-Object {
        ($_ -notlike ",,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofLogicalEnclosure = Import-Csv $tempFile

    foreach ($LE in $ListofLogicalEnclosure)
    {
        $Name           = $LE.LogicalEnclosureName
        $EnclName       = $LE.Enclosure
        $EncGroup       = $LE.EnclosureGroup
        $FWBaseline     = $LE.FWBaseline
        $FWInstall      = if ($FWBaseline) { $LE.FWInstall -eq 'Yes' } else { $False }
        #$ForceAdd       = $LE.ForceAdd -eq 'Yes'

        if ($EnclName)
        {
            $EnclosureArray = $EnclName.Split($Sep)
            $ThisEnclosure  = Get-HPOVEnclosure | Where-Object name -eq $EnclosureArray[0]
            if ($ThisEnclosure)
            {
                if ($EncGroup)
                {
                    $ThisEnclosureGroup = Get-HPOVEnclosureGroup | Where-Object Name -eq $EncGroup
                    if ($ThisEnclosureGroup)
                    {
                        $FWCmds = ""
                        if ($FWBaseline)
                        {
                            $ThisFWBaseline = Get-HPOVBaseline -file $FWBaseline
                            if ($ThisFWBaseline)
                            {
                                $FWCmds = " -FirmwareBaseline `$ThisFWBaseLine  "
                                if ($FWInstall)
                                {
                                    $FWCmds += " -ForceFirmwareBaseline "
                                }
                            }
                        } else {
                            Write-Host -ForegroundColor Yellow "  FW BaseLine not specified. Will not include FW BaseLine in Logical Enclosure..."
                        }
                        $ThisLogicalEnclosure = Get-HPOVLogicalEnclosure | Where-Object name -eq $Name
                        if ($ThisLogicalEnclosure)
                        {
                            Write-Host -ForegroundColor Yellow "  Logical Enclosure $Name already exists, skip creating Logical Enclosure..."
                        } else {
                            $Cmds  = "New-HPOVLogicalEnclosure -name $Name -Enclosure `$ThisEnclosure -EnclosureGroup `$ThisEnclosureGroup "
                            $Cmds += $FWCmds

                            Write-Host -ForegroundColor Cyan "Creating Logical Enclosure for enclosure $EnclName ...."
                            Invoke-Expression $Cmds
                        }
                    } else {
                        Write-Host -ForegroundColor Yellow "  Enclosure Group $EncGroup does not exist, skip creating Logical Enclosure..."
                    }
                } else {
                    Write-Host -ForegroundColor Yellow "  Enclosure Group name is empty, skip creating Logical Enclosure..."
                }
            } else {
                Write-Host -ForegroundColor Yellow "  Enclosure $EnclName does not exist, skip creating Logical Enclosure..."
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Enclosure name is empty, skip creating Logical Enclosure..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVDLServer
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVDLServer
{
    <#
      .SYNOPSIS
        Import ProLiant DL Server Hardware in OneView

      .DESCRIPTION
    	Import ProLiant DL Server Hardware in Oneview

      .PARAMETER OVDLServerCSV
        Name of the CSV file containing DL Server Hardware definitions

    #>

    Param (
            [string]$OVDLServerCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVDLServerCSV | Where-Object {
        ($_ -notlike ",,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofServers = Import-Csv $tempFile

    foreach ($s in $ListofServers)
    {
        $Server             = $s.ServerName
        if ($Server)
        {
            $ThisServer = Get-HPOVServer | Where-Object name -eq $server
            if ($ThisServer)
            {
                Write-Host -ForegroundColor Yellow "  Server $server already present in OneView, skip adding server..."
            } else {
                $ADminName          = $s.AdminName
                $ADminPassword      = $s.AdminPassword
                $Licensing          = $s.LicensingIntent
                $IsMonitored        = ($s.Monitored -eq 'Yes') -or ($Licensing -eq "")

                Write-Host -ForegroundColor Cyan "Adding Server $Server..."

                if ($IsMonitored)
                {
                    Add-HPOVServer -Hostname $server -Username $AdminName -Password $AdminPassword -Monitored | Wait-HPOVTaskComplete | Format-List
                } else {
                    Add-HPOVServer -Hostname $server -Username $AdminName -Password $AdminPassword -LicensingIntent $Licensing | Wait-HPOVTaskComplete | Format-List
                }
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Server name or IP address not provided, skip adding server..."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVProfileTemplate
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVProfileTemplate
{
    <#
      .SYNOPSIS
        Create Server Profile Template in OneView

      .DESCRIPTION
        Create Server Profile Template in OneView

      .PARAMETER OVProfileTemplateCSV
        Name of the CSV file containing definitions of server profile Template

      .PARAMETER OVProfileConnectionCSV
        Name of the CSV file containing definitions of Connections (Ethernet or Fibre Channel) associated to Server Profile Template

      .PARAMETER OVProfileLOCALStorageCSV
        Name of the CSV file containing definitions of Local Storage Volumes associated to Server Profile Template

      .PARAMETER OVProfileSANStorageCSV
        Name of the CSV file containing definitions of SAN Storage Volumes associated to Server Profile Template

    #>

    Param (
            [string]$OVProfileTemplateCSV,
            [string]$OVProfileTemplateConnectionCSV,
            [string]$OVProfileTemplateLOCALStorageCSV,
            [string]$OVProfileTemplateSANStorageCSV
    )

    Create-ProfileOrTemplate -OVProfileTemplateCSV $OVProfileTemplateCSV -OVProfileConnectionCSV $OVProfileTemplateConnectionCSV -OVProfileLOCALStorageCSV $OVProfileTemplateLOCALStorageCSV -OVProfileSANStorageCSV $OVProfileTemplateSANStorageCSV
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-ProfileOrTemplate
##
## -------------------------------------------------------------------------------------------------------------
function Create-ProfileOrTemplate
{
    <#
      .SYNOPSIS
        Create Server Profile Template in OneView

      .DESCRIPTION
        Create Server Profile Template in OneView

      .PARAMETER OVProfileTemplateCSV
        Name of the CSV file containing definitions of server profile Template

      .PARAMETER OVProfileConnectionCSV
        Name of the CSV file containing definitions of Connections (Ethernet or Fibre Channel) associated to Server Profile Template

      .PARAMETER OVProfileLOCALStorageCSV
        Name of the CSV file containing definitions of Local Storage Volumes associated to Server Profile Template

      .PARAMETER OVProfileSANStorageCSV
        Name of the CSV file containing definitions of SAN Storage Volumes associated to Server Profile Template

      .PARAMETER CreateProfile
        Distinguish between creating a Server Profile or a Server Profile Template

    #>

    Param (
            [string]$OVProfileTemplateCSV,
            [string]$OVProfileConnectionCSV,
            [string]$OVProfileLOCALStorageCSV,
            [string]$OVProfileSANStorageCSV,
            [switch]$CreateProfile
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVProfileTemplateCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofProfileTemplate = Import-Csv $tempFile

    foreach ($SPT in $ListofProfileTemplate)
    {
        $Proceed = $True

        if ($CreateProfile)
        {
            $ProfileName     = $SPT.ProfileName
            if ($ProfileName -like '* *')
            {
                $ProfileName        = $DoubleQuote + $ProfileName.Trim() + $DoubleQuote
            }

            $EncName                = $SPT.Enclosure
            $Bay                    = $SPT.EnclosureBay
            $AssignType             = $SPT.AssignmentType
            $Server                 = $SPT.Server.Trim() -replace $DoubleQuote,''
            $ServerTemplate         = $SPT.ServerTemplate
            $ProfileTemplateName    = $ProfileName

            if ($ServerTemplate)
            {
                $TemplatetoCreateFrom = Get-HPOVServerProfileTemplate -name $ServerTemplate -ErrorAction SilentlyContinue
                if ($TemplatetoCreateFrom)
                {
                    $ServerTemplateToCreateFromCmds = " -ServerProfileTemplate `$TemplatetoCreateFrom "
                } else {
                    Write-Host -ForegroundColor Yellow "  Server Profile Template $ServerTemplate does not exist. Cannot create Server Profile from this template"
                    continue
                }
            }
        } else {
            $ProfileTemplateName    = $DoubleQuote + $SPT.ProfileTemplateName.Trim() + $DoubleQuote
            $ServerPDescription     = $DoubleQuote + $SPT.ServerProfileDescription + $DoubleQuote
        }

        $Description                = $DoubleQuote + $SPT.Description + $DoubleQuote
        $SHType                     = $SPT.ServerHardwareType
        $EnclGroup                  = $SPT.EnclosureGroup
        $Affinity                   = if ($SPT.Affinity) { $SPT.Affinity } else { 'Bay' }
        $BootMode                   = if ($SPT.BootMode) { $SPT.BootMode } else { 'BIOS' }
        $BootOrderArray             = if ($SPT.BootOrder) { $SPT.BootOrder.Split($SepChar) } else { $NULL }
        $BIOSSettings               = $SPT.BIOSSettings
        $FWEnable                   = if ($SPT.FWEnable  -eq 'Yes') { $True } else { $False }
        $FWMode                     = $SPT.FWMode
        $FWInstall                  = if ($SPT.FWInstall -eq 'Yes') { $True } else { $False }
        $Baseline                   = $SPT.FWBaseline

        if ($CreateProfile)
        {
            Write-Host -ForegroundColor Cyan "Creating Server Profile $ProfileTemplateName"
        } else {
            Write-Host -ForegroundColor Cyan "Creating Server Profile Template $ProfileTemplateName"
        }

        $SHTCmds = ""
        if ($SHType)
        {
            $BIOSsettingID = @()
            $ThisSHT = Get-HPOVServerHardwareType -name $SHType -ErrorAction SilentlyContinue
            if ($ThisSHT)
            {
                $Model   = $ThisSHT.Model
                $IsDL    = $Model -like '*DL*'
                $ThisSHT.BIOSSettings | ForEach-Object { $BIOSsettingID += $_.ID}  # Collect BIOSSettings ID
                $SHTCmds = " -Serverhardwaretype `$ThisSHT "
            } else {
                Write-Host -ForegroundColor Yellow "  Server Hardware Type $SHType does not exist. Can't create profile or template."
                $Proceed = $CreateProfile
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Server Hardware Type $SHType is not specified. Can't create profile or template."
            $Proceed = $False
        }

        if ($CreateProfile)
        {
            if ($Server)
            {
                $ServerObj = Get-HPOVServer -name $Server -ErrorAction SilentlyContinue
                if ($ServerObj)
                {
                    if ($ServerObj.state -eq 'ProfileApplied')
                    {
                        Write-Host -ForegroundColor Yellow "  Server $Server already has profile assigned. Skip creating profile for $ProfileName."
                        continue
                    } else {
                        switch ($AssignType)
                        {
                            "server"    {
                                            $AssignTypeCmds = " -AssignmentType server "
                                            if (-not $Server)
                                            {
                                                Write-Host -ForegroundColor Yellow "  Assignment type is set to 'server' but server is not specified. Can't create profile for $ProfileName."
                                                $Proceed = $False
                                            } else {
                                                $ServerObj      = Get-HPOVServer -name $Server -ErrorAction SilentlyContinue
                                                if ($ServerObj)
                                                {
                                                    $ServerCmds = " -Server `$ServerObj "
                                                } else {
                                                    Write-Host -ForegroundColor Yellow "  Server does not exist. Can't create profile for $ProfileName."
                                                    $Proceed = $False
                                                }
                                            }
                                        }

                            "bay"       {
                                            $AssignTypeCmds = " -AssignmentType bay "
                                            if (-not $Bay)
                                            {
                                                Write-Host -ForegroundColor Yellow "  Assignment type is set to 'bay' but bay number is not specified. Can't create profile for $ProfileName."
                                                $Proceed = $False
                                            }
                                        }

                            "unassigned" {
                                            $AssignTypeCmds = " -AssignmentType unassigned "
                                            if ( (-not $ProfileTemplate) -and (-not $SHType) )
                                            {
                                                Write-Host -ForegroundColor Yellow "  Assignment type is set to 'unassigned' but profile template or server hardware type is not specified. Can't create profile for $ProfileName."
                                                $Proceed = $False
                                            } else {
                                                Write-Host "Not implemented yet. To create profile from Template."
                                                $Proceed = $false
                                            }

                                            if (-not $Server)
                                            {
                                                Write-Host -ForegroundColor Yellow "  Assignment type is set to 'unassigned' but server is not specified. Can't create profile for $ProfileName."
                                                $Proceed = $False
                                            } else {
                                                $ServerObj      = Get-HPOVServer -name $Server
                                                if ($ServerObj)
                                                {
                                                    $ServerCmds = " -server `$ServerObj "
                                                } else {
                                                    Write-Host -ForegroundColor Yellow "  Server does not exist. Can't create profile for $ProfileName."
                                                    $Proceed = $False
                                                }
                                            }
                                        }
                        }
                    }
                }
            } else {
                if ($AssignType -eq "Bay")
                {
                    $AssignTypeCmds = " -AssignmentType bay "
                    if (-not $Bay)
                    {
                        Write-Host -ForegroundColor Yellow "  Assignment type is set to 'bay' but bay number is not specified. Can't create profile for $ProfileName."
                        $Proceed = $False
                    }

                    if (-not $EncName)
                    {
                        Write-Host -ForegroundColor Yellow "  Assignment type is set to 'bay' but enclosure name is not specified. Can't create profile for $ProfileName."
                        $Proceed = $False
                    } else {
                        $ThisEnclosure = Get-HPOVEnclosure -name $EncName -ErrorAction SilentlyContinue
                        if ($ThisEnclosure)
                        {
                            $EnclosureBayCmds = " -Enclosure `$ThisEnclosure -EnclosureBay $Bay "
                        } else {
                            Write-Host -ForegroundColor Yellow "  Enclosure $EncName does not exist. Can't create profile for $ProfileName."
                            $Proceed = $False
                        }
                    }

                    if (-not $SHType)
                    {
                        Write-Host -ForegroundColor Yellow "  Assignment type is set to 'bay' but server hardware type is not specified. Can't create profile for $ProfileName."
                        $Proceed = $False
                    }
                } else {
                    $AssignTypeCmds = " -AssignmentType $AssignType "
                }
            }

            if ($ProfileName)
            {
                $ProfileTemplateName = $ProfileName
            } else {
                if ($isDL)
                {
                    $ProfileTemplateName = "Default Profile for DL"
                } else {
                    $ProfileTemplateName = "$EncName, Bay $Bay"
                }
            }
            $ThisProfileTemplate = Get-HPOVServerProfile | Where-Object { $($DoubleQuote + $_.name + $DoubleQuote) -eq $ProfileTemplateName }
        } else {
            $ThisProfileTemplate = Get-HPOVServerProfileTemplate | Where-Object { $($DoubleQuote + $_.name + $DoubleQuote) -eq $ProfileTemplateName }
        }

        if ($ThisProfileTemplate)
        {
            Write-Host -ForegroundColor Yellow "  Server Profile Template or Server Profile --> $ProfileTemplateName already exists. Skip creation of Profile."
        } else {
            $ConnectionsCmds = ""
            $SANStorageCmds = ""
            $AffinityCmds = ""
            $egCmds = ""

            if (-not $isDL)
            {
                if ($OVProfileConnectionCSV -and (Test-Path $OVProfileConnectionCSV))
                {
                    $ProfilesNConnections = Create-OVProfileConnection -OVProfileConnectionCSV $OVProfileConnectionCSV -ProfileName $ProfileTemplateName
                    if ($ProfilesNConnections)
                    {
                        $ConnectionsCmds = " -Connections `$ProfilesNConnections "
                    } else {
                        Write-Host -ForegroundColor Yellow "  Cannot find valid connections for profile $ProfileTemplateName. Will create profile without connections."
                        $ConnectionsCmds = ""
                    }
                } else {
                    Write-Host -ForegroundColor Yellow "  Connections list is empty. Profile will be created without any network/FC connection."
                }

                if ($OVProfileSANStorageCSV -and (Test-Path $OVProfileSANStorageCSV))
                {
                    $Enable,$HostOSType,$VolAttach = Create-OVProfileSANStorage -OVProfileSANStorageCSV $OVProfileSANStorageCSV -OVProfileName $ProfileTemplateName -createProfile:$CreateProfile

                    if ($VolAttach -and $Enable -and $HostOSType)
                    {
                        $SANStorageCmds = " -SANStorage -HostOSType $HostOSType -StorageVolume `$VolAttach"
                    } else {
                        Write-Host -ForegroundColor Yellow "  Either SANStorage is not enabled or HostOSType or StorageVolume not defined in CSV file. Will create profile without SAN Storage."
                        $SANStorageCmds = ""
                    }
                } else {
                    Write-Host -ForegroundColor Yellow "  Cannot find SAN Storage list for this profile $ProfileTemplateName. Will create profile without SAN Storage."
                    $SANStorageCmds = ""
                }

                if ($Affinity)
                {
                    $AffinityCmds = " -affinity $Affinity "
                }

                if ($enclGroup)
                {
                    $ThisEnclosureGroup = Get-HPOVEnclosureGroup | Where-Object name -eq $EnclGroup
                    if ($ThisEnclosureGroup)
                    {
                        $egCmds = " -EnclosureGroup `$ThisEnclosureGroup "
                    } else {
                        Write-Host -ForegroundColor Yellow "  Enclosure Group $enclGroup does not exist."
                    }
                } else {
                    Write-Host -ForegroundColor Yellow "  Enclosure Group $enclGroup is not specified."
                }

                if ($CreateProfile -and ($AssignType -eq 'Bay'))
                {
                    $egCmds = ""
                }
            }

            $LOCALStorageCmds = ""
            if ( $OVProfileLOCALStorageCSV -and (Test-Path $OVProfileLOCALStorageCSV) )
            {
                $Enable, $StorageController = Create-OVProfileLOCALStorage -OVProfileLOCALStorageCSV $OVProfileLOCALStorageCSV -OVProfileName $ProfileTemplateName

                if ($StorageController -and $Enable)
                {
                    $LOCALStorageCmds = " -LocalStorage -StorageController `$StorageController"
                } else {
                    Write-Host -ForegroundColor Yellow "  Either LocalStorage is not enabled or LocalStorage Controllers not defined in CSV file. Will create profile without LOCAL Storage."
                    $LOCALStorageCmds = ""
                }
            } else {
                Write-Host -ForegroundColor Yellow "  Cannot find LOCAL Storage list for this profile $ProfileTemplateName. Will create profile without LOCAL Storage."
                $LOCALStorageCmds = ""
            }

            if ($Model -notlike '*Gen8*')
            {
                $BootModeCmds = " -bootmode $BootMode "
            } else {
                Write-Host -ForegroundColor Yellow "  Server Hardware Model $Model does not support BootMode. Ignore BootMode Value."
                $BootModeCmds = ""
            }

            $BootOrderCmds = ""
            if ($BootOrderArray -ne $NULL)
            {
                $BootOrderCmds = " -ManageBoot -bootOrder `$BootOrderArray "
            }

            $DescCmds = ""
            if ($Description)
            {
                $DescCmds = " -Description $Description "
            }

            $ServerDescCmds = ""
            if ($ServerPDescription)
            {
                $ServerDescCmds = " -ServerProfileDescription $ServerPDescription "
            }

            $FWCmds = ""
            if ($FWEnable)
            {
                if ($Baseline)
                {
                    $Baseline    = $Baseline.Trim()
                    $FWVersion   = ($Baseline -split(' '))[-1]

                    $FWObj       = Get-HPOVBaseline | Where-Object version -eq $FWVersion
                    if ($FwObj)
                    {
                        $FWCmds = " -firmware -Baseline `$FWObj "
                        if ($FWMode)
                        {
                            $FWCMds += " -FirmwareMode $FWMode "
                        }

                        if ($FWInstall)
                        {
                            $FWCmds += " -forceInstallFirmware "
                        }
                    }
                }
            }

            $ProfileTemplateNameCmds = ""
            if ($ProfileTemplateName)
            {
                $ProfileTemplateNameCmds  = " -name  $ProfileTemplateName "
            }

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
                        } else {
                            Write-Host -ForegroundColor Yellow "  This BIOSsetting ID $id is not supported for this server hardware type $SHType. Ignore setting."
                        }
                    }
                }

                if ($BIOSSettingsArray)
                {
                    $BIOSettingsCmds = " -BIOS -BIOSSettings `$BIOSSettingsArray "
                } else {
                    Write-Host -ForegroundColor Yellow "  No valid BIOSsetting found. Ignore BIOS configuration."
                    $BIOSettingsCmds = ""
                }
            } else {
                $BIOSettingsCmds = ""
            }

            if ($Proceed)
            {
                if ($CreateProfile)
                {
                    $ProfileCmds  = "New-HPOVServerProfile " + $ProfileTemplateNameCmds + $DescCmds
                    $ProfileCmds += $AssignTypeCmds + $ServerCmds

                    if ($ServerTemplate)
                    {
                        Write-Host -ForegroundColor Cyan "Creating profile from Server Template....."
                        $ProfileCmds += $ServerTemplateToCreateFromCmds
                        $ProfileCmds += $ConnectionsCmds
                    } else {
                        $ProfileCmds += $EnclosureBayCmds
                        $ProfileCmds += $SHTCmds + $egCmds + $AffinityCmds
                        $ProfileCmds += $BootOrderCmds + $BootModeCmds
                        $ProfileCmds += $ConnectionsCmds + $LOCALStorageCmds + $SANStorageCmds
                        $ProfileCmds += $FWCmds + $BIOSettingsCmds
                    }

                    if ($ServerObj)
                    {
                        $ServerObj | Stop-HPOVServer -Force -confirm:$False | Wait-HPOVTaskComplete
                    }

                    Invoke-Expression $ProfileCmds | Wait-HPOVTaskComplete | Format-List
                } else {
                    if ($ProfileTemplateNameCmds)
                    {
                        $ProfileTemplateCmds   = "New-HPOVServerProfileTemplate " + $ProfileTemplateNameCmds + $DescCmds + $ServerDescCmds
                        $ProfileTemplateCmds   += $SHTCmds + $egCmds + $AffinityCmds
                        $ProfileTemplateCmds   += $BootOrderCmds + $BootModeCmds
                        $ProfileTemplateCmds   += $ConnectionsCmds + $LOCALStorageCmds + $SANStorageCmds
                        $ProfileTemplateCmds   += $FWCmds + $BIOSettingsCmds

                        Invoke-Expression $ProfileTemplateCmds | Wait-HPOVTaskComplete | Format-List
                    } else {
                        Write-Host -ForegroundColor Yellow "  $ProfileTemplateName not specified. Can't create server profile template."
                    }
                }
            } else {
                Write-Host -ForegroundColor Yellow "  Correct errors and re-run the command again"
            }
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVProfileConnection
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVProfileConnection
{
    <#
      .SYNOPSIS
        Create ProfileConnection in OneView

      .DESCRIPTION
    	Create ProfileConnection in OneView and return a hash table of Server ProfileName and connection list

      .PARAMETER OVProfileConnectionCSV
        Name of the CSV file containing Server Profile Connection definitions

      .PARAMETER ProfileName
        Name of the Server Profile to apply connections

    #>

    Param (
            [string]$OVProfileConnectionCSV,
            [string]$ProfileName=""
    )

    if ($ProfileName -eq "")
    {
        Write-Host -ForegroundColor Yellow "  No Server profile nor template provided, skip creating connection profile..."
        return $NULL
    }

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVProfileConnectionCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ConnectionList = @()
    $ListofConnections = Import-Csv $tempFile

    foreach ($Conn in $ListofConnections)
    {
        $ServerProfileName  =   $Conn.ServerProfileName.Trim()
        if ($ServerProfileName -like '* *')
        {
            $ServerProfileName  =   $DoubleQuote + $ServerProfileName.Trim() + $DoubleQuote
        }

        if ($ServerProfileName -eq $ProfileName)
        {
            $ConnName           = $Conn.ConnectionName
            $ConnID             = $Conn.ConnectionID
            $NetworkName        = $Conn.NetworkName
            $PortID             = $Conn.PortID
            $RequestedBandWidth = $Conn.RequestedBandWidth
            $UserDefined        = if ( $Conn.UserDefined -eq 'Yes' ) { $True } else { $False }
            $ConnMAC            = $Conn.ConnectionMACAddress
            $ConnWWNN           = $Conn.ConnectionWWNN
            $ConnWWPN           = $Conn.ConnectionWWPN

            if ($ConnMAC -or $ConnWWNN -or $ConnWWPN)
            {
                $UserDefined = $True
            }

            if ($UserDefined)
            {
                $MACCmds         = if ($ConnMAC ) { " -mac $ConnMAC "   } else { "" }
                $WWNNCmds        = if ($ConnWWNN) { " -wwnn $ConnWWNN " } else { "" }
                $WWPNCmds        = if ($ConnWWPN) { " -wwpn $ConnWWPN " } else { "" }

                $UserDefinedCmds = " -userDefined $MacCmds $WWNNCmds $WWPNCmds "
            } else {
                $MacCmds         = ""
                $WWNNCmds        = ""
                $WWPNCmds        = ""
                $UserDefinedCmds = ""
            }

            $ConnNameCmds        = ""
            if ($ConnName)
            {
                $ConnNameCmds    = " -Name `$ConnName "
            }

            $BootPriorityCmds    = ""
            $Bootable            = if ($Conn.Bootable -eq 'Yes' ) { $True } else { $False }
            if ($Bootable)
            {
                $BootPriority    = $Conn.BootPriority
                if ($BootPriority)
                {
                    $BootPriorityCmds = " -bootable -priority $BootPriority "
                } else {
                    Write-Host -ForegroundColor Yellow "  Bootable is set to 'YES' but BootPriority is not specified. Ignore Bootable settings."
                }
            }

            $BootVolumeSource    = $Conn.BootVolumeSource
            if ($NetworkName)
            {
                try
                {
                    $objNetwork = Get-HPOVNetwork -Name $NetworkName -ErrorAction Stop
                }
                catch [HPOneView.NetworkResourceException]
                {
                    $objNetwork = $NULL
                }

                if ($objNetwork -eq $NULL)
                {
                    try
                    {
                        $objNetwork = Get-HPOVNetworkSet -Name $NetworkName -ErrorAction Stop
                    }
                    catch [HPOneView.NetworkResourceException]
                    {
                        $objNetwork = $NULL
                    }
                }

                if ($objNetwork -ne $NULL)
                {
                    $PortIDCmds = ""
                    if ($PortID)
                    {
                        $PortIDCmds = " -portID `$PortID "
                    }

                    $RequestBWCmds = ""
                    if ($RequestedBandWidth)
                    {
                        $RequestBWCmds = " -requestedBW $RequestedBandWidth "
                    }

                    $BootVolumeSourceCmds = ""
                    if ($BootVolumeSource)
                    {
                        $BootVolumeSourceCmds = " -bootvolumesource $BootVolumeSource "
                    }

                    $Cmds  = "New-HPOVServerProfileConnection -connectionID $ConnID -network `$objNetwork "
                    $Cmds +=  $ConnNameCmds + $PortIDCmds + $RequestBWCmds + $UserDefinedCmds + $BootPriorityCmds + $BootVolumeSourceCmds

                    $Connection = Invoke-Expression $Cmds
                    $ConnectionList += $Connection
                } else {
                    Write-Host -ForegroundColor Yellow "  Cannot find network name or network set $NetworkName for this connection. Skip creating Network Connection..."
                }
            } else {
                Write-Host -ForegroundColor Yellow "  The following information is not provided: `n `
                            - Network Name to connect to `n `
                            Please provide information and re-run the command. "
            }
        }
    }
    return $ConnectionList
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVProfileLOCALStorage
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVProfileLOCALStorage
{
    <#
      .SYNOPSIS
        Create ProfileLOCALStorage in OneView

      .DESCRIPTION
    	Create ProfileLOCALStorage in OneView and return a hash table of Server ProfileName and connection list

      .PARAMETER OVProfileLOCALStorageCSV
        Name of the CSV file containing Server Profile Connection definition

      .PARAMETER OVProfileName
        Name of the Server Profile to apply LOCAL Storage Volumes

    #>

    Param (
            [string]$OVProfileLOCALStorageCSV,
            [string]$OVProfileName=""
    )

    if ($OVProfileName -eq "")
    {
        Write-Host -ForegroundColor Yellow "  No Server profile or template provided. Skip creating Local Storage for profile..."
        return $NULL
    }

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVProfileLOCALStorageCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $StorageVolList = @()
    $ListofControllers   = @()
    $ProfileStorageParam = ""
    $DriveTechnologies   = @('SAS','SATA','SASSSD','SATASSD','Auto')
    $ListofLocalStorage  = Import-Csv $tempFile
    $ListofLocalStorage  = $ListofLocalStorage | Where-Object `
        {   if ($_.ProfileName -like "* *")
            {
                ($DoubleQuote + $_.ProfileName + $DoubleQuote) -eq $OVProfileName
            } else {
                $_.ProfileName -eq $OVProfileName
            }
        }

    foreach ($LS in $ListofLocalStorage)
    {
        $EnableLOCALStorage  =  if ($LS.EnableLOCALStorage -eq 'Yes') { $True} else {$False}
        $ControllerID        =  if ($LS.ControllerID) {$LS>ControllerID} else {'Embedded'}
        $ControllerMode      =  $LS.ControllerMode
        $ControlInit         =  if ($LS.ControllerInitialize -eq 'Yes') { $True} else {$False}
        $LDisks              =  $LS.LogicalDisks
        $ListofLogicalDisks  =  @()
        if ($LDisks)
        {
            $ListofVols      =  $LDisks.Split($SepChar)
            for ($Index=0;$Index -lt $ListofVols.Count;$Index++)
            {
                $DiskName    =  $ListofVols[$Index].Trim()
                $Bootable    =  if ($LS.Bootable)
                                {
                                    $a = $LS.Bootable.Split($SepChar)
                                    if ($a[$Index].Trim() -eq 'Yes') { $True } else { $False }
                                } else {
                                    $False
                                }

                $DriveType       = if ($LS.DriveType) { $LS.DriveType.Split($SepChar)[$Index].Trim()} else { 'Auto' }
                $NumberofDrives  = if ($LS.NumberofDrives) { $LS.NumberofDrives.Split($SepChar)[$Index].Trim() }
                $RAIDLevel       = if ($LS.RAID) { $LS.RAID.Split($SepChar)[$Index].Trim() }
                $MinDriveSize    = if ($LS.MinDriveSize) { $LS.MinDriveSize.Split($SepChar)[$Index].Trim() }
                $MaxDriveSize    = if ($LS.MaxDriveSize) { $LS.MaxDriveSize.Split($SepChar)[$Index].Trim() }

                $ListofLogicalDisks += New-HPOVServerProfileLogicalDisk -Name $DiskName -RAID $RAIDLevel -NumberofDrives $NumberofDrives -DriveType $DriveType -Bootable $Bootable
            }
        }

        $ListofControllers += New-HPOVServerProfileLogicalDiskController -Mode $ControllerMode -ControllerID $ControllerID -Initialize:$ControlInit -LogicalDisk $ListofLogicalDisks
    }

    return $EnableLocalStorage,$ListofControllers
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVProfileSANStorage
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVProfileSANStorage
{
    <#
      .SYNOPSIS
        Create ProfileSANStorage in OneView

      .DESCRIPTION
    	Create ProfileSANStorage in OneView and return a hash table of Server ProfileName and connection list

      .PARAMETER OVProfileSANStorageCSV
        Name of the CSV file containing Server Profile Connection definition

      .PARAMETER OVProfileName
        Profile Name

    #>

    Param (
            [string]$OVProfileSANStorageCSV,
            [string]$OVProfileName="",
            [switch]$CreateProfile
    )

    if ($OVProfileName -eq "")
    {
        Write-Host -ForegroundColor Yellow "  No Server profile or template provided. Skip creating Local Storage for profile..."
        return $NULL
    }

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVProfileSANStorageCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $StorageVolList = @()

    $ListofSANStorage = Import-Csv $tempFile
    $ListofSANStorage = $ListofSANStorage | Where-Object `
        {   if ($_.ProfileName -like "* *")
            {
                ($DoubleQuote + $_.ProfileName + $DoubleQuote) -eq $OVProfileName
            } else {
                $_.ProfileName -eq $OVProfileName
            }
        }

    foreach ($SL in $ListofSANStorage)
    {
        $EnableSAN      = if ($SL.EnableSANStorage -eq 'Yes') { $True } else { $False }
        $HostOSType     = $SL.HostOSType
        $VolNameArray   = $SL.VolumeName.Split($SepChar)
        $LUNArray       = $SL.Lun.Split($SepChar)

        $VoltoAttachArr = @()
        if ($EnableSAN)
        {
            for ($index=0;$index -lt $VolNameArray.Count; $index++)
            {
                $ThisLUN        = $LUNArray[$Index]
                $ThisVolName    = $VolNameArray[$Index].Trim()

                if ($ThisVolName)
                {
                    $ThisVol    = Get-HPOVStorageVolume -name $ThisVolName -ErrorAction SilentlyContinue
                    if ($ThisVol)
                    {
                        if ($ThisLUN)
                        {
                            $VolAttach = New-HPOVServerProfileAttachVolume -Volume $ThisVol -LunID $ThisLUN -LunIDType 'Manual'
                        } else {
                            #if ($CreateProfile)
                            #{
                            $VolAttach = New-HPOVServerProfileAttachVolume -Volume $ThisVol -LunIDType 'Auto'
                        }
                            #else {
                            #    Write-Host -ForegroundColor Yellow "  No LUN ID provided for volume $ThisVolName. Skip attaching this volume. `n When creating server profile template, specify LUN ID for volumes."
                            #}
                    }
                    $VoltoAttachArr += $VolAttach
                } else {
                    Write-Host -ForegroundColor Yellow "  The volume specified as $ThisVolName does not exist. Please create it first..."
                }
            }
        }
    }
    return $EnableSAN,$HostOSType,$VoltoAttachArr
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-ProfileFROMTemplate
##
## -------------------------------------------------------------------------------------------------------------
function Create-ProfileFROMTemplate ([pscustomobject]$SP)
{
    $ProfileName     = $SP.ProfileName
    $Description     = $SP.Description
    $ServerHW        = $SP.Server
    $SPTemplate      = $SP.ServerProfileTemplate
    $AssignmentType  = if ($SP.AssignmentType) {$SP.AssignmentType} else {'Bay'}

    if ($ProfileName)
    {
        $TemplateCheck = $False
        if ($SPTemplate)
        {
            $ThisProfileTemplate = Get-HPOVServerProfileTemplate | Where-Object name -eq $SPTemplate
            if ($ThisProfileTemplate)
            {
                $TemplateCheck = $True
            } else {
                Write-Host -ForegroundColor Yellow "  Server Profile Template $SPTemplate does not exist. Can't create Server Profile from Template."
                $TemplateCheck = $False
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Server Profile Template is not specified. Can't create Server Profile from Template."
            $TemplateCheck = $False
        }

        $HWCheck = $False
        if ($ServerHW)
        {
            $ThisServerHW = Get-HPOVServer | Where-Object name -eq $ServerHW
            if ($ThisServerHW)
            {
                if ($ThisServerHW.State -eq 'NoProfileApplied')
                {
                    $HWCheck = $True
                } else {
                    Write-Host -ForegroundColor Yellow "  The Server Hardware $ServerHW already has profile. Skip creating profile."
                    $HWCheck = $False
                }
            } else {
                Write-Host -ForegroundColor Yellow "  The Server Hardware $ServerHW does not exist. Please check name with Get-HPOVServer. Can't create Server Profile from Template."
                $HWCheck = $False
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Server Hardware is not specified. Can't create Server Profile from Template."
            $HWCheck = $False
        }

        if ($HWCheck -and $TemplateCheck)
        {
            Write-Host -ForegroundColor Cyan "Creating profile $Profilename for server $ServerHW "
            New-HPOVServerProfile -Name $ProfileName -Description $Description -ServerProfileTemplate $ThisProfileTemplate -Server $ThisServerHW -AssignmentType $AssignmentType | Wait-HPOVTaskComplete

            Write-Host -ForegroundColor Cyan "Updating profile $Profilename from template $TemplateName "
            Get-HPOVServerProfile -name $ProfileName | Update-HPOVServerProfile -confirm:$false
        } else {
            Write-Host -ForegroundColor Yellow "  Missing information to create server profile from Template. Check Profile Template or Server Hardware."
        }
    } else {
        Write-Host -ForegroundColor Yellow "  Name of profile not specified. Skip creating profile."
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVProfileFROMTemplate
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVProfileFROMTemplate
{
    <#
      .SYNOPSIS
        Create Server Profile from Template in OneView

      .DESCRIPTION
        Create Server Profile from Template in OneView

      .PARAMETER OVProfilefromTemplateCSV
        Name of the CSV file that contains definitions of server profiles

    #>

    Param (
            [string]$OVProfilefromTemplateCSV
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVProfilefromTemplateCSV | Where-Object {
        ($_ -notlike ",,,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $ListofProfile = Import-Csv $tempFile

    foreach ($SP in $ListofProfile)
    {
        $ProfileName     = $SP.ProfileName
        if ($ProfileName -like '* *')
        {
            $ProfileName  =   $DoubleQuote + $ProfileName.Trim() + $DoubleQuote
        }

        $Description     = $SP.Description
        $ServerHW        = $SP.Server
        $SPTemplate      = $SP.ServerTemplate
        $AssignmentType  = if ($SP.AssignmentType) {$SP.AssignmentType} else { 'Bay' }

        if ($ProfileName)
        {
            $TemplateCheck = $False
            if ($SPTemplate)
            {
                $ThisProfileTemplate = Get-HPOVServerProfileTemplate | Where-Object name -eq $SPTemplate
                if ($ThisProfileTemplate)
                {
                    $TemplateCheck = $True
                } else {
                    Write-Host -ForegroundColor Yellow "  Server Profile Template $SPTemplate does not exist. Can't create Server Profile from Template."
                    $TemplateCheck = $False
                }
            } else {
                Write-Host -ForegroundColor Yellow "  Server Profile Template is not specified. Can't create Server Profile from Template."
                $TemplateCheck = $False
            }

            $HWCheck = $False
            if ($ServerHW)
            {
                $ThisServerHW = Get-HPOVServer | Where-Object name -eq $ServerHW
                if ($ThisServerHW)
                {
                    if ($ThisServerHW.State -eq 'NoProfileApplied')
                    {
                        $HWCheck = $True
                    } else {
                        Write-Host -ForegroundColor Yellow "  The Server Hardware $ServerHW already has profile. Skip creating profile."
                        $HWCheck = $False
                    }
                } else {
                    Write-Host -ForegroundColor Yellow "  The Server Hardware $ServerHW does not exist. Please check name with Get-HPOVServer. Can't create Server Profile from Template."
                    $HWCheck = $False
                }
            } else {
                Write-Host -ForegroundColor Yellow "  Server Hardware is not specified. Can't create Server Profile from Template."
                $HWCheck = $False
            }

            if ($HWCheck -and $TemplateCheck)
            {
                Write-Host -ForegroundColor Cyan "Creating profile $Profilename for server $ServerHW"
                New-HPOVServerProfile -Name $ProfileName -Description $Description -ServerProfileTemplate $ThisProfileTemplate -Server $ThisServerHW -AssignmentType $AssignmentType | Wait-HPOVTaskComplete

                Write-Host -ForegroundColor Cyan "Updating profile $Profilename from template $TemplateName"
                Get-HPOVServerProfile -Name $ProfileName | Update-HPOVServerProfile -Confirm:$false
            } else {
                Write-Host -ForegroundColor Yellow "  Missing information to create server profile from Template. Check Profile Template or Server Hardware."
            }
        } else {
            Write-Host -ForegroundColor Yellow "  Name of profile not specified. Skip creating profile."
        }
    }
}


## -------------------------------------------------------------------------------------------------------------
##
##      Function Create-OVProfile
##
## -------------------------------------------------------------------------------------------------------------
function Create-OVProfile
{
    <#
      .SYNOPSIS
        Create Server Profile  in OneView

      .DESCRIPTION
        Create Server Profile in OneView

      .PARAMETER OVProfileConnectionCSV
        Name of the CSV file that contains definitions of Connections (Ethernet or Fibre Channel) associated to server profiles

      .PARAMETER OVProfileCSV
        Name of the CSV file that contains definitions of server profiles

      .PARAMETER OVProfileLOCALStorageCSV
        Name of the CSV file containing definitions of Local Storage Volumes associated to Server Profile Template

      .PARAMETER OVProfileSANStorageCSV
        Name of the CSV file containing definitions of SAN Storage Volumes associated to Server Profile Template

    #>

    Param (
            [string]$OVProfileConnectionCSV,
            [string]$OVProfileCSV,
            [string]$OVProfileLOCALStorageCSV,
            [string]$OVProfileSANStorageCSV
    )

    Create-ProfileOrTemplate -OVProfileTemplateCSV $OVProfileCSV -OVProfileConnectionCSV $OVProfileConnectionCSV -OVProfileLOCALStorageCSV $OVProfileLOCALStorageCSV -OVProfileSANStorageCSV $OVProfileSANStorageCSV -CreateProfile
}

## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-BackupConfig
##
## -------------------------------------------------------------------------------------------------------------
function Import-BackupConfig
{
    <#
      .SYNOPSIS
        Import from a backup configuration CSV file and then schedule remote backup in OneView

      .DESCRIPTION
        Import and schedule backup in OneView

      .PARAMETER OVBackupConfig
        Name of the CSV file containing backup configurations

    #>

    Param (
            [string]$OVBackupConfig
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVBackupConfig | Where-Object {
        ($_ -notlike ",,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $Backup_Config = Import-Csv $tempFile

    if ($Backup_Config)
    {
        $remoteServerName       = $Backup_Config.remoteServerName
        $remoteServerDir        = $Backup_Config.remoteServerDir
        $userName               = $Backup_Config.userName
        $password               = $Backup_Config.password
        $protocol               = $Backup_Config.protocol
        $scheduleInterval       = $Backup_Config.scheduleInterval
        $scheduleDays           = ($Backup_Config.scheduleDays).split(" ")
        $scheduleTime           = $Backup_Config.scheduleTime
        $remoteServerPublicKey  = $Backup_Config.remoteServerPublicKey

        if ($remoteServerDir)
        {
            Set-HPOVAutomaticBackupConfig -Hostname $remoteServerName -Username $userName -HostSSHKey $remoteServerPublicKey -Protocol $protocol -Interval $scheduleInterval -Days $scheduleDays -Time $scheduleTime -Directory $remoteServerDir -Password (ConvertTo-SecureString $password -AsPlainText -Force)
        } else {
            Set-HPOVAutomaticBackupConfig -Hostname $remoteServerName -Username $userName -HostSSHKey $remoteServerPublicKey -Protocol $protocol -Interval $scheduleInterval -Days $scheduleDays -Time $scheduleTime -Password (ConvertTo-SecureString $password -AsPlainText -Force)
        }
    } else {
        Write-Host -ForegroundColor Yellow "  Backup Schedule configuration failed."
    }
}

## -------------------------------------------------------------------------------------------------------------
##
##      Function Import-OVRSConfig
##
## -------------------------------------------------------------------------------------------------------------
function Import-OVRSConfig
{
    <#
      .SYNOPSIS
        Import from a backup configuration CSV file and configure remote support in OneView

      .DESCRIPTION
        Import and configure default site for OneView remote support

      .PARAMETER OVRSConfig
        Name of the CSV file containing remote support configuration

    #>
    Param (
            [string]$OVRSConfig
    )

    $tempFile = [IO.Path]::GetTempFileName()

    Get-Content $OVRSConfig | Where-Object {
        ($_ -notlike ",,,*") -and ( $_ -notlike "#*") -and ($_ -notlike ",,,#*")
    } > $tempFile

    $OVRS_Config = Import-Csv $tempFile

    if ($OVRS_Config)
    {
        $company                = $OVRS_Config.Company
        $firstName              = $OVRS_Config.FirstName
        $lastName               = $OVRS_Config.LastName
        $email                  = $OVRS_Config.Email
        $phone                  = $OVRS_Config.Primary
        $streetAddress1         = $OVRS_Config.streetAddress1
        $streetAddress2         = $OVRS_Config.streetAddress2
        $city                   = $OVRS_Config.City
        $state                  = $OVRS_Config.State
        $postalCode             = $OVRS_Config.postalCode
        $country                = $OVRS_Config.countryCode
        $timeZone               = $OVRS_Config.TimeZone

        $ovrsEnabled = Get-HPOVRemoteSupport

        if(!$ovrsEnabled.enableRemoteSupport)
        {

            $ovrsContact = Get-HPOVRemoteSupportContact
            if(!$ovrsContact.default)
            {
                New-HPOVRemoteSupportContact -Firstname $firstName -Lastname $lastName -Email $email -PrimaryPhone $phone -Language en -Default
            }

            $ovrsDefaultSite = $null
            try
            {
                $ovrsDefaultSite = Get-HPOVRemoteSupportDefaultSite -ErrorAction SilentlyContinue
            }
            catch
            {
                $ovrsDefaultSite = $null
            }

            if(!$ovrsDefaultSite -and !$ovrsDefaultSite.default)
            {
                if(!$streetAddress2 -eq $null)
                {
                    Set-HPOVRemoteSupportDefaultSite -AddressLine1 $streetAddress1 -AddressLine2 $streetAddress2 -City $city -State $state -PostalCode $postalCode -Country $country -TimeZone $timeZone.Trim()
                }
                else
                {
                    Set-HPOVRemoteSupportDefaultSite -AddressLine1 $streetAddress1 -City $city -State $state -PostalCode $postalCode -Country $country -TimeZone $timeZone.Trim()
                }
            }

            Set-HPOVRemoteSupport -CompanyName $company
        }
    }
    else
    {
        Write-Host -ForegroundColor Yellow "  Remote Support configuration failed."
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
        $OVProfileConnectionCSV                 = "ProfileConnection.csv"
        $OVProfileLOCALStorageCSV               = "ProfileLOCALStorage.csv"
        $OVProfileSANStorageCSV                 = "ProfileSANStorage.csv"

        $OVProfileTemplateCSV                   = "ProfileTemplate.csv"
        $OVProfileTemplateConnectionCSV         = "ProfileTemplateConnection.csv"
        $OVProfileTemplateLOCALStorageCSV       = "ProfileTemplateLOCALStorage.csv"
        $OVProfileTemplateSANStorageCSV         = "ProfileTemplateSANStorage.csv"

        $OVSANManagerCSV                        = "SANManager.csv"
        $OVStorageSystemCSV                     = "StorageSystems.csv"
        $OVStorageVolumeTemplateCSV             = "StorageVolumeTemplate.csv"
        $OVStorageVolumeCSV                     = "StorageVolume.csv"

        $OVAddressPoolCSV                       = "AddressPool.csv"
        $OVWwnnCSV                              = "Wwnn.csv"
        $OVIPAddressCSV                         = "IPAddress.csv"
        $OVOSDeploymentCSV                      = "OSDeployment.csv"

        $OVLicense                              = "OVLicense.txt"
        $OVFWBundleISO                          = "SPP_2018.06.20180709_for_HPE_Synergy_Z7550-96524.iso"
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


    if ($DisableVSN)
    {
        Write-Host -ForegroundColor Cyan "Checking for Enabled Virtual Serial Number Pools"
        Disable-VSN
    }

    if ( -not [string]::IsNullOrEmpty($OVLdapCSV) -and (Test-Path $OVLdapCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing LDAP Directory config from CSV file         --> $OVLdapCSV"
        Import-LDAP -OVLdap $OVLdapCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVFWBundleISO) -and (Test-Path $OVFWBundleISO) )
    {
        Write-Host -ForegroundColor Cyan "Importing Service Pack for ProLiant FW Bundle file    --> $OVFWBundleISO"
        Add-Firmware-Bundle -OVFWBundle $OVFWBundleISO
    }

    if ( -not [string]::IsNullOrEmpty($OVFWReposCSV) -and (Test-Path $OVFWReposCSV) )
    {
        Write-Host -ForegroundColor Cyan "Configuring External FW Repository from CSV file      --> $OVFWReposCSV"
        Import-FWRepos -OVFWReposCSV $OVFWReposCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVLicense) -and (Test-Path $OVLicense) )
    {
        Write-Host -ForegroundColor Cyan "Importing OneView and Synergy Licenses from file      --> $OVLicense"
        Add-License -OVLicense $OVLicense
    }

    if ( -not [string]::IsNullOrEmpty($OVProxyCSV) -and (Test-Path $OVProxyCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing OneView Proxy configuration from file       --> $OVProxyCSV"
        Import-Proxy -OVProxyCSV $OVProxyCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVTimeLocaleCSV) -and (Test-Path $OVTimeLocaleCSV) )
    {
        Write-Host -ForegroundColor Cyan "Configuring Time and Locale settings from CSV file    --> $OVTimeLocaleCSV"
        Import-TimeLocale -OVTimeLocale $OVTimeLocaleCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVSmtpCSV) -and (Test-Path $OVSmtpCSV) )
    {
        Write-Host -ForegroundColor Cyan "Configuring SMTP settings from CSV file               --> $OVSmtpCSV"
        Import-SMTP -OVSmtpCSV $OVSmtpCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVAlertsCSV) -and (Test-Path $OVAlertsCSV) )
    {
        Write-Host -ForegroundColor Cyan "Configuring SMTP Alerts from CSV file                 --> $OVAlertsCSV"
        Import-Alerts -OVAlertsCSV $OVAlertsCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVScopesCSV) -and (Test-Path $OVScopesCSV) )
    {
        Write-Host -ForegroundColor Cyan "Configuring Scopes from CSV file                      --> $OVScopesCSV"
        Import-Scopes -OVScopesCSV $OVScopesCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVUsersCSV) -and (Test-Path $OVUsersCSV) )
    {
        Write-Host -ForegroundColor Cyan "Configuring Users from CSV file                       --> $OVUsersCSV"
        Import-Users -OVUsersCSV $OVUsersCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVLdapGroupsCSV) -and (Test-Path $OVLdapGroupsCSV) )
    {
        Write-Host -ForegroundColor Cyan "Configuring LDAP Groups from CSV file                 --> $OVLdapGroupsCSV"
        Import-Groups -OVLdapGroupsCSV $OVLdapGroupsCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVAddressPoolCSV) -and (Test-Path $OVAddressPoolCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Address Pools from CSV file                 --> $OVAddressPoolCSV"
        Create-OVAddressPool -OVAddressPoolCSV $OVAddressPoolCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVEnclosureCSV) -and (Test-Path $OVEnclosureCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing and Renaming Enclosures from CSV file       --> $OVEnclosureCSV"
        Create-OVEnclosure -OVEnclosureCSV $OVEnclosureCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVSANManagerCSV) -and (Test-Path $OVSANManagerCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing SAN Managers from CSV file                  --> $OVSANManagerCSV"
        Create-OVSANManager -OVSANManagerCSV $OVSANManagerCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVEthernetNetworksCSV) -and (Test-Path $OVEthernetNetworksCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Ethernet Networks from CSV file             --> $OVEthernetNetworksCSV"
        Create-OVEthernetNetworks -OVEthernetNetworksCSV $OVEthernetNetworksCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVFCNetworksCSV) -and (Test-Path $OVFCNetworksCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Fibre Channel Networks from CSV file        --> $OVFCNetworksCSV"
        Create-OVFCNetworks -OVFCNetworksCSV $OVFCNetworksCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVStorageSystemCSV) -and (Test-Path $OVStorageSystemCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Storage Systems from CSV file               --> $OVStorageSystemCSV"
        Create-OVStorageSystem -OVStorageSystemCSV $OVStorageSystemCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVStorageVolumeTemplateCSV) -and (Test-Path $OVStorageVolumeTemplateCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Storage Volume Templates from CSV file      --> $OVStorageVolumeTemplateCSV"
        Create-OVStorageVolumeTemplate -OVStorageVolumeTemplateCSV $OVStorageVolumeTemplateCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVStorageVolumeCSV) -and (Test-Path $OVStorageVolumeCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Storage Volumes from CSV file               --> $OVStorageVolumeCSV"
        Create-OVStorageVolume -OVStorageVolumeCSV $OVStorageVolumeCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVOSDeploymentCSV ) -and (Test-Path $OVOSDeploymentCSV ) )
    {
        Write-Host -ForegroundColor Cyan "Importing OS Deployment Servers from CSV file         --> $OVOSDeploymentCSV"
        Create-OVDeploymentServer -OVOSDeploymentCSV $OVOSDeploymentCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVLogicalInterConnectGroupCSV) -and (Test-Path $OVLogicalInterConnectGroupCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Logical Interconnect Groups from CSV file   --> $OVLogicalInterConnectGroupCSV"
        Create-OVLogicalInterConnectGroup -OVLogicalInterConnectGroupCSV $OVLogicalInterConnectGroupCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVUpLinkSetCSV) -and (Test-Path $OVUpLinkSetCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Uplink Sets from CSV file                   --> $OVUpLinkSetCSV"
        Create-OVUplinkSet -OVUpLinkSetCSV $OVUpLinkSetCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVEnclosureGroupCSV) -and (Test-Path $OVEnclosureGroupCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Enclosure Groups from CSV file              --> $OVEnclosureGroupCSV"
        Create-OVEnclosureGroup -OVEnclosureGroupCSV $OVEnclosureGroupCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVLogicalEnclosureCSV) -and (Test-Path $OVLogicalEnclosureCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Logical Enclosures from CSV file            --> $OVLogicalEnclosureCSV"
        Create-OVLogicalEnclosure -OVLogicalEnclosureCSV $OVLogicalEnclosureCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVDLServerCSV) -and (Test-Path $OVDLServerCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing ProLiant DL Servers from CSV file           --> $OVDLServerCSV"
        Create-OVDLServer -OVDLServerCSV $OVDLServerCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVBackupConfig) -and (Test-Path $OVBackupConfig) )
    {
        Write-Host -ForegroundColor Cyan "Importing Scheduled Backup Config from CSV file       --> $OVBackupConfig"
        Import-BackupConfig -OVBackupConfig $OVBackupConfig
    }

    if ( -not [string]::IsNullOrEmpty($OVRSConfig) -and (Test-Path $OVRSConfig) )
    {
        Write-Host -ForegroundColor Cyan "Importing OneView Remote Support Config from CSV file --> $OVRSConfig"
        Import-OVRSConfig -OVRSConfig $OVRSConfig
    }

    if ( -not [string]::IsNullOrEmpty($OVProfileTemplateCSV)             -and  (Test-Path $OVProfileTemplateCSV)              -and `
         -not [string]::IsNullOrEmpty($OVProfileTemplateConnectionCSV)   -and  (Test-Path $OVProfileTemplateConnectionCSV)    -and `
         -not [string]::IsNullOrEmpty($OVProfileTemplateLOCALStorageCSV) -and  (Test-Path $OVProfileTemplateLOCALStorageCSV)  -and `
         -not [string]::IsNullOrEmpty($OVProfileTemplateSANStorageCSV)   -and  (Test-Path $OVProfileTemplateSANStorageCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Server Profile Templates from CSV file      --> $OVProfileTemplateCSV"
        Create-OVProfileTemplate -OVProfileTemplateCSV $OVProfileTemplateCSV -OVProfileTemplateConnectionCSV $OVProfileTemplateConnectionCSV -OVProfileTemplateLOCALStorageCSV $OVProfileTemplateLOCALStorageCSV -OVProfileTemplateSANStorageCSV $OVProfileTemplateSANStorageCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVProfileCSV)             -and  (Test-Path $OVProfileCSV)              -and `
         -not [string]::IsNullOrEmpty($OVProfileConnectionCSV)   -and  (Test-Path $OVProfileConnectionCSV)    -and `
         -not [string]::IsNullOrEmpty($OVProfileLOCALStorageCSV) -and  (Test-Path $OVProfileLOCALStorageCSV)  -and `
         -not [string]::IsNullOrEmpty($OVProfileSANStorageCSV)   -and  (Test-Path $OVProfileSANStorageCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Server Profile from CSV file                --> $OVProfileCSV"
        Create-OVProfile -OVProfileCSV $OVProfileCSV -OVProfileConnectionCSV $OVProfileConnectionCSV -OVProfileLOCALStorageCSV $OVProfileLOCALStorageCSV -OVProfileSANStorageCSV $OVProfileSANStorageCSV
    }

    if ( -not [string]::IsNullOrEmpty($OVProfileFROMTemplateCSV) -and (Test-Path $OVProfileFROMTemplateCSV) )
    {
        Write-Host -ForegroundColor Cyan "Importing Server Profile from Template CSV file       --> $OVProfileFROMTemplateCSV"
        Create-OVProfileFROMTemplate -OVProfileFROMTemplateCSV $OVProfileFROMTemplateCSV
    }


    Write-Host -ForegroundColor Cyan "------------------------------------------------"
    Write-Host -ForegroundColor Cyan "-----  Disconnecting from OneView/Synergy  -----"
    Write-Host -ForegroundColor Cyan "------------------------------------------------"
    Disconnect-HPOVMgmt
}