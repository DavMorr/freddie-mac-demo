#!/bin/bash

echo "=========================================================================="
echo "🔧 FREDDIE MAC OPENRISK NAVIGATOR - AI FIX AND COMPREHENSIVE TEST"
echo "=========================================================================="
echo "Testing AI integration with corrected Key module API and full diagnostics"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_section() {
    echo ""
    echo -e "${BLUE}=================================================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=================================================================================${NC}"
}

print_test() {
    echo ""
    echo -e "${YELLOW}🔬 $1${NC}"
    echo "---------------------------------------------------------------------------------"
}

print_result() {
    if [[ $1 == *"SUCCESS"* ]] || [[ $1 == *"AVAILABLE"* ]] || [[ $1 == *"YES"* ]] || [[ $1 == *"POPULATED"* ]]; then
        echo -e "${GREEN}✅ $1${NC}"
    elif [[ $1 == *"FAILED"* ]] || [[ $1 == *"NOT AVAILABLE"* ]] || [[ $1 == *"NO"* ]] || [[ $1 == *"EMPTY"* ]]; then
        echo -e "${RED}❌ $1${NC}"
    else
        echo "$1"
    fi
}

# =============================================================================
# STEP 1: FIX OPENAI KEY WITH CORRECT API
# =============================================================================
print_section "STEP 1: Fix OpenAI Key Creation (Correct Key Module API)"

print_test "Recreating OpenAI key with proper Key module configuration"

# IMPORTANT: Replace 'PUT_YOUR_ACTUAL_OPENAI_API_KEY_HERE' with your real OpenAI API key
OPENAI_API_KEY="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"

if [ "$OPENAI_API_KEY" = "PUT_YOUR_ACTUAL_OPENAI_API_KEY_HERE" ]; then
    echo -e "${RED}❌ ERROR: You must edit this script and replace 'PUT_YOUR_ACTUAL_OPENAI_API_KEY_HERE' with your actual OpenAI API key${NC}"
    echo "Edit this script at line $(grep -n "PUT_YOUR_ACTUAL_OPENAI_API_KEY_HERE" "$0" | head -1 | cut -d: -f1) and try again"
    exit 1
fi

RESULT1=$(ddev drush php:eval "
\$key_storage = \Drupal::entityTypeManager()->getStorage('key');
\$existing_key = \$key_storage->load('openai_api_key');
if (\$existing_key) {
    \$existing_key->delete();
    print 'Deleted existing key | ';
}

// Create key with CORRECT configuration
\$key = \$key_storage->create([
    'id' => 'openai_api_key',
    'label' => 'OpenAI API Key for Risk Assessment',
    'description' => 'OpenAI API Key for Risk Assessment',
    'key_type' => 'authentication',
    'key_provider' => 'config',
    'key_input' => 'text_field',  // THIS WAS THE MISSING PIECE!
    'key_provider_settings' => [
        'key_value' => '$OPENAI_API_KEY'  // CORRECT WAY TO SET VALUE
    ]
]);

try {
    \$result = \$key->save();
    print 'Key creation result: ' . \$result . ' | ';
    
    // Verify the key was saved correctly
    \$reloaded = \$key_storage->load('openai_api_key');
    if (\$reloaded) {
        \$key_value = \$reloaded->getKeyValue();
        print 'Key length: ' . strlen(\$key_value) . ' | ';
        print 'Key prefix: ' . substr(\$key_value, 0, 10) . '... | ';
        
        // Test key access through repository
        \$key_repo = \Drupal::service('key.repository');
        \$repo_key = \$key_repo->getKey('openai_api_key');
        if (\$repo_key && \$repo_key->getKeyValue()) {
            print 'Repository access: SUCCESS';
        } else {
            print 'Repository access: FAILED';
        }
    } else {
        print 'Verification: FAILED - Key not found after save';
    }
} catch (Exception \$e) {
    print 'Key creation FAILED: ' . \$e->getMessage();
}
" 2>&1)
print_result "$RESULT1"

# =============================================================================
# STEP 2: TEST AI SERVICES WITH FIXED KEY
# =============================================================================
print_section "STEP 2: Test AI Services with Fixed Key"

print_test "Testing AI provider services with properly configured OpenAI key"
RESULT2=$(ddev drush php:eval "
// Test 1: Key repository access
\$key = \Drupal::service('key.repository')->getKey('openai_api_key');
print 'Key repository: ' . (\$key && \$key->getKeyValue() ? 'SUCCESS' : 'FAILED') . ' | ';

// Test 2: AI provider configuration
\$config = \Drupal::config('ai_provider_openai.settings');
\$api_key_setting = \$config->get('api_key');
print 'Provider config: ' . (\$api_key_setting ? 'YES' : 'NO') . ' | ';

// Test 3: Available AI services
\$available_services = [];
\$container = \Drupal::getContainer();
foreach (['ai.provider', 'ai_provider_openai.helper', 'plugin.manager.ai_agents'] as \$service) {
    if (\$container->has(\$service)) {
        \$available_services[] = \$service;
    }
}
print 'Available services: ' . implode(', ', \$available_services);
" 2>&1)
print_result "$RESULT2"

# =============================================================================
# STEP 3: TEST OPENAI PROVIDER DIRECT CONNECTION
# =============================================================================
print_section "STEP 3: Test OpenAI Provider Direct Connection"

print_test "Testing direct OpenAI API connectivity through available services"
RESULT3=$(ddev drush php:eval "
try {
    // Try the OpenAI helper service first
    \$openai_helper = \Drupal::service('ai_provider_openai.helper');
    print 'OpenAI helper service: AVAILABLE | ';
    
    // Try to get the configured provider
    \$provider_manager = \Drupal::service('plugin.manager.ai_provider');
    if (\$provider_manager) {
        \$definitions = \$provider_manager->getDefinitions();
        print 'Provider manager: AVAILABLE | ';
        print 'Definitions: ' . implode(', ', array_keys(\$definitions)) . ' | ';
        
        if (isset(\$definitions['openai'])) {
            \$openai_provider = \$provider_manager->createInstance('openai');
            print 'OpenAI provider: CREATED | ';
            
            // Test actual API call
            \$response = \$openai_provider->chat([
                'messages' => [
                    ['role' => 'user', 'content' => 'Respond with exactly: API_TEST_SUCCESS']
                ]
            ]);
            print 'API Test: SUCCESS | Response: ' . trim(\$response);
        } else {
            print 'OpenAI provider: NOT AVAILABLE in definitions';
        }
    } else {
        print 'Provider manager: NOT AVAILABLE';
    }
} catch (Exception \$e) {
    print 'OpenAI Test: FAILED - ' . \$e->getMessage();
}
" 2>&1)
print_result "$RESULT3"

# =============================================================================
# STEP 4: TEST OPENRISK NAVIGATOR RISK MANAGER
# =============================================================================
print_section "STEP 4: Test OpenRisk Navigator Risk Manager"

print_test "Testing OpenRisk Navigator specific risk analysis service"
RESULT4=$(ddev drush php:eval "
if (\Drupal::hasService('openrisk_navigator.loan_risk_manager')) {
    try {
        \$risk_manager = \Drupal::service('openrisk_navigator.loan_risk_manager');
        print 'Risk Manager service: AVAILABLE | ';
        
        // Check available methods
        \$methods = get_class_methods(\$risk_manager);
        print 'Available methods: ' . implode(', ', \$methods) . ' | ';
        
        // Try to find a risk analysis method
        \$risk_methods = array_filter(\$methods, function(\$method) {
            return stripos(\$method, 'risk') !== false || stripos(\$method, 'analyz') !== false || stripos(\$method, 'generate') !== false;
        });
        
        if (!empty(\$risk_methods)) {
            print 'Risk methods found: ' . implode(', ', \$risk_methods);
        } else {
            print 'No obvious risk analysis methods found';
        }
        
    } catch (Exception \$e) {
        print 'Risk Manager: FAILED - ' . \$e->getMessage();
    }
} else {
    print 'Risk Manager Service: NOT AVAILABLE';
}
" 2>&1)
print_result "$RESULT4"

# =============================================================================
# STEP 5: TEST AI DEFAULT CONFIGURATION
# =============================================================================
print_section "STEP 5: Configure and Test AI Defaults"

print_test "Setting up AI default provider configuration"
RESULT5a=$(ddev drush config:set ai.settings default_providers.chat openai -y 2>&1)
RESULT5b=$(ddev drush config:set ai.settings default_providers.embeddings openai -y 2>&1) 
RESULT5c=$(ddev drush cr 2>&1)

print_test "Verifying AI default configuration"
RESULT5=$(ddev drush php:eval "
try {
    \$ai_settings = \Drupal::config('ai.settings');
    \$defaults = \$ai_settings->get('default_providers');
    
    if (\$defaults) {
        print 'AI defaults configured: YES | ';
        foreach (\$defaults as \$service => \$provider) {
            print \$service . ': ' . \$provider . ' | ';
        }
        
        // Try to use the main AI service now
        if (\Drupal::hasService('ai')) {
            \$ai_service = \Drupal::service('ai');
            print 'Main AI service: AVAILABLE | ';
            
            try {
                \$response = \$ai_service->chat('Respond with: MAIN_AI_SUCCESS');
                print 'Main AI test: SUCCESS | Response: ' . trim(\$response);
            } catch (Exception \$e) {
                print 'Main AI test: FAILED - ' . \$e->getMessage();
            }
        } else {
            print 'Main AI service: NOT AVAILABLE';
        }
    } else {
        print 'AI defaults configured: NO';
    }
} catch (Exception \$e) {
    print 'AI settings check: FAILED - ' . \$e->getMessage();
}
" 2>&1)
print_result "$RESULT5"

# =============================================================================
# STEP 6: TEST ENTITY SAVE WITH AI PROCESSING
# =============================================================================
print_section "STEP 6: Test Entity Save with AI Processing"

print_test "Creating loan record and testing complete AI integration during save"
RESULT6=$(ddev drush php:eval "
// Create test loan record with good data
\$loan_record = \Drupal::entityTypeManager()->getStorage('loan_record')->create([
    'borrower_name' => 'Fixed API Test Borrower ' . date('H:i:s'),
    'loan_amount' => 750000,
    'fico_score' => 800,
    'ltv_ratio' => 70,
    'dti' => 25,
    'borrower_state' => 'CA',
    'defaulted' => FALSE,
]);

print 'Before save - risk_summary: ' . (\$loan_record->get('risk_summary')->value ?: 'EMPTY') . ' | ';

try {
    \$loan_record->save();
    print 'Loan record saved: ID ' . \$loan_record->id() . ' | ';
    
    // Reload from database to check if risk_summary was populated
    \$reloaded = \Drupal::entityTypeManager()->getStorage('loan_record')->load(\$loan_record->id());
    \$risk_summary = \$reloaded->get('risk_summary')->value;
    
    if (!empty(\$risk_summary)) {
        print 'After save - risk_summary: POPULATED | ';
        print 'Content length: ' . strlen(\$risk_summary) . ' chars | ';
        print 'Sample: ' . substr(trim(\$risk_summary), 0, 200) . '...';
    } else {
        print 'After save - risk_summary: STILL EMPTY';
    }
} catch (Exception \$e) {
    print 'Save failed: FAILED - ' . \$e->getMessage();
}
" 2>&1)
print_result "$RESULT6"

# =============================================================================
# STEP 7: CHECK SAVE HOOKS AND MODULE IMPLEMENTATION
# =============================================================================
print_section "STEP 7: Check Save Hooks and Module Implementation"

print_test "Examining OpenRisk Navigator module save hook implementation"
RESULT7=$(ddev drush php:eval "
// Check hook implementations using correct method
\$module_handler = \Drupal::moduleHandler();
\$hooks_found = [];

// Check for hook implementations
\$possible_hooks = [
    'entity_presave',
    'entity_insert', 
    'entity_update',
    'loan_record_presave',
    'loan_record_insert',
    'loan_record_update'
];

foreach (\$possible_hooks as \$hook) {
    if (\$module_handler->hasImplementation('openrisk_navigator', \$hook)) {
        \$hooks_found[] = \$hook;
    }
}

if (!empty(\$hooks_found)) {
    print 'Save hooks implemented: ' . implode(', ', \$hooks_found) . ' | ';
} else {
    print 'No save hooks found | ';
}

// Check if module files exist
\$module_path = \Drupal::service('extension.list.module')->getPath('openrisk_navigator');
\$module_file = \$module_path . '/openrisk_navigator.module';
if (file_exists(\$module_file)) {
    print 'Module file exists: YES | ';
    \$module_content = file_get_contents(\$module_file);
    if (strpos(\$module_content, 'presave') !== false) {
        print 'Contains presave hooks: YES';
    } else {
        print 'Contains presave hooks: NO';
    }
} else {
    print 'Module file exists: NO';
}
" 2>&1)
print_result "$RESULT7"

# =============================================================================
# FINAL ANALYSIS AND SUMMARY
# =============================================================================
print_section "FINAL ANALYSIS AND SUMMARY"

echo ""
echo "🔍 COMPREHENSIVE ANALYSIS:"
echo "=========================="

# Check if key was fixed
if [[ $RESULT1 == *"SUCCESS"* ]]; then
    echo -e "${GREEN}✅ OpenAI Key: FIXED - Proper Key module API used${NC}"
else
    echo -e "${RED}❌ OpenAI Key: FAILED - Key creation still not working${NC}"
fi

# Check if API connectivity works
if [[ $RESULT3 == *"API_TEST_SUCCESS"* ]]; then
    echo -e "${GREEN}✅ OpenAI API: WORKING - Direct API calls successful${NC}"
else
    echo -e "${RED}❌ OpenAI API: FAILED - No successful API connection${NC}"
fi

# Check if main AI service works
if [[ $RESULT5 == *"MAIN_AI_SUCCESS"* ]]; then
    echo -e "${GREEN}✅ Main AI Service: WORKING - Default provider configured${NC}"
else
    echo -e "${RED}❌ Main AI Service: FAILED - Service not accessible${NC}"
fi

# Check if entity save populates AI field
if [[ $RESULT6 == *"POPULATED"* ]]; then
    echo -e "${GREEN}✅ AI Entity Processing: WORKING - risk_summary field populated on save${NC}"
else
    echo -e "${RED}❌ AI Entity Processing: FAILED - risk_summary field still empty${NC}"
fi

# Check if save hooks exist
if [[ $RESULT7 == *"presave"* ]] || [[ $RESULT7 == *"entity_"* ]]; then
    echo -e "${GREEN}✅ Save Hooks: IMPLEMENTED - Found hook implementations${NC}"
else
    echo -e "${RED}❌ Save Hooks: MISSING - No save hooks found in module${NC}"
fi

echo ""
echo "📋 SPECIFIC RECOMMENDATIONS:"
echo "============================="

if [[ $RESULT6 == *"POPULATED"* ]]; then
    echo -e "${GREEN}🎉 SUCCESS! AI integration is now working end-to-end${NC}"
    echo "   - OpenAI API key properly configured"
    echo "   - AI services accessible and responding"  
    echo "   - Entity save triggers AI processing"
    echo "   - risk_summary field populated with AI analysis"
elif [[ $RESULT3 == *"API_TEST_SUCCESS"* ]] && [[ $RESULT6 == *"EMPTY"* ]]; then
    echo -e "${YELLOW}⚠️ API works but entity save doesn't populate field${NC}"
    echo "   - OpenAI API connectivity is working"
    echo "   - Issue is in save hook implementation or field processing"
    echo "   - Check OpenRisk Navigator module's presave hook"
    echo "   - Verify field is configured for AI processing"
else
    echo -e "${RED}❌ Multiple issues need resolution${NC}"
    echo "   - Review each test result above"
    echo "   - Fix API connectivity first if needed"
    echo "   - Then address save hook implementation"
fi

echo ""
echo "🎯 DIAGNOSTIC COMPLETE"
echo "================================================================================"