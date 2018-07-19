#!/usr/bin/env bash
## Now we need to create an app with SP, see here https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal

# First run az login and the following for your subscription if you do not have a spn

SUBSCRIPTION_ID=''  # Must be populated manually
PASSWORD='P@ssWord12' # Must be populated manually

SCOPE=/subscriptions/$SUBSCRIPTION_ID

SERVER_APP_ID=$(az ad sp create-for-rbac --role="Contributor" --scopes=$SCOPE --password $PASSWORD --query appId --output tsv)
az ad app update --id $SERVER_APP_ID --set groupMembershipClaims="All" --required-resource-accesses serviceManifest.json

echo "***Add these values in the ADk8.py file SERVER_APP_ID is" $SERVER_APP_ID "and SERVER_SECRET is" $PASSWORD ". You must manually
press Grant Permissions in the portal for the SP created"
