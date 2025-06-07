## Chapter 8. Mapping Tables

Mapping tables are a crucial part of the data pipeline, serving as a bridge between source data and dimension keys. They ensure data consistency and enable efficient querying and analysis. This chapter details the structure and purpose of various mapping tables used within the data pipeline.

*   Each section will detail the table's source and key fields.

### 8.1. `map_bizible_campaign_grouping`

This mapping table is used to group Bizible campaigns based on certain criteria.

*   **Source:**
    *   `bizible_touchpoints` (likely a prepped or base table derived from Bizible touchpoint data)
    *   `campaign` (likely a prepped or base table derived from SFDC Campaign data)

*   **Key Fields:**
    *   `dim_crm_touchpoint_id`:  Foreign key referencing the CRM touchpoint dimension. This links a specific touchpoint to a campaign grouping.
    *   `dim_campaign_id`: Foreign key referencing the campaign dimension.  This links a specific campaign to a campaign grouping.
    *   `integrated_campaign_grouping`:  A text field containing the grouped name of the campaign.
    *    `gtm_motion`: A text field that captures the go-to-market motion associated with the campaign.
    *   `touchpoint_segment`: A text field specifying to which segment the touchpoint belongs.

The SQL code shows how this table is used in the `dim_crm_touchpoint` creation:

```sql
WITH combined_touchpoints AS (
    SELECT
      --ids
      touchpoint_id                 AS dim_crm_touchpoint_id,
      ...
    FROM bizible_touchpoints_with_campaign
    UNION ALL
    SELECT
      --ids
      touchpoint_id                 AS dim_crm_touchpoint_id,
      ...
    FROM bizible_attribution_touchpoints_with_campaign
), final AS (
    SELECT
      combined_touchpoints.dim_crm_touchpoint_id,
      ...,
      bizible_campaign_grouping.integrated_campaign_grouping,
      bizible_campaign_grouping.bizible_integrated_campaign_grouping,
      bizible_campaign_grouping.gtm_motion,
      bizible_campaign_grouping.touchpoint_segment,
      ...
    FROM combined_touchpoints
    LEFT JOIN bizible_campaign_grouping
      ON combined_touchpoints.dim_crm_touchpoint_id = bizible_campaign_grouping.dim_crm_touchpoint_id
    LEFT JOIN devrel_influence_campaigns
      ON combined_touchpoints.bizible_ad_campaign_name = devrel_influence_campaigns.campaign_name
    LEFT JOIN prep_bizible_touchpoint_keystone
      ON combined_touchpoints.dim_crm_touchpoint_id=prep_bizible_touchpoint_keystone.dim_crm_touchpoint_id
    WHERE combined_touchpoints.dim_crm_touchpoint_id IS NOT NULL
)
```

This join enriches the `dim_crm_touchpoint` table with the campaign grouping information based on the `dim_crm_touchpoint_id`.

### 8.2. `map_bizible_marketing_channel_path`

This table maps specific Bizible marketing channel paths to grouped names.

*   **Source:**
    *   `touchpoints` (likely a prepped table derived from Bizible touchpoint data).  It is more accurate to consider that the source is the result of the CTE called final.

*   **Key Fields:**
    *   `bizible_marketing_channel_path`: The original Bizible marketing channel path (e.g., "Paid Search.AdWords").
    *   `bizible_marketing_channel_path_name_grouped`: A more general grouping of the channel path (e.g., "Paid Demand Gen").

The SQL code shows how this table is created and used in the `fct_crm_person` creation:

```sql
CREATE TABLE "PROD".common.fct_crm_person as
WITH account_dims_mapping AS (
  SELECT *
  FROM "PROD".restricted_safe_common_mapping.map_crm_account
), crm_person AS (
    SELECT
      dim_crm_person_id,
      sfdc_record_id,
      bizible_person_id,
      bizible_touchpoint_position,
      bizible_marketing_channel_path,
      bizible_touchpoint_date,
      last_utm_content,
      last_utm_campaign,
      dim_crm_account_id,
      dim_crm_user_id,
      ga_client_id,
      person_score,
      name_of_active_sequence,
      sequence_task_due_date,
      sequence_status,
      traction_first_response_time,
      traction_first_response_time_seconds,
      traction_response_time_in_business_hours,
      last_activity_date,
      last_transfer_date_time,
      time_from_last_transfer_to_sequence,
      time_from_mql_to_last_transfer,
      zoominfo_contact_id,
      is_bdr_sdr_worked,
      is_partner_recalled,
      is_high_priority,
      high_priority_datetime,
      propensity_to_purchase_days_since_trial_start,
      propensity_to_purchase_score_date,
      last_worked_by_date,
      last_worked_by_datetime,
    --Groove
      groove_last_engagement_datetime,
      groove_active_flows_count,
      groove_added_to_flow_date,
      groove_flow_completed_date,
      groove_next_step_due_date,
      groove_overdue_days,
      groove_removed_from_flow_date,
      groove_engagement_score,
      groove_outbound_email_counter,
      email_hash,
      CASE
        WHEN LOWER(lead_source) LIKE '%trial - gitlab.com%' THEN TRUE
        WHEN LOWER(lead_source) LIKE '%trial - enterprise%' THEN TRUE
        ELSE FALSE
      END                                                        AS is_lead_source_trial,
      dim_account_demographics_hierarchy_sk
    FROM "PROD".common_prep.prep_crm_person
), industry AS (
    SELECT *
    FROM "PROD".common_prep.prep_industry
), bizible_marketing_channel_path AS (
    SELECT *
    FROM "PROD".common_prep.prep_bizible_marketing_channel_path
), bizible_marketing_channel_path_mapping AS (
    SELECT *
    FROM "PROD".common_mapping.map_bizible_marketing_channel_path
), person_final AS (
    SELECT
    -- ids
      crm_person.dim_crm_person_id    AS dim_crm_person_id,
      crm_person.sfdc_record_id       AS sfdc_record_id,
      crm_person.bizible_person_id    AS bizible_person_id,
      crm_person.ga_client_id         AS ga_client_id,
      crm_person.zoominfo_contact_id  AS zoominfo_contact_id,
     -- common dimension keys
      crm_person.dim_crm_user_id                                                                               AS dim_crm_user_id,
      crm_person.dim_crm_account_id                                                                            AS dim_crm_account_id,
      account_dims_mapping.dim_parent_crm_account_id,
  COALESCE(bizible_marketing_channel_path.dim_bizible_marketing_channel_path_id, MD5(-1))
            AS dim_bizible_marketing_channel_path_id,
      )
    FROM crm_person
    LEFT JOIN bizible_marketing_channel_path_mapping
      ON crm_person.bizible_marketing_channel_path = bizible_marketing_channel_path_mapping.bizible_marketing_channel_path
    LEFT JOIN bizible_marketing_channel_path
      ON bizible_marketing_channel_path_mapping.bizible_marketing_channel_path_name_grouped = bizible_marketing_channel_path.bizible_marketing_channel_path_name
)
```

As observed in the SQL code, the table `map_bizible_marketing_channel_path` is aliased with `bizible_marketing_channel_path_mapping` to make the connection with the `prep_crm_person` table, linking the `bizible_marketing_channel_path` of a crm person with the `dim_bizible_marketing_channel_path_id`.

### 8.3. `map_crm_account`

This mapping table is central to relating CRM accounts to various dimensions like sales segment, territory, and industry.

*   **Source:**
    *   `prep_sfdc_account` (likely a prepped table containing Salesforce Account data).
    *   `dim_sales_segment`
    *   `dim_sales_territory`
    *   `dim_industry`
    *   `prep_location_country`

*   **Key Fields:**
    *   `dim_crm_account_id`: Foreign key referencing the CRM account dimension.
    *   `dim_parent_crm_account_id`: Foreign key referencing the parent CRM account dimension (hierarchical relationship).
    *   `dim_account_sales_segment_id`: Foreign key referencing the sales segment dimension for the account.
    *   `dim_account_sales_territory_id`: Foreign key referencing the sales territory dimension for the account.
    *   `dim_account_industry_id`: Foreign key referencing the industry dimension for the account.
    *   `dim_account_location_country_id`: Foreign key referencing the location country dimension for the account's location.
    *   `dim_account_location_region_id`: Foreign key referencing the location region dimension for the account's location.
     *   `dim_parent_sales_segment_id`: Foreign key referencing the sales segment dimension for the parent account.
    *   `dim_parent_sales_territory_id`: Foreign key referencing the sales territory dimension for the parent account.
    *   `dim_parent_industry_id`: Foreign key referencing the industry dimension for the parent account.

The following SQL code snippet shows where this table is used in creating the `fct_crm_touchpoint` table:

```sql
CREATE TABLE "PROD".common.fct_crm_touchpoint as
WITH account_dimensions AS (
    SELECT *
    FROM "PROD".restricted_safe_common_mapping.map_crm_account
), bizible_touchpoints AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_touchpoint
), final_touchpoint AS (
    SELECT
      touchpoint_id                             AS dim_crm_touchpoint_id,
      bizible_touchpoints.bizible_person_id,
      -- shared dimension keys
      crm_person.dim_crm_person_id,
      crm_person.dim_crm_user_id,
      campaign_id                                       AS dim_campaign_id,
      account_dimensions.dim_crm_account_id,
      account_dimensions.dim_parent_crm_account_id,
      account_dimensions.dim_parent_sales_segment_id,
      account_dimensions.dim_parent_sales_territory_id,
      account_dimensions.dim_parent_industry_id,
      account_dimensions.dim_account_sales_segment_id,
      account_dimensions.dim_account_sales_territory_id,
      account_dimensions.dim_account_industry_id,
      account_dimensions.dim_account_location_country_id,
      account_dimensions.dim_account_location_region_id,
      -- attribution counts
      bizible_count_first_touch,
      bizible_count_lead_creation_touch,
      bizible_count_u_shaped,
      bizible_touchpoints.bizible_created_date
    FROM bizible_touchpoints
    LEFT JOIN account_dimensions
      ON bizible_touchpoints.bizible_account = account_dimensions.dim_crm_account_id
    LEFT JOIN crm_person
      ON bizible_touchpoints.bizible_person_id = crm_person.bizible_person_id
)
SELECT *
FROM final_touchpoint;
```

In this case, the  `map_crm_account` table (aliased as `account_dimensions`) provides dimension keys that link the touchpoint to relevant account information, including parent account details, sales segments, territories, and industries, and it's linked with the field `bizible_account` in the table `bizible_touchpoints`.

### 8.4. Other mapping tables
These mapping tables are used to support a more specific goal.

*   **Source:** `zuora_country_geographic_region`
     *This mapping table associates Zuora's country codes with geographic regions.*

*   **Source:** `Zuora Order Action Rate Plan`
    *This table is used to correlate Zuora order actions with specific rate plans, providing a historical view of how subscriptions have changed over time.*

*   **Source:** `charge_contractual_value`
     *This mapping table relates charges to contractual values, essential for revenue recognition.*

*   **Source:** `User Hierarchy`
     *This table maps users to sales segments, territories, roles, and business units.*

These mapping tables are essential for various purposes, including territory management, reporting, and analyzing sales performance.