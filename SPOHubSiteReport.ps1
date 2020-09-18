Install-Module Microsoft.Online.SharePoint.PowerShell -Force
Import-Module Microsoft.Online.SharePoint.PowerShell
Get-Module

Write-Host " "

$SPOAdminURL = Read-Host -Prompt "Please enter your Sharepoint Admin URL (e.g. 'https://contoso-admin.sharepoint.com')"
 
Connect-SPOService -Url $SPOAdminURL

$arrReport = @()


Get-SPOHubSite | ForEach {
   $countryCode = ""
   $countryExists = $false

   if($_.SiteUrl -ne $null)
   {
        write-host "Site Url: " $_.SiteUrl
        $splitUrl = $_.SiteUrl -split '/sites/'
        $countryCode = $splitURL[1].Substring(0,2)
   }
   else
   {
        if($_.LogoUrl -ne $null)
        {
            write-host "Logo Url (Site Url missing): " $_.LogoUrl
            $splitUrl = $_.LogoUrl -split '/sites/'
            $countryCode = $splitURL[1].Substring(0,2)
        }
        else
        {
            $countryCode = "Unknown"
        }
   }

   $countryExists = $arrReport | Where {$_.CountryCode -eq $countryCode} | Select HubCount

   if($countryExists -eq $null)
   {
       $arrReport += ([PSCustomObject]@{CountryCode = $countryCode;  HubCount = 1})
   }
   else
   {
       $selectedCC = $arrReport | Where {$_.CountryCode -eq $countryCode}
       $selectedCC.HubCount = $selectedCC.HubCount +1
   }

}

$arrReport

$arrReport | Export-Csv -Path "C:\SPOHubReport.csv"

Write-Host "Export to 'C:\SPOHubReport.csv'"
Write-Host " "