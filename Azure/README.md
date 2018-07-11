az provider operation show --namespace Microsoft.ContainerService

az provider operation show --namespace Microsoft.ContainerService -o json >> customcontainerservice.json

Removed 

```
{
      "displayName": "Managed Clusters",
      "name": "managedClusters/accessProfiles",
      "operations": [
        {
          "description": "Get a managed cluster access profile by role name",
          "displayName": "Get Managed Cluster AccessProfile",
          "isDataAction": false,
          "name": "Microsoft.ContainerService/managedClusters/accessProfiles/read",
          "origin": "user,system",
          "properties": null
        },
        {
          "description": "Get a managed cluster access profile by role name using list credential",
          "displayName": "Get Managed Cluster AccessProfile by List Crednetial",
          "isDataAction": false,
          "name": "Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action",
          "origin": "user,system",
          "properties": null
        }
      ]
    },
```

```
{
    "Name": "Custom Container Service",
    "Description": "Cannot read Container service credentials",
    "Actions": [
        "Microsoft.ContainerService/managedClusters/read",
        "Microsoft.ContainerService/managedClusters/accessProfiles/read"
    ],
    "DataActions": [
    ],
    "NotDataActions": [
    ],
    "AssignableScopes": [
        "/subscriptions/2ff1913a-8336-4476-8fe6-42c756b333c6resourcegroups/MC_devopsaksad_devopsaksad_eastus/providers/Microsoft.ContainerService/managedClusters/devopsaksad/accessProfiles/clusterUser/"
    ]
}
```

az role definition create --role-definition '{
    "Name": "Custom Container Service",
    "Description": "Cannot read Container service credentials",
    "Actions": [
        "Microsoft.ContainerService/managedClusters/read"
    ],
    "DataActions": [
    ],
    "NotDataActions": [
    ],
    "AssignableScopes": [
        "/subscriptions/2ff1913a-8336-4476-8fe6-42c756b333c6"
    ]
}'
