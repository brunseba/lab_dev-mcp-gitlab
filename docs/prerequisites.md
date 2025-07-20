# Prerequisites

## 🛠️ Required Tools

### Essential Components

#### IDE
- **VSCode** or **VSCodium**: Your primary development environment
  - Download VSCode: [https://code.visualstudio.com/](https://code.visualstudio.com/)
  - Download VSCodium: [https://vscodium.com/](https://vscodium.com/)

#### GitLab Engine
- **Latest GitLab version**: Self-hosted or GitLab.com account
  - For self-hosted: [GitLab Installation Guide](https://docs.gitlab.com/ee/install/)
  - For GitLab.com: Create account at [https://gitlab.com](https://gitlab.com)

#### MCP Server
- **GitLab MCP Server**: AI integration component
  - Repository: [https://github.com/zereight/gitlab-mcp](https://github.com/zereight/gitlab-mcp)
  - Clone the repository: `git clone https://github.com/zereight/gitlab-mcp.git`

#### Container Runtime
- **Docker Compose**: For local development environment
  - Install Docker Desktop: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
  - Verify installation: `docker-compose --version`

## 🔧 System Requirements

### Hardware Requirements
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: At least 10GB free space
- **CPU**: Multi-core processor recommended

### Operating System Support
- **Linux**: Ubuntu 20.04+, CentOS 8+, or equivalent
- **macOS**: macOS 11.0+ (Big Sur)
- **Windows**: Windows 10/11 with WSL2

## 🌐 Network Requirements

### Ports
- **Port 8080**: GitLab web interface
- **Port 2222**: GitLab SSH
- **Port 3000**: MCP Server (configurable)

### External Dependencies
- Internet access for downloading Docker images
- Access to GitLab repositories (if using GitLab.com)
- AI model API access (OpenAI, Anthropic, etc.)

## 🔑 Authentication

### GitLab Access Token
1. Navigate to GitLab → User Settings → Access Tokens
2. Create a new token with appropriate scopes:
   - `api`: Full API access
   - `read_repository`: Repository read access
   - `write_repository`: Repository write access

### MCP Configuration
- AI service API keys (OpenAI, Anthropic, etc.)
- GitLab instance URL and access token

## ✅ Verification Checklist

Before proceeding, ensure you have:

- [ ] VSCode or VSCodium installed
- [ ] Docker and Docker Compose installed
- [ ] GitLab access (self-hosted or GitLab.com)
- [ ] GitLab MCP server repository cloned
- [ ] Required ports available
- [ ] GitLab access token generated
- [ ] AI service API keys obtained

## 🚀 Next Steps

Once all prerequisites are met, proceed to the [Setup Guide](setup.md) to begin the installation process.
