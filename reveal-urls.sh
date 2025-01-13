#!/bin/bash


set -e

NAMESPACE="dev-clerk-app"
APP_URL=$(kubectl get svc clerk-app-service -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Application URL: http://${APP_URL}"

INGRESS_URL=$(kubectl get svc nginx-ingress-ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Ingress URL: http://${INGRESS_URL}"

ARGOCD_URL=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "ArgoCD URL: http://${ARGOCD_URL}"

echo "Retrieving ArgoCD initial admin secret..."
ARGOCD_SECRET=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
echo "ArgoCD Admin Password: ${ARGOCD_SECRET}"

echo "Grafana Credentials:"
echo "Username: admin"
echo "Password: admin"
