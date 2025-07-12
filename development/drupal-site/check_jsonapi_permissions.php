<?php

/**
 * Simple PHP script to check JSON:API permissions and grant them.
 * Run with: ddev drush scr check_jsonapi_permissions.php
 */

echo "🔍 === JSON:API Permission Checker ===\n\n";

// Get all permissions
$permissionHandler = \Drupal::service('user.permissions');
$allPermissions = $permissionHandler->getPermissions();

// Find JSON:API related permissions
$jsonapiPermissions = [];
$relevantPermissions = [];

foreach ($allPermissions as $name => $permission) {
  $title = $permission['title'] ?? '';
  
  // Look for JSON:API related permissions
  if (stripos($name, 'jsonapi') !== FALSE || 
      stripos($name, 'json') !== FALSE || 
      stripos($title, 'JSON') !== FALSE ||
      stripos($title, 'API') !== FALSE) {
    $jsonapiPermissions[] = [
      'name' => $name,
      'title' => $title,
      'category' => $permission['provider'] ?? 'unknown'
    ];
  }
  
  // Also look for any REST related permissions
  if (stripos($name, 'rest') !== FALSE || 
      stripos($title, 'REST') !== FALSE) {
    $relevantPermissions[] = [
      'name' => $name,
      'title' => $title,
      'category' => $permission['provider'] ?? 'unknown'
    ];
  }
}

echo "📋 Found JSON:API Related Permissions:\n";
if (empty($jsonapiPermissions)) {
  echo "  ❌ No JSON:API specific permissions found\n";
  echo "  ℹ️  This is normal - Drupal's core JSON:API module relies on entity access permissions\n\n";
} else {
  foreach ($jsonapiPermissions as $perm) {
    echo "  • " . $perm['name'] . " - " . $perm['title'] . " (" . $perm['category'] . ")\n";
  }
  echo "\n";
}

echo "📋 Found REST Related Permissions:\n";
if (empty($relevantPermissions)) {
  echo "  ❌ No REST specific permissions found\n\n";
} else {
  foreach ($relevantPermissions as $perm) {
    echo "  • " . $perm['name'] . " - " . $perm['title'] . " (" . $perm['category'] . ")\n";
  }
  echo "\n";
}

// Check current anonymous permissions
echo "🔐 Current Anonymous User Permissions:\n";
$anonymousRole = \Drupal\user\Entity\Role::load('anonymous');
if ($anonymousRole) {
  $anonPermissions = $anonymousRole->getPermissions();
  
  // Show relevant permissions
  $relevantAnonPerms = array_filter($anonPermissions, function($perm) {
    return (stripos($perm, 'content') !== FALSE || 
            stripos($perm, 'json') !== FALSE || 
            stripos($perm, 'api') !== FALSE ||
            stripos($perm, 'loan') !== FALSE ||
            stripos($perm, 'view') !== FALSE);
  });
  
  foreach ($relevantAnonPerms as $perm) {
    echo "  ✅ " . $perm . "\n";
  }
  
  echo "\nTotal anonymous permissions: " . count($anonPermissions) . "\n\n";
} else {
  echo "  ❌ Could not load anonymous role\n\n";
}

// Check if key permissions exist and grant them
echo "🛠️  Ensuring Key Permissions:\n";
$keyPermissions = [
  'access content',
  'view loan_record entities'
];

foreach ($keyPermissions as $permission) {
  if (isset($allPermissions[$permission])) {
    if ($anonymousRole && !$anonymousRole->hasPermission($permission)) {
      try {
        $anonymousRole->grantPermission($permission);
        $anonymousRole->save();
        echo "  ✅ Granted: " . $permission . "\n";
      } catch (Exception $e) {
        echo "  ❌ Failed to grant: " . $permission . " - " . $e->getMessage() . "\n";
      }
    } else {
      echo "  ☑️  Already has: " . $permission . "\n";
    }
  } else {
    echo "  ⚠️  Permission not found: " . $permission . "\n";
  }
}

echo "\n🎯 Summary:\n";
echo "• JSON:API typically uses entity-level permissions, not module-specific ones\n";
echo "• Anonymous users need 'access content' and 'view [entity_type] entities'\n";
echo "• If endpoints return 404/403, check entity access permissions\n";
echo "• If endpoints return 000, check web server/Drupal installation\n\n";

echo "✅ Permission check complete!\n";
