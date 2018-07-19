#!/bin/bash
function getJsonVal () { 
    python -c "import json,sys;sys.stdout.write(json.dumps(json.load(sys.stdin)$1))"; 
}
# Configurables
RESOURCE_GROUP=AKSADCluster101
CLUSTER_NAME=AKSADCluster101
SERVER_APP=AKSADCluster101Server
CLIENT_APP=AKSADCluster101Client
SERVER_SECRET=P@ssword12
SUBSCRIPTION_ID=02471285-a96a-4392-9c19-0176df619018

# Create AKS AAD sever app
SERVER_ID=$(az ad app create --display-name $SERVER_APP --identifier-uris http://$SERVER_APP --homepage http://$SERVER_APP --reply-urls http://$SERVER_APP  --password $SERVER_SECRET --required-resource-accesses serviceManifest.json --query appId -o tsv --debug --verbose --native-app false)
az ad app update --id $SERVER_ID --set groupMembershipClaims="All"
az ad sp create --id $SERVER_ID

# Create AKS AAD client app
CLIENT_PERMS=$(cat <<EOF
[{"resourceAccess": [{"id": "318f4279-a6d6-497a-8c69-a793bda0d54f","type": "Scope"}],"resourceAppId": "$SERVER_ID"}]
EOF
)
CLIENT_ID=$(az ad app create --display-name $CLIENT_APP --native-app --reply-urls http://$CLIENT_APP --required-resource-accesses "$CLIENT_PERMS" --query appId -o tsv)
az ad sp create --id $CLIENT_ID

# Get tenant ID
#TENANT_ID=$(az account list --query [0].[tenantId] -o tsv)
TENANT_ID=$(az account show --subscription $SUBSCRIPTION_ID --query tenantId -o tsv)
# Create resource group
az group create --name $RESOURCE_GROUP --location eastus

# Create AKS cluster
az aks create --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --enable-rbac --aad-server-app-id $SERVER_ID --aad-server-app-secret $SERVER_SECRET --aad-client-app-id $CLIENT_ID --aad-tenant-id $TENANT_ID


#Is this is part 2?

# Create app with client secret
SERVER_ID=$(az ad app create --display-name $SERVER_APP --identifier-uris http://$SERVER_APP --homepage http://$SERVER_APP --reply-urls http://$SERVER_APP  --password $SERVER_SECRET --required-resource-accesses serviceManifest.json --query appId -o tsv --debug --verbose --native-app false --oauth2-allow-implicit-flow true)
az ad app update --id $SERVER_ID --set groupMembershipClaims="All"
az ad sp create --id $SERVER_ID

TOKENBODY='&grant_type=client_credentials&client_id='$SERVER_ID'&resource=https%3A%2F%2Fgraph.windows.net&client_secret='$SERVER_SECRET
TOKEN_URL='https://login.microsoftonline.com/'$TENANT_ID'/oauth2/token'
# Get a bearer token for server app
TOKEN=$(curl -X POST $TOKEN_URL -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/json" -d $TOKENBODY)

# Get the spn object id via the REST call for the server app just created store in $SERVER_APP_SPN
# Call Token Client Credentials as the app just created
# Create Native App
# Create SP for native App
# Get Service Principal for native app permissions including SERVER_APP
# Create OAuth2 Permissions for both? permissions





curl https://login.microsoftonline.com/TENANT_ID/adminconsent?
client_id=CLIENT_ID
&state=12345
&redirect_uri=http://AKSADCluster101Client



# Is this it?
curl -X GET \
  'https://graph.windows.net/devops10000001@outlook.com.onmicrosoft.com/servicePrincipals?api-version=1.6&%24filter=appId%20eq%20'\''00000002-0000-0000-c000-000000000000'\''' \
  -H 'authorization: Bearer undefined' \
  -H 'cache-control: no-cache'
  -d '&grant_type=client_credentials&client_id=f3125fc0-3aa0-44bf-b3b5-2128d2fb84af&resource=https%3A%2F%2Fgraph.windows.net&client_secret=P@ssword12'


BEARER='Authorization: Bearer '
HEADERTOKEN=$BEARER$(az account get-access-token --subscription $SUBSCRIPTION_ID --query AccessToken -o tsv)
HEADERTOKEN=$BEARER$(az account get-access-token --subscription $SUBSCRIPTION_ID -o tsv)
CLIENTREQUESTID='x-ms-client-request-id:'$CLIENT_ID
CORRELATIONID='x-ms-correlation-id:'$CLIENTID


curl -i -X POST-H $HEADERTOKEN -H 'X-Requested-With: XMLHttpRequest' -H $CLIENTREQUESTID -H $CORRELATIONID  https://main.iam.ad.ext.azure.com/api/RegisteredApplications/$CLIENT_ID/Consent?onBehalfOfAll=true

curl https://main.iam.ad.ext.azure.com/api/RegisteredApplications/$azureAppId/Consent?onBehalfOfAll=true

$secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($Username, $secpasswd)
$res = login-azurermaccount -Credential $mycreds
$context = Get-AzureRmContext
$tenantId = $context.Tenant.Id
$refreshToken = $context.TokenCache.ReadItems().RefreshToken
$body = "grant_type=refresh_token&refresh_token=$($refreshToken)&resource=74658136-14ec-4630-ad9b-26e160ff0fc6"
$apiToken = Invoke-RestMethod "https://login.windows.net/$tenantId/oauth2/token" -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'
$header = @{
'Authorization' = 'Bearer ' + $apiToken.access_token
'X-Requested-With'= 'XMLHttpRequest'
'x-ms-client-request-id'= [guid]::NewGuid()
'x-ms-correlation-id' = [guid]::NewGuid()}
$url = "https://main.iam.ad.ext.azure.com/api/RegisteredApplications/$SERVER_ID/Consent?onBehalfOfAll=true"
Invoke-RestMethod –Uri $url –Headers $header –Method POST -ErrorAction Stop
}

curl -i -X POST-H 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlRpb0d5d3dsaHZkRmJYWjgxM1dwUGF5OUFsVSIsImtpZCI6IlRpb0d5d3dsaHZkRmJYWjgxM1dwUGF5OUFsVSJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuY29yZS53aW5kb3dzLm5ldC8iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC8wMjQ3MTI4NS1hOTZhLTQzOTItOWMxOS0wMTc2ZGY2MTkwMTgvIiwiaWF0IjoxNTMxNzQxNzM5LCJuYmYiOjE1MzE3NDE3MzksImV4cCI6MTUzMTc0NTYzOSwiYWNyIjoiMSIsImFpbyI6IjQyQmdZRGlYY2ppd2VlcFQ1UmkzbWxBRGc1bEtuOU5xMjkvTTJWcC9yaU5Xd3kwL1RBb0EiLCJhbHRzZWNpZCI6IjE6bGl2ZS5jb206MDAwMzQwMDEwRjIyMDI4OCIsImFtciI6WyJwd2QiXSwiYXBwaWQiOiIwNGIwNzc5NS04ZGRiLTQ2MWEtYmJlZS0wMmY5ZTFiZjdiNDYiLCJhcHBpZGFjciI6IjAiLCJlX2V4cCI6MjYyODAwLCJlbWFpbCI6ImRldm9wczEwMDAwMDAxQG91dGxvb2suY29tIiwiZmFtaWx5X25hbWUiOiJBZG1pbiIsImdpdmVuX25hbWUiOiJEZXZPcHMiLCJncm91cHMiOlsiMjQyZmE5ZTMtODA3Zi00ZmYzLThjN2UtMWM2OWQyNDM3ODI4IiwiZGIxMTEzODAtNzlhMi00ZWZkLWFjNjEtOTNlNWVmYzg4MGViIiwiYTIxYmNjZTMtNzQ1Ni00OGYwLThmZTUtMWVhZDRiZmM5NmM5IiwiODJkOTY4ZWYtNWFlNC00ZWY3LWI1NzgtY2ExMjQ4ZWYyM2NkIl0sImlkcCI6ImxpdmUuY29tIiwiaXBhZGRyIjoiODEuMTMyLjEwNC4xMTciLCJuYW1lIjoiRGV2T3BzMTAwMDAwMDAxIiwib2lkIjoiMGRkZmIzYzMtZTUxNS00MDY1LThhNTktYjVmZWQ2NGQ5ZDUwIiwicHVpZCI6IjEwMDNCRkZEQUJFRTNGOUEiLCJzY3AiOiJ1c2VyX2ltcGVyc29uYXRpb24iLCJzdWIiOiI1UXBZd2hwRXBJSThLaDRmU3VRaFRwaFFReldjdnJGRVozWUdQa3kyaVBvIiwidGlkIjoiMDI0NzEyODUtYTk2YS00MzkyLTljMTktMDE3NmRmNjE5MDE4IiwidW5pcXVlX25hbWUiOiJsaXZlLmNvbSNkZXZvcHMxMDAwMDAwMUBvdXRsb29rLmNvbSIsInV0aSI6IjJhYlNad25BYTBXcEVLbzVVLUlpQUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbIjYyZTkwMzk0LTY5ZjUtNDIzNy05MTkwLTAxMjE3NzE0NWUxMCIsImU4NjExYWI4LWMxODktNDZlOC05NGUxLTYwMjEzYWIxZjgxNCIsIjE5NGFlNGNiLWIxMjYtNDBiMi1iZDViLTYwOTFiMzgwOTc3ZCJdfQ.DUzXQgNz7jxJ7XXqhwKAbQsg00VwtKpVHGEXVbb1RVf0P5x-KOwc4dbl8gMjQEnTqzeTXubSddp1mR6MTzok4egdVjkW4o09JNqhuiAjEtJrX4MY8SmYd51b4HkbE6Yup1lvua3w_mWf5oXL8vmVXiBx6tdDKi6MhC8YyZAMa2rLv1JpnC4hJ57f5CvpxodkxcPKwgogZVM9S4AQFGdERmXiHs6tuXSfKm2mFAn45-filChzHpffRuFNouOJtbVm_l3zwJrPJMnY4dFrWP_0tYBeqq6IKoPusJfbMLuKXJq2Ew07pwZkZu8wA4CE7qjvuC9HMSEW5gQsI6pAmCjc3Q' -H 'X-Requested-With: XMLHttpRequest' -H $CLIENTREQUESTID -H $CORRELATIONID  https://main.iam.ad.ext.azure.com/api/RegisteredApplications/$CLIENT_ID/Consent?onBehalfOfAll=true

https://graph.windows.net/devops10000001@outlook.com.onmicrosoft.com/servicePrincipals?$filter=appId eq 72ea1b06-b33a-4a62-9e5f-1bbc5d7a1c16


'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlRpb0d5d3dsaHZkRmJYWjgxM1dwUGF5OUFsVSIsImtpZCI6IlRpb0d5d3dsaHZkRmJYWjgxM1dwUGF5OUFsVSJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuY29yZS53aW5kb3dzLm5ldC8iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC8wMjQ3MTI4NS1hOTZhLTQzOTItOWMxOS0wMTc2ZGY2MTkwMTgvIiwiaWF0IjoxNTMxNzQxNzM5LCJuYmYiOjE1MzE3NDE3MzksImV4cCI6MTUzMTc0NTYzOSwiYWNyIjoiMSIsImFpbyI6IjQyQmdZRGlYY2ppd2VlcFQ1UmkzbWxBRGc1bEtuOU5xMjkvTTJWcC9yaU5Xd3kwL1RBb0EiLCJhbHRzZWNpZCI6IjE6bGl2ZS5jb206MDAwMzQwMDEwRjIyMDI4OCIsImFtciI6WyJwd2QiXSwiYXBwaWQiOiIwNGIwNzc5NS04ZGRiLTQ2MWEtYmJlZS0wMmY5ZTFiZjdiNDYiLCJhcHBpZGFjciI6IjAiLCJlX2V4cCI6MjYyODAwLCJlbWFpbCI6ImRldm9wczEwMDAwMDAxQG91dGxvb2suY29tIiwiZmFtaWx5X25hbWUiOiJBZG1pbiIsImdpdmVuX25hbWUiOiJEZXZPcHMiLCJncm91cHMiOlsiMjQyZmE5ZTMtODA3Zi00ZmYzLThjN2UtMWM2OWQyNDM3ODI4IiwiZGIxMTEzODAtNzlhMi00ZWZkLWFjNjEtOTNlNWVmYzg4MGViIiwiYTIxYmNjZTMtNzQ1Ni00OGYwLThmZTUtMWVhZDRiZmM5NmM5IiwiODJkOTY4ZWYtNWFlNC00ZWY3LWI1NzgtY2ExMjQ4ZWYyM2NkIl0sImlkcCI6ImxpdmUuY29tIiwiaXBhZGRyIjoiODEuMTMyLjEwNC4xMTciLCJuYW1lIjoiRGV2T3BzMTAwMDAwMDAxIiwib2lkIjoiMGRkZmIzYzMtZTUxNS00MDY1LThhNTktYjVmZWQ2NGQ5ZDUwIiwicHVpZCI6IjEwMDNCRkZEQUJFRTNGOUEiLCJzY3AiOiJ1c2VyX2ltcGVyc29uYXRpb24iLCJzdWIiOiI1UXBZd2hwRXBJSThLaDRmU3VRaFRwaFFReldjdnJGRVozWUdQa3kyaVBvIiwidGlkIjoiMDI0NzEyODUtYTk2YS00MzkyLTljMTktMDE3NmRmNjE5MDE4IiwidW5pcXVlX25hbWUiOiJsaXZlLmNvbSNkZXZvcHMxMDAwMDAwMUBvdXRsb29rLmNvbSIsInV0aSI6IjJhYlNad25BYTBXcEVLbzVVLUlpQUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbIjYyZTkwMzk0LTY5ZjUtNDIzNy05MTkwLTAxMjE3NzE0NWUxMCIsImU4NjExYWI4LWMxODktNDZlOC05NGUxLTYwMjEzYWIxZjgxNCIsIjE5NGFlNGNiLWIxMjYtNDBiMi1iZDViLTYwOTFiMzgwOTc3ZCJdfQ.DUzXQgNz7jxJ7XXqhwKAbQsg00VwtKpVHGEXVbb1RVf0P5x-KOwc4dbl8gMjQEnTqzeTXubSddp1mR6MTzok4egdVjkW4o09JNqhuiAjEtJrX4MY8SmYd51b4HkbE6Yup1lvua3w_mWf5oXL8vmVXiBx6tdDKi6MhC8YyZAMa2rLv1JpnC4hJ57f5CvpxodkxcPKwgogZVM9S4AQFGdERmXiHs6tuXSfKm2mFAn45-filChzHpffRuFNouOJtbVm_l3zwJrPJMnY4dFrWP_0tYBeqq6IKoPusJfbMLuKXJq2Ew07pwZkZu8wA4CE7qjvuC9HMSEW5gQsI6pAmCjc3Q


curl -X POST \
  'https://graph.windows.net/myorganization/oauth2PermissionGrants?api-version=1.6' \
  -H 'authorization: Bearer undefined' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "odata.type": "Microsoft.DirectoryServices.OAuth2PermissionGrant",
    "clientId": "3c1b3a48-9997-4a51-b677-d900ca890574",
    "consentType": "AllPrincipals",
    "principalId": null,
    "resourceId": "370582c4-911d-454c-9b55-b53599919e38",
    "scope": "user_impersonation",
    "startTime": "0001-01-01T00:00:00",
    "expiryTime": "9000-01-01T00:00:00"
}'