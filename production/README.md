# Freddie Mac OpenRisk Navigator

Professional AI-powered mortgage loan risk analysis platform built with Drupal 11 and React 19.

Complete production automation achieved: One-command deployment with integrated AI setup, comprehensive monitoring, and enterprise-grade Docker orchestration. Professional deployment system designed for mortgage industry applications.

## Quick Start

### Prerequisites
- Docker and Docker Compose
- 8GB+ RAM recommended
- Ports 8080 and 8081 available

### One-Command Deployment
```bash
# Complete deployment with interactive AI setup
make deploy-fresh-with-ai

# OR: Basic deployment (manual AI setup)
make deploy-fresh
```

## Access Points

After deployment completion, access your production environment:

| Service | URL | Credentials | Description |
|---------|-----|-------------|-------------|
| React Frontend | http://react.localhost:8080 | - | Main application interface |
| Drupal Backend | http://localhost:8081 | admin/password | API and admin interface |
| Drupal Admin | http://localhost:8081/admin | admin/password | Administrative interface |
| OpenRisk Hub | http://localhost:8081/admin/structure/loan-record-settings | admin/password | Module management |
| JSON API | http://localhost:8081/jsonapi/loan_record/loan_record | - | RESTful endpoints |
| AI Configuration | http://localhost:8081/admin/config/ai/providers | admin/password | AI provider setup |
| OAuth2 Consumers | http://localhost:8081/admin/config/services/consumer | admin/password | API authentication |

## Available Commands

### Core Operations
```bash
make help                 # Show all available commands
make deploy-fresh-with-ai # Complete deployment with AI setup
make deploy-fresh         # Complete fresh deployment (manual AI)
make setup-ai            # Configure AI integration (post-deployment)
make up                  # Start services
make down                # Stop services
make status              # Check system status
```

### Development & Debugging
```bash
make shell-drupal   # Access Drupal container
make shell-react    # Access React container
make logs          # View all logs
make logs-drupal   # View Drupal container logs only
make logs-react    # View React container logs only
make logs-nginx    # View nginx logs only
make debug-drupal  # Drupal diagnostics
```

### Maintenance & Operations
```bash
make backup        # Backup database
make clean         # Remove all data (destructive)
make reset         # Clean install from scratch
make restart       # Restart all services
make rebuild       # Force rebuild all images
```

### Monitoring & Troubleshooting
```bash
make troubleshoot  # Run comprehensive troubleshooting diagnostics
make monitor       # Monitor all containers in real-time
make health        # Quick health check of all services
```

### OpenRisk Navigator Module
```bash
make enable-openrisk  # Enable custom module
make setup-ai         # Interactive AI integration setup
```

## Configuration

### Docker Environment
This deployment uses Docker containerization with the following architecture:
- **React**: Internal port 3000, external 8080
- **Drupal**: Internal port 9000 (PHP-FPM), external 8081
- **MySQL**: Internal port 3306, external 3306
- **nginx-react**: Reverse proxy for React frontend
- **nginx-drupal**: Reverse proxy for Drupal backend

### Environment Configuration
Configuration is managed through Docker Compose environment variables and interactive setup scripts. The system does not use .env files for security reasons - all sensitive configuration is handled through interactive prompts during deployment.

## AI Integration Setup

The OpenRisk Navigator provides comprehensive AI integration with two setup approaches for maximum flexibility.

### Option 1: Automated Setup (Recommended)

Interactive configuration with guided prompts and full automation.

```bash
# During initial deployment
make deploy-fresh-with-ai

# OR: After deployment
make setup-ai
```

**What the automated setup does:**
1. **Creates API user** (`api_user`) for secure API access
2. **Prompts for OpenAI API key** and validates format
3. **Configures Drupal Key entity** with your OpenAI credentials
4. **Sets up OAuth2 consumer** (`openrisk_navigator`) for React-Drupal communication
5. **Configures AI provider** (OpenAI) with specific model settings
6. **Sets AI default providers** for all AI functions
7. **Tests configuration** to ensure everything works
8. **Optional sample data** creation for immediate testing

**Requirements:**
- OpenAI API key from [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
- Active internet connection for API validation

**Benefits:**
- One-command setup with no manual configuration
- Validates dependencies and ensures proper setup order
- Idempotent operation (safe to run multiple times)
- Choice-driven (can skip AI setup if not needed)
- Professional logging with clear status reporting

### Option 2: Manual Setup

For advanced users, custom AI providers, or specific configuration requirements.

**Required manual configuration steps (in dependency order):**

#### Step 1: Accounts Configuration
1. Navigate to: http://localhost:8081/admin/people
2. Create or verify `api_user` account exists
3. Ensure proper permissions for API access

#### Step 2: Keys Configuration  
1. Navigate to: http://localhost:8081/admin/config/system/keys
2. **Add Key**:
   - **Key ID**: `openai_api_key`
   - **Key Type**: Authentication
   - **Key Provider**: Configuration
   - **Key Value**: Your OpenAI API key
3. **Save configuration**

#### Step 3: Simple OAuth Scopes
1. Navigate to: http://localhost:8081/admin/config/people/simple_oauth/oauth2_scope/dynamic
2. Verify `loan_record:view` scope exists (created by OpenRisk Navigator module)

#### Step 4: Consumer Configuration
1. Navigate to: http://localhost:8081/admin/config/services/consumer
2. **Add Consumer**:
   - **Client ID**: `openrisk_navigator`
   - **Label**: OpenRisk Navigator App
   - **Secret**: `password`
   - **Grant Types**: Client Credentials
   - **Scopes**: `loan_record:view`
   - **User**: `api_user`
   - **Confidential**: Yes
3. **Save consumer**

#### Step 5: AI Providers Configuration
1. Navigate to: http://localhost:8081/admin/config/ai/providers
2. **Configure OpenAI Provider**:
   - **Provider**: OpenAI
   - **API Key**: Select `openai_api_key`
   - **Chat Model**: `gpt-4o`
   - **Embeddings Model**: `text-embedding-3-small`
   - **Text-to-Image Model**: `dall-e-3`
   - **Other Models**: Configure as needed
3. **Test connection** and **Save**

#### Step 6: AI Settings Configuration
1. Navigate to: http://localhost:8081/admin/config/ai/settings
2. **Set Default Providers**:
   - **Chat**: OpenAI (gpt-4o)
   - **Embeddings**: OpenAI (text-embedding-3-small)
   - **Text-to-Image**: OpenAI (dall-e-3)
   - **Configure other AI functions** as needed
3. **Save configuration**

### Alternative AI Providers

The system is designed to work with OpenAI by default, but supports multiple AI providers. Alternative options include:

- **Anthropic Claude** - Install `drupal/ai_provider_anthropic` module
- **Google AI** - Install appropriate Google AI provider module  
- **Ollama** - For local AI models
- **Custom APIs** - Any OpenAI-compatible API endpoint

To use alternative providers:
1. Install the appropriate Drupal AI provider module via Composer
2. Enable the module: `make shell-drupal` then `drush en [module_name] -y`
3. Follow Steps 5-6 in manual setup with provider-specific configuration

### Automated Setup Troubleshooting

If the automated AI setup encounters issues:

```bash
# Check container status
make status

# View setup logs
make logs-drupal

# Re-run setup (idempotent)
make setup-ai

# Access container for manual debugging
make shell-drupal
vendor/bin/drush status
```

**Common Issues:**
- **OpenAI API key invalid**: Verify key at [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
- **Module not enabled**: Run `make enable-openrisk` first
- **Container not running**: Run `make up` or `make deploy-fresh`
- **Network connectivity**: Verify internet access for OpenAI API calls

## Architecture

### Container Structure
- **nginx-react**: Reverse proxy for React frontend
- **nginx-drupal**: Reverse proxy for Drupal backend
- **react**: Node.js/Vite development server
- **drupal**: PHP-FPM with Drupal 11
- **mysql**: Database with persistent storage

### Technology Stack
- **Backend**: Drupal 11, PHP 8.3, MySQL 8.0
- **Frontend**: React 19, TypeScript, Vite, Tailwind CSS
- **AI Integration**: Configurable AI providers via Drupal AI modules
- **API**: JSON:API + OAuth2 for React-Drupal communication
- **Containerization**: Docker Compose with professional orchestration

### Data Persistence
- **mysql_data**: Database persistence across container restarts
- **drupal_files**: Uploaded files and media storage
- **react_node_modules**: Node.js dependencies for performance

## Key Features

### OpenRisk Navigator Module
- Custom `loan_record` entity for mortgage data management
- AI-powered `risk_summary` field with automated analysis
- Professional admin interface with enhanced navigation
- Real-time risk analysis on loan record save
- JSON:API integration for external system connectivity

### Development Features
- Hot module reloading for React development
- Volume-mounted source code (no rebuilds needed for changes)
- Comprehensive logging and monitoring capabilities
- Professional error handling and validation

## API Integration

### JSON:API Endpoints
The system provides RESTful API access to all loan data:

- **Loan Records**: `/jsonapi/loan_record/loan_record`
- **Users**: `/jsonapi/user/user`
- **Node Types**: `/jsonapi/node_type/node_type`

### OAuth2 Authentication
API authentication is managed through OAuth2 with the automatically configured consumer:

```bash
# Get OAuth2 token
curl -X POST http://localhost:8081/oauth/token \
  -d "grant_type=client_credentials" \
  -d "client_id=openrisk_navigator" \
  -d "client_secret=password" \
  -d "scope=loan_record:view"

# Use token to access API
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8081/jsonapi/loan_record/loan_record
```

## Monitoring & Troubleshooting

### Health Monitoring
```bash
# Quick system overview
make status

# Comprehensive diagnostics
make troubleshoot

# Real-time container monitoring
make monitor

# Check individual service health
make health
```

### Comprehensive Troubleshooting

The `make troubleshoot` command provides enterprise-grade diagnostics:

- **Docker Environment**: Version information and compatibility
- **Container Status**: Detailed status of all services
- **Network Connectivity**: Tests all service endpoints
- **Volume Status**: Storage and persistence verification
- **Recent Logs**: Last 20 lines from all services for quick debugging

### Real-Time Monitoring

The `make monitor` command provides continuous monitoring:
- Live container status updates every 2 seconds
- Real-time resource usage statistics
- Memory, CPU, and network monitoring for all services

### Log Management
```bash
make logs            # All services combined
make logs-drupal     # Drupal container only
make logs-react      # React container only  
make logs-nginx      # Nginx services only
```

### Common Troubleshooting Scenarios

#### Services Won't Start
```bash
make down
make clean
make deploy-fresh
```

#### Database Connection Issues
```bash
make shell-mysql     # Test database access
make logs | grep mysql
```

#### React/Drupal Communication Issues
```bash
# Test service endpoints
curl -I http://react.localhost:8080  # Test React
curl -I http://localhost:8081       # Test Drupal

# Check network connectivity
make troubleshoot
```

#### AI Integration Not Working
```bash
# Verify AI configuration
make shell-drupal
vendor/bin/drush config:get ai_provider_openai.settings

# Test AI provider connection
# Visit: http://localhost:8081/admin/config/ai/providers
# Use "Test Connection" feature
```

## Production Deployment Considerations

### Security Configuration
- Change default passwords for production use
- Configure HTTPS for production domains
- Review and restrict API permissions as needed
- Set up proper backup schedules
- Monitor container resource usage

### Performance Optimization
- OPcache enabled for PHP performance
- Nginx compression configured for faster loading
- MySQL optimized for Drupal workloads
- React production build optimization for deployment

### Scaling Considerations
- Container resource limits can be adjusted in docker-compose.yml
- Database can be externalized for enterprise deployments
- Multiple frontend containers can be deployed for load balancing
- AI provider rate limits should be monitored for high-volume usage

## Development Workflow

### Making Changes
1. Edit files directly on host system (live-mounted volumes)
2. Changes appear instantly with hot module reloading
3. Use `make logs` to monitor application behavior
4. Use container shells for debugging when needed

### Custom Module Development
- OpenRisk Navigator module located in `drupal-site/web/modules/custom/`
- Enable development modules with `make enable-openrisk`
- Configure AI settings at http://localhost:8081/admin/config/ai
- Use `make shell-drupal` for Drush commands and debugging

## File Structure

```
production/
├── docker-compose.yml    # Multi-container orchestration
├── Makefile             # Professional command interface
├── README.md            # This documentation
├── docker/              # Container configurations
├── drupal-site/         # Drupal 11 with OpenRisk Navigator
├── react-site/          # React 19 frontend application
└── scripts/             # Automation and setup scripts
```

## Support & Documentation

### Project Documentation
- [Drupal 11 Documentation](https://www.drupal.org/docs)
- [React 19 Documentation](https://react.dev)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [JSON:API Drupal Module](https://www.drupal.org/docs/core-modules-and-themes/core-modules/jsonapi-module)

### AI Integration Resources
- [OpenAI API Documentation](https://platform.openai.com/docs/api-reference)
- [Drupal AI Module](https://www.drupal.org/project/ai)

### Professional Support
This deployment is production-ready and includes:
- Comprehensive error handling and validation
- Professional logging and monitoring capabilities
- Security best practices implementation
- Performance optimization for enterprise use
- Monitoring and troubleshooting tools

## License

GPL-2.0-or-later

---

**Built for enterprise-grade mortgage risk analysis platforms**  
*Freddie Mac OpenRisk Navigator - Professional Docker Deployment*

## Quick Reference

### Essential Commands
```bash
make deploy-fresh-with-ai # Complete automated deployment
make setup-ai            # Configure AI integration
make troubleshoot        # Comprehensive diagnostics
make monitor            # Real-time monitoring
make status             # Quick system status
```

### Essential URLs
- **Admin Interface**: http://localhost:8081/admin
- **AI Configuration**: http://localhost:8081/admin/config/ai/providers
- **OAuth2 Management**: http://localhost:8081/admin/config/services/consumer
- **API Endpoint**: http://localhost:8081/jsonapi/loan_record/loan_record
- **Application**: http://react.localhost:8080

### Getting Help
1. Run `make troubleshoot` for comprehensive system diagnostics
2. Check `make logs` for detailed service information
3. Use `make monitor` for real-time system monitoring
4. Automated setup is idempotent - safe to re-run `make deploy-fresh-with-ai`
5. All commands include built-in help and status reporting
