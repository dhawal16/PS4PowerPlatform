#Install the Power BI Workspace Mgmt Module
#Install-Module -Name MicrosoftPowerBIMgmt.Workspaces

## Login to Power BI using an account with service admin rights.
Login-PowerBI
#Connect-AzureAD

$workspaces = Get-PowerBIWorkspace -Scope Organization -All

$workspaceFilePath = "./PowerBI-Workspaces.csv"

# Add the header to the csv file
$wsFileHeaders = "Workspace Id," `
        + "Workspace Name," `
        + "Workspace Type," `
        + "Workspace State," `
        + "IsReadOnly," `
        + "IsOrphaned," `
        + "IsOnDedicatedCapacity," `
        + "CapacityId," `
        + "Workspace Owner(s)";

Add-Content -Path $workspaceFilePath -Value $wsFileHeaders

foreach ($ws in $workspaces) 
{
    $owners = $null
    
    if ($ws.State -eq 'Active') 
    { 
        if ($ws.Type -eq 'Workspace' -or $ws.Type -eq 'PersonalGroup')
        {
            $u = $ws.Users | Where-Object AccessRight -eq 'Admin' | Select-Object UserPrincipalName
            $owners = $u.UserPrincipalName -join ";"
        }
        elseif($ws.Type -eq 'Group')
        {
            $go = Get-AzureADGroupOwner -ObjectId $ws.Id
            $owners = $go.UserPrincipalName -join ";" 
        }
    } 

    $row = $ws.Id.Guid + "," `
        + $ws.Name + "," `
        + $ws.Type + "," `
        + $ws.State + "," `
        + $ws.IsReadOnly + "," `
        + $ws.IsOrphaned + "," `
        + $ws.IsOnDedicatedCapacity + "," `
        + $ws.CapacityId + "," `
        + $owners;

    Add-Content -Path $workspaceFilePath -Value $row 
    
}
