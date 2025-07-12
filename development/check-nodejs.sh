#!/bin/bash

# 🔍 NODE.JS VERSION CHECKER
# Quick utility to check Node.js and nvm status

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

echo "🔍 NODE.JS ENVIRONMENT CHECK"
echo "============================"
echo ""

# Check Node.js version
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_status "Node.js version: $NODE_VERSION"
    
    if [[ "$NODE_VERSION" < "v18" ]]; then
        print_warning "Node.js $NODE_VERSION detected. This app requires v18+"
    else
        print_success "Node.js version is compatible with this application"
    fi
else
    print_error "Node.js not found. Please install from https://nodejs.org/"
fi

echo ""

# Check npm
if command -v npm &> /dev/null; then
    print_success "npm available: $(npm --version)"
else
    print_error "npm not found"
fi

echo ""

# Check nvm availability
print_status "Checking nvm availability..."

if command -v nvm &> /dev/null; then
    print_success "nvm command available"
    nvm --version 2>/dev/null || echo "nvm version command failed"
elif [ -s "$HOME/.nvm/nvm.sh" ]; then
    print_success "nvm script found at $HOME/.nvm/nvm.sh"
    print_status "To use nvm: source ~/.nvm/nvm.sh"
elif [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
    print_success "nvm script found at /usr/local/opt/nvm/nvm.sh (Homebrew)"
    print_status "To use nvm: source /usr/local/opt/nvm/nvm.sh"
else
    print_warning "nvm not detected"
    print_status "Manual Node.js installation required from https://nodejs.org/"
fi

echo ""

# Recommendations
print_status "RECOMMENDATIONS:"
echo ""

if [[ "$(node --version 2>/dev/null)" < "v18" ]]; then
    echo "📥 UPDATE NEEDED:"
    if command -v nvm &> /dev/null || [ -s "$HOME/.nvm/nvm.sh" ]; then
        echo "   Option 1: nvm install 18 && nvm use 18"
        echo "   Option 2: Download from https://nodejs.org/"
    else
        echo "   Download Node.js 18+ from https://nodejs.org/"
    fi
    echo ""
    echo "🔄 AFTER UPDATE:"
    echo "   cd react-site"
    echo "   rm -rf node_modules package-lock.json"
    echo "   npm install"
    echo "   npm run dev"
else
    echo "🎉 Your Node.js version is ready for React development!"
    echo ""
    echo "🚀 TO START DEVELOPMENT:"
    echo "   cd react-site"
    echo "   npm run dev"
fi

echo ""
print_success "Environment check complete!"
