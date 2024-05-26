#!/bin/bash

# Verify monitoring namespace exists
if kubectl get namespace monitoring > /dev/null 2>&1; then
  echo "Namespace monitoring exists."
else
  echo "Namespace monitoring does not exist. Exiting..."
  exit
fi

# Add Grafana Helm repository
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Grafana
helm install scgc-hw-grafana grafana/grafana -n monitoring

echo "Waiting for the Helm chart deployment to be ready..."
sleep 5
while true; do
    if kubectl get pods -n monitoring | grep -qE "scgc-hw-grafana.*Running"; then
        READY_COUNT=$(kubectl get pods -n monitoring -o json | jq -r \ '.items[] | select(.metadata.labels."app.kubernetes.io/instance" == "scgc-hw-grafana") | .status.containerStatuses[].ready' | grep -c true)
	TOTAL_COUNT=$(kubectl get pods -n monitoring -o json | jq -r \ '.items | map(select(.metadata.labels."app.kubernetes.io/instance" == "scgc-hw-grafana")) | length')
        if [ "$READY_COUNT" -eq "$TOTAL_COUNT" ]; then
            echo "All Grafana pods are ready."
            break
        fi
    fi
done

# Show the running pod
kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana

echo ""
echo "The password for 'admin' grafana user is:"
kubectl get secret --namespace monitoring scgc-hw-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

echo ""
echo "Forward grafana to VM with: kubectl port-forward svc/scgc-hw-grafana 3000:80"
kubectl port-forward -n monitoring svc/scgc-hw-grafana 3000:80
