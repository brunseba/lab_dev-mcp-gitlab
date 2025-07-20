# IDE Configuration

## Overview

Configuring your IDE is a crucial step for full utilization of the AI and GitLab development environment.

## Pre-requisites

- Install the necessary extensions for VSCode or Codium
- Ensure Docker and Docker Compose are running

## Extension Installation

### VSCode Extensions

1. **Docker**
   - Go to Extensions view (Ctrl+Shift+X)
   - Search for "Docker" and install

2. **Remote Development**
   - Search for "Remote Development" and install

3. **GitLab Workflow**
   - Search for "GitLab Workflow" and install

### Codium Extensions

- Follow similar steps as VSCode for Codium-extension installation.

## Configuring Settings

### VSCode

Incorporate your MCP server settings:

1. Open settings (Ctrl+,)
2. Search for "MCP Server Configuration"
3. Add the following:
   ```json
   "mcp.server": "http://localhost:3000",
   "gitlab.accessToken": "your-access-token-here"
   ```

### Codium

- Follow similar setup as VSCode settings configuration.

## Connecting IDE to GitLab

### GitLab Extension Configuration

- Go to the GitLab section in your IDE
- Enter GitLab URL: `http://localhost:8080`
- Enter your access token

## Troubleshooting

### Common Issues

- Verify that the Docker services are running
- Confirm the MCP server is accessible
- Check settings for correct configuration

### Useful Commands

- **Restart Docker**
  ```bash
  systemctl restart docker
  ```

- **Verify MCP Connection**
  ```bash
  curl http://localhost:3000/health
  ```

## Next Steps

1. Utilize AI features in your development workflow.
2. Explore GitLab advanced configurations and integrations.
