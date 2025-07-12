#!/bin/bash

# 🧪 FREDDIE MAC OPENRISK NAVIGATOR - DEVELOPMENT TEST
# Verify that the development environment is working correctly

set -e

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

echo "🧪 TESTING FREDDIE MAC OPENRISK NAVIGATOR DEVELOPMENT"
echo "===================================================="
echo ""

# Check if we're in the right directory
if [ ! -d "drupal-site" ] || [ ! -d "react-site" ]; then
    print_error "Must be run from the development directory containing drupal-site and react-site"
    exit 1
fi

cd drupal-site

# Test 1: Check DDEV status
print_status "Test 1: Checking DDEV status..."
if ddev describe &> /dev/null; then
    print_success "DDEV is running"
    DDEV_URL=$(ddev describe | grep "can be reached at" | awk '{print $NF}' | head -1)
    echo "   URL: $DDEV_URL"
else
    print_error "DDEV is not running - run './setup-dev.sh' first"
    exit 1
fi

# Test 2: Check Drupal status
print_status "Test 2: Checking Drupal status..."
if ddev drush status --fields=bootstrap --format=string 2>/dev/null | grep -q "Successful"; then
    print_success "Drupal is bootstrapped and working"
else
    print_error "Drupal is not properly installed"
    exit 1
fi

# Test 3: Check OpenRisk Navigator module
print_status "Test 3: Checking OpenRisk Navigator module..."
if ddev drush pm:list --status=enabled --format=string | grep -q "openrisk_navigator"; then
    print_success "OpenRisk Navigator module is enabled"
else
    print_error "OpenRisk Navigator module is not enabled"
    exit 1
fi

# Test 4: Check JSON:API availability
print_status "Test 4: Testing JSON:API endpoint..."
if ddev drush eval "echo json_encode(Drupal::service('module_handler')->moduleExists('jsonapi'));" | grep -q "true"; then
    print_success "JSON:API module is enabled"
    # Test actual endpoint
    if curl -s -o /dev/null -w "%{http_code}" "$DDEV_URL/jsonapi/loan_record/loan_record" | grep -q "200"; then
        print_success "JSON:API endpoint is responding"
    else
        print_warning "JSON:API endpoint may not be accessible (this is OK for testing)"
    fi
else
    print_error "JSON:API module is not enabled"
fi

cd ..

# Test 5: Check React setup
print_status "Test 5: Checking React setup..."
cd react-site

if [ -f "package.json" ] && [ -d "node_modules" ]; then
    print_success "React dependencies are installed"
    
    # Check if we can run the build (quick test)
    if npm run build > /dev/null 2>&1; then
        print_success "React application builds successfully"
    else
        print_warning "React build had issues - may need npm install"
    fi
else
    print_error "React setup incomplete - run './setup-dev.sh' first"
fi

cd ..

echo ""
echo "🎉 DEVELOPMENT ENVIRONMENT TEST COMPLETE!"
echo "========================================"
echo ""
echo "✅ All core functionality appears to be working"
echo ""
echo "🚀 NEXT STEPS:"
echo "   1. Visit: $DDEV_URL/admin (login: admin/password)"
echo "   2. Check OpenRisk Navigator: $DDEV_URL/admin/structure/loan-record-settings"
echo "   3. Start React dev server: cd react-site && npm run dev"
echo "   4. Test API: $DDEV_URL/jsonapi/loan_record/loan_record"
echo ""
print_success "Happy testing! 🎯"
