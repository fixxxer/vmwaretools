# Script: Install Biztalk 2016 using vRA Component Services
# Author: Anibal Avelar <aavelar@vmware.com>
# Date: Jul 16, 2017
# Version: 1.1
# Based on work from Juan Manuel Silva Koch <Juan.Silva@Cloudcontinuity.com.mx>


$MountPath = "Srmjump02\sql2014"
$MountUsername = "CPN\vra_service"
$MountPassword = "vRa!17.3/3"

$ISOFileNameWin = "SW_DVD5_BizTalk_Server_Ent_2016_English_MLF_X21-21277.iso"


$INSTALLSHAREDDIR="""C:\Program Files\Microsoft BizTalk Server"""

Import-Module ServerManager

net use \\$MountPath /user:$MountUsername $MountPassword
$mountresultwin = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin -PassThru
$driveletterwin = ($mountresultwin | Get-Volume).DriveLetter

$mediabts="${driveletterwin}:\Biztalk Server\Setup.exe"

$mediasso="${driveletterwin}:\BizTalk Server\Platform\SSO\sso.msi"

Write-Host("Recuerda que la unidad donde se instalara el aplicativo es $INSTALLSHAREDDIR") -Fore Red


########################Instalacion SSO#######################################################################
#$command=  $mediasso + " /quiet /norestart" 
#Invoke-Expression -Command $command

Write-Host("Instalando SSO") -Fore Green

$process = $mediasso
$arguments = "/quiet /norestart"
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


##################Instalacion Biztalk 2016############################

#$command = $mediabts + " /quiet /promptrestart /addlocal AdditionalApps /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR" 
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 1 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal AdditionalApps /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal SSOAdmin /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 2 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal SSOAdmin /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal SSOServer /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 3 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal SSOServer /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal BizTalk /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 4 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal BizTalk /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal WMI /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 5 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal WMI /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal Engine /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 6 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal Engine /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal Runtime /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 7 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal Runtime /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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

#$command = $mediabts + " /quiet /promptrestart /addlocal MOT /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 8 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal MOT /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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

#$command = $mediabts + " /quiet /promptrestart /addlocal MSMQ /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 9 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal MSMQ /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal MsEDIAS2 /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 10 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal MsEDIAS2 /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal MsEDIAS2StatusReporting /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 11 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal MsEDIAS2StatusReporting /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal WCFAdapter /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server""" 
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 12 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal WCFAdapter /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal AdminAndMonitoring /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 13 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal AdminAndMonitoring /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal AdminTools /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 14 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal AdminTools /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal MonitoringAndTracking /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 15 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal MonitoringAndTracking /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal BizTalkAdminSnapIn /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 16 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal BizTalkAdminSnapIn /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal BAMTools /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 17 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal BAMTools /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal PAM /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 18 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal PAM /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal WcfAdapterAdminTools /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 19 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal WcfAdapterAdminTools /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal BAMPortal /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 20 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal BAMPortal /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


#$command = $mediabts + " /quiet /promptrestart /addlocal RulesEngine /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR "+"""f:\program files\Microsoft BizTalk Server"""
#Invoke-Expression -Command $command

Write-Host("Instalando Herramienta paso 21 de 21") -Fore Green

$process = $mediabts
$arguments = "/quiet /promptrestart /addlocal RulesEngine /COMPANYNAME SAT /IGNOREDEPENDENCIES /INSTALLDIR $INSTALLSHAREDDIR"
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


Write-Output "Unmounting BizTalk ISO"
DisMount-DiskImage -ImagePath \\$MountPath\$ISOFileNameWin

Shutdown -r -t 01
        
