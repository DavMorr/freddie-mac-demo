#!/bin/bash

# FREDDIE MAC OPENRISK NAVIGATOR - PRODUCTION AI SETUP
# Automated AI integration following exact procedural dependency order
# Adapted from development setup for Docker container environment

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
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

print_info() {
    echo -e "${CYAN}${NC} $1"
}

echo "FREDDIE MAC OPENRISK NAVIGATOR - AI INTEGRATION SETUP"
echo "====================================================="
echo "Following exact procedural dependency order for production"
echo ""

# Verify containers are running
print_status "Verifying container environment..."
if ! docker compose ps | grep -q "drupal.*Up"; then
    print_error "Drupal container not running. Please run 'make up' first."
    exit 1
fi

if ! docker compose exec drupal vendor/bin/drush status --field=bootstrap 2>/dev/null | grep -q "Successful"; then
    print_error "Drupal not bootstrapped. Please run 'make deploy-fresh' first."
    exit 1
fi

print_success "Container environment verified"
echo ""

# =============================================================================
# STEP 1: ACCOUNTS [/admin/people] - ALWAYS CREATE
# =============================================================================
print_status "Step 1: API User Account Configuration"
print_status "======================================"

# Helper function to check if API user exists
check_api_user_exists() {
    if docker compose exec drupal vendor/bin/drush user:information api_user >/dev/null 2>&1; then
        return 0  # User exists
    else
        return 1  # User doesn't exist
    fi
}

if check_api_user_exists; then
    print_success "API user 'api_user' already exists"
else
    print_status "Creating API user 'api_user'..."
    docker compose exec drupal vendor/bin/drush user:create api_user \
        --mail="api_user@localhost:8081" \
        --password="password"
    
    if check_api_user_exists; then
        print_success "API user created successfully"
    else
        print_error "Failed to create API user"
        exit 1
    fi
fi

echo ""

# =============================================================================
# STEP 2: CHOICE POINT - OpenAI Setup Prompt
# =============================================================================
print_info "AI Integration Setup"
print_info "==================="
print_info "The OpenRisk Navigator can use AI for automated risk analysis."
print_info "This requires an OpenAI API key and internet connectivity."
echo ""

# Helper function to check if OpenAI key exists
check_openai_key_exists() {
    if docker compose exec drupal vendor/bin/drush config:get key.key.openai_api_key >/dev/null 2>&1; then
        return 0  # Key exists
    else
        return 1  # Key doesn't exist
    fi
}

# Helper function to check if AI provider is configured
check_ai_provider_configured() {
    if docker compose exec drupal vendor/bin/drush config-get ai_provider_openai.settings >/dev/null 2>&1; then
        return 0  # Config exists
    else
        return 1  # Config doesn't exist
    fi
}

# Check if OpenAI is already configured
if check_openai_key_exists && check_ai_provider_configured; then
    print_success "OpenAI integration already configured"
    SETUP_AI="configured"
else
    echo -n -e "${BLUE}▶${NC} Would you like to configure OpenAI for automated AI risk analysis? (y/n): "
    read -r AI_RESPONSE
    
    if [[ $AI_RESPONSE =~ ^[Yy]$ ]]; then
        SETUP_AI="yes"
        
        # Prompt for OpenAI API key
        echo ""
        print_info "You'll need an OpenAI API key from: https://platform.openai.com/api-keys"
        echo ""
        echo -n -e "${BLUE}▶${NC} Enter your OpenAI API key: "
        read OPENAI_API_KEY
        
        if [ -z "$OPENAI_API_KEY" ]; then
            print_warning "No API key provided - skipping AI configuration"
            SETUP_AI="no"
        else
            # Validate API key format (basic check)
            if [[ ! "$OPENAI_API_KEY" =~ ^sk-[A-Za-z0-9] ]]; then
                print_warning "API key format looks incorrect (should start with 'sk-')"
                print_warning "Continuing anyway - you can reconfigure later if needed"
            fi
            print_success "OpenAI API key received"
        fi
    else
        SETUP_AI="no"
        print_info "Skipping AI configuration - see README.md for manual setup instructions"
    fi
fi

echo ""

# =============================================================================
# CONDITIONAL SETUP: Only proceed if user chose OpenAI
# =============================================================================
if [ "$SETUP_AI" = "yes" ]; then
    
    # =========================================================================
    # STEP 3: KEYS [/admin/config/system/keys] - REQUIRES USER INPUT
    # =========================================================================
    print_status "Step 3: OpenAI Key Configuration"
    print_status "================================"
    
    if check_openai_key_exists; then
        print_status "Updating existing OpenAI key..."
        docker compose exec drupal vendor/bin/drush php:eval "
            \$key = \Drupal::entityTypeManager()->getStorage('key')->load('openai_api_key');
            if (\$key) {
                \$key->delete();
            }
            \$new_key = \Drupal\key\Entity\Key::create([
                'id' => 'openai_api_key',
                'label' => 'OpenAI API Key for Risk Assessment',
                'description' => 'OpenAI API Key for Risk Assessment',
                'key_type' => 'authentication',
                'key_provider' => 'config',
                'key_input' => 'text_field',
                'key_provider_settings' => [
                    'key_value' => '$OPENAI_API_KEY'
                ]
            ]);
            \$new_key->save();
        "
    else
        print_status "Creating OpenAI key configuration..."
        docker compose exec drupal vendor/bin/drush php:eval "
            \$key = \Drupal\key\Entity\Key::create([
                'id' => 'openai_api_key',
                'label' => 'OpenAI API Key for Risk Assessment',
                'description' => 'OpenAI API Key for Risk Assessment',
                'key_type' => 'authentication',
                'key_provider' => 'config',
                'key_input' => 'text_field',
                'key_provider_settings' => [
                    'key_value' => '$OPENAI_API_KEY'
                ]
            ]);
            \$key->save();
        "
    fi
    
    # Verify key was created/updated
    if check_openai_key_exists; then
        print_success "OpenAI key configured successfully"
    else
        print_error "Failed to configure OpenAI key"
        exit 1
    fi
    
    echo ""
    
    # =========================================================================
    # STEP 4: SIMPLE OAUTH SCOPES - VERIFY EXISTS
    # =========================================================================
    print_status "Step 4: OAuth2 Scope Verification"
    print_status "================================="
    
    # Helper function to check if OAuth2 scope exists
    check_oauth2_scope_exists() {
        local result=$(docker compose exec drupal vendor/bin/drush php:eval '
            try {
                $query = \Drupal::entityQuery("oauth2_scope");
                $query->condition("name", "loan_record:view");
                $query->accessCheck(FALSE);
                print $query->count()->execute();
            } catch (Exception $e) {
                print "0";
            }
        ' 2>/dev/null)
        
        if [ "$result" = "1" ]; then
            return 0  # Scope exists
        else
            return 1  # Scope doesn't exist
        fi
    }
    
    if check_oauth2_scope_exists; then
        print_success "OAuth2 scope 'loan_record:view' verified"
    else
        print_warning "OAuth2 scope 'loan_record:view' not found"
        print_warning "This should have been created by the OpenRisk Navigator module"
        print_warning "Continuing with Consumer setup - scope may be created automatically"
    fi
    
    echo ""
    
    # =========================================================================
    # STEP 5: CONSUMER [/admin/config/services/consumer] - DEPENDS ON STEPS 1 & 4
    # =========================================================================
    print_status "Step 5: OAuth2 Consumer Configuration"
    print_status "====================================="
    
    # Helper function to check if OAuth2 consumer exists
    check_oauth2_consumer_exists() {
        local result=$(docker compose exec drupal vendor/bin/drush php:eval '
            try {
                $query = \Drupal::entityQuery("consumer");
                $query->condition("client_id", "openrisk_navigator");
                $query->accessCheck(FALSE);
                print $query->count()->execute();
            } catch (Exception $e) {
                print "0";
            }
        ' 2>/dev/null)
        
        if [ "$result" = "1" ]; then
            return 0  # Consumer exists
        else
            return 1  # Consumer doesn't exist
        fi
    }
    
    if check_oauth2_consumer_exists; then
        print_success "OAuth2 consumer 'openrisk_navigator' already exists"
    else
        print_status "Creating OAuth2 consumer 'openrisk_navigator'..."
        
        # Clear cache and wait for Simple OAuth to fully initialize
        docker compose exec drupal vendor/bin/drush cr
        sleep 3
        
        # Create OAuth2 consumer
        docker compose exec drupal vendor/bin/drush php:eval "
            try {
                // Get api_user ID
                \$query = \Drupal::entityQuery('user');
                \$query->condition('name', 'api_user');
                \$query->accessCheck(FALSE);
                \$uids = \$query->execute();
                \$user_id = !empty(\$uids) ? reset(\$uids) : NULL;
                
                if (!\$user_id) {
                    throw new Exception('api_user not found');
                }
                
                // Create consumer
                \$consumer = \Drupal\consumers\Entity\Consumer::create([
                    'client_id' => 'openrisk_navigator',
                    'label' => 'OpenRisk Navigator App',
                    'secret' => 'password',
                    'grant_types' => ['client_credentials'],
                    'scopes' => ['loan_record:view'],
                    'user_id' => \$user_id,
                    'is_confidential' => TRUE,
                    'access_token_expiration' => 300,
                ]);
                \$consumer->save();
                print 'Consumer created successfully';
            } catch (Exception \$e) {
                print 'Error: ' . \$e->getMessage();
            }
        "
        
        # Verify consumer was created
        if check_oauth2_consumer_exists; then
            print_success "OAuth2 consumer created successfully"
        else
            print_warning "OAuth2 consumer creation may have failed"
            print_warning "You can create it manually at: http://localhost:8081/admin/config/services/consumer"
        fi
    fi
    
    echo ""
    
    # =========================================================================
    # STEP 6: AI PROVIDERS [/admin/config/ai/providers/openai] - DEPENDS ON STEP 3
    # =========================================================================
    print_status "Step 6: AI Provider Configuration"
    print_status "================================="
    
    print_status "Configuring OpenAI provider with API key and models..."
    
    # Configure OpenAI provider settings
    docker compose exec drupal vendor/bin/drush config:set ai_provider_openai.settings api_key openai_api_key -y
    
    # Configure specific OpenAI models as per documentation
    docker compose exec drupal vendor/bin/drush config:set ai_provider_openai.settings chat_model gpt-4o -y
    docker compose exec drupal vendor/bin/drush config:set ai_provider_openai.settings embeddings_model text-embedding-3-small -y
    docker compose exec drupal vendor/bin/drush config:set ai_provider_openai.settings text_to_image_model dall-e-3 -y
    docker compose exec drupal vendor/bin/drush config:set ai_provider_openai.settings text_to_speech_model tts-1-hd -y
    docker compose exec drupal vendor/bin/drush config:set ai_provider_openai.settings speech_to_text_model whisper-1 -y
    docker compose exec drupal vendor/bin/drush config:set ai_provider_openai.settings moderation_model omni-moderation-latest -y
    
    # Clear cache after provider configuration
    docker compose exec drupal vendor/bin/drush cr
    
    print_success "OpenAI provider configured with specific models"
    
    echo ""
    
    # =========================================================================
    # STEP 7: AI SETTINGS [/admin/config/ai/settings] - DEPENDS ON STEP 6
    # =========================================================================
    print_status "Step 7: AI Settings Configuration"
    print_status "================================="
    
    # Set OpenAI as default provider with specific models as per documentation
    print_status "Setting OpenAI as default provider with documented model specifications..."
    
    # Configure AI default settings with exact models from documentation
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.embeddings openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.embeddings text-embedding-3-small -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.chat openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.chat gpt-4o -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.text_to_image openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.text_to_image dall-e-3 -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.text_to_speech openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.text_to_speech tts-1-hd -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.speech_to_text openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.speech_to_text whisper-1 -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.moderation openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.moderation omni-moderation-latest -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.chat_with_image_vision openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.chat_with_image_vision gpt-4o -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.chat_with_complex_json openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.chat_with_complex_json gpt-4o -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.chat_with_structured_response openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.chat_with_structured_response gpt-4.1 -y
    
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_providers.chat_with_tools_function_calling openai -y
    docker compose exec drupal vendor/bin/drush config:set ai.settings default_models.chat_with_tools_function_calling gpt-4.1 -y
    
    # Clear cache after AI settings configuration
    docker compose exec drupal vendor/bin/drush cr
    
    print_success "AI settings configured with documented default models"
    
    echo ""
    
    # =========================================================================
    # FINAL AI SETUP VALIDATION
    # =========================================================================
    print_status "Final AI Setup Validation"
    print_status "========================="
    
    # Test AI configuration
    print_status "Testing AI configuration..."
    
    AI_TEST_RESULT=$(docker compose exec drupal vendor/bin/drush php:eval "
        try {
            \$ai_provider = \Drupal::service('ai.provider.openai');
            if (\$ai_provider) {
                print 'AI provider service available';
            } else {
                print 'AI provider service not available';
            }
        } catch (Exception \$e) {
            print 'Error: ' . \$e->getMessage();
        }
    " 2>/dev/null)
    
    if echo "$AI_TEST_RESULT" | grep -q "AI provider service available"; then
        print_success "AI configuration validation passed"
    else
        print_warning "AI configuration validation failed: $AI_TEST_RESULT"
        print_warning "Manual verification may be needed"
    fi
    
else
    # User chose not to configure AI
    print_warning "AI INTEGRATION SKIPPED"
    print_warning "====================="
    print_info "To configure AI manually later:"
    print_info "1. Visit: http://localhost:8081/admin/config/system/keys"
    print_info "2. Create OpenAI API key configuration"
    print_info "3. Visit: http://localhost:8081/admin/config/ai/providers"
    print_info "4. Configure OpenAI provider"
    print_info "5. Visit: http://localhost:8081/admin/config/services/consumer"
    print_info "6. Create OAuth2 consumer for API access"
    print_info ""
    print_info "See README.md for detailed manual setup instructions"
fi

echo ""

# =============================================================================
# SAMPLE DATA SEEDING OPTION
# =============================================================================
print_status "Sample Data Configuration"
print_status "========================"

# Check if sample data already exists
EXISTING_LOANS=$(docker compose exec drupal vendor/bin/drush php:eval "
    \$query = \Drupal::entityQuery('loan_record');
    \$query->accessCheck(FALSE);
    print \$query->count()->execute();
" 2>/dev/null)

if [ "$EXISTING_LOANS" -gt 0 ]; then
    print_success "Sample data already exists ($EXISTING_LOANS loan records)"
else
    echo -n -e "${BLUE}▶${NC} Would you like to create sample loan records for testing? (y/n): "
    read -r SEED_RESPONSE
    
    if [[ $SEED_RESPONSE =~ ^[Yy]$ ]]; then
        echo -n -e "${BLUE}▶${NC} How many loan records would you like to create? (default: 10): "
        read SEED_COUNT
        SEED_COUNT=${SEED_COUNT:-10}  # Default to 10 if empty
        
        print_status "Creating $SEED_COUNT sample loan records..."
        
        SEEDER_RESULT=$(docker compose exec drupal vendor/bin/drush php:eval "
            \$count = $SEED_COUNT;
            if (\Drupal::hasService('openrisk_navigator.loan_record_seeder')) {
                \$seeder = \Drupal::service('openrisk_navigator.loan_record_seeder');
                try {
                    \$seeder->seed(\$count);
                    print \"Created \" . \$count . \" loan records\";
                } catch (Exception \$e) {
                    print \"Seeder error: \" . \$e->getMessage();
                }
            } else {
                print 'Seeder service not available';
            }
        " 2>/dev/null)
        
        if echo "$SEEDER_RESULT" | grep -q "Created"; then
            print_success "Sample data generation complete: $SEEDER_RESULT"
        else
            print_warning "Sample data generation issue: $SEEDER_RESULT"
        fi
    else
        print_info "Skipping sample data creation"
    fi
fi

echo ""

# =============================================================================
# FINAL SUCCESS SUMMARY
# =============================================================================
print_success "AI INTEGRATION SETUP COMPLETE!"
echo "============================================="
echo ""
print_status "CONFIGURATION SUMMARY:"
print_status "   API User: api_user (password: password)"

if [ "$SETUP_AI" = "yes" ] || [ "$SETUP_AI" = "configured" ]; then
    print_success "AI INTEGRATION: CONFIGURED"
    print_status "   OpenAI API Key: Configured"
    print_status "   AI Provider: OpenAI (all functions)"
    print_status "   OAuth2 Consumer: openrisk_navigator"
    print_status ""
    print_status "TEST AI INTEGRATION:"
    print_status "   1. Visit: http://localhost:8081/admin/structure/loan-record-settings"
    print_status "   2. Create a new loan record"
    print_status "   3. Verify AI risk analysis generates in risk_summary field"
else
    print_warning "AI INTEGRATION: NOT CONFIGURED"
    print_status "   OAuth2 Consumer: Manual setup required"
    print_status "   AI Provider: Manual setup required"
    print_status ""
    print_status "MANUAL SETUP:"
    print_status "   See README.md 'AI Provider Setup' section"
fi

echo ""
print_status "ACCESS POINTS:"
print_status "   React Frontend:  http://reactlocalhost:8080"
print_status "   Drupal Admin: http://localhost:8081/admin"
print_status "   AI Settings: http://localhost:8081/admin/config/ai"
print_status "   OAuth2 Config: http://localhost:8081/admin/config/services/consumer"
print_status "   API Keys: http://localhost:8081/admin/config/system/keys"
print_status "   JSON API: http://localhost:8081/jsonapi/loan_record/loan_record"
echo ""
print_status "CREDENTIALS:"
print_status "   Drupal Admin: admin / password"
print_status "   API User: api_user / password"
print_status "   OAuth2 Consumer: openrisk_navigator / password"
echo ""
print_success "Ready for loan risk analysis testing!"
