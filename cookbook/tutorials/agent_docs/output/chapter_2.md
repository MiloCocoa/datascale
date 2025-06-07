## Chapter 2. Dimension Tables

This chapter details the creation and structure of the dimension tables used in the data warehouse. Dimension tables provide context to the facts stored in fact tables, enabling effective data analysis and reporting. Each section will describe the source tables, data transformations involved, the final selection of columns, and the table schema.

### 2.1. dim_crm_user

This dimension table stores information about CRM users (sales representatives, managers, etc.).

*   **Source:** `prep_crm_user`
    The source table for `dim_crm_user` is the prepared table `prep_crm_user`. This table is assumed to be the result of initial transformations and data cleansing applied to raw CRM user data.

*   **Data Transformations:**
    The provided code snippet focuses on creating the table `dim_crm_user` from the `prep_crm_user` source. The relevant snippet from the content is:

    ```sql
    CREATE TABLE "PROD".common.dim_crm_user as
    -- depends_on: "PROD".common_prep.prep_crm_user
    WITH final AS (
        SELECT
          "DIM_CRM_USER_ID",
      "EMPLOYEE_NUMBER",
      "USER_NAME",
      "TITLE",
      "DEPARTMENT",
      "TEAM",
      "MANAGER_ID",
      "MANAGER_NAME",
      "USER_EMAIL",
      "IS_ACTIVE",
      "START_DATE",
      "RAMPING_QUOTA",
      "USER_TIMEZONE",
      "USER_ROLE_ID",
      "DIM_CRM_USER_ROLE_NAME_ID",
      "USER_ROLE_NAME",
      "USER_ROLE_TYPE",
      "DIM_CRM_USER_ROLE_LEVEL_1_ID",
      "USER_ROLE_LEVEL_1",
      "DIM_CRM_USER_ROLE_LEVEL_2_ID",
      "USER_ROLE_LEVEL_2",
      "DIM_CRM_USER_ROLE_LEVEL_3_ID",
      "USER_ROLE_LEVEL_3",
      "DIM_CRM_USER_ROLE_LEVEL_4_ID",
      "USER_ROLE_LEVEL_4",
      "DIM_CRM_USER_ROLE_LEVEL_5_ID",
      "USER_ROLE_LEVEL_5",
      "DIM_CRM_USER_SALES_SEGMENT_ID",
      "CRM_USER_SALES_SEGMENT",
      "CRM_USER_SALES_SEGMENT_GROUPED",
      "DIM_CRM_USER_GEO_ID",
      "CRM_USER_GEO",
      "DIM_CRM_USER_REGION_ID",
      "CRM_USER_REGION",
      "DIM_CRM_USER_AREA_ID",
      "CRM_USER_AREA",
      "DIM_CRM_USER_BUSINESS_UNIT_ID",
      "CRM_USER_BUSINESS_UNIT",
      "DIM_CRM_USER_ROLE_TYPE_ID",
      "IS_HYBRID_USER",
      "DIM_CRM_USER_HIERARCHY_SK",
      "CRM_USER_SALES_SEGMENT_GEO_REGION_AREA",
      "CRM_USER_SALES_SEGMENT_REGION_GROUPED",
      "SDR_SALES_SEGMENT",
      "SDR_REGION",
      "CREATED_DATE",
      "CRM_USER_SUB_BUSINESS_UNIT",
      "CRM_USER_DIVISION",
      "ASM"
        FROM "PROD".common_prep.prep_crm_user
    )
    SELECT
          *,
          '@mcooperDD'::VARCHAR       AS created_by,
          '@chrissharp'::VARCHAR       AS updated_by,
          '2020-11-20'::DATE        AS model_created_date,
          '2023-05-04'::DATE        AS model_updated_date,
          CURRENT_TIMESTAMP()               AS dbt_updated_at,
                CURRENT_TIMESTAMP()               AS dbt_created_at
        FROM final;
    ```

    This code performs the following steps:

    1.  **Selecting Columns**: Selects all columns from the `prep_crm_user` table.
    2.  **Adding Metadata Columns**: Adds metadata columns like `created_by`, `updated_by`, `model_created_date`, `model_updated_date`, `dbt_updated_at`, and `dbt_created_at`.  These columns help track the lineage and freshness of the data.
    3.  **Casting**: Casts the added metadata columns to the appropriate data types (e.g., `VARCHAR`, `DATE`, `CURRENT_TIMESTAMP()`).

*   **Final Selection**:
    The final `SELECT` statement selects all columns from the `final` CTE (Common Table Expression) along with the added metadata columns.

*   **Table Schema:**

| Column Name                         | Data Type   | Description                                                                                                     |
| ----------------------------------- | ----------- | --------------------------------------------------------------------------------------------------------------- |
| `dim_crm_user_id`                   | VARCHAR     | Primary key for the dimension table; SFDC User ID                                                              |
| `employee_number`                     | VARCHAR     | Employee number from HR system                                                                                   |
| `user_name`                         | VARCHAR     | User's full name                                                                                               |
| `title`                             | VARCHAR     | User's job title                                                                                             |
| `department`                        | VARCHAR     | User's department                                                                                             |
| `team`                              | VARCHAR     | User's team                                                                                                  |
| `manager_id`                        | VARCHAR     | User's manager's User ID                                                                                       |
| `manager_name`                      | VARCHAR     | User's manager's name                                                                                          |
| `user_email`                        | VARCHAR     | User's email address                                                                                             |
| `is_active`                         | BOOLEAN     | Flag indicating whether the user is currently active                                                            |
| `start_date`                        | DATE        | User's start date                                                                                              |
| `ramping_quota`                     | NUMBER      | Sales quota during the ramping period                                                                             |
| `user_timezone`                     | VARCHAR     | User's timezone                                                                                              |
| `user_role_id`                      | VARCHAR     | User's role ID                                                                                               |
| `dim_crm_user_role_name_id`           | VARCHAR     | Surrogate key for the `dim_crm_user_role_name` dimension                                                       |
| `user_role_name`                    | VARCHAR     | User's role name                                                                                             |
| `user_role_type`                    | VARCHAR     | User's role type (e.g., Sales, Marketing)                                                                     |
| `dim_crm_user_role_level_1_id`        | VARCHAR     | Surrogate key for user role level 1 hierarchy                                                                 |
| `user_role_level_1`                 | VARCHAR     | User's role level 1 (e.g., AMER)                                                                              |
| `dim_crm_user_role_level_2_id`        | VARCHAR     | Surrogate key for user role level 2 hierarchy                                                                 |
| `user_role_level_2`                 | VARCHAR     | User's role level 2 (e.g., AMER_COMM)                                                                         |
| `dim_crm_user_role_level_3_id`        | VARCHAR     | Surrogate key for user role level 3 hierarchy                                                                 |
| `user_role_level_3`                 | VARCHAR     | User's role level 3                                                                                             |
| `dim_crm_user_role_level_4_id`        | VARCHAR     | Surrogate key for user role level 4 hierarchy                                                                 |
| `user_role_level_4`                 | VARCHAR     | User's role level 4                                                                                             |
| `dim_crm_user_role_level_5_id`        | VARCHAR     | Surrogate key for user role level 5 hierarchy                                                                 |
| `user_role_level_5`                 | VARCHAR     | User's role level 5                                                                                             |
| `dim_crm_user_sales_segment_id`       | VARCHAR     | Surrogate key for `dim_sales_segment` dimension                                                                |
| `crm_user_sales_segment`            | VARCHAR     | User's sales segment (e.g., SMB, Enterprise)                                                                  |
| `crm_user_sales_segment_grouped`    | VARCHAR     | Grouped sales segment (e.g., SMB, Large)                                                                      |
| `dim_crm_user_geo_id`                 | VARCHAR     | Surrogate key for the `dim_location_geo` dimension                                                            |
| `crm_user_geo`                      | VARCHAR     | User's geographic location                                                                                      |
| `dim_crm_user_region_id`              | VARCHAR     | Surrogate key for the `dim_location_region` dimension                                                         |
| `crm_user_region`                   | VARCHAR     | User's region                                                                                                |
| `dim_crm_user_area_id`                | VARCHAR     | Surrogate key for user area dimension                                                                         |
| `crm_user_area`                     | VARCHAR     | User's area                                                                                                  |
| `dim_crm_user_business_unit_id`       | VARCHAR     | Surrogate key for user business unit dimension                                                                |
| `crm_user_business_unit`            | VARCHAR     | User's business unit                                                                                           |
| `dim_crm_user_role_type_id`       | VARCHAR     | Surrogate key for user role type dimension                                                                |
| `is_hybrid_user`       | BOOLEAN    | Flag indicating whether the user is a hybrid user                                                               |
| `dim_crm_user_hierarchy_sk`  | VARCHAR         | Hierarchy surrogate key based on sales segment, geo, region and area.                    |
| `crm_user_sales_segment_geo_region_area`| VARCHAR | concatenated string for sales segment, geo, region, and area                                           |
| `crm_user_sales_segment_region_grouped` | VARCHAR | the sales segment region that has been grouped                                                               |
| `sdr_sales_segment`            | VARCHAR     | SDR's sales segment                                                                                                |
| `sdr_region`                     | VARCHAR     | SDR's region                                                                                                |
| `created_date`                     | DATE        | SFDC Created Date        |
| `crm_user_sub_business_unit`            | VARCHAR     | User's Sub Business Unit                                                                                           |
| `crm_user_division`            | VARCHAR     | User's Division                                                                                           |
| `ASM`            | VARCHAR     | User's ASM                                                                                           |
| `created_by`                      | VARCHAR     | User who created the record in the data warehouse                                                             |
| `updated_by`                      | VARCHAR     | User who last updated the record in the data warehouse                                                         |
| `model_created_date`              | DATE        | Date when the model was created                                                                                |
| `model_updated_date`              | DATE        | Date when the model was last updated                                                                           |
| `dbt_updated_at`                  | TIMESTAMP   | Timestamp when the record was last updated by dbt                                                              |
| `dbt_created_at`                  | TIMESTAMP   | Timestamp when the record was created by dbt                                                                   |

*   **Key Fields:**
    *   `dim_crm_user_id`
    *   `user_name`
    *   `title`
    *   `team`
    *   `is_active`
    *   `user_role_name`
    *   `crm_user_sales_segment`
    *   `crm_user_geo`
    *   `crm_user_region`

### 2.2. dim_crm_person

This dimension table contains information about people in the CRM, including leads and contacts.

*   **Source:** `prep_crm_person`

    The source table for `dim_crm_person` is `prep_crm_person`, which is assumed to be a pre-processed table containing enriched CRM person data.

*   **Data Transformations:**
    The code snippet shows the creation of the `dim_crm_person` table. The relevant snippet is:

    ```sql
    CREATE TABLE "PROD".common.dim_crm_person as
    WITH final AS (
        SELECT
          --id
          dim_crm_person_id,
          sfdc_record_id,
          bizible_person_id,
          sfdc_record_type,
          email_hash,
          email_domain,
          IFF(email_domain_type = 'Business email domain',TRUE,FALSE) AS is_valuable_signup,
          email_domain_type,
          marketo_lead_id,
          --keys
          master_record_id,
          owner_id,
          record_type_id,
          dim_crm_account_id,
          reports_to_id,
          dim_crm_user_id,
          crm_partner_id,
          --info
          person_score,
          behavior_score,
          title,
          country,
          person_role,
          state,
          has_opted_out_email,
          email_bounced_date,
          email_bounced_reason,
          status,
          lead_source,
          lead_source_type,
          inactive_contact,
          was_converted_lead,
          source_buckets,
          employee_bucket,
          net_new_source_categories,
          bizible_touchpoint_position,
          bizible_marketing_channel_path,
          bizible_touchpoint_date,
          sequence_step_type,
          is_actively_being_sequenced,
          is_high_priority,
          prospect_share_status,
          partner_prospect_status,
          partner_prospect_owner_name,
          partner_prospect_id,
          is_partner_recalled,
          marketo_last_interesting_moment,
          marketo_last_interesting_moment_date,
          outreach_step_number,
          matched_account_owner_role,
          matched_account_account_owner_name,
          matched_account_sdr_assigned,
          matched_account_type,
          matched_account_gtm_strategy,
          matched_account_bdr_prospecting_status,
          is_first_order_initial_mql,
          is_first_order_mql,
          is_first_order_person,
          cognism_company_office_city,
          cognism_company_office_state,
          cognism_company_office_country,
          cognism_city,
          cognism_state,
          cognism_country,
          cognism_employee_count,
          leandata_matched_account_billing_state,
          leandata_matched_account_billing_postal_code,
          leandata_matched_account_billing_country,
          leandata_matched_account_employee_count,
          leandata_matched_account_sales_segment,
          zoominfo_contact_city,
          zoominfo_contact_state,
          zoominfo_contact_country,
          zoominfo_company_city,
          zoominfo_company_state,
          zoominfo_company_country,
          zoominfo_phone_number,
          zoominfo_mobile_phone_number,
          zoominfo_do_not_call_direct_phone,
          zoominfo_do_not_call_mobile_phone,
          zoominfo_company_employee_count,
          account_demographics_sales_segment,
          account_demographics_sales_segment_grouped,
          account_demographics_geo,
          account_demographics_region,
          account_demographics_area,
          account_demographics_segment_region_grouped,
          account_demographics_territory,
          account_demographics_employee_count,
          account_demographics_max_family_employee,
          account_demographics_upa_country,
          account_demographics_upa_state,
          account_demographics_upa_city,
          account_demographics_upa_street,
          account_demographics_upa_postal_code,
          propensity_to_purchase_score_group,
          pql_namespace_creator_job_description,
          pql_namespace_id,
          pql_namespace_name,
          pql_namespace_users,
          is_product_qualified_lead,
          propensity_to_purchase_insights,
          is_ptp_contact,
          propensity_to_purchase_namespace_id,
          propensity_to_purchase_past_insights,
          propensity_to_purchase_past_score_group,
          is_defaulted_trial,
          lead_score_classification,
          person_first_country,
          assignment_date,
          assignment_type,
          is_exclude_from_reporting,
        --6 Sense Fields
          has_account_six_sense_6_qa,
          six_sense_account_6_qa_end_date,
          six_sense_account_6_qa_start_date,
          six_sense_account_buying_stage,
          six_sense_account_profile_fit,
          six_sense_person_grade,
          six_sense_person_profile,
          six_sense_person_update_date,
          six_sense_segments,
        --UserGems
          usergem_past_account_id,
          usergem_past_account_type,
          usergem_past_contact_relationship,
          usergem_past_company,
        -- Worked By
          mql_worked_by_user_id,
          mql_worked_by_user_manager_id,
          last_worked_by_user_manager_id,
          last_worked_by_user_id,
        --Groove
          groove_email,
          is_created_by_groove,
          groove_last_engagement_type,
          groove_last_flow_name,
          groove_last_flow_status,
          groove_last_flow_step_number,
          groove_last_flow_step_type,
          groove_last_step_completed_datetime,
          groove_last_step_skipped,
          groove_last_touch_datetime,
          groove_last_touch_type,
          groove_log_a_call_url,
          groove_mobile_number,
          groove_phone_number,
          groove_removed_from_flow_reason,
          groove_create_opportunity_url,
          groove_email_domain,
          is_groove_converted,
        --MQL and Most Recent Touchpoint info
          bizible_mql_touchpoint_id,
          bizible_mql_touchpoint_date,
          bizible_mql_form_url,
          bizible_mql_sfdc_campaign_id,
          bizible_mql_ad_campaign_name,
          bizible_mql_marketing_channel,
          bizible_mql_marketing_channel_path,
          bizible_most_recent_touchpoint_id,
          bizible_most_recent_touchpoint_date,
          bizible_most_recent_form_url,
          bizible_most_recent_sfdc_campaign_id,
          bizible_most_recent_ad_campaign_name,
          bizible_most_recent_marketing_channel,
          bizible_most_recent_marketing_channel_path
        FROM "PROD".common_prep.prep_crm_person
    )
    SELECT
          *,
          '@jjstark'::VARCHAR       AS created_by,
          '@rkohnke'::VARCHAR       AS updated_by,
          '2020-09-10'::DATE        AS model_created_date,
          '2024-12-02'::DATE        AS model_updated_date,
          CURRENT_TIMESTAMP()               AS dbt_updated_at,
                CURRENT_TIMESTAMP()               AS dbt_created_at
        FROM final;
    ```

    The code performs the following transformations:

    1.  **Selecting Columns**:  Selects and renames columns from the `prep_crm_person` table.
    2.  **Applying Business Logic**:  Applies some IFF (conditional) logic for the column `is_valuable_signup`.
    3.  **Adding Metadata Columns**:  Adds metadata columns similar to the `dim_crm_user` table.

*   **Final Selection**:
    The final `SELECT` statement selects all columns from the `final` CTE and adds the standard metadata columns.

*   **Table Schema:**

| Column Name                                  | Data Type   | Description                                                                                                                      |
| -------------------------------------------- | ----------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `dim_crm_person_id`                          | VARCHAR     | Primary key, a hash of the SFDC record ID                                                                                       |
| `sfdc_record_id`                             | VARCHAR     | SFDC record ID (Lead or Contact ID)                                                                                             |
| `sfdc_record_type`                           | VARCHAR     | Type of SFDC record (Lead or Contact)                                                                                            |
| `email_hash`                                 | VARCHAR     | Hashed email address for privacy                                                                                                |
| `email_domain`                               | VARCHAR     | Email domain of the person                                                                                                       |
| `is_valuable_signup`                         | BOOLEAN     | Flag indicating whether the signup used a business email domain                                                                  |
| `marketo_lead_id`                            | NUMBER      | Marketo Lead ID, if available                                                                                                   |
| `master_record_id`                           | VARCHAR     | SFDC Master Record ID                                                                                                            |
| `owner_id`                                   | VARCHAR     | SFDC Owner ID                                                                                                                   |
| `record_type_id`                             | VARCHAR     | SFDC Record Type ID                                                                                                             |
| `dim_crm_account_id`                         | VARCHAR     | Foreign key to `dim_crm_account`                                                                                                 |
| `reports_to_id`                              | VARCHAR     | SFDC Reports To ID                                                                                                              |
| `dim_crm_user_id`                            | VARCHAR     | Foreign key to `dim_crm_user`                                                                                                    |
| `crm_partner_id`                             | VARCHAR     | Partner ID from CRM system.                                                                                                  |
| `person_score`                               | NUMBER      | Lead/Contact score                                                                                                               |
| `behavior_score`                             | NUMBER      | Behavior Score of the lead/contact                                                                                             |
| `title`                                      | VARCHAR     | Job title of the person                                                                                                          |
| `country`                                    | VARCHAR     | Country of the person                                                                                                          |
| `person_role`                                | VARCHAR     | Role of the person                                                                                                             |
| `state`                                      | VARCHAR     | State of the person                                                                                                            |
| `has_opted_out_email`                        | BOOLEAN     | Flag indicating if the person has opted out of emails                                                                         |
| `email_bounced_date`                         | DATE        | Date when the email bounced                                                                                                      |
| `email_bounced_reason`                       | VARCHAR     | Reason for the email bounce                                                                                                    |
| `status`                                     | VARCHAR     | Status of the lead/contact                                                                                                     |
| `lead_source`                                | VARCHAR     | Lead source                                                                                                                    |
| `lead_source_type`                           | VARCHAR     | Type of lead source (e.g. Inbound, Outbound)                                                                                  |
| `inactive_contact`                           | BOOLEAN     | Flag indicating if the contact is inactive                                                                                     |
| `was_converted_lead`                         | BOOLEAN     | Flag indicating if the record was a converted lead                                                                           |
| `source_buckets`                             | VARCHAR     | Categorization of lead source, net new                                                                                    |
| `employee_bucket`                             | VARCHAR     | Categorization of leads based on company employee                                                                                    |
| `net_new_source_categories`                  | VARCHAR     | Net New source Categories                                                                                                     |
| `bizible_touchpoint_position`                | VARCHAR     | The location of this interaction in the sales cycle ex: FT/LC                                                                       |
| `bizible_marketing_channel_path`             | VARCHAR     | The path to an asset that the lead touched                                                                                       |
| `bizible_touchpoint_date`                    | DATE        | Bizible touchpoint date                                                                                                         |
| `sequence_step_type`                         | VARCHAR     | The step type in a person sequence  ex: Email, Call                                                                           |
| `is_actively_being_sequenced`                | BOOLEAN     | If a lead is actively being sequenced                                                                                              |
| `is_high_priority`                           | BOOLEAN     | If a lead is a high priority lead                                                                                               |
| `prospect_share_status`                      | VARCHAR     | Indicates a share status  ex: Accepted, Pending                                                                                     |
| `partner_prospect_status`                    | VARCHAR     | Status of a prospect  ex: Qualified                                                                                             |
| `partner_prospect_owner_name`                | VARCHAR     | Name of the partner who is set as the  prospect owner                                                                                  |
| `partner_prospect_id`                        | VARCHAR     | ID of the prospect to be shared                                                                                              |
| `is_partner_recalled`                        | BOOLEAN     | Is the person a Partner Recall  ex: TRUE/FALSE                                                                                             |
| `outreach_step_number`                       | NUMBER      | The step number that this lead has moved through to outreach                                                                                             |
| `matched_account_owner_role`                 | VARCHAR     | Matched Account Owner Role.                                                                                              |
| `matched_account_account_owner_name`         | VARCHAR     | Matched Account Owner Name.                                                                                               |
| `matched_account_sdr_assigned`               | VARCHAR     | Matched Account SDR.                                                                                                  |
| `matched_account_type`                       | VARCHAR     | Matched Account Type.                                                                                                |
| `matched_account_gtm_strategy`               | VARCHAR     | Matched Account GTM Strategy.                                                                                                |
| `matched_account_bdr_prospecting_status`     | VARCHAR     | Matched Account BDR Prospecting Status.                                                                                              |
| `is_first_order_initial_mql`                 | BOOLEAN     | Flag to indicate if is a Initial MQL                                                                                     |
| `is_first_order_mql`                         | BOOLEAN     | Flag to indicate if is a First Order MQL                                                                                   |
| `is_first_order_person`                      | BOOLEAN     | Flag to indicate First Order Person                                                                                        |
| `cognism_company_office_city` | VARCHAR     | City of Cognism company.                                                                                             |
| `cognism_company_office_state` | VARCHAR     | State of Cognism company.                                                                                           |
| `cognism_company_office_country` | VARCHAR     | Country of Cognism company.                                                                                         |
| `cognism_city` | VARCHAR     | City of Cognism employee                                                                                             |
| `cognism_state` | VARCHAR     | State of Cognism employee.                                                                                           |
| `cognism_country` | VARCHAR     | Country of Cognism employee                                                                                             |
| `cognism_employee_count` | VARCHAR     | Employee count of Cognism employee.                                                                                        |
| `leandata_matched_account_billing_state` | VARCHAR     | Leandata matched account billing state                                                                                             |
| `leandata_matched_account_billing_postal_code` | VARCHAR     | Leandata matched account billing postal code.                                                                                          |
| `leandata_matched_account_billing_country` | VARCHAR     | Leandata matched account billing country                                                                                             |
| `leandata_matched_account_employee_count` | VARCHAR     | Leandata matched account employee count.                                                                                      |
| `leandata_matched_account_sales_segment` | VARCHAR     | Leandata matched account sales segment.                                                                                          |
| `zoominfo_contact_city` | VARCHAR     | Zoom Info Contact City.                                                                                            |
| `zoominfo_contact_state` | VARCHAR     | Zoom Info Contact State                                                                                             |
| `zoominfo_contact_country` | VARCHAR     | Zoom Info Contact Country                                                                                             |
| `zoominfo_company_city` | VARCHAR     | Zoom Info Company City                                                                                           |
| `zoominfo_company_state` | VARCHAR     | Zoom Info Company State.                                                                                            |
| `zoominfo_company_country` | VARCHAR     | Zoom Info Company Country.                                                                                             |
| `zoominfo_phone_number` | VARCHAR     | Zoom Info Company Phone Number.                                                                                          |
| `zoominfo_mobile_phone_number` | VARCHAR     | Zoom Info Company Mobile Phone Number.                                                                                             |
| `zoominfo_do_not_call_direct_phone` | VARCHAR     | Zoom Info Company Do Not Call Direct Phone.                                                                                          |
| `zoominfo_do_not_call_mobile_phone` | VARCHAR     | Zoom Info Company Do Not Call Mobile Phone                                                                                             |
| `zoominfo_company_employee_count` | VARCHAR     | Zoom Info Company Employee Count                                                                                             |
| `account_demographics_sales_segment`               | VARCHAR     | Account Demographic of Sales Segment                                                                                        |
| `account_demographics_sales_segment_grouped`       | VARCHAR     | Account Demographic of Sales Segment - Grouped.                                                                                      |
| `account_demographics_geo`                      | VARCHAR     | Account Demographic of Geo                                                                                               |
| `account_demographics_region`                   | VARCHAR     | Account Demographic of Region.                                                                                               |
| `account_demographics_area`                     | VARCHAR     | Account Demographic of Area                                                                                           |
| `account_demographics_segment_region_grouped`  | VARCHAR     | Account Demographic of Segment Region Grouped.                                                                                           |
| `account_demographics_territory`              | VARCHAR     | Account Demographic of  Territory.                                                                                              |
| `account_demographics_employee_count`           | VARCHAR     | Account Demographic of Employee Count.                                                                                               |
| `account_demographics_max_family_employee`           | VARCHAR     | Account Demographic of Max Family Employee                                                                                           |
| `account_demographics_upa_country`                 | VARCHAR     | UPA country.                                                                                           |
| `account_demographics_upa_state`                       | VARCHAR     | UPA State.                                                                                                 |
| `account_demographics_upa_city`                        | VARCHAR     | UPA City.                                                                                     |
| `account_demographics_upa_street`                    | VARCHAR     | UPA Street.                                                                                             |
| `account_demographics_upa_postal_code`               | VARCHAR     | UPA Postal Code.                                                                                       |
| `propensity_to_purchase_score_group` | VARCHAR     | Propensity To Purchase Score Group.                                                                                          |
| `pql_namespace_creator_job_description` | VARCHAR     | The job description for the user who created namespace.                                                                                             |
| `pql_namespace_id` | VARCHAR     | Unique identifier of a namespace.                                                                                             |
| `pql_namespace_name` | VARCHAR     | Name of the Namespace.                                                                                            |
| `pql_namespace_users` | VARCHAR     | Number of users in the PQL                                                                                            |
| `is_product_qualified_lead` | BOOLEAN     | Is this lead PQL                                                                                            |
| `propensity_to_purchase_insights` | VARCHAR     | Insights regarding lead's propensity to purchase Gitlab.                                                                                              |
| `is_ptp_contact` | BOOLEAN     | A contact that is a PTP lead                                                                                            |
| `propensity_to_purchase_namespace_id` | VARCHAR     | Unique namespace id to lead                                                                                           |
| `propensity_to_purchase_past_insights` | VARCHAR     | Propensity To Purchase Past Insights                                                                                            |
| `propensity_to_purchase_past_score_group` | VARCHAR     | Propensity To Purchase Past Score Group                                                                                           |
| `is_defaulted_trial` | BOOLEAN     |  lead converted to the default                                                                                         |
| `lead_score_classification` | VARCHAR     | Classification of Lead ex: Tier 1, Tier 2, Tier 3                                                                                           |
| `mql_worked_by_user_id` | VARCHAR     | Sales Rep Owner assigned to MQL                                                                                            |
| `mql_worked_by_user_manager_id` | VARCHAR     | Sales Management assigned to MQL                                                                                            |
| `last_worked_by_user_manager_id` | VARCHAR     | Sales Rep manager worked by                                                                                            |
| `last_worked_by_user_id` | VARCHAR     | Sales Rep worked by lead.                                                                                            |
| `is_partner_recalled`               | BOOLEAN     | Is the person a Partner Recall  ex: TRUE/FALSE                                                                                             |
| `is_bdr_sdr_worked` | BOOLEAN     | Has BDR/SDR worked through and spoken to this prospect |
|`last_worked_by_datetime`| DATETIME | Last time the lead or contact was worked by someone |
| `assignment_date`              | STRING        | Date assignment occurred                                                             |
| `assignment_type`              | STRING        | Type of assignment                                                                |
| `is_exclude_from_reporting`                     | BOOLEAN     | record to exclude from reports                    |
| `has_account_six_sense_6_qa` | VARCHAR     |  6Sense data to check if the account has 6 qa                                                            |
| `six_sense_account_6_qa_end_date` | VARCHAR     | 6Sense qa end date to determine account validity for the time qa is available                              |
| `six_sense_account_6_qa_start_date` | VARCHAR     | 6Sense qa start date to determine account validity for the time qa is available                              |
| `six_sense_account_buying_stage` | VARCHAR     |  6Sense account buying stage                                                            |
| `six_sense_account_profile_fit` | VARCHAR     | 6Sense account profile fit grade.                                                            |
| `six_sense_person_grade` | VARCHAR     | 6Sense person grade.                                                            |
| `six_sense_person_profile` | VARCHAR     | 6Sense person profile fit.                                                            |
| `six_sense_person_update_date` | VARCHAR     |  6Sense Person last updated Date, to get the most recent record to