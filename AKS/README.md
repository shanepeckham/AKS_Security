# AKS Node issues from running [Kube-Bench](https://github.com/aquasecurity/kube-bench) on the node for AKS running on Kubernetes 10.3

1. [INFO] 2 Worker Node Security Configuration
2. [INFO] 2.1 Kubelet
3. [FAIL] 2.1.1 Ensure that the --allow-privileged argument is set to false (Scored)
4. [PASS] 2.1.2 Ensure that the --anonymous-auth argument is set to false (Scored)
5. [PASS] 2.1.3 Ensure that the --authorization-mode argument is not set to AlwaysAllow (Scored)
6. [PASS] 2.1.4 Ensure that the --client-ca-file argument is set as appropriate (Scored)
7. [FAIL] 2.1.5 Ensure that the --read-only-port argument is set to 0 (Scored)
8. [FAIL] 2.1.6 Ensure that the --streaming-connection-idle-timeout argument is not set to 0 (Scored)
9. [FAIL] 2.1.7 Ensure that the --protect-kernel-defaults argument is set to true (Scored)
10. [FAIL] 2.1.8 Ensure that the --make-iptables-util-chains argument is set to true (Scored)
11. [PASS] 2.1.9 Ensure that the --keep-terminated-pod-volumes argument is set to false (Scored)
12. [PASS] 2.1.10 Ensure that the --hostname-override argument is not set (Scored)
13. [PASS] 2.1.11 Ensure that the --event-qps argument is set to 0 (Scored)
14. [FAIL] 2.1.12 Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate (Scored)
15. [PASS] 2.1.13 Ensure that the --cadvisor-port argument is set to 0 (Scored)
16. [FAIL] 2.1.14 Ensure that the RotateKubeletClientCertificate argument is set to true
17. [FAIL] 2.1.15 Ensure that the RotateKubeletServerCertificate argument is set to true
18. [INFO] 2.2 Configuration Files
19. [FAIL] 2.2.1 Ensure that the kubelet.conf file permissions are set to 644 or more restrictive (Scored)
20. [FAIL] 2.2.2 Ensure that the kubelet.conf file ownership is set to root:root (Scored)
21. [FAIL] 2.2.3 Ensure that the kubelet service file permissions are set to 644 or more restrictive (Scored)
22. [FAIL] 2.2.4 2.2.4 Ensure that the kubelet service file ownership is set to root:root (Scored)
23. [FAIL] 2.2.5 Ensure that the proxy kubeconfig file permissions are set to 644 or more restrictive (Scored)
24. [FAIL] 2.2.6 Ensure that the proxy kubeconfig file ownership is set to root:root (Scored)
25. [WARN] 2.2.7 Ensure that the certificate authorities file permissions are set to 644 or more restrictive (Scored)
26. [WARN] 2.2.8 Ensure that the client certificate authorities file ownership is set to root:root

## Issue 2.1.1 Ensure that the --allow-privileged argument is set to false

If true, it allows containers to request privileged mode.

**Mitigation**

Apply Pod Security policies with RBAC and ClusterRoles. Ensure that containers are run with security contexts.


## 2.1.5 Ensure that the --read-only-port argument is set to 0

The read-only port for the Kubelet to serve on with no authentication/authorization (set to 0 to disable) (default 10255)

Access to port 10255 to the Kubernetes API server is blocked by Azure networking. Furthermore, AKS can be deployed with the API server being fully private.

## 2.1.6 Ensure that the --streaming-connection-idle-timeout argument is not set to 0

Maximum time a streaming connection can be idle before the connection is automatically closed. 0 indicates no timeout. Example: '5m' (default 4h0m0s)

UNCLEAR WHY THIS IS A SECURITY ISSUE WHEN SETTING IT TO 0 WILL RESULT IN NO TIMEOUT????

## 2.1.7 Ensure that the --protect-kernel-defaults argument is set to true

Default kubelet behaviour for kernel tuning. If set, kubelet errors if any of kernel tunables is different than kubelet defaults.

WHY DOES THIS NEED TO BE SET TO TRUE - SURELY IT SHOULD BE SET TO FALSE

**Mitigation**

Restrict access to running privilged containers and access to kubernetes node hosts

## 2.1.8 Ensure that the --make-iptables-util-chains argument is set to true

If true, kubelet will ensure iptables utility rules are present on host.

WHY IS THIS A SECURITY ISSUE? WILL KUBEROUTER OR OTHER NETWORK POLICIES WORK IF THIS IS FALSE

**Mitigation**

Restrict access to running privilged containers and access to kubernetes node hosts

## Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate

--cert-dir The directory where the TLS certs are located (by default /var/run/kubernetes). If --tls-cert-file and --tls-private-key-file are provided, this flag will be ignored. (default "/var/run/kubernetes")
      --cgroup-driver string                                    Driver that the kubelet uses to manipulate cgroups on the host.  Possible values: 'cgroupfs', 'systemd' (default "cgroupfs")
      
File containing x509 Certificate for HTTPS.  (CA cert, if any, concatenated after server cert). If --tls-cert-file and --tls-private-key-file are not provided, a self-signed certificate and key are generated for the public address and saved to the directory passed to --cert-dir.
      --tls-private-key-file string                             File containing x509 private key matching --tls-cert-file.
      --volume-plugin-dir string                                <Warning: Alpha feature> The full path of the directory in which to search for additional third party volume plugins (default "/usr/libexec/kubernetes/kubelet-plugins/volume/exec/")
      
**Mitigations**

Using Istio???

## 2.1.14 Ensure that the RotateKubeletClientCertificate argument is set to true


https://kubernetes.io/docs/tasks/tls/certificate-rotation/#enabling-client-certificate-rotation

The kubelet process accepts an argument --rotate-certificates that controls if the kubelet will automatically request a new certificate as the expiration of the certificate currently in use approaches. Since certificate rotation is a beta feature, the feature flag must also be enabled with --feature-gates=RotateKubeletClientCertificate=true.

## 2.1.15 Ensure that the RotateKubeletServerCertificate argument is set to true


## 2.2.1 Ensure that the kubelet.conf file permissions are set to 644 or more restrictive

**Mitigation**

Restrict access to running privilged containers and access to kubernetes node hosts

## 2.2.2 Ensure that the kubelet.conf file ownership is set to root:root

**Mitigation**

Restrict access to running privilged containers and access to kubernetes node hosts

## 2.2.3 Ensure that the kubelet service file permissions are set to 644 or more restrictive

**Mitigation**

Restrict access to running privilged containers and access to kubernetes node hosts

## 2.2.4 Ensure that the kubelet service file ownership is set to root:root 

**Mitigation**

Restrict access to running privilged containers and access to kubernetes node hosts

## 2.2.6 Ensure that the proxy kubeconfig file ownership is set to root:root

**Mitigation**

Restrict access to running privilged containers and access to kubernetes node hosts



















