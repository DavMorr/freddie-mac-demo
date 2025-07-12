# Freddie Mac OpenRisk Navigator - Demo

**Complete React 19 + Drupal 11 demonstration application for AI-powered loan risk analysis.**

## 🎯 **Quick Start - Development Environment**

```bash
# Navigate to development directory
cd development/

# Run the setup script
chmod +x setup-dev.sh
./setup-dev.sh

# Start React development server
cd react-site
npm run dev
```

**Access URLs:**
- 🌐 **Drupal Admin**: https://freddie-mac-demo.ddev.site/admin
- 🎯 **OpenRisk Hub**: https://freddie-mac-demo.ddev.site/admin/structure/loan-record-settings  
- 📊 **JSON API**: https://freddie-mac-demo.ddev.site/jsonapi/loan_record/loan_record
- ⚛️ **React Frontend**: http://localhost:5173

## 🎉 **What You Get**

- **AI-Powered Loan Risk Analysis**: Create loan records and see real-time AI risk assessments
- **Professional Admin Interface**: Complete Drupal backend with enhanced navigation
- **React 19 Frontend**: Modern, responsive UI connecting to JSON:API
- **Sample Data**: Pre-loaded demonstration loan records  
- **Zero Configuration**: Everything works out of the box

## 📋 **Prerequisites**

- [DDEV](https://ddev.readthedocs.io/) installed
- Node.js 18+ for React/Vite
- Docker (for DDEV containers)

## 🎯 **Demo Workflow**

1. **Access Admin Dashboard**: `/admin/openrisk/dashboard`
2. **Create Loan Records**: `/admin/content/loan-record/add`
3. **View AI Analysis**: Records automatically get AI risk summaries
4. **Test JSON:API**: `/jsonapi/loan_record/loan_record`
5. **Use React Frontend**: Modern UI with real-time data

## 📊 **Features Demonstrated**

- **AI Integration**: Multiple AI provider support through Drupal AI module
- **API-First Architecture**: Headless Drupal with React frontend
- **Professional UX**: Enhanced admin interface with statistics
- **Enterprise Patterns**: OAuth2, permissions, entity management
- **Modern Stack**: Drupal 11, React 19, AI-powered workflows

## 🔧 **Configuration**

### **AI Provider Setup**
Configure your AI provider in Drupal:
1. Navigate to `/admin/config/ai/providers`
2. Add your OpenAI API key (or other provider)
3. AI risk analysis will work automatically

### **API Access**
- **Anonymous access**: Enabled by default for demos
- **OAuth2**: Configured for machine-to-machine access
- **JSON:API**: Full CRUD operations available

## 🏗️ **Project Structure**

```
📁 freddie-mac-demo/
├── development/            # DDEV + Vite development environment
│   ├── drupal-site/       # Drupal 11 with OpenRisk Navigator module
│   ├── react-site/        # React 19 with Vite
│   ├── setup-dev.sh       # Automated development setup
│   └── README.md          # This file
└── production/            # Docker containers (future implementation)
```

## 🔧 **Useful Commands**

```bash
# DDEV commands (run from drupal-site directory)
ddev ssh              # SSH into Drupal container
ddev drush status     # Check Drupal status
ddev drush uli        # Get admin login link
ddev drush cr         # Clear cache

# React commands (run from react-site directory)  
npm run dev           # Start development server
npm run build         # Build for production
npm run preview       # Preview production build
```

## 🐛 **Troubleshooting**

### **Common Issues**
- **Port conflicts**: Ensure ports 80, 3000, 8080 are available
- **DDEV conflicts**: Make sure no other DDEV projects named "freddie-mac-demo" exist
- **AI Integration**: Verify API keys in `/admin/config/ai/providers`

### **Get Help**
- Check logs: `ddev logs` (development)
- Reset DDEV: `ddev restart` or `ddev poweroff && ddev start`
- Clear React cache: Delete `node_modules` and run `npm install`

## 📄 **License**

GPL-2.0-or-later

---

**Built with ❤️ for the mortgage industry by Freddie Mac**

*Demonstrating AI-powered financial technology with open-source tools*
