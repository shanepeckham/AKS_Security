# Let's delete the AD Groups - cluster scope
az ad group delete --group ClusterViewAdmin 
az ad group delete --group ClusterViewDev
az ad group delete --group ClusterViewOps
az ad group delete --group ClusterCreateAdmin
az ad group delete --group ClusterCreateDev
az ad group delete --group ClusterCreateOps
# Let's delete the AD Groups - namespace NS1 scope
az ad group delete --group NS1ViewAdmin
az ad group delete --group NS1ViewDev
az ad group delete --group NS1ViewOps
az ad group delete --group NS1CreateAdmin
az ad group delete --group NS1CreateDev
az ad group delete --group NS1CreateOps
# Let's delete the users - needs to be amended with your domain
OBJECTID=$(az ad user show --upn-or-object-id devopsbot@devops10000001outlook.onmicrosoft.com --query objectId --output tsv)
az ad user delete  --upn-or-object-id $OBJECTID
OBJECTID=$(az ad user show --upn-or-object-id devopsbot2@devops10000001outlook.onmicrosoft.com --query objectId --output tsv)
az ad user delete  --upn-or-object-id $OBJECTID
