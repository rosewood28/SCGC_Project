#!/bin/bash

# Uninstall the Grafana Helm release
helm uninstall scgc-hw-grafana -n monitoring

# Remove the Grafana Helm repository
helm repo remove grafana
