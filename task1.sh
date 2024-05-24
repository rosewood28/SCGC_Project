#!/bin/bash

# Set -e to exit the script if any command fails
set -e

# Create a Kubernetes cluster with kind
echo "Creating Kubernetes cluster with kind..."
kind create cluster
sleep 2

# Apply the nginx deployment
echo "Applying nginx deployment..."
kubectl apply -f task1_nginx_deployment.yaml

# Apply the HTML ConfigMap
echo "Applying HTML ConfigMap..."
kubectl apply -f task1_nginx_html.yaml

# Apply the nginx service
echo "Applying nginx service..."
kubectl apply -f task1_nginx_service.yaml

# Apply the nginx ConfigMap
echo "Applying nginxnginx Configuration ConfigMap..."
kubectl apply -f task1_nginx_config.yaml

echo "Waiting for the nginx deployment to be ready..."
kubectl wait --for=condition=Available deployment/nginx --timeout=600s
#Testing
echo "Test nginx app with curl http://172.18.0.2:30080"
curl http://172.18.0.2:30080

echo "Test metrics with curl http://172.18.0.2:30088/metrics"
curl http://172.18.0.2:30088/metrics
