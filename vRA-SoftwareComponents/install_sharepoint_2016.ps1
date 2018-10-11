# Script: Install pre-requisites SharePoint 2016 using vRA Component Services
# Author: Anibal Avelar <aavelar@vmware.com>
# Date: Jul 12, 2017
# Version: 1.1
# Based on work from Juan Manuel Silva Koch <Juan.Silva@Cloudcontinuity.com.mx>

$MountPath = "Srmjump02\sql2014"
$MountUsername = "CPN\vra_service"
$MountPassword = "VMware1!"

$ISOFileName = "SW_DVD5_SharePoint_Server_2016_64Bit_English_MLF_X20-97223.iso"


Write-Output "Mounting remote software repo"
net use \\$MountPath /user:$MountUsername $MountPassword

$mountresult = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileName -PassThru
$driveletter = ($mountresult | Get-Volume).DriveLetter

$process = $driveletter+':\setup.exe'
$arguments =  "/config \\$MountPath\Sharepoint\Sharepoint2016Config.xml"

Write-Output "Installing Sharepoint 2016"

Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to install Sharepoint 2016"
     Write-Error $_.Exception
     Exit -1 
  }

Write-Output "Unmounting Sharepoint ISO"
DisMount-DiskImage -ImagePath \\$MountPath\$ISOFileName

