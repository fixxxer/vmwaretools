# Script: Install pre-requisites SharePoint 2016 using vRA Component Services
# Author: Anibal Avelar <aavelar@vmware.com>
# Date: Oct 11, 2017
# Version: 1.1
# Changes for Win 2016
# Based on work from Juan Manuel Silva Koch <Juan.Silva@Cloudcontinuity.com.mx>


$MountPath = "Srmjump02\sql2014"
$MountUsername = "CPN\vra_service"
$MountPassword = "vRa!17.3/3"

$ISOFileNameWin = "SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-3_MLF_X21-30353.iso"


#$ISOFileName = "SW_DVD5_SharePoint_Server_2016_64Bit_English_MLF_X20-97223.iso"


net use \\$MountPath /user:$MountUsername $MountPassword
$mountresultwin = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin -PassThru
$driveletterwin = ($mountresultwin | Get-Volume).DriveLetter

#$mountresult = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileName -PassThru
#$driveletter = ($mountresult | Get-Volume).DriveLetter

$sxsdir = $driveletterwin+':\Sources\sxs'


Write-Host("Installing Windows Features...") -Fore Green

# Install required Windows Features
Import-Module ServerManager


#######################Instalacion de Roles y caracteristicas como prerrequisitos############
Add-WindowsFeature Net-Framework-Features -Source $sxsdir
Add-WindowsFeature Web-Server -Source $sxsdir
Add-WindowsFeature Web-WebServer -Source $sxsdir
Add-WindowsFeature Web-Common-Http -Source $sxsdir
Add-WindowsFeature Web-Static-Content -Source $sxsdir
Add-WindowsFeature Web-Default-Doc -Source $sxsdir
Add-WindowsFeature Web-Dir-Browsing -Source $sxsdir
Add-WindowsFeature Web-Http-Errors -Source $sxsdir
Add-WindowsFeature Web-App-Dev -Source $sxsdir
Add-WindowsFeature Web-Asp-Net -Source $sxsdir
Add-WindowsFeature Web-Net-Ext -Source $sxsdir
Add-WindowsFeature Web-ISAPI-Ext -Source $sxsdir
Add-WindowsFeature Web-ISAPI-Filter -Source $sxsdir
Add-WindowsFeature Web-Health -Source $sxsdir
Add-WindowsFeature Web-Http-Logging -Source $sxsdir
Add-WindowsFeature Web-Log-Libraries -Source $sxsdir
Add-WindowsFeature Web-Request-Monitor -Source $sxsdir
Add-WindowsFeature Web-Http-Tracing -Source $sxsdir
Add-WindowsFeature Web-Security -Source $sxsdir
Add-WindowsFeature Web-Basic-Auth -Source $sxsdir
Add-WindowsFeature Web-Windows-Auth -Source $sxsdir
Add-WindowsFeature Web-Filtering -Source $sxsdir
Add-WindowsFeature Web-Digest-Auth -Source $sxsdir
Add-WindowsFeature Web-Performance -Source $sxsdir
Add-WindowsFeature Web-Stat-Compression -Source $sxsdir
Add-WindowsFeature Web-Dyn-Compression -Source $sxsdir
Add-WindowsFeature Web-Mgmt-Tools -Source $sxsdir
Add-WindowsFeature Web-Mgmt-Console -Source $sxsdir
Add-WindowsFeature Web-Mgmt-Compat -Source $sxsdir
Add-WindowsFeature Web-Metabase -Source $sxsdir
Add-WindowsFeature Application-Server -Source $sxsdir
Add-WindowsFeature AS-Web-Support -Source $sxsdir
Add-WindowsFeature AS-TCP-Port-Sharing -Source $sxsdir
Add-WindowsFeature AS-WAS-Support -Source $sxsdir
Add-WindowsFeature AS-HTTP-Activation -Source $sxsdir
Add-WindowsFeature AS-TCP-Activation -Source $sxsdir
Add-WindowsFeature AS-Named-Pipes -Source $sxsdir
Add-WindowsFeature AS-Net-Framework -Source $sxsdir
Add-WindowsFeature WAS -Source $sxsdir
Add-WindowsFeature WAS-Process-Model -Source $sxsdir
Add-WindowsFeature WAS-NET-Environment -Source $sxsdir
Add-WindowsFeature WAS-Config-APIs -Source $sxsdir
Add-WindowsFeature Web-Lgcy-Scripting -Source $sxsdir
Add-WindowsFeature Windows-Identity-Foundation -Source $sxsdir
Add-WindowsFeature Server-Media-Foundation -Source $sxsdir
Add-WindowsFeature Xps-Viewer -Source $sxsdir

##########################Instalacion de SoftwareAdicional Requerido#######################
#$command1 = "C:\Scripts\SPPrevFiles\sqlncli.msi /passive IACCEPTSQLNCLILICENSETERMS=YES"
#Invoke-Expression $command1

$process = "\\$MountPath\SPPrevFiles\sqlncli.msi"
$arguments = "/quiet IACCEPTSQLNCLILICENSETERMS=YES"
Write-Host("Installing $process $arguments ") -Fore Green

Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
    }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }


#$command2 = "C:\Scripts\SPPrevFiles\Windows8.1-KB2898850-x64.msu /quiet /norestart"
#Invoke-Expression $command2 
#Pause

$process = "wusa.exe"
$arguments = "\\$MountPath\SPPrevFiles\Windows8.1-KB2898850-x64.msu /quiet /norestart"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

#$command3 = "C:\Scripts\SPPrevFiles\MicrosoftIdentityExtensions-64.msi /quiet"
#Invoke-Expression $command3

$process = "\\$MountPath\SPPrevFiles\MicrosoftIdentityExtensions-64.msi"
$arguments = "/quiet"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
    Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }


#$command4 = "C:\Scripts\SPPrevFiles\Synchronization.msi /passive"
#Invoke-Expression $command4

$process = "\\$MountPath\SPPrevFiles\Synchronization.msi"
$arguments = "/quiet"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

#$command5 = "C:\Scripts\SPPrevFiles\WindowsServerAppFabricSetup_x64.exe /i /GAC"
#Invoke-Expression $command5

#$process = $driveletter+":\prerequisiteinstaller.exe"
#$arguments = "/SQLNCli:\\$MountPath\SPPrevFiles\sqlncli.msi /IDFX11:\\$MountPath\SPPrevFiles\MicrosoftIdentityExtensions-64.msi /Sync:\\$MountPath\SPPrevFiles\Synchronization.msi /MSIPCClient:\\$MountPath\SPPrevFiles\setup_msipc_x64.msi /WCFDataServices56:\\$MountPath\SPPrevFiles\WcfDataServices.exe /DotNetFx:\\$MountPath\SPPrevFiles\NDP462-KB3151800-x86-x64-AllOS-ENU.exe /MSVCRT11:\\$MountPath\SPPrevFiles\vcredist_x64.exe /MSVCRT14:\\$MountPath\SPPrevFiles\vc_redist.x64.exe /KB3092423:\\$MountPath\SPPrevFiles\AppFabric-KB3092423-x64-ENU.exe /ODBC:\\$MountPath\SPPrevFiles\msodbcsql.msi /AppFabric:\\$MountPath\SPPrevFiles\WindowsServerAppFabricSetup_x64.exe /unattended /continue"
$process = "\\$MountPath\SPPrevFiles\WindowsServerAppFabricSetup_x64.exe"
$arguments = "/i /GAC"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

#sleep 30 
#$command6 = "C:\Scripts\SPPrevFiles\AppFabric-KB3092423-x64-ENU.exe /Norestart /quiet"
#Invoke-Expression $command6

$process = "\\$MountPath\SPPrevFiles\AppFabric-KB3092423-x64-ENU.exe"
$arguments = "/quiet /norestart"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

# sleep 15

#$command7 = "C:\Scripts\SPPrevFiles\setup_msipc_x64.msi /quiet /passive"
#Invoke-Expression $command7

$process = "\\$MountPath\SPPrevFiles\setup_msipc_x64.msi"
$arguments = "/quiet"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }


#$command8 = "C:\Scripts\SPPrevFiles\WcfDataServices.exe /quiet /passive"
#Invoke-Expression $command8

$process = "\\$MountPath\SPPrevFiles\WcfDataServices.exe"
$arguments = "/quiet"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

#$command9 = "C:\Scripts\SPPrevFiles\NDP462-KB3151800-x86-x64-AllOS-ENU.exe /passive /norestart"
#Invoke-Expression $command9

$process = "\\$MountPath\SPPrevFiles\NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
$arguments = "/quiet /norestart"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

#$command10 = "C:\Scripts\SPPrevFiles\vcredist_x64.exe /passive /norestart"
#Invoke-Expression $command10

$process = "\\$MountPath\SPPrevFiles\vcredist_x64.exe"
$arguments = "/quiet /norestart"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

#$command11 = "C:\Scripts\SPPrevFiles\vc_redistx64.exe /passive /norestart"
#Invoke-Expression $command11

$process = "\\$MountPath\SPPrevFiles\vc_redist.x64.exe"
$arguments = "/quiet /norestart"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

#$command12 = "C:\Scripts\SPPrevFiles\Windows8.1-KB2898850-x64.msu /quiet /norestart"
#Invoke-Expression $command12

$process = "wusa.exe"
$arguments = "\\$MountPath\SPPrevFiles\Windows8.1-KB2898850-x64.msu /quiet /norestart"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }

#$command13 = "C:\Scripts\SPPrevFiles\msodbcsql.msi /passive IACCEPTMSODBCSQLLICENSETERMS=YES"
#Invoke-Expression $command13

$process = "\\$MountPath\SPPrevFiles\msodbcsql.msi"
$arguments = "/quiet IACCEPTMSODBCSQLLICENSETERMS=YES"
Write-Host("Installing $process $arguments ") -Fore Green
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run $process $arguments"
     Write-Error $_.Exception
     Exit -1 
 }


Write-Output "Unmounting Windows ISO"
DisMount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin

#Write-Output "Unmounting SharePoint 2016 ISO"
#DisMount-DiskImage -ImagePath \\$MountPath\$ISOFileName

#Shutdown -r -t 01

