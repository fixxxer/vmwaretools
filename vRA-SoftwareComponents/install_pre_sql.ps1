# Script: Install pre-requisites SQL 2014 using vRA Component Services
# Author: Anibal Avelar <aavelar@vmware.com>
# Date: Oct 17, 2017
# Version: 1.2
# Support for Win 2016
# Based on work from Juan Manuel Silva Koch <Juan.Silva@Cloudcontinuity.com.mx>

$MountPath = "Srmjump02\sql2014"
$MountUsername = "CPN\vra_service"
$MountPassword = "vRa!17.3/3"

$ISOFileNameWin = "en_windows_server_2012_r2_x64_dvd_2707946.iso"


net use \\$MountPath /user:$MountUsername $MountPassword
$mountresultwin = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin -PassThru
$driveletterwin = ($mountresultwin | Get-Volume).DriveLetter

$sxsdir = $driveletterwin+':\Sources\sxs'

$SQLDBDIR="C:\Database"
$SQLLOGSDIR="C:\Log"
$SQLTEMPDIR="C:\TempDatabase"
$SQLBACKUPDIR="C:\Backup"
$instancedir="C:\Program Files\Microsoft SQL Server"
$INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server"
$INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server"                       

########FASE DE PRERREQUISITOS################################################
Import-Module ServerManager;


#Obtener la version actual del sistema operativo
$WindowsVersion = [environment]::OsVersion.Version

#Añadir .NET 3.5 en cualquiera de sus versiones
If (($WindowsVersion.Major -eq 6) -and ($WindowsVersion.Minor -lt 2)) {Add-WindowsFeature AS-Net-Framework;}
Elseif (($WindowsVersion.Major -eq 6) -and ($WindowsVersion.Minor -ge 2)) {Add-WindowsFeature Net-Framework-Core -Source $sxsdir;}
Elseif (($WindowsVersion.Major -eq 10) -and ($WindowsVersion.Minor -eq 0)) {Add-WindowsFeature Net-Framework-Core -Source $sxsdir;}

#Añadir reglas de firewall necesarias para SQL
netsh advfirewall firewall add rule name="SQL Instancia" dir=in action=allow protocol=TCP localport=1433
netsh advfirewall firewall add rule name="SQL Dedicated Admin" dir=in action=allow protocol=TCP localport=1434
netsh advfirewall firewall add rule name="SQL SRSS HTTP" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="SQL SRSS HTTPS" dir=in action=allow protocol=TCP localport=443
netsh advfirewall firewall add rule name="SQL FileStream" dir=in action=allow protocol=TCP localport=139
netsh advfirewall firewall add rule name="SQL FileTables" dir=in action=allow protocol=TCP localport=445
netsh advfirewall firewall add rule name="SQL Analisys Services" dir=in action=allow protocol=TCP localport=2383
netsh advfirewall firewall add rule name="SQL DTC" dir=in action=allow protocol=TCP localport=135
netsh advfirewall firewall add rule name="SQL Browser" dir=in action=allow protocol=UDP localport=1434
Write-Host("Reglas de firewall creada exitosamente, puertos abiertos 1433, 1434, 80, 443, 139, 445, 2383, 135") -Fore Green


#Crear directorios para trabajar
New-Item -ItemType directory -Path $SQLTEMPDIR
New-Item -ItemType directory -Path $SQLBACKUPDIR
New-Item -ItemType directory -Path $SQLDBDIR
New-Item -ItemType directory -Path $SQLLOGSDIR
New-Item -ItemType directory -Path $instancedir
New-Item -ItemType directory -Path $INSTALLSHAREDWOWDIR
Write-Host("Carpetas creadas satisfactoriamente") -Fore Green


#Instalar rol de FailoverCluster para AlwaysOn
Add-WindowsFeature Failover-Clustering -Source $sxsdir
Add-WindowsFeature RSAT-Clustering-Mgmt -Source $sxsdir
Add-WindowsFeature RSAT-Clustering-PowerShell -Source $sxsdir
Add-WindowsFeature RSAT-Clustering-AutomationServer -Source $sxsdir
Add-WindowsFeature RSAT-Clustering-CmdInterface -Source $sxsdir

Write-Host("Roles requeridos instalados, al presionar continuar se reiniciara el equipo.") -Fore Green

Write-Output "Unmounting Windows ISO"
DisMount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin

#Shutdown -r -t 01
