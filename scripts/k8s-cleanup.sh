#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Scripts to Cleanup the kubernetes manifest files 

# Cleanup the secret manifest file
kubectl delete -f ../kubernetes/mongodb/mongodb-secret.yaml
echo "Mongodb secrets has been removed"
echo "------------"

# Cleanup mongodb deployment manifest file
kubectl delete -f ../kubernetes/mongodb/mongodb-deployment.yaml
echo "Mongodb has been removed"
echo "------------"

# Cleanup mongodb service manifest file
kubectl delete -f ../kubernetes/mongodb/mongodb-service.yaml
echo "Mongodb service has been removed"
echo "------------"

# Cleanup mongodb persistence volume claim manifest file
kubectl delete -f ../kubernetes/mongodb/mongodb-pvc.yaml
echo "Mongodb PVC has been removed"
echo "------------"

# Cleanup muchtodo-app configmap manifest file
kubectl delete -f ../kubernetes/backend/backend-configmap.yaml
echo "Muchtodo-app configmap has been removed"
echo "------------"

# Cleanup muchtodo-app deployment manifest file
kubectl delete -f ../kubernetes/backend/backend-deployment.yaml
echo "Muchtodo-app Cleanupment has been removed"
echo "------------"

# Cleanup muchtodo-app service manifest file
kubectl delete -f ../kubernetes/backend/backend-service.yaml
echo "Muchtodo-app service has been removed"
echo "------------"

# Deploy ingress manifest file
kubectl delete -f ../kubernetes/ingress.yaml
echo "Ingress has been removed"
echo "------------"

# Cleanup the namespace manifest file
kubectl delete -f ../kubernetes/namespace.yaml
echo "Muchtodo namespace has been removed"
echo "------------"