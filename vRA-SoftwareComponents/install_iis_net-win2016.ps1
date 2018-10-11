# Script: Install IIS under Windows 2016 using vRA Component Services
# Author: Anibal Avelar <aavelar@vmware.com>
# Date: Jul 18, 2017
# Version: 1.1

$MountPath = "Srmjump02\sql2014"
$MountUsername = "CPN\vra_service"
$MountPassword = "VMware1!"

$ISOFileNameWin = "SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-3_MLF_X21-30353.iso"


net use \\$MountPath /user:$MountUsername $MountPassword
$mountresultwin = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin -PassThru
$driveletterwin = ($mountresultwin | Get-Volume).DriveLetter

$sxsdir = $driveletterwin+':\Sources\sxs'

########FASE DE PRERREQUISITOS################################################
Import-Module ServerManager;


#Obtener la version actual del sistema operativo
$WindowsVersion = [environment]::OsVersion.Version

#Añadir .NET 3.5 en cualquiera de sus versiones
If (($WindowsVersion.Major -eq 6) -and ($WindowsVersion.Minor -lt 2)) {Add-WindowsFeature AS-Net-Framework;}
Elseif (($WindowsVersion.Major -eq 6) -and ($WindowsVersion.Minor -ge 2)) {Add-WindowsFeature Net-Framework-Core -Source $sxsdir;}

Write-Host("NET Framework 3.5 (incluidos 2.0 y 3.0) instalados correctamente") -ForegroundColor Green

#################FASE de roles y caracteristicas##############################
Import-Module ServerManager
#Install-WindowsFeature -Name Application-Server  -Source $sxsdir
#Install-WindowsFeature -Name AS-NET-Framework  -Source $sxsdir
Install-WindowsFeature -Name Web-Server  -Source $sxsdir
Write-Host("Roles & Features instalados correctamente, se reiniciara el equipo") -ForegroundColor Green

#Shutdown -r -t 01
