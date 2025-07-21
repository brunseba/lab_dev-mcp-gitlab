# GitLab API Usage

This document outlines the usage of the GitLab API within the MCP-GitLab integration, providing developers with detailed guidance on interacting programmatically with GitLab resources.

## Authentication

### Personal Access Tokens

To interact with the GitLab API, you'll need to use a personal access token with the appropriate scopes.

**Token Scopes:**
- `api`: Full access to the API
- `read_user`: Read user information
- `read_repository`: Read repository contents

**Creating a Token:**
1. Navigate to `GitLab > User Settings > Access Tokens`.
2. Enter a name and select the scopes needed for your integration.
3. Create and store the token securely.

```bash
# Example request using curl
curl --header "PRIVATE-TOKEN: your_token_here" https://gitlab.example.com/api/v4/projects
```

## Common API Endpoints

### Project Endpoints

- **List all projects:**
  ```http
  GET /api/v4/projects
  ```

- **Get single project:**
  ```http
  GET /api/v4/projects/:id
  ```

- **Create new project:**
  ```http
  POST /api/v4/projects
  Content-Type: application/json

  {
    "name": "New Project",
    "visibility": "private"
  }
  ```

### Issue Endpoints

- **List project issues:**
  ```http
  GET /api/v4/projects/:id/issues
  ```

- **Create a new issue:**
  ```http
  POST /api/v4/projects/:id/issues
  Content-Type: application/json

  {
    "title": "New Issue",
    "description": "Issue description",
    "labels": "bug,urgent"
  }
  ```

### Merge Request Endpoints

- **List merge requests:**
  ```http
  GET /api/v4/projects/:id/merge_requests
  ```

- **Create a merge request:**
  ```http
  POST /api/v4/projects/:id/merge_requests
  Content-Type: application/json

  {
    "source_branch": "feature-branch",
    "target_branch": "main",
    "title": "Feature: New functionality"
  }
  ```

## Pagination

GitLab APIs support pagination through query parameters:
- `page`: Page number
- `per_page`: Number of items per page

```bash
# Example: List projects paginated
curl --header "PRIVATE-TOKEN: your_token_here" "https://gitlab.example.com/api/v4/projects?page=2&per_page=10"
```

## Error Handling

API Errors will return an appropriate HTTP status code with a message:

| Status Code | Description |
|-------------|-------------|
| 400 | Bad request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not found |
| 500 | Server error |

## Ratelimiting

GitLab enforces rate limits on API requests per user or token:
- **Rate**: Default to 600 requests per minute
- **Burst**: Short bursts may exceed these rates

Ratelimit headers provide current consumption insight:
```http
X-RateLimit-Limit: 600
X-RateLimit-Remaining: 550
X-RateLimit-Reset: 1633036800
```

Handle rate limits using retries with exponential backoff:

```javascript
async function requestWithBackoff(requestFunction, retries = 3) {
  for (let i = 0; i <= retries; i++) {
    try {
      return await requestFunction();
    } catch (err) {
      if (err.response && err.response.status === 429 && i < retries) {
        const backoffTime = Math.pow(2, i) * 1000;
        await new Promise(res => setTimeout(res, backoffTime));
      } else {
        throw err;
      }
    }
  }
}
```

## Advanced Usage

### Webhooks

Set up project webhooks to automate workflows:
- Trigger on events like push, merge, issues
- Configure through GitLab UI or API

```bash
# Set up webhook via API
curl --request POST --header "PRIVATE-TOKEN: your_token_here" \
--url "https://gitlab.example.com/api/v4/projects/:id/hooks" \
--data "url=https://yourserver.com/webhook&push_events=true"
```

### CI/CD Pipelines

GitLab provides robust CI/CD capabilities through its pipelines feature:

- **Trigger pipelines**: Define in `.gitlab-ci.yml`
- **Monitor pipeline status**
- **Integrate with external tools**

```yaml
# Example .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

build_job:
  stage: build
  script:
    - echo "Building..."

test_job:
  stage: test
  script:
    - echo "Running tests..."

deploy_job:
  stage: deploy
  script:
    - echo "Deploying..."
```

## Security Best Practices

- **Use minimal scopes** for access tokens
- **Rotate tokens regularly** to minimize risk
- **Secure webhook endpoints** with secret tokens
- **Monitor API usage** and adjust limits as necessary

## Conclusion

Using the GitLab API within MCP-GitLab provides automation and integration power to streamline your development and operations workflows. Follow security best practices and leverage advanced features to maximize efficiency and security.

## Resources

- [GitLab API Documentation](https://docs.gitlab.com/ee/api/)
- [GitLab Webhooks Overview](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html)
- [GitLab CI/CD Pipelines](https://docs.gitlab.com/ee/ci/pipelines/)
