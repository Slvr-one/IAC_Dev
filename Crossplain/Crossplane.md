# Crossplane

- Refer to the [gist][cp_gs-gist].

## prequisites:

- Kubernetes cluster at your disposal, [Minikube][minikube], [KIND][kind] will do. 
- It needs to be able to reach the internet.
- Install [Crossplane][cp] to the cluster:

```bash
kubectl create namespace crossplane-system
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm upgrade --install crossplane --namespace crossplane-system crossplane-stable/crossplane
```

Before applying a Provider, make sure Crossplane is healthy and running. With the kubectl wait command:
```bash
kubectl wait deployment.apps/crossplane --namespace crossplane-system --for condition=AVAILABLE=True --timeout 1m
# kubectl wait pod -l app=crossplane --namespace crossplane-system --for=condition=ready --timeout=120s
```

[cp_gs-gist]: https://gist.github.com/Slvr-one/4c3c2e0628a0fc3f6e9b9168259676bc

[minikube]: https://minikube.sigs.k8s.io/docs/start/
[kind]: https://kind.sigs.k8s.io/docs/user/quick-start#installation
[cp]: https://docs.crossplane.io/v1.12/software/install/