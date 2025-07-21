# Enhanced Developer Experience with AI and GitLab

This project aims to enhance the developer experience by integrating AI capabilities with GitLab through the Model Context Protocol (MCP). By combining these technologies, developers can leverage AI-powered assistance directly within their development workflow.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- VSCode or VSCodium IDE
- GitLab Personal Access Token

### 1. Environment Setup
```bash
# Copy environment template
cp .env.example .env

# Edit with your GitLab credentials
# GITLAB_TOKEN=your-gitlab-token-here
```

### 2. Start Services
```bash
# Start GitLab and MCP server
docker-compose up -d

# View logs
docker-compose logs -f
```

### 3. Access Services
- **GitLab**: http://localhost:8080
- **MCP Server**: http://localhost:3002
- **Documentation**: `./scripts/serve-docs.sh`

## 📚 Documentation

### Serve Documentation Locally
```bash
# Start documentation server
./scripts/serve-docs.sh

# Or directly with MkDocs
mkdocs serve
```

### Documentation Structure
- **[Design](docs/design/)**: System architecture and component design
- **[Use Cases](docs/use-cases/)**: Practical implementation scenarios
- **[Implementation](docs/implementation/)**: Setup and configuration guides

## 🐳 Docker Services

### GitLab MCP Server
- **Image**: `iwakitakuma/gitlab-mcp:latest`
- **Port**: 3002
- **Features**: Project management, issue tracking, merge requests, wiki, pipelines

### GitLab CE
- **Image**: `gitlab/gitlab-ce:latest`
- **Ports**: 8080 (HTTP), 2222 (SSH), 443 (HTTPS)
- **Features**: Complete GitLab instance with container registry and pages

## 🔧 Configuration

### Environment Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `GITLAB_TOKEN` | GitLab Personal Access Token | Required |
| `GITLAB_API_URL` | GitLab API endpoint | `http://gitlab/api/v4` |
| `GITLAB_READ_ONLY_MODE` | Restrict to read operations | `false` |
| `USE_GITLAB_WIKI` | Enable wiki functionality | `true` |
| `USE_MILESTONE` | Enable milestone management | `true` |
| `USE_PIPELINE` | Enable pipeline operations | `true` |

### AI Tool Integration

#### Claude Desktop
```json
{
  "mcpServers": {
    "GitLab communication server": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "your-token",
        "GITLAB_API_URL": "https://gitlab.com/api/v4"
      }
    }
  }
}
```

#### VSCode with Cline
```json
{
  "servers": {
    "GitLab-MCP": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "your-token"
      }
    }
  }
}
```

## 🛠️ Development

### Directory Structure
```
.
├── docs/                   # MkDocs documentation
│   ├── design/            # Architecture and design docs
│   ├── use-cases/         # Use case documentation
│   └── implementation/    # Setup and config guides
├── nginx/                 # Nginx configuration
├── scripts/               # Utility scripts
├── docker-compose.yml     # Service orchestration
├── mkdocs.yml            # Documentation configuration
└── .env.example          # Environment template
```

### Scripts
- `./scripts/serve-docs.sh` - Start documentation server

### Docker Commands
```bash
# Start all services
docker-compose up -d

# View service status
docker-compose ps

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild services
docker-compose up -d --build
```

## 📊 Features

### GitLab Integration
- ✅ Project and repository management
- ✅ Issue tracking and management
- ✅ Merge request workflows
- ✅ CI/CD pipeline operations
- 🔄 Wiki management (optional)
- 🔄 Milestone tracking (optional)

### AI Capabilities
- **Code Review**: AI-assisted merge request reviews
- **Issue Triage**: Automated categorization and assignment
- **Documentation**: Automated README and wiki generation
- **Code Generation**: AI-powered code suggestions
- **Pipeline Optimization**: CI/CD performance improvements

### IDE Support
- **Claude Desktop**: Native MCP integration
- **VSCode + Cline**: Extension-based integration
- **Cursor**: Built-in MCP support
- **Roo Code**: Configuration-based setup

## 🔐 Security

### Access Token Setup
1. Navigate to GitLab → User Settings → Access Tokens
2. Create token with scopes:
   - `api`: Full API access
   - `read_repository`: Repository read access
   - `write_repository`: Repository write access (optional)

### Read-Only Mode
For enhanced security, enable read-only mode:
```bash
GITLAB_READ_ONLY_MODE=true
```

## 🚀 Use Cases

1. **AI-Assisted Code Review**: Automated code quality analysis
2. **Intelligent Issue Management**: Smart categorization and assignment
3. **Documentation Generation**: Automated project documentation
4. **Pipeline Optimization**: CI/CD performance improvements
5. **Code Migration**: AI-assisted framework upgrades

## 📖 Documentation

For detailed documentation, visit:
- **Setup Guide**: [docs/implementation/setup.md](docs/implementation/setup.md)
- **Docker Configuration**: [docs/implementation/docker-compose.md](docs/implementation/docker-compose.md)
- **MCP Integration**: [docs/implementation/mcp-integration.md](docs/implementation/mcp-integration.md)
- **Use Cases**: [docs/use-cases/use-cases.md](docs/use-cases/use-cases.md)

## 🤝 Contributing

See [Contributing Guide](docs/implementation/contributing.md) for development setup and contribution guidelines.

## 📄 License

This project is licensed under the MIT License.

## 🔗 Links

- [GitLab MCP Server](https://github.com/zereight/gitlab-mcp)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
- [Docker Compose](https://docs.docker.com/compose/)

---

**Start exploring AI-enhanced GitLab development today!** 🚀
