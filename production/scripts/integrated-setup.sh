#!/bin/bash

echo "=========================================================================="
echo "🚀 FREDDIE MAC OPENRISK NAVIGATOR - COMPLETE DOCKER SETUP"
echo "=========================================================================="
echo "Integrated setup script incorporating all troubleshooting findings"
echo "from 4+ hour expert debugging session"
echo ""

set -e  # Exit on any error

PROJECT_DIR="/Users/davidmorrison/Sites2/Production/freddie-mac/freddie-mac-demo/production"
cd "$PROJECT_DIR"

echo "📍 Working Directory: $(pwd)"
echo ""

# ==============================================================================
# STEP 1: PRE-FLIGHT CHECKS
# ==============================================================================
echo "🔍 STEP 1: PRE-FLIGHT CHECKS"
echo "=============================="

if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Error: Docker not found. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose >/dev/null 2>&1 && ! command -v docker compose >/dev/null 2>&1; then
    echo "❌ Error: Docker Compose not found. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose found"
echo "✅ Project directory confirmed"
echo ""

# ==============================================================================
# STEP 2: CLEAN ENVIRONMENT
# ==============================================================================
echo "🧹 STEP 2: CLEAN ENVIRONMENT"
echo "============================="

echo "Stopping any existing containers..."
docker compose down 2>/dev/null || true

echo "Cleaning up any orphaned containers..."
docker container prune -f >/dev/null 2>&1 || true

echo "✅ Environment cleaned"
echo ""

# ==============================================================================
# STEP 3: VERIFY CRITICAL FILES
# ==============================================================================
echo "📋 STEP 3: VERIFY CRITICAL FILES"
echo "================================="

CRITICAL_FILES=(
    "docker-compose.yml"
    "drupal-site/Dockerfile" 
    "drupal-site/php-fpm.conf"
    "drupal-site/php.ini"
    "drupal-site/composer.json"
    "drupal-site/web/index.php"
    "react-site/package.json"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file"
    else
        echo "❌ MISSING: $file"
        exit 1
    fi
done

echo "✅ All critical files present"
echo ""

# ==============================================================================
# STEP 4: BUILD AND START CONTAINERS
# ==============================================================================
echo "🏗️ STEP 4: BUILD AND START CONTAINERS"
echo "====================================="

echo "Building containers with latest fixes..."
docker compose up -d --build

echo ""
echo "Waiting for containers to stabilize..."
sleep 30

echo ""
echo "Container status:"
docker compose ps
echo ""

# ==============================================================================
# STEP 5: DATABASE SETUP WITH CORRECT CREDENTIALS
# ==============================================================================
echo "💾 STEP 5: DATABASE SETUP"
echo "========================="

echo "Setting up database with correct credentials..."

# Use the actual passwords we discovered during troubleshooting
ROOT_PASSWORD="docker_test_root_pass_2025"
DRUPAL_PASSWORD="docker_test_db_pass_2025"

echo "Creating database and user..."
docker compose exec mysql mysql -u root -p"${ROOT_PASSWORD}" -e "
CREATE DATABASE IF NOT EXISTS drupal_production;
CREATE USER IF NOT EXISTS 'drupal_user'@'%' IDENTIFIED BY '${DRUPAL_PASSWORD}';
GRANT ALL PRIVILEGES ON drupal_production.* TO 'drupal_user'@'%';
FLUSH PRIVILEGES;
" >/dev/null 2>&1

echo "Testing database connection..."
if docker compose exec mysql mysql -u drupal_user -p"${DRUPAL_PASSWORD}" drupal_production -e "SELECT 'Database connection successful' as status;" >/dev/null 2>&1; then
    echo "✅ Database connection verified"
else
    echo "❌ Database connection failed"
    exit 1
fi

echo ""

# ==============================================================================
# STEP 6: FIX DRUSH PERMISSIONS (CRITICAL FIX FROM TROUBLESHOOTING)
# ==============================================================================
echo "🔧 STEP 6: FIX DRUSH PERMISSIONS"
echo "================================"

echo "Applying drush wrapper script fix..."
docker compose exec drupal chmod +x vendor/bin/drush

echo "Verifying drush functionality..."
if docker compose exec drupal vendor/bin/drush --version >/dev/null 2>&1; then
    echo "✅ Drush is working"
else
    echo "❌ Drush fix failed"
    exit 1
fi

echo ""

# ==============================================================================
# STEP 7: DRUPAL INSTALLATION
# ==============================================================================
echo "🏛️ STEP 7: DRUPAL INSTALLATION"
echo "=============================="

echo "Installing Drupal with standard profile..."
docker compose exec drupal vendor/bin/drush site:install standard \
  --db-url=mysql://drupal_user:${DRUPAL_PASSWORD}@mysql:3306/drupal_production \
  --account-name=admin \
  --account-pass=password \
  --site-name="Freddie Mac OpenRisk Navigator" \
  --yes

echo ""
echo "Verifying Drupal installation..."
if docker compose exec drupal vendor/bin/drush status | grep -q "Connected"; then
    echo "✅ Drupal installation successful"
else
    echo "❌ Drupal installation verification failed"
    exit 1
fi

echo ""

# ==============================================================================
# STEP 8: FINAL VERIFICATION
# ==============================================================================
echo "🎯 STEP 8: FINAL VERIFICATION"
echo "============================="

echo "Testing web access..."

# Test React frontend
if curl -s -o /dev/null -w "%{http_code}" http://react.localhost:8080/ | grep -q "200"; then
    echo "✅ React Frontend (http://react.localhost:8080): Working"
else
    echo "❌ React Frontend: Failed"
fi

# Test Drupal backend  
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/ | grep -q "200"; then
    echo "✅ Drupal Backend (http://localhost:8081): Working"
else
    echo "❌ Drupal Backend: Failed"
fi

echo ""

# ==============================================================================
# SUCCESS SUMMARY
# ==============================================================================
echo "=========================================================================="
echo "🎉 SETUP COMPLETE - FREDDIE MAC OPENRISK NAVIGATOR READY!"
echo "=========================================================================="
echo ""
echo "🌐 ACCESS INFORMATION:"
echo "  React Frontend:  http://reactlocalhost:8080"
echo "  Drupal Backend:  http://localhost:8081"
echo "  Drupal Admin:    http://localhost:8081/admin"
echo "  Login:           admin / password"
echo ""
echo "🔧 MANAGEMENT COMMANDS:"
echo "  Start:           make up"
echo "  Stop:            make down"
echo "  Status:          make debug"
echo "  Logs:            make logs"
echo ""
echo "📋 SYSTEM STATUS:"
docker compose exec drupal vendor/bin/drush status | head -10
echo ""
echo "🚀 READY FOR OPENRISK NAVIGATOR MODULE CONFIGURATION!"
echo "=========================================================================="
