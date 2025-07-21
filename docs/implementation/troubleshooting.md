# Troubleshooting Guide

This comprehensive troubleshooting guide helps resolve common issues with the MCP-GitLab integration.

## Quick Reference

| Issue Category | Quick Fix | Detailed Section |
|----------------|-----------|------------------|
| Connection Issues | Check network/credentials | [Connection Problems](#connection-problems) |
| Authentication Errors | Verify tokens/permissions | [Authentication Issues](#authentication-issues) |
| Performance Problems | Check resource usage | [Performance Issues](#performance-issues) |
| API Errors | Validate request format | [API Troubleshooting](#api-troubleshooting) |

## Connection Problems

### GitLab Connection Failed

**Symptoms:**
- Cannot connect to GitLab instance
- Timeout errors
- Connection refused messages

**Diagnosis:**
```bash
# Test GitLab connectivity
curl -I https://your-gitlab-instance.com

# Check DNS resolution
nslookup your-gitlab-instance.com

# Test API endpoint
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://your-gitlab-instance.com/api/v4/user
```

**Solutions:**

1. **Network Issues**
   ```bash
   # Check firewall rules
   sudo iptables -L
   
   # Test specific ports
   telnet your-gitlab-instance.com 443
   ```

2. **SSL/TLS Issues**
   ```bash
   # Test SSL certificate
   openssl s_client -connect your-gitlab-instance.com:443
   
   # Disable SSL verification (temporary)
   export NODE_TLS_REJECT_UNAUTHORIZED=0
   ```

3. **Proxy Configuration**
   ```bash
   # Set proxy environment variables
   export HTTP_PROXY=http://proxy.company.com:8080
   export HTTPS_PROXY=http://proxy.company.com:8080
   ```

### MCP Server Won't Start

**Symptoms:**
- Server fails to start
- Port binding errors
- Module loading failures

**Diagnosis:**
```bash
# Check port availability
netstat -tlnp | grep 3000

# Verify dependencies
npm list

# Check Node.js version
node --version
```

**Solutions:**

1. **Port Conflicts**
   ```bash
   # Find process using port
   lsof -i :3000
   
   # Kill conflicting process
   kill -9 PID
   
   # Use different port
   export MCP_PORT=3001
   ```

2. **Missing Dependencies**
   ```bash
   # Reinstall dependencies
   rm -rf node_modules package-lock.json
   npm install
   ```

3. **Permission Issues**
   ```bash
   # Fix ownership
   sudo chown -R $USER:$USER .
   
   # Set executable permissions
   chmod +x scripts/start.sh
   ```

## Authentication Issues

### Invalid Token Errors

**Symptoms:**
- 401 Unauthorized responses
- Token validation failures
- Access denied messages

**Diagnosis:**
```bash
# Test token validity
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://your-gitlab-instance.com/api/v4/user

# Check token permissions
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://your-gitlab-instance.com/api/v4/personal_access_tokens
```

**Solutions:**

1. **Token Expired**
   - Generate new personal access token in GitLab
   - Update environment variables
   - Restart MCP server

2. **Insufficient Permissions**
   ```bash
   # Required scopes for token:
   # - api
   # - read_user
   # - read_repository
   # - write_repository (if needed)
   ```

3. **Token Format Issues**
   ```bash
   # Verify token format (no spaces/newlines)
   echo -n "$GITLAB_TOKEN" | wc -c
   ```

### OAuth Authentication Problems

**Symptoms:**
- OAuth flow failures
- Redirect URI mismatches
- Invalid client credentials

**Solutions:**

1. **Application Configuration**
   ```yaml
   # config.yml
   oauth:
     client_id: your-client-id
     client_secret: your-client-secret
     redirect_uri: http://localhost:3000/auth/callback
   ```

2. **Redirect URI Configuration**
   - Ensure redirect URI matches exactly in GitLab application settings
   - Check for trailing slashes
   - Verify protocol (http vs https)

## Performance Issues

### Slow Response Times

**Symptoms:**
- API calls take longer than expected
- Timeout errors
- High resource usage

**Diagnosis:**
```bash
# Monitor resource usage
top -p $(pgrep node)

# Check memory usage
free -h

# Monitor network latency
ping -c 10 your-gitlab-instance.com

# Profile API calls
curl -w "@curl-format.txt" -o /dev/null -s \
     "http://localhost:3000/mcp/projects"
```

**Solutions:**

1. **Enable Caching**
   ```yaml
   # config.yml
   cache:
     enabled: true
     ttl: 300
     max_entries: 1000
   ```

2. **Optimize Database Queries**
   ```sql
   -- Add indexes for frequently queried fields
   CREATE INDEX idx_projects_updated_at ON projects(updated_at);
   CREATE INDEX idx_issues_state ON issues(state);
   ```

3. **Increase Resource Limits**
   ```bash
   # Increase Node.js memory limit
   export NODE_OPTIONS="--max-old-space-size=4096"
   
   # Adjust container resources
   docker run --memory=2g --cpus=2 ...
   ```

### Memory Leaks

**Symptoms:**
- Gradually increasing memory usage
- Out of memory errors
- Server crashes

**Diagnosis:**
```bash
# Monitor memory over time
while true; do
  ps -o pid,vsz,rss,comm -p $(pgrep node)
  sleep 30
done

# Generate heap dump
node --inspect server.js
```

**Solutions:**

1. **Update Dependencies**
   ```bash
   npm audit fix
   npm update
   ```

2. **Profile Memory Usage**
   ```javascript
   // Add memory monitoring
   setInterval(() => {
     const usage = process.memoryUsage();
     console.log('Memory usage:', usage);
   }, 60000);
   ```

3. **Implement Connection Pooling**
   ```javascript
   // Database connection pool
   const pool = new Pool({
     max: 10,
     idleTimeoutMillis: 30000,
     connectionTimeoutMillis: 2000,
   });
   ```

## API Troubleshooting

### GitLab API Errors

**Common Error Codes:**

| Code | Meaning | Solution |
|------|---------|----------|
| 400 | Bad Request | Validate request format |
| 401 | Unauthorized | Check authentication |
| 403 | Forbidden | Verify permissions |
| 404 | Not Found | Check resource existence |
| 429 | Rate Limited | Implement retry logic |
| 500 | Server Error | Check GitLab server status |

**Rate Limiting Issues:**

**Symptoms:**
- HTTP 429 responses
- "Rate limit exceeded" messages
- Requests being throttled

**Solutions:**

1. **Implement Exponential Backoff**
   ```javascript
   async function retryRequest(request, maxRetries = 3) {
     for (let i = 0; i < maxRetries; i++) {
       try {
         return await request();
       } catch (error) {
         if (error.status === 429) {
           const delay = Math.pow(2, i) * 1000;
           await sleep(delay);
           continue;
         }
         throw error;
       }
     }
   }
   ```

2. **Request Batching**
   ```javascript
   // Batch multiple requests
   const batchRequests = async (requests) => {
     const batchSize = 10;
     const results = [];
     
     for (let i = 0; i < requests.length; i += batchSize) {
       const batch = requests.slice(i, i + batchSize);
       const batchResults = await Promise.all(batch);
       results.push(...batchResults);
       
       // Delay between batches
       if (i + batchSize < requests.length) {
         await sleep(1000);
       }
     }
     
     return results;
   };
   ```

### MCP Protocol Errors

**Invalid JSON-RPC Format:**

**Symptoms:**
- "Invalid request" errors
- JSON parsing failures
- Protocol violation messages

**Solutions:**

1. **Validate Request Format**
   ```json
   {
     "jsonrpc": "2.0",
     "method": "list_projects",
     "params": {},
     "id": 1
   }
   ```

2. **Check Content-Type Headers**
   ```bash
   curl -X POST \
        -H "Content-Type: application/json" \
        -d '{"jsonrpc":"2.0","method":"ping","id":1}' \
        http://localhost:3000/mcp
   ```

## Docker Issues

### Container Won't Start

**Symptoms:**
- Docker container exits immediately
- Initialization failures
- Environment variable issues

**Diagnosis:**
```bash
# Check container logs
docker logs gitlab-mcp

# Inspect container
docker inspect gitlab-mcp

# Check resource constraints
docker stats gitlab-mcp
```

**Solutions:**

1. **Environment Variables**
   ```bash
   # Check required variables are set
   docker run -e GITLAB_URL -e GITLAB_TOKEN \
              --rm gitlab-mcp env | grep GITLAB
   ```

2. **Volume Mounting Issues**
   ```bash
   # Fix volume permissions
   sudo chown -R 1001:1001 ./data
   
   # Correct volume syntax
   docker run -v $(pwd)/config:/app/config gitlab-mcp
   ```

### Network Connectivity

**Symptoms:**
- Cannot reach external services
- DNS resolution failures
- Port binding issues

**Solutions:**

1. **Docker Network Configuration**
   ```bash
   # Create custom network
   docker network create mcp-network
   
   # Run container with custom network
   docker run --network=mcp-network gitlab-mcp
   ```

2. **Port Mapping**
   ```bash
   # Explicit port mapping
   docker run -p 3000:3000 gitlab-mcp
   
   # Check port mapping
   docker port gitlab-mcp
   ```

## Logging and Debugging

### Enable Debug Logging

```bash
# Environment variable
export LOG_LEVEL=debug

# Configuration file
echo "log_level: debug" >> config.yml

# Command line argument
node server.js --log-level=debug
```

### Structured Logging

```javascript
// Winston logger configuration
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
    new winston.transports.Console()
  ]
});
```

### Health Checks

```bash
# Basic health check
curl http://localhost:3000/health

# Detailed system status
curl http://localhost:3000/status

# GitLab connectivity test
curl http://localhost:3000/test/gitlab
```

## Getting Help

### Log Analysis

When reporting issues, include:

1. **System Information**
   ```bash
   # Operating system
   uname -a
   
   # Node.js version
   node --version
   
   # Docker version (if applicable)
   docker --version
   ```

2. **Configuration**
   ```bash
   # Sanitized configuration (remove secrets)
   cat config.yml | sed 's/token:.*/token: [REDACTED]/'
   ```

3. **Relevant Logs**
   ```bash
   # Recent error logs
   tail -n 100 error.log
   
   # Container logs
   docker logs --tail 100 gitlab-mcp
   ```

### Community Support

- **GitHub Issues**: Report bugs and feature requests
- **Documentation**: Check the latest documentation
- **Community Forum**: Ask questions and share experiences
- **Stack Overflow**: Search for existing solutions

### Professional Support

For enterprise customers:
- **Priority Support**: Guaranteed response times
- **Dedicated Engineer**: Assigned support engineer
- **Custom Solutions**: Tailored troubleshooting
- **Emergency Hotline**: 24/7 critical issue support

## Prevention

### Monitoring Setup

```yaml
# Prometheus metrics
metrics:
  enabled: true
  endpoint: /metrics
  interval: 15s

# Health checks
health_checks:
  - name: gitlab_connectivity
    endpoint: /api/v4/version
    interval: 60s
  
  - name: database_connection
    type: database
    interval: 30s
```

### Automated Testing

```bash
# Integration tests
npm run test:integration

# Performance tests
npm run test:performance

# Security tests
npm run test:security
```

### Regular Maintenance

```bash
#!/bin/bash
# maintenance.sh - Run weekly

# Update dependencies
npm update

# Clean logs
find logs/ -name "*.log" -mtime +30 -delete

# Restart services
docker-compose restart

# Run health checks
npm run health-check
```

## Conclusion

Regular monitoring, proper logging, and preventive maintenance significantly reduce troubleshooting needs. When issues arise, systematic diagnosis and the solutions provided in this guide should resolve most problems quickly.

For complex issues not covered here, consider:
1. Checking the latest documentation
2. Searching community forums
3. Contacting professional support
4. Contributing back to the community

## Resources

- [Configuration Guide](setup.md)
- [Performance Analysis](../analysis/performance-analysis.md)
- [Security Best Practices](../security/best-practices.md)
- [API Reference](../api/mcp-protocol.md)
