#Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force
#Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber -Force

#pull the list of connectors for the default environment
$connectorList = Get-PowerAppEnvironment -Default | Get-PowerAppConnector

# file path
$connectorFilePath = "./PowerPlatform-AllConnectors.csv"

# Add the header to the csv file
$connectorFileHeaders = "ConnectorId," `
        + "ConnectorDisplayName," `
        + "ConnectorDescription," `
        + "IsConnectorPremiumOrStandard," `
        + "ConnectorReleaseDate," `
        + "ConnectorModifiedDate," `
        + "Publisher";
Add-Content -Path $connectorFilePath -Value $connectorFileHeaders

foreach( $connector in $connectorList )
{

    $connectorId = $connector.ConnectorId
    $connectorDisplayName = $connector.DisplayName.replace(","," ")
    
    $connectorDescription = $connector.Description
    if($connectorDescription)
    {
        $connectorDescription = $connectorDescription.replace(","," ")        
        $connectorDescription = $connectorDescription.replace("`n"," ")        
        $connectorDescription = $connectorDescription.replace("`r"," ")
    }
    
    $connectorIsPremiumOrStandard =  $connector.Tier
    $connectorReleaseDate = $connector.CreatedTime
    $connectorModifiedDate = $connector.ChangedTime
    $connectorPublisher = $connector.Publisher.replace(","," ")

    $row = $connectorId + "," `
        +$connectorDisplayName + "," `
        + $connectorDescription + "," `
        + $connectorIsPremiumOrStandard + "," `
        + $connectorReleaseDate + "," `
        + $connectorModifiedDate + "," `
        + $connectorPublisher;
    Add-Content -Path $connectorFilePath -Value $row 
}