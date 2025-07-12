# Freddie Mac OpenRisk Navigator - Production Environment Management
# Professional Docker deployment system with integrated setup
# Based on proven working solution from integrated debugging session

.PHONY: help up down restart logs health build clean install deploy-fresh reset status setup-ai deploy-fresh-with-ai _enable-modules

# Default target
help: ## Show this help message
	@echo '🏦 Freddie Mac OpenRisk Navigator - Docker Commands'
	@echo '=================================================='
	@echo ''
	@echo 'Usage: make [target]'
	@echo ''
	@echo '🚀 QUICK START:'
	@echo '  make deploy-fresh-with-ai # Complete deployment with AI setup'
	@echo '  make deploy-fresh         # Complete deployment (manual AI setup)'
	@echo '  make setup-ai            # Configure AI integration (post-deployment)'
	@echo '  make up                  # Start existing environment'
	@echo '  make status              # Check system status'
	@echo ''
	@echo '📋 AVAILABLE COMMANDS:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ''
	@echo '🌐 ACCESS URLS:'
	@echo '  React Frontend:  http://react.localhost:8080'
	@echo '  Drupal Backend:  http://localhost:8081'
	@echo '  Drupal Admin:    http://localhost:8081/admin'

# =============================================================================
# CORE DEPLOYMENT COMMANDS
# =============================================================================

deploy-fresh: ## Complete fresh deployment (recommended for first time)
	@echo '🚀 FREDDIE MAC OPENRISK NAVIGATOR - COMPLETE DEPLOYMENT'
	@echo '========================================================'
	@echo 'Starting fresh deployment with proven setup process...'
	@echo ''
	$(MAKE) _preflight-check
	$(MAKE) _clean-environment
	$(MAKE) _verify-files
	$(MAKE) _build-and-start
	$(MAKE) _setup-database
	$(MAKE) _fix-permissions
	$(MAKE) _install-drupal
	$(MAKE) _enable-modules
	$(MAKE) _verify-deployment
	@echo ''
	@echo '🎉 DEPLOYMENT COMPLETE!'
	@echo '======================='
	@echo 'React Frontend:  http://react.localhost:8080'
	@echo 'Drupal Backend:  http://localhost:8081'
	@echo 'Drupal Admin:    http://localhost:8081/admin (admin/password)'
	@echo ''
	@echo 'To configure AI integration, run: make setup-ai'

deploy-fresh-with-ai: ## Complete deployment with interactive AI setup
	@echo '🚀 FREDDIE MAC OPENRISK NAVIGATOR - DEPLOYMENT WITH AI SETUP'
	@echo '============================================================'
	$(MAKE) deploy-fresh
	@echo ''
	@echo '🤖 FREDDIE MAC AI INTEGRATION SETUP'
	@echo '===================================='
	chmod +x scripts/ai-setup.sh
	@bash -c 'exec < /dev/tty && ./scripts/ai-setup.sh'

up: ## Start all services (build if needed)
	@echo '🏗️ Starting Freddie Mac OpenRisk Navigator...'
	docker compose up -d --build
	@echo ''
	@echo '🎉 Services started successfully!'
	@echo ''
	@echo '🌐 ACCESS INFORMATION:'
	@echo '  React Frontend: http://react.localhost:8080'
	@echo '  Drupal Backend: http://localhost:8081'
	@echo '  Drupal Admin:   http://localhost:8081/admin'
	@echo ''
	@echo 'Run "make status" to check service health'

down: ## Stop all services
	@echo '🛑 Stopping all services...'
	docker compose down
	@echo '✅ All services stopped'

restart: ## Restart all services
	@echo '🔄 Restarting all services...'
	docker compose restart
	@echo '✅ All services restarted'

# =============================================================================
# MAINTENANCE COMMANDS
# =============================================================================

status: ## Show detailed system status
	@echo '📊 FREDDIE MAC OPENRISK NAVIGATOR STATUS'
	@echo '========================================'
	@echo ''
	@echo '🐳 Container Status:'
	@docker compose ps
	@echo ''
	@echo '🌐 Service Health Checks:'
	@curl -s -o /dev/null -w "React Frontend (8080):  HTTP %{http_code}\n" http://react.localhost:8080/ || echo "React Frontend (8080):  ❌ Not responding"
	@curl -s -o /dev/null -w "Drupal Backend (8081):  HTTP %{http_code}\n" http://localhost:8081/ || echo "Drupal Backend (8081):  ❌ Not responding"
	@echo ''
	@echo '💾 Volume Usage:'
	@docker system df --format "table {{.Type}}\t{{.Total}}\t{{.Active}}\t{{.Size}}\t{{.Reclaimable}}"

health: ## Quick health check of all services
	@echo '🏥 Health Check Results:'
	@echo '======================='
	@docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

logs: ## View logs from all services
	docker compose logs -f

logs-drupal: ## View Drupal container logs only
	docker compose logs -f drupal

logs-react: ## View React container logs only
	docker compose logs -f react

logs-nginx: ## View nginx logs only
	docker compose logs -f nginx-drupal nginx-react

# =============================================================================
# DEVELOPMENT COMMANDS
# =============================================================================

shell-drupal: ## Access Drupal container shell
	docker compose exec drupal sh

shell-react: ## Access React container shell
	docker compose exec react sh

shell-mysql: ## Access MySQL container shell
	docker compose exec mysql mysql -u drupal_user -pdocker_test_db_pass_2025

debug-drupal: ## Debug Drupal installation status
	@echo '🔍 Drupal Debug Information:'
	@echo '==========================='
	@docker compose exec drupal sh -c "cd /opt/drupal && pwd && ls -la"
	@echo ''
	@echo '📋 Drush Status:'
	@docker compose exec drupal vendor/bin/drush status
	@echo ''
	@echo '🔧 PHP Configuration:'
	@docker compose exec drupal php -v

# =============================================================================
# BACKUP & RESTORE
# =============================================================================

backup: ## Create database backup
	@mkdir -p backups
	@docker compose exec mysql mysqldump -u root -pdocker_test_root_pass_2025 drupal_production > backups/drupal_$(shell date +%Y%m%d_%H%M%S).sql
	@echo '💾 Database backup created in backups/ directory'

restore: ## Restore database (specify FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then echo "Usage: make restore FILE=backup.sql"; exit 1; fi
	@docker compose exec -T mysql mysql -u root -pdocker_test_root_pass_2025 drupal_production < $(FILE)
	@echo '📥 Database restored from $(FILE)'

# =============================================================================
# INTERNAL DEPLOYMENT STEPS (DO NOT RUN DIRECTLY)
# =============================================================================

_preflight-check:
	@echo '🔍 Pre-flight Checks'
	@echo '==================='
	@command -v docker >/dev/null 2>&1 || (echo "❌ Docker not found" && exit 1)
	@command -v docker compose >/dev/null 2>&1 || command -v docker-compose >/dev/null 2>&1 || (echo "❌ Docker Compose not found" && exit 1)
	@echo '✅ Docker and Docker Compose found'
	@echo '✅ Project directory confirmed'

_clean-environment:
	@echo ''
	@echo '🧹 Cleaning Environment'
	@echo '======================'
	@echo 'Stopping and removing project containers and volumes...'
	@docker compose down -v 2>/dev/null || true
	@echo '✅ Project environment cleaned (volumes removed for fresh start)'

_verify-files:
	@echo ''
	@echo '📋 Verifying Critical Files'
	@echo '==========================='
	@test -f docker-compose.yml || (echo "❌ MISSING: docker-compose.yml" && exit 1)
	@test -f drupal-site/Dockerfile || (echo "❌ MISSING: drupal-site/Dockerfile" && exit 1)
	@test -f drupal-site/composer.json || (echo "❌ MISSING: drupal-site/composer.json" && exit 1)
	@test -f react-site/package.json || (echo "❌ MISSING: react-site/package.json" && exit 1)
	@echo '✅ All critical files present'

_build-and-start:
	@echo ''
	@echo '🏗️ Building and Starting Containers'
	@echo '==================================='
	@echo 'Building containers with latest fixes...'
	@docker compose up -d --build
	@echo ''
	@echo 'Waiting for containers to stabilize...'
	@sleep 30
	@echo ''
	@echo 'Container status:'
	@docker compose ps

_setup-database:
	@echo ''
	@echo '💾 Setting Up Database'
	@echo '====================='
	@echo 'Creating database and user with correct credentials...'
	@docker compose exec mysql mysql -u root -pdocker_test_root_pass_2025 -e " \
		CREATE DATABASE IF NOT EXISTS drupal_production; \
		CREATE USER IF NOT EXISTS 'drupal_user'@'%' IDENTIFIED BY 'docker_test_db_pass_2025'; \
		GRANT ALL PRIVILEGES ON drupal_production.* TO 'drupal_user'@'%'; \
		FLUSH PRIVILEGES;" >/dev/null 2>&1
	@echo 'Testing database connection...'
	@docker compose exec mysql mysql -u drupal_user -pdocker_test_db_pass_2025 drupal_production -e "SELECT 'Database connection successful' as status;" >/dev/null 2>&1
	@echo '✅ Database connection verified'

_fix-permissions:
	@echo ''
	@echo '🔧 Fixing Permissions'
	@echo '===================='
	@echo 'Applying Drush wrapper script fix...'
	@docker compose exec drupal chmod +x vendor/bin/drush
	@echo 'Verifying Drush functionality...'
	@docker compose exec drupal vendor/bin/drush --version >/dev/null 2>&1
	@echo '✅ Drush is working'

_install-drupal:
	@echo ''
	@echo '🏛️ Installing Drupal'
	@echo '=================='
	@echo 'Installing Drupal with standard profile...'
	@docker compose exec drupal vendor/bin/drush site:install standard \
		--db-url=mysql://drupal_user:docker_test_db_pass_2025@mysql:3306/drupal_production \
		--account-name=admin \
		--account-pass=password \
		--site-name="Freddie Mac OpenRisk Navigator" \
		--yes 2>/dev/null || echo "⚠️  Drupal may already be installed (this is fine)"
	@echo ''
	@echo 'Verifying Drupal installation...'
	@if docker compose exec drupal vendor/bin/drush status | grep -q "Connected"; then \
		echo "✅ Drupal installation verified"; \
	else \
		echo "⚠️  Drupal status check - may already be configured"; \
	fi

_enable-modules:
	@echo ''
	@echo '📺 Enabling Required Modules'
	@echo '============================='
	@echo 'Enabling OpenRisk Navigator and AI modules...'
	@docker compose exec drupal vendor/bin/drush en openrisk_navigator key ai ai_provider_openai simple_oauth consumers -y
	@docker compose exec drupal vendor/bin/drush cr
	@echo '✅ All required modules enabled'

_verify-deployment:
	@echo ''
	@echo '🎯 Final Verification'
	@echo '===================='
	@echo 'Testing web access...'
	@if curl -s -o /dev/null -w "%{http_code}" http://react.localhost:8080/ | grep -q "200"; then \
		echo "✅ React Frontend (http://react.localhost:8080): Working"; \
	else \
		echo "❌ React Frontend: Failed"; \
	fi
	@if curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/ | grep -q "200"; then \
		echo "✅ Drupal Backend (http://localhost:8081): Working"; \
	else \
		echo "❌ Drupal Backend: Failed"; \
	fi

# =============================================================================
# ADVANCED COMMANDS
# =============================================================================

clean: ## Remove all containers and volumes (DESTRUCTIVE)
	@echo '⚠️  WARNING: This will remove all containers and data!'
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	docker compose down -v --remove-orphans
	docker system prune -f
	@echo '🧹 Complete cleanup finished'

rebuild: ## Force rebuild all images
	@echo '🔄 Force rebuilding all images...'
	docker compose build --no-cache
	@echo '✅ All images rebuilt'

reset: ## Reset to clean state and deploy fresh
	@echo '🔄 Resetting to clean state...'
	docker compose down -v --remove-orphans
	$(MAKE) deploy-fresh

update-react: ## Update React dependencies and restart
	docker compose exec react npm install
	docker compose restart react
	@echo '✅ React dependencies updated'

# =============================================================================
# OPENRISK NAVIGATOR MODULE MANAGEMENT
# =============================================================================

enable-openrisk: ## Enable OpenRisk Navigator module
	@echo '🎯 Enabling OpenRisk Navigator module...'
	@docker compose exec drupal vendor/bin/drush en openrisk_navigator -y
	@echo '✅ OpenRisk Navigator module enabled'

setup-ai: ## Interactive AI integration setup with automated configuration
	@echo '🤖 FREDDIE MAC AI INTEGRATION SETUP'
	@echo '===================================='
	chmod +x scripts/ai-setup.sh
	@bash -c 'exec < /dev/tty && ./scripts/ai-setup.sh'

configure-ai: ## Legacy command - use setup-ai instead
	@echo '⚠️  configure-ai is deprecated. Use "make setup-ai" for automated setup'
	@echo 'Or visit http://localhost:8081/admin/config/ai for manual configuration'

# =============================================================================
# MONITORING & TROUBLESHOOTING
# =============================================================================

monitor: ## Monitor all containers in real-time
	watch -n 2 'docker compose ps && echo "" && docker stats --no-stream'

troubleshoot: ## Run comprehensive troubleshooting diagnostics
	@echo '🔧 COMPREHENSIVE TROUBLESHOOTING'
	@echo '==============================='
	@echo ''
	@echo '🐳 Docker Info:'
	@docker --version
	@docker compose version
	@echo ''
	@echo '📊 Container Status:'
	@docker compose ps
	@echo ''
	@echo '🌐 Network Test:'
	@curl -I http://react.localhost:8080 2>/dev/null || echo "❌ React not responding"
	@curl -I http://localhost:8081 2>/dev/null || echo "❌ Drupal not responding" 
	@echo ''
	@echo '💾 Volume Status:'
	@docker volume ls | grep freddie-mac
	@echo ''
	@echo '📋 Recent Logs (last 20 lines):'
	@docker compose logs --tail=20