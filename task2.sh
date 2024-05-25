#!/bin/bash

# Set -e to exit the script if any command fails
set -e

# Apply the nginx-prometheus-exporter deployment
echo "Applying nginx-prometheus-exporter deployment..."
kubectl apply -f task2_prometheus_exporter.yaml

# Apply the nginx-prometheus-exporter service
echo "Applying nginx-prometheus-exporter service"
kubectl apply -f task2_service.yaml

echo "Waiting for the nginx deployment to be ready..."
kubectl wait --for=condition=Available deployment/nginx-prometheus-exporter --timeout=600s
#Testing
echo "Result of kubectl describe pods nginx-prometheus-exporter"
kubectl describe pods nginx-prometheus-exporter
