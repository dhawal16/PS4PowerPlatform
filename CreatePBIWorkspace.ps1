#Install the Power BI Workspace Mgmt Module

Install-Module -Name MicrosoftPowerBIMgmt.Workspaces

## Login to Power BI using an account with service admin rights.
Login-PowerBI

#For getting the Workspace Name
$WSName = Read-Host -Prompt 'Provide the name of the Workspace to be created'

#New Workspace V2 Creation
$NewWPName = New-PowerBIWorkspace -Name $WSName

#Getting the Admin which needed to be added as Workspace Admin
$WSAdmin = Read-Host -Prompt 'Please provide the e-mail ID for the Workspace Admin '

#Adding the Power BI Workpace Admin
Add-PowerBIWorkspaceUser -UserEmailAddress $WSAdmin -AccessRight "Admin" -Id $NewWPName.ID

#Workspace Creation completed
Write-Host "New Workspace $WSName has been created and admin access has been provided to $WSAdmin" -ForegroundColor red -BackgroundColor white
