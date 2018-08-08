#Global settings
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

#Get variable values
$WorkspaceID = Get-AutomationVariable -Name 'Supercharger-LogAnalyticsWorkspaceID'
$WorkspaceKey = Get-AutomationVariable -Name 'Supercharger-LogAnalyticsWorkspaceKey'
$DataSourceURI = Get-AutomationVariable -Name 'Supercharger-DataSourceURI'
$LogType = Get-AutomationVariable -Name 'Supercharger-LogAnalyticsLogType'

#Other values
$ScriptRuntime = [System.DateTime]::UtcNow
$TimestampField = ""

#Get and prepare Supercharger data
#Get and prepare Supercharger data
$SecurityProtocolTypes = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $SecurityProtocolTypes
$Results = Invoke-WebRequest -Uri $DataSourceURI -Method Get -UseBasicParsing
$Results = $Results | ConvertFrom-Json

$Objects = @()
foreach($Result in $Results)
    {
    #Cerate custom PowerShell object
    $Object = New-Object –TypeName PSObject
    $Object | Add-Member –MemberType NoteProperty –Name "Name" –Value $Result.name
    $Object | Add-Member –MemberType NoteProperty –Name "Status" –Value $Result.status
    $Object | Add-Member –MemberType NoteProperty –Name "DateOpened" –Value $Result.dateOpened
    $Object | Add-Member –MemberType NoteProperty –Name "StallCount" –Value $Result.stallCount
    $Object | Add-Member –MemberType NoteProperty –Name "Street" –Value $Result.address.street
    $Object | Add-Member –MemberType NoteProperty –Name "ZIP" –Value $Result.address.zip
    $Object | Add-Member –MemberType NoteProperty –Name "City" –Value $Result.address.city
    $Object | Add-Member –MemberType NoteProperty –Name "Country" –Value $Result.address.country
    $Object | Add-Member –MemberType NoteProperty –Name "Lon" –Value ($Result | select -expand gps).longitude
    $Object | Add-Member –MemberType NoteProperty –Name "Lat" –Value ($Result | select -expand gps).latitude
    $Objects += $Object
    Write-Output $Object
    }

$Body = $Objects | ConvertTo-Json

#Prepare ingestion
$Method = "POST"
$ContentType = "application/json"
$Resource = "/api/logs"
$RFC1123Date = [DateTime]::UtcNow.ToString("r")
$ContentLength = $body.Length  
$XHeaders = "x-ms-date:" + $RFC1123Date
$StringToHash = $Method + "`n" + $ContentLength + "`n" + $ContentType + "`n" + $XHeaders + "`n" + $Resource
$BytesToHash = [Text.Encoding]::UTF8.GetBytes($StringToHash)
$KeyBytes = [Convert]::FromBase64String($WorkspaceKey)
$SHA256 = New-Object System.Security.Cryptography.HMACSHA256
$SHA256.Key = $KeyBytes
$CalculatedHash = $SHA256.ComputeHash($BytesToHash)
$EncodedHash = [Convert]::ToBase64String($CalculatedHash)
$Authorization = 'SharedKey {0}:{1}' -f $WorkspaceId,$EncodedHash
$URI = "https://" + $WorkspaceId + ".ods.opinsights.azure.com" + $Resource + "?api-version=2016-04-01"
$headers = @{
        "Authorization" = $Authorization;
        "Log-Type" = $LogType;
        "x-ms-date" = $RFC1123Date;
        "time-generated-field" = $TimeStampField;
}

#Ingest data
$Response = Invoke-WebRequest -Uri $URI -Method $Method -ContentType $ContentType -Headers $Headers -Body $Body -UseBasicParsing
if($Response.StatusCode -eq 200){return 'Status Code ' +$response.StatusCode +', data ingestion successful!'}
else{return 'Status Code ' +$response.StatusCode +', please investigate!'}