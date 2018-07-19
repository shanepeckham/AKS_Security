#!/usr/bin/env bash
## Now we need to create an app, see here https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal

## To automate an app run bash script

# First run az login and the following for your subscription if you do not have a spn

#Enter SERVER_ID below
SUBSCRIPTION_ID='2ff1913a-8336-4476-8fe6-42c756b333c6'  # Must be populated manually
QUOTE='"'
SCOPE=/subscriptions/$SUBSCRIPTION_ID

SERVER_APP_ID=$(az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/"$SUBSCRIPTION_ID --query appId --output tsv)
az ad app update --id $SERVER_APP_ID --set groupMembershipClaims="All" --required-resource-accesses serviceManifest.json
SERVER_SPN_OBJECT_ID=$(az ad sp create --id $SERVER_APP_ID --query objectId --output tsv)

echo "***Add these values in the ADk8.py file SERVER_APP_ID is" $SERVER_APP_ID" and SERVER_SPN_OBJECT_ID is" $SERVER_SPN_OBJECT_ID

