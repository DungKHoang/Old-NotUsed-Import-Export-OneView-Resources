# Import and Export OneView resources

Import-OVResources.ps1 and Export-OVResources.ps1 are PowerShell scripts that leverage HPE OneView PowerShell library and Excel to automate configuration of OneView OVResources
Import-OVResources.ps1 uses CSV files extracted from the XLSx tabs to provide settings for dieffrent resources.
Export-OVresources.ps1 queries to OneView to collect settings from OV resoucres and save them in CSV files.

## Prerequisites
Both scripts require the latest OneView PowerShell library : https://github.com/HewlettPackard/POSH-HPOneView/releases

## Excel spreadsheet

There are two different Excel sheets:
   * OneView-C7000
   * OneView-Synergy

Each sheet has multiple tabs for various OV resources. Customize those tabs to fit with your environment and save each tab in a separate CSV file
You will use CSV files as input for the Import script.

## Import-OVResources.PS1 

Import-OVResources.ps1 is a PowerShell script that configures OV resources based on CSV files including:
   * Address Pool
   * Ethernet newtorks
   * Network set
   * FC / FCOE networks
   * SAN Manager
   * Storage Systems: 3PAR
   * Storage Volume templates
   * Storage Volumes
   * Logical InterConnect Groups
   * Uplink Sets
   * Enclosure Groups
   * Enclosures
   * DL Servers 
   * Network connections
   * Local Storage connections
   * SAN Storage connections
   * Server Profile Templates
   * Server Profiles

## Syntax

### To create Address Pools

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVAddressPoolCSV c:\AddressPool.csv

```

### To create Ethernet networks

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVEthernetNetworksCSV c:\EthernetNetworks.csv

```

### To create SAN Manager

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVSANManagerCSV c:\SANManager.csv

```

### To import SAN Storage Systems

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVSANStorageSystemCSV c:\SANStorageSystem.csv

```

### To create FC networks

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVFCNetworksCSV c:\FCNetworks.csv

```

### To create Volume Templates

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVStorageVolumeTemplateCSV c:\StorageVolumeTemplate.csv

```

### To create Storage Volume

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVStorageVolumeCSV c:\StorageVolume.csv

```

### To create Logical Interconnect Group

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVLogicalInterconnectGroup c:\LogicalInterconnectGroup.csv

```
### To create UplinkSet

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVuplinkSetCSV c:\Uplinkset.csv

```

### To create Enclosure Group

```
.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVEnclosureGroupCSV c:\EnclosureGroup.csv

```

### To import Enclosure

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVEnclosureCSV c:\Enclosure.csv

```

### To import DL servers

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVServerCSV c:\Server.csv

```


### To create Server profile Template

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVProfileTemplateCSV c:\ProfileTemplate.csv -OVProfileLOCALStorageCSV c:\ProfileLOCALStorage.csv -OVProfileSANStorageCSV c:\ProfileSANStorage.csv -OVProfileConnectionCSV c:\ProfileConnection.csv

```

### To create Server profile

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVProfileCSV c:\Profile.csv -OVProfileLOCALStorageCSV c:\ProfileLOCALStorage.csv -OVProfileSANStorageCSV c:\ProfileSANStorage.csv -OVProfileConnectionCSV c:\ProfileConnection.csv

```

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------


## Export-OVResources.PS1 

Export-OVResources.ps1 is a PowerShell script that exports OV resources into CSV files including:
   * Address Pool
   * Ethernet newtorks
   * Network set
   * FC / FCOE networks
   * SAN Manager
   * Storage Systems: 3PAR
   * Storage Volume templates
   * Storage Volumes
   * Logical InterConnect Groups
   * Uplink Sets
   * Enclosure Groups
   * Enclosures
   * DL Servers 
   * Network connections
   * Local Storage connections
   * SAN Storage connections
   * Server Profile Templates
   * Server Profiles
   * IP addresses used by Synergy components
   * WWWNN when there are FC networks in profile


## Syntax

### To export all resources

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -All

```

### To export Address Pools

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVAddressPoolCSV c:\AddressPool.csv

```

### To export Ethernet networks

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVEthernetNetworksCSV c:\EthernetNetworks.csv

```

### To export SAN Manager

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVSANManagerCSV c:\SANManager.csv

```

### To Export SAN Storage Systems

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVSANStorageSystemCSV c:\SANStorageSystem.csv

```

### To export FC networks

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVFCNetworksCSV c:\FCNetworks.csv

```

### To export Volume Templates

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVStorageVolumeTemplateCSV c:\StorageVolumeTemplate.csv

```

### To export Storage Volume

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVStorageVolumeCSV c:\StorageVolume.csv

```

### To export Logical Interconnect Group

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVLogicalInterconnectGroup c:\LogicalInterconnectGroup.csv

```
### To export UplinkSet

```
    .\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVuplinkSetCSV c:\Uplinkset.csv

```

### To export Enclosure Group

```
.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVEnclosureGroupCSV c:\EnclosureGroup.csv

```

### To export Enclosure

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVEnclosureCSV c:\Enclosure.csv

```

### To export DL Servers

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVServerCSV c:\Servers.csv

```

### To export Server profile Template

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVProfileTemplateCSV c:\ProfileTemplate.csv -OVProfileLOCALStorageCSV c:\ProfileLOCALStorage.csv -OVProfileSANStorageCSV c:\ProfileSANStorage.csv -OVProfileConnectionCSV c:\ProfileConnection.csv

```

### To export Server profile

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVProfileCSV c:\Profile.csv -OVProfileLOCALStorageCSV c:\ProfileLOCALStorage.csv -OVProfileSANStorageCSV c:\ProfileSANStorage.csv -OVProfileConnectionCSV c:\ProfileConnection.csv

```

### To export WWNN

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVWWNNCSV c:\wwnn.csv

```

### To export IP addresses

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVipCSV c:\ip.csv

```


## Generate CSV files from Excel file

The Import-OVResource.ps1 described above uses CSV files as parameter to create OneView resources.
An administrator can leverage the Excel sheet templates provided in the pacakge to define OneView resources for their environment. He can generate CSV files by saving each sheet as CSV
The Save-AsCSV.ps1 reads an Excel file and automatically generates CSV files per sheet. Those CSV files can be used for the Import-OVResources script.

Note: This requires that you have Excel software on your local computer
The syntax is described as below

### To export Excel spreadsheet to CSV files

```

.\OV-Excel\Save-AsCSV -ExcelFile .\OneView.xlsx -CSVFolder Import_CSV

```

## Generate Excel OneView spreadsheet from CSV files

Using the Export-OVResources.ps1 script, an administrator can save configuration of OneView resources through CSV files. He can then assemble CSV files into a single Excel spreadsheet to document configuration of OneView.
The Write-ToExcel.ps1 script reads CSV files and automatically generates Excel spreadhseet based on a template provided in the package.

Note: This requires that you have Excel software on your local computer
The syntax is described as below

### To generate Excel file from exported CSV files

```
.\OV-Excel\Write-ToExcel.ps1  -TemplateFullPath c:\OV-Excel\OSynergy-Template.xlsx -CSVFolder MyImportCSVFolder -ExcelName MyExcelName.Xlsx

```
