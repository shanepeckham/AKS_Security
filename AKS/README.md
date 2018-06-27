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


