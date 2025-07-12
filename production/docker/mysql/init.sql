-- MySQL Database Initialization for Freddie Mac OpenRisk Navigator
-- Creates database and user with proper permissions for Drupal

-- Ensure we're using the MySQL system database for user creation
USE mysql;

-- Create the application database with proper charset/collation for Drupal
CREATE DATABASE IF NOT EXISTS drupal_production 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Create application user with limited privileges
CREATE USER IF NOT EXISTS 'drupal_user'@'%' IDENTIFIED BY 'PLACEHOLDER_PASSWORD';

-- Grant necessary privileges for Drupal operations
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, 
      CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, 
      SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, TRIGGER 
ON drupal_production.* TO 'drupal_user'@'%';

-- Flush privileges to ensure they take effect
FLUSH PRIVILEGES;

-- Switch to the application database
USE drupal_production;

-- Create initial tables will be handled by Drupal installation
-- This script only sets up the database structure and permissions

-- Verify database is ready
SELECT 'Database drupal_production ready for Drupal installation' AS status;