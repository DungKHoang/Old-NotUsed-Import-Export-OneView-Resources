## -------------------------------------------------------------------------------------------------------------
##
##
##      Description: Write-To Excel for OV Resources
##
## DISCLAIMER
## The sample scripts are not supported under any HPE standard support program or service.
## The sample scripts are provided AS IS without warranty of any kind. 
## HP further disclaims all implied warranties including, without limitation, any implied 
## warranties of merchantability or of fitness for a particular purpose. 
##
##    
## Scenario
##     	Generate Excel files from OneView Resources CSV 
##		
##
## Input parameters:
##         TemplateFullPath                   = Xlsx template file
##		   CSVFolder                          = Folder containing CSV files
##         ExcelName                          = Excel Output file name
##
## History: 
##         August-2017   : v1.0 release
##
## -------------------------------------------------------------------------------------------------------------
<#
    .SYNOPSIS
     Generate Excel file for OV resources from CSV files
  
    .DESCRIPTION
	 Generate Excel file for OV resources from CSV files
        
    .EXAMPLE
    .\Write-toExcel.ps1 -TemplaeFullPath "c:\Ov-Excel\Synergy-Template.xlsx" -CSVFolder "c:\OV-Excel\CSV" -ExcelName "OV-Output.xlsx"

    .PARAMETER TemplateFullPath                 
        Full path of Xlsx template file

    .PARAMETER CSVFolder                 
        Folder containing CSV files
    
    .PARAMETER ExcelName                
        Excel Output file name. Will be appended with date

    #Requires PS -Version 5.0
 #>
  
## -------------------------------------------------------------------------------------------------------------

Param (
    [string]$TemplateFullPath          = "C:\OV-Excel\Synergy-Template.xlsx",
    [string]$CSVFolder                 = "C:\OV-Excel\csv",
    [string]$ExcelName                 = "OneView-Resources.xlsx"
)


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToAddressPool
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToAddressPool ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.PoolName
         $WS.Cells($RowStart,2)   = $obj.PoolType
         $WS.Cells($RowStart,3)   = $obj.RangeType
         $WS.Cells($RowStart,4)   = $obj.StartAddress
         $WS.Cells($RowStart,5)   = $obj.EndAddress
         $WS.Cells($RowStart,6)   = $obj.NetworkID
         $WS.Cells($RowStart,7)   = $obj.SubnetMask
         $WS.Cells($RowStart,8)   = $obj.Gateway
         $WS.Cells($RowStart,9)   = $obj.DNSServers
         $WS.Cells($RowStart,10)  = $obj.Domain
         
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToEthernetNetwork
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToEtherNetNetwork ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.NetworkSet
         $WS.Cells($RowStart,2)   = $obj.NSTypicalBandwidth
         $WS.Cells($RowStart,3)   = $obj.NSMaximumBandwidth
         $WS.Cells($RowStart,4)   = $obj.UplinkSet
         $WS.Cells($RowStart,5)   = $obj.LogicalInterConnectGroup
         $WS.Cells($RowStart,6)   = $obj.NetworkName
         $WS.Cells($RowStart,7)   = $obj.Type
         $WS.Cells($RowStart,8)   = $obj.vLANID
         $WS.Cells($RowStart,9)   = $obj.vLANType
         $WS.Cells($RowStart,10)  = $obj.SubnetID
         $WS.Cells($RowStart,11)  = $obj.TypicalBandwidth
         $WS.Cells($RowStart,12)  = $obj.MaximumBandwidth
         $WS.Cells($RowStart,13)  = $obj.SmartLink
         $WS.Cells($RowStart,14)  = $obj.PrivateNetwork
         $WS.Cells($RowStart,15)  = $obj.Purpose
         
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToFCNetwork
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToFCNetwork ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.NetworkName
         $WS.Cells($RowStart,2)   = $obj.Description
         $WS.Cells($RowStart,3)   = $obj.Type
         $WS.Cells($RowStart,4)   = $obj.FabricType
         $WS.Cells($RowStart,5)   = $obj.ManagedSAN
         $WS.Cells($RowStart,6)   = $obj.vLANID
         $WS.Cells($RowStart,7)   = $obj.TypicalBandwidth
         $WS.Cells($RowStart,8)   = $obj.MaximumBandwidth
         $WS.Cells($RowStart,9)   = $obj.LoginRedistribution	
         $WS.Cells($RowStart,10)  = $obj. LinkStabilityTime
         
         
         $RowStart               += 2               # Add 1 blank line           
    		
        
         
    }
  
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToSANManager
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToSANManager ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.SanManagerName
         $WS.Cells($RowStart,2)   = $obj.Type
         $WS.Cells($RowStart,3)   = $obj.Username
         $WS.Cells($RowStart,4)   = $obj.Password
         $WS.Cells($RowStart,5)   = $obj.Port
         $WS.Cells($RowStart,6)   = $obj.UseSSL
         $WS.Cells($RowStart,7)   = $obj.snmpAuthLevel
         $WS.Cells($RowStart,8)   = $obj.snmpAuthProtocol
         $WS.Cells($RowStart,9)   = $obj.snmpAuthUsername
         $WS.Cells($RowStart,10)  = $obj.snmpAuthPassword
         $WS.Cells($RowStart,11)  = $obj.snmpPrivProtocol
         $WS.Cells($RowStart,12)  = $obj.snmpPrivPassword

         
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToStorageSystems
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToStorageSystems ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.StorageHostName	
         $WS.Cells($RowStart,2)   = $obj.StorageFamilyName
         $WS.Cells($RowStart,3)   = $obj.StorageAdminName
         $WS.Cells($RowStart,4)   = $obj.StorageAdminPassword
         $WS.Cells($RowStart,5)   = $obj.StoragePorts
         $WS.Cells($RowStart,6)   = $obj.StorageDomainName
         $WS.Cells($RowStart,7)   = $obj.StorageVIPS
         $WS.Cells($RowStart,8)   = $obj.StoragePools         
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToStorageVolumeTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToStorageVolumeTemplate ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.TemplateName	
         $WS.Cells($RowStart,2)   = $obj.Description
         $WS.Cells($RowStart,3)   = $obj.StoragePool
         $WS.Cells($RowStart,4)   = $obj.StorageSystem
         $WS.Cells($RowStart,5)   = $obj.Capacity
         $WS.Cells($RowStart,6)   = $obj.ProvisionningType
         $WS.Cells($RowStart,7)   = $obj.Shared     
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToStorageVolume
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToStorageVolume ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.VolumeName	
         $WS.Cells($RowStart,2)   = $obj.Description
         $WS.Cells($RowStart,3)   = $obj.StoragePool
         $WS.Cells($RowStart,4)   = $obj.StorageSystem
         $WS.Cells($RowStart,5)   = $obj.VolumeTemplate
         $WS.Cells($RowStart,6)   = $obj.Capacity
         $WS.Cells($RowStart,7)   = $obj.ProvisionningType
         $WS.Cells($RowStart,8)   = $obj.Shared     
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToLogicalInterConnectGroup
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToLogicalInterConnectGroup ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.LIGName
         $WS.Cells($RowStart,2)   = $obj.FrameCount
         $WS.Cells($RowStart,3)   = $obj.InterConnectBaySet
         $WS.Cells($RowStart,4)   = $obj.InterConnectType
         $WS.Cells($RowStart,5)   = $obj.BayConfig
         $WS.Cells($RowStart,6)   = $obj.Redundancy
         $WS.Cells($RowStart,7)   = $obj.InternalNetworks
         $WS.Cells($RowStart,8)   = $obj.IGMPSnooping
         $WS.Cells($RowStart,9)   = $obj.IGMPIdleTimeout
         $WS.Cells($RowStart,10)  = $obj.FastMacCacheFailover
         $WS.Cells($RowStart,11)  = $obj.MacRefreshInterval
         $WS.Cells($RowStart,12)  = $obj.NetworkLoopProtection
         $WS.Cells($RowStart,13)  = $obj.PauseFloodProtection
         $WS.Cells($RowStart,14)  = $obj.EnhancedLLDPTLV	
         $WS.Cells($RowStart,15)  = $obj.LDPTagging
         $WS.Cells($RowStart,16)  = $obj.SNMP
         $WS.Cells($RowStart,17)  = $obj.QOSConfiguration
         
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToUplinkSet
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToUplinkSet ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.LIGName
         $WS.Cells($RowStart,2)   = $obj.UplinkSetName
         $WS.Cells($RowStart,3)   = $obj.UpLinkType
         $WS.Cells($RowStart,4)   = $obj.UpLinkPorts
         $WS.Cells($RowStart,5)   = $obj.Networks
         $WS.Cells($RowStart,6)   = $obj.NativeEthernetNetwork
         $WS.Cells($RowStart,7)   = $obj.EthernetMode
         $WS.Cells($RowStart,8)   = $obj.LACPTimer
         $WS.Cells($RowStart,9)   = $obj.PrimaryPort	
         $WS.Cells($RowStart,10)  = $obj.FCuplinkSpeed	

         
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}						

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToOSDeployment
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToOSDeployment ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.DeploymentServerName
         $WS.Cells($RowStart,2)   = $obj.Description
         $WS.Cells($RowStart,3)   = $obj.ManagementNetwork
         $WS.Cells($RowStart,4)   = $obj.ImageStreamerAppliance
         

         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToEnclosureGroup
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToEnclosureGroup ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.EnclosureGroupName
         $WS.Cells($RowStart,2)   = $obj.Description
         $WS.Cells($RowStart,3)   = $obj.LogicalInterConnectGroupMapping
         $WS.Cells($RowStart,4)   = $obj.EnclosureCount
         $WS.Cells($RowStart,5)   = $obj.IPv4AddressType
         $WS.Cells($RowStart,6)   = $obj.AddressPool
         $WS.Cells($RowStart,7)   = $obj.DeploymentNetworkType
         $WS.Cells($RowStart,8)   = $obj.DeploymentNetwork
         $WS.Cells($RowStart,9)   = $obj.PowerRedundantMode	

         
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}	
														

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToLogicalEnclosure
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToLogicalEnclosure ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.LogicalEnclosureName
         $WS.Cells($RowStart,2)   = $obj.Enclosure
         $WS.Cells($RowStart,3)   = $obj.EnclosureGroup
         $WS.Cells($RowStart,4)   = $obj.FWBaseLine
         $WS.Cells($RowStart,5)   = $obj.FWInstall
         
         
												
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  
}	

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToEnclosure
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToEnclosure ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.EnclosureGroupName
         $WS.Cells($RowStart,2)   = $obj.EnclosureName
         $WS.Cells($RowStart,3)   = $obj.OAIPAddress
         $WS.Cells($RowStart,4)   = $obj.OAAdminName
         $WS.Cells($RowStart,5)   = $obj.OAAdminPassword
         $WS.Cells($RowStart,6)   = $obj.LicensingIntent
         $WS.Cells($RowStart,7)   = $obj.FWBaseLine
         $WS.Cells($RowStart,8)   = $obj.FWInstall
         $WS.Cells($RowStart,9)   = $obj.MonitoredOnly
         
												
         
         $RowStart               += 2               # Add 1 blank line           
            
         
    }
  

}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToProfileTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToProfileTemplate ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.ProfileTemplateName
         $WS.Cells($RowStart,2)   = $obj.Description
         $WS.Cells($RowStart,3)   = $obj.ServerProfileDescription
         $WS.Cells($RowStart,4)   = $obj.ServerHardwareType
         $WS.Cells($RowStart,5)   = $obj.EnclosureGroup
         $WS.Cells($RowStart,6)   = $obj.Affinity
         $WS.Cells($RowStart,7)   = $obj.FWEnable
         $WS.Cells($RowStart,8)   = $obj.FWBaseLine
         $WS.Cells($RowStart,9)   = $obj.FWMode
         $WS.Cells($RowStart,10)  = $obj.FWInstall
         $WS.Cells($RowStart,11)  = $obj.BIOSSettings
         $WS.Cells($RowStart,12)  = $obj.BootOrder
         $WS.Cells($RowStart,13)  = $obj.BootMode
         $WS.Cells($RowStart,14)  = $obj.PXEBootPolicy
         $WS.Cells($RowStart,15)  = $obj.MACAssignment
         $WS.Cells($RowStart,16)  = $obj.WWNAssignment
         $WS.Cells($RowStart,17)  = $obj.SNAssignment
         $WS.Cells($RowStart,18)  = $obj.HideUnusedFlexNics
         
         
         $RowStart               += 2               # Add 1 blank line           
            	
         
    }
  
}
							
## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToProfile
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToProfile ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.ProfileName
         $WS.Cells($RowStart,2)   = $obj.Description
         $WS.Cells($RowStart,3)   = $obj.AssignmentType
         $WS.Cells($RowStart,4)   = $obj.Enclosure
         $WS.Cells($RowStart,5)   = $obj.EnclosureBay
         $WS.Cells($RowStart,6)   = $obj.Server
         $WS.Cells($RowStart,7)   = $obj.ServerTemplate
         $WS.Cells($RowStart,8)   = ""
         $WS.Cells($RowStart,9)   = $obj.ServerHardwareType
         $WS.Cells($RowStart,10)  = $obj.EnclosureGroup
         $WS.Cells($RowStart,11)  = $obj.Affinity
         $WS.Cells($RowStart,12)  = $obj.FWEnable
         $WS.Cells($RowStart,13)  = $obj.FWBaseline
         $WS.Cells($RowStart,14)  = $obj.FWMode
         $WS.Cells($RowStart,15)  = $obj.FWInstall
         $WS.Cells($RowStart,16)  = $obj.BIOSSettings
         $WS.Cells($RowStart,17)  = $obj.BootOrder
         $WS.Cells($RowStart,18)  = $obj.BootMode
         $WS.Cells($RowStart,19)  = $obj.PXEBootPolicy
         $WS.Cells($RowStart,20)  = $obj.MACAssignment
         $WS.Cells($RowStart,21)  = $obj.WWNAssignment
         $WS.Cells($RowStart,22)  = $obj.SNAssignment
         $WS.Cells($RowStart,23)  = $obj.HideUnusedFlexNics
         

         $RowStart               += 2               # Add 1 blank line           
            	
         
    }
  
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToProfileConnectionTemplate
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToProfileConnectionTemplate ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.ServerProfileName	
         $WS.Cells($RowStart,2)   = $obj.ConnectionName	
         $WS.Cells($RowStart,3)   = $obj.ConnectionID
         $WS.Cells($RowStart,4)   = $obj.NetworkName	
         $WS.Cells($RowStart,5)   = $obj.PortID
         $WS.Cells($RowStart,6)   = $obj.RequestedBandwidth
         $WS.Cells($RowStart,7)   = $obj.Bootable
         $WS.Cells($RowStart,8)   = $obj.BootPriority
         $WS.Cells($RowStart,9)   = $obj.UserDefined
         $WS.Cells($RowStart,10)  = $obj.ConnectionMACAddress
         $WS.Cells($RowStart,11)  = $obj.ConnectionWWNN
         $WS.Cells($RowStart,12)  = $obj.ConnectionWWPN
         
								
         

         $RowStart               += 2               # Add 1 blank line           
            	
         
    }
  
}

## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToProfileConnection
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToProfileConnection ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.ServerProfileName	
         $WS.Cells($RowStart,2)   = $obj.ConnectionName	
         $WS.Cells($RowStart,3)   = $obj.ConnectionID
         $WS.Cells($RowStart,4)   = $obj.NetworkName	
         $WS.Cells($RowStart,5)   = $obj.PortID
         $WS.Cells($RowStart,6)   = $obj.RequestedBandwidth
         $WS.Cells($RowStart,7)   = $obj.Bootable
         $WS.Cells($RowStart,8)   = $obj.BootPriority
         $WS.Cells($RowStart,9)   = $obj.UserDefined
         $WS.Cells($RowStart,10)  = $obj.ConnectionMACAddress
         $WS.Cells($RowStart,11)  = $obj.ConnectionWWNN
         $WS.Cells($RowStart,12)  = $obj.ConnectionWWPN
         
								
         

         $RowStart               += 2               # Add 1 blank line           
            	
         
    }
  
}
				
## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToProfileLOCALStorage
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToProfileLOCALStorage ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.ProfileName	
         $WS.Cells($RowStart,2)   = $obj.EnableLOCALStorage
         $WS.Cells($RowStart,3)   = $obj.ControllerID
         $WS.Cells($RowStart,4)   = $obj.ControllerMode	
         $WS.Cells($RowStart,5)   = $obj.ControllerInitialize
         $WS.Cells($RowStart,6)   = $obj.LogicalDisks
         $WS.Cells($RowStart,7)   = $obj.Bootable
         $WS.Cells($RowStart,8)   = $obj.DriveType
         $WS.Cells($RowStart,9)   = $obj.RAID
         $WS.Cells($RowStart,10)  = $obj.NumberofDrives
         $WS.Cells($RowStart,11)  = $obj.MinDriveSize
         $WS.Cells($RowStart,12)  = $obj.MaxDriveSize
         	
         

         $RowStart               += 2               # Add 1 blank line           
            	
         
    }
  
}


## -------------------------------------------------------------------------------------------------------------
##
##                     Function Write-ToProfileSANStorage
##
## -------------------------------------------------------------------------------------------------------------

Function Write-ToProfileSANStorage ($WS,[string]$CSVFile, [int16]$RowStart = 15)
{    
    $ThisCSV     = import-CSV $CSVFile

    foreach ($obj in $ThisCSV)
    {
         $WS.Cells($RowStart,1)   = $obj.ProfileName	
         $WS.Cells($RowStart,2)   = $obj.EnableSANstorage
         $WS.Cells($RowStart,3)   = $obj.HostOSType
         $WS.Cells($RowStart,4)   = $obj.VolumeName
         $WS.Cells($RowStart,5)   = $obj.LUN				
         

         $RowStart               += 2               # Add 1 blank line           
            	
         
    }
  
}

# -------------------------------------------------------------------------------------------------------------
#
#                  Main Entry
#
#
# -------------------------------------------------------------------------------------------------------------


if ( (test-path -Path $TemplateFullPath -PathType Leaf) -and (Test-Path -path $CSVFolder) )
{
    # Generate the output file
    $date             = (Get-Date).ToShortDateString() -replace '/', '-'
    $BaseName         = $ExcelName.Split('.')[0]
    $CurrentFolder    = (Get-ChildItem $TemplateFullPath).DirectoryName
    $ExcelFileName    = "$CurrentFolder\$BaseName-$date.xlsx"

    Copy-item  -Path $TemplateFullPath -Destination $ExcelFileName -Force

    # Connect To Excel
    $Excel=New-Object -ComObject Excel.Application
    if ($Excel)
    {
        write-host -foreground Cyan "--------------------------------------------------------------------------------"
        write-host -foreground Cyan "Creating Excel file $ExcelFileName ....                                         "
        write-host -foreground Cyan "--------------------------------------------------------------------------------"

        $worbook=$Excel.WorkBooks.Open($ExcelFileName)
        

        # Fetch CSV Files
        $ListofFiles      = Get-ChildItem $CSVFolder
        foreach ($f in $ListofFiles)
        {
            $SheetName    = $f.BaseName
            
            switch ($SheetName) 
            {
                'AddressPool'   
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToAddressPool -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }
            
                'EthernetNetworks'   
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToEthernetNetwork -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }
                
                'FCNetworks'   
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToFCNetwork -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }
                
                'SANManager'   
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToSANManager -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }

                'StorageSystems'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToStorageSystems -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }
            
                'StorageVolumeTemplate'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToStorageVolumeTemplate -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }
            
                'StorageVolume'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToStorageVolume -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }
                
                'LogicalInterConnectGroup'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToLogicalInterConnectGroup -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }

                'UpLinkSet'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToUpLinkSet -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }

                'OSDeployment'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToOSDeployment -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }

                'EnclosureGroup'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToEnclosureGroup -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }  
                
                'LogicalEnclosure'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToLogicalEnclosure -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                }
                                
                'Enclosure'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToEnclosure -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 
            
                'ProfileTemplate'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToProfileTemplate -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 

                'Profile'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToProfile -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 

                'ProfileTemplateConnection'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToProfileConnection -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 

                'ProfileConnection'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToProfileConnection -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 

                'ProfileTemplateLOCALStorage'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToProfileLOCALStorage -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 
                'ProfileLOCALStorage'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToProfileLOCALStorage -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 

                'ProfileTemplateSANStorage'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToProfileSANStorage -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 
                'ProfileSANStorage'
                                { 
                                    $ThisWorkSheet = $worbook.WorkSheets | where Name -eq $SheetName
                                    if ($ThisWorkSheet)
                                    {
                                        Write-Host -ForegroundColor CYAN "Creating worksheet $SheetName ....."
                                        Write-ToProfileSANStorage -WS $ThisWorkSheet -CSVFile $f.FullName -RowStart 15
                                    }
                                } 
            }
        }

        $worbook.save() 
        $Excel.Quit() 
        
        [gc]::collect() 
        [gc]::WaitForPendingFinalizers() 
    }
    else 
    {
        write-host -ForegroundColor YELLOW "Excel software is not available from this compuer.Cannot generate Excel Sheets.`n Please use a computher that has Excel installed "

    }
} 
else 
{
    write-host -foreground YELLOW " Neither OV Excel Template is provided nor CSV folder does not exist. Skip generating Excel sheets...."
    
}
