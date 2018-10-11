<#
.DESCRIPTION
        This script create a new BD, create a new local DB user. 
        Set new user as owner in new DB. Finally assigns sysadmin role to new user.
        Usage: SQL-CreateDB.ps1 dbname dbuser dbpass
.NOTES
        Version:        1.0
        Author:         Anibal Avelar
        Github:         http://www.github.com/fixxxer/vmwaretools/powercli
#>

param(
[string]$dbName=$null,
[string]$dbUser=$null,
[string]$dbPass=$null
)
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null

$serverName = "IAAS-W8-01A"
$instance = "SQLEXPRESS"

$server = new-object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $serverName\$instance

$server.ConnectionContext.LoginSecure=$false;
$loginName="sa"
$loginPassword="VMware1!" 
$server.ConnectionContext.set_Login($loginName);
$server.ConnectionContext.set_Password($loginPassword)
$server.ConnectionContext.ApplicationName="SQLDeploymentScript"

#Create a new database
try{
$dbC = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $server, $dbName
}catch{
   $error[0]|format-list -force
   exit 1
}
$dbC.Create()

#Create login
$login = new-object -TypeName Microsoft.SqlServer.Management.Smo.Login $server, $dbUser
$login.LoginType="SqlLogin"
$login.PasswordPolicyEnforced=$false
$login.PasswordExpirationEnabled=$false
$login.Create($dbPass)
Write-Host("Login $dbUser created successfully") 

$db = $server.Databases[$dbName]
$db.SetOwner($dbUser,$TRUE)
$db.alter()
Write-Host("Owner $dbUser assigned successfully")

$db.CreateDate

$User = $db.Users[$dbUser]
if(!($User)){
	$User = new-object -TypeName Microsoft.SqlServer.Management.Smo.User -ArgumentList $db, $login.Name
	$User.DefaultSchema = "dbo"
	$User.Login = $login.Name
	$User.create
	Write-Host("User $dbUser created successfully")
}

$Role = $server.Roles['sysadmin']
$Role.AddMember($login.Name)
Write-Host("Role $dbUser = db_owner assigned successfully")


