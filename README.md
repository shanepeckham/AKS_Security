# AKS_Security


## First Principles:

• Apply least privileged access
• Segregation of responsibility


## Kubernetes best practices

• Authentication RBAC
• Authorisation
• Network Segmentation
• Pod Security Policy
• Encrypt Secrets
• Auditing
• Admission Controllers
• Layered security approach
• Label everything for granular control
• Apply networking segmentation at Level 4 (e.g. Kuberouter) and Level 7 (Istio, Linkerd)


### Container Level 

Scan container - solutions include:
• Aqua
• Twistlock
• Avoid access to HOST PIC namespace - only if absolutely necessary
• Avoid access toi Host PID namespace - only if absolutely necessary
• A pod policy cannot necessarily protect against a container image that has privileged root access

### Pod Level

• Restrict access to Host PID
• Avoid priviled pods
Add security context, see:
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
https://kubernetes.io/docs/concepts/policy/pod-security-policy/
https://sysdig.com/blog/kubernetes-security-psp-network-policy/

• Exposed credentials
• Mount host with write access
• Expose unnecessary ports

• Use AllwaysPullImages
••• Force registry authentication and can prevent other pods using the image
••• Only those with correct credentials can pull pod
••• Can result in a crashloopbackoff if the credentials are not provided or incorrect

• Use DenyEscalating Exec
•• If container has priviliged access, user this DenyEscalatingControl as mitigation as this will deny user trying to issue kubectl exec against the image and gain access to the node/cluster

### Node level



### Cluster level
• Admission Controllers
•• Operates at the API Server level
•• Intercepts request before it is persisted to etcd
•• Occurrs after authentication
•• Only cluster admin can configure an admission controller
•• Failure to configure the admission controller results in other functionality not being available

•• Two types of admission control
••• Mutuating - can modify the request
••• Validation - can only validate, not modify
Any request that is rejected will fail and pass an error message to the user

•• Developed out of tree and configured at runtime
•• Facilitates dynamic action responses
•• Should be within the same cluster

Available in Kubernetes 1.10 - IS THIS AVAILABLE ON AKS???

The following are the recommended admission controllers:
•• NamespaceLifeCycle
•• LimitRanger
•• ServiceAccount
•• DefaultStorageClass
•• DefaultTolerationSeconds
•• MutuatingAdmissionWebhoon
•• Validating AdmissionWebhook
•• ResourceQuota


### Azure level

• Encrypt Storage (data at rest)



















Key risks:

• Access to sensitive data
• Ability to take over a Kubernetes cluster with elevated privileges
• Gain root access to Kubernetes worker nodes
• Run workloads or access components outside the Kubernetes cluster
• Deploying unvetted malicious images on to the cluster





Most security breaches were doing to humar error, deploying with defaults
