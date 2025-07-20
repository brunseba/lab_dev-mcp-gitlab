# MCP Server Integration Guide

## 🎯 Overview

This guide provides comprehensive instructions for integrating the GitLab MCP server with various AI development tools and IDEs, enabling seamless AI-powered GitLab workflows.

## 🚀 Supported AI Tools

### Claude Desktop App
The Claude Desktop app provides native MCP server support for direct GitLab integration.

#### Configuration
Create or update your Claude Desktop configuration file:

**Location**: 
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "GitLab communication server": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "glpat-xxxxxxxxxxxxxxxxxxxx",
        "GITLAB_API_URL": "https://gitlab.com/api/v4",
        "GITLAB_READ_ONLY_MODE": "false",
        "USE_GITLAB_WIKI": "true",
        "USE_MILESTONE": "true",
        "USE_PIPELINE": "true"
      }
    }
  }
}
```

### VSCode with Cline Extension
Cline (formerly Claude Dev) provides MCP integration within VSCode.

#### Setup Steps
1. Install the Cline extension from VSCode marketplace
2. Create `.vscode/mcp.json` in your project root:

```json
{
  "inputs": [
    {
      "type": "promptString",
      "id": "gitlab-token",
      "description": "GitLab Token to read API",
      "password": true
    }
  ],
  "servers": {
    "GitLab-MCP": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "${input:gitlab-token}",
        "GITLAB_API_URL": "https://gitlab.example.com/api/v4",
        "GITLAB_READ_ONLY_MODE": "false",
        "USE_GITLAB_WIKI": "true",
        "USE_MILESTONE": "false",
        "USE_PIPELINE": "true"
      }
    }
  }
}
```

3. Restart VSCode and Cline will prompt for your GitLab token

### Cursor IDE
Cursor provides built-in MCP support similar to VSCode.

#### Configuration
1. Open Cursor IDE
2. Create `.cursor/mcp.json` in your project:

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "your_gitlab_token",
        "GITLAB_API_URL": "https://gitlab.com/api/v4",
        "GITLAB_READ_ONLY_MODE": "false"
      }
    }
  }
}
```

### Roo Code
Roo Code supports MCP integration through configuration files.

```json
{
  "mcp": {
    "servers": {
      "gitlab": {
        "command": "npx",
        "args": ["-y", "@zereight/mcp-gitlab"],
        "env": {
          "GITLAB_PERSONAL_ACCESS_TOKEN": "your_token_here",
          "GITLAB_API_URL": "https://gitlab.com/api/v4"
        }
      }
    }
  }
}
```

## 🔧 Advanced Integration Modes

### Server-Sent Events (SSE)
For real-time updates and event streaming:

```bash
# Start MCP server in SSE mode
docker run -d \
  --name gitlab-mcp-sse \
  -e GITLAB_PERSONAL_ACCESS_TOKEN=your_token \
  -e GITLAB_API_URL="https://gitlab.com/api/v4" \
  -e SSE=true \
  -p 3333:3002 \
  iwakitakuma/gitlab-mcp
```

Client configuration:
```json
{
  "mcpServers": {
    "GitLab communication server": {
      "type": "sse",
      "url": "http://localhost:3333/sse"
    }
  }
}
```

### HTTP Mode
For RESTful API integration:

```bash
# Start MCP server in HTTP mode
docker run -d \
  --name gitlab-mcp-http \
  -e GITLAB_PERSONAL_ACCESS_TOKEN=your_token \
  -e STREAMABLE_HTTP=true \
  -p 3334:3002 \
  iwakitakuma/gitlab-mcp
```

Client configuration:
```json
{
  "mcpServers": {
    "GitLab communication server": {
      "url": "http://localhost:3334/mcp"
    }
  }
}
```

## 🐳 Docker Integration

### Standalone Container
Run the MCP server as a standalone Docker container:

```bash
docker run -i --rm \
  -e GITLAB_PERSONAL_ACCESS_TOKEN=your_token \
  -e GITLAB_API_URL="https://gitlab.com/api/v4" \
  -e GITLAB_READ_ONLY_MODE=false \
  -e USE_GITLAB_WIKI=true \
  -e USE_MILESTONE=true \
  -e USE_PIPELINE=true \
  iwakitakuma/gitlab-mcp
```

### Docker Compose Integration
Our provided `docker-compose.yml` includes the MCP server:

```yaml
mcp-server:
  image: iwakitakuma/gitlab-mcp:latest
  container_name: mcp-server
  ports:
    - "${MCP_SERVER_PORT:-3002}:3002"
  environment:
    GITLAB_PERSONAL_ACCESS_TOKEN: ${GITLAB_TOKEN}
    GITLAB_API_URL: ${GITLAB_API_URL:-http://gitlab/api/v4}
    GITLAB_READ_ONLY_MODE: ${GITLAB_READ_ONLY_MODE:-false}
    USE_GITLAB_WIKI: ${USE_GITLAB_WIKI:-true}
    USE_MILESTONE: ${USE_MILESTONE:-true}
    USE_PIPELINE: ${USE_PIPELINE:-true}
```

## 🔐 Security Configuration

### Token Scopes
Ensure your GitLab Personal Access Token has appropriate scopes:

#### Read-Only Mode
```
read_api
read_repository
read_user
```

#### Full Access Mode
```
api
read_repository
write_repository
read_user
```

### Environment Variables Security

#### Development
```bash
# .env file
GITLAB_TOKEN=glpat-xxxxxxxxxxxxxxxxxxxx
GITLAB_API_URL=https://gitlab.com/api/v4
GITLAB_READ_ONLY_MODE=false
```

#### Production
```bash
# Use environment variables or secret management
export GITLAB_PERSONAL_ACCESS_TOKEN=$(vault kv get -field=token secret/gitlab)
export GITLAB_API_URL=https://gitlab.company.com/api/v4
export GITLAB_READ_ONLY_MODE=true
```

## 📊 Feature Configuration

### Wiki Integration
Enable GitLab wiki access:
```bash
USE_GITLAB_WIKI=true
```

**Capabilities**:
- Read wiki pages
- Create new wiki pages
- Update existing content
- Manage wiki attachments

### Milestone Management
Enable milestone functionality:
```bash
USE_MILESTONE=true
```

**Capabilities**:
- List project milestones
- Create milestones
- Update milestone details
- Track milestone progress

### Pipeline Operations
Enable CI/CD pipeline integration:
```bash
USE_PIPELINE=true
```

**Capabilities**:
- Monitor pipeline status
- Trigger pipeline runs
- Access job logs
- Manage pipeline variables

## 🛠️ Troubleshooting

### Common Issues

#### Authentication Errors
```bash
# Check token validity
curl -H "PRIVATE-TOKEN: your_token" \
     https://gitlab.com/api/v4/user

# Verify token scopes in GitLab settings
```

#### Connection Issues
```bash
# Test API connectivity
curl -v https://gitlab.com/api/v4/projects

# Check network/firewall settings
telnet gitlab.com 443
```

#### Permission Errors
- Verify token has required scopes
- Check project access permissions
- Ensure user has appropriate GitLab role

### Debug Mode
Enable debug logging:
```bash
DEBUG=* npx @zereight/mcp-gitlab
```

### Health Checks
Monitor MCP server health:
```bash
# For HTTP mode
curl http://localhost:3002/health

# For Docker container
docker logs mcp-server
```

## 📚 API Capabilities

### Project Operations
- List projects
- Get project details
- Access repository files
- Manage project settings

### Issue Management
- Create issues
- Update issue descriptions
- Add comments
- Manage labels and assignees

### Merge Request Workflow
- Create merge requests
- Review code changes
- Add review comments
- Manage approvals

### Repository Operations
- Browse file tree
- Read file content
- View commit history
- Manage branches

## 🔄 Workflow Examples

### AI-Assisted Code Review
```python
# AI can now:
# 1. Fetch merge request details
# 2. Analyze code changes
# 3. Add review comments
# 4. Suggest improvements
# 5. Approve or request changes
```

### Automated Issue Triage
```python
# AI can now:
# 1. Read new issues
# 2. Categorize by type
# 3. Assign appropriate labels
# 4. Set priority levels
# 5. Assign to team members
```

### Documentation Generation
```python
# AI can now:
# 1. Scan repository structure
# 2. Analyze code patterns
# 3. Generate wiki pages
# 4. Update README files
# 5. Create API documentation
```

## 🔗 Next Steps

1. **[Prerequisites Setup](../prerequisites.md)**: Ensure all requirements are met
2. **[Docker Deployment](docker-compose.md)**: Deploy the complete environment
3. **[IDE Configuration](ide-config.md)**: Configure your development environment
4. **[Use Cases](../use-cases/use-cases.md)**: Explore practical applications
