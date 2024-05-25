#!/bin/bash

# Uninstall the Prometheus Helm chart
helm uninstall prometheus --namespace monitoring

# Remove the Prometheus Helm repository
helm repo remove prometheus-community

# Delete the 'monitoring' namespace
kubectl delete namespace monitoring
