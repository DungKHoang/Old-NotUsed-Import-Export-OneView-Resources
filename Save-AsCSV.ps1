## -------------------------------------------------------------------------------------------------------------
##
##
##      Description: SaveAs-CSV for OV Resources
##
## DISCLAIMER
## The sample scripts are not supported under any HPE standard support program or service.
## The sample scripts are provided AS IS without warranty of any kind. 
## HP further disclaims all implied warranties including, without limitation, any implied 
## warranties of merchantability or of fitness for a particular purpose. 
##
##    
## Scenario
##     	Generate CSV files from OneView Resources Xlsx 
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
     Generate CSV files from OV resources Excel spreasheet
  
    .DESCRIPTION
      Generate CSV files from OV resources Excel spreasheet.
    This will be used as input to Import-OVResources.PS1
        
    .EXAMPLE
    .\Write-toExcel.ps1 -TemplaeFullPath "c:\Ov-Excel\Synergy-Template.xlsx" -CSVFolder "c:\OV-Excel\CSV" -ExcelName "OV-Output.xlsx"

    .PARAMETER ExcelFile                 
        Full path of Xlsx resources file

    .PARAMETER CSVFolder                 
        Folder containing CSV files
    

    #Requires PS -Version 5.0
 #>
  
## -------------------------------------------------------------------------------------------------------------

Param (
    [string]$ExcelFile                 = "C:\OV-Excel\Synergy.xlsx",
    [string]$CSVFolder                 = "C:\OV-Excel\csv"
)


# -------------------------------------------------------------------------------------------------------------
#
#                  Main Entry
#
#
# -------------------------------------------------------------------------------------------------------------


if (test-path -Path $ExcelFile -PathType Leaf) 
{
    # Check CSV Folder - If not existed then created it
    $CurrentFolder    = (Get-ChildItem $ExcelFile).DirectoryName
    $CSVFolder        = $CSVFolder.TrimEnd('\')

    if (-not (Test-path -Path $CSVFolder))
    {
        $OutputFolder = $CSVFolder.Split('\')[-1]
        $OutputFolder = "$CurrentFolder\" + $OutputFolder
        write-host -ForegroundColor YELLOW "CSV Folder $CSVFolder specified does not exist. Will create CSV folder as $OutputFolder...."
        md $Outputfolder > $null
        $CSVFolder = $OutputFolder
    }


    # Connect To Excel
    $Excel=New-Object -ComObject Excel.Application
    if ($Excel)
    {
        write-host -foreground Cyan "--------------------------------------------------------------------------------"
        write-host -foreground Cyan "Generating CSV file from $ExcelFile ....                                        "
        write-host -foreground Cyan "--------------------------------------------------------------------------------"

        $worbook=$Excel.WorkBooks.Open($ExcelFile)
        foreach ($sheet in $worbook.Worksheets)
        {
            $SheetName = $sheet.Name
            if ($SheetName -ne 'Version')
            {
                $csvFile  = "$CSVFolder\$SheetName" + ".CSV"
                write-host -ForegroundColor CYAN "Generating $CsvFile from sheet $SheetName..."
                $sheet.SaveAs($csvFile,6)
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
    write-host -foreground YELLOW "No valid Excel file $ExcelFile provided. Skip generating Excel sheets...."
    
}
