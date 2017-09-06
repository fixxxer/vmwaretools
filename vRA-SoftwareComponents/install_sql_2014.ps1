# Script: Install SQL 2014 using vRA Component Services
# Author: Anibal Avelar <aavelar@vmware.com>
# Date: Jul 18, 2017
# Version: 1.1
# Based on work from Juan Manuel Silva Koch <Juan.Silva@Cloudcontinuity.com.mx>

$MountPath = "Srmjump02\sql2014"
$InstanceName = "Prueba"
$MountUsername = "CPN\vra_service"
$MountPassword = "vRa!17.3/3"

$SQLSVCAccount = "Administrator"
$SQLSVCAccountPassword = "VMware1!"

$SQLAdmin = "CPN\vra_service"

$ISOFileName = "SW_DVD9_SQL_Svr_Ent_Core_2014_64Bit_English_MLF_X19-34257.iso"


$SQLDBDIR="C:\Database"
$SQLLOGSDIR="C:\Log"
$SQLTEMPDIR="C:\TempDatabase"
$SQLBACKUPDIR="C:\Backup"              
$instancedir="C:\Program Files\Microsoft SQL Server"
$INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server"
$INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server"

Write-Output "Mounting remote software repo"
net use \\$MountPath /user:$MountUsername $MountPassword

$mountresult = Mount-DiskImage -ImagePath \\$MountPath\$ISOFileName -PassThru
$driveletter = ($mountresult | Get-Volume).DriveLetter

$process = $driveletter+':\setup.exe'
$arguments =  " /q /ACTION=Install /UpdateEnabled=0 /FEATURES=SQLENGINE,REPLICATION,SSMS,ADV_SSMS /INSTALLSHAREDDIR="""+`
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



