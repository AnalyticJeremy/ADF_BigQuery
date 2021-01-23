# A PowerShell script for retrieving a refresh token from Google
# (This is Step 2 of a two-step process)
# written by Jeremy Peach (AnalyticJeremy)
# full documentation:  https://github.com/AnalyticJeremy/ADF_BigQuery


# Before running this script, you need to set these four values.  The first three
# can be obtained from the GCP console.  The "codeUrl" was obtained in Step 1.
$clientId = "<your client Id>"
$clientSecret = "<your client secret>"
$redirectUrl = "<EXACT URL you entered when creating your OAuth credentials>"
$codeUrl = "<auth code URL to which you were redirected in step 1>"


# Extract access code frome the URL
$codeUrl = [uri]$codeUrl
Add-Type -AssemblyName System.Web
$queryString = [System.Web.HttpUtility]::ParseQueryString($codeUrl.Query)
$accessCode = $queryString["code"]


# Construct URL and parameters for HTTP POST that will be used to exchange the
# access code for an access token and a refresh token
$authUrl = "https://www.googleapis.com/oauth2/v4/token"
$postParams = @{code=$accessCode;
                client_id=$clientId;
                client_secret=$clientSecret;
                redirect_uri=$redirectUrl;
                grant_type="authorization_code"}


# make the HTTP request
try {
   $refreshOutput = Invoke-WebRequest -Uri $authUrl -Method POST -Body $postParams
}
catch {
   Write-Host "### ERROR TRYING TO REDEEM ACCESS CODE ###"
   $ErrorMessage = $_.Exception.Message
   $FailedItem = $_.Exception.ItemName
   $result = $_.Exception.Response.GetResponseStream()
   $reader = New-Object System.IO.StreamReader($result)
   $responseBody = $reader.ReadToEnd();
   Write-Host "## responseBody ##`n$responseBody`n##################`n"
   throw
}


# If we were successful, extract the refresh token from the HTTP response
$refreshOutputContent = ConvertFrom-Json $refreshOutput.Content
$refreshToken = $refreshOutputContent.refresh_token


# Display our findings!
$output = @{"Client Id" = $clientId;
            "Client Secret" = $clientSecret;
            "Refresh Token" = $refreshToken}
Write-Host "`n`n$("-"*80)`n"
Write-Host "In Azure Data Factory, create a linked service to Google BigQuery."
Write-Host "Set the `"Authentication type`" to `"User Authentication`"."
Write-Host "Use the following values for the remaining fields:"
$output
