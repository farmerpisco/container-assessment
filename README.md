# MuchToDo - Container Assessment Project

A production-ready Golang backend application with MongoDB, demonstrating containerization with Docker and orchestration with Kubernetes. This project showcases best practices for building, deploying, and managing containerized applications.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Deployment Options](#deployment-options)
  - [Docker Deployment](#docker-deployment)
  - [Docker Compose Deployment](#docker-compose-deployment)
  - [Kubernetes Deployment](#kubernetes-deployment)
- [Configuration](#configuration)
- [API Endpoints](#api-endpoints)
- [Monitoring and Health Checks](#monitoring-and-health-checks)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🔍 Overview

MuchToDo is a containerized Golang backend application that demonstrates:

- Multi-stage Docker builds for optimized image sizes
- Security best practices (non-root users, health checks)
- Docker Compose for local development
- Kubernetes manifests for production deployment
- MongoDB integration with proper secret management
- Ingress configuration for external access

## 🏗 Architecture

```
┌─────────────────┐
│   Ingress       │ (muchtodo.local)
└────────┬────────┘
         │
┌────────▼────────┐
│  MuchToDo App   │ (Port 8080)
│   (2 replicas)  │
└────────┬────────┘
         │
┌────────▼────────┐
│    MongoDB      │ (Port 27017)
│  + Persistence  │
└─────────────────┘
```

**Components:**
- **MuchToDo App**: Golang backend service with health checks and logging
- **MongoDB**: Database with persistent storage
- **Mongo Express**: Web-based MongoDB admin interface (development only)

## 📦 Prerequisites

### Required Software

- **Docker**: Version 20.10 or higher
  ```bash
  docker --version
  ```

- **Docker Compose**: Version 2.0 or higher
  ```bash
  docker compose version
  ```

- **Kubernetes** (for K8s deployment):
  - Minikube 1.25+ or Kind 0.14+
  - kubectl 1.21+
  ```bash
  kubectl version --client
  ```

- **Golang**: Version 1.23+ (for local development)
  ```bash
  go version
  ```

### System Requirements

- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: 5GB free space
- **OS**: Linux, macOS, or Windows with WSL2

## 📁 Project Structure

```
container-assessment/
├── application-code/        
│   ├── cmd/
│   │   └── api/            
│   ├── go.mod             
│   └── go.sum            
├── kubernetes/          
│   ├── backend/
│   │   ├── backend-configmap.yaml
│   │   ├── backend-deployment.yaml
│   │   └── backend-service.yaml
│   ├── mongodb/
│   │   ├── mongodb-deployment.yaml
│   │   ├── mongodb-pvc.yaml
│   │   ├── mongodb-secret.yaml
│   │   └── mongodb-service.yaml
│   ├── ingress.yaml
│   └── namespace.yaml
├── scripts/                
│   ├── docker-deploy.sh   
│   ├── docker-compose-deploy.sh
│   ├── k8s-deploy.sh       
│   └── k8s-cleanup.sh    
├── Dockerfile              
├── docker-compose.yaml    
├── docker-compose.env.example  
├── .dockerignore         
└── .gitignore         
```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/farmerpisco/container-assessment.git
cd container-assessment
```

### 2. Create Environment File

```bash
cp docker-compose.env.example docker-compose.env
```

Edit `docker-compose.env` with your configuration:

```env
DB_NAME=muchtodo_db
MONGO_USERNAME=muchtodo
MONGO_PASSWORD=YourSecurePassword123
MONGODB_SERVER=mongodb
```

### 3. Choose Your Deployment Method

See [Deployment Options](#deployment-options) below for detailed instructions.

## 🐳 Deployment Options

### Docker Deployment

Deploy using plain Docker commands with automated script.

#### Build and Run

```bash
cd scripts
chmod +x docker-deploy.sh
./docker-deploy.sh
```

#### What the Script Does

1. Builds Docker image: `muchtodo-app:latest`
2. Tags version: `muchtodo-app:v1.0`
3. Creates Docker network: `muchtodo-app`
4. Starts MongoDB container
5. Starts MuchToDo app container
6. Verifies deployment with health check
7. Cleans up resources

#### Manual Deployment

If you prefer manual control:

```bash
# Build image
docker build -t muchtodo-app:latest -f Dockerfile .

# Create network
docker network create muchtodo-app

# Run MongoDB
docker run -d \
  --name mongodb \
  --network muchtodo-app \
  -e MONGO_INITDB_ROOT_USERNAME=goappuser \
  -e MONGO_INITDB_ROOT_PASSWORD=goapppass \
  -p 27017:27017 \
  mongo

# Run application
docker run -d \
  --name muchtodo-app \
  --network muchtodo-app \
  -e MONGO_URI="mongodb://goappuser:goapppass@mongodb:27017/?authSource=admin" \
  -e DB_NAME="muchtodo-db" \
  -p 8082:8080 \
  muchtodo-app:latest
```

#### Access the Application

```bash
curl http://localhost:8082
```

#### Stop and Cleanup

```bash
docker stop muchtodo-app mongodb
docker rm muchtodo-app mongodb
docker network rm muchtodo-app
```

---

### Docker Compose Deployment

**Recommended for local development** - Manages multiple services with a single command.

#### Deploy All Services

```bash
cd scripts
chmod +x docker-compose-deploy.sh
./docker-compose-deploy.sh
```

#### Manual Docker Compose Commands

```bash
# Start services
docker compose --env-file docker-compose.env up -d

# View logs
docker compose logs -f muchtodo-app

# Check status
docker compose ps

# Stop services
docker compose down

# Stop and remove volumes
docker compose down -v
```

#### Access Services

- **MuchToDo App**: http://localhost:8082
- **MongoDB**: localhost:27017
- **Mongo Express** (Admin UI): http://localhost:8083

#### Service Configuration

| Service | Internal Port | External Port | Purpose |
|---------|--------------|---------------|---------|
| muchtodo-app | 8080 | 8082 | Main application |
| mongodb | 27017 | 27017 | Database |
| mongo-express | 8081 | 8083 | DB admin interface |

---

### Kubernetes Deployment

**Recommended for production** - Full orchestration with scaling, persistence, and ingress.

#### Deploy to Kubernetes

```bash
cd scripts
chmod +x k8s-deploy.sh
./k8s-deploy.sh
```

#### What the Deployment Script Does

1. Creates `muchtodo` namespace
2. Deploys MongoDB secrets
3. Creates PersistentVolumeClaim for MongoDB
4. Deploys MongoDB with persistent storage
5. Creates MongoDB service
6. Deploys application ConfigMap
7. Deploys application (2 replicas)
8. Creates application service
9. Configures Ingress for external access
10. Verifies all pods and services

#### Manual Kubernetes Deployment

```bash
# Apply manifests in order
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/mongodb-secret.yaml
kubectl apply -f kubernetes/mongodb/mongodb-pvc.yaml
kubectl apply -f kubernetes/mongodb/mongodb-deployment.yaml
kubectl apply -f kubernetes/mongodb/mongodb-service.yaml
kubectl apply -f kubernetes/backend/backend-configmap.yaml
kubectl apply -f kubernetes/backend/backend-deployment.yaml
kubectl apply -f kubernetes/backend/backend-service.yaml
kubectl apply -f kubernetes/ingress.yaml
```

#### Configure Local DNS

Add to `/etc/hosts` (Linux/Mac) or `C:\Windows\System32\drivers\etc\hosts` (Windows):

```bash
# Get Machind IP
minikube ip

# Add entry (replace <MINIKUBE_IP> with actual IP)
echo "<MINIKUBE_IP> muchtodo.local" | sudo tee -a /etc/hosts
```

#### Access the Application

```bash
curl http://muchtodo.local
```

#### Verify Deployment

```bash
# Check pods
kubectl get pods -n muchtodo

# Check services
kubectl get svc -n muchtodo

# Check ingress
kubectl get ingress -n muchtodo

# View logs
kubectl logs -f deployment/muchtodo-app -n muchtodo

# Describe pod (troubleshooting)
kubectl describe pod <pod-name> -n muchtodo
```

#### Scale Application

```bash
# Scale to 5 replicas
kubectl scale deployment muchtodo-app -n muchtodo --replicas=5

# Verify scaling
kubectl get pods -n muchtodo
```

#### Cleanup Kubernetes Resources

```bash
cd scripts
chmod +x k8s-cleanup.sh
./k8s-cleanup.sh
```

Or manually:

```bash
kubectl delete namespace muchtodo
```

---

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `MONGO_URI` | MongoDB connection string | Yes | - |
| `DB_NAME` | Database name | Yes | - |
| `MONGO_USERNAME` | MongoDB admin username | Yes | - |
| `MONGO_PASSWORD` | MongoDB admin password | Yes | - |
| `MONGODB_SERVER` | MongoDB server hostname | Yes (compose) | `mongodb` |

### Docker Compose Environment

Create `docker-compose.env`:

```env
DB_NAME=YourDbName
MONGO_USERNAME=YourUsername
MONGO_PASSWORD=SecurePassword123!
MONGODB_SERVER=mongodb
```

### Kubernetes Secrets

MongoDB credentials are base64 encoded in `mongodb-secret.yaml`:

```bash
# Encode credentials
echo -n "YourUsername" | base64
# Output: 

echo -n "SecurePassword" | base64
# Output: 
```

**⚠️ Security Warning**: The current secrets are examples. Generate new credentials for production:

### View Logs

**Docker:**
```bash
docker logs muchtodo-app
docker logs -f muchtodo-app  # Follow logs
```

**Docker Compose:**
```bash
docker compose logs muchtodo-app
docker compose logs -f  # All services
```

**Kubernetes:**
```bash
kubectl logs deployment/muchtodo-app -n muchtodo
kubectl logs -f deployment/muchtodo-app -n muchtodo  # Follow logs
```

## 📈 Performance Optimization

### Docker Image Optimization

The multi-stage Dockerfile reduces image size:
- **Builder stage**: Full Go environment (~800MB)
- **Runtime stage**: Alpine Linux only (~15MB)
- **Final image**: ~25MB (vs ~815MB single-stage)

## 👤 Author

**farmerpisco**
- Email: farmerpisco@gmail.com
- GitHub: [@farmerpisco](https://github.com/farmerpisco)
