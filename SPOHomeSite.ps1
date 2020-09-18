Install-Module Microsoft.Online.SharePoint.PowerShell -Force
Import-Module Microsoft.Online.SharePoint.PowerShell

$SPOAdminURL = Read-Host -Prompt "Please enter your Sharepoint Admin URL (e.g. 'https://contoso-admin.sharepoint.com')"
 
Connect-SPOService -Url $SPOAdminURL

$homeURL = Read-Host -Prompt "Please provide the SPO Site URL which needs to make as SPO Home Site"

Set-SPOHomeSite -HomeSiteUrl $homeURL
