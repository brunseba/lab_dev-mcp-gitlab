# Installation Options

This document outlines various installation methods for the MCP-GitLab integration.

## Docker Installation (Recommended)

### Quick Start with Docker Compose

```bash
# Clone the repository
git clone https://github.com/your-username/dev-mcp-gitlab.git
cd dev-mcp-gitlab

# Configure environment
cp .env.example .env
# Edit .env with your GitLab credentials

# Start services
docker-compose up -d
```

### Docker Run

```bash
docker run -d \
  --name gitlab-mcp \
  -p 3000:3000 \
  -e GITLAB_URL=https://gitlab.example.com \
  -e GITLAB_TOKEN=your-token-here \
  iwakitakuma/gitlab-mcp:latest
```

## Native Installation

### Prerequisites

- Node.js 18.x or higher
- npm or yarn package manager
- GitLab instance with API access

### Installation Steps

```bash
# Install globally
npm install -g @modelcontextprotocol/server-gitlab

# Or install locally
npm install @modelcontextprotocol/server-gitlab

# Configure and run
export GITLAB_URL=https://gitlab.example.com
export GITLAB_TOKEN=your-token-here
mcp-server-gitlab
```

## Kubernetes Deployment

### Helm Chart Installation

```bash
# Add the repository
helm repo add mcp-gitlab https://charts.example.com/mcp-gitlab
helm repo update

# Install
helm install mcp-gitlab mcp-gitlab/mcp-gitlab-server \
  --set gitlab.url=https://gitlab.example.com \
  --set gitlab.token=your-token-here
```

### Manual Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mcp-gitlab
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mcp-gitlab
  template:
    metadata:
      labels:
        app: mcp-gitlab
    spec:
      containers:
      - name: mcp-gitlab
        image: iwakitakuma/gitlab-mcp:latest
        ports:
        - containerPort: 3000
        env:
        - name: GITLAB_URL
          value: "https://gitlab.example.com"
        - name: GITLAB_TOKEN
          valueFrom:
            secretKeyRef:
              name: gitlab-credentials
              key: token
```

## Cloud Platform Deployments

### AWS ECS

```json
{
  "family": "mcp-gitlab",
  "taskRoleArn": "arn:aws:iam::account:role/ecsTaskRole",
  "containerDefinitions": [
    {
      "name": "mcp-gitlab",
      "image": "iwakitakuma/gitlab-mcp:latest",
      "portMappings": [
        {
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "GITLAB_URL",
          "value": "https://gitlab.example.com"
        }
      ],
      "secrets": [
        {
          "name": "GITLAB_TOKEN",
          "valueFrom": "arn:aws:secretsmanager:region:account:secret:gitlab-token"
        }
      ]
    }
  ]
}
```

### Google Cloud Run

```bash
gcloud run deploy mcp-gitlab \
  --image=iwakitakuma/gitlab-mcp:latest \
  --platform=managed \
  --region=us-central1 \
  --set-env-vars="GITLAB_URL=https://gitlab.example.com" \
  --set-secrets="GITLAB_TOKEN=gitlab-token:latest"
```

### Azure Container Instances

```bash
az container create \
  --resource-group myResourceGroup \
  --name mcp-gitlab \
  --image iwakitakuma/gitlab-mcp:latest \
  --ports 3000 \
  --environment-variables GITLAB_URL=https://gitlab.example.com \
  --secure-environment-variables GITLAB_TOKEN=your-token-here
```

## Development Installation

### From Source

```bash
# Clone the repository
git clone https://github.com/your-username/dev-mcp-gitlab.git
cd dev-mcp-gitlab

# Install dependencies
npm install

# Set up environment
cp .env.example .env
# Edit .env file

# Run in development mode
npm run dev
```

### Using Development Container

```bash
# With VS Code Dev Containers
code --install-extension ms-vscode-remote.remote-containers
# Open in container when prompted

# Or with Docker directly
docker build -t mcp-gitlab-dev -f Dockerfile.dev .
docker run -it --rm -v $(pwd):/workspace mcp-gitlab-dev
```

## Configuration Options

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `GITLAB_URL` | GitLab instance URL | - | ✅ |
| `GITLAB_TOKEN` | Personal access token | - | ✅ |
| `MCP_PORT` | Server listening port | 3000 | ❌ |
| `LOG_LEVEL` | Logging level | info | ❌ |
| `REDIS_URL` | Redis connection string | - | ❌ |
| `DATABASE_URL` | Database connection | sqlite:memory | ❌ |

### Configuration File

Create `config.yml`:

```yaml
gitlab:
  url: https://gitlab.example.com
  token: your-token-here
  
server:
  port: 3000
  host: 0.0.0.0
  
logging:
  level: info
  format: json
  
features:
  caching: true
  webhooks: true
  analytics: false
```

## Verification

### Health Check

```bash
# Check server status
curl http://localhost:3000/health

# Expected response
{
  "status": "healthy",
  "version": "1.0.0",
  "gitlab": {
    "connected": true,
    "version": "16.5.0"
  }
}
```

### MCP Protocol Test

```bash
# Test MCP connection
echo '{"jsonrpc":"2.0","id":1,"method":"ping","params":{}}' | \
  curl -X POST -H "Content-Type: application/json" \
  -d @- http://localhost:3000/mcp
```

## Troubleshooting

### Common Issues

1. **Connection Refused**
   - Check if GitLab URL is accessible
   - Verify network connectivity
   - Confirm firewall settings

2. **Authentication Failed**
   - Validate GitLab token permissions
   - Check token expiration
   - Verify user access rights

3. **Permission Denied**
   - Ensure token has required scopes
   - Check project-level permissions
   - Verify group membership

### Logs and Debugging

```bash
# View container logs
docker logs gitlab-mcp

# Enable debug logging
export LOG_LEVEL=debug

# Check system resources
docker stats gitlab-mcp
```

## Next Steps

- [MCP Integration](mcp-integration.md)
- [IDE Configuration](ide-config.md)
- [Troubleshooting](troubleshooting.md)
