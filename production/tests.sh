# Test 1: Can we call AI service directly?
docker compose exec drupal vendor/bin/drush php:eval "
try {
    \$ai = \Drupal::service('ai.provider');
    \$response = \$ai->createInstance('openai')->chat([
        'messages' => [['role' => 'user', 'content' => 'Test message - reply with OK']]
    ]);
    print 'AI Direct Call: SUCCESS - ' . substr(\$response, 0, 50);
} catch (Exception \$e) {
    print 'AI Direct Call: FAILED - ' . \$e->getMessage();
}
"

# Test 2: Check OpenRisk Navigator service methods
docker compose exec drupal vendor/bin/drush php:eval "
if (\Drupal::hasService('openrisk_navigator.loan_risk_manager')) {
    \$risk_manager = \Drupal::service('openrisk_navigator.loan_risk_manager');
    \$methods = get_class_methods(\$risk_manager);
    print 'Risk Manager Methods: ' . implode(', ', \$methods);
} else {
    print 'Risk Manager Service: NOT AVAILABLE';
}
"

# Test 3: Check save hooks are implemented
docker compose exec drupal vendor/bin/drush php:eval "
\$module_handler = \Drupal::moduleHandler();
\$hooks = [];
if (\$module_handler->hasImplementation('openrisk_navigator', 'entity_presave')) {
    \$hooks[] = 'entity_presave';
}
if (\$module_handler->hasImplementation('openrisk_navigator', 'loan_record_presave')) {
    \$hooks[] = 'loan_record_presave';
}
print 'Implemented hooks: ' . (empty(\$hooks) ? 'NONE' : implode(', ', \$hooks));
"

# Test 4: Test Risk Manager directly (if available)
docker compose exec drupal vendor/bin/drush php:eval "
if (\Drupal::hasService('openrisk_navigator.loan_risk_manager')) {
    try {
        \$risk_manager = \Drupal::service('openrisk_navigator.loan_risk_manager');
        // Try different method names that might exist
        if (method_exists(\$risk_manager, 'generateRiskAnalysis')) {
            \$result = \$risk_manager->generateRiskAnalysis(['test' => 'data']);
            print 'generateRiskAnalysis: SUCCESS - ' . substr(\$result, 0, 100);
        } elseif (method_exists(\$risk_manager, 'calculateRiskScore')) {
            \$result = \$risk_manager->calculateRiskScore(['test' => 'data']);
            print 'calculateRiskScore: SUCCESS - ' . substr(\$result, 0, 100);
        } else {
            print 'No known risk analysis methods found';
        }
    } catch (Exception \$e) {
        print 'Risk Manager Test: FAILED - ' . \$e->getMessage();
    }
}
"