# Freddie Mac OpenRisk Navigator - Development Environment

Professional development environment for AI-powered loan risk analysis using Drupal 11 + React 19.

Complete automation achieved: One-command setup with full AI integration, OAuth2 authentication, and intelligent protocol detection. No manual configuration required for a complete working demo environment.

## **Project Overview**

The Freddie Mac OpenRisk Navigator is a comprehensive loan risk assessment platform that combines:
- **Drupal 11 Backend** with custom OpenRisk Navigator module
- **React 19 Frontend** with modern Vite development workflow  
- **AI-Powered Risk Analysis** using configurable AI providers
- **JSON:API Integration** for seamless data flow
- **Professional Admin Interface** with enhanced navigation and statistics

## **Quick Start**

### **One-Command Setup**
```bash
# From the development directory
./setup-dev.sh
```

This automated setup script will:
- ✅ Verify all prerequisites (DDEV, Node.js 18+, npm)
- ✅ Install and configure Drupal with all required modules
- ✅ **Automatically create API user and OAuth2 authentication**
- ✅ **Optionally configure OpenAI for AI risk analysis with guided prompts**
- ✅ **Auto-detect working protocol (HTTP/HTTPS) and configure React environment**
- ✅ Create sample loan records for testing (optional)
- ✅ **Validate all connections and provide comprehensive access URLs**

**Setup time:** ~5-10 minutes depending on your system and choices

## **Prerequisites**

- **[DDEV](https://ddev.readthedocs.io/)** - Local development environment
- **Node.js 18+** - JavaScript runtime (check with `node --version`)
- **Docker** - Required by DDEV for containers
- **OpenAI API Key** - Optional, for AI risk analysis (configured during setup)

### **Node.js Version Notes**
- **Required:** Node.js 18.0.0 or higher
- **Works with:** Node.js 18.x, 19.x, 20.x+
- **Setup script** automatically detects your version and provides upgrade instructions if needed

## What You Get

After running `./setup-dev.sh`, you'll have:

### Drupal 11 Backend
- OpenRisk Navigator Module - Custom loan management system
- Professional Admin Interface - Enhanced navigation and dashboards  
- JSON:API Endpoints - RESTful API for all loan data
- OAuth2 Integration - Fully automated machine-to-machine API access with `openrisk_navigator` consumer
- API User Account - Automatically created `api_user` for secure API access
- Sample Data - Demo loan records (optional during setup)

### React 19 Frontend
- Modern Development - Vite hot-reload, React 19 features
- Auto-Configured API - Automatically connects to Drupal backend with protocol detection
- Professional UI - TailwindCSS styling with ShadCN components
- Real-time Data - Live connection to loan records and AI analysis

### AI Integration (Fully Automated Setup)
- Interactive Configuration - Setup script prompts for OpenAI API key and configures everything automatically
- Multiple Provider Support - OpenAI configured automatically, other providers via manual setup
- Automatic Risk Analysis - AI-generated summaries for loan records
- Markdown Formatting - Professional display of AI-generated content
- One-Click Setup - No manual configuration needed if using OpenAI

## Access Points

After setup completion, access your development environment:

| Service | URL | Credentials | Description |
|---------|-----|-------------|-------------|
| Drupal Admin | Auto-detected/admin | admin/password | Admin interface |
| OpenRisk Hub | Auto-detected/admin/structure/loan-record-settings | admin/password | Module management |
| JSON API | Auto-detected/jsonapi/loan_record/loan_record | - | RESTful endpoints |
| AI Configuration | Auto-detected/admin/config/ai/providers | admin/password | AI provider setup |
| OAuth2 Consumers | Auto-detected/admin/config/services/consumer | admin/password | API authentication |
| React Frontend | http://localhost:5173 | - | Development server |

*Auto-detected URLs use HTTP or HTTPS based on connectivity during setup*

## Protocol Detection & Connectivity

The enhanced setup script automatically handles HTTPS/HTTP connectivity issues common in development environments:

### Intelligent Protocol Detection
- **First**: Tests HTTPS connectivity to DDEV site
- **Auto-Fallback**: Automatically switches to HTTP if HTTPS fails (common with DDEV SSL certificates)
- **React Auto-Configuration**: Automatically configures React environment with the working protocol
- **No User Intervention**: Handles protocol detection transparently

### What You'll See
```
▶ Testing URL connectivity...
✅ HTTPS connectivity confirmed: https://freddie-mac-demo.ddev.site
```
**OR**
```
▶ Testing URL connectivity...
⚠️ HTTPS failed, using HTTP: http://freddie-mac-demo.ddev.site
```

The React environment is automatically configured with whichever protocol works.

### Manual Protocol Override (Rarely Needed)
If you need to manually change protocols after setup:

```bash
# Edit React environment
cd react-site
cp .env.example .env

# Replace {{DRUPAL_ROOT_URL}} with your preferred URL
sed -i 's|{{DRUPAL_ROOT_URL}}|http://freddie-mac-demo.ddev.site|g' .env
```

## **AI Provider Setup**

The enhanced setup script provides **fully automated OpenAI configuration** with interactive prompts, plus manual setup options for other providers.

### **Automated Setup (Default - Recommended)**

The setup script automatically handles AI configuration:

1. **Interactive Prompt**: You'll be asked: *"Would you like to configure OpenAI for AI risk analysis? (y/n)"*
2. **API Key Input**: If you choose 'yes', enter your OpenAI API key when prompted
3. **Automatic Configuration**: Script automatically:
   - Creates and configures the OpenAI key in Drupal
   - Sets up the AI provider with proper settings
   - Configures default models and settings
   - Tests the configuration
4. **Ready to Use**: Create loan records and see AI risk analysis immediately

**No manual configuration needed!** The setup script handles everything automatically.

### **Manual Setup for Other Providers**

If you chose 'no' during setup or want to add additional AI providers:

#### **Step 1: Get API Key**
- **OpenAI**: https://platform.openai.com/api-keys
- **Anthropic Claude**: https://console.anthropic.com/
- **Other Providers**: Check provider documentation

#### **Step 2: Configure Key in Drupal**
1. Navigate to: `/admin/config/system/keys/add`
2. **Key ID**: `openai_api_key` (or provider-specific)
3. **Key Type**: Authentication
4. **Key Provider**: Configuration
5. **Key Value**: Paste your API key
6. **Save**

#### **Step 3: Configure AI Provider**
1. Navigate to: `/admin/config/ai/providers`
2. **Add Provider** → Select your provider type
3. **Configuration**:
   - **Provider Name**: Custom name
   - **API Key**: Select your configured key
   - **Model**: Choose appropriate model (e.g., `gpt-4o` for OpenAI)
   - **Base URL**: Leave default unless using custom endpoint
4. **Test Connection** to verify setup
5. **Save**

#### **Step 4: Test AI Integration**
1. **Create a test loan record** at `/loan-record/add`
2. **Fill in loan details** (borrower name, amounts, scores)
3. **Save** - AI risk analysis should generate automatically
4. **Check the risk_summary field** for AI-generated content

### **Alternative AI Providers**

The system supports multiple AI providers beyond OpenAI:

#### **Anthropic Claude**
```bash
# Install Claude provider (if available)
ddev composer require drupal/ai_provider_anthropic
ddev drush en ai_provider_anthropic -y

# Configure with Claude API key
# Follow steps 2-4 above with Claude-specific settings
```

#### **Custom APIs**
- **OpenAI-Compatible**: Any API that follows OpenAI format
- **Local Models**: With appropriate API wrapper (Ollama, LocalAI)
- **Enterprise APIs**: Azure OpenAI, AWS Bedrock (if modules available)

#### **Troubleshooting AI Setup**
- **Invalid API Key**: Verify your account has billing enabled
- **Network Issues**: Check firewall and proxy settings  
- **Module Errors**: Clear cache with `ddev drush cr`
- **AI Content Not Displaying**: Verify field formatter configuration at `/admin/structure/loan-record-settings`

## API Authentication & OAuth2

The setup script fully automates secure API access configuration:

### Automated OAuth2 Configuration
The setup script automatically creates:
- **Client ID**: `openrisk_navigator`
- **Client Secret**: `password` (consistent with other demo credentials)
- **Grant Type**: Client Credentials (machine-to-machine)
- **Scope**: `loan_record:view`
- **API User**: `api_user@freddie-mac-demo.ddev.site` (automatically created)
- **Configuration**: Consumer marked as confidential with 300-second token expiration

No manual configuration required! Everything is set up automatically during the setup process.

### **Testing API Access** (Ready to Use)
The enhanced setup script automatically configures OAuth2 authentication. You can test it immediately:

```bash
# Get OAuth2 token (consumer secret is 'password')
curl -X POST http://freddie-mac-demo.ddev.site/oauth/token \
  -d "grant_type=client_credentials" \
  -d "client_id=openrisk_navigator" \
  -d "client_secret=password" \
  -d "scope=loan_record:view"

# Use token to access API
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://freddie-mac-demo.ddev.site/jsonapi/loan_record/loan_record
```

**Note**: Replace the URL with your actual DDEV site URL (the setup script displays this).

### **React API Integration**
The React app is automatically configured to use the correct API endpoints:
- **Environment Variables**: Auto-generated in `.env`
- **API Base URL**: Matches working Drupal protocol
- **Authentication**: Ready for OAuth2 token integration

## Available Commands

### Core Operations
```bash
./setup-dev.sh        # Enhanced automated setup (idempotent)
./test-dev.sh         # Validate environment
```

### Development Workflow
```bash
# Start DDEV (from drupal-site/)
ddev start            # Start development environment
ddev restart          # Restart if needed
ddev stop             # Stop development environment

# React development (from react-site/) 
npm run dev           # Start development server
npm run build         # Build for production
npm run preview       # Preview production build
npm run lint          # Run ESLint
```

### Drupal Operations
```bash
# Container access
ddev ssh              # SSH into Drupal container
ddev drush status     # Check Drupal status
ddev drush uli        # Get admin login link
ddev drush cr         # Clear cache
ddev logs             # View container logs

# Database operations
ddev drush sql:dump   # Export database
ddev import-db        # Import database
```

## **Features Demonstrated**

### **OpenRisk Navigator Module**
- **Custom Entity Management** - Create and manage loan records
- **Professional Admin Interface** - Enhanced Drupal admin experience  
- **AI Risk Analysis** - Automatic risk assessment for new loan records
- **JSON:API Integration** - RESTful endpoints for all loan data
- **OAuth2 Security** - Machine-to-machine API authentication
- **Sample Data Generation** - Interactive seeding for demonstration

### **React Frontend Capabilities**
- **Modern Development Stack** - React 19, Vite, TailwindCSS
- **Auto-Configured API** - No manual URL configuration needed
- **Component Library** - Professional UI components with ShadCN
- **Hot Module Replacement** - Instant updates during development
- **Protocol Detection** - Works with both HTTP and HTTPS automatically

### **AI & Data Processing**
- **Multi-Provider AI Support** - OpenAI, Claude, custom endpoints
- **Markdown Content Rendering** - Professional display of AI-generated analysis
- **Dynamic Risk Assessment** - Real-time analysis of loan parameters
- **Configurable AI Models** - Choose models based on accuracy vs cost needs

## Troubleshooting

### **Enhanced Setup Script Issues**
```bash
# If enhanced setup fails partway through
./setup-dev.sh  # Script is idempotent - safe to re-run

# The script will detect existing configurations and skip duplicate operations
# Check specific failure point in output for targeted troubleshooting
```

### **AI Integration Issues**
- **No AI Content Generated**: 
  1. Verify you chose 'y' when prompted for AI setup during installation
  2. Check AI provider configuration: `/admin/config/ai/providers`
  3. Verify API key is valid and has billing enabled at OpenAI
  4. Test API connection in provider configuration
  5. Clear cache: `ddev drush cr`

- **Setup Script Didn't Prompt for AI**: 
  1. Re-run setup script - it will detect existing setup and only prompt for missing configurations
  2. Or configure manually: `/admin/config/system/keys` then `/admin/config/ai/providers`

### **OAuth2 & API Access Issues**
- **OAuth2 Consumer Not Created**:
  1. Check if consumer exists: `/admin/config/services/consumer`
  2. Look for `openrisk_navigator` consumer with client_credentials grant type
  3. If missing, the enhanced setup script can re-create it on next run

- **API User Missing**:
  1. Check users: `/admin/people` for `api_user`
  2. Re-run setup script to create missing user

### **Protocol/Connectivity Issues**
```bash
# Test Drupal connectivity manually
curl -I http://freddie-mac-demo.ddev.site    # Try HTTP
curl -I https://freddie-mac-demo.ddev.site   # Try HTTPS

# Check React .env configuration
cd react-site
cat .env | grep VITE_API_BASE_URL

# Regenerate .env if needed
rm .env
cp .env.example .env
sed -i 's|{{DRUPAL_ROOT_URL}}|http://freddie-mac-demo.ddev.site|g' .env
```

### **DDEV Issues**
```bash
# DDEV won't start
cd drupal-site
ddev restart
# If still issues: ddev stop && ddev start

# Port conflicts
ddev stop
# Check what's using port 80: lsof -i :80
ddev start

# Database connection issues
ddev restart
ddev drush status
```

### **React Development Issues**
```bash
# React won't start or build errors
cd react-site
rm -rf node_modules package-lock.json
npm install
npm run dev

# API connection issues
# 1. Verify Drupal is running: check URL in browser
# 2. Check .env file has correct URL
# 3. Test JSON API: curl http://your-url/jsonapi/loan_record/loan_record
```

### **Module & API Issues**
```bash
# OpenRisk Navigator module problems
cd drupal-site
ddev drush pm:list | grep openrisk  # Check if enabled
ddev drush en openrisk_navigator -y # Re-enable if needed
ddev drush cr                       # Clear cache

# API access issues
ddev drush user:information api_user  # Check API user exists
# Visit /admin/config/services/consumer # Check OAuth2 consumer

# Permission issues
ddev drush user:login              # Get admin login link
# Then visit /admin/people/permissions to verify
```

### **AI Integration Issues**
- **No AI Content Generated**: 
  1. Check AI provider configuration: `/admin/config/ai/providers`
  2. Verify API key is valid and has billing enabled
  3. Test API connection in provider configuration
  4. Clear cache: `ddev drush cr`

- **AI Content Not Displaying Properly**:
  1. Check field formatter: `/admin/structure/loan-record-settings`
  2. Ensure "AI Markdown to HTML" formatter is selected for risk_summary
  3. Clear render cache: `ddev drush cr`

- **API Rate Limits**: 
  1. Check OpenAI usage dashboard
  2. Verify billing status
  3. Consider using different model with lower costs

### **Environment Variables**
```bash
# .env file issues
cd react-site
cat .env  # Verify URL matches DDEV site

# If incorrect, regenerate
rm .env
./setup-dev.sh  # Will regenerate .env correctly

# Or manual fix
cp .env.example .env
sed -i 's|{{DRUPAL_ROOT_URL}}|YOUR_ACTUAL_URL|g' .env
```

## **Project Structure**

```
development/
├── setup-dev.sh              # Enhanced setup script
├── test-dev.sh               # Validation script  
├── README.md                 # This documentation
├── *.md                      # Historical documentation
├── drupal-site/              # DDEV Drupal 11
│   ├── .ddev/               # DDEV configuration
│   ├── web/                 # Drupal docroot
│   │   ├── modules/custom/openrisk_navigator/  # Main module
│   │   └── ...
│   ├── composer.json        # PHP dependencies
│   └── vendor/              # Composer packages
└── react-site/              # Vite React 19
    ├── src/                 # React source code
    ├── public/              # Static assets
    ├── .env.example         # Environment template
    ├── .env                 # Generated environment (auto-created)
    ├── package.json         # Node dependencies
    ├── vite.config.js       # Vite configuration
    └── node_modules/        # NPM packages
```

## **Success Metrics**

When the enhanced setup script completes successfully:
- ✅ **Setup script** completes without errors showing "DEVELOPMENT ENVIRONMENT READY!"
- ✅ **DDEV starts** and serves Drupal at auto-detected URL (HTTP or HTTPS)
- ✅ **Admin interface** loads with OpenRisk Navigator menu items
- ✅ **API user** (`api_user`) and OAuth2 consumer (`openrisk_navigator`) automatically created
- ✅ **JSON:API endpoints** respond with loan record data
- ✅ **React development server** starts and connects to API automatically
- ✅ **AI integration** configured and generating risk analysis (if AI enabled during setup)
- ✅ **Sample loan records** display with AI-generated content (if sample data chosen)
- ✅ **Protocol detection** working (HTTP/HTTPS auto-selected)
- ✅ **Complete automation** - no manual post-setup configuration needed

## Complete Automation Achievement

The enhanced setup script delivers on the "distributed demo" vision with complete automation:

### Fully Automated Components
- ✅ Drupal Installation & Module Configuration - Standard profile with all required modules
- ✅ OpenRisk Navigator Module Enablement - Custom entity and admin interface  
- ✅ API User Creation - `api_user` with proper permissions and settings
- ✅ OAuth2 Consumer Setup - `openrisk_navigator` consumer with client credentials grant
- ✅ AI Integration - OpenAI provider configuration via interactive prompts
- ✅ Protocol Detection - Automatic HTTPS/HTTP fallback for reliability
- ✅ React Environment Configuration - Auto-generated .env with working API URLs
- ✅ Comprehensive Validation - All endpoints tested and confirmed working

### Zero Manual Configuration Required
The setup script handles every aspect of your procedural requirements automatically. No post-setup manual steps needed for core functionality.

### Professional Distribution Ready
The enhanced setup creates a complete, working demo environment that can be distributed to users with confidence that it will "just work" out of the box.

---

## **Advanced Configuration**

### **Multiple AI Providers**
You can configure multiple AI providers simultaneously:
1. **Configure each provider** with separate API keys
2. **Set default provider** in AI settings: `/admin/config/ai/settings`
3. **Switch providers** per operation if needed

### **Custom OAuth2 Scopes**
To create additional API scopes:
1. **Visit**: `/admin/config/people/simple_oauth/oauth2_scope/dynamic`
2. **Add Scope** with custom permissions
3. **Update Consumer** to include new scopes
4. **Test access** with new scope in API calls

### **Production Configuration**
For production deployments:
- **Generate secure consumer secrets** (not demo values)
- **Use environment-specific API keys**
- **Configure proper CORS settings** for production domains
- **Enable HTTPS** with proper SSL certificates
- **Review permissions** and remove unnecessary access

## **Testing & Validation**

### **Automated Testing**
```bash
# Run comprehensive environment test
./test-dev.sh

# Expected output: All green checkmarks
# ✅ DDEV is running
# ✅ Drupal is bootstrapped and working  
# ✅ OpenRisk Navigator module is enabled
# ✅ JSON:API module is enabled
# ✅ JSON:API endpoint is responding
# ✅ React dependencies are installed
# ✅ React application builds successfully
```

### **Manual Testing Checklist**
- [ ] Drupal admin accessible with admin/password
- [ ] OpenRisk Navigator menu items visible in admin interface
- [ ] API user `api_user` created and visible at `/admin/people`
- [ ] OAuth2 consumer `openrisk_navigator` visible at `/admin/config/services/consumer`
- [ ] Create new loan record - saves successfully
- [ ] AI risk analysis generates automatically (if AI configured during setup)
- [ ] JSON:API returns loan data: `/jsonapi/loan_record/loan_record`
- [ ] React dev server starts: `npm run dev`
- [ ] React app connects to Drupal API automatically
- [ ] Protocol detection worked correctly (HTTP or HTTPS as detected)

## **Additional Resources**

### **Documentation**
- **Drupal 11**: [https://www.drupal.org/docs/drupal-apis](https://www.drupal.org/docs/drupal-apis)
- **React 19**: [https://react.dev/](https://react.dev/)
- **Vite**: [https://vitejs.dev/guide/](https://vitejs.dev/guide/)
- **JSON:API**: [https://www.drupal.org/docs/core-modules-and-themes/core-modules/jsonapi-module](https://www.drupal.org/docs/core-modules-and-themes/core-modules/jsonapi-module)
- **DDEV**: [https://ddev.readthedocs.io/](https://ddev.readthedocs.io/)
- **Simple OAuth**: [https://www.drupal.org/project/simple_oauth](https://www.drupal.org/project/simple_oauth)

### **AI Integration**
- **OpenAI API**: [https://platform.openai.com/docs/api-reference](https://platform.openai.com/docs/api-reference)
- **Drupal AI Module**: [https://www.drupal.org/project/ai](https://www.drupal.org/project/ai)
- **AI Provider Configuration**: Available in your Drupal admin interface

## **License**

GPL-2.0-or-later

---

**Built for the mortgage industry by Freddie Mac**

*Demonstrating professional AI-powered financial technology with open-source tools*

---

## **Quick Reference**

### **Essential URLs** (Auto-detected during setup)
- **Admin**: `/admin` (admin/password)
- **AI Config**: `/admin/config/ai/providers`
- **OAuth2**: `/admin/config/services/consumer`
- **Field Display**: `/admin/structure/loan-record-settings`
- **API**: `/jsonapi/loan_record/loan_record`

### Essential Commands
```bash
./setup-dev.sh          # Enhanced automated setup (idempotent - safe to re-run)
./test-dev.sh           # Validate environment  
ddev drush uli          # Get admin login link
npm run dev             # Start React development
```

### Getting Help
1. Check this README for comprehensive solutions
2. Re-run setup script: `./setup-dev.sh` is idempotent and will fix missing configurations
3. Run test script: `./test-dev.sh` for environment validation
4. Check logs: `ddev logs` for DDEV issues
5. Clear caches: `ddev drush cr` for Drupal issues

---

**Built for enterprise-grade mortgage risk analysis platforms**  
*Freddie Mac OpenRisk Navigator - Professional Development Environment*
