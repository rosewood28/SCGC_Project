#!/bin/bash

echo "Create a new Kubernetes namespace called 'monitoring'"
kubectl create namespace monitoring

echo "Get Prometheus Helm repository info"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "Deploy Prometheus Helm chart in the monitoring namespace"
helm install prometheus prometheus-community/prometheus -n monitoring -f task3_prometheus_values.yaml

echo "Waiting for the Helm chart deployment to be ready..."
sleep 10
while true; do
    if kubectl get pods -n monitoring | grep -qE "prometheus.*Running"; then
        READY_COUNT=$(kubectl get pods -n monitoring -o json | jq -r '.items[].status.containerStatuses[].ready' | grep -c true)
        TOTAL_COUNT=$(kubectl get pods -n monitoring -o json | jq -r '.items | length')
        if [ "$READY_COUNT" -eq "$TOTAL_COUNT" ]; then
            echo "All Prometheus pods are ready."
            break
        fi
    fi
done

# Forward port 9090 of my VM to port 80 on te prometheus-server service pod
# "kubectl get svc -n monitoring prometheus-server -o yaml" to find that port 80 was used by the service
echo "Forward the promeheus-server service to the VM"
echo "kubectl port-forward -n monitoring svc/prometheus-server 9090:80"
kubectl port-forward -n monitoring svc/prometheus-server 9090:80
