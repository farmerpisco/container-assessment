#!/bin/bash

# Use the docker compose file to run mutiple services, and create network and volume
docker compose \
--env-file ../docker-compose.env \
-f ../docker-compose.yaml \
up -d
echo "Containers are up and running"
echo "-------------------"

sleep 60

# Validate running containers
docker compose \
--env-file ../docker-compose.env \
-f ../docker-compose.yaml \
ps
echo "-------------------"

# Verify muchtodo-app container is live
curl http://localhost:8082
echo "-------------------"

#clean up
docker compose \
--env-file ../docker-compose.env \
-f ../docker-compose.yaml \
down -v
echo "Clean up is complete and successful"
echo "-------------------"
