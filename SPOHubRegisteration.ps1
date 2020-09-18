Install-Module Microsoft.Online.SharePoint.PowerShell -Force
Import-Module Microsoft.Online.SharePoint.PowerShell

$SPOAdminURL = Read-Host -Prompt "Please enter your Sharepoint Admin URL (e.g. 'https://contoso-admin.sharepoint.com')"
 
Connect-SPOService -Url $SPOAdminURL

$hubURL = Read-Host -Prompt "Please provide the SPO Site URL which needs to promoted as Hub"
$whoCanAssociate = Read-Host -Prompt "Please provide the user's email Ids [Comma "," sperated] who can associate site with this Hub, if left blank anyone can associate their site with this Hub"

Register-SPOHubSite -Site $hubURL -Principals $null
if($whoCanAssociate.Length -gt 0)
{
    $allUsers = $whoCanAssociate.Split(",")
    foreach($user in $allUsers)
    {
        Grant-SPOHubSiteRights -Identity $hubURL -Principals $user -Rights Join
    }
}