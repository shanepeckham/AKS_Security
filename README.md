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

### Container scanning
Solutions include:
• Aqua
• Twistlock

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


### Node level



### Cluster level


### Azure level

• Encrypt Storage (data at rest)



















Key risks:

• Access to sensitive data
• Ability to take over a Kubernetes cluster with elevated privileges
• Gain root access to Kubernetes worker nodes
• Run workloads or access components outside the Kubernetes cluster
• Deploying unvetted malicious images on to the cluster





Most security breaches were doing to humar error, deploying with defaults
