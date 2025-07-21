# GitLab Omnibus Docker Compose Setup

This is a simplified Docker Compose setup using GitLab Omnibus all-in-one container. This setup includes PostgreSQL, Redis, and all GitLab components in a single container.

## Features

- **GitLab CE**: Full GitLab Community Edition with all features
- **Built-in Database**: PostgreSQL included in Omnibus
- **Built-in Cache**: Redis included in Omnibus
- **Container Registry**: Enabled by default on port 5050
- **GitLab Pages**: Enabled for static site hosting
- **MCP Server**: GitLab MCP integration server
- **GitLab Runner**: Optional CI/CD runner (profile-based)
- **Profile Management**: Organized service groups
- **Log Management**: Configured log rotation and size limits

## Quick Start

1. **Copy environment file:**
   ```bash
   cp .env.omnibus .env
   ```

2. **Update configuration:**
   Edit `.env` file with your specific settings, especially:
   - `GITLAB_ROOT_PASSWORD`: Set a strong password
   - `GITLAB_TOKEN`: Your GitLab personal access token (generate after setup)

3. **Start GitLab:**
   ```bash
   docker-compose -f docker-compose-omnibus.yml up -d
   ```

4. **Wait for GitLab to start** (this can take 5-10 minutes):
   ```bash
   docker-compose -f docker-compose-omnibus.yml logs -f gitlab
   ```

5. **Access GitLab:**
   - Web Interface: http://localhost
   - Registry: http://localhost:5050
   - SSH: ssh://git@localhost:22

## Profile Usage

Use profiles to start only specific components:

### Default Profile (GitLab + MCP Server)
```bash
docker-compose -f docker-compose-omnibus.yml up -d
```

### GitLab Only
```bash
docker-compose -f docker-compose-omnibus.yml --profile gitlab up -d
```

### MCP Server Only
```bash
docker-compose -f docker-compose-omnibus.yml --profile mcp up -d
```

### With GitLab Runner (CI/CD)
```bash
docker-compose -f docker-compose-omnibus.yml --profile ci up -d
```

## Initial Setup

1. **Login to GitLab:**
   - Username: `root`
   - Password: Value from `GITLAB_ROOT_PASSWORD` environment variable

2. **Create Personal Access Token:**
   - Go to User Settings > Access Tokens
   - Create token with `api` scope
   - Update `GITLAB_TOKEN` in `.env` file

3. **Restart MCP Server:**
   ```bash
   docker-compose -f docker-compose-omnibus.yml restart mcp-server
   ```

## GitLab Runner Setup (Optional)

If you started with the `runner` or `ci` profile:

1. **Get registration token:**
   - Go to GitLab Admin Area > Runners
   - Copy the registration token

2. **Register runner:**
   ```bash
   docker-compose -f docker-compose-omnibus.yml exec gitlab-runner gitlab-runner register
   ```

## Data Persistence

Data is stored in local volumes under `./volumes/gitlab/`:
- `config/`: GitLab configuration files
- `logs/`: Application logs
- `data/`: Application data (repositories, database, etc.)

## Performance Optimizations

The configuration includes several optimizations for development use:
- Reduced worker processes
- Disabled monitoring components (Prometheus, Grafana, etc.)
- Optimized PostgreSQL settings
- Configured shared memory

## Backup

Create a backup:
```bash
docker-compose -f docker-compose-omnibus.yml exec gitlab gitlab-backup create
```

Backups are stored in `./volumes/gitlab/data/backups/`

## Troubleshooting

### Check GitLab Status
```bash
docker-compose -f docker-compose-omnibus.yml exec gitlab gitlab-ctl status
```

### View GitLab Logs
```bash
docker-compose -f docker-compose-omnibus.yml logs gitlab
```

### Reconfigure GitLab
```bash
docker-compose -f docker-compose-omnibus.yml exec gitlab gitlab-ctl reconfigure
```

### Reset GitLab
```bash
docker-compose -f docker-compose-omnibus.yml down -v
rm -rf volumes/gitlab/*
docker-compose -f docker-compose-omnibus.yml up -d
```

## Monitoring Logs

View logs from all services:
```bash
docker-compose -f docker-compose-omnibus.yml logs -f
```

View specific service logs:
```bash
docker-compose -f docker-compose-omnibus.yml logs -f gitlab
docker-compose -f docker-compose-omnibus.yml logs -f mcp-server
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `GITLAB_ROOT_PASSWORD` | `changeme123` | Initial root password |
| `GITLAB_TOKEN` | - | Personal access token |
| `GITLAB_API_URL` | `http://gitlab/api/v4` | GitLab API endpoint |
| `GITLAB_PROJECT_ID` | - | Default project ID for MCP |
| `MCP_SERVER_PORT` | `3002` | MCP server port |
| `NODE_ENV` | `production` | Node.js environment |

## Ports

| Port | Service | Description |
|------|---------|-------------|
| 80 | GitLab | Web interface |
| 443 | GitLab | HTTPS (if configured) |
| 22 | GitLab | SSH Git access |
| 5050 | Registry | Container registry |
| 3002 | MCP Server | MCP API endpoint |

## Resource Requirements

**Minimum:**
- RAM: 4GB
- CPU: 2 cores
- Disk: 10GB

**Recommended:**
- RAM: 8GB
- CPU: 4 cores
- Disk: 50GB SSD

## Differences from Multi-Container Setup

This simplified setup:
- ✅ Single GitLab container (easier management)
- ✅ Built-in PostgreSQL and Redis
- ✅ Faster startup and less resource usage
- ✅ Simplified networking
- ❌ Less flexibility for scaling individual components
- ❌ Cannot use external database/cache easily

Choose this setup for:
- Development environments
- Small teams
- Simple deployments
- Learning and testing
