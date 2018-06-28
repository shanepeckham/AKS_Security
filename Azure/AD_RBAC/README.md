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

## Best practise for RBAC with Azure Active Directory

* Use AD groups user acccess, not individual kubernetes users (subjects) for single, central and simplified maintenance 
* Use AD groups service access, not kubernetes service accounts for system access for single, central and simplified maintenance 


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

We can now grant the group to which the user belongs, namely DevOpsGroup, the permissions to read pods.

Create the following role yaml in kubectl:

```kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
  ```

Now we can create a Rolebinding to assign the role to the group DevOpsGroup:

```
# This role binding allows members in group DevOpsGroup to read pods in the "default" namespace.
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: Group
  name: "DevOpsGroup" # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```

Now if you run ```kubectl get pods``` you should see:

```No resources found```

To inspect what permissions you have you can issue the following command:

```kubectl auth can-i get pods```

You should see a friendly response:

![yes](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180628_4.png)

```kubectl auth can-i create pods```

Computer says no:

![no](https://github.com/shanepeckham/AKS_Security/blob/master/Images/Snip20180628_5.png)

# Create full application flow

* Control permissions by Azure Active Directory Group - DevOpsGroup
* Members of this group can only view pods in the default namespace
* Members of this group can create, view and exec into pods in the DevOpsGroup namespace

**Create the namespace for devops**

```kubectl create -f namespace-devops.yaml```

**Roles in Kubernets are additive, you cannot deny so we start from the baseline permissions and work from there**

**Create the role and rolebinding to get and list pods in namespace devops

```kubectl create -f role-pod-list-podlogs-list.yaml```

**As a member of devops run**

```kubectl auth can-i get pods -n devops```

**Create the role and rolebinding to create and exec pods in namespace devops

```kubectl auth can-i create pods -n devops```

**Now we want to create a deployment for a simple application - as a member of devops run**

```kubectl auth can-i create deployments -n devops```

As the admin assign the deployment role to the DevOpsGroup - role-deployment-create-watch-list.yaml

Now create the deployment as a member of devops

As the admin assign the service role to the DevOpsGroup - role-ervice-create-watch-list.yaml

Now create the service as a member of devops

**Now we can create a Pod Security Policy to control aspects of how containers are run**

See [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#what-is-a-pod-security-policy) for more info

Create the 













