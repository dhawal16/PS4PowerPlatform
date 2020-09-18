#Get-AdminPowerAppConnector | Export-Csv -Path "C:\CustomConnectors.csv"

#pull the list of connectors for the default environment
$connectorList = Get-AdminPowerAppConnector

# file path
$connectorFilePath = "./PowerPlatform-CustomConnectors.csv"

# Add the header to the csv file
$connectorFileHeaders = "ConnectorId," `
        + "ConnectorDisplayName," `
        + "ConnectorDescription," `
        + "Environment Name," `
        + "Created By," `
        + "Standard/Premium";
Add-Content -Path $connectorFilePath -Value $connectorFileHeaders

foreach( $connector in $connectorList )
{

    $connectorId = $connector.ConnectorName
    $connectorDisplayName = $connector.DisplayName
    if($connectorDisplayName)
    {
        $connectorDisplayName = $connectorDisplayName.replace(","," ")
    }

    $connectorDescription = $connector.Internal.description
    if($connectorDescription)
    {
        $connectorDescription = $connectorDescription.replace(","," ")        
        $connectorDescription = $connectorDescription.replace("`n"," ")        
        $connectorDescription = $connectorDescription.replace("`r"," ")
    }
    
    $connectorIsPremiumOrStandard =  $connector.EnvironmentName
    $connectorReleaseDate = $connector.CreatedBy.userPrincipalName
    $connectorPublisher = $connector.Internal.tier

    $row = $connectorId + "," `
        + $connectorDisplayName + "," `
        + $connectorDescription + "," `
        + $connectorIsPremiumOrStandard + "," `
        + $connectorReleaseDate + "," `
        + $connectorPublisher;
    Add-Content -Path $connectorFilePath -Value $row 
}