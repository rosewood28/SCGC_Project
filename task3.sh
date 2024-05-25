#!/bin/bash

echo "Create a new Kubernetes namespace called 'monitoring'"
kubectl create namespace monitoring

echo "Get Prometheus Helm repository info"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "Deploy Prometheus Helm chart in the monitoring namespace"
helm install prometheus prometheus-community/prometheus --namespace monitoring

echo "Waiting for the Helm chart deployment to be ready..."
while true; do
    if kubectl get pods -n monitoring | grep -qE "prometheus.*Running"; then
        READY_COUNT=$(kubectl get pods -n monitoring -o json | jq -r '.items[].status.containerStatuses[].ready' | grep -c true)
        TOTAL_COUNT=$(kubectl get pods -n monitoring -o json | jq -r '.items | length')
        if [ "$READY_COUNT" -eq "$TOTAL_COUNT" ]; then
            echo "All Prometheus pods are ready."
            break
        fi
    fi
    sleep 5
done

echo "Forward the promeheus-server service to the VM"
kubectl port-forward -n monitoring prometheus-server 9090:80
