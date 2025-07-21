# Enhanced Developer Experience with AI and GitLab Integration

This project aims to enhance the developer experience by integrating AI capabilities with GitLab using the Model Context Protocol (MCP). This integration allows developers to leverage AI-powered assistance directly within their workflow to increase productivity and automate routine tasks.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- VSCode or VSCodium IDE
- GitLab Personal Access Token

### Environment Setup
1. Copy the environment template:
   ```bash
   cp .env.example .env
   ```
   Add your GitLab credentials to the `.env` file:
   ```
   GITLAB_TOKEN=your-gitlab-token-here
   ```

### Start Services
Start the GitLab and MCP server:
```bash
docker-compose up -d
```
View real-time logs:
```bash
docker-compose logs -f
```

### Access Services
- **GitLab**: [http://localhost:8080](http://localhost:8080)
- **MCP Server**: [http://localhost:3002](http://localhost:3002)
- **Documentation**: Use `./scripts/serve-docs.sh`

## 📚 Documentation

### Serve Locally
To serve the documentation locally, run:
```bash
./scripts/serve-docs.sh
```
or directly with MkDocs using:
```bash
mkdocs serve
```

### Key Documentation
- **[Design Documentation](docs/design/)**: Explore system architecture and component design
- **[Use Cases](docs/use-cases/)**: Discover practical implementation scenarios
- **[Implementation Guides](docs/implementation/)**: Learn setup and configuration procedures

## 🐳 Docker Services

### GitLab MCP Server
- **Image**: `iwakitakuma/gitlab-mcp:latest`
- **Port**: 3002
- **Features**: Project management, issues, merge requests, pipelines, and wiki

### GitLab CE
- **Image**: `gitlab/gitlab-ce:latest`
- **Ports**: 8080 (HTTP), 2222 (SSH), 443 (HTTPS)
- **Features**: Complete instance, container registry, and pages

## 🔧 Configuration

### Environment Variables
| Variable               | Description                      | Default             |
|------------------------|----------------------------------|---------------------|
| `GITLAB_TOKEN`         | GitLab Personal Access Token     | Required            |
| `GITLAB_API_URL`       | GitLab API endpoint              | `http://gitlab/api/v4` |
| `GITLAB_READ_ONLY_MODE`| Restrict to read operations       | `false`             |
| `USE_GITLAB_WIKI`      | Enable wiki functionality        | `true`              |
| `USE_MILESTONE`        | Enable milestone management      | `true`              |
| `USE_PIPELINE`         | Enable pipeline operations       | `true`              |

### AI Tool Integration

#### Claude Desktop Setup
Configuration:
```json
{
  "mcpServers": {
    "GitLab communication server": {
      "command": "npx",
      "args": ["@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "your-token",
        "GITLAB_API_URL": "https://gitlab.com/api/v4"
      }
    }
  }
}
```

#### VSCode with Cline
Configuration:
```json
{
  "servers": {
    "GitLab-MCP": {
      "type": "stdio",
      "command": "npx",
      "args": ["@zereight/mcp-gitlab"],
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
│   ├── design/            # Architectural design
│   ├── use-cases/         # Use case documentation
│   └── implementation/    # Setup and configuration guides
├── nginx/                 # Nginx configurations
├── scripts/               # Utility scripts
├── docker-compose.yml     # Service orchestration file
├── mkdocs.yml            # MkDocs configuration
└── .env.example          # Environment template
```

### Management Scripts
- To start the documentation server, run `./scripts/serve-docs.sh`

### Docker Commands
```bash
# Start all services
docker-compose up -d

# View status
docker-compose ps

# Follow logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild services
docker-compose up -d --build
```

## 📊 Features

### GitLab Integration
- ✔️ Comprehensive project and repository management
- ✔️ Issue tracking and management
- ✔️ Merge request workflows
- ✔️ CI/CD pipeline operations
- ⚙️ Optional: Wiki management
- ⚙️ Optional: Milestone tracking

### AI Capabilities
- **Code Review**: AI-assisted merge request analysis
- **Issue Triage**: Automated categorization and assignment
- **Documentation**: Automated README and wiki generation
- **Code Suggestion**: AI-based code generation
- **Pipeline Optimization**: Performance improvements

### IDE Support
- **Claude Desktop**: Native MCP integration
- **VSCode + Cline**: Plugin-based integration
- **Cursor**: Built-in support
- **Roo Code**: Configuration-based setup

## 📈 Recommendation for Production MCP Server

### Key Criteria for Choosing an MCP Server
- **Performance**: Look for servers with high responsiveness, stability under load, and effective concurrency handling.
- **Scalability**: Ensure the MCP server supports horizontal and vertical scaling to handle increased workloads.
- **Monitoring and Optimization**: Include comprehensive monitoring tools and plan for ongoing performance tuning.

### Performance Insights
Refer to the [Performance Analysis](docs/analysis/performance-analysis.md) for detailed benchmarks and results:
- **Response Time**: Average 95ms for standard operations 
- **Throughput**: Sustained at 1,000+ requests per minute
- **Scalability**: Effective up to 10,000 concurrent users

For further exploration, see:
- **Enterprise Scenarios**: [Enterprise Use Cases](docs/use-cases/enterprise-scenarios.md)
- **Best Practices**: [Security and Performance Best Practices](docs/security/best-practices.md)

## 🔐 Security and Configuration

### Access Token Setup
1. Go to GitLab → User Settings → Access Tokens
2. Create a token with required scopes:
   - `api`: Full API access
   - `read_repository`: Repository read access
   - `write_repository` (optional): Write access

### Enabling Read-Only Mode
To improve security, activate read-only mode:
```bash
GITLAB_READ_ONLY_MODE=true
```

## 🚀 Use Cases

1. **AI-Assisted Code Review**: Automated quality analysis
2. **Intelligent Issue Management**: Smart categorization and assignment
3. **Automated Documentation**: Project documentation generation
4. **Pipeline Optimization**: CI/CD performance improvements
5. **Code Migration**: Framework upgrade assistance

## 📖 Documentation
Access the complete documentation:
- **Setup Guide**: [docs/implementation/setup.md]
- **Docker Configuration**: [docs/implementation/docker-compose.md]
- **MCP Integration**: [docs/implementation/mcp-integration.md]
- **Use Cases**: [docs/use-cases/use-cases.md]

## 🤝 Contributing
For contributing guidelines, see [Contributing Guide](docs/implementation/contributing.md).

## 📄 License

This project is licensed under the MIT License.

## 🔗 Links

- [GitLab MCP Server](https://github.com/zereight/gitlab-mcp)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
- [Docker Compose](https://docs.docker.com/compose/)

---

**Explore AI-enhanced GitLab development today!** 🚀
