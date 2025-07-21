# MCP Protocol Reference

This document provides a comprehensive reference for the Model Context Protocol (MCP) implementation in the GitLab integration.

## Protocol Overview

The Model Context Protocol (MCP) is a JSON-RPC based protocol that enables AI assistants to interact with external tools and data sources. Our GitLab implementation provides a set of standardized tools for GitLab operations.

### Protocol Specifications

- **Transport**: HTTP/HTTPS
- **Message Format**: JSON-RPC 2.0
- **Authentication**: Bearer tokens
- **Content-Type**: `application/json`

## Base Request Format

All MCP requests follow the JSON-RPC 2.0 specification:

```json
{
  "jsonrpc": "2.0",
  "method": "method_name",
  "params": {
    "parameter": "value"
  },
  "id": 1
}
```

## Available Tools

### Project Management

#### `list_projects`

List all accessible GitLab projects.

**Parameters:**
```json
{
  "visibility": "public|private|internal",
  "owned": true,
  "starred": false,
  "page": 1,
  "per_page": 20
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "result": {
    "projects": [
      {
        "id": 123,
        "name": "My Project",
        "path": "my-project",
        "namespace": "username",
        "visibility": "private",
        "web_url": "https://gitlab.example.com/username/my-project"
      }
    ],
    "total_count": 1
  },
  "id": 1
}
```

#### `get_project`

Get detailed information about a specific project.

**Parameters:**
```json
{
  "project_id": 123
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "result": {
    "id": 123,
    "name": "My Project",
    "description": "Project description",
    "default_branch": "main",
    "created_at": "2024-01-01T00:00:00Z",
    "last_activity_at": "2024-01-15T12:00:00Z",
    "statistics": {
      "commit_count": 150,
      "storage_size": 1024000
    }
  },
  "id": 1
}
```

### Issue Management

#### `list_issues`

List issues for a project.

**Parameters:**
```json
{
  "project_id": 123,
  "state": "opened|closed|all",
  "labels": ["bug", "feature"],
  "assignee_id": 456,
  "page": 1,
  "per_page": 20
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "result": {
    "issues": [
      {
        "id": 789,
        "iid": 1,
        "title": "Issue title",
        "description": "Issue description",
        "state": "opened",
        "created_at": "2024-01-01T00:00:00Z",
        "assignee": {
          "id": 456,
          "name": "John Doe",
          "username": "johndoe"
        }
      }
    ],
    "total_count": 1
  },
  "id": 1
}
```

#### `create_issue`

Create a new issue.

**Parameters:**
```json
{
  "project_id": 123,
  "title": "New issue title",
  "description": "Issue description",
  "assignee_id": 456,
  "labels": ["bug", "priority-high"]
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "result": {
    "id": 790,
    "iid": 2,
    "title": "New issue title",
    "web_url": "https://gitlab.example.com/username/my-project/-/issues/2"
  },
  "id": 1
}
```

### Merge Request Operations

#### `list_merge_requests`

List merge requests for a project.

**Parameters:**
```json
{
  "project_id": 123,
  "state": "opened|closed|merged|all",
  "target_branch": "main",
  "source_branch": "feature-branch",
  "page": 1,
  "per_page": 20
}
```

#### `create_merge_request`

Create a new merge request.

**Parameters:**
```json
{
  "project_id": 123,
  "title": "Merge request title",
  "description": "MR description",
  "source_branch": "feature-branch",
  "target_branch": "main",
  "assignee_id": 456,
  "remove_source_branch": true
}
```

### Pipeline Operations

#### `list_pipelines`

List CI/CD pipelines for a project.

**Parameters:**
```json
{
  "project_id": 123,
  "status": "pending|running|success|failed|canceled|skipped",
  "ref": "main",
  "page": 1,
  "per_page": 20
}
```

#### `trigger_pipeline`

Trigger a new pipeline.

**Parameters:**
```json
{
  "project_id": 123,
  "ref": "main",
  "variables": {
    "CUSTOM_VAR": "value"
  }
}
```

### Repository Operations

#### `get_file_content`

Get the content of a file from the repository.

**Parameters:**
```json
{
  "project_id": 123,
  "file_path": "README.md",
  "ref": "main"
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "result": {
    "file_name": "README.md",
    "file_path": "README.md",
    "content": "base64_encoded_content",
    "encoding": "base64",
    "size": 1024,
    "last_commit": {
      "id": "abc123",
      "message": "Update README",
      "author_name": "John Doe"
    }
  },
  "id": 1
}
```

#### `list_repository_files`

List files in a repository directory.

**Parameters:**
```json
{
  "project_id": 123,
  "path": "src/",
  "ref": "main",
  "recursive": false
}
```

### Search Operations

#### `search_projects`

Search for projects by name or description.

**Parameters:**
```json
{
  "search": "search term",
  "visibility": "public|private|internal",
  "page": 1,
  "per_page": 20
}
```

#### `search_issues`

Search for issues across projects.

**Parameters:**
```json
{
  "search": "bug report",
  "project_id": 123,
  "state": "opened",
  "page": 1,
  "per_page": 20
}
```

## Error Handling

### Error Response Format

```json
{
  "jsonrpc": "2.0",
  "error": {
    "code": -32000,
    "message": "GitLab API Error",
    "data": {
      "status": 404,
      "message": "Project not found"
    }
  },
  "id": 1
}
```

### Standard Error Codes

| Code | Message | Description |
|------|---------|-------------|
| -32700 | Parse error | Invalid JSON |
| -32600 | Invalid Request | Invalid JSON-RPC |
| -32601 | Method not found | Unknown method |
| -32602 | Invalid params | Invalid parameters |
| -32603 | Internal error | Server error |
| -32000 | GitLab API Error | GitLab-specific error |

### GitLab API Error Mapping

| GitLab Status | MCP Error Code | Description |
|---------------|----------------|-------------|
| 400 | -32602 | Bad Request |
| 401 | -32000 | Unauthorized |
| 403 | -32000 | Forbidden |
| 404 | -32000 | Not Found |
| 429 | -32000 | Rate Limited |
| 500 | -32603 | Server Error |

## Authentication

### Bearer Token Authentication

All requests require a valid GitLab personal access token:

```http
POST /mcp HTTP/1.1
Host: localhost:3000
Content-Type: application/json
Authorization: Bearer glpat-xxxxxxxxxxxxxxxxxxxx

{
  "jsonrpc": "2.0",
  "method": "list_projects",
  "params": {},
  "id": 1
}
```

### Token Requirements

Required scopes for the personal access token:
- `api` - Full API access
- `read_user` - Read user information
- `read_repository` - Read repository data

Optional scopes:
- `write_repository` - Write repository data
- `read_registry` - Read container registry

## Rate Limiting

### Request Limits

- **Default**: 600 requests per minute per token
- **Burst**: 100 requests per minute
- **Window**: 1 minute rolling window

### Rate Limit Headers

Response headers indicate current rate limit status:

```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 600
X-RateLimit-Remaining: 599
X-RateLimit-Reset: 1640995200
```

### Handling Rate Limits

When rate limited, implement exponential backoff:

```javascript
async function makeRequest(request) {
  let retries = 0;
  const maxRetries = 3;
  
  while (retries < maxRetries) {
    try {
      return await request();
    } catch (error) {
      if (error.code === -32000 && error.data.status === 429) {
        const delay = Math.pow(2, retries) * 1000;
        await sleep(delay);
        retries++;
        continue;
      }
      throw error;
    }
  }
}
```

## Pagination

### Pagination Parameters

Most list methods support pagination:

```json
{
  "page": 1,
  "per_page": 20
}
```

### Pagination Response

Paginated responses include metadata:

```json
{
  "jsonrpc": "2.0",
  "result": {
    "data": [...],
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total": 100,
      "total_pages": 5,
      "has_next": true,
      "has_prev": false
    }
  },
  "id": 1
}
```

## Webhooks

### Webhook Configuration

Configure webhooks to receive real-time updates:

```json
{
  "jsonrpc": "2.0",
  "method": "configure_webhook",
  "params": {
    "project_id": 123,
    "url": "https://your-server.com/webhook",
    "events": ["push", "issues", "merge_requests"]
  },
  "id": 1
}
```

### Webhook Events

Supported webhook events:
- `push` - Code push events
- `issues` - Issue events
- `merge_requests` - Merge request events
- `pipelines` - Pipeline events
- `wiki` - Wiki page events

## Security

### Request Signing

For enhanced security, requests can be signed:

```javascript
const crypto = require('crypto');

function signRequest(payload, secret) {
  const hmac = crypto.createHmac('sha256', secret);
  hmac.update(payload);
  return hmac.digest('hex');
}

// Add signature header
headers['X-MCP-Signature'] = `sha256=${signRequest(body, secret)}`;
```

### IP Whitelisting

Configure allowed IP addresses for API access:

```yaml
security:
  ip_whitelist:
    - "192.168.1.0/24"
    - "10.0.0.0/8"
  blocked_ips:
    - "malicious.ip.address"
```

## Performance Optimization

### Caching

Enable response caching to improve performance:

```json
{
  "jsonrpc": "2.0",
  "method": "list_projects",
  "params": {
    "cache": true,
    "cache_ttl": 300
  },
  "id": 1
}
```

### Batch Requests

Send multiple requests in a single HTTP call:

```json
[
  {
    "jsonrpc": "2.0",
    "method": "list_projects",
    "params": {},
    "id": 1
  },
  {
    "jsonrpc": "2.0",
    "method": "list_issues",
    "params": {"project_id": 123},
    "id": 2
  }
]
```

## Client SDKs

### JavaScript/Node.js

```javascript
const McpGitlabClient = require('@mcp-gitlab/client');

const client = new McpGitlabClient({
  endpoint: 'http://localhost:3000/mcp',
  token: 'your-gitlab-token'
});

// List projects
const projects = await client.listProjects({
  visibility: 'private'
});

// Create issue
const issue = await client.createIssue({
  project_id: 123,
  title: 'New issue',
  description: 'Issue description'
});
```

### Python

```python
from mcp_gitlab import McpGitlabClient

client = McpGitlabClient(
    endpoint='http://localhost:3000/mcp',
    token='your-gitlab-token'
)

# List projects
projects = client.list_projects(visibility='private')

# Create issue
issue = client.create_issue(
    project_id=123,
    title='New issue',
    description='Issue description'
)
```

## Testing

### Unit Tests

Test individual MCP methods:

```javascript
describe('MCP Protocol', () => {
  it('should list projects', async () => {
    const response = await client.request({
      method: 'list_projects',
      params: {}
    });
    
    expect(response.result).toHaveProperty('projects');
    expect(Array.isArray(response.result.projects)).toBe(true);
  });
});
```

### Integration Tests

Test complete workflows:

```javascript
describe('Issue Workflow', () => {
  it('should create and retrieve issue', async () => {
    // Create issue
    const createResponse = await client.createIssue({
      project_id: 123,
      title: 'Test issue'
    });
    
    const issueId = createResponse.result.id;
    
    // Retrieve issue
    const getResponse = await client.getIssue({
      project_id: 123,
      issue_id: issueId
    });
    
    expect(getResponse.result.title).toBe('Test issue');
  });
});
```

## Resources

- [JSON-RPC 2.0 Specification](https://www.jsonrpc.org/specification)
- [GitLab API Documentation](https://docs.gitlab.com/ee/api/)
- [MCP Protocol Specification](https://spec.modelcontextprotocol.org/)
- [Client SDK Documentation](../implementation/sdk-usage.md)
