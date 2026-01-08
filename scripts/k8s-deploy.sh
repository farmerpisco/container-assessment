#!/bin/bash

# Scripts to deploy the kubernetes manifest files 

# Exit immediately if a command exits with a non-zero status
set -e


# Deploy the namespace manifest file
kubectl apply -f ../kubernetes/namespace.yaml
echo "Muchtodo namespace has been created"
echo "------------"

# Deploy the secret manifest file
kubectl apply -f ../kubernetes/mongodb/mongodb-secret.yaml
echo "Mongodb secrets has been created"
echo "------------"

# Deploy mongodb persistence volume claim manifest file
kubectl apply -f ../kubernetes/mongodb/mongodb-pvc.yaml
echo "Mongodb PVC has been created"
echo "------------"

# Deploy mongodb deployment manifest file
kubectl apply -f ../kubernetes/mongodb/mongodb-deployment.yaml
echo "Mongodb has been deployed"
echo "------------"

# Deploy mongodb service manifest file
kubectl apply -f ../kubernetes/mongodb/mongodb-service.yaml
echo "Mongodb service has been created"
echo "------------"

# Deploy muchtodo-app configmap manifest file
kubectl apply -f ../kubernetes/backend/backend-configmap.yaml
echo "Muchtodo-app configmap has been created"
echo "------------"

# Deploy muchtodo-app deployment manifest file
kubectl apply -f ../kubernetes/backend/backend-deployment.yaml
echo "Muchtodo-app deployment has been created"
echo "------------"

# Deploy muchtodo-app service manifest file
kubectl apply -f ../kubernetes/backend/backend-service.yaml
echo "Muchtodo-app service has been created"
echo "------------"

# Deploy ingress manifest file
kubectl apply -f ../kubernetes/ingress.yaml
echo "Ingress has been created"
echo "------------"

sleep 30

# Verify pods that were created
kubectl get pods -n muchtodo
echo "------------"

# Verify services that were created
kubectl get services -n muchtodo
echo "------------"

# Verify muchtodo app is live
curl http://muchtodo.local
echo "----------"
