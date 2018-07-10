# RBAC, Kubernetes and Azure Active Directory

This document will provide some guidance on how to implement RBAC with Kubernetes with Azure Active Directory (AAD) in a secure fashion and adhering to a few security First Principles, namely:

* Apply least privileged access
* Segregation of responsibility
* Minimise attack surface
* Apply security in a layered approac

[Azure Active Directory](https://azure.microsoft.com/en-us/services/active-directory/)(AAD) helps you manage user identities and create intelligence-driven access policies to secure your resources. By managing Kubernetes users in AAD, maintenance is simplified as all users are managed centrally, and users have a single identity with which to access all services, not just Kubernetes. 

**RBAC in Kubernetes may be thought of as the following:**

![RBAC](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180709_3.png)

For example, can user devops view pods in namespace devops?

## To manage RBAC in Kubernetes, apart from resources and operations, we need the following elements:

From [Bitnami](https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/)

* Roles and ClusterRoles: Both consist of rules. The difference between a Role and a ClusterRole is the scope: in a Role, the rules are applicable to a single namespace, whereas a ClusterRole is cluster-wide, so the rules are applicable to more than one namespace. ClusterRoles can define rules for cluster-scoped resources (such as nodes) as well. Both Roles and ClusterRoles are mapped as API Resources inside our cluster.

* **Subjects**: These correspond to the entity that attempts an operation in the cluster. There are three types of subjects:
* **User Accounts**: These are global, and meant for humans or processes living outside the cluster. There is no associated resource API Object in the Kubernetes cluster.
* **Service Accounts**: This kind of account is namespaced and meant for intra-cluster processes running inside pods, which want to authenticate against the API.
* **RoleBindings and ClusterRoleBindings**: Just as the names imply, these bind subjects to roles (i.e. the operations a given user can perform). As for Roles and ClusterRoles, the difference lies in the scope: a RoleBinding will make the rules effective inside a namespace, whereas a ClusterRoleBinding will make the rules effective in all namespaces.
You can find examples of each API element in the Kubernetes official documentation.

## Users in Kubernetes from [Kubernetes docs](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens)

* All Kubernetes clusters have two categories of users: service accounts managed by Kubernetes, and normal users.

* Normal users are assumed to be managed by an outside, independent service, in this case AAD. Kubernetes does not have objects which represent normal user accounts. Regular users cannot be added to a cluster through an API call.

* In contrast, service accounts are users managed by the Kubernetes API. They are bound to specific namespaces, and created automatically by the API server or manually through API calls. Service accounts are tied to a set of credentials stored as Secrets, which are mounted into pods allowing in-cluster processes to talk to the Kubernetes API.


## AAD Groups

* AAD Groups are containers that contain user and computer objects within them as members. We can use these groups to bind to Role and Cluster Role Bindings and then simply add users as members to Groups. 

**The following diagram illustrates conceptually how AAD groups fit into RBAC with Kubernetes:**

![Flow](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180709_4.png)

We map 1:M Roles to RoleBindings (or Cluster Roles and Cluster Role Bindings for cluster wide scope), we bind 1:M RoleBindings to an AAD Group, and we associate 1:M Users with an AAD Group. In the case of ServiceAccounts which are managed exclusively within Kubernetes, we can associate these 1:1 with an AAD  Group, but we will cover this later.

### Apply Least Priviliged Access

We should always start from a position of applying the least permissions or priviliges to an account, thus in the context of Kubernetes for example, the minimum permissions would be the ability to view an object, such as Pods, for a single Namespace. This does not include watching or spooling logs, merely being able to list Pods and see their status. 

We would then create an AAD Group that represents this minimum privilege and appply a RoleBinding to this AAD Group. We then simply need to add all new users to this ADD Group until they need more privileges.

Determining which Roles are required for operations within Kubernetes resources can be quite a time consuming task, and a typical approach to trace missing permissions is to enable the [Audit Policy](https://kubernetes.io/docs/tasks/debug-application-cluster/audit/) via an Admission Controller and then user Jordan Ligget's tool [audit2RBAC](https://kubernetes.io/docs/tasks/debug-application-cluster/audit/) to help quickly identify missing permissions. This is unfortunately not possible in AKS at the moment but can be used within [ACS-Engine](https://github.com/Azure/acs-engine).

### Implementing Least Priviliged Access

**The diagram below illustrates how we could map AAD Groups to a layered RBAC permissions approach**:

![Layered](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180710_7.png)

This is however a simplified approach as it does not implement restrictions on resources that may be accessed. In reality a user's access is defined by three components, that of Scope e.g. Cluster or Namespace, Resources e.g. Pods, Services and Verbs, e.g. Create, Exec, List, see below:

![Access](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180710_8.png?v=4&s=200)

Thus a more secure approach would be to introduce layers of resource restrictions on this model. Clearly a balance needs to be found between maintenance and control, thus it may make sense to aggregate typical resources that are required to deploy solutions on Kubernetes. We do not want to create too many AAD Groups, or rather we do not want users to be members of too many AAD Groups as these are reflected in the token and can increase login times.

Thus it is viable to create many AAD Groups representing Resource, Scope and Verb permissions, but care should then be taken to ensure that the user is added to the least amount of AAD Groups to enable those permissions.

## Enable RBAC on cluster with AD integration

Follow initial setup as documented [here](https://docs.microsoft.com/en-us/azure/aks/aad-integration)

## Apply RBAC to Azure AD users and groups

### Log on to Kubernetes as the AAD admin

Run 
```
az aks get-credentials --name [clustername] --resource-group [resourcegroup] --admin
```
7. You can issue the command 
```az aks get-credentials --name devopsaksad --resource-group devopsakdsad ```
8. When you try to run a kubectl command you will be presented with the following:

```To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code [code] to authenticate```

You will then be directed to an OAUTH permission request, see below:

![Permissions](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180627_2.png)

![Grant client AD application access](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180627_3.png)

If you try to run ```kubectl get nodes ``` you will receive the following message:

```
You must be logged in to the server (Unauthorized)
```

We can now grant the group to which the user belongs, namely DevOpsGroup, the permissions to read pods.


Create the 

Todo
Create namespace read devopsbot2
Create devopsbot + 2 with namespace create and cluster scope read for multiple
Create service account with ad settings password longer change maybe with cluster wide read, namespace create/???
All automated via az clie


Create the cluster role for the to allow the granting of roles at the cluster level. Anyone added to this group will be allowed to grant roles at the same scope to others


### Create a new user DevopsBot

As the admin of the AD Directory create a new user:

```
az ad user create --display-name devopsbot --password OpsBotDev --user-principal-name devopsbot@[yourdomain].onmicrosoft.com --force-change-password-next-login true --immutable-id devopsbot

```

### Create the AD Group for cluster scoped list permissions

```
az ad group create --display-name K8Cluster-View --mail-nickname K8Cluster-View

```
### Get the users object id

``` 
az ad user show --upn-or-object-id devopsbot@[yourdomain].onmicrosoft.com --query objectId
```                   

### Add ClusterRoles and ClusterRoleBindings to view pods and podlogs and assign to group K8Cluster-View

```
kubectl create -f https://raw.githubusercontent.com/shanepeckham/AKS_Security/master/Sample%20Implementation/Roles%20and%20RoleBindings/New/K8ClusterView.yaml
```

### Grant DevOpsBot cluster scoped list permissions by binding roles to the group
```
az ad group member add --group K8Cluster-View --member-id [objectId]                  
```   

Now if user devopsbot issues the following command, it should be successful:

```
kubectl get pods -n devops
```
```
kubectl get pods --all-namespaces
```
```
kubectl auth can-i get pods
```

The last command should return 'yes'

![yes](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180628_4.png)


### Grant DevOpsBot namespace scoped list permissions by binding roles to the group (for create, update, watch pods)

```
az ad group member add --group K8DevOpsEdit --member-id [objectId]                  
```   

### Add ClusterRoles and ClusterRoleBindings to view pods and podlogs and assign to group K8Cluster-View

```
kubectl create -f https://raw.githubusercontent.com/shanepeckham/AKS_Security/master/Sample%20Implementation/Roles%20and%20RoleBindings/New/K8ClusterView.yaml
```

### Create a new user DevopsBot2

As the admin of the AD Directory create a new user:

```
az ad user create --display-name devopsbot2 --password OpsBotDev2 --user-principal-name devopsbot2@[yourdomain].onmicrosoft.com --force-change-password-next-login true --immutable-id devopsbot2
```

### Add the 

### Grant DevOpsBot2 namespace scoped list permissions




### Service Accounts




### Aggregated Roles


