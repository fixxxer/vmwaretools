<#
.DESCRIPTION
	This script connects to an ESXi host and runs an UNMAP against each datastore to reclaim space from thin file operations.
	Usage: AutoUnmap.ps1 ESXiHostname
	Requires ESXi version >= 6.0 & PowerCLI 6.5 U2
.NOTES
  	Version:        1.0
  	Author:         Anibal Avelar
  	Github:         http://www.github.com/fixxxer/vmwaretools
#>
Param
(
   [Parameter(Mandatory=$true)]
   $HostName
)
 
$User = "your_username"                            
$Password = "yourpassword"                 
$Rest = "300"                         
#below sets the vmfs block per iteration value. Default is 200
$blocks = "300"
 
#ensure snap in is loaded so PS execution is possible and remove any cert warnings
If ((Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue) -eq $null ) { 
  Add-PSSnapin VMware.VimAutomation.Core }
  Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false
   
  #it's go time 
  Connect-VIServer -Server $HostName -user $User -password $Password  
  $HostEsxCli = Get-EsxCli -VMHost $HostName
  $DataStores = Get-Datastore | Where-Object {$_.ExtensionData.Summary.Type -eq 'VMFS' -And $_.ExtensionData.Capability.PerFileThinProvisioningSupported} | Sort-Object Name
  ForEach ($DStore in $DataStores) { 
      Write-Host " ------------------------------------------------------------ " -ForegroundColor 'yellow'
      Write-Host " -- Starting Unmap on DataStore $DStore -- " -ForegroundColor 'yellow' 
      Write-Host " ------------------------------------------------------------ " -ForegroundColor 'yellow'
      $HostEsxCli.storage.vmfs.unmap($blocks,"$DStore", $null)
      Write-Host " ------------------------------------------------------------ " -ForegroundColor 'green'
      Write-Host " -- Unmap has completed on DataStore $DStore -- " -ForegroundColor 'green'
      Write-Host " ------------------------------------------------------------ " -ForegroundColor 'green'
      Start-Sleep -s $Rest
  }