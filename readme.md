#Import and Export OneView resources

Import-OVResources.ps1 and Export-OVResources.ps1 are PowerShell scripts that leverage HPE OneView PowerShell library and Excel to automate configuration of OneView OVResources
Import-OVResources.ps1 uses CSV files extracted from the XLSx tabs to provide settings for dieffrent resources.
Export-OVresources.ps1 queries to OneView to collect settings from OV resoucres and save them in CSV files.

## Import-OVResources.PS1 
Import-OVResources.ps1 is a PowerShell script that including:
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


