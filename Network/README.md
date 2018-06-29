
# Network Policies

## Mini-Kube

Thanks to [TechDiction](https://www.techdiction.com/2018/06/02/enforcing-network-policies-using-kube-router-on-aks/) for the [working example](https://github.com/marrobi/kube-router/blob/marrobi/aks-yaml/daemonset/kube-router-firewall-daemonset-aks.yaml)

Run the following command to install:

```kubectl create -f templates/kube-router-firewall-daemonset-aks.yaml```

The status of the kube router daemonset can be seen by running:

```kubectl get daemonset kube-router -n kube-system```

If we navigate to the service we created for flaskhello, e.g. http://40.114.29.99:5000/ which should see our service return. Now we will apply a network policy to deny all traffiic

**Now we will deny all ingress to out cluster

```kubectl create -f kubectl create -f devops-deny-all.yaml```

Navigate to the service we created for flaskhello, e.g. http://40.114.29.99:5000/, you should now get a refused connection.

**Now we will open the port 5000 only for ingress to the entire namespace devops**

```kubectl create -f kubectl create -f devops-allow-ingress-5000.yaml```



