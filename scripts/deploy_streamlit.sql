-- ===========================================================================
-- STREAMLIT DEPLOYMENT SCRIPT
-- ===========================================================================
-- This script deploys the Customer Journey Analytics Streamlit app via Git integration.
-- Run this AFTER setup.sql has completed successfully.
--
-- Prerequisites:
--   - setup.sql has been executed
-- ===========================================================================

-- Set query tag for tracking
ALTER SESSION SET query_tag = '{"origin":"sf_sit-is","name":"customer_journey_analytics_with_sequent","version":{"major":1,"minor":0},"attributes":{"is_quickstart":1,"source":"sql"}}';

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SEQUENT_WH;

-- ===========================================================================
-- GIT INTEGRATION & STREAMLIT DEPLOYMENT
-- ===========================================================================

-- 1. Create API integration with GitHub
CREATE OR REPLACE API INTEGRATION GITHUB_INTEGRATION_SEQUENT
  API_PROVIDER = GIT_HTTPS_API
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ALLOWED_AUTHENTICATION_SECRETS = ALL
  ENABLED = TRUE
  COMMENT = 'Git integration with GitHub repository for Sequent Customer Journey Analytics.';

-- 2. Create Git repository object (public repository - no authentication needed)
CREATE OR REPLACE GIT REPOSITORY SEQUENT_DB.ANALYTICS.GITHUB_REPO_SEQUENT
  ORIGIN = 'https://github.com/Snowflake-Labs/sfguide-customer-journey-analytics-with-sequent.git'
  API_INTEGRATION = 'GITHUB_INTEGRATION_SEQUENT';

-- 3. Fetch latest from GitHub
ALTER GIT REPOSITORY SEQUENT_DB.ANALYTICS.GITHUB_REPO_SEQUENT FETCH;

-- 4. Create Streamlit app from GitHub
CREATE OR REPLACE STREAMLIT SEQUENT_DB.ANALYTICS.SEQUENT
  FROM '@SEQUENT_DB.ANALYTICS.GITHUB_REPO_SEQUENT/branches/main/streamlit/'
  MAIN_FILE = 'sequent.py'
  QUERY_WAREHOUSE = 'SEQUENT_WH'
  TITLE = 'SEQUENT'
  COMMENT = '{"origin":"sf_sit", "name":"sfguide_customer_journey_analytics_sequent", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"streamlit"}}';

-- 5. Add live version
ALTER STREAMLIT SEQUENT_DB.ANALYTICS.SEQUENT ADD LIVE VERSION FROM LAST;

-- Grant access to the Streamlit app
GRANT USAGE ON STREAMLIT SEQUENT_DB.ANALYTICS.SEQUENT TO ROLE SEQUENT_ROLE;

-- ===========================================================================
-- STREAMLIT DEPLOYMENT COMPLETE
-- ===========================================================================
-- Navigate to: Snowsight > Projects > Streamlit > "Sequent"
-- ===========================================================================

