# Encryption and layer 7 control and routing

# Linkerd

We will set up [Linkerd](https://linkerd.io) for encryption and routing control

** We will deploy Linkerd in its own namespace

```kubectl create ns linkerd```
```
kubectl apply -f https://raw.githubusercontent.com/linkerd/linkerd-examples/master/k8s-daemonset/k8s/servicemesh.yml
```



