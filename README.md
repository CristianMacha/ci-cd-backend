# NestJS Backend with CI/CD, n8n Automation & nginx Proxy

<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Nest Logo" /></a>
</p>

<p align="center">Production-ready NestJS backend with automated CI/CD, n8n workflow automation, and nginx reverse proxy, all deployed on AWS EC2 with SSL support.</p>

## 🏗️ Architecture Overview

This project implements a complete production infrastructure with:

- **🚀 NestJS Backend**: TypeScript API with health checks
- **🔄 n8n Automation**: Workflow automation platform
- **⚡ nginx Proxy**: Reverse proxy with SSL termination
- **🐳 Docker**: Containerized services with Docker Compose
- **☁️ AWS EC2**: Cloud hosting with optimized performance
- **🔐 SSL/HTTPS**: Cloudflare SSL with automatic certificates
- **⚙️ CI/CD**: Automated testing, building, and deployment

## 🎯 Features

- **Zero-downtime deployments** (~5 seconds downtime)
- **Automated CI/CD pipeline** with GitHub Actions
- **Docker Hub integration** for faster deployments
- **Manual deployment controls** for n8n and nginx
- **Health checks and monitoring**
- **SSL/HTTPS support** for all services
- **Production-optimized** Docker images

## 🚀 Quick Start

### Prerequisites

- AWS EC2 instance (t3.small recommended)
- Docker Hub account
- Cloudflare account (for SSL)
- Domain name with DNS control

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/your-username/your-project.git
cd your-project

# Install dependencies
npm install

# Build the project
npm run build
```

### 2. Environment Configuration

Create your environment variables in GitHub Secrets:

```
DOCKER_USERNAME=your-dockerhub-username
DOCKER_PASSWORD=your-dockerhub-access-token
EC2_HOST=your-ec2-public-ip
EC2_SSH_KEY=your-ec2-private-key-content
N8N_PASSWORD=secure-password-for-n8n
```

### 3. Deploy to Production

Push to main branch to trigger automatic deployment:

```bash
git add .
git commit -m "Initial deployment"
git push origin main
```

## 📁 Project Structure

```
.
├── .github/workflows/          # CI/CD workflows
│   ├── ci.yml                 # Automated: Build & test & push to Docker Hub
│   ├── cd.yml                 # Automated: Deploy backend only
│   ├── deploy-n8n.yml         # Manual: n8n management
│   └── deploy-nginx.yml       # Manual: nginx management
├── nginx/
│   └── nginx.conf             # Reverse proxy configuration
├── src/                       # NestJS application source
├── docker-compose.yml         # Multi-service orchestration
├── Dockerfile                 # Optimized multi-stage build
└── README.md                  # This file
```

## 🐳 Services Architecture

### Backend Service (Automated Deployment)
- **Image**: Your custom NestJS app from Docker Hub
- **Port**: 3000
- **Health Check**: `/health` endpoint
- **Deployment**: Automatic on every push to main

### n8n Service (Manual Deployment)
- **Image**: `n8nio/n8n:latest`
- **Port**: 5678
- **Access**: https://n8n.yourdomain.com
- **Deployment**: Manual via GitHub Actions

### nginx Service (Manual Deployment)
- **Image**: `nginx:alpine`
- **Ports**: 80, 443
- **Purpose**: Reverse proxy and SSL termination
- **Deployment**: Manual via GitHub Actions

## ⚙️ CI/CD Pipeline

### Automated Workflows

#### 1. CI Pipeline (`.github/workflows/ci.yml`)
**Triggers**: Push to `main` or `develop`

```yaml
✅ Checkout code
✅ Setup Node.js 22
✅ Install dependencies
✅ Run ESLint
✅ Build project
✅ Login to Docker Hub
✅ Build Docker image (latest + SHA tags)
✅ Push to Docker Hub
```

#### 2. CD Pipeline (`.github/workflows/cd.yml`)
**Triggers**: Successful CI completion on `main`

```yaml
✅ Pull latest code on EC2
✅ Pull latest image from Docker Hub
✅ Stop old backend container
✅ Start new backend container
✅ Health check verification
✅ Deployment success notification
```

### Manual Workflows

#### 3. Deploy n8n Service
**Access**: GitHub Actions → "Deploy n8n Service" → Run workflow

**Actions**:
- **`restart`**: Restart n8n with same version (fix issues)
- **`update`**: Update to latest n8n version
- **`logs`**: View n8n logs for debugging

#### 4. Deploy nginx Service
**Access**: GitHub Actions → "Deploy Nginx Service" → Run workflow

**Actions**:
- **`restart`**: Full restart (for config changes)
- **`reload-config`**: Quick config reload (zero downtime)
- **`logs`**: View access and error logs

## 🌐 DNS & SSL Setup

### Cloudflare Configuration

1. **DNS Records**:
   ```
   api.yourdomain.com     A    YOUR_EC2_IP    🧡 Proxied
   n8n.yourdomain.com     A    YOUR_EC2_IP    🧡 Proxied
   ```

2. **SSL Settings**:
   - SSL/TLS → Overview → **"Flexible"**
   - Edge Certificates → "Always Use HTTPS" → **ON**

### nginx Configuration

The nginx service routes traffic to appropriate containers:

```nginx
# API Backend
api.yourdomain.com → nestjs-app:3000

# n8n Automation
n8n.yourdomain.com → n8n-automation:5678
```

## 🔧 Local Development

### Development Setup

```bash
# Install dependencies
npm install

# Start in watch mode
npm run start:dev

# Run tests
npm run test

# Run linting
npm run lint
```

### Docker Development

```bash
# Build and run all services locally
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

## 📊 Production Deployment

### AWS EC2 Setup

**Recommended Instance**: `t3.small` (2 vCPU, 2 GB RAM)

**Security Groups**:
```
Port 22  (SSH)   - Your IP only
Port 80  (HTTP)  - 0.0.0.0/0 (for Cloudflare)
Port 443 (HTTPS) - 0.0.0.0/0 (for Cloudflare)
```

**Initial EC2 Setup**:
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install docker.io docker-compose-plugin -y
sudo usermod -aG docker ubuntu

# Setup project directory
sudo mkdir -p /app
sudo chown ubuntu:ubuntu /app

# Generate SSH key for GitHub
ssh-keygen -t ed25519 -C "your-email@example.com"
# Add public key as Deploy Key in GitHub repository

# Clone project
cd /app
git clone git@github.com:your-username/your-project.git .
```

### First Deployment

```bash
# On EC2, set required environment variable for backend service
export DOCKER_USERNAME=your-dockerhub-username

# Initial deployment (all services)
docker-compose up -d

# Verify all services are running
docker ps
```

## 🔍 Monitoring & Debugging

### Health Checks

- **Backend**: `https://api.yourdomain.com/health`
- **n8n**: `https://n8n.yourdomain.com` (Basic Auth required)
- **nginx**: Service status via `docker ps`

### Common Commands

```bash
# Check service status
docker ps

# View logs
docker logs nestjs-app --tail 50
docker logs n8n-automation --tail 50
docker logs nginx-proxy --tail 50

# Restart specific service
export DOCKER_USERNAME=your-dockerhub-username  # Only needed for app service
docker-compose restart app
docker-compose restart n8n    # No DOCKER_USERNAME needed
docker-compose restart nginx  # No DOCKER_USERNAME needed

# Emergency: Restart everything (set variable first for app service)
export DOCKER_USERNAME=your-dockerhub-username
docker-compose down && docker-compose up -d
```

### Troubleshooting

**Container corruption (ContainerConfig error)**:
```bash
# Nuclear option - recreate everything
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker system prune -f
# Set variable for app service before recreating
export DOCKER_USERNAME=your-dockerhub-username
docker-compose up -d
```

**SSL issues**:
- Verify Cloudflare SSL mode is "Flexible"
- Check DNS propagation: `nslookup yourdomain.com`
- Ensure ports 80/443 are open in Security Groups

## 📈 Performance Optimization

- **Multi-stage Docker builds** reduce image size by 60%
- **Docker Hub caching** reduces deployment time from 2+ minutes to ~30 seconds
- **Health checks** ensure zero failed requests during deployment
- **nginx caching** improves response times
- **Container restart strategy** minimizes downtime to ~5 seconds

## 🔒 Security Features

- **Non-root container execution** for enhanced security
- **Basic authentication** for n8n access
- **SSL/TLS encryption** for all external traffic
- **Private Docker networks** isolate services
- **Environment variable management** via GitHub Secrets
- **SSH key authentication** for deployments

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📝 License

This project is [MIT licensed](LICENSE).

## 🎯 Production Checklist

Before going live, ensure:

- [ ] AWS EC2 instance with correct Security Groups
- [ ] Docker Hub repository created
- [ ] All GitHub Secrets configured
- [ ] Cloudflare DNS with Proxied enabled
- [ ] SSH Deploy Key added to GitHub
- [ ] Domain names updated in all config files
- [ ] SSL certificates working (test https://yourdomains.com)
- [ ] Health checks responding correctly
- [ ] n8n accessible with proper authentication

---

**Need help?** Check the [Issues](https://github.com/your-username/your-project/issues) section or create a new issue with detailed information about your problem.