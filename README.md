# clerk-integration

### 1. Build infrastructure

Navigate to `infrastructure` directory and run the following command

```
terragrunt run-all apply
```

### 2. Post-building infrastructure

Navigate to the [Application GitHub Repository](https://github.com/johnbedeir/clerk-integration) > `Actions` Tab and run the latest `Workflow` to make sure the `Docker Image` is built and pushed to the `ECR`

`Make sure you commit the recent updates before you do that`

### 3. Before deployment

Update the `kubeconfig` by running the following command:

```
aws eks update-kubeconfig --name cluster-1-dev --region eu-central-1
```

### 4. Application Deployment

### Deploy Via `Kubernetes`

Create namespace

```
kubectl create ns dev-clerk-app
```

Navigate to `k8s` directory and run the following command:

```
kubectl apply -n dev-clerk-app -f eks/
```

This will deploy the application `deployment`, `service` and `external secrets`

### (Optional) Deploy via `Helm Chart`

For deploying the application via `Helm`, Navigate to the [Chart Repository](https://github.com/johnbedeir/clerk-app-chart) and follow the steps in the `README`

### 5. Before Accessing the Application

Navigate to your `Domain CPanel` and update the `Zone Editor` with `CNAME` using the `Ingress LoadBalancer`

### a. fetch the LoadBalancers URLs from Kubernetes:

#### Application URL

```
kubectl get svc clerk-app-service -n dev-clerk-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Add the URL to `clerk.johnydev.com`

#### Ingress URL

```
kubectl get svc nginx-ingress-ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Add the URL to `alertmanager.johnydev.com`, `prometheus.johnydev.com` and `grafana.johnydev.com`

#### ArgoCD URL

```
kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Add the URL to `argocd.johnydev.com`

### b. Update the `CNAME` Record as shown

<img src=imgs/cpanel.png>

### c. Access the applications using the following URLs

#### Prometheus

```
prometheus.johnydev.com
```

#### AlertManager

```
alertmanager.johnydev.com
```

#### Access Application

```
clerk.johnydev.com
```

#### Check `clerk.json`

```
clerk.johnydev.com/feeds/clerk.json
```

Copy that URL to your `clerk.io` Data sync

<img src=imgs/data-sync.png>

#### ArgoCD

```
argocd.johnydev.com
```

Login using `admin` username

Fetch the `password` from `k8s secrets` using the following command:

```
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```

Add `+ New App` give it a name and then deploy using either `k8s manifests` or `Helm Chart`

Option 1: `GitHub Repository`

```
https://github.com/johnbedeir/clerk-integration
```

Add the `kubernetes manifest files` path

```
k8s/eks
```

And `Namespace`

```
dev-clerk-app
```

You should see your app

#### Grafana

```
grafana.johny
```
