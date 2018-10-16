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
   * Ethernet networks
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
   * Backup configuration
   * OS Deployment for Image Streame
   * OneView License
   * Firmware bundles
   * Time & Locale Settings
   * SMTP Settings
   * Alert Settings
   * Scope Settings
   * Users 
   * Firmware Bundles
   * Backup Settings
   * Remote Support Settings
   * Proxy settings
   * LDAP settings
   * LDAP Groups

## Syntax

   * By default the POSH OneView module is HPOneView.410. If you use a different OneView module, use -OneviewModule to specify the library version of POSH, for example -OneViewModule HPOneView.310
   * By default the login domain to OneView/Composer is set to LOCAL. If you use AD credential, use -OVAuthDomain to specify the Active Directory Domain, for example -OVAuthDomain AD.int

### To import  all configuration
   You can use the switch -ALL to import all configuration into OneView based on a pre-defined set of CSV that includes:
   * EthernetNetworks.csv
   * NetworkSet.csv
   * FCNetworks.csv

   * LogicalInterConnectGroup.csv
   * UpLinkSet.csv

   * EnclosureGroup.csv
   * Enclosure.csv
   * LogicalEnclosure.csv
   * DLServers.csv

   * Profiles.csv
   * ProfileConnection.csv
   * ProfileLOCALStorage.csv
   * ProfileSANStorage.csv

   * ProfileTemplate.csv
   * ProfileTemplateConnection.csv
   * ProfileTemplateLOCALStorage.csv
   * ProfileTemplateSANStorage.csv

   * SANManager.csv
   * StorageSystems.csv
   * StorageVolumeTemplate.csv
   * StorageVolume.csv

   * AddressPool.csv
   * Wwnn.csv
   * IPAddress.csv
   * OSDeployment.csv

   * OVLicense.txt
   * Firmware.csv
        SPP_2018.06.20180709_for_HPE_Synergy_Z7550-96524.iso"
   * TimeLocale.csv
   * SMTP.csv
   * Alerts.csv
   * Scopes.csv
   * Users.csv
   * FWRepositories.csv
   * BackupConfigurations.csv
   * OVRSConfiguration.csv
   * Proxy.csv
   * LDAP.csv
   * LDAPGroups.csv

### To import  Address Pools

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVAddressPoolCSV c:\AddressPool.csv

```

### To import  Ethernet networks

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVEthernetNetworksCSV c:\EthernetNetworks.csv

```

### To import  SAN Manager

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVSANManagerCSV c:\SANManager.csv

```

### To import SAN Storage Systems

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVSANStorageSystemCSV c:\SANStorageSystem.csv

```

### To import  FC networks

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVFCNetworksCSV c:\FCNetworks.csv

```

### To import  Volume Templates

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVStorageVolumeTemplateCSV c:\StorageVolumeTemplate.csv

```

### To import  Storage Volume

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVStorageVolumeCSV c:\StorageVolume.csv

```

### To import  Logical Interconnect Group

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVLogicalInterconnectGroup c:\LogicalInterconnectGroup.csv

```
### To import  UplinkSet

```
    .\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVuplinkSetCSV c:\Uplinkset.csv

```

### To import  Enclosure Group

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


### To import  Server profile Template

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVProfileTemplateCSV c:\ProfileTemplate.csv -OVProfileLOCALStorageCSV c:\ProfileLOCALStorage.csv -OVProfileSANStorageCSV c:\ProfileSANStorage.csv -OVProfileConnectionCSV c:\ProfileConnection.csv

```

### To import  Server profile

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVProfileCSV c:\Profile.csv -OVProfileLOCALStorageCSV c:\ProfileLOCALStorage.csv -OVProfileSANStorageCSV c:\ProfileSANStorage.csv -OVProfileConnectionCSV c:\ProfileConnection.csv

```

### To import Backup Configurations
The login credential to the remote backup server needs to included in the CSV file.
```
.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVBackupConfig c:\BackupConfig.csv

```

### To Import Backup Configurations

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVBackupConfig c:\BackupConfig.csv

```
### To import Firmware Repositories

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVFWReposCSV c:\FirmwareRepositories.csv

```

### To Import Time Locale

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVTimeLocaleCSV c:\TimeLocale.csv

```

### To import Proxy

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVProxyCSV c:\Proxy.csv

```
### To import SMTP

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVsmtpCSV c:\smtp.csv

```
### To import LDAP

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVldapCSV c:\ldap.csv

```
### To import alerts

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVAlertsCSV c:\alerts.csv

```

### To import OSDeployment

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVOSDeploymentCSV c:\OSDeployment.csv

```

### To import LDAPgroups

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVldapgroupsCSV c:\ldapgroups.csv

```

### To import scopes

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVscopesCSV c:\scopes.csv

```

### To import users

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVusersCSV c:\scopes.csv

```

### To Import RemoteSupport Config

```

.\Import-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVRSConfigCSV c:\RSConfig.csv

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
   * OS Deployment for Image Streamer
   * OneView License
   * Firmware bundles
   * Time & Locale Settings
   * SMTP Settings
   * Alert Settings
   * Scope Settings
   * Users 
   * Firmware Bundles
   * Backup Settings
   * Remote Support Settings
   * Proxy settings
   * LDAP settings
   * LDAP Groups

## Syntax

   * By default the POSH OneView module is HPOneView.410. If you use a different OneView module, use -OneviewModule to specify the library version of POSH, for example -OneViewModule HPOneView.310
   * By default the login domain to OneView/Composer is set to LOCAL. If you use AD credential, use -OVAuthDomain to specify the Active Directory Domain, for example -OVAuthDomain AD.int

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


### To export Backup Configurations

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVBackupConfig c:\BackupConfig.csv

```
### To export Firmware Repositories

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVFWReposCSV c:\FirmwareRepositories.csv

```

### To export Time Locale

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVTimeLocaleCSV c:\TimeLocale.csv

```

### To export Proxy

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVProxyCSV c:\Proxy.csv

```
### To export SMTP

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVsmtpCSV c:\smtp.csv

```
### To export LDAP

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVldapCSV c:\ldap.csv

```

### To export alerts

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVAlertsCSV c:\alerts.csv

```

### To export OSDeployment

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVOSDeploymentCSV c:\OSDeployment.csv

```

### To export LDAPgroups

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVldapgroupsCSV c:\ldapgroups.csv

```

### To export scopes

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVscopesCSV c:\scopes.csv

```

### To export users

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVusersCSV c:\scopes.csv

```

### To export RemoteSupport Config

```

.\Export-OVResources.ps1 -OVApplianceIP <OV-IP-Address> -OVAdminName <Admin-name> -OVAdminPassword <password> -OVRSConfigCSV c:\RSConfig.csv

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
