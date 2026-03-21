# All due credit to go to Christian Frohn - just put in this repo for my own use so I don't lose it.
# https://www.christianfrohn.dk/2024/04/10/getting-started-with-api-driven-inbound-user-provisioning-to-on-premises-ad/

# Get the infomation from the Azure AD app registration
$ClientID = ""
$ClientSecret = ""
$TenantID = ""

$InboundProvisioningAPIEndpoint = "https://graph.microsoft.com/v1.0/servicePrincipals/24fd9ee6-fcb3-4ee8-a9f4-7a33a5a4eee6/synchronization/jobs/API2AD.59ab8c8294d342f4b54788f69160d44e.334e4532-346d-407b-b2d7-c03c3bd883ca/bulkUpload"

$JsonContent = @"
{
    "schemas": ["urn:ietf:params:scim:api:messages:2.0:BulkRequest"],
    "Operations": [
        {
            "method": "POST",
            "bulkId": "897401c2-2de4-4b87-a97f-c02de3bcfc61",
            "path": "/Users",
            "data": {
                "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User",
                "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"],
                "externalId": "",
                "userName": "",
                "name": {
                    "formatted": "",
                    "familyName": "",
                    "givenName": "",
                    "middleName": ""
                },
                "displayName": "",
                "nickName": "",
                "emails": [
                    {
                        "value": "",
                        "type": "work",
                        "primary": true
                    }
                ],
                "userType": "",
                "title": "",
                "preferredLanguage": "en-GB",
                "locale": "en-GB",
                "timezone": "Europe/Amsterdam",
                "active":true,
                "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
                    "employeeNumber": "",
                    "costCenter": "",
                    "organization": "",
                    "division": "",
                    "department": ""
                }
            }
        },
        {
            "method": "POST",
            "bulkId": "897401c2-2de4-4b87-a97f-c02de3bcfc62",
            "path": "/Users",
            "data": {
                "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User",
                "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"],
                "externalId": "12346",
                "userName": "",
                "name": {
                    "formatted": "",
                    "familyName": "",
                    "givenName": "",
                    "middleName": ""
                },
                "displayName": "",
                "nickName": "",
                "emails": [
                    {
                        "value": "",
                        "type": "work",
                        "primary": true
                    }
                ],
                "userType": "",
                "title": "",
                "preferredLanguage": "en-GB",
                "locale": "en-GB",
                "timezone": "Europe/Amsterdam",
                "active":true,
                "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
                    "employeeNumber": "12346",
                    "costCenter": "999",
                    "organization": "",
                    "division": "",
                    "department": ""
                }
            }
        }

        
    ],
    "failOnErrors": false
}
"@
 
$JsonPayload = $JsonContent | ConvertTo-Json
 
# Code execution starts here
 
# Define the parameters for getting the access token
$tokenParams = @{
    Uri         = "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token"
    Method      = 'POST'
    Body        = @{
        client_id     = $ClientID
        scope         = 'https://graph.microsoft.com/.default'
        client_secret = $ClientSecret
        grant_type    = 'client_credentials'
    }
    ContentType = 'application/x-www-form-urlencoded'
}
 
# Get the access token
$accessTokenResponse = Invoke-RestMethod @tokenParams
 
# Parameters for JSON upload to API-driven provisioning endpoint
$bulkUploadParams = @{
    Uri         = $InboundProvisioningAPIEndpoint
    Method      = 'POST'
    Headers     = @{
        'Authorization' = "Bearer " +  $accessTokenResponse.access_token
        'Content-Type'  = 'application/scim+json'
    }
    Body        = ([System.Text.Encoding]::UTF8.GetBytes($JsonPayload))
    Verbose     = $true
}
 
# Send the JSON payload to the API-driven provisioning endpoint
$response = Invoke-RestMethod @bulkUploadParams
$response


