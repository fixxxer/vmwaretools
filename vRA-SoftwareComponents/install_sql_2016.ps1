# Script: Install pre-requisites SQL 
# Author: Servicio Administración Tributaria SAT
# Date:   September 2017  
# Version: 2.0

$MountPath = "192.168.1.2\Scripts\ISOS"
$InstanceName = "MSSQLSERVER"
$MountUsername = "JM\jmadmin"
$MountPassword = "Password01"

$SQLSVCAccount = "JM\jmadmin"
$SQLSVCAccountPassword = "Password01"

$SQLAdmin = "jm\jmadmin"

$ISOFileName = "SW_DVD9_SQL_Svr_Enterprise_Edtn_2016_64Bit_English_MLF_X20-97275.iso"


$SQLDBDIR="G:\Database"
$SQLLOGSDIR="H:\Log"
$SQLTEMPDIR="I:\TempDatabase"
$SQLBACKUPDIR="I:\Backup"              
$instancedir="F:\Program Files\Microsoft SQL Server"
$INSTALLSHAREDDIR="F:\Program Files\Microsoft SQL Server"
$INSTALLSHAREDWOWDIR="F:\Program Files (x86)\Microsoft SQL Server"

Write-Output "Mounting remote software repo"
net use \\$MountPath /user:$MountUsername $MountPassword

$mountresult = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileName -PassThru
$driveletter = ($mountresult | Get-Volume).DriveLetter

$process = $driveletter+':\setup.exe'
$arguments =  " /q /ACTION=Install /UpdateEnabled=0 /FEATURES=SQLENGINE,REPLICATION /INSTALLSHAREDDIR="""+`
$INSTALLSHAREDDIR + """ /INSTALLSHAREDWOWDIR=""" + $INSTALLSHAREDWOWDIR + """ /INSTANCENAME="+$InstanceName+`
"  /INSTANCEDIR=""" + $instancedir + """ /SQLSVCACCOUNT="+$SQLSVCAccount +" /SQLSVCPASSWORD="+$SQLSVCAccountPassword +`
 " /SQLSYSADMINACCOUNTS="+$SQLAdmin +" /AGTSVCACCOUNT=""NT Authority\Network Service""" +`
 " /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS /SQLTEMPDBDIR="""+$SQLTEMPDIR+""" /SQLBACKUPDIR="""+$SQLBACKUPDIR+`
 """ /SQLUSERDBDIR="""+$SQLDBDIR+""" /SQLUSERDBLOGDIR="""+$SQLLOGSDIR+""" /IACCEPTSQLSERVERLICENSETERMS"

Write-Output "Installing SQL Server with instance named $InstanceName"
Try 
     {
     Start-Process $process -ArgumentList $arguments -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to install SQL Server 2014"
     Write-Error $_.Exception
     Exit -1 
  }
#$run = $process + $arguments
#Invoke-Expression -Command $run

Write-Output "Unmounting SQL ISO"
DisMount-DiskImage -ImagePath \\$MountPath\$ISOFileName


##############Instalacion de Management Tools para SQL 2016######################################

$ISOFileName2 = "sqlmgmstd.iso"
Write-Output "Mounting remote management tools"
net use \\$MountPath /user:$MountUsername $MountPassword
$mountresult = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileName2 -PassThru
$driveletter = ($mountresult | Get-Volume).DriveLetter

$process2 = $driveletter+':\SSMS-Setup-ENU.exe'
$arguments2 =  " /passive /quiet /norestart"

Write-Output "Installing SQL Server Management Tools"
Try 
     {
     Start-Process $process2 -ArgumentList $arguments2 -PassThru -Wait -ErrorAction Stop
     }
Catch
     {
     Write-Error "Failed to install SQL Server 2016 Management Tools"
     Write-Error $_.Exception
     Exit -1 
  }


Write-Output "Unmounting SQL ISO"
DisMount-DiskImage -ImagePath \\$MountPath\$ISOFileName2

