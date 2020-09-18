#Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force
#Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber -Force

#NOTE: This will not move Built-In Connectors like Mail, HTTP, HTTP WebHook and When HTTP Request received so you have to move those manually.
# Also with this script we are not moving any Custom Connectors.

#pull the policy which we want to duplicate
$dupPolicyName = Read-Host -Prompt "Please provide the DLP Policy Name which you want to Duplicate"
$dlpPolicy = Get-AdminDlpPolicy $dupPolicyName
if (![bool]($dlpPolicy.PSobject.Properties.name -match "name"))
{
    Write-Host "DLP Policy with this name not found" -ForegroundColor Red
    Return
}


#Create the new policy with makeing Blocked as Default
# EnvironmentType options are 1) All Environments 2) OnlyEnvironments [For Inclusion] 3) ExceptEnvrionments [For Exclusion] and 4) SingleEnvironment [For Environment Policy]
# When you don't provide Environments to apply, it creates the policy without applying to any environment 

$newPolicyName = Read-Host -Prompt "Please provide the NEW DLP Policy Name"
$isPolicyExist = Get-AdminDlpPolicy $newPolicyName
if ([bool]($isPolicyExist.PSobject.Properties.name -match "name"))
{
    Write-Host "DLP Policy with this name Already Exist" -ForegroundColor Red
    Return
}
$newdlpPolicy = New-DlpPolicy -DisplayName $newPolicyName -DefaultConnectorClassification Blocked -EnvironmentType OnlyEnvironments


foreach($connector in $dlpPolicy.BusinessDataGroup)
{
    if($connector.type -ne "Custom") #To Avoid moving any custom Connectors
    {
        $connName = $connector.id.Split("/")
        
        Write-Host $connName[$connName.Length-1]
        
        Add-ConnectorToBusinessDataGroup -PolicyName $newdlpPolicy.name -ConnectorName $connName[$connName.Length-1] -ErrorAction SilentlyContinue
    }
}


#Adding to Business Group First and removing it so it goes to the Non-Business Group as there is no method available for adding it to Non-Business Group

foreach($connector in $dlpPolicy.NonBusinessDataGroup)
{
    if($connector.type -ne "Custom") #To Avoid moving any custom Connectors
    {
        $connName = $connector.id.Split("/")

        Write-Host $connName[$connName.Length-1]

        Add-ConnectorToBusinessDataGroup -PolicyName $newdlpPolicy.name -ConnectorName $connName[$connName.Length-1] -ErrorAction SilentlyContinue
        Remove-ConnectorFromBusinessDataGroup -PolicyName $newdlpPolicy.name -ConnectorName $connName[$connName.Length-1] -ErrorAction SilentlyContinue
    }
}
