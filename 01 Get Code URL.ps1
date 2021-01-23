# A PowerShell script for getting an OAuth code URL from Google
# (This is Step 1 of a two-step process)
# written by Jeremy Peach (AnalyticJeremy)
# full documentation:  https://github.com/AnalyticJeremy/ADF_BigQuery


# Before running this script, you need to set these three values.  They can be
# obtained from the GCP console.
$clientId = "<your client Id>"
$clientSecret = "<your client secret>"
$redirectUrl = "<EXACT URL you entered when creating your OAuth credentials>"


# This is the access scope we will be requesting
$scope = "https://www.googleapis.com/auth/bigquery"


# Build the URL for Google's OAuth service
$authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
$authUrl += "?client_id=" + $clientId
$authUrl += "&redirect_uri=" + [uri]::EscapeDataString($redirectUrl)
$authUrl += "&scope=" + [uri]::EscapeDataString($scope)
$authUrl += "&access_type=offline&include_granted_scopes=true&response_type=code&prompt=consent"

Write-Host "`n`n$("*" * 80) `n"
Write-Host "Open the follwing URL in your web browser:`n"
Write-Host "`t$authUrl`n"
Write-Host "Log into Google and grant consent to the application.  After clicking allow, you will be redirected to a URL."
Write-Host "Copy the URL to which you are redirected and proceed to Step 2."
Write-Host "`n$("*" * 80) `n`n"