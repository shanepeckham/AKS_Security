# Enable RBAC on cluster with AD integration

Follow initial setup as documented [here](https://docs.microsoft.com/en-us/azure/aks/aad-integration)

Run ```az aks get-credentials --name devopsaksad --resource-group devopsakdsad ``` --admin

**Creates a context called devopsaksad-admin**

1. Add an Active Directory Group called Kubernetes-admin
2. Create the admingroupclusterrolebinding yaml:

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

3. Create a second user in active directory and do not assign to the group
4. Ensure you had added the new user to the Azure subscription
5. Login to az cli as that user






