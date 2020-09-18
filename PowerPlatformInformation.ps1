#Install the PowerApps Admin Cmdlets
#https://powerapps.microsoft.com/en-us/blog/gdpr-admin-powershell-cmdlets/

#Install-Module -Name Microsoft.PowerApps.Administration.PowerShell
#Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber

# Here is how you can pass in credentials (avoiding opening a prompt)
Add-PowerAppsAccount

#For getting the list of Environment Name where have admin access | Type | Region | Created By | Created | Number of Apps


Get-AdminPowerAppEnvironment | Export-Csv -Path '.\PowerAppEnvironmentExport.csv'
Get-AdminPowerApp | Export-Csv -Path '.\PowerAppExport.csv'
Get-AdminFlow | Export-Csv -Path '.\FlowExport.csv'
