# RBAC

Todo
Create namespace read devopsbot2
Create devopsbot + 2 with namespace create and cluster scope read for multiple
Create service account with ad settings password longer change maybe with cluster wide read, namespace create/???
All automated via az clie


Create the cluster role for the to allow the granting of roles at the cluster level. Anyone added to this group will be allowed to grant roles at the same scope to others


### Create a new user DevopsBot

As the admin of the AD Directory create a new user:

```az ad user create --display-name devopsbot --password OpsBotDev --user-principal-name devopsbot@[yourdomain].onmicrosoft.com --force-change-password-next-login true --immutable-id devopsbot
```

### Create the AD Group for cluster scoped list permissions

```az ad group create --display-name K8Cluster-View --mail-nickname K8Cluster-View

```
### Get the users object id

```az ad user show --upn-or-object-id devopsbot@[yourdomain].onmicrosoft.com --query objectId
```

### Grant DevOpsBot cluster scoped list permissions by binding roles to the group
```az ad group member add --group K8Cluster-View
                       --member-id [objectId]                  
```                       

### Add ClusterRoles and ClusterRoleBindings to view pods and podlogs and assign to group K8Cluster-View

```kubectl

### Create a new user DevopsBot2

As the admin of the AD Directory create a new user:

```az ad user create --display-name devopsbot2 --password OpsBotDev2 --user-principal-name devopsbot2@[yourdomain].onmicrosoft.com --force-change-password-next-login true --immutable-id devopsbot2
```

### Add the 

### Grant DevOpsBot2 namespace scoped list permissions
