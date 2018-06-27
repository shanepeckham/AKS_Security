# Enable RBAC on cluster with AD integration

Follow initial setup as documented [here](https://docs.microsoft.com/en-us/azure/aks/aad-integration)

## To manage RBAC in Kubernetes, apart from resources and operations, we need the following elements:

From [Bitnami](https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/)

* Roles and ClusterRoles: Both consist of rules. The difference between a Role and a ClusterRole is the scope: in a Role, the rules are applicable to a single namespace, whereas a ClusterRole is cluster-wide, so the rules are applicable to more than one namespace. ClusterRoles can define rules for cluster-scoped resources (such as nodes) as well. Both Roles and ClusterRoles are mapped as API Resources inside our cluster.

* Subjects: These correspond to the entity that attempts an operation in the cluster. There are three types of subjects:
* User Accounts: These are global, and meant for humans or processes living outside the cluster. There is no associated resource API Object in the Kubernetes cluster.
* Service Accounts: This kind of account is namespaced and meant for intra-cluster processes running inside pods, which want to authenticate against the API.
* Groups: This is used for referring to multiple accounts. There are some groups created by default such as cluster-admin (explained in later sections).
* RoleBindings and ClusterRoleBindings: Just as the names imply, these bind subjects to roles (i.e. the operations a given user can perform). As for Roles and ClusterRoles, the difference lies in the scope: a RoleBinding will make the rules effective inside a namespace, whereas a ClusterRoleBinding will make the rules effective in all namespaces.
You can find examples of each API element in the Kubernetes official documentation.

## Users in Kubernetes from [Kubernetes docs](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens)

All Kubernetes clusters have two categories of users: service accounts managed by Kubernetes, and normal users.

* Normal users are assumed to be managed by an outside, independent service. An admin distributing private keys, a user store like Keystone or Google Accounts, even a file with a list of usernames and passwords. In this regard, Kubernetes does not have objects which represent normal user accounts. Regular users cannot be added to a cluster through an API call.

* In contrast, service accounts are users managed by the Kubernetes API. They are bound to specific namespaces, and created automatically by the API server or manually through API calls. Service accounts are tied to a set of credentials stored as Secrets, which are mounted into pods allowing in-cluster processes to talk to the Kubernetes API.

API requests are tied to either a normal user or a service account, or are treated as anonymous requests. This means every process inside or outside the cluster, from a human user typing kubectl on a workstation, to kubelets on nodes, to members of the control plane, must authenticate when making requests to the API server, or be treated as an anonymous user.



## Apply RBAC to Azure AD users and groups


Run ```az aks get-credentials --name devopsaksad --resource-group devopsakdsad ``` --admin

**Creates a context called devopsaksad-admin**

1. Create an Active Directory Group called Kubernetes-admin
2. Create an Active Directory Group called DevOps
3. Create the admingroupclusterrolebinding yaml:

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
 name: group-cluster-admins
roleRef:
 apiGroup: rbac.authorization.k8s.io
 kind: ClusterRole
 name: cluster-admin
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: "Kubernetes-admin"

```

4. Create a second user in active directory and do not assign to the group
5. Ensure you had added the new user to the Azure subscription
6. Login to az cli as that user
7. You can issue the command 
```az aks get-credentials --name devopsaksad --resource-group devopsakdsad ```
8. When you try to run a kubectl command you will be presented with the following:

```To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code [code] to authenticate```

You will then be directed to an OAUTH permission request, see below:

![Permissions](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180627_2.png)

![Grant client AD application access](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180627_3.png)

If you try to run ```kubectl get nodes ``` you will receive the following message:

```You must be logged in to the server (Unauthorized)```





