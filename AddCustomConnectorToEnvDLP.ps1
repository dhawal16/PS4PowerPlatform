#This Script is for the Environment Admin and not Global Admin

#Install-Module -Name Microsoft.PowerApps.Administration.PowerShell
#Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber

# Here is how you can pass in credentials (avoiding opening a prompt)
Add-PowerAppsAccount

#For adding the custom connector you will require PolicyName [Should be created before this], Connector Name, GroupName as hbi for adding to Business only group [lbi for Non-Business], ConnectorId and ConnectorType as Custom

#Getting the PolicyName [GUID] for the defined DLP for enviornment
$dlpPolicyDispName = Read-Host -Prompt "Please provide the DLP Policy Display Name"
$dlpPolicy = Get-AdminDlpPolicy $dlpPolicyDispName

if($dlpPolicy.Type -like "*environments*")
{
    $envDispName = Read-Host -Prompt "Please provide the Environment Name for this DLP Policy as this is an Environment Level Policy"
    $environment = Get-AdminPowerAppEnvironment "*$envDispName*"
}

#Getting the Custom Connector Name and ConnectorID from Display Name
$custConnDispName = Read-Host -Prompt "Please provide the Custom Connector Display Name"

#pull the list of all custom connectors
$connectorList = Get-AdminPowerAppConnector
foreach( $connector in $connectorList )
{
    if($custConnDispName -eq $connector.DisplayName)
    {
        $custConn = $connector.ConnectorName
        $custConnId = $connector.ConnectorId

        #hbi for Business Only and lbi for Non-business only group.
        if($environment)
        {
            $response = Add-CustomConnectorToPolicy -PolicyName $dlpPolicy.PolicyName -EnvironmentName $environment.EnvironmentName –ConnectorName $custConn -GroupName hbi -ConnectorId $custConnId -ConnectorType Custom
        }
        else
        {
            $response = Add-CustomConnectorToPolicy -PolicyName $dlpPolicy.PolicyName –ConnectorName $custConn -GroupName hbi -ConnectorId $custConnId -ConnectorType Custom
        }

        if($response.Code -eq 200)
        {
            Write-Host "Connector has been added to the DLP"
        }
        else
        {
            Write-Host $response.Error
        }
    }
    else
    {
        Write-Host "No macthing Custom Connector found."
    }
}

