-- ===========================================================================
-- TEARDOWN SCRIPT
-- ===========================================================================
-- This script removes all resources created by setup.sql and deploy_streamlit.sql
-- Run this to completely clean up your Snowflake account
--
-- WARNING: This will permanently delete all data and objects!
-- ===========================================================================

USE ROLE ACCOUNTADMIN;

-- ===========================================================================
-- DROP STREAMLIT APP (if deployed)
-- ===========================================================================
DROP STREAMLIT IF EXISTS SEQUENT_DB.ANALYTICS.CUSTOMER_JOURNEY_ANALYTICS;

-- ===========================================================================
-- DROP GIT REPOSITORY AND API INTEGRATION (if created)
-- ===========================================================================
DROP GIT REPOSITORY IF EXISTS SEQUENT_DB.ANALYTICS.GITHUB_REPO_SEQUENT;
DROP API INTEGRATION IF EXISTS GITHUB_INTEGRATION_SEQUENT;

-- ===========================================================================
-- DROP DATABASE (removes all schemas, tables, views, procedures)
-- ===========================================================================
DROP DATABASE IF EXISTS SEQUENT_DB;

-- ===========================================================================
-- DROP WAREHOUSE
-- ===========================================================================
DROP WAREHOUSE IF EXISTS SEQUENT_WH;

-- ===========================================================================
-- DROP ROLE
-- ===========================================================================
DROP ROLE IF EXISTS SEQUENT_ROLE;

-- ===========================================================================
-- TEARDOWN COMPLETE
-- ===========================================================================
SELECT 'Teardown complete. All Sequent resources have been removed.' AS status;

