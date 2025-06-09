## 5. Source Data Overview

This section provides a high-level overview of the raw data sources that feed into the preparatory models. These tables are typically direct replicas of source system data, with minimal transformations. Understanding these source tables is crucial for tracing the lineage of data within the `PROD.common_mart_marketing.mart_crm_touchpoint` table and for debugging any data quality issues.

### 5.1. Salesforce (SFDC) Sources

Salesforce is a primary source for CRM data. Raw data is ingested into the data warehouse with minimal transformations. The following tables are essential for understanding the CRM data landscape:

*   **`sfdc_lead_source`**: This table contains raw data for leads. It includes key lead attributes like contact information, lead source, status, and timestamps for important lifecycle events such as creation and MQL dates.

    ```sql
    SELECT lead_id, lead_first_name, lead_last_name, lead_email, lead_source, created_date
    FROM "PREP".sfdc.sfdc_lead_source
    LIMIT 5;
    ```

*   **`sfdc_contact_source`**: This table contains raw data for contacts. Similar to `sfdc_lead_source`, it includes contact details, account associations, and engagement metrics.

    ```sql
    SELECT contact_id, contact_first_name, contact_last_name, contact_email, account_id, created_date
    FROM "PREP".sfdc.sfdc_contact_source
    LIMIT 5;
    ```

*   **`sfdc_bizible_touchpoint_source`**: This table contains raw Bizible touchpoint data. Bizible is a marketing attribution tool, and this table captures details of each marketing interaction, including touchpoint type, source, campaign, and associated URLs.

    ```sql
    SELECT touchpoint_id, bizible_person_id, bizible_touchpoint_date, bizible_touchpoint_type, campaign_id
    FROM "PREP".sfdc.sfdc_bizible_touchpoint_source
    LIMIT 5;
    ```

*   **`sfdc_bizible_person_source`**: This table contains raw Bizible person data, linking Bizible's identifier for a person to their Salesforce Lead or Contact ID.

    ```sql
    SELECT person_id, bizible_lead_id, bizible_contact_id
    FROM "PREP".sfdc.sfdc_bizible_person_source
    LIMIT 5;
    ```

*   **`sfdc_bizible_attribution_touchpoint_source`**: This table is similar to `sfdc_bizible_touchpoint_source` but specifically contains touchpoints used for multi-touch attribution modeling.

    ```sql
    SELECT touchpoint_id, bizible_touchpoint_date, campaign_id, bizible_count_first_touch, bizible_count_u_shaped
    FROM "PREP".sfdc.sfdc_bizible_attribution_touchpoint_source
    LIMIT 5;
    ```

*   **`sfdc_users_source`**: This table contains raw user data, including employee information, roles, and geographical attributes.

    ```sql
    SELECT user_id, user_name, title, department, user_email, is_active
    FROM "PREP".sfdc.sfdc_users_source
    LIMIT 5;
    ```

*   **`sfdc_campaign_source`**: This table contains raw campaign data, including campaign names, types, statuses, and budget information.

    ```sql
    SELECT campaign_id, campaign_name, type, status, start_date, end_date, budgeted_cost
    FROM "PREP".sfdc.sfdc_campaign_source
    LIMIT 5;
    ```

*   **`sfdc_account_source`**: This table contains raw account data, capturing key details about customer accounts such as industry, employee count, and billing address.

    ```sql
    SELECT account_id, account_name, industry, numberofemployees, billingcountry
    FROM "PREP".sfdc.sfdc_account_source
    LIMIT 5;
    ```

*   **`sfdc_user_roles_source`**: This table contains raw user role data, defining the different roles within the organization and their hierarchical structure.

    ```sql
    SELECT id, name, description
    FROM "PREP".sfdc.sfdc_user_roles_source
    LIMIT 5;
    ```

*   **`sfdc_opportunity_source`**: This table contains raw opportunity data, including potential sales deals, their stages, amounts, and associated dates.

    ```sql
    SELECT opportunity_id, account_id, opportunity_name, stagename, amount, closedate
    FROM "PREP".sfdc.sfdc_opportunity_source
    LIMIT 5;
    ```

*   **`sfdc_opportunity_stage_source`**: This table defines the different stages an opportunity can progress through, along with associated probabilities and forecast categories.

    ```sql
    SELECT sfdc_id, primary_label, forecastcategoryname, isactive, iswon
    FROM "PREP".sfdc.sfdc_opportunity_stage_source
    LIMIT 5;
    ```

*   **`sfdc_zqu_quote_source`**: This table stores data related to Zuora Quotes, linking quotes to Salesforce Opportunities.

    ```sql
    SELECT zqu_quote_id, zqu__opportunity, createddate, zqu__status
    FROM "PREP".sfdc.sfdc_zqu_quote_source
    LIMIT 5;
    ```

*   **`sfdc_opportunity_contact_role_source`**: This table defines the roles that contacts play in an opportunity.

    ```sql
    SELECT opportunity_contact_role_id, opportunityid, contactid, role, isprimary
    FROM "PREP".sfdc.sfdc_opportunity_contact_role_source
    LIMIT 5;
    ```

*   **`sfdc_task_source`**: Contains raw task data related to activities performed by users. This is key in determining user activities related to CRM objects.

    ```sql
    SELECT task_id, whoid, whatid, ownerid, task_status, task_type
    FROM "PREP".sfdc.sfdc_task_source
    LIMIT 5;
    ```

*   **`sfdc_event_source`**: This table contains raw event data from Salesforce, representing scheduled meetings, webinars, and other events.

    ```sql
    SELECT event_id, accountid, ownerid, event_subject, startdatetime, enddatetime
    FROM "PREP".sfdc.sfdc_event_source
    LIMIT 5;
    ```

### 5.2. Marketo Sources

Marketo is another key marketing automation platform and the following tables are loaded into the data warehouse:

*   **`marketo_lead_source`**: Raw Marketo lead data, including lead attributes and timestamps.

    ```sql
    SELECT marketo_lead_id, email, first_name, last_name, company_name, lead_source
    FROM "PREP".marketo.marketo_lead_source
    LIMIT 5;
    ```

*   **`marketo_activity_delete_lead_source`**: This table logs activities related to deleted leads in Marketo.

    ```sql
    SELECT marketo_activity_delete_lead_id, lead_id, activity_date, activity_type_id
    FROM "PREP".marketo.marketo_activity_delete_lead_source
    LIMIT 5;
    ```

### 5.3. Zuora Sources

Zuora is the billing and subscription management system, thus, the following tables provide insights into subscription details and billing information.

*   **`zuora_rate_plan_charge_source`**: Contains raw rate plan charge data, which is core to understanding the recurring revenue associated with a subscription.

    ```sql
    SELECT rate_plan_charge_id, rate_plan_id, product_rate_plan_charge_id, mrr, quantity
    FROM "PREP".zuora.zuora_rate_plan_charge_source
    LIMIT 5;
    ```

*   **`zuora_account_source`**: Contains raw Zuora account data, capturing details about billing and payment information.

    ```sql
    SELECT account_id, account_number, name, currency, crm_id
    FROM "PREP".zuora.zuora_account_source
    LIMIT 5;
    ```

*   **`zuora_subscription_source`**: This table contains raw subscription data, providing details about the subscription's status, term, and associated dates.

    ```sql
    SELECT subscription_id, subscription_name, account_id, subscription_status, termstartdate, termenddate
    FROM "PREP".zuora.zuora_subscription_source
    LIMIT 5;
    ```

*   **`zuora_booking_transaction_source`**: Contains booking transaction data used for revenue analysis.

    ```sql
    SELECT booking_transaction_id, rate_plan_charge_id, list_price
    FROM "PREP".zuora.zuora_booking_transaction_source
    LIMIT 5;
    ```

*   **`zuora_rate_plan_source`**: This table contains rate plan data, linking subscriptions to their associated products and charges.

    ```sql
    SELECT rate_plan_id, subscription_id, product_id, product_rate_plan_id
    FROM "PREP".zuora.zuora_rate_plan_source
    LIMIT 5;
    ```

*   **`zuora_order_action_source`**: This table stores raw order action data, which allows us to track changes made to subscriptions over time.

    ```sql
    SELECT order_action_id, order_id, subscription_id, type, created_date
    FROM "PREP".zuora_order.zuora_order_action_source
    LIMIT 5;
    ```

*   **`zuora_order_source`**: This table contains raw order data, representing customer orders and their associated information.

    ```sql
    SELECT order_id, account_id, order_number, created_date, status
    FROM "PREP".zuora_order.zuora_order_source
    LIMIT 5;
    ```

### 5.4. Zuora Query API Sources

These tables are populated via the Zuora Query API, offering alternative ways to pull data.

*   **`zuora_query_api_order_action_rate_plan_source`**: Raw order action rate plan data from Zuora Query API.

    ```sql
    SELECT order_action_rate_plan_id, order_action_id, rate_plan_id, created_date
    FROM "PREP".zuora_query_api.zuora_query_api_order_action_rate_plan_source
    LIMIT 5;
    ```

*   **`zuora_query_api_charge_contractual_value_source`**: Raw charge contractual value data from Zuora Query API.

    ```sql
    SELECT charge_contractual_value_id, rate_plan_charge_id, amount, elp, created_on
    FROM "PREP".zuora_query_api.zuora_query_api_charge_contractual_value_source
    LIMIT 5;
    ```

### 5.5. Zuora Revenue Sources

These tables come from Zuora Revenue, which is used to recognize revenue and ensure compliance with accounting standards.

*   **`zuora_revenue_manual_journal_entry_source`**: Raw manual journal entry data from Zuora Revenue.

    ```sql
    SELECT manual_journal_entry_line_id, manual_journal_entry_header_id, amount, period_id
    FROM "PREP".zuora_revenue.zuora_revenue_manual_journal_entry_source
    LIMIT 5;
    ```

*   **`zuora_revenue_revenue_contract_line_source`**: Raw revenue contract line data from Zuora Revenue.

    ```sql
    SELECT revenue_contract_line_id, revenue_contract_id,  extended_selling_price, revenue_start_date, revenue_end_date
    FROM "PREP".zuora_revenue.zuora_revenue_revenue_contract_line_source
    LIMIT 5;
    ```

### 5.6. Sheetload Sources

Sheetload sources are manually maintained tables that contain mappings and configurations.

*   **`sheetload_devrel_influenced_campaigns_source`**: This table lists campaigns that have been manually identified as influenced by the Developer Relations (DevRel) team.

    ```sql
    SELECT campaign_name, campaign_type, description, influence_type
    FROM "PREP".sheetload.sheetload_devrel_influenced_campaigns_source
    LIMIT 5;
    ```

*   **`sheetload_mapping_sdr_sfdc_bamboohr_source`**: This table maps Sales Development Representatives (SDRs) between Salesforce and BambooHR.

    ```sql
    SELECT user_id, first_name, last_name, sdr_segment, sdr_region
    FROM "PREP".sheetload.sheetload_mapping_sdr_sfdc_bamboohr_source
    LIMIT 5;
    ```

*   **`sheetload_bizible_to_pathfactory_mapping_source`**: Manual mapping for Bizible URLs to PathFactory content.

    ```sql
    SELECT bizible_url, pathfactory_content_type
    FROM "PREP".sheetload.sheetload_bizible_to_pathfactory_mapping_source
    LIMIT 5;
    ```

*   **`sheetload_sales_targets_source`**: This table contains sales targets data, used for performance analysis.

    ```sql
    SELECT kpi_name, month, sales_qualified_source, allocated_target, user_segment, user_geo
    FROM "PREP".sheetload.sheetload_sales_targets_source
    LIMIT 5;
    ```

*   **`sheetload_maxmind_countries_source`**: This table contains country data from MaxMind, used for geographic mapping.

    ```sql
    SELECT geoname_id, country_name, country_iso_code, continent_name
    FROM "PREP".sheetload.sheetload_maxmind_countries_source
    LIMIT 5;
    ```

### 5.7. Data Science Sources

These tables provide data science scores that enrich account and person data.

*   **`ptc_scores_source`**: Product to Contraction (PTC) scores for accounts.

    ```sql
    SELECT crm_account_id, score_date, score, decile
    FROM "PREP".data_science.ptc_scores_source
    LIMIT 5;
    ```

*   **`pte_scores_source`**: Product to Expansion (PTE) scores for accounts.

    ```sql
    SELECT crm_account_id, score_date, score, decile
    FROM "PREP".data_science.pte_scores_source
    LIMIT 5;
    ```

### 5.8. GitLab Data YAML Sources

These files are maintained in YAML format and uploaded as tables.

*   **`content_keystone_source`**: Content metadata defined in YAML files, providing additional context to marketing content.

    ```sql
    SELECT content_name, gitlab_epic, gtm, type, url_slug
    FROM "PREP".gitlab_data_yaml.content_keystone_source
    LIMIT 5;
    ```

### 5.9. Date Sources

This provides date dimension used in various models.

*   **`date_details_source`**: Core date spine information

    ```sql
    SELECT date_id, date_actual, day_name, month_actual, year_actual
    FROM "PREP".date.date_details_source
    LIMIT 5;
    ```

### 5.10. Legacy Snapshot Sources

These tables contain historical snapshots of data from various sources.

*   **`sfdc_account_snapshots_source`**: Historical snapshots of Salesforce account data.

    ```sql
    SELECT account_id, account_name, industry, numberofemployees, dbt_valid_from, dbt_valid_to
    FROM "PROD".legacy.sfdc_account_snapshots_source
    LIMIT 5;
    ```

*   **`sfdc_user_snapshots_source`**: Historical snapshots of Salesforce user data.

    ```sql
    SELECT user_id, name, title, department, dbt_valid_from, dbt_valid_to
    FROM "PROD".legacy.sfdc_user_snapshots_source
    LIMIT 5;
    ```

*   **`sfdc_opportunity_snapshots_source`**: Historical snapshots of Salesforce opportunity data.

    ```sql
    SELECT opportunity_id, account_id, opportunity_name, stagename, amount, closedate, dbt_valid_from, dbt_valid_to
    FROM "PROD".legacy.sfdc_opportunity_snapshots_source
    LIMIT 5;
    ```

### 5.11. Seed & Driveload Sources

These are static seed tables and tables loaded from Google Drive.

*   **`net_iacv_to_net_arr_ratio`**: Seed data for converting IACV to Net ARR based on segment and order type.

    ```sql
    SELECT user_segment_stamped, order_type, ratio_net_iacv_to_net_arr
    FROM "PREP".seed_sales.net_iacv_to_net_arr_ratio
    LIMIT 5;
    ```

*   **`driveload_lam_corrections_source`**: Manual corrections for LAM (Land-Adopt-Monitor) metrics.

    ```sql
    SELECT dim_parent_crm_account_id, parent_crm_account_sales_segment, dev_count, estimated_capped_lam, valid_from, valid_to
    FROM "PREP".driveload.driveload_lam_corrections_source
    LIMIT 5;
    ```

By understanding these raw data sources, analysts and data engineers can more effectively use and maintain the `mart_crm_touchpoint` table. Knowing where the data originates enables more robust analysis and troubleshooting, ensuring the marketing data mart remains a reliable source of truth.
