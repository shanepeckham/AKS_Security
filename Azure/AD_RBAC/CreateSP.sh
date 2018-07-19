#!/usr/bin/env bash


## Now we need to create an app, see here https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal

## To automate an app run bash script

# First run az login and the following for your subscription if you do not have a spn

#Enter SERVER_ID below

SERVER_APP_NAME='AKSShane1'
SERVER_SECRET='P@ssword12'

SERVER_ID=$(az ad app create --display-name $SERVER_APP_NAME --identifier-uris http://$SERVER_APP_NAME --homepage http://$SERVER_APP_NAME --reply-urls http://$SERVER_APP_NAME  --password $SERVER_SECRET --required-resource-accesses serviceManifest.json --query appId -o tsv --debug --verbose --native-app false)
az ad app update --id $SERVER_ID --set groupMembershipClaims="All"
SERVER_SPN_OBJECT_ID=$(az ad sp create --id $SERVER_ID --query objectId --output tsv)

echo "***Add these values in the ADk8.py file SERVER_ID is" $SERVER_ID" and SERVER_SPN_OBJECT_ID is" $SERVER_SPN_OBJECT_ID
