## Chapter 1. Mart CRM Touchpoint Table
### Purpose of the Table
The `mart_crm_touchpoint` table is designed to provide a comprehensive view of customer relationship management (CRM) touchpoints. It consolidates data from multiple source tables, transforming and calculating key metrics to facilitate marketing analysis and reporting. This table enables users to understand the various interactions customers have with the organization, their influence on the customer journey, and their contribution to key marketing outcomes.

### Source Tables
The `mart_crm_touchpoint` table is built from the following source tables:

*   `dim_crm_touchpoint`: Contains dimensional information about CRM touchpoints, such as touchpoint type, source, and content.
*   `fct_crm_touchpoint`: Contains fact data related to CRM touchpoints, including counts of first touches, lead creation touches, and U-shaped touches.
*   `dim_campaign`: Provides dimensional information about marketing campaigns, such as campaign name, status, and budget holder.
*   `fct_campaign`: Contains fact data related to marketing campaigns, including budget costs, expected revenue, and counts of contacts and leads.
*   `dim_crm_person`: Stores dimensional information about CRM persons (leads/contacts), such as name, title, and location.
*   `fct_crm_person`: Stores fact data about CRM persons, including MQL dates, inquiry dates, and conversion dates.
*   `dim_crm_account`: Holds dimensional data for CRM accounts, including industry, GTM strategy, and health score.
*   `dim_crm_user`: Contains dimensional data about CRM users, such as name, title, and team.

The corresponding SQL code to access these tables is:

```sql
WITH dim_crm_touchpoint AS (
    SELECT *
    FROM "PROD".common.dim_crm_touchpoint
), fct_crm_touchpoint AS (
    SELECT *
    FROM "PROD".common.fct_crm_touchpoint
), dim_campaign AS (
    SELECT *
    FROM "PROD".common.dim_campaign
), fct_campaign AS (
    SELECT *
    FROM "PROD".common.fct_campaign
), dim_crm_person AS (
    SELECT *
    FROM "PROD".common.dim_crm_person
), fct_crm_person AS (
    SELECT *
    FROM "PROD".common.fct_crm_person
), dim_crm_account AS (
    SELECT *
    FROM "PROD".restricted_safe_common.dim_crm_account
), dim_crm_user AS (
    SELECT *
    FROM "PROD".common.dim_crm_user
)
```

### Joining Logic and Data Transformations

The core of the `mart_crm_touchpoint` table is constructed through a series of left joins, connecting the fact and dimension tables.

The joining logic is as follows:

1.  `fct_crm_touchpoint` is the base table, joined to `dim_crm_touchpoint` on `dim_crm_touchpoint_id`.
2.  The result is then left-joined to `dim_campaign` and `fct_campaign` on `dim_campaign_id`.
3.  The result is further left-joined to `dim_crm_person` and `fct_crm_person` on `dim_crm_person_id`.
4.  `dim_crm_account` is left-joined on `dim_crm_account_id`.
5.  Finally, `dim_crm_user` (for both campaign owner and sales rep information) is joined on respective user IDs.

Data transformations include:

*   **String Concatenation and Hashing:** The `touchpoint_person_campaign_date_id` is created by concatenating `dim_crm_person_id`, `dim_campaign_id`, and `bizible_touchpoint_date_time`, then hashing using `md5`.
*   **Case Statements:** Several calculated fields, like `is_fmm_influenced`, `integrated_budget_holder`, and various count fields, use case statements to derive values based on conditions.
*   **Data Type Casting:** Casting from one datatype to another is used for example when creating the `touchpoint_person_campaign_date_id`.
*   **String Manipulation:** Functions like `LOWER`, `LIKE`, `LEFT`, `RIGHT`, `SPLIT_PART`, and `REGEXP_COUNT` are extensively used for string pattern matching, extraction, and transformation in various fields, especially UTM parameters.
*   **Date Truncation:** The `bizible_touchpoint_month` field is derived by truncating the `bizible_touchpoint_date` to the month level.
*   **COALESCE:** The `COALESCE` function is used when selecting the final UTM parameters.
*   **Parsing:** The `PARSE_URL` function is used to get UTM parameters.

The SQL code for the core joining and transformations is:

```sql
, joined AS (
    SELECT
      -- touchpoint info
      dim_crm_touchpoint.dim_crm_touchpoint_id,
      md5(cast(coalesce(cast(fct_crm_touchpoint.dim_crm_person_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(dim_campaign.dim_campaign_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(dim_crm_touchpoint.bizible_touchpoint_date_time as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS touchpoint_person_campaign_date_id,
      dim_crm_touchpoint.bizible_touchpoint_date,
      dim_crm_touchpoint.bizible_touchpoint_date_time,
      dim_crm_touchpoint.bizible_touchpoint_month,
      dim_crm_touchpoint.bizible_touchpoint_position,
      dim_crm_touchpoint.bizible_touchpoint_source,
      dim_crm_touchpoint.bizible_touchpoint_source_type,
      dim_crm_touchpoint.bizible_touchpoint_type,
      dim_crm_touchpoint.touchpoint_offer_type,
      dim_crm_touchpoint.touchpoint_offer_type_grouped,
      dim_crm_touchpoint.bizible_ad_campaign_name,
      dim_crm_touchpoint.bizible_ad_content,
      dim_crm_touchpoint.bizible_ad_group_name,
      dim_crm_touchpoint.bizible_form_url,
      dim_crm_touchpoint.bizible_form_url_raw,
      dim_crm_touchpoint.bizible_landing_page,
      dim_crm_touchpoint.bizible_landing_page_raw,
      dim_crm_touchpoint.bizible_marketing_channel,
      dim_crm_touchpoint.bizible_marketing_channel_path,
      dim_crm_touchpoint.marketing_review_channel_grouping,
      dim_crm_touchpoint.bizible_medium,
      dim_crm_touchpoint.bizible_referrer_page,
      dim_crm_touchpoint.bizible_referrer_page_raw,
      dim_crm_touchpoint.bizible_form_page_utm_content,
      dim_crm_touchpoint.bizible_form_page_utm_budget,
      dim_crm_touchpoint.bizible_form_page_utm_allptnr,
      dim_crm_touchpoint.bizible_form_page_utm_partnerid,
      dim_crm_touchpoint.bizible_landing_page_utm_content,
      dim_crm_touchpoint.bizible_landing_page_utm_budget,
      dim_crm_touchpoint.bizible_landing_page_utm_allptnr,
      dim_crm_touchpoint.bizible_landing_page_utm_partnerid,
      dim_crm_touchpoint.utm_campaign,
      dim_crm_touchpoint.utm_source,
      dim_crm_touchpoint.utm_medium,
      dim_crm_touchpoint.utm_content,
      dim_crm_touchpoint.utm_budget,
      dim_crm_touchpoint.utm_allptnr,
      dim_crm_touchpoint.utm_partnerid,
      dim_crm_touchpoint.utm_campaign_date,
      dim_crm_touchpoint.utm_campaign_region,
      dim_crm_touchpoint.utm_campaign_budget,
      dim_crm_touchpoint.utm_campaign_type,
      dim_crm_touchpoint.utm_campaign_gtm,
      dim_crm_touchpoint.utm_campaign_language,
      dim_crm_touchpoint.utm_campaign_name,
      dim_crm_touchpoint.utm_campaign_agency,
      dim_crm_touchpoint.utm_content_offer,
      dim_crm_touchpoint.utm_content_asset_type,
      dim_crm_touchpoint.utm_content_industry,
      dim_crm_touchpoint.bizible_salesforce_campaign,
      dim_crm_touchpoint.bizible_integrated_campaign_grouping,
      dim_crm_touchpoint.touchpoint_segment,
      dim_crm_touchpoint.gtm_motion,
      dim_crm_touchpoint.integrated_campaign_grouping,
      dim_crm_touchpoint.pipe_name,
      dim_crm_touchpoint.is_dg_influenced,
      dim_crm_touchpoint.is_dg_sourced,
      fct_crm_touchpoint.bizible_count_first_touch,
      fct_crm_touchpoint.bizible_count_lead_creation_touch,
      fct_crm_touchpoint.bizible_count_u_shaped,
      dim_crm_touchpoint.bizible_created_date,
      dim_crm_touchpoint.devrel_campaign_type,
      dim_crm_touchpoint.devrel_campaign_description,
      dim_crm_touchpoint.devrel_campaign_influence_type,
      dim_crm_touchpoint.keystone_content_name,
      dim_crm_touchpoint.keystone_gitlab_epic,
      dim_crm_touchpoint.keystone_gtm,
      dim_crm_touchpoint.keystone_url_slug,
      dim_crm_touchpoint.keystone_type,
      -- person info
      fct_crm_touchpoint.dim_crm_person_id,
      dim_crm_person.sfdc_record_id,
      dim_crm_person.sfdc_record_type,
      dim_crm_person.marketo_lead_id,
      dim_crm_person.email_hash,
      dim_crm_person.email_domain,
      dim_crm_person.owner_id,
      dim_crm_person.person_score,
      dim_crm_person.title                                                 AS crm_person_title,
      dim_crm_person.country                                               AS crm_person_country,
      dim_crm_person.state                                                 AS crm_person_state,
      dim_crm_person.status                                                AS crm_person_status,
      dim_crm_person.lead_source,
      dim_crm_person.lead_source_type,
      dim_crm_person.source_buckets,
      dim_crm_person.net_new_source_categories,
      dim_crm_person.crm_partner_id,
      fct_crm_person.created_date                                          AS crm_person_created_date,
      fct_crm_person.inquiry_date,
      fct_crm_person.mql_date_first,
      fct_crm_person.mql_date_latest,
      fct_crm_person.legacy_mql_date_first,
      fct_crm_person.legacy_mql_date_latest,
      fct_crm_person.accepted_date,
      fct_crm_person.qualifying_date,
      fct_crm_person.qualified_date,
      fct_crm_person.converted_date,
      fct_crm_person.is_mql,
      fct_crm_person.is_inquiry,
      fct_crm_person.mql_count,
      fct_crm_person.last_utm_content,
      fct_crm_person.last_utm_campaign,
      fct_crm_person.true_inquiry_date,
      dim_crm_person.account_demographics_sales_segment,
      dim_crm_person.account_demographics_geo,
      dim_crm_person.account_demographics_region,
      dim_crm_person.account_demographics_area,
      dim_crm_person.is_partner_recalled,
      -- campaign info
      dim_campaign.dim_campaign_id,
      dim_campaign.campaign_name,
      dim_campaign.is_active                                               AS campagin_is_active,
      dim_campaign.status                                                  AS campaign_status,
      dim_campaign.type,
      dim_campaign.description,
      dim_campaign.budget_holder,
      dim_campaign.bizible_touchpoint_enabled_setting,
      dim_campaign.strategic_marketing_contribution,
      dim_campaign.large_bucket,
      dim_campaign.reporting_type,
      dim_campaign.allocadia_id,
      dim_campaign.is_a_channel_partner_involved,
      dim_campaign.is_an_alliance_partner_involved,
      dim_campaign.is_this_an_in_person_event,
      dim_campaign.will_there_be_mdf_funding,
      dim_campaign.alliance_partner_name,
      dim_campaign.channel_partner_name,
      dim_campaign.sales_play,
      dim_campaign.total_planned_mqls,
      fct_campaign.dim_parent_campaign_id,
      fct_campaign.campaign_owner_id,
      fct_campaign.created_by_id                                           AS campaign_created_by_id,
      fct_campaign.start_date                                              AS camapaign_start_date,
      fct_campaign.end_date                                                AS campaign_end_date,
      fct_campaign.created_date                                            AS campaign_created_date,
      fct_campaign.last_modified_date                                      AS campaign_last_modified_date,
      fct_campaign.last_activity_date                                      AS campaign_last_activity_date,
      fct_campaign.region                                                  AS campaign_region,
      fct_campaign.sub_region                                              AS campaign_sub_region,
      fct_campaign.budgeted_cost,
      fct_campaign.expected_response,
      fct_campaign.expected_revenue,
      fct_campaign.actual_cost,
      fct_campaign.amount_all_opportunities,
      fct_campaign.amount_won_opportunities,
      fct_campaign.count_contacts,
      fct_campaign.count_converted_leads,
      fct_campaign.count_leads,
      fct_campaign.count_opportunities,
      fct_campaign.count_responses,
      fct_campaign.count_won_opportunities,
      fct_campaign.count_sent,
      --planned values
      fct_campaign.planned_inquiry,
      fct_campaign.planned_mql,
      fct_campaign.planned_pipeline,
      fct_campaign.planned_sao,
      fct_campaign.planned_won,
      fct_campaign.planned_roi,
      fct_campaign.total_planned_mql,
      -- sales rep info
      dim_crm_user.user_name                               AS rep_name,
      dim_crm_user.title                                   AS rep_title,
      dim_crm_user.team,
      dim_crm_user.is_active                               AS rep_is_active,
      dim_crm_user.user_role_name,
      dim_crm_user.crm_user_sales_segment                  AS touchpoint_crm_user_segment_name_live,
      dim_crm_user.crm_user_geo                            AS touchpoint_crm_user_geo_name_live,
      dim_crm_user.crm_user_region                         AS touchpoint_crm_user_region_name_live,
      dim_crm_user.crm_user_area                           AS touchpoint_crm_user_area_name_live,
      dim_crm_user.sdr_sales_segment,
      dim_crm_user.sdr_region,
      -- campaign owner info
      campaign_owner.user_name                             AS campaign_rep_name,
      campaign_owner.title                                 AS campaign_rep_title,
      campaign_owner.team                                  AS campaign_rep_team,
      campaign_owner.is_active                             AS campaign_rep_is_active,
      campaign_owner.user_role_name                        AS campaign_rep_role_name,
      campaign_owner.crm_user_sales_segment                AS campaign_crm_user_segment_name_live,
      campaign_owner.crm_user_geo                          AS campaign_crm_user_geo_name_live,
      campaign_owner.crm_user_region                       AS campaign_crm_user_region_name_live,
      campaign_owner.crm_user_area                         AS campaign_crm_user_area_name_live,
      -- account info
      dim_crm_account.dim_crm_account_id,
      dim_crm_account.crm_account_name,
      dim_crm_account.crm_account_billing_country,
      dim_crm_account.crm_account_industry,
      dim_crm_account.crm_account_gtm_strategy,
      dim_crm_account.crm_account_focus_account,
      dim_crm_account.health_number,
      dim_crm_account.health_score_color,
      dim_crm_account.dim_parent_crm_account_id,
      dim_crm_account.parent_crm_account_name,
      dim_crm_account.parent_crm_account_sales_segment,
      dim_crm_account.parent_crm_account_industry,
      dim_crm_account.parent_crm_account_territory,
      dim_crm_account.parent_crm_account_region,
      dim_crm_account.parent_crm_account_area,
      dim_crm_account.crm_account_owner_user_segment,
      dim_crm_account.record_type_id,
      dim_crm_account.gitlab_com_user,
      dim_crm_account.crm_account_type,
      dim_crm_account.technical_account_manager,
      dim_crm_account.merged_to_account_id,
      dim_crm_account.is_reseller,
      dim_crm_account.is_focus_partner,
      -- bizible influenced
       CASE
        WHEN dim_campaign.budget_holder = 'fmm'
              OR campaign_rep_role_name = 'Field Marketing Manager'
              OR LOWER(dim_crm_touchpoint.utm_content) LIKE '%field%'
              OR LOWER(dim_campaign.type) = 'field event'
              OR LOWER(dim_crm_person.lead_source) = 'field event'
          THEN 1
        ELSE 0
      END AS is_fmm_influenced,
      CASE
        WHEN dim_crm_touchpoint.bizible_touchpoint_position LIKE '%FT%'
          AND is_fmm_influenced = 1
          THEN 1
        ELSE 0
      END AS is_fmm_sourced,
    --budget holder
    CASE
      WHEN LOWER(dim_campaign.budget_holder) = 'fmm'
        THEN 'Field Marketing'
      WHEN LOWER(dim_campaign.budget_holder) = 'dmp'
        THEN 'Digital Marketing'
      WHEN LOWER(dim_campaign.budget_holder) = 'corp'
        THEN 'Corporate Events'
      WHEN LOWER(dim_campaign.budget_holder)  = 'abm'
        THEN 'Account Based Marketing'
      WHEN LOWER(dim_campaign.budget_holder) LIKE '%cmp%'
        THEN 'Campaigns Team'
      WHEN LOWER(dim_campaign.budget_holder) = 'devrel' OR LOWER(dim_campaign.budget_holder) = 'cmty'
        THEN 'Developer Relations Team'
      WHEN LOWER(dim_campaign.budget_holder)  LIKE '%ptnr%' OR LOWER(dim_campaign.budget_holder)  LIKE '%chnl%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_budget)  = 'fmm'
        THEN 'Field Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) = 'dmp'
        THEN 'Digital Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) = 'corp'
        THEN 'Corporate Events'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) = 'abm'
        THEN 'Account Based Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) LIKE '%cmp%'
        THEN 'Campaigns Team'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) = 'devrel' OR LOWER(dim_crm_touchpoint.utm_budget) = 'cmty'
        THEN 'Developer Relations Team'
      WHEN LOWER(dim_crm_touchpoint.utm_budget)LIKE '%ptnr%' OR LOWER(dim_crm_touchpoint.utm_budget) LIKE '%chnl%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name) LIKE '%abm%'
        THEN 'Account Based Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%pmg%'
        THEN 'Digital Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%fmm%'
        THEN 'Field Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%dmp%'
        THEN 'Digital Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%brand%'
        THEN 'Brand Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%comm%'
        THEN 'Brand Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%cmp%'
        THEN 'Campaigns Team'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%corp%'
        THEN 'Corporate Events'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%lfc%'
        THEN 'Lifecycle Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%ptnr%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%partner%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%mdf%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_medium)  IN ('paidsocial','cpc')
        THEN 'Digital Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name) LIKE '%devopsgtm_'
        THEN 'Digital Marketing'
      WHEN LOWER(campaign_owner.user_role_name) LIKE '%field marketing%'
        THEN 'Field Marketing'
      WHEN LOWER(campaign_owner.user_role_name) LIKE '%abm%'
        THEN 'Account Based Marketing'
    END AS integrated_budget_holder,
    -- counts
     CASE
        WHEN dim_crm_touchpoint.bizible_touchpoint_position LIKE '%LC%'
          AND dim_crm_touchpoint.bizible_touchpoint_position NOT LIKE '%PostLC%'
          THEN 1
        ELSE 0
      END AS count_inquiry,
      CASE
        WHEN fct_crm_person.true_inquiry_date >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN 1
        ELSE 0
      END AS count_true_inquiry,
      CASE
        WHEN fct_crm_person.mql_date_first >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN 1
        ELSE 0
      END AS count_mql,
      CASE
        WHEN fct_crm_person.mql_date_first >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN fct_crm_touchpoint.bizible_count_lead_creation_touch
        ELSE 0
      END AS count_net_new_mql,
      CASE
        WHEN fct_crm_person.accepted_date >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN 1
        ELSE '0'
      END AS count_accepted,
      CASE
        WHEN fct_crm_person.accepted_date >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN fct_crm_touchpoint.bizible_count_lead_creation_touch
        ELSE 0
      END AS count_net_new_accepted,
      CASE
        WHEN count_mql=1 THEN dim_crm_person.sfdc_record_id
        ELSE NULL
      END AS mql_crm_person_id
    FROM fct_crm_touchpoint
    LEFT JOIN dim_crm_touchpoint
      ON fct_crm_touchpoint.dim_crm_touchpoint_id = dim_crm_touchpoint.dim_crm_touchpoint_id
    LEFT JOIN dim_campaign
      ON fct_crm_touchpoint.dim_campaign_id = dim_campaign.dim_campaign_id
    LEFT JOIN fct_campaign
      ON fct_crm_touchpoint.dim_campaign_id = fct_campaign.dim_campaign_id
    LEFT JOIN dim_crm_person
      ON fct_crm_touchpoint.dim_crm_person_id = dim_crm_person.dim_crm_person_id
    LEFT JOIN fct_crm_person
      ON fct_crm_touchpoint.dim_crm_person_id = fct_crm_person.dim_crm_person_id
    LEFT JOIN dim_crm_account
      ON fct_crm_touchpoint.dim_crm_account_id = dim_crm_account.dim_crm_account_id
    LEFT JOIN dim_crm_user AS campaign_owner
      ON fct_campaign.campaign_owner_id = campaign_owner.dim_crm_user_id
    LEFT JOIN dim_crm_user
      ON fct_crm_touchpoint.dim_crm_user_id = dim_crm_user.dim_crm_user_id
)
```

### Key Calculated Fields

Several key calculated fields are derived in the `mart_crm_touchpoint` table to support specific analytical use cases. These fields provide valuable insights into marketing influence, lead qualification, and touchpoint weighting.

*   `touchpoint_person_campaign_date_id`: A unique identifier for each touchpoint, created by hashing the combination of the CRM person ID, campaign ID, and touchpoint date/time.

    ```sql
    md5(cast(coalesce(cast(fct_crm_touchpoint.dim_crm_person_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(dim_campaign.dim_campaign_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(dim_crm_touchpoint.bizible_touchpoint_date_time as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS touchpoint_person_campaign_date_id
    ```
*   `is_fmm_influenced`: A flag indicating whether the touchpoint was influenced by Field Marketing, based on campaign budget holder, FMM user role, or UTM content.

    ```sql
       CASE
        WHEN dim_campaign.budget_holder = 'fmm'
              OR campaign_rep_role_name = 'Field Marketing Manager'
              OR LOWER(dim_crm_touchpoint.utm_content) LIKE '%field%'
              OR LOWER(dim_campaign.type) = 'field event'
              OR LOWER(dim_crm_person.lead_source) = 'field event'
          THEN 1
        ELSE 0
      END AS is_fmm_influenced
    ```
*   `is_fmm_sourced`: A flag indicating whether the touchpoint was sourced by Field Marketing, based on touchpoint position and `is_fmm_influenced` flag.

    ```sql
        CASE
        WHEN dim_crm_touchpoint.bizible_touchpoint_position LIKE '%FT%'
          AND is_fmm_influenced = 1
          THEN 1
        ELSE 0
      END AS is_fmm_sourced
    ```
*   `integrated_budget_holder`: A categorized value indicating the marketing team or function responsible for the touchpoint, derived from campaign budget holder, UTM budget, and Bizible ad campaign name.

    ```sql
    CASE
      WHEN LOWER(dim_campaign.budget_holder) = 'fmm'
        THEN 'Field Marketing'
      WHEN LOWER(dim_campaign.budget_holder) = 'dmp'
        THEN 'Digital Marketing'
      WHEN LOWER(dim_campaign.budget_holder) = 'corp'
        THEN 'Corporate Events'
      WHEN LOWER(dim_campaign.budget_holder)  = 'abm'
        THEN 'Account Based Marketing'
      WHEN LOWER(dim_campaign.budget_holder) LIKE '%cmp%'
        THEN 'Campaigns Team'
      WHEN LOWER(dim_campaign.budget_holder) = 'devrel' OR LOWER(dim_campaign.budget_holder) = 'cmty'
        THEN 'Developer Relations Team'
      WHEN LOWER(dim_campaign.budget_holder)  LIKE '%ptnr%' OR LOWER(dim_campaign.budget_holder)  LIKE '%chnl%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_budget)  = 'fmm'
        THEN 'Field Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) = 'dmp'
        THEN 'Digital Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) = 'corp'
        THEN 'Corporate Events'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) = 'abm'
        THEN 'Account Based Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) LIKE '%cmp%'
        THEN 'Campaigns Team'
      WHEN LOWER(dim_crm_touchpoint.utm_budget) = 'devrel' OR LOWER(dim_crm_touchpoint.utm_budget) = 'cmty'
        THEN 'Developer Relations Team'
      WHEN LOWER(dim_crm_touchpoint.utm_budget)LIKE '%ptnr%' OR LOWER(dim_crm_touchpoint.utm_budget) LIKE '%chnl%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name) LIKE '%abm%'
        THEN 'Account Based Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%pmg%'
        THEN 'Digital Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%fmm%'
        THEN 'Field Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%dmp%'
        THEN 'Digital Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%brand%'
        THEN 'Brand Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%comm%'
        THEN 'Brand Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%cmp%'
        THEN 'Campaigns Team'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%corp%'
        THEN 'Corporate Events'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%lfc%'
        THEN 'Lifecycle Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%ptnr%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%partner%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name)  LIKE '%mdf%'
        THEN 'Partner Marketing'
      WHEN LOWER(dim_crm_touchpoint.utm_medium)  IN ('paidsocial','cpc')
        THEN 'Digital Marketing'
      WHEN LOWER(dim_crm_touchpoint.bizible_ad_campaign_name) LIKE '%devopsgtm_'
        THEN 'Digital Marketing'
      WHEN LOWER(campaign_owner.user_role_name) LIKE '%field marketing%'
        THEN 'Field Marketing'
      WHEN LOWER(campaign_owner.user_role_name) LIKE '%abm%'
        THEN 'Account Based Marketing'
    END AS integrated_budget_holder
    ```
*   `count_inquiry`: A flag indicating whether the touchpoint is considered an inquiry touchpoint.

    ```sql
     CASE
        WHEN dim_crm_touchpoint.bizible_touchpoint_position LIKE '%LC%'
          AND dim_crm_touchpoint.bizible_touchpoint_position NOT LIKE '%PostLC%'
          THEN 1
        ELSE 0
      END AS count_inquiry
    ```
*   `count_true_inquiry`: A flag indicating whether the touchpoint occurred before the person's true inquiry date.

    ```sql
      CASE
        WHEN fct_crm_person.true_inquiry_date >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN 1
        ELSE 0
      END AS count_true_inquiry
    ```
*   `count_mql`: A flag indicating whether the touchpoint occurred before the person's first MQL date.

    ```sql
     CASE
        WHEN fct_crm_person.mql_