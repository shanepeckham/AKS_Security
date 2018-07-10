# Let's get the Object id and add the users to the respective groups
OBJECTID=$(az ad user show --upn-or-object-id devopsbot@devops10000001outlook.onmicrosoft.com --query objectId --output tsv)
az ad group member add --group NS1ViewOps --member-id $OBJECTID
OBJECTID=$(az ad user show --upn-or-object-id devopsbot2@devops10000001outlook.onmicrosoft.com --query objectId --output tsv)
az ad group member add --group NS1ViewOps --member-id $OBJECTID