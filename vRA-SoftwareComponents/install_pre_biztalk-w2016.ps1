# Script: Install pre-requisites Biztalk 2016 using vRA Component Services
# Author: Anibal Avelar <aavelar@vmware.com>
# Date: Oct 11, 2017
# Version: 1.3
# Changes for Win 2016
# Based on work from Juan Manuel Silva Koch <Juan.Silva@Cloudcontinuity.com.mx>

$MountPath = "Srmjump02\sql2014"
$MountUsername = "CPN\vra_service"
$MountPassword = "VMware1!"

$ISOFileNameWin = "en_windows_server_2012_r2_x64_dvd_2707946.iso"

net use \\$MountPath /user:$MountUsername $MountPassword
$mountresultwin = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin -PassThru
$driveletterwin = ($mountresultwin | Get-Volume).DriveLetter

# Set Windows installation media path
$sxsdir = $driveletterwin+':\Sources\sxs'

# Create the Servicing Registry Key and LocalSourcePath String Value
New-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing -Force
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing -Name "LocalSourcePath" -Value $sxsdir -Force


Write-Host("Installing Windows Features...") -Fore Green

# Install required Windows Features
Import-Module ServerManager
Install-WindowsFeature -name FS-FileServer -Source $sxsdir
Install-WindowsFeature -name Storage-Services -Source $sxsdir
Install-WindowsFeature -name Web-Default-Doc -Source $sxsdir
Install-WindowsFeature -name Web-Dir-Browsing -Source $sxsdir
Install-WindowsFeature -name Web-Http-Errors -Source $sxsdir
Install-WindowsFeature -name Web-Static-Content -Source $sxsdir
Install-WindowsFeature -name Web-Http-Logging -Source $sxsdir
Install-WindowsFeature -name Web-Log-Libraries -Source $sxsdir
Install-WindowsFeature -name Web-ODBC-Logging -Source $sxsdir
Install-WindowsFeature -name Web-Request-Monitor -Source $sxsdir
Install-WindowsFeature -name Web-Http-Tracing -Source $sxsdir
Install-WindowsFeature -name Web-Stat-Compression -Source $sxsdir
Install-WindowsFeature -name Web-Dyn-Compression -Source $sxsdir
Install-WindowsFeature -name Web-Filtering -Source $sxsdir
Install-WindowsFeature -name Web-Basic-Auth -Source $sxsdir
Install-WindowsFeature -name Web-Digest-Auth -Source $sxsdir
Install-WindowsFeature -name Web-Windows-Auth -Source $sxsdir

Install-WindowsFeature -name Web-App-Dev -IncludeAllSubFeature -Source $sxsdir
Install-WindowsFeature -name Web-Mgmt-Tools -IncludeAllSubFeature -Source $sxsdir

Install-WindowsFeature -name NET-Framework-Core -Source $sxsdir
Install-WindowsFeature -name NET-Framework-45-Core -Source $sxsdir
Install-WindowsFeature -name NET-Framework-45-ASPNET -Source $sxsdir
Install-WindowsFeature -name NET-WCF-HTTP-Activation45 -Source $sxsdir
Install-WindowsFeature -name NET-WCF-TCP-PortSharing45 -Source $sxsdir
Install-WindowsFeature -name RDC -Source $sxsdir
Install-WindowsFeature -name RSAT-AD-PowerShell -Source $sxsdir
Install-WindowsFeature -name RSAT-AD-AdminCenter -Source $sxsdir
Install-WindowsFeature -name RSAT-ADDS-Tools -Source $sxsdir
Install-WindowsFeature -name RSAT-ADLDS -Source $sxsdir
Install-WindowsFeature -name FS-SMB1 -Source $sxsdir
Install-WindowsFeature -name PowerShell -Source $sxsdir
Install-WindowsFeature -name PowerShell-V2 -Source $sxsdir
Install-WindowsFeature -name PowerShell-ISE -Source $sxsdir
Install-WindowsFeature -name WAS-Process-Model -Source $sxsdir
Install-WindowsFeature -name WAS-Config-APIs -Source $sxsdir
Install-WindowsFeature -name WoW64-Support -Source $sxsdir

$process = "cscript.exe"
$arguments = "c:\inetpub\adminscripts\adsutil.vbs SET W3SVC/AppPools/Enable32bitAppOnWin64 1"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run cscript.exe"
     Write-Error $_.Exception
     Exit -1 
  }

########################REVISAR SI EL NOMBRE DE EQUIPO ES CORRECTO########################################################

$computerName = [system.environment]::MachineName
$computerNameLength = $computerName.length

# Valid computer name
if ($computerNameLength -lt 16) {
    Write-Host("El nombre de equipo es: $computerName, el cual es de $computerNameLength caracteres y valido para instalar BiztalK.") -fore Green
}
# Invalid computer name
else {
    Write-Host("El nombre de equipo es: $computerName, el cual es de $computerNameLength . Necesita ser cambiado ahora!") -fore Red
    exit
}


####################################Deshabilitar IPv6########################################################

Write-Host("Conexiones IPv6 deshabilitadas ... ") -fore Green
New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\' -Name  'DisabledComponents' -Value '0xffffffff' -PropertyType 'DWord'

#Write-Host("Conexiones IPv6 actualmente habilitadas:") -fore Green
#Get-NetAdapterBinding -ComponentID ms_tcpip6
#$netAdapterName = Read-Host("`nCual red IPv6 quieres deshabilitar (Escribir el atributo NAME)?")
#Disable-NetAdapterBinding -Name $netAdapterName -ComponentID ms_tcpip6


########################HABILITAR DTC##########################################################################
# Enable MSDTC for Network Access
Write-Host "Enabling MSDTC for Network Access..." –fore green
 
try {
    Set-DtcNetworkSetting –DtcName Local –AuthenticationLevel Mutual –InboundTransactionsEnabled 1 –OutboundTransactionsEnabled 1 –RemoteClientAccessEnabled 1 –confirm:$false
 
    Restart-Service MSDTC
 
    Write-Host "`nMSDTC Ha sido configurado y reiniciado"
}
catch {
    Write-Host "MSDTC Fallo en la habilitacion. Por favor revisar los logs" -fore red
}

######Funcionando
Write-Host "vcredist_86.exe ..."
#$command5 = "\\$MountPath\BiztalKPrevFiles\vcredist_x86.exe /q" 
#Invoke-Expression -Command $command5 | Out-Null

$process = "\\$MountPath\BiztalKPrevFiles\vcredist_x86.exe"
$arguments = "/install /quiet"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run vcredist_x86.exe"
     Write-Error $_.Exception
     Exit -1 
  }

######Funcionando
Write-Host "sqlxml_x64.msi ..."
#$command4 = "\\$MountPath\BiztalkPrevFiles\sqlxml_x64.msi /q"
#Invoke-Expression -Command $command4 | Out-Null

$process = "\\$MountPath\BiztalkPrevFiles\sqlxml_x64.msi"
$arguments = "/q"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run sqlxml_x64.msi"
     Write-Error $_.Exception
     Exit -1 
  }

######Funcionando
Write-Host "owc11.exe ..."
#$command2 = "\\$MountPath\BiztalkPrevFiles\owc11.exe /passive /quiet /norestart"
#Invoke-Expression -Command $command2 | Out-Null

$process = "\\$MountPath\BiztalkPrevFiles\owc11.exe"
$arguments = "/passive /quiet /norestart"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run owc11.exe"
     Write-Error $_.Exception
     Exit -1 
  }

####Funcionando
Write-Host "SQL_AS_ADOMD.msi ..."
#$command3 = "\\$MountPath\BiztalkPrevFiles\SQL_AS_ADOMD.msi /q"
#Invoke-Expression -Command $command3 | Out-Null

$process = "\\$MountPath\BiztalkPrevFiles\SQL_AS_ADOMD.msi"
$arguments = "/q"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run SQL_AS_ADOMD.msi"
     Write-Error $_.Exception
     Exit -1 
  }

######Funcionando
Write-Host "Windows8.1-KB2919442-x64.msu ..."
#$command5 = "wusa.exe \\$MountPath\BiztalkPrevFiles\Windows8.1-KB2919442-x64.msu /quiet /norestart"
#Invoke-Expression -Command $command5 | Out-Null

$process = "wusa.exe"
$arguments = "\\$MountPath\BiztalkPrevFiles\Windows8.1-KB2919442-x64.msu /quiet /norestart"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run wusa.exe Windows8.1-KB2919442-x64.msu"
     Write-Error $_.Exception
     Exit -1 
  }

#####Funcionando
Write-Host "clearcompressionflag.exe ..."
#$command6 = "\\$MountPath\BiztalkPrevFiles\clearcompressionflag.exe /q"
#Invoke-Expression -Command $command6 | Out-Null

$process = "\\$MountPath\BiztalkPrevFiles\clearcompressionflag.exe"
$arguments = "/q"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run clearcompressionflag.exe"
     Write-Error $_.Exception
     Exit -1 
  }


######Funcionando
Write-Host "Windows8.1-KB2919355-x64.msu ..."
#$command7 = "wusa.exe \\$MountPath\BiztalkPrevFiles\Windows8.1-KB2919355-x64.msu /quiet /norestart"
#Invoke-Expression -Command $command7 | Out-Null

$process = "wusa.exe"
$arguments = "\\$MountPath\BiztalkPrevFiles\Windows8.1-KB2919355-x64.msu /quiet /norestart"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run wusa.exe Windows8.1-KB2919355-x64.msu"
     Write-Error $_.Exception
     Exit -1 
  }

######Funcionando
Write-Host "Windows8.1-KB2932046-x64.msu ..."
#$command8 = "wusa.exe \\$MountPath\BiztalkPrevFiles\Windows8.1-KB2932046-x64.msu /quiet /norestart"
#Invoke-Expression -Command $command8 | Out-Null

$process = "wusa.exe"
$arguments = "\\$MountPath\BiztalkPrevFiles\Windows8.1-KB2932046-x64.msu /quiet /norestart"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run wusa.exe Windows8.1-KB2932046-x64.msu"
     Write-Error $_.Exception
     Exit -1 
  }

######Funcionando
Write-Host "Windows8.1-KB2934018-x64.msu ..."
#$command9 = "wusa.exe \\$MountPath\BiztalkPrevFiles\Windows8.1-KB2934018-x64.msu /quiet /norestart"
#Invoke-Expression -Command $command9 | Out-Null

$process = "wusa.exe"
$arguments = "\\$MountPath\BiztalkPrevFiles\Windows8.1-KB2934018-x64.msu /quiet /norestart"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run wusa.exe Windows8.1-KB2934018-x64.msu"
     Write-Error $_.Exception
     Exit -1 
  }

######Funcionando
Write-Host "Windows8.1-KB2937592-x64.msu ..."
#$command10 = "wusa.exe \\$MountPath\BiztalkPrevFiles\Windows8.1-KB2937592-x64.msu /quiet /norestart"
#Invoke-Expression -Command $command10 | Out-Null

$process = "wusa.exe"
$arguments = "\\$MountPath\BiztalkPrevFiles\Windows8.1-KB2937592-x64.msu /quiet /norestart"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run wusa.exe Windows8.1-KB2937592-x64.msu"
     Write-Error $_.Exception
     Exit -1 
  }

######Funcionando
Write-Host "Windows8.1-KB2938439-x64.msu ..."
#$command11 = "wusa.exe \\$MountPath\BiztalkPrevFiles\Windows8.1-KB2938439-x64.msu /quiet /norestart"
#Invoke-Expression -Command $command11 | Out-Null

$process = "wusa.exe"
$arguments = "\\$MountPath\BiztalkPrevFiles\Windows8.1-KB2938439-x64.msu /quiet /norestart"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run wusa.exe Windows8.1-KB2938439-x64.msu"
     Write-Error $_.Exception
     Exit -1 
  }

###### No Funcionando
Write-Host "NDP452-KB2901907-x86-x64-AllOS-ENU.exe ..."
#$command12 = "\\$MountPath\BiztalkPrevFiles\NDP452-KB2901907-x86-x64-AllOS-ENU.exe /q" 
#Invoke-Expression -Command $command12 | Out-Null

$process = "\\$MountPath\BiztalkPrevFiles\NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
$arguments = "/quiet /norestart﻿"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
     Write-Error $_.Exception
     Exit -1 
  }

Write-Host "Windows8.1-KB2959977-x64.msu ..."
#$command13 = "wusa.exe \\$MountPath\BiztalkPrevFiles\Windows8.1-KB2959977-x64.msu /quiet /norestart" 
#Invoke-Expression -Command $command13 | Out-Null

$process = "wusa.exe"
$arguments = "\\$MountPath\BiztalkPrevFiles\Windows8.1-KB2959977-x64.msu /quiet /norestart"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to run wusa.exe Windows8.1-KB2959977-x64.msu"
     Write-Error $_.Exception
     Exit -1 
  }


Write-Output "Unmounting Windows ISO"
DisMount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin

#Shutdown -r -t 01
