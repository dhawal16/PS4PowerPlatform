#Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force
#Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber -Force


#pull the list of all DLP Policy of the tenant
$dlpPolicies = Get-AdminDlpPolicy


# file path
$connectorFilePath = "./PowerPlatform-AllDLPPolicyDetail.csv"

# Add the header to the csv file
$connectorFileHeaders = "DLP PolicyName," `
        + "DLP Policy DisplayName," `
        + "Created On," `
        + "Created By," `
        + "Modified On," `
        + "Modified By," `
        + "Filter Type," `
        + "Environments," `
        + "ConnectorDisplayName," `
        + "ConnectorId," `
        + "Connector Group";

Add-Content -Path $connectorFilePath -Value $connectorFileHeaders


foreach($dlpConnectors in $dlpPolicies)
{

    $dlpID = $dlpConnectors.PolicyName
    $dlpDispName = $dlpConnectors.DisplayName
    $dlpCreatedOn = $dlpConnectors.CreatedTime
    $dlpCreatedBy = $dlpConnectors.CreatedBy.userPrincipalName
    $dlpModifiedOn = $dlpConnectors.LastModifiedTime
    $dlpModifiedBy = $dlpConnectors.LastModifiedBy.userPrincipalName
    $dlpFilter = $dlpConnectors.FilterType

    if(($dlpConnectors.Environments) -And ($dlpConnectors.Environments.Length -ge 0))
    {
        foreach($env in $dlpConnectors.Environments)
        {
            $dlpEnvironments = $dlpEnvironments + ";" + $env.name
        }
        $dlpEnvironments = $dlpEnvironments.Remove(0,1)
    }
    else
    {
        $dlpEnvironments = ""
    }
        
        foreach( $connector in $dlpConnectors.BusinessDataGroup)
        {

            $connectorDisplayName = $connector.name
            if($connectorDisplayName)
            {
                $connectorDisplayName = $connectorDisplayName.replace(","," ")
            }

            #$connectorType = "Business Only"

            $row = $dlpID + "," `
            + $dlpDispName + "," `
            + $dlpCreatedOn + "," `
            + $dlpCreatedBy + "," `
            + $dlpModifiedOn + "," `
            + $dlpModifiedBy + "," `
            + $dlpFilter + "," `
            + $dlpEnvironments + "," `
            + $connectorDisplayName + "," `
            + $connector.id + "," `
            + "Business Only";
            Add-Content -Path $connectorFilePath -Value $row 
        }
        foreach( $connector in $dlpConnectors.NonBusinessDataGroup )
        {

            $connectorDisplayName = $connector.name
            if($connectorDisplayName)
            {
                $connectorDisplayName = $connectorDisplayName.replace(","," ")
            }

            #$connectorType = "Non-Business"

            $row = $dlpID + "," `
            + $dlpDispName + "," `
            + $dlpCreatedOn + "," `
            + $dlpCreatedBy + "," `
            + $dlpModifiedOn + "," `
            + $dlpModifiedBy + "," `
            + $dlpFilter + "," `
            + $dlpEnvironments + "," `
            + $connectorDisplayName + "," `
            + $connector.id + "," `
            + "Non-Business";
            Add-Content -Path $connectorFilePath -Value $row  
        }
        foreach( $connector in $dlpConnectors.BlockedGroup )
        {

            $connectorDisplayName = $connector.name
            if($connectorDisplayName)
            {
                $connectorDisplayName = $connectorDisplayName.replace(","," ")
            }

            #$connectorType = "Blocked"

            $row = $dlpID + "," `
            + $dlpDispName + "," `
            + $dlpCreatedOn + "," `
            + $dlpCreatedBy + "," `
            + $dlpModifiedOn + "," `
            + $dlpModifiedBy + "," `
            + $dlpFilter + "," `
            + $dlpEnvironments + "," `
            + $connectorDisplayName + "," `
            + $connector.id + "," `
            + "Blocked";
            Add-Content -Path $connectorFilePath -Value $row 
        }  
         
}