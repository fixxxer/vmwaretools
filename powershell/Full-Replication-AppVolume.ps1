<#
.DESCRIPTION
    This script replicate all assigments from Source AppVolume to Target AppVolume. Deleting all previous assignements existing on Target App Volume.
    Usage: Full-Replication-AppVolume.ps1
.NOTES
    Version:        1.0
    Author:         Anibal Avelar
    Github:         http://www.github.com/fixxxer/vmwaretools/powershell
    Based on previous script of Stephane Asselin, https://blogs.vmware.com/euc/2017/07/app-volumes-automated-entitlement-replication.html
#>

add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
 
 
$Credentials = @{
username = 'domain\username'
password = 'password'
}
$SourceServer = "SourceServerFQDN"
$TargetServer = "DestinationServerFQDN"

Invoke-RestMethod -SessionVariable SourceServerSession -Method Post -Uri "https://$SourceServer/cv_api/sessions" -Body $Credentials
Invoke-RestMethod -SessionVariable TargetServerSession -Method Post -Uri "https://$TargetServer/cv_api/sessions" -Body $Credentials
$SourceAssignments = (Invoke-RestMethod -WebSession $SourceServerSession -Method Get -Uri "https://$SourceServer/cv_api/assignments").assignments
$SourceAppstacks = Invoke-RestMethod -WebSession $SourceServerSession -Method Get -Uri "https://$SourceServer/cv_api/appstacks"
$TargetAppStacks = Invoke-RestMethod -WebSession $TargetServerSession -Method Get -Uri "https://$TargetServer/cv_api/appstacks"

# begin section to delete target assigments
$TargetAssignments = (Invoke-RestMethod -WebSession $TargetServerSession -Method Get -Uri "https://$TargetServer/cv_api/assignments").assignments
foreach ($Assignment in $TargetAssignments)
{
    forearch ($TargetAppStack in $TargetAppStacks)
    {
        Invoke-RestMethod -WebSession $TargetServerSession -Method Post -Uri "https://$TargetServer/cv_api/assignments?action_type=unassign&id=$($TargetAppStack.id)&assignments%5B0%5D%5Bentity_type%5D=$($assignment.entityt)&assignments%5B0%5D%5Bpath%5D=$($assignment.entity_dn)"
    }
}
# end section to delete target assigments

foreach ($Assignment in $SourceAssignments)
{
    $SourceAppStack = $SourceAppStacks.Where({$_.id -eq $assignment.snapvol_id})[0]
    $TargetAppStack = $TargetAppStacks.Where({$_.name -eq $SourceAppstack.name})[0]
    Invoke-RestMethod -WebSession $TargetServerSession -Method Post -Uri "https://$TargetServer/cv_api/assignments?action_type=assign&id=$($TargetAppStack.id)&assignments%5B0%5D%5Bentity_type%5D=$($assignment.entityt)&assignments%5B0%5D%5Bpath%5D=$($assignment.entity_dn)"
}