# Deploying secure solutions on Azure Kubernetes Service

## Key risks of an insecure Kubernetes cluster

* Access to sensitive data
* Ability to take over a Kubernetes cluster with elevated privileges
* Gain root access to Kubernetes worker nodes
* Run workloads or access components outside the Kubernetes cluster
* Deploying unvetted malicious images on to the cluster

## First Principles:

* Apply least privileged access
* Segregation of responsibility
* Integrate security into DevOps

## Kubernetes best practices

* Authentication RBAC
* Authorisation
* Network Segmentation - tightly control all communication
* Pod Security Policy
* Encrypt Secrets
* Auditing
* Admission Controllers
* Layered security approach
* Label everything for granular control
* Apply networking segmentation at Level 4 (e.g. Kuberouter) and Level 7 (Istio, Linkerd)
* A user should not be able to override Kubernetes security by crafting a YAML file if layered security controls have been successfully implemented
* Create administrative boundaries between resources
* Store secrets centrally, preferably in a secure valault such as Azure Key Vault

### Container Level 

* Use a trusted registry so that only authorised images are depployed to the cluster. Introduce a process to approve images for uploading to registry
* Regularly apply security updates to cluster and container images (AKS will auto patch. Azure automatically applies security patches to the nodes in an AKS cluster on a nightly schedule

* Scan container - solutions include:
** [Aqua](www.aquasec.com)
** [Twistlock](https://www.twistlock.com/)
** [Docker Bench for security](https://github.com/docker/docker-bench-security)
** [CoreOS Clair](https://github.com/coreos/clair)
** [OpenScap](https://www.open-scap.org/tools/)
** [Neuvector](https://neuvector.com/container-compliance-auditing-solutions/)

* Avoid access to HOST PIC namespace - only if absolutely necessary
* Avoid access toi Host PID namespace - only if absolutely necessary
* A pod policy cannot necessarily protect against a container image that has privileged root access

* Scan image with Aqua MicroScanner - https://github.com/aquasecurity/microscanner - can be run be developer on dev workstation prior to uploading to container registry

Add the following to the Dockerfile

```
ADD https://get/aquasec.com/microscanner
RUN chmod +x microscanner
ARG token
RUN /microscanner ${token} && rm /microscanner
```

* [Secure Docker](https://www.cisecurity.org/benchmark/docker/)

### Pod Level

* PodSecurityPolicies are only available if admission controllers have been implemented - dynamic admission controllers are available in 1.10

** PodSecurityPolicy can: (NEED RECIPES)
*** Avoid privilged containers from being run
*** Avoid containers that use the root namespaces from being run
*** Limit permissions on bvolume types that can be used
*** Enforce read only access to root file system
*** Ensure SELinux and AppArmor context
*** Apply Secomp/SELinux/App Armor profile
*** Can disable hostPath volumes

* Restrict access to Host PID
** Avoid priviled pods
Add security context, see:
*** https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
*** https://kubernetes.io/docs/concepts/policy/pod-security-policy/
*** https://sysdig.com/blog/kubernetes-security-psp-network-policy/

* Exposed credentials
* Mount host with write access
* Expose unnecessary ports

* Use AllwaysPullImages
** Force registry authentication and can prevent other pods using the image
** Only those with correct credentials can pull pod
** Can result in a crashloopbackoff if the credentials are not provided or incorrect

* Use DenyEscalatingExec
** If container has priviliged access, user this DenyEscalatingControl as mitigation as this will deny user trying to issue kubectl exec against the image and gain access to the node/cluster

### Namespace level

* By applying a ResourceQuota, DoS attacks that target on malicious resource consumptio can be mitigated against. Apply a ResourceQuote admission controller to restrict resources such as :
** CPU
** Memory
** Pods
** Services
** ReplicationControllers
** ResourceQuota
** Secrets
** PersistentVolumeClaims

### Node level

* Use admission controller to prvent intra-pod leakage, exposed secrets/ config maps etc:
** Limit the Node and Pod that a kubelet can modify
** Enforce that kubelets must use credentials in system nodes

* Limit SSH access to nodes - this is possible with AKS https://docs.microsoft.com/en-us/azure/aks/aks-ssh. Use kubectl exec instead if absolutely necessary - see DenyEscalating policy

### Cluster level

* Admission Controllers
** Operates at the API Server level
** Intercepts request before it is persisted to etcd
** Occurrs after authentication
** Only cluster admin can configure an admission controller
** Failure to configure the admission controller results in other functionality not being available

** Two types of admission control
*** Mutuating - can modify the request
*** Validation - can only validate, not modify

Any request that is rejected will fail and pass an error message to the user

** Developed out of tree and configured at runtime
** Facilitates dynamic action responses
** Should be within the same cluster

Available in Kubernetes 1.10 - IS THIS AVAILABLE ON AKS???

The following are the recommended admission controllers:
* NamespaceLifeCycle
* LimitRanger
* ServiceAccount
* DefaultStorageClass
* DefaultTolerationSeconds
* MutuatingAdmissionWebhoon
* Validating AdmissionWebhook
* ResourceQuota

Applying the ImagePolicyWebhopok allows an external service to be invoked (Aqua, Twistlock) for scanning at the cluster level will protect against:

** Images running vulnerabilities
** Images running malware
** Images that embed secrets
** Images that run as UID 0 (root privileges)

** Apply network segmentation, tools include:
*** [Kube-router](https://www.kube-router.io/) - [ahmetb's has some examples here](https://github.com/ahmetb/kubernetes-network-policy-recipes) for examples 
*** [Trireme](https://github.com/aporeto-inc/trireme-kubernetes)

** Apply service mesh and application routing
*** [Twistlock cloud native firewall](https://www.twistlock.com/platform/cloud-native-firewall/)
*** [Istio Service Mesh](https://istio.io/)
*** [Linkerd Service Mesh](https://linkerd.io/)
*** [Heptio Contour](https://heptio.com/products/#heptio-contour)

** Manage configuration
*** [Heptio Sonobuoy](https://heptio.com/products/#heptio-sonobuoy)

** Kubernetes conformance tests
*** [Heptio Sonobuoy Scanner](https://scanner.heptio.com/)
*** [kubesec.io](https://kubesec.io/)
=== [Falco](https://sysdig.com/opensource/falco/)



### Azure level

* Integrate AKS RABC with Azure Active Directory - https://docs.microsoft.com/en-us/azure/aks/aad-integration
* Encrypt Storage [encrypt data at rest](https://docs.microsoft.com/en-us/azure/storage/common/storage-service-encryption)
* Apply regular updates- Azure automatically applies security patches to the nodes in your cluster on a nightly schedule
* Apply NSGs for cross cluster communication

### CI/CD pipeline

* Add scanning to pipeline build



### Auditing and Logging

* Audit everything at the cluster level,  tools include:
** [AKS containerlogging](https://docs.microsoft.com/en-us/azure/monitoring/monitoring-container-health)
** [Fluentd](https://www.fluentd.org/)
** [Grafana](https://grafana.com/)
** [Kibana](https://www.elastic.co/products/kibana)
** [Prometheus](https://prometheus.io/)


Most security breaches were doing to humar error, deploying with defaults


# Additional resource for security
* Kube-Bench open source tool- CIS benchmark testing - https://github.com/aquasecurity/kube-bench . This will raise issues and remediations
* Kube-Hunter - penetration testing tool to be run by the security team. Identify key security risks at the cluster level. In private beta and will be a free tool
* [Aqua Microscanner](https://github.com/aquasecurity/microscanner) to assess security of image at build time. Can be run on developer workstation prior to upload to regstry
* Using Kured, an open-source reboot daemon for Kubernetes. Kured runs as a DaemonSet and monitors each node for the presence of a file indicating that a reboot is required. It then orchestrates those reboots across the cluster, following the same cordon and drain process described earlier. - https://github.com/weaveworks/kured




