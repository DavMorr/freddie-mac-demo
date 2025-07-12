#!/bin/bash

echo "🧪 === TESTING OPENRISK NAVIGATOR INSTALLATION AUTOMATION ==="
echo "📅 $(date)"
echo ""

# Navigate to Drupal directory
cd /Users/davidmorrison/Sites2/Production/freddie-mac/drupal-site

echo "1️⃣ === PRE-TEST VERIFICATION ==="
echo "Checking current module status..."
MODULE_STATUS=$(ddev drush pm:list | grep openrisk_navigator | grep Enabled | wc -l)
if [ "$MODULE_STATUS" -gt 0 ]; then
    echo "✅ OpenRisk Navigator module is currently enabled"
else
    echo "❌ OpenRisk Navigator module not enabled - cannot test"
    exit 1
fi

echo ""
echo "Checking current loan records count..."
CURRENT_LOANS=$(ddev drush eval "echo count(\\Drupal::entityTypeManager()->getStorage('loan_record')->loadMultiple());" 2>/dev/null || echo "0")
echo "📊 Current loan records: $CURRENT_LOANS"

echo ""
echo "2️⃣ === TESTING AUTOMATION WITHOUT DATA LOSS ==="
echo "⚠️  Note: This test will NOT delete existing data"
echo "The enhanced install hook should safely handle existing installations"

echo ""
echo "Testing enhanced installation hooks..."
echo "Running drush updatedb to trigger any new install functions..."
ddev drush updatedb -y

echo ""
echo "3️⃣ === VERIFYING AUTOMATION RESULTS ==="

echo ""
echo "📋 Testing Permissions Automation..."
echo "Checking anonymous permissions:"
ANON_PERMS=$(ddev drush eval "
\$role = \\Drupal\\user\\Entity\\Role::load('anonymous');
if (\$role && \$role->hasPermission('view loan_record entities')) {
  echo 'GRANTED';
} else {
  echo 'NOT_GRANTED';
}
" 2>/dev/null)
echo "Anonymous 'view loan_record entities': $ANON_PERMS"

echo "Checking authenticated permissions:"
AUTH_PERMS=$(ddev drush eval "
\$role = \\Drupal\\user\\Entity\\Role::load('authenticated');
if (\$role && \$role->hasPermission('view loan_record entities')) {
  echo 'GRANTED';
} else {
  echo 'NOT_GRANTED';
}
" 2>/dev/null)
echo "Authenticated 'view loan_record entities': $AUTH_PERMS"

echo ""
echo "🔒 Testing OAuth2 Scope Automation..."
OAUTH_SCOPE=$(ddev drush eval "
if (\\Drupal::moduleHandler()->moduleExists('simple_oauth')) {
  \$scope = \\Drupal::entityTypeManager()->getStorage('oauth2_scope')->load('loan_record_view');
  if (\$scope) {
    echo 'EXISTS';
  } else {
    echo 'NOT_FOUND';
  }
} else {
  echo 'SIMPLE_OAUTH_DISABLED';
}
" 2>/dev/null)
echo "OAuth2 scope 'loan_record_view': $OAUTH_SCOPE"

echo ""
echo "🎨 Testing Entity Display Configuration..."
DISPLAY_CONFIG=$(ddev drush eval "
\$display = \\Drupal\\Core\\Entity\\Entity\\EntityViewDisplay::load('loan_record.loan_record.default');
if (\$display) {
  \$components = \$display->getComponents();
  echo 'CONFIGURED (' . count(\$components) . ' components)';
} else {
  echo 'NOT_CONFIGURED';
}
" 2>/dev/null)
echo "Default display configuration: $DISPLAY_CONFIG"

echo ""
echo "📊 Testing Sample Data (if enabled)..."
NEW_LOANS=$(ddev drush eval "echo count(\\Drupal::entityTypeManager()->getStorage('loan_record')->loadMultiple());" 2>/dev/null || echo "0")
echo "Loan records after automation: $NEW_LOANS"

if [ "$NEW_LOANS" -gt "$CURRENT_LOANS" ]; then
    ADDED_LOANS=$((NEW_LOANS - CURRENT_LOANS))
    echo "✅ $ADDED_LOANS new sample loan records created"
else
    echo "ℹ️  No new sample data created (may be disabled or already present)"
fi

echo ""
echo "4️⃣ === API ENDPOINT VERIFICATION ==="
echo "Testing JSON:API endpoint access..."
API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://freddie-mac.ddev.site/jsonapi/loan_record/loan_record)
echo "JSON:API endpoint status: $API_STATUS"

if [ "$API_STATUS" = "200" ]; then
    echo "✅ JSON:API endpoint accessible"
    echo "Sample API response:"
    curl -s http://freddie-mac.ddev.site/jsonapi/loan_record/loan_record | head -3
else
    echo "❌ JSON:API endpoint not accessible"
fi

echo ""
echo "5️⃣ === AUTOMATION SUMMARY ==="
echo ""

# Summary of results
if [ "$ANON_PERMS" = "GRANTED" ] && [ "$AUTH_PERMS" = "GRANTED" ]; then
    echo "✅ PERMISSIONS: Successfully automated"
else
    echo "❌ PERMISSIONS: Automation failed or incomplete"
fi

if [ "$OAUTH_SCOPE" = "EXISTS" ]; then
    echo "✅ OAUTH2 SCOPE: Successfully automated"
elif [ "$OAUTH_SCOPE" = "SIMPLE_OAUTH_DISABLED" ]; then
    echo "ℹ️  OAUTH2 SCOPE: Skipped (Simple OAuth not enabled)"
else
    echo "❌ OAUTH2 SCOPE: Automation failed"
fi

if [ "$DISPLAY_CONFIG" != "NOT_CONFIGURED" ]; then
    echo "✅ ENTITY DISPLAYS: Successfully automated"
else
    echo "❌ ENTITY DISPLAYS: Automation failed"
fi

if [ "$API_STATUS" = "200" ]; then
    echo "✅ API ACCESS: Fully functional"
else
    echo "❌ API ACCESS: Not working properly"
fi

echo ""
echo "🎯 === AUTOMATION TEST COMPLETE ==="

# Overall success assessment
if [ "$ANON_PERMS" = "GRANTED" ] && [ "$AUTH_PERMS" = "GRANTED" ] && [ "$API_STATUS" = "200" ]; then
    echo "🎉 AUTOMATION SUCCESS: Zero-configuration goal achieved!"
    echo ""
    echo "✅ Module installation now includes:"
    echo "   • Automatic permissions setup"
    echo "   • OAuth2 scope configuration"
    echo "   • Entity display optimization"
    echo "   • API endpoint functionality"
    echo "   • Optional sample data generation"
    echo ""
    echo "🚀 Ready for Task 3: Independent Module Repository"
else
    echo "⚠️  AUTOMATION INCOMPLETE: Some components need attention"
    echo ""
    echo "❓ Issues to address:"
    [ "$ANON_PERMS" != "GRANTED" ] && echo "   • Anonymous permissions not granted"
    [ "$AUTH_PERMS" != "GRANTED" ] && echo "   • Authenticated permissions not granted"
    [ "$API_STATUS" != "200" ] && echo "   • API endpoint not accessible"
fi

echo ""
echo "📋 Next Steps:"
echo "   1. Review automation results above"
echo "   2. Test admin interface functionality"
echo "   3. Verify React frontend still connects"
echo "   4. Confirm all features working as expected"
echo ""
