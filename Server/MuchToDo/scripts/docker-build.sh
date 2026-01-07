#!/bin/bash

# Builds docker image from Dockerfile
docker build -t muchtodo-app:latest -f ../Dockerfile ..

echo "Docker image was built successfully"
echo "--------------------"

# Show list of images to confirm the docker image
docker images
echo "--------------------"
# Tag the docker image built with appropriate version
docker tag muchtodo-app:latest muchtodo-app:v1.0

echo "Docker tag versioning was successful"
echo "--------------------"

# Create docker network
docker network create muchtodo-app

echo "muchtodo-app network was created"
echo "--------------------"

# Run mongodb container
docker run -d \
--name mongodb \
--network muchtodo-app \
-e MONGO_INITDB_ROOT_USERNAME=goappuser \
-e MONGO_INITDB_ROOT_PASSWORD=goapppass \
-p 27017:27017 \
mongo

echo "Mongodb container is running"
echo "--------------------"

# Run muchtodo-app container
docker run -d \
--name muchtodo_app-live \
--network muchtodo-app \
-e MONGO_URI="mongodb://goappuser:goapppass@mongodb:27017/?authSource=admin" \
-e DB_NAME="muchtodo-db" \
-p 8082:8080 \
muchtodo-app:latest

echo "muchtodo-app container is running"
echo "--------------------"

sleep 60

# List currently running container
docker ps
echo "--------------------"

# Verify the muchtodo-app container is running 
curl http://localhost:8082
echo "--------------------"

# Stop both muchtodo-app and mongodb containers
docker stop muchtodo_app-live mongodb

echo "muchtodo-app and mongodb containers stopped"
echo "--------------------"

# Removed both muchtodo-app and mongodb containers
docker rm muchtodo_app-live mongodb

echo "muchtodo-app and mongodb containers removed"
echo "--------------------"

# Remove muchtodo-app network
docker network rm muchtodo-app

echo "muchtodo-app network removed"
echo "--------------------"