
CREATE TABLE "PROD".common_mart_marketing.mart_crm_touchpoint as
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
), count_of_pre_mql_tps AS (
    SELECT DISTINCT
      joined.email_hash,
      COUNT(DISTINCT joined.dim_crm_touchpoint_id) AS pre_mql_touches
    FROM joined
    WHERE joined.mql_date_first IS NOT NULL
      AND joined.bizible_touchpoint_date <= joined.mql_date_first
    GROUP BY 1
), pre_mql_tps_by_person AS (
    SELECT
      count_of_pre_mql_tps.email_hash,
      count_of_pre_mql_tps.pre_mql_touches,
      1/count_of_pre_mql_tps.pre_mql_touches AS pre_mql_weight
    FROM count_of_pre_mql_tps
    GROUP BY 1,2
), pre_mql_tps AS (
    SELECT
      joined.dim_crm_touchpoint_id,
      pre_mql_tps_by_person.pre_mql_weight
    FROM pre_mql_tps_by_person
    LEFT JOIN joined
      ON pre_mql_tps_by_person.email_hash=joined.email_hash
    WHERE joined.mql_date_first IS NOT NULL
      AND joined.bizible_touchpoint_date <= joined.mql_date_first
), post_mql_tps AS (
    SELECT
      joined.dim_crm_touchpoint_id,
      0 AS pre_mql_weight
    FROM joined
    WHERE joined.bizible_touchpoint_date > joined.mql_date_first
      OR joined.mql_date_first IS null
), mql_weighted_tps AS (
    SELECT *
    FROM pre_mql_tps
    UNION ALL
    SELECT *
    FROM post_mql_tps
),final AS (
  SELECT
    joined.*,
    mql_weighted_tps.pre_mql_weight
  FROM joined
  LEFT JOIN mql_weighted_tps
    ON joined.dim_crm_touchpoint_id=mql_weighted_tps.dim_crm_touchpoint_id
  WHERE joined.dim_crm_touchpoint_id IS NOT NULL
)
SELECT *
FROM final;

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

CREATE TABLE "PROD".restricted_safe_common.dim_crm_account as
WITH prep_crm_account AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_crm_account
), prep_charge_mrr AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_charge_mrr
), prep_date AS (
    SELECT *
    FROM "PROD".common_prep.prep_date
),
cohort_date AS (
  SELECT
    prep_charge_mrr.dim_crm_account_id,
    MIN(prep_date.first_day_of_month)          AS crm_account_arr_cohort_month,
    MIN(prep_date.first_day_of_fiscal_quarter) AS crm_account_arr_cohort_quarter
  FROM prep_charge_mrr
  LEFT JOIN prep_date
    ON prep_charge_mrr.date_id = prep_date.date_id
  WHERE prep_charge_mrr.subscription_status IN ('Active', 'Cancelled')
  GROUP BY 1
),
parent_cohort_date AS (
  SELECT
    prep_crm_account.dim_parent_crm_account_id,
    MIN(prep_date.first_day_of_month)          AS parent_account_arr_cohort_month,
    MIN(prep_date.first_day_of_fiscal_quarter) AS parent_account_arr_cohort_quarter
  FROM prep_charge_mrr
  LEFT JOIN prep_date
    ON prep_charge_mrr.date_id = prep_date.date_id
  LEFT JOIN prep_crm_account
    ON prep_charge_mrr.dim_crm_account_id = prep_crm_account.dim_crm_account_id
  WHERE prep_charge_mrr.subscription_status IN ('Active', 'Cancelled')
  GROUP BY 1
),
final AS (
  SELECT
    --primary key
    prep_crm_account.dim_crm_account_id,
    --surrogate keys
    prep_crm_account.dim_parent_crm_account_id,
    prep_crm_account.dim_crm_user_id,
    prep_crm_account.merged_to_account_id,
    prep_crm_account.record_type_id,
    prep_crm_account.master_record_id,
    prep_crm_account.dim_crm_person_primary_contact_id,
    --account people
    prep_crm_account.crm_account_owner,
    prep_crm_account.proposed_crm_account_owner,
    prep_crm_account.account_owner,
    prep_crm_account.technical_account_manager,
    prep_crm_account.tam_manager,
    prep_crm_account.executive_sponsor,
    prep_crm_account.owner_role,
    prep_crm_account.user_role_type,
    ----ultimate parent crm account info
    prep_crm_account.parent_crm_account_name,
    prep_crm_account.parent_crm_account_sales_segment,
    prep_crm_account.parent_crm_account_sales_segment_legacy,
    prep_crm_account.parent_crm_account_sales_segment_grouped,
    prep_crm_account.parent_crm_account_segment_region_stamped_grouped,
    prep_crm_account.parent_crm_account_industry,
    prep_crm_account.parent_crm_account_business_unit,
    prep_crm_account.parent_crm_account_geo,
    prep_crm_account.parent_crm_account_region,
    prep_crm_account.parent_crm_account_area,
    prep_crm_account.parent_crm_account_territory,
    prep_crm_account.parent_crm_account_role_type,
    prep_crm_account.parent_crm_account_max_family_employee,
    prep_crm_account.parent_crm_account_upa_country,
    prep_crm_account.parent_crm_account_upa_country_name,
    prep_crm_account.parent_crm_account_upa_state,
    prep_crm_account.parent_crm_account_upa_city,
    prep_crm_account.parent_crm_account_upa_street,
    prep_crm_account.parent_crm_account_upa_postal_code,
    --descriptive attributes
    prep_crm_account.crm_account_name,
    prep_crm_account.crm_account_employee_count,
    prep_crm_account.crm_account_gtm_strategy,
    prep_crm_account.crm_account_focus_account,
    prep_crm_account.crm_account_owner_user_segment,
    prep_crm_account.crm_account_billing_country,
    prep_crm_account.crm_account_billing_country_code,
    prep_crm_account.crm_account_type,
    prep_crm_account.crm_account_industry,
    prep_crm_account.crm_account_sub_industry,
    prep_crm_account.crm_account_employee_count_band,
    prep_crm_account.partner_vat_tax_id,
    prep_crm_account.account_manager,
    prep_crm_account.crm_business_dev_rep_id,
    prep_crm_account.dedicated_service_engineer,
    prep_crm_account.account_tier,
    prep_crm_account.account_tier_notes,
    prep_crm_account.license_utilization,
    prep_crm_account.support_level,
    prep_crm_account.named_account,
    prep_crm_account.billing_postal_code,
    prep_crm_account.partner_type,
    prep_crm_account.partner_status,
    prep_crm_account.gitlab_customer_success_project,
    prep_crm_account.demandbase_account_list,
    prep_crm_account.demandbase_intent,
    prep_crm_account.demandbase_page_views,
    prep_crm_account.demandbase_score,
    prep_crm_account.demandbase_sessions,
    prep_crm_account.demandbase_trending_offsite_intent,
    prep_crm_account.demandbase_trending_onsite_engagement,
    prep_crm_account.account_domains,
    prep_crm_account.account_domain_1,
    prep_crm_account.account_domain_2,
    prep_crm_account.is_locally_managed_account,
    prep_crm_account.is_strategic_account,
    prep_crm_account.partner_track,
    prep_crm_account.partners_partner_type,
    prep_crm_account.gitlab_partner_program,
    prep_crm_account.zoom_info_company_name,
    prep_crm_account.zoom_info_company_revenue,
    prep_crm_account.zoom_info_company_employee_count,
    prep_crm_account.zoom_info_company_industry,
    prep_crm_account.zoom_info_company_city,
    prep_crm_account.zoom_info_company_state_province,
    prep_crm_account.zoom_info_company_country,
    prep_crm_account.account_phone,
    prep_crm_account.zoominfo_account_phone,
    prep_crm_account.abm_tier,
    prep_crm_account.health_number,
    prep_crm_account.health_score_color,
    prep_crm_account.partner_account_iban_number,
    prep_crm_account.gitlab_com_user,
    prep_crm_account.crm_account_zi_technologies,
    prep_crm_account.crm_account_zoom_info_website,
    prep_crm_account.crm_account_zoom_info_company_other_domains,
    prep_crm_account.crm_account_zoom_info_dozisf_zi_id,
    prep_crm_account.crm_account_zoom_info_parent_company_zi_id,
    prep_crm_account.crm_account_zoom_info_parent_company_name,
    prep_crm_account.crm_account_zoom_info_ultimate_parent_company_zi_id,
    prep_crm_account.crm_account_zoom_info_ultimate_parent_company_name,
    prep_crm_account.forbes_2000_rank,
    prep_crm_account.crm_sales_dev_rep_id,
    prep_crm_account.admin_manual_source_number_of_employees,
    prep_crm_account.admin_manual_source_account_address,
    prep_crm_account.eoa_sentiment,
    prep_crm_account.gs_health_user_engagement,
    prep_crm_account.gs_health_cd,
    prep_crm_account.gs_health_devsecops,
    prep_crm_account.gs_health_ci,
    prep_crm_account.gs_health_scm,
    prep_crm_account.risk_impact,
    prep_crm_account.risk_reason,
    prep_crm_account.last_timeline_at_risk_update,
    prep_crm_account.last_at_risk_update_comments,
    prep_crm_account.bdr_prospecting_status,
    prep_crm_account.is_focus_partner,
    prep_crm_account.gs_health_csm_sentiment,
    prep_crm_account.bdr_next_steps,
    prep_crm_account.bdr_account_research,
    prep_crm_account.bdr_account_strategy,
    prep_crm_account.account_bdr_assigned_user_role,
    prep_crm_account.gs_csm_compensation_pool,
    prep_crm_account.groove_notes,
    prep_crm_account.groove_engagement_status,
    prep_crm_account.groove_inferred_status,
    prep_crm_account.compensation_target_account,
    prep_crm_account.pubsec_type,
    --measures (maintain for now to not break reporting)
    prep_crm_account.parent_crm_account_lam,
    prep_crm_account.parent_crm_account_lam_dev_count,
    prep_crm_account.carr_account_family,
    prep_crm_account.carr_this_account,
    --D&B Fields
    prep_crm_account.dnb_match_confidence_score,
    prep_crm_account.dnb_match_grade,
    prep_crm_account.dnb_connect_company_profile_id,
    prep_crm_account.dnb_duns,
    prep_crm_account.dnb_global_ultimate_duns,
    prep_crm_account.dnb_domestic_ultimate_duns,
    prep_crm_account.dnb_exclude_company,
    --6 sense fields
    prep_crm_account.has_six_sense_6_qa,
    prep_crm_account.risk_rate_guid,
    prep_crm_account.six_sense_account_profile_fit,
    prep_crm_account.six_sense_account_reach_score,
    prep_crm_account.six_sense_account_profile_score,
    prep_crm_account.six_sense_account_buying_stage,
    prep_crm_account.six_sense_account_numerical_reach_score,
    prep_crm_account.six_sense_account_update_date,
    prep_crm_account.six_sense_account_6_qa_end_date,
    prep_crm_account.six_sense_account_6_qa_age_days,
    prep_crm_account.six_sense_account_6_qa_start_date,
    prep_crm_account.six_sense_account_intent_score,
    prep_crm_account.six_sense_segments,
    --Qualified Fields
    prep_crm_account.qualified_days_since_last_activity,
    prep_crm_account.qualified_signals_active_session_time,
    prep_crm_account.qualified_signals_bot_conversation_count,
    prep_crm_account.qualified_condition,
    prep_crm_account.qualified_score,
    prep_crm_account.qualified_trend,
    prep_crm_account.qualified_meetings_booked,
    prep_crm_account.qualified_signals_rep_conversation_count,
    prep_crm_account.qualified_signals_research_state,
    prep_crm_account.qualified_signals_research_score,
    prep_crm_account.qualified_signals_session_count,
    prep_crm_account.qualified_visitors_count,
    --degenerative dimensions
    prep_crm_account.is_sdr_target_account,
    prep_crm_account.is_key_account,
    prep_crm_account.is_reseller,
    prep_crm_account.is_jihu_account,
    prep_crm_account.is_first_order_available,
    prep_crm_account.is_zi_jenkins_present,
    prep_crm_account.is_zi_svn_present,
    prep_crm_account.is_zi_tortoise_svn_present,
    prep_crm_account.is_zi_gcp_present,
    prep_crm_account.is_zi_atlassian_present,
    prep_crm_account.is_zi_github_present,
    prep_crm_account.is_zi_github_enterprise_present,
    prep_crm_account.is_zi_aws_present,
    prep_crm_account.is_zi_kubernetes_present,
    prep_crm_account.is_zi_apache_subversion_present,
    prep_crm_account.is_zi_apache_subversion_svn_present,
    prep_crm_account.is_zi_hashicorp_present,
    prep_crm_account.is_zi_aws_cloud_trail_present,
    prep_crm_account.is_zi_circle_ci_present,
    prep_crm_account.is_zi_bit_bucket_present,
    prep_crm_account.is_excluded_from_zoom_info_enrich,
    --dates
    prep_crm_account.crm_account_created_date,
    prep_crm_account.abm_tier_1_date,
    prep_crm_account.abm_tier_2_date,
    prep_crm_account.abm_tier_3_date,
    prep_crm_account.gtm_acceleration_date,
    prep_crm_account.gtm_account_based_date,
    prep_crm_account.gtm_account_centric_date,
    prep_crm_account.partners_signed_contract_date,
    prep_crm_account.technical_account_manager_date,
    prep_crm_account.customer_since_date,
    prep_crm_account.next_renewal_date,
    prep_crm_account.gs_first_value_date,
    prep_crm_account.gs_last_csm_activity_date,
    prep_crm_account.bdr_recycle_date,
    prep_crm_account.actively_working_start_date,
    cohort_date.crm_account_arr_cohort_month,
    cohort_date.crm_account_arr_cohort_quarter,
    parent_cohort_date.parent_account_arr_cohort_month,
    parent_cohort_date.parent_account_arr_cohort_quarter,
    --metadata
    prep_crm_account.created_by_name,
    prep_crm_account.last_modified_by_name,
    prep_crm_account.last_modified_date,
    prep_crm_account.last_activity_date,
    prep_crm_account.is_deleted,
    prep_crm_account.pte_score,
    prep_crm_account.pte_decile,
    prep_crm_account.pte_score_group,
    prep_crm_account.ptc_score,
    prep_crm_account.ptc_decile,
    prep_crm_account.ptc_score_group,
    prep_crm_account.ptp_score,
    prep_crm_account.ptp_score_value,
    prep_crm_account.ptp_insights
  FROM prep_crm_account
  LEFT JOIN cohort_date
    ON prep_crm_account.dim_crm_account_id = cohort_date.dim_crm_account_id
  LEFT JOIN parent_cohort_date
    ON prep_crm_account.dim_parent_crm_account_id = parent_cohort_date.dim_parent_crm_account_id
)
SELECT
      *,
      '@msendal'::VARCHAR       AS created_by,
      '@fmcwilliams'::VARCHAR       AS updated_by,
      '2020-06-01'::DATE        AS model_created_date,
      '2024-11-21'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common.dim_campaign as
WITH sfdc_campaign_info AS (
    SELECT *
    FROM "PROD".common_prep.prep_campaign
), final AS (
    SELECT
      dim_campaign_id,
      campaign_name,
      is_active,
      status,
      type,
      description,
      budget_holder,
      bizible_touchpoint_enabled_setting,
      strategic_marketing_contribution,
      large_bucket,
      reporting_type,
      allocadia_id,
      is_a_channel_partner_involved,
      is_an_alliance_partner_involved,
      is_this_an_in_person_event,
      alliance_partner_name,
      channel_partner_name,
      sales_play,
      gtm_motion,
      total_planned_mqls,
      registration_goal,
      attendance_goal,
      will_there_be_mdf_funding,
      mdf_request_id,
      campaign_partner_crm_id,
      series_campaign_id,
      series_campaign_name
    FROM sfdc_campaign_info
)
SELECT
      *,
      '@paul_armstrong'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2020-1-13'::DATE        AS model_created_date,
      '2024-10-24'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common.dim_crm_touchpoint as
WITH campaign_details AS (
    SELECT *
    FROM "PROD".common_prep.prep_campaign
), bizible_touchpoints AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_touchpoint
), prep_bizible_touchpoint_keystone AS (
    SELECT *
    FROM "PROD".common_prep.prep_bizible_touchpoint_keystone
), bizible_attribution_touchpoints AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_attribution_touchpoint
), bizible_touchpoints_with_campaign AS (
    SELECT
      bizible_touchpoints.*,
      campaign_details.dim_campaign_id,
      campaign_details.dim_parent_campaign_id
    FROM bizible_touchpoints
    LEFT JOIN campaign_details
      ON bizible_touchpoints.campaign_id = campaign_details.dim_campaign_id
), bizible_attribution_touchpoints_with_campaign AS (
    SELECT
      bizible_attribution_touchpoints.*,
      campaign_details.dim_campaign_id,
      campaign_details.dim_parent_campaign_id
    FROM bizible_attribution_touchpoints
    LEFT JOIN campaign_details
      ON bizible_attribution_touchpoints.campaign_id = campaign_details.dim_campaign_id
), bizible_campaign_grouping AS (
    SELECT *
    FROM "PROD".common_mapping.map_bizible_campaign_grouping
), devrel_influence_campaigns AS (
    SELECT *
    FROM "PREP".sheetload.sheetload_devrel_influenced_campaigns_source
), combined_touchpoints AS (
    SELECT
      --ids
      touchpoint_id                 AS dim_crm_touchpoint_id,
      -- touchpoint info
      bizible_touchpoint_date::DATE AS bizible_touchpoint_date,
      bizible_touchpoint_date AS bizible_touchpoint_date_time,
      DATE_TRUNC('month', bizible_touchpoint_date) AS bizible_touchpoint_month,
      bizible_touchpoint_position,
      bizible_touchpoint_source,
      bizible_touchpoint_source_type,
      bizible_touchpoint_type,
      touchpoint_offer_type,
      touchpoint_offer_type_grouped,
      bizible_ad_campaign_name,
      bizible_ad_content,
      bizible_ad_group_name,
      bizible_form_url,
      bizible_form_url_raw,
      bizible_landing_page,
      bizible_landing_page_raw,
    --UTMs not captured by the Bizible - Landing Page
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_campaign']::VARCHAR  AS bizible_landing_page_utm_campaign,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_medium']::VARCHAR    AS bizible_landing_page_utm_medium,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_source']::VARCHAR    AS bizible_landing_page_utm_source,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_content']::VARCHAR   AS bizible_landing_page_utm_content,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_budget']::VARCHAR    AS bizible_landing_page_utm_budget,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_allptnr']::VARCHAR   AS bizible_landing_page_utm_allptnr,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_partnerid']::VARCHAR AS bizible_landing_page_utm_partnerid,
    --UTMs not captured by the Bizible - Form Page
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_campaign']::VARCHAR     AS bizible_form_page_utm_campaign,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_medium']::VARCHAR       AS bizible_form_page_utm_medium,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_source']::VARCHAR       AS bizible_form_page_utm_source,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_content']::VARCHAR       AS bizible_form_page_utm_content,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_budget']::VARCHAR        AS bizible_form_page_utm_budget,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_allptnr']::VARCHAR       AS bizible_form_page_utm_allptnr,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_partnerid']::VARCHAR     AS bizible_form_page_utm_partnerid,
    --Final UTM Parameters
      COALESCE(bizible_landing_page_utm_campaign, bizible_form_page_utm_campaign)   AS utm_campaign,
      COALESCE(bizible_landing_page_utm_medium, bizible_form_page_utm_medium)       AS utm_medium,
      COALESCE(bizible_landing_page_utm_source, bizible_form_page_utm_source)       AS utm_source,
      COALESCE(bizible_landing_page_utm_budget, bizible_form_page_utm_budget)       AS utm_budget,
      COALESCE(bizible_landing_page_utm_content, bizible_form_page_utm_content)     AS utm_content,
      COALESCE(bizible_landing_page_utm_allptnr, bizible_form_page_utm_allptnr)     AS utm_allptnr,
      COALESCE(bizible_landing_page_utm_partnerid, bizible_form_page_utm_partnerid) AS utm_partnerid,
      -- new utm parsing
    CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 1)
END AS utm_campaign_date,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 2)
END AS utm_campaign_region,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 3)
END AS utm_campaign_budget,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 4)
END AS utm_campaign_type,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 5)
END AS utm_campaign_gtm,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 6)
END AS utm_campaign_language,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6
        AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
        AND LEFT(SPLIT_PART(utm_campaign , '_', 8), 2) = 'a-'
    THEN RIGHT(SPLIT_PART(utm_campaign , '_', 8), LENGTH(SPLIT_PART(utm_campaign , '_', 8)) - 2)
END AS utm_campaign_agency,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6
        AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
        AND LEFT(SPLIT_PART(utm_campaign , '_', 8), 2) = 'a-'
        THEN SUBSTRING(
            RIGHT(utm_campaign, LEN(utm_campaign) - regexp_instr(utm_campaign,
            '_', 1, 6)),
            1,
            CHARINDEX('_a-', RIGHT(utm_campaign, LEN(utm_campaign) - regexp_instr(utm_campaign, '_', 1, 6))) - 1
            )
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6
        AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
        THEN RIGHT(utm_campaign , LEN(utm_campaign ) - regexp_instr(utm_campaign ,'_',1,6))
END AS utm_campaign_name,
    CASE
    WHEN REGEXP_COUNT(utm_content, '_') >= 2
    THEN SPLIT_PART(utm_content , '_', 1)
END AS utm_content_offer,
CASE
    WHEN REGEXP_COUNT(utm_content, '_') >= 2
    THEN SPLIT_PART(utm_content , '_', 2)
END AS utm_content_asset_type,
CASE
    WHEN REGEXP_COUNT(utm_content, '_') >= 2
    THEN SPLIT_PART(utm_content , '_', 3)
END AS utm_content_industry,
      bizible_marketing_channel,
      bizible_marketing_channel_path,
      bizible_medium,
      bizible_referrer_page,
      bizible_referrer_page_raw,
      bizible_salesforce_campaign,
      '0'                           AS is_attribution_touchpoint,
      dim_campaign_id,
      dim_parent_campaign_id,
      bizible_created_date
    FROM bizible_touchpoints_with_campaign
    UNION ALL
    SELECT
      --ids
      touchpoint_id                 AS dim_crm_touchpoint_id,
      -- touchpoint info
      bizible_touchpoint_date::DATE AS bizible_touchpoint_date,
      bizible_touchpoint_date AS bizible_touchpoint_date_time,
      DATE_TRUNC('month', bizible_touchpoint_date) AS bizible_touchpoint_month,
      bizible_touchpoint_position,
      bizible_touchpoint_source,
      bizible_touchpoint_source_type,
      bizible_touchpoint_type,
      touchpoint_offer_type,
      touchpoint_offer_type_grouped,
      bizible_ad_campaign_name,
      bizible_ad_content,
      bizible_ad_group_name,
      bizible_form_url,
      bizible_form_url_raw,
      bizible_landing_page,
      bizible_landing_page_raw,
    --UTMs not captured by the Bizible - Landing Page
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_campaign']::VARCHAR  AS bizible_landing_page_utm_campaign,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_medium']::VARCHAR    AS bizible_landing_page_utm_medium,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_source']::VARCHAR    AS bizible_landing_page_utm_source,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_content']::VARCHAR   AS bizible_landing_page_utm_content,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_budget']::VARCHAR    AS bizible_landing_page_utm_budget,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_allptnr']::VARCHAR   AS bizible_landing_page_utm_allptnr,
      PARSE_URL(bizible_landing_page_raw)['parameters']['utm_partnerid']::VARCHAR AS bizible_landing_page_utm_partnerid,
    --UTMs not captured by the Bizible - Form Page
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_campaign']::VARCHAR     AS bizible_form_page_utm_campaign,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_medium']::VARCHAR       AS bizible_form_page_utm_medium,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_source']::VARCHAR       AS bizible_form_page_utm_source,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_content']::VARCHAR       AS bizible_form_page_utm_content,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_budget']::VARCHAR        AS bizible_form_page_utm_budget,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_allptnr']::VARCHAR       AS bizible_form_page_utm_allptnr,
      PARSE_URL(bizible_form_url_raw)['parameters']['utm_partnerid']::VARCHAR     AS bizible_form_page_utm_partnerid,
    --Final UTM Parameters
      COALESCE(bizible_landing_page_utm_campaign, bizible_form_page_utm_campaign)   AS utm_campaign,
      COALESCE(bizible_landing_page_utm_medium, bizible_form_page_utm_medium)       AS utm_medium,
      COALESCE(bizible_landing_page_utm_source, bizible_form_page_utm_source)       AS utm_source,
      COALESCE(bizible_landing_page_utm_budget, bizible_form_page_utm_budget)       AS utm_budget,
      COALESCE(bizible_landing_page_utm_content, bizible_form_page_utm_content)     AS utm_content,
      COALESCE(bizible_landing_page_utm_allptnr, bizible_form_page_utm_allptnr)     AS utm_allptnr,
      COALESCE(bizible_landing_page_utm_partnerid, bizible_form_page_utm_partnerid) AS utm_partnerid,
    -- new utm parsing
    CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 1)
END AS utm_campaign_date,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 2)
END AS utm_campaign_region,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 3)
END AS utm_campaign_budget,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 4)
END AS utm_campaign_type,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 5)
END AS utm_campaign_gtm,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6 AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
    THEN SPLIT_PART(utm_campaign , '_', 6)
END AS utm_campaign_language,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6
        AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
        AND LEFT(SPLIT_PART(utm_campaign , '_', 8), 2) = 'a-'
    THEN RIGHT(SPLIT_PART(utm_campaign , '_', 8), LENGTH(SPLIT_PART(utm_campaign , '_', 8)) - 2)
END AS utm_campaign_agency,
CASE
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6
        AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
        AND LEFT(SPLIT_PART(utm_campaign , '_', 8), 2) = 'a-'
        THEN SUBSTRING(
            RIGHT(utm_campaign, LEN(utm_campaign) - regexp_instr(utm_campaign,
            '_', 1, 6)),
            1,
            CHARINDEX('_a-', RIGHT(utm_campaign, LEN(utm_campaign) - regexp_instr(utm_campaign, '_', 1, 6))) - 1
            )
    WHEN REGEXP_COUNT(utm_campaign, '_') >= 6
        AND (REGEXP_LIKE(utm_campaign, '.*(20[0-9]{6}).*') OR LEFT(utm_campaign, 3) = 'eg_')
        THEN RIGHT(utm_campaign , LEN(utm_campaign ) - regexp_instr(utm_campaign ,'_',1,6))
END AS utm_campaign_name,
    CASE
    WHEN REGEXP_COUNT(utm_content, '_') >= 2
    THEN SPLIT_PART(utm_content , '_', 1)
END AS utm_content_offer,
CASE
    WHEN REGEXP_COUNT(utm_content, '_') >= 2
    THEN SPLIT_PART(utm_content , '_', 2)
END AS utm_content_asset_type,
CASE
    WHEN REGEXP_COUNT(utm_content, '_') >= 2
    THEN SPLIT_PART(utm_content , '_', 3)
END AS utm_content_industry,
      bizible_marketing_channel,
      CASE
        WHEN dim_parent_campaign_id = '7014M000001dn8MQAQ' THEN 'Paid Social.LinkedIn Lead Gen'
        WHEN bizible_ad_campaign_name = '20201013_ActualTechMedia_DeepMonitoringCI' THEN 'Sponsorship'
        ELSE bizible_marketing_channel_path
      END AS bizible_marketing_channel_path,
      bizible_medium,
      bizible_referrer_page,
      bizible_referrer_page_raw,
      bizible_salesforce_campaign,
      '1'                           AS is_attribution_touchpoint,
      dim_campaign_id,
      dim_parent_campaign_id,
      bizible_created_date
    FROM bizible_attribution_touchpoints_with_campaign
), final AS (
    SELECT
      combined_touchpoints.dim_crm_touchpoint_id,
      combined_touchpoints.bizible_touchpoint_date,
      combined_touchpoints.bizible_touchpoint_date_time,
      combined_touchpoints.bizible_touchpoint_month,
      combined_touchpoints.bizible_touchpoint_position,
      combined_touchpoints.bizible_touchpoint_source,
      combined_touchpoints.bizible_touchpoint_source_type,
      combined_touchpoints.bizible_touchpoint_type,
      combined_touchpoints.touchpoint_offer_type,
      combined_touchpoints.touchpoint_offer_type_grouped,
      combined_touchpoints.bizible_ad_campaign_name,
      combined_touchpoints.bizible_ad_content,
      combined_touchpoints.bizible_ad_group_name,
      combined_touchpoints.bizible_form_url,
      combined_touchpoints.bizible_form_url_raw,
      combined_touchpoints.bizible_landing_page,
      combined_touchpoints.bizible_landing_page_raw,
      combined_touchpoints.bizible_form_page_utm_content,
      combined_touchpoints.bizible_form_page_utm_budget,
      combined_touchpoints.bizible_form_page_utm_allptnr,
      combined_touchpoints.bizible_form_page_utm_partnerid,
      combined_touchpoints.bizible_landing_page_utm_content,
      combined_touchpoints.bizible_landing_page_utm_budget,
      combined_touchpoints.bizible_landing_page_utm_allptnr,
      combined_touchpoints.bizible_landing_page_utm_partnerid,
      combined_touchpoints.utm_campaign,
      combined_touchpoints.utm_medium,
      combined_touchpoints.utm_source,
      combined_touchpoints.utm_content,
      combined_touchpoints.utm_budget,
      combined_touchpoints.utm_allptnr,
      combined_touchpoints.utm_partnerid,
      combined_touchpoints.utm_campaign_date,
      combined_touchpoints.utm_campaign_region,
      combined_touchpoints.utm_campaign_budget,
      combined_touchpoints.utm_campaign_type,
      combined_touchpoints.utm_campaign_gtm,
      combined_touchpoints.utm_campaign_language,
      combined_touchpoints.utm_campaign_name,
      combined_touchpoints.utm_campaign_agency,
      combined_touchpoints.utm_content_offer,
      combined_touchpoints.utm_content_asset_type,
      combined_touchpoints.utm_content_industry,
      combined_touchpoints.bizible_marketing_channel,
      combined_touchpoints.bizible_marketing_channel_path,
      CASE
        WHEN combined_touchpoints.bizible_marketing_channel IN ('Paid Search', 'Content', 'Paid Social')
          THEN 'Paid Demand Gen'
        WHEN combined_touchpoints.bizible_marketing_channel IN ('Event')
          THEN 'Events'
        WHEN combined_touchpoints.bizible_marketing_channel IN ('Email')
          THEN 'Email Nurture'
        WHEN combined_touchpoints.bizible_marketing_channel IN ('Other','Direct', 'Organic Search', 'Digital', 'Web Referral', 'Social')
          THEN 'Inbound Demand'
        WHEN combined_touchpoints.bizible_marketing_channel IN ('SDR Generated')
          THEN 'Outbound Demand'
        WHEN combined_touchpoints.bizible_marketing_channel IN ('Referral')
          THEN 'Partner'
        ELSE CONCAT('not-grouped - ',combined_touchpoints.bizible_marketing_channel)
      END AS marketing_review_channel_grouping,
      combined_touchpoints.bizible_medium,
      combined_touchpoints.bizible_referrer_page,
      combined_touchpoints.bizible_referrer_page_raw,
      combined_touchpoints.bizible_salesforce_campaign,
      combined_touchpoints.is_attribution_touchpoint,
      bizible_campaign_grouping.integrated_campaign_grouping,
      bizible_campaign_grouping.bizible_integrated_campaign_grouping,
      bizible_campaign_grouping.gtm_motion,
      bizible_campaign_grouping.touchpoint_segment,
      CASE
        WHEN combined_touchpoints.dim_crm_touchpoint_id ILIKE 'a6061000000CeS0%' -- Specific touchpoint overrides
          THEN 'Field Event'
        WHEN combined_touchpoints.bizible_marketing_channel_path = 'CPC.AdWords'
          THEN 'Google AdWords'
        WHEN combined_touchpoints.bizible_marketing_channel_path IN ('Email.Other', 'Email.Newsletter','Email.Outreach')
          THEN 'Email'
        WHEN combined_touchpoints.bizible_marketing_channel_path IN ('Field Event','Partners.Google','Brand.Corporate Event','Conference','Speaking Session')
                  OR (combined_touchpoints.bizible_medium = 'Field Event (old)' AND combined_touchpoints.bizible_marketing_channel_path = 'Other')
          THEN 'Field Event'
        WHEN combined_touchpoints.bizible_marketing_channel_path IN ('Paid Social.Facebook','Paid Social.LinkedIn','Paid Social.Twitter','Paid Social.YouTube')
          THEN 'Paid Social'
        WHEN combined_touchpoints.bizible_marketing_channel_path IN ('Social.Facebook','Social.LinkedIn','Social.Twitter','Social.YouTube')
          THEN 'Social'
        WHEN combined_touchpoints.bizible_marketing_channel_path IN ('Marketing Site.Web Referral','Web Referral')
          THEN 'Web Referral'
        WHEN combined_touchpoints.bizible_marketing_channel_path in ('Marketing Site.Web Direct', 'Web Direct')
              -- Added to Web Direct
              OR combined_touchpoints.dim_campaign_id in (
                                '701610000008ciRAAQ', -- Trial - GitLab.com
                                '70161000000VwZbAAK', -- Trial - Self-Managed
                                '70161000000VwZgAAK', -- Trial - SaaS
                                '70161000000CnSLAA0', -- 20181218_DevOpsVirtual
                                '701610000008cDYAAY'  -- 2018_MovingToGitLab
                                )
          THEN 'Web Direct'
        WHEN combined_touchpoints.bizible_marketing_channel_path LIKE 'Organic Search.%'
              OR combined_touchpoints.bizible_marketing_channel_path = 'Marketing Site.Organic'
          THEN 'Organic Search'
        WHEN combined_touchpoints.bizible_marketing_channel_path IN ('Sponsorship')
          THEN 'Paid Sponsorship'
        ELSE 'Unknown'
      END AS pipe_name,
      CASE
        WHEN touchpoint_segment = 'Demand Gen' THEN 1
        ELSE 0
      END AS is_dg_influenced,
      CASE
        WHEN combined_touchpoints.bizible_touchpoint_position LIKE '%FT%'
          AND is_dg_influenced = 1
          THEN 1
        ELSE 0
      END AS is_dg_sourced,
      combined_touchpoints.bizible_created_date,
      CASE
        WHEN devrel_influence_campaigns.campaign_name IS NOT NULL
          THEN TRUE
          ELSE FALSE
      END AS is_devrel_influenced_campaign,
      devrel_influence_campaigns.campaign_type      AS devrel_campaign_type,
      devrel_influence_campaigns.description        AS devrel_campaign_description,
      devrel_influence_campaigns.influence_type     AS devrel_campaign_influence_type,
      prep_bizible_touchpoint_keystone.content_name AS keystone_content_name,
      prep_bizible_touchpoint_keystone.gitlab_epic  AS keystone_gitlab_epic,
      prep_bizible_touchpoint_keystone.gtm          AS keystone_gtm,
      prep_bizible_touchpoint_keystone.url_slug     AS keystone_url_slug,
      prep_bizible_touchpoint_keystone.type         AS keystone_type
    FROM combined_touchpoints
    LEFT JOIN bizible_campaign_grouping
      ON combined_touchpoints.dim_crm_touchpoint_id = bizible_campaign_grouping.dim_crm_touchpoint_id
    LEFT JOIN devrel_influence_campaigns
      ON combined_touchpoints.bizible_ad_campaign_name = devrel_influence_campaigns.campaign_name
    LEFT JOIN prep_bizible_touchpoint_keystone
      ON combined_touchpoints.dim_crm_touchpoint_id=prep_bizible_touchpoint_keystone.dim_crm_touchpoint_id
    WHERE combined_touchpoints.dim_crm_touchpoint_id IS NOT NULL
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2021-01-21'::DATE        AS model_created_date,
      '2024-12-19'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common.fct_campaign as
WITH sfdc_campaigns AS (
    SELECT *
    FROM "PROD".common_prep.prep_campaign
), final_campaigns AS (
    SELECT
      -- campaign ids
      dim_campaign_id,
      dim_parent_campaign_id,
      -- user ids
      campaign_owner_id,
      created_by_id,
      last_modified_by_id,
      -- dates
      start_date,
  TO_NUMBER(TO_CHAR(start_date::DATE,'YYYYMMDD'),'99999999')
              AS start_date_id,
      end_date,
  TO_NUMBER(TO_CHAR(end_date::DATE,'YYYYMMDD'),'99999999')
                AS end_date_id,
      created_date,
  TO_NUMBER(TO_CHAR(created_date::DATE,'YYYYMMDD'),'99999999')
            AS created_date_id,
      last_modified_date,
  TO_NUMBER(TO_CHAR(last_modified_date::DATE,'YYYYMMDD'),'99999999')
      AS last_modified_date_id,
      last_activity_date,
  TO_NUMBER(TO_CHAR(last_activity_date::DATE,'YYYYMMDD'),'99999999')
      AS last_activity_date_id,
      region,
      sub_region,
      --planned values
      planned_inquiry,
      planned_mql,
      planned_pipeline,
      planned_sao,
      planned_won,
      planned_roi,
      total_planned_mql,
      -- additive fields
      budgeted_cost,
      expected_response,
      expected_revenue,
      actual_cost,
      amount_all_opportunities,
      amount_won_opportunities,
      count_contacts,
      count_converted_leads,
      count_leads,
      count_opportunities,
      count_responses,
      count_won_opportunities,
      count_sent
    FROM sfdc_campaigns
)
SELECT *
FROM final_campaigns;

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
), account_history_final AS (
  SELECT
    account_id_18 AS dim_crm_account_id,
    owner_id AS dim_crm_user_id,
    ultimate_parent_id AS dim_crm_parent_account_id,
    abm_tier_1_date,
    abm_tier_2_date,
    abm_tier,
    MIN(dbt_valid_from)::DATE AS valid_from,
    MAX(dbt_valid_to)::DATE AS valid_to
  FROM "PROD".legacy.sfdc_account_snapshots_source
  WHERE abm_tier_1_date >= '2022-02-01'
    OR abm_tier_2_date >= '2022-02-01'
  group by 1,2,3,4,5,6
), industry AS (
    SELECT *
    FROM "PROD".common_prep.prep_industry
), bizible_marketing_channel_path AS (
    SELECT *
    FROM "PROD".common_prep.prep_bizible_marketing_channel_path
), bizible_marketing_channel_path_mapping AS (
    SELECT *
    FROM "PROD".common_mapping.map_bizible_marketing_channel_path
), sales_segment AS (
      SELECT *
      FROM "PROD".common.dim_sales_segment
), sales_territory AS (
    SELECT *
    FROM "PROD".common_prep.prep_sales_territory
), sfdc_contacts AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_contact_source
    WHERE is_deleted = 'FALSE'
), sfdc_leads AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_lead_source
    WHERE is_deleted = 'FALSE'
), sfdc_lead_converted AS (
    SELECT *
    FROM sfdc_leads
    WHERE is_converted
    QUALIFY ROW_NUMBER() OVER(PARTITION BY converted_contact_id ORDER BY converted_date DESC) = 1
), prep_crm_user_hierarchy AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_user_hierarchy
), marketing_qualified_leads AS(
    SELECT
      md5(cast(coalesce(cast(COALESCE(converted_contact_id, lead_id) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(marketo_qualified_lead_datetime::timestamp as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS mql_event_id,
      marketo_qualified_lead_datetime::timestamp                                                                          AS mql_event_timestamp,
      initial_marketo_mql_date_time::timestamp                                                                            AS initial_mql_event_timestamp,
      true_mql_date::timestamp                                                                                            AS legacy_mql_event_timestamp,
      mql_datetime_inferred::timestamp                                                                                    AS inferred_mql_event_timestamp,
      lead_id                                                                                                             AS sfdc_record_id,
      'lead'                                                                                                              AS sfdc_record,
      md5(cast(coalesce(cast(COALESCE(converted_contact_id, lead_id) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                          AS crm_person_id,
      converted_contact_id                                                                                                AS contact_id,
      converted_account_id                                                                                                AS account_id,
      owner_id                                                                                                            AS crm_user_id,
      person_score                                                                                                        AS person_score
    FROM sfdc_leads
    WHERE marketo_qualified_lead_datetime IS NOT NULL
      OR mql_datetime_inferred IS NOT NULL
), marketing_qualified_contacts AS(
    SELECT
      md5(cast(coalesce(cast(contact_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(marketo_qualified_lead_datetime::timestamp as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                          AS mql_event_id,
      marketo_qualified_lead_datetime::timestamp                                                                          AS mql_event_timestamp,
      initial_marketo_mql_date_time::timestamp                                                                            AS initial_mql_event_timestamp,
      true_mql_date::timestamp                                                                                            AS legacy_mql_event_timestamp,
      mql_datetime_inferred::timestamp                                                                                    AS inferred_mql_event_timestamp,
      contact_id                                                                                                          AS sfdc_record_id,
      'contact'                                                                                                           AS sfdc_record,
      md5(cast(coalesce(cast(contact_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                                       AS crm_person_id,
      contact_id                                                                                                          AS contact_id,
      account_id                                                                                                          AS account_id,
      owner_id                                                                                                            AS crm_user_id,
      person_score                                                                                                        AS person_score
    FROM sfdc_contacts
    WHERE marketo_qualified_lead_datetime IS NOT NULL
      OR mql_datetime_inferred IS NOT NULL
    HAVING mql_event_id NOT IN (
                         SELECT mql_event_id
                         FROM marketing_qualified_leads
                         )
), mqls_unioned AS (
    SELECT *
    FROM marketing_qualified_leads
    UNION
    SELECT *
    FROM marketing_qualified_contacts
), mqls AS (
    SELECT
      crm_person_id,
      MIN(mql_event_timestamp)          AS first_mql_date,
      MAX(mql_event_timestamp)          AS last_mql_date,
      MIN(initial_mql_event_timestamp)  AS first_initial_mql_date,
      MIN(legacy_mql_event_timestamp)   AS first_legacy_mql_date,
      MAX(legacy_mql_event_timestamp)   AS last_legacy_mql_date,
      MIN(inferred_mql_event_timestamp) AS first_inferred_mql_date,
      MAX(inferred_mql_event_timestamp) AS last_inferred_mql_date,
      COUNT(*)                          AS mql_count
    FROM mqls_unioned
    GROUP BY 1
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
      account_dims_mapping.dim_parent_crm_account_id,                                                          -- dim_parent_crm_account_id
      COALESCE(account_dims_mapping.dim_account_sales_segment_id, sales_segment.dim_sales_segment_id)          AS dim_account_sales_segment_id,
      COALESCE(account_dims_mapping.dim_account_sales_territory_id, sales_territory.dim_sales_territory_id)    AS dim_account_sales_territory_id,
      COALESCE(account_dims_mapping.dim_account_industry_id, industry.dim_industry_id)                         AS dim_account_industry_id,
      account_dims_mapping.dim_account_location_country_id,                                                    -- dim_account_location_country_id
      account_dims_mapping.dim_account_location_region_id,                                                     -- dim_account_location_region_id
      account_dims_mapping.dim_parent_sales_segment_id,                                                        -- dim_parent_sales_segment_id
      account_dims_mapping.dim_parent_sales_territory_id,                                                      -- dim_parent_sales_territory_id
      account_dims_mapping.dim_parent_industry_id,                                                             -- dim_parent_industry_id
  COALESCE(bizible_marketing_channel_path.dim_bizible_marketing_channel_path_id, MD5(-1))
            AS dim_bizible_marketing_channel_path_id,
  COALESCE(prep_crm_user_hierarchy.dim_crm_user_hierarchy_id, MD5(-1))
                               AS dim_account_demographics_hierarchy_id,
      crm_person.dim_account_demographics_hierarchy_sk,
  COALESCE(prep_crm_user_hierarchy.dim_crm_user_sales_segment_id, MD5(-1))
                           AS dim_account_demographics_sales_segment_id,
  COALESCE(prep_crm_user_hierarchy.dim_crm_user_geo_id, MD5(-1))
                                     AS dim_account_demographics_geo_id,
  COALESCE(prep_crm_user_hierarchy.dim_crm_user_region_id, MD5(-1))
                                  AS dim_account_demographics_region_id,
  COALESCE(prep_crm_user_hierarchy.dim_crm_user_area_id, MD5(-1))
                                    AS dim_account_demographics_area_id,
     -- important person dates
      COALESCE(sfdc_leads.created_date, sfdc_lead_converted.created_date, sfdc_contacts.created_date)::DATE
                                                                                                                AS created_date,
  TO_NUMBER(TO_CHAR(COALESCE(sfdc_leads.created_date, sfdc_lead_converted.created_date, sfdc_contacts.created_date)::DATE,'YYYYMMDD'),'99999999')
                                                                                                                AS created_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', COALESCE(sfdc_leads.created_date, sfdc_lead_converted.created_date, sfdc_contacts.created_date))::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                                                                AS created_date_pt_id,
      COALESCE(sfdc_leads.created_date, sfdc_lead_converted.created_date)::DATE                                 AS lead_created_date,
  TO_NUMBER(TO_CHAR(COALESCE(sfdc_leads.created_date, sfdc_lead_converted.created_date)::DATE::DATE,'YYYYMMDD'),'99999999')
            AS lead_created_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', COALESCE(sfdc_leads.created_date, sfdc_lead_converted.created_date)::DATE)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
         AS lead_created_date_pt_id,
      sfdc_contacts.created_date::DATE                                                                          AS contact_created_date,
  TO_NUMBER(TO_CHAR(sfdc_contacts.created_date::DATE::DATE,'YYYYMMDD'),'99999999')
                                                     AS contact_created_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', sfdc_contacts.created_date::DATE)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                  AS contact_created_date_pt_id,
      COALESCE(sfdc_contacts.inquiry_datetime, sfdc_leads.inquiry_datetime)::DATE                               AS inquiry_date,
  TO_NUMBER(TO_CHAR(inquiry_date::DATE,'YYYYMMDD'),'99999999')
                                                                         AS inquiry_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', inquiry_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                      AS inquiry_date_pt_id,
      COALESCE(sfdc_contacts.inquiry_datetime_inferred, sfdc_leads.inquiry_datetime_inferred)::DATE             AS inquiry_inferred_datetime,
  TO_NUMBER(TO_CHAR(inquiry_inferred_datetime::DATE,'YYYYMMDD'),'99999999')
                                                            AS inquiry_inferred_datetime_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', inquiry_inferred_datetime)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                         AS inquiry_inferred_datetime_pt_id,
      LEAST(COALESCE(inquiry_date,'9999-01-01'),COALESCE(inquiry_inferred_datetime,'9999-01-01'))               AS prep_true_inquiry_date,
      CASE
        WHEN prep_true_inquiry_date != '9999-01-01'
        THEN prep_true_inquiry_date
      END                                                                                                       AS true_inquiry_date,
  TO_NUMBER(TO_CHAR(true_inquiry_date::DATE,'YYYYMMDD'),'99999999')
                                                                    AS true_inquiry_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', true_inquiry_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                 AS true_inquiry_date_pt_id,
      mqls.first_mql_date::DATE                                                                                 AS mql_date_first,
      mqls.first_mql_date                                                                                       AS mql_datetime_first,
      CONVERT_TIMEZONE('America/Los_Angeles', mqls.first_mql_date)                                              AS mql_datetime_first_pt,
  TO_NUMBER(TO_CHAR(first_mql_date::DATE,'YYYYMMDD'),'99999999')
                                                                       AS mql_date_first_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', first_mql_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                    AS mql_date_first_pt_id,
      mqls.last_mql_date::DATE                                                                                  AS mql_date_latest,
      mqls.last_mql_date                                                                                        AS mql_datetime_latest,
      CONVERT_TIMEZONE('America/Los_Angeles', mqls.last_mql_date)                                               AS mql_datetime_latest_pt,
  TO_NUMBER(TO_CHAR(last_mql_date::DATE,'YYYYMMDD'),'99999999')
                                                                        AS mql_date_latest_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', last_mql_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                     AS mql_date_latest_pt_id,
      mqls.first_initial_mql_date::DATE                                                                         AS initial_mql_date_first,
      mqls.first_initial_mql_date                                                                               AS initial_mql_datetime_first,
      CONVERT_TIMEZONE('America/Los_Angeles', mqls.first_initial_mql_date)                                      AS initial_mql_datetime_first_pt,
  TO_NUMBER(TO_CHAR(first_initial_mql_date::DATE,'YYYYMMDD'),'99999999')
                                                               AS initial_mql_date_first_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', first_initial_mql_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                            AS initial_mql_date_first_pt_id,
      mqls.first_legacy_mql_date::DATE                                                                          AS legacy_mql_date_first,
      mqls.first_legacy_mql_date                                                                                AS legacy_mql_datetime_first,
      CONVERT_TIMEZONE('America/Los_Angeles', mqls.first_legacy_mql_date)                                       AS legacy_mql_datetime_first_pt,
  TO_NUMBER(TO_CHAR(legacy_mql_date_first::DATE,'YYYYMMDD'),'99999999')
                                                                AS legacy_mql_date_first_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', legacy_mql_date_first)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                             AS legacy_mql_date_first_pt_id,
      mqls.last_legacy_mql_date::DATE                                                                           AS legacy_mql_date_latest,
      mqls.last_legacy_mql_date                                                                                 AS legacy_mql_datetime_latest,
      CONVERT_TIMEZONE('America/Los_Angeles', mqls.last_legacy_mql_date)                                        AS legacy_mql_datetime_latest_pt,
  TO_NUMBER(TO_CHAR(last_legacy_mql_date::DATE,'YYYYMMDD'),'99999999')
                                                                 AS legacy_mql_date_latest_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', last_legacy_mql_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                              AS legacy_mql_date_latest_pt_id,
      mqls.first_inferred_mql_date::DATE                                                                        AS inferred_mql_date_first,
      mqls.first_inferred_mql_date                                                                              AS inferred_mql_datetime_first,
      CONVERT_TIMEZONE('America/Los_Angeles', mqls.first_inferred_mql_date)                                     AS inferred_mql_datetime_first_pt,
  TO_NUMBER(TO_CHAR(first_inferred_mql_date::DATE,'YYYYMMDD'),'99999999')
                                                              AS inferred_mql_date_first_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', first_inferred_mql_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                           AS inferred_mql_date_first_pt_id,
      mqls.last_inferred_mql_date::DATE                                                                         AS inferred_mql_date_latest,
      mqls.last_inferred_mql_date                                                                               AS inferred_mql_datetime_latest,
      CONVERT_TIMEZONE('America/Los_Angeles', mqls.last_inferred_mql_date)                                      AS inferred_mql_datetime_latest_pt,
  TO_NUMBER(TO_CHAR(last_inferred_mql_date::DATE,'YYYYMMDD'),'99999999')
                                                               AS inferred_mql_date_latest_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', last_inferred_mql_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                            AS inferred_mql_date_latest_pt_id,
      COALESCE(sfdc_contacts.marketo_qualified_lead_datetime, sfdc_leads.marketo_qualified_lead_datetime)::DATE
                                                                                                                AS mql_sfdc_date,
      COALESCE(sfdc_contacts.marketo_qualified_lead_datetime, sfdc_leads.marketo_qualified_lead_datetime)       AS mql_sfdc_datetime,
  TO_NUMBER(TO_CHAR(mql_sfdc_date::DATE,'YYYYMMDD'),'99999999')
                                                                        AS mql_sfdc_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', mql_sfdc_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                     AS mql_sfdc_date_pt_id,
      COALESCE(sfdc_contacts.mql_datetime_inferred, sfdc_leads.mql_datetime_inferred)::DATE                     AS mql_inferred_date,
      COALESCE(sfdc_contacts.mql_datetime_inferred, sfdc_leads.mql_datetime_inferred)                           AS mql_inferred_datetime,
  TO_NUMBER(TO_CHAR(mql_inferred_date::DATE,'YYYYMMDD'),'99999999')
                                                                    AS mql_inferred_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', mql_inferred_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                 AS mql_inferred_date_pt_id,
      COALESCE(sfdc_contacts.accepted_datetime, sfdc_leads.accepted_datetime)::DATE                             AS accepted_date,
      COALESCE(sfdc_contacts.accepted_datetime, sfdc_leads.accepted_datetime)                                   AS accepted_datetime,
      CONVERT_TIMEZONE('America/Los_Angeles', COALESCE(sfdc_contacts.accepted_datetime, sfdc_leads.accepted_datetime))
                                                                                                                AS accepted_datetime_pt,
  TO_NUMBER(TO_CHAR(accepted_date::DATE,'YYYYMMDD'),'99999999')
                                                                        AS accepted_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', accepted_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                     AS accepted_date_pt_id,
      COALESCE(sfdc_contacts.qualifying_datetime, sfdc_leads.qualifying_datetime)::DATE                         AS qualifying_date,
  TO_NUMBER(TO_CHAR(qualifying_date::DATE,'YYYYMMDD'),'99999999')
                                                                      AS qualifying_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', qualifying_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                   AS qualifying_date_pt_id,
      COALESCE(sfdc_contacts.qualified_datetime, sfdc_leads.qualified_datetime)::DATE                           AS qualified_date,
  TO_NUMBER(TO_CHAR(qualified_date::DATE,'YYYYMMDD'),'99999999')
                                                                       AS qualified_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', qualified_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                    AS qualified_date_pt_id,
      COALESCE(sfdc_contacts.initial_recycle_datetime, sfdc_leads.initial_recycle_datetime)::DATE               AS initial_recycle_date,
      COALESCE(sfdc_contacts.initial_recycle_datetime, sfdc_leads.initial_recycle_datetime)                     AS initial_recycle_datetime,
  TO_NUMBER(TO_CHAR(initial_recycle_date::DATE,'YYYYMMDD'),'99999999')
                                                                 AS initial_recycle_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', initial_recycle_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                              AS initial_recycle_date_pt_id,
      COALESCE(sfdc_contacts.most_recent_recycle_datetime, sfdc_leads.most_recent_recycle_datetime)::DATE       AS most_recent_recycle_date,
  TO_NUMBER(TO_CHAR(most_recent_recycle_date::DATE,'YYYYMMDD'),'99999999')
                                                             AS most_recent_recycle_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', most_recent_recycle_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                          AS most_recent_recycle_date_pt_id,
      sfdc_lead_converted.converted_date::DATE                                                                  AS converted_date,
  TO_NUMBER(TO_CHAR(sfdc_lead_converted.converted_date::DATE,'YYYYMMDD'),'99999999')
                                                   AS converted_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', sfdc_lead_converted.converted_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                AS converted_date_pt_id,
      COALESCE(sfdc_contacts.worked_datetime, sfdc_leads.worked_datetime)::DATE                                 AS worked_date,
  TO_NUMBER(TO_CHAR(worked_date::DATE,'YYYYMMDD'),'99999999')
                                                                          AS worked_date_id,
  TO_NUMBER(
    TO_CHAR(
      CONVERT_TIMEZONE('America/Los_Angeles', worked_date)::DATE
      ,'YYYYMMDD'
      )
    ,'99999999'
    )
                                                                       AS worked_date_pt_id,
      crm_person.high_priority_datetime,
     -- flags
      CASE
          WHEN mqls.last_mql_date IS NOT NULL THEN 1
          ELSE 0
        END                                                                                                               AS is_mql,
      CASE
        WHEN true_inquiry_date IS NOT NULL THEN 1
        ELSE 0
      END                                                                                                                 AS is_inquiry,
      crm_person.is_bdr_sdr_worked,
      crm_person.is_partner_recalled,
      crm_person.is_lead_source_trial,
      crm_person.is_high_priority,
      crm_person.last_worked_by_date,
      crm_person.last_worked_by_datetime,
    --Groove
      crm_person.groove_last_engagement_datetime,
      crm_person.groove_active_flows_count,
      crm_person.groove_added_to_flow_date,
      crm_person.groove_flow_completed_date,
      crm_person.groove_next_step_due_date,
      crm_person.groove_overdue_days,
      crm_person.groove_removed_from_flow_date,
      crm_person.groove_engagement_score,
      crm_person.groove_outbound_email_counter,
     -- information fields
      crm_person.name_of_active_sequence,
      crm_person.sequence_task_due_date,
      crm_person.sequence_status,
      crm_person.last_activity_date,
      crm_person.last_utm_content,
      crm_person.last_utm_campaign,
      crm_person.last_transfer_date_time,
      crm_person.time_from_last_transfer_to_sequence,
      crm_person.time_from_mql_to_last_transfer,
      crm_person.traction_first_response_time,
      crm_person.traction_first_response_time_seconds,
      crm_person.traction_response_time_in_business_hours,
      crm_person.propensity_to_purchase_score_date,
      crm_person.propensity_to_purchase_days_since_trial_start,
      crm_person.email_hash,
     -- additive fields
      crm_person.person_score                                                                                             AS person_score,
      mqls.mql_count                                                                                                      AS mql_count
    FROM crm_person
    LEFT JOIN sfdc_leads
      ON crm_person.sfdc_record_id = sfdc_leads.lead_id
    LEFT JOIN sfdc_contacts
      ON crm_person.sfdc_record_id = sfdc_contacts.contact_id
    LEFT JOIN sfdc_lead_converted
      ON crm_person.sfdc_record_id = sfdc_lead_converted.converted_contact_id
    LEFT JOIN mqls
      ON crm_person.dim_crm_person_id = mqls.crm_person_id
    LEFT JOIN account_dims_mapping
      ON crm_person.dim_crm_account_id = account_dims_mapping.dim_crm_account_id
    LEFT JOIN sales_segment
      ON sfdc_leads.sales_segmentation = sales_segment.sales_segment_name
    LEFT JOIN sales_territory
      ON sfdc_leads.tsp_territory = sales_territory.sales_territory_name
    LEFT JOIN industry
      ON COALESCE(sfdc_contacts.industry, sfdc_leads.industry) = industry.industry_name
    LEFT JOIN bizible_marketing_channel_path_mapping
      ON crm_person.bizible_marketing_channel_path = bizible_marketing_channel_path_mapping.bizible_marketing_channel_path
    LEFT JOIN bizible_marketing_channel_path
      ON bizible_marketing_channel_path_mapping.bizible_marketing_channel_path_name_grouped = bizible_marketing_channel_path.bizible_marketing_channel_path_name
    LEFT JOIN prep_crm_user_hierarchy
      ON prep_crm_user_hierarchy.dim_crm_user_hierarchy_sk = crm_person.dim_account_demographics_hierarchy_sk
), inquiry_base AS (
  SELECT
  --IDs
    person_final.dim_crm_person_id,
  --Person Data
    person_final.true_inquiry_date,
    -- account_history_final.abm_tier_1_date,
    -- account_history_final.abm_tier_2_date,
    -- account_history_final.abm_tier,
    CASE
      WHEN true_inquiry_date IS NOT NULL
        AND true_inquiry_date BETWEEN valid_from AND valid_to
        THEN TRUE
      ELSE FALSE
    END AS is_abm_tier_inquiry
  FROM person_final
  LEFT JOIN account_history_final
    ON person_final.dim_crm_account_id=account_history_final.dim_crm_account_id
  WHERE abm_tier IS NOT NULL
  AND true_inquiry_date IS NOT NULL
  AND true_inquiry_date >= '2022-02-01'
  AND (abm_tier_1_date IS NOT NULL
    OR abm_tier_2_date IS NOT NULL)
  AND is_abm_tier_inquiry = TRUE
), mql_base AS (
  SELECT
  --IDs
    person_final.dim_crm_person_id,
  --Person Data
    person_final.mql_datetime_latest_pt,
    -- account_history_final.abm_tier_1_date,
    -- account_history_final.abm_tier_2_date,
    -- account_history_final.abm_tier,
    CASE
      WHEN mql_datetime_latest_pt IS NOT NULL
        AND mql_datetime_latest_pt BETWEEN valid_from AND valid_to
        THEN TRUE
      ELSE FALSE
    END AS is_abm_tier_mql
  FROM person_final
  LEFT JOIN account_history_final
    ON person_final.dim_crm_account_id=account_history_final.dim_crm_account_id
  WHERE abm_tier IS NOT NULL
  AND mql_datetime_latest_pt IS NOT NULL
  AND mql_datetime_latest_pt >= '2022-02-01'
  AND (abm_tier_1_date IS NOT NULL
    OR abm_tier_2_date IS NOT NULL)
  AND is_abm_tier_mql = TRUE
), abm_tier_id AS (
    SELECT
        dim_crm_person_id
    FROM inquiry_base
    UNION ALL
    SELECT
        dim_crm_person_id
    FROM mql_base
), abm_tier_id_final AS (
    SELECT DISTINCT
        dim_crm_person_id
    FROM abm_tier_id
), abm_tier_final AS (
  SELECT DISTINCT
    abm_tier_id_final.dim_crm_person_id,
    inquiry_base.is_abm_tier_inquiry,
    mql_base.is_abm_tier_mql
  FROM abm_tier_id_final
  LEFT JOIN inquiry_base
      ON abm_tier_id_final.dim_crm_person_id=inquiry_base.dim_crm_person_id
  LEFT JOIN mql_base
    ON abm_tier_id_final.dim_crm_person_id=mql_base.dim_crm_person_id
), final AS (
  SELECT
    person_final.*,
    abm_tier_final.is_abm_tier_inquiry,
    abm_tier_final.is_abm_tier_mql
  FROM person_final
  LEFT JOIN abm_tier_final
    ON person_final.dim_crm_person_id=abm_tier_final.dim_crm_person_id
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2020-12-01'::DATE        AS model_created_date,
      '2024-10-07'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common.fct_crm_touchpoint as
WITH account_dimensions AS (
    SELECT *
    FROM "PROD".restricted_safe_common_mapping.map_crm_account
), bizible_touchpoints AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_touchpoint
), crm_person AS (
    SELECT
      bizible_person_id,
      dim_crm_person_id,
      dim_crm_user_id
    FROM "PROD".common_prep.prep_crm_person
    -- occasionally we see duplicate bizible_person_id's in prep_crm_person so we should qualify on that field
    QUALIFY ROW_NUMBER() OVER (PARTITION BY bizible_person_id ORDER BY created_date DESC) = 1
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
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2021-01-21'::DATE        AS model_created_date,
      '2024-01-31'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final_touchpoint;

CREATE TABLE "PROD".common.dim_sales_segment as
WITH sales_segment AS (
    SELECT
      dim_sales_segment_id,
      sales_segment_name,
      sales_segment_grouped
    FROM "PROD".common_prep.prep_sales_segment
)
SELECT
      *,
      '@msendal'::VARCHAR       AS created_by,
      '@jpeguero'::VARCHAR       AS updated_by,
      '2020-11-05'::DATE        AS model_created_date,
      '2020-04-26'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM sales_segment;

CREATE TABLE "PROD".common_prep.prep_crm_attribution_touchpoint as
WITH bizible_attribution_touchpoint_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_bizible_attribution_touchpoint_source
    WHERE is_deleted = 'FALSE'
), bizible_attribution_touchpoint_base AS (
  SELECT DISTINCT
    bizible_attribution_touchpoint_source.*,
    REPLACE(LOWER(bizible_form_url),'.html','') AS bizible_form_url_clean,
    pathfactory_content_type,
    prep_campaign.type
  FROM bizible_attribution_touchpoint_source
  LEFT JOIN "PROD".legacy.sheetload_bizible_to_pathfactory_mapping
    ON bizible_form_url_clean=bizible_url
  LEFT JOIN "PROD".common_prep.prep_campaign
      ON bizible_attribution_touchpoint_source.campaign_id = prep_campaign.dim_campaign_id
), final AS (
  SELECT
    bizible_attribution_touchpoint_base.*,
    CASE
      WHEN bizible_touchpoint_type = 'Web Chat'
        OR LOWER(bizible_ad_campaign_name) LIKE '%webchat%'
        OR bizible_ad_campaign_name = 'FY24_Qualified.com web conversation'
        THEN 'Web Chat'
      WHEN bizible_touchpoint_type IN ('Web Form', 'marketotouchpoin')
        AND bizible_form_url_clean IN ('gitlab.com/-/trial_registrations/new',
                                'gitlab.com/-/trial_registrations',
                                'gitlab.com/-/trials/new')
        THEN 'GitLab Dot Com Trial'
      WHEN bizible_touchpoint_type IN ('Web Form', 'marketotouchpoin')
        AND bizible_form_url_clean IN (
                                'about.gitlab.com/free-trial/index',
                                'about.gitlab.com/free-trial',
                                'about.gitlab.com/free-trial/self-managed',
                                'about.gitlab.com/free-trial/self-managed/index',
                                'about.gitlab.com/fr-fr/free-trial',
                                'about.gitlab.com/ja-jp/free-trial'
                                )
        THEN 'GitLab Self-Managed Trial'
      WHEN  bizible_form_url_clean LIKE '%/sign_up%'
        OR bizible_form_url_clean LIKE '%/users%'
        THEN 'Sign Up Form'
      WHEN bizible_form_url_clean IN ('about.gitlab.com/sales',
        'about.gitlab.com/ja-jp/sales',
        'about.gitlab.com/de-de/sales',
        'about.gitlab.com/fr-fr/sales',
        'about.gitlab.com/es/sales',
        'about.gitlab.com/dedicated',
        'about.gitlab.com/pt-br/sales'
        )
        OR bizible_form_url_clean LIKE 'about.gitlab.com/pricing/smb%'
        THEN 'Contact Sales Form'
      WHEN bizible_form_url_clean LIKE '%/resources/%'
        THEN 'Resources'
      WHEN bizible_touchpoint_type IN ('Web Form', 'marketotouchpoin')
        AND
          (
            (bizible_form_url_clean LIKE '%page.gitlab.com%')
            OR (bizible_form_url_clean LIKE '%about.gitlab.com/gartner%%')
          )
        THEN 'Online Content'
      WHEN bizible_form_url_clean LIKE 'learn.gitlab.com%'
        THEN 'Online Content'
      WHEN bizible_marketing_channel = 'Event'
        THEN type
      WHEN (LOWER(bizible_ad_campaign_name) LIKE '%lead%'
        AND LOWER(bizible_ad_campaign_name) LIKE '%linkedin%')
        OR
        (
          type  = 'Paid Social'
          -- they are all ABM LinkedIN Lead Gen but the name doesn't say that.
          AND (bizible_ad_campaign_name LIKE '%2023_ABM%'
            OR bizible_ad_campaign_name LIKE '%2024_ABM%')
        )
        THEN 'Lead Gen Form'
      WHEN bizible_marketing_channel = 'IQM'
        THEN 'IQM'
      WHEN bizible_form_url_clean LIKE '%/education/%'
        OR LOWER(bizible_ad_campaign_name) LIKE '%education%'
        THEN 'Education'
      WHEN bizible_form_url_clean LIKE '%/company/%'
        THEN 'Company Pages'
      WHEN bizible_touchpoint_type = 'CRM'
        AND (LOWER(bizible_ad_campaign_name) LIKE '%partner%'
          OR LOWER(bizible_medium) LIKE '%partner%')
        THEN 'Partner Sourced'
      WHEN bizible_form_url_clean ='about.gitlab.com/company/contact/'
        OR bizible_form_url_clean LIKE '%/releases/%'
        OR bizible_form_url_clean LIKE '%/blog/%'
        OR bizible_form_url_clean LIKE '%/community/%'
        THEN 'Newsletter/Release/Blog Sign-Up'
      WHEN type  = 'Survey'
        OR bizible_form_url_clean LIKE '%survey%'
          OR LOWER(bizible_ad_campaign_name) LIKE '%survey%'
        THEN 'Survey'
      WHEN bizible_form_url_clean LIKE '%/solutions/%'
        OR bizible_form_url_clean IN ('about.gitlab.com/enterprise/','about.gitlab.com/small-business/')
        THEN 'Solutions'
      WHEN bizible_form_url_clean LIKE '%/blog%'
        THEN 'Blog'
      WHEN bizible_form_url_clean LIKE '%/webcast/%'
        THEN 'Webcast'
      WHEN bizible_form_url_clean LIKE '%/services%'
        THEN 'GitLab Professional Services'
      WHEN bizible_form_url_clean LIKE '%/fifteen%'
        THEN  'Event Registration'
      WHEN bizible_ad_campaign_name LIKE '%PQL%'
        THEN 'Product Qualified Lead'
      WHEN bizible_marketing_channel_path LIKE '%Content Syndication%'
        THEN 'Content Syndication'
      WHEN (bizible_form_url_clean LIKE '%about.gitlab.com/events%')
        THEN 'Event Registration'
      ELSE 'Other'
    END AS touchpoint_offer_type_wip,
    CASE
      WHEN pathfactory_content_type IS NOT NULL
        THEN pathfactory_content_type
      WHEN (touchpoint_offer_type_wip = 'Online Content'
        AND bizible_form_url_clean LIKE '%registration-page%'
        OR bizible_form_url_clean LIKE '%registrationpage%'
        OR bizible_form_url_clean LIKE '%inperson%'
        OR bizible_form_url_clean LIKE '%in-person%'
        OR bizible_form_url_clean LIKE '%landing-page%')
        OR touchpoint_offer_type_wip = 'Event Registration'
        THEN 'Event Registration'
      WHEN touchpoint_offer_type_wip = 'Online Content'
        AND bizible_form_url_clean LIKE '%ebook%'
        THEN 'eBook'
      WHEN (touchpoint_offer_type_wip = 'Online Content'
        AND bizible_form_url_clean LIKE '%webcast%')
        OR bizible_form_url_clean IN ('about.gitlab.com/seventeen',
                                      'about.gitlab.com/sixteen',
                                      'about.gitlab.com/eighteen',
                                      'about.gitlab.com/nineteen',
                                      'about.gitlab.com/fr-fr/seventeen',
                                      'about.gitlab.com/de-de/seventeen',
                                      'about.gitlab.com/es/seventeen')
        THEN 'Webcast'
      WHEN touchpoint_offer_type_wip = 'Online Content'
        AND bizible_form_url_clean LIKE '%demo%'
        THEN 'Demo'
      WHEN touchpoint_offer_type_wip = 'Online Content'
        THEN 'Other Online Content'
      ELSE touchpoint_offer_type_wip
    END AS touchpoint_offer_type,
    CASE
      WHEN bizible_marketing_channel = 'Event'
        OR touchpoint_offer_type = 'Event Registration'
          OR touchpoint_offer_type = 'Webcast'
          OR touchpoint_offer_type = 'Workshop'
        THEN 'Events'
      WHEN touchpoint_offer_type_wip = 'Online Content'
        THEN 'Online Content'
      WHEN touchpoint_offer_type IN ('Content Syndication','Newsletter/Release/Blog Sign-Up','Blog','Resources')
        THEN 'Online Content'
      WHEN touchpoint_offer_type = 'Sign Up Form'
        THEN 'Sign Up Form'
      WHEN touchpoint_offer_type IN ('GitLab Dot Com Trial', 'GitLab Self-Managed Trial')
        THEN 'Trials'
      WHEN touchpoint_offer_type = 'Web Chat'
        THEN 'Web Chat'
      WHEN touchpoint_offer_type = 'Contact Sales Form'
        THEN 'Contact Sales Form'
      WHEN touchpoint_offer_type = 'Partner Sourced'
        THEN 'Partner Sourced'
      WHEN touchpoint_offer_type = 'Lead Gen Form'
        THEN 'Lead Gen Form'
      ELSE 'Other'
    END AS touchpoint_offer_type_grouped
  FROM bizible_attribution_touchpoint_base
)
SELECT
      *,
      '@rkohnke'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2024-01-31'::DATE        AS model_created_date,
      '2024-12-18'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common_prep.prep_date as
WITH source AS (
  SELECT
  TO_NUMBER(TO_CHAR(date_actual::DATE,'YYYYMMDD'),'99999999')
                                AS date_id,
    *
  FROM "PREP".date.date_details_source
)
SELECT
      *,
      '@pempey'::VARCHAR       AS created_by,
      '@jpeguero'::VARCHAR       AS updated_by,
      '2023-01-09'::DATE        AS model_created_date,
      '2023-08-14'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM source;

CREATE TABLE "PROD".common_prep.prep_crm_user_hierarchy as
WITH dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), prep_crm_user_daily_snapshot AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_user_daily_snapshot
), prep_crm_user AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_user
), prep_crm_account_daily_snapshot AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_crm_account_daily_snapshot
), prep_crm_opportunity AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_crm_opportunity_v1
), prep_sales_funnel_target AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_sales_funnel_target
), prep_crm_person AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_person
),
fiscal_months AS (
  SELECT DISTINCT
    fiscal_month_name_fy,
    fiscal_year,
    first_day_of_month
  FROM dim_date
),
current_fiscal_year AS (
  SELECT fiscal_year
  FROM dim_date
  WHERE date_actual = CURRENT_DATE - 1
),
prep_crm_user_roles AS (
  SELECT DISTINCT
    user_role_name,
    crm_user_sales_segment,
    crm_user_geo,
    crm_user_region,
    crm_user_area,
    crm_user_business_unit,
    user_role_level_1,
    user_role_level_2,
    user_role_level_3,
    user_role_level_4,
    user_role_level_5
  FROM prep_crm_user
),
account_demographics_hierarchy AS (
  SELECT DISTINCT
    created_date_fiscal_year                  AS fiscal_year,
    UPPER(account_demographics_sales_segment) AS account_demographics_sales_segment,
    UPPER(account_demographics_geo)           AS account_demographics_geo,
    UPPER(account_demographics_region)        AS account_demographics_region,
    UPPER(account_demographics_area)          AS account_demographics_area,
    NULL                                      AS user_business_unit,
    dim_account_demographics_hierarchy_sk,
    NULL                                      AS user_role_name,
    NULL                                      AS user_role_level_1,
    NULL                                      AS user_role_level_2,
    NULL                                      AS user_role_level_3,
    NULL                                      AS user_role_level_4,
    NULL                                      AS user_role_level_5
  FROM prep_crm_person
),
user_geo_hierarchy_source AS (
  SELECT DISTINCT
    dim_date.fiscal_year,
    prep_crm_user_daily_snapshot.crm_user_sales_segment AS user_segment,
    prep_crm_user_daily_snapshot.crm_user_geo           AS user_geo,
    prep_crm_user_daily_snapshot.crm_user_region        AS user_region,
    prep_crm_user_daily_snapshot.crm_user_area          AS user_area,
    prep_crm_user_daily_snapshot.crm_user_business_unit AS user_business_unit,
    prep_crm_user_daily_snapshot.dim_crm_user_hierarchy_sk,
    NULL                                                AS user_role_name,
    NULL                                                AS user_role_level_1,
    NULL                                                AS user_role_level_2,
    NULL                                                AS user_role_level_3,
    NULL                                                AS user_role_level_4,
    NULL                                                AS user_role_level_5
  FROM prep_crm_user_daily_snapshot
  INNER JOIN dim_date
    ON prep_crm_user_daily_snapshot.snapshot_id = dim_date.date_id
  WHERE prep_crm_user_daily_snapshot.crm_user_sales_segment IS NOT NULL
    AND prep_crm_user_daily_snapshot.crm_user_geo IS NOT NULL
    AND prep_crm_user_daily_snapshot.crm_user_region IS NOT NULL
    AND prep_crm_user_daily_snapshot.crm_user_area IS NOT NULL
    AND IFF(dim_date.fiscal_year > 2023, prep_crm_user_daily_snapshot.crm_user_business_unit IS NOT NULL, 1 = 1) -- with the change in structure, business unit must be present after FY23
    AND IFF(dim_date.fiscal_year < dim_date.current_fiscal_year, dim_date.date_actual = dim_date.last_day_of_fiscal_year, dim_date.date_actual = dim_date.current_date_actual) -- take only the last valid hierarchy of the fiscal year for previous fiscal years
    AND dim_date.fiscal_year < 2025 -- stop geo hierarchy after 2024
    AND prep_crm_user_daily_snapshot.is_active = TRUE
),
user_role_hierarchy_snapshot_source AS (
  SELECT DISTINCT
    dim_date.fiscal_year,
    prep_crm_user_daily_snapshot.crm_user_sales_segment AS user_segment,
    prep_crm_user_daily_snapshot.crm_user_geo           AS user_geo,
    prep_crm_user_daily_snapshot.crm_user_region        AS user_region,
    prep_crm_user_daily_snapshot.crm_user_area          AS user_area,
    prep_crm_user_daily_snapshot.crm_user_business_unit AS user_business_unit,
    prep_crm_user_daily_snapshot.dim_crm_user_hierarchy_sk,
    prep_crm_user_daily_snapshot.user_role_name,
    prep_crm_user_daily_snapshot.user_role_level_1,
    prep_crm_user_daily_snapshot.user_role_level_2,
    prep_crm_user_daily_snapshot.user_role_level_3,
    prep_crm_user_daily_snapshot.user_role_level_4,
    prep_crm_user_daily_snapshot.user_role_level_5
  FROM prep_crm_user_daily_snapshot
  INNER JOIN dim_date
    ON prep_crm_user_daily_snapshot.snapshot_id = dim_date.date_id
  WHERE dim_date.fiscal_year >= 2025
    AND prep_crm_user_daily_snapshot.is_active = TRUE
  QUALIFY ROW_NUMBER() OVER (PARTITION BY prep_crm_user_daily_snapshot.user_role_name, dim_date.fiscal_year ORDER BY snapshot_id DESC) = 1
),
user_role_hierarchy_live_source AS (
  SELECT DISTINCT
    current_fiscal_year.fiscal_year,
    prep_crm_user.crm_user_sales_segment AS user_segment,
    prep_crm_user.crm_user_geo           AS user_geo,
    prep_crm_user.crm_user_region        AS user_region,
    prep_crm_user.crm_user_area          AS user_area,
    prep_crm_user.crm_user_business_unit AS user_business_unit,
    prep_crm_user.dim_crm_user_hierarchy_sk,
    prep_crm_user.user_role_name,
    prep_crm_user.user_role_level_1,
    prep_crm_user.user_role_level_2,
    prep_crm_user.user_role_level_3,
    prep_crm_user.user_role_level_4,
    prep_crm_user.user_role_level_5
  FROM prep_crm_user
  LEFT JOIN current_fiscal_year
  WHERE user_role_level_1 IS NOT NULL
    AND is_active = TRUE
),
account_hierarchy_snapshot_source AS (
  SELECT DISTINCT
    dim_date.fiscal_year,
    prep_crm_account_daily_snapshot.parent_crm_account_sales_segment,
    prep_crm_account_daily_snapshot.parent_crm_account_geo,
    prep_crm_account_daily_snapshot.parent_crm_account_region,
    prep_crm_account_daily_snapshot.parent_crm_account_area,
    prep_crm_account_daily_snapshot.parent_crm_account_business_unit,
    prep_crm_account_daily_snapshot.dim_crm_parent_account_hierarchy_sk,
    NULL AS user_role_name,
    NULL AS user_role_level_1,
    NULL AS user_role_level_2,
    NULL AS user_role_level_3,
    NULL AS user_role_level_4,
    NULL AS user_role_level_5
  FROM prep_crm_account_daily_snapshot
  INNER JOIN dim_date
    ON prep_crm_account_daily_snapshot.snapshot_id = dim_date.date_id
  WHERE prep_crm_account_daily_snapshot.parent_crm_account_sales_segment IS NOT NULL
    AND prep_crm_account_daily_snapshot.parent_crm_account_geo IS NOT NULL
    AND prep_crm_account_daily_snapshot.parent_crm_account_region IS NOT NULL
    AND prep_crm_account_daily_snapshot.parent_crm_account_area IS NOT NULL
    AND IFF(dim_date.fiscal_year > 2023, prep_crm_account_daily_snapshot.parent_crm_account_business_unit IS NOT NULL, TRUE) -- with the change in structure, business unit must be present after FY23
    AND IFF(dim_date.fiscal_year < dim_date.current_fiscal_year, dim_date.date_actual = dim_date.last_day_of_fiscal_year, dim_date.date_actual = dim_date.current_date_actual) -- take only the last valid hierarchy of the fiscal year for previous fiscal years
    AND dim_date.fiscal_year < 2025
),
user_geo_hierarchy_sheetload AS (
/*
  To get a complete picture of the hierarchy and to ensure fidelity with the target setting model, we will union in the distinct hierarchy values from the file.
  */
  SELECT DISTINCT
    prep_sales_funnel_target.fiscal_year,
    prep_sales_funnel_target.user_segment,
    prep_sales_funnel_target.user_geo,
    prep_sales_funnel_target.user_region,
    prep_sales_funnel_target.user_area,
    prep_sales_funnel_target.user_business_unit,
    prep_sales_funnel_target.dim_crm_user_hierarchy_sk,
    NULL AS user_role_name,
    NULL AS user_role_level_1,
    NULL AS user_role_level_2,
    NULL AS user_role_level_3,
    NULL AS user_role_level_4,
    NULL AS user_role_level_5
  FROM prep_sales_funnel_target
  WHERE prep_sales_funnel_target.user_area != 'N/A'
    AND prep_sales_funnel_target.user_segment IS NOT NULL
    AND prep_sales_funnel_target.user_geo IS NOT NULL
    AND prep_sales_funnel_target.user_region IS NOT NULL
    AND prep_sales_funnel_target.user_area IS NOT NULL
    AND prep_sales_funnel_target.role_level_1 IS NULL
),
user_role_hierarchy_sheetload AS (
/*
  To get a complete picture of the hierarchy and to ensure fidelity with the target setting model, we will union in the distinct hierarchy values from the file.
  */
  SELECT DISTINCT
    prep_sales_funnel_target.fiscal_year,
    COALESCE(prep_crm_user_roles.crm_user_sales_segment, prep_sales_funnel_target.user_segment)       AS user_segment, -- coalescing as some roles exist in targets but not yet in SFDC
    COALESCE(prep_crm_user_roles.crm_user_geo, prep_sales_funnel_target.user_geo)                     AS user_geo,
    COALESCE(prep_crm_user_roles.crm_user_region, prep_sales_funnel_target.user_region)               AS user_region,
    COALESCE(prep_crm_user_roles.crm_user_area, prep_sales_funnel_target.user_area)                   AS user_area,
    COALESCE(prep_crm_user_roles.crm_user_business_unit, prep_sales_funnel_target.user_business_unit) AS user_business_unit,
    prep_sales_funnel_target.dim_crm_user_hierarchy_sk,
    prep_sales_funnel_target.user_role_name,
    prep_sales_funnel_target.role_level_1,
    prep_sales_funnel_target.role_level_2,
    prep_sales_funnel_target.role_level_3,
    prep_sales_funnel_target.role_level_4,
    prep_sales_funnel_target.role_level_5
  FROM prep_sales_funnel_target
  LEFT JOIN prep_crm_user_roles
    ON prep_sales_funnel_target.user_role_name = prep_crm_user_roles.user_role_name
  WHERE prep_sales_funnel_target.role_level_1 IS NOT NULL
),
user_geo_hierarchy_stamped_opportunity AS (
/*
  To get a complete picture of the hierarchy and to ensure fidelity with the stamped opportunities, we will union in the distinct hierarchy values from the stamped opportunities.
  The hierarchy switched from geo to role after 2024 so we stop taking geo values after that fiscal_year.
  */
  SELECT DISTINCT
    prep_crm_opportunity.close_fiscal_year                      AS fiscal_year,
    prep_crm_opportunity.user_segment_stamped                   AS user_segment,
    prep_crm_opportunity.user_geo_stamped                       AS user_geo,
    prep_crm_opportunity.user_region_stamped                    AS user_region,
    prep_crm_opportunity.user_area_stamped                      AS user_area,
    prep_crm_opportunity.user_business_unit_stamped             AS user_business_unit,
    prep_crm_opportunity.dim_crm_opp_owner_stamped_hierarchy_sk AS dim_crm_user_hierarchy_sk,
    NULL                                                        AS user_role_name,
    NULL                                                        AS user_role_level_1,
    NULL                                                        AS user_role_level_2,
    NULL                                                        AS user_role_level_3,
    NULL                                                        AS user_role_level_4,
    NULL                                                        AS user_role_level_5
  FROM prep_crm_opportunity
  WHERE is_live = 1
    AND prep_crm_opportunity.close_fiscal_year < 2025
),
user_role_hierarchy_stamped_opportunity AS (
/*
  To get a complete picture of the hierarchy and to ensure fidelity with the stamped opportunities, we will union in the distinct hierarchy values from the stamped opportunities.
  The hierarchy switched from geo to role after 2024 so only take role values after that fiscal_year.
  */
  SELECT DISTINCT
    prep_crm_opportunity.close_fiscal_year                      AS fiscal_year,
    prep_crm_user_roles.crm_user_sales_segment                  AS user_segment,
    prep_crm_user_roles.crm_user_geo                            AS user_geo,
    prep_crm_user_roles.crm_user_region                         AS user_region,
    prep_crm_user_roles.crm_user_area                           AS user_area,
    prep_crm_user_roles.crm_user_business_unit                  AS user_business_unit,
    prep_crm_opportunity.dim_crm_opp_owner_stamped_hierarchy_sk AS dim_crm_user_hierarchy_sk,
    prep_crm_opportunity.opportunity_owner_role                 AS user_role_name,
    prep_crm_user_roles.user_role_level_1,
    prep_crm_user_roles.user_role_level_2,
    prep_crm_user_roles.user_role_level_3,
    prep_crm_user_roles.user_role_level_4,
    prep_crm_user_roles.user_role_level_5
  FROM prep_crm_opportunity
  INNER JOIN prep_crm_user_roles
    ON prep_crm_opportunity.opportunity_owner_role = prep_crm_user_roles.user_role_name
  WHERE is_live = 1
    AND (
      prep_crm_user_roles.user_role_level_1 IS NOT NULL
      OR LOWER(prep_crm_opportunity.opportunity_owner_role) IN ('executive', 'channel manager-programs')
    ) -- temp workaround for roles that should have a level 1 mapping
    AND prep_crm_opportunity.close_fiscal_year >= 2025
),
unioned AS (
/*
  Union all four hierarchy sources to combine all possible hierarchies generated used in the past, as well as those not currently used in the system, but used in target setting.
  */
  SELECT *
  FROM user_geo_hierarchy_source
  UNION
  SELECT *
  FROM user_role_hierarchy_snapshot_source
  WHERE user_role_level_1 IS NOT NULL
  UNION
  SELECT *
  FROM user_role_hierarchy_live_source
  UNION
  SELECT *
  FROM user_geo_hierarchy_sheetload
  UNION
  SELECT *
  FROM user_role_hierarchy_sheetload
  UNION
  SELECT *
  FROM user_geo_hierarchy_stamped_opportunity
  UNION
  SELECT *
  FROM user_role_hierarchy_stamped_opportunity
  UNION
  SELECT *
  FROM account_hierarchy_snapshot_source
  UNION
  SELECT *
  FROM account_demographics_hierarchy
),
pre_fy24_hierarchy AS (
/*
  Before FY24, the hierarchy only uncluded segment, geo, region, and area.
  */
  SELECT DISTINCT
    fiscal_year,
    UPPER(user_segment) AS user_segment,
    UPPER(user_geo)     AS user_geo,
    UPPER(user_region)  AS user_region,
    UPPER(user_area)    AS user_area,
    NULL                AS user_business_unit,
    dim_crm_user_hierarchy_sk,
    NULL                AS user_role_name,
    NULL                AS user_role_level_1,
    NULL                AS user_role_level_2,
    NULL                AS user_role_level_3,
    NULL                AS user_role_level_4,
    NULL                AS user_role_level_5
  FROM unioned
  WHERE fiscal_year < 2024
),
fy24_hierarchy AS (
/*
  In FY24, business unit was added to the hierarchy.
  */
  SELECT DISTINCT
    fiscal_year,
    UPPER(user_segment)       AS user_segment,
    UPPER(user_geo)           AS user_geo,
    UPPER(user_region)        AS user_region,
    UPPER(user_area)          AS user_area,
    UPPER(user_business_unit) AS user_business_unit,
    dim_crm_user_hierarchy_sk,
    NULL                      AS user_role_name,
    NULL                      AS user_role_level_1,
    NULL                      AS user_role_level_2,
    NULL                      AS user_role_level_3,
    NULL                      AS user_role_level_4,
    NULL                      AS user_role_level_5
  FROM unioned
  WHERE fiscal_year = 2024
),
fy25_and_beyond_hierarchy AS (
/*
  In FY25, we switched to a role based hierarchy.
  */
  SELECT DISTINCT
    fiscal_year,
    MIN(UPPER(user_segment))                  AS user_segment,
    COALESCE(MIN(UPPER(user_geo)), 'UNKNOWN') AS user_geo,
    MIN(UPPER(user_region))                   AS user_region,
    MIN(UPPER(user_area))                     AS user_area,
    MIN(UPPER(user_business_unit))            AS user_business_unit,
    dim_crm_user_hierarchy_sk,
    MIN(UPPER(user_role_name))                AS user_role_name,
    MIN(UPPER(user_role_level_1))             AS user_role_level_1,
    MIN(UPPER(user_role_level_2))             AS user_role_level_2,
    MIN(UPPER(user_role_level_3))             AS user_role_level_3, -- workaround linked to https://gitlab.com/gitlab-com/sales-team/field-operations/systems/-/issues/5181
    MIN(UPPER(user_role_level_4))             AS user_role_level_4, -- hopefully the MIN function can be removed before merging to production.
    MIN(UPPER(user_role_level_5))             AS user_role_level_5
  FROM unioned
  WHERE fiscal_year >= 2025
  GROUP BY fiscal_year, dim_crm_user_hierarchy_sk
),
final_unioned AS (
  SELECT *
  FROM pre_fy24_hierarchy
  UNION ALL
  SELECT *
  FROM fy24_hierarchy
  UNION ALL
  SELECT *
  FROM fy25_and_beyond_hierarchy
),
final AS (
  SELECT DISTINCT
    md5(cast(coalesce(cast(final_unioned.dim_crm_user_hierarchy_sk as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS dim_crm_user_hierarchy_id,
    final_unioned.dim_crm_user_hierarchy_sk,
    final_unioned.fiscal_year,
    final_unioned.user_business_unit                                                                                     AS crm_user_business_unit,
    md5(cast(coalesce(cast(final_unioned.user_business_unit as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))        AS dim_crm_user_business_unit_id,
    final_unioned.user_segment                                                                                           AS crm_user_sales_segment,
    md5(cast(coalesce(cast(final_unioned.user_segment as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))              AS dim_crm_user_sales_segment_id,
    final_unioned.user_geo                                                                                               AS crm_user_geo,
    md5(cast(coalesce(cast(final_unioned.user_geo as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                  AS dim_crm_user_geo_id,
    final_unioned.user_region                                                                                            AS crm_user_region,
    md5(cast(coalesce(cast(final_unioned.user_region as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))               AS dim_crm_user_region_id,
    final_unioned.user_area                                                                                              AS crm_user_area,
    md5(cast(coalesce(cast(final_unioned.user_area as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                 AS dim_crm_user_area_id,
    final_unioned.user_role_name                                                                                         AS crm_user_role_name,
    md5(cast(coalesce(cast(final_unioned.user_role_name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))            AS dim_crm_user_role_name_id,
    final_unioned.user_role_level_1                                                                                      AS crm_user_role_level_1,
    md5(cast(coalesce(cast(final_unioned.user_role_level_1 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))         AS dim_crm_user_role_level_1_id,
    final_unioned.user_role_level_2                                                                                      AS crm_user_role_level_2,
    md5(cast(coalesce(cast(final_unioned.user_role_level_2 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))         AS dim_crm_user_role_level_2_id,
    final_unioned.user_role_level_3                                                                                      AS crm_user_role_level_3,
    md5(cast(coalesce(cast(final_unioned.user_role_level_3 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))         AS dim_crm_user_role_level_3_id,
    final_unioned.user_role_level_4                                                                                      AS crm_user_role_level_4,
    md5(cast(coalesce(cast(final_unioned.user_role_level_4 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))         AS dim_crm_user_role_level_4_id,
    final_unioned.user_role_level_5                                                                                      AS crm_user_role_level_5,
    md5(cast(coalesce(cast(final_unioned.user_role_level_5 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))         AS dim_crm_user_role_level_5_id,
    CASE
      WHEN final_unioned.user_segment IN ('Large', 'PubSec') THEN 'Large'
      ELSE final_unioned.user_segment
    END                                                                                                                  AS crm_user_sales_segment_grouped,
    CASE
      WHEN final_unioned.user_role_level_1 IN ('SMB', 'PUBSEC', 'APJ') THEN final_unioned.user_role_level_1
      WHEN final_unioned.user_role_level_2 = 'AMER_COMM' THEN  final_unioned.user_role_level_2
      WHEN final_unioned.user_role_level_1 = 'AMER' THEN  final_unioned.user_role_level_1
      ELSE final_unioned.user_role_level_2
    END                                                                                                                  AS pipe_council_grouping,
    CASE
  WHEN UPPER(final_unioned.user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(final_unioned.user_geo) = 'AMER' AND UPPER(final_unioned.user_region) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(final_unioned.user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(final_unioned.user_geo) IN ('AMER', 'LATAM') AND UPPER(final_unioned.user_region) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(final_unioned.user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(final_unioned.user_geo) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN final_unioned.user_geo
  WHEN UPPER(final_unioned.user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(final_unioned.user_region) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(final_unioned.user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(final_unioned.user_geo) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(final_unioned.user_segment) NOT IN ('LARGE', 'PUBSEC')
    THEN final_unioned.user_segment
  ELSE 'Missing segment_region_grouped'
END                                                                                                                      AS crm_user_sales_segment_region_grouped,
    IFF(final_unioned.fiscal_year = current_fiscal_year.fiscal_year, 1, 0)                                               AS is_current_crm_user_hierarchy
  FROM final_unioned
  LEFT JOIN current_fiscal_year
    ON final_unioned.fiscal_year = current_fiscal_year.fiscal_year
  WHERE dim_crm_user_hierarchy_sk IS NOT NULL
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@chrissharp'::VARCHAR       AS updated_by,
      '2021-01-05'::DATE        AS model_created_date,
      '2024-04-23'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common_prep.prep_crm_user as
WITH sfdc_user_roles_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_user_roles_source
), dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), sfdc_users_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_users_source
), sfdc_user_snapshots_source AS (
    SELECT *
    FROM "PROD".legacy.sfdc_user_snapshots_source
)
, sheetload_mapping_sdr_sfdc_bamboohr_source AS (
    SELECT *
    FROM "PREP".sheetload.sheetload_mapping_sdr_sfdc_bamboohr_source
), sfdc_users AS (
    SELECT
        *
    FROM
      sfdc_users_source
), current_fiscal_year AS (
    SELECT
      fiscal_year
    FROM dim_date
    WHERE date_actual = CURRENT_DATE()
), final AS (
    SELECT
      sfdc_users.user_id                                                                                                              AS dim_crm_user_id,
      sfdc_users.employee_number,
      sfdc_users.name                                                                                                                 AS user_name,
      sfdc_users.title,
      sfdc_users.department,
      sfdc_users.team,
      sfdc_users.manager_id,
      sfdc_users.manager_name,
      sfdc_users.user_email,
      sfdc_users.is_active,
      sfdc_users.start_date,
      sfdc_users.ramping_quota,
      sfdc_users.user_timezone,
      sfdc_users.user_role_id,
      md5(cast(coalesce(cast(sfdc_user_roles_source.name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                         AS dim_crm_user_role_name_id,
      sfdc_user_roles_source.name                                                                                                     AS user_role_name,
      sfdc_users.user_role_type                                                                                                       AS user_role_type,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_1 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_1_id,
      sfdc_users.user_role_level_1                                                                                                    AS user_role_level_1,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_2 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_2_id,
      sfdc_users.user_role_level_2                                                                                                    AS user_role_level_2,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_3 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_3_id,
      sfdc_users.user_role_level_3                                                                                                    AS user_role_level_3,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_4 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_4_id,
      sfdc_users.user_role_level_4                                                                                                    AS user_role_level_4,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_5 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_5_id,
      sfdc_users.user_role_level_5                                                                                                    AS user_role_level_5,
      md5(cast(coalesce(cast(sfdc_users.user_segment as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                             AS dim_crm_user_sales_segment_id,
      sfdc_users.user_segment                                                                                                         AS crm_user_sales_segment,
      sfdc_users.user_segment_grouped                                                                                                 AS crm_user_sales_segment_grouped,
      md5(cast(coalesce(cast(sfdc_users.user_geo as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                                 AS dim_crm_user_geo_id,
      sfdc_users.user_geo                                                                                                             AS crm_user_geo,
      md5(cast(coalesce(cast(sfdc_users.user_region as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                              AS dim_crm_user_region_id,
      sfdc_users.user_region                                                                                                          AS crm_user_region,
      md5(cast(coalesce(cast(sfdc_users.user_area as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                                AS dim_crm_user_area_id,
      sfdc_users.user_area                                                                                                            AS crm_user_area,
      md5(cast(coalesce(cast(sfdc_users.user_business_unit as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                       AS dim_crm_user_business_unit_id,
      sfdc_users.user_business_unit                                                                                                   AS crm_user_business_unit,
      md5(cast(coalesce(cast(sfdc_users.user_role_type as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                           AS dim_crm_user_role_type_id,
      CASE
        WHEN sfdc_users.is_hybrid_user = 'Yes'
          THEN 1
        WHEN sfdc_users.is_hybrid_user = 'No'
          THEN  0
        WHEN sfdc_users.is_hybrid_user IS NULL
          THEN 0
        ELSE 0
      END                                                                                                                             AS is_hybrid_user,
      CONCAT(
             UPPER(sfdc_user_roles_source.name),
             '-',
             current_fiscal_year.fiscal_year
            )                                                                                                                         AS dim_crm_user_hierarchy_sk,
      COALESCE(
               sfdc_users.user_segment_geo_region_area,
               CONCAT(sfdc_users.user_segment,'-' , sfdc_users.user_geo, '-', sfdc_users.user_region, '-', sfdc_users.user_area)
               )                                                                                                                      AS crm_user_sales_segment_geo_region_area,
      sfdc_users.user_segment_region_grouped                                                                                          AS crm_user_sales_segment_region_grouped,
      sheetload_mapping_sdr_sfdc_bamboohr_source.sdr_segment                                                                          AS sdr_sales_segment,
      sheetload_mapping_sdr_sfdc_bamboohr_source.sdr_region,
      sfdc_users.created_date,
         CASE
        WHEN LOWER(sfdc_users.user_business_unit) = 'entg'
          THEN user_geo
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
          AND
            (
            LOWER(sfdc_users.user_segment) = 'smb'
            AND LOWER(sfdc_users.user_geo) = 'amer'
            AND LOWER(sfdc_users.user_area) = 'lowtouch'
            )
          THEN 'AMER Low-Touch'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
          AND
            (
            LOWER(sfdc_users.user_segment) = 'mid-market'
            AND (LOWER(sfdc_users.user_geo) = 'amer' OR LOWER(sfdc_users.user_geo) = 'emea')
            AND LOWER(sfdc_users.user_role_type) = 'first order'
            )
          THEN 'MM First Orders'  --mid-market FO(?)
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
          AND LOWER(sfdc_users.user_geo) = 'emea'
          AND
            (
            LOWER(sfdc_users.user_segment) != 'mid-market'
            AND LOWER(sfdc_users.user_role_type) != 'first order'
            )
          THEN  'EMEA'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
          AND LOWER(sfdc_users.user_geo) = 'amer'
          AND
            (
            LOWER(sfdc_users.user_segment) != 'mid-market'
            AND LOWER(sfdc_users.user_role_type) != 'first order'
            )
          AND
            (
            LOWER(sfdc_users.user_segment) != 'smb'
            AND LOWER(sfdc_users.user_area) != 'lowtouch'
            )
          THEN 'AMER'
        ELSE 'Other'
      END                                                                                                                             AS crm_user_sub_business_unit,
      -- Division (X-Ray 3rd hierarchy)
      CASE
        WHEN LOWER(sfdc_users.user_business_unit) = 'entg'
          THEN sfdc_users.user_region
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND (LOWER(crm_user_sub_business_unit) = 'amer' OR LOWER(crm_user_sub_business_unit) = 'emea')
              AND LOWER(sfdc_users.user_segment) = 'mid-market'
          THEN 'Mid-Market'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND (LOWER(crm_user_sub_business_unit) = 'amer' OR LOWER(crm_user_sub_business_unit) = 'emea')
              AND LOWER(sfdc_users.user_segment) = 'smb'
          THEN 'SMB'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'mm first orders'
          THEN 'MM First Orders'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'amer low-touch'
          THEN 'AMER Low-Touch'
        ELSE 'Other'
      END                                                                                                                             AS crm_user_division,
      -- ASM (X-Ray 4th hierarchy): definition pending
      CASE
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'amer'
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'emea'
              AND (LOWER(crm_user_division) = 'dach' OR LOWER(crm_user_division) = 'neur' OR LOWER(crm_user_division) = 'seur')
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'emea'
              AND LOWER(crm_user_division) = 'meta'
          THEN sfdc_users.user_segment --- pending/ waiting for Meri?
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'apac'
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'pubsec'
              AND LOWER(crm_user_division) != 'sled'
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'pubsec'
              AND LOWER(crm_user_division) = 'sled'
          THEN sfdc_users.user_region
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND (LOWER(crm_user_sub_business_unit) = 'amer' OR LOWER(crm_user_sub_business_unit) = 'emea')
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'mm first orders'
          THEN sfdc_users.user_geo
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'amer low-touch'
              AND LOWER(sfdc_users.user_role_type) = 'first order'
          THEN 'LowTouch FO'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'amer low-touch'
              AND LOWER(sfdc_users.user_role_type) != 'first order'
          THEN 'LowTouch Pool'
        ELSE 'Other'
      END                                                                                                         AS asm
    FROM sfdc_users
    LEFT JOIN sfdc_user_roles_source
      ON sfdc_users.user_role_id = sfdc_user_roles_source.id
    LEFT JOIN sheetload_mapping_sdr_sfdc_bamboohr_source
      ON sfdc_users.user_id = sheetload_mapping_sdr_sfdc_bamboohr_source.user_id
    LEFT JOIN current_fiscal_year
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@chrissharp'::VARCHAR       AS updated_by,
      '2021-01-12'::DATE        AS model_created_date,
      '2024-02-28'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common_prep.prep_campaign as
WITH sfdc_campaign_info AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_campaign_source
    WHERE NOT is_deleted
), intermediate AS (
    SELECT
      -- campaign ids
      campaign_id                                   AS dim_campaign_id,
      campaign_parent_id                            AS dim_parent_campaign_id,
      -- campaign details
      campaign_name,
      is_active,
      status,
      type,
      description,
      budget_holder,
      bizible_touchpoint_enabled_setting,
      strategic_marketing_contribution,
      region,
      CASE
        WHEN sub_region = 'Central' AND region = 'EMEA'
            THEN 'Central Europe'
        WHEN sub_region = 'Northern' AND region = 'EMEA'
            THEN 'Northern Europe'
        WHEN sub_region = 'Southern' AND region = 'EMEA'
            THEN 'Southern Europe'
        ELSE sub_region
      END AS sub_region,
      large_bucket,
      reporting_type,
      allocadia_id,
      is_a_channel_partner_involved,
      is_an_alliance_partner_involved,
      is_this_an_in_person_event,
      alliance_partner_name,
      channel_partner_name,
      sales_play,
      gtm_motion,
      total_planned_mqls,
      will_there_be_mdf_funding,
      mdf_request_id,
      campaign_partner_crm_id,
      -- user ids
      campaign_owner_id,
      created_by_id,
      last_modified_by_id,
      -- dates
      start_date,
      end_date,
      created_date,
      last_modified_date,
      last_activity_date,
      --planned values
      planned_inquiry,
      planned_mql,
      planned_pipeline,
      planned_sao,
      planned_won,
      planned_roi,
      total_planned_mql,
      -- additive fields
      budgeted_cost,
      expected_response,
      expected_revenue,
      actual_cost,
      amount_all_opportunities,
      amount_won_opportunities,
      count_contacts,
      count_converted_leads,
      count_leads,
      count_opportunities,
      count_responses,
      count_won_opportunities,
      count_sent,
      registration_goal,
      attendance_goal,
    FROM sfdc_campaign_info
), campaign_parent AS (
    SELECT
        intermediate.dim_campaign_id,
        intermediate.campaign_name,
        parent_campaign.dim_campaign_id AS dim_parent_campaign_id,
        parent_campaign.campaign_name AS parent_campaign_name
    FROM intermediate
    LEFT JOIN intermediate AS parent_campaign
        ON intermediate.dim_parent_campaign_id=parent_campaign.dim_campaign_id
), series_final AS (
    SELECT
        campaign_parent.dim_campaign_id,
        campaign_parent.campaign_name,
        campaign_parent.dim_parent_campaign_id,
        campaign_parent.parent_campaign_name,
        CASE
            WHEN series.dim_parent_campaign_id IS NULL AND LOWER(series.campaign_name) LIKE '%series%'
                THEN series.dim_campaign_id
            WHEN  LOWER(series.parent_campaign_name) LIKE '%series%'
                THEN series.dim_parent_campaign_id
            ELSE NULL
        END AS series_campaign_id,
        CASE
            WHEN series.parent_campaign_name IS NULL AND LOWER(series.campaign_name) LIKE '%series%'
                THEN series.campaign_name
            WHEN LOWER(series.parent_campaign_name) LIKE '%series%'
                THEN series.parent_campaign_name
            ELSE NULL
        END AS series_campaign_name
    FROM campaign_parent
    LEFT JOIN campaign_parent AS series
        ON campaign_parent.dim_parent_campaign_id = series.dim_campaign_id
), final AS (
    SELECT
        intermediate.*,
        series_campaign_id,
        series_campaign_name
    FROM intermediate
    LEFT JOIN series_final
        ON intermediate.dim_campaign_id=series_final.dim_campaign_id
)
SELECT *
FROM final;

CREATE TABLE "PROD".common_prep.prep_crm_person as
WITH biz_person AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_bizible_person_source
    WHERE is_deleted = 'FALSE'
), biz_touchpoints AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_bizible_touchpoint_source
    WHERE bizible_touchpoint_position LIKE '%FT%'
     AND is_deleted = 'FALSE'
), prep_bizible_touchpoint_information AS (
    SELECT *
    FROM "PROD".common_prep.prep_bizible_touchpoint_information
), prep_date AS (
    SELECT *
    FROM "PROD".common_prep.prep_date
), prep_location_country AS (
    SELECT *
    FROM "PROD".common_prep.prep_location_country
), sfdc_account_source AS (
    SELECT
      account_id,
      six_sense_segments
    FROM "PREP".sfdc.sfdc_account_source
), crm_tasks AS (
    SELECT
      sfdc_record_id,
      MIN(task_completed_date) AS min_task_completed_date_by_bdr_sdr
    FROM "PROD".common_prep.prep_crm_task
    WHERE is_deleted = 'FALSE'
    AND task_owner_role LIKE '%BDR%'
    OR task_owner_role LIKE '%SDR%'
    GROUP BY 1
), crm_events AS (
    SELECT
      sfdc_record_id,
      MIN(event_date) AS min_task_completed_date_by_bdr_sdr
    FROM "PROD".common_prep.prep_crm_event
    LEFT JOIN "PROD".common.dim_crm_user event_user_id
    ON prep_crm_event.dim_crm_user_id = event_user_id.dim_crm_user_id
    LEFT JOIN "PROD".common.dim_crm_user  event_booked_by_id
    ON prep_crm_event.booked_by_employee_number = event_booked_by_id.employee_number
    WHERE
    event_user_id.user_role_name LIKE '%BDR%'
    OR event_booked_by_id.user_role_name LIKE '%BDR%'
    OR event_user_id.user_role_name LIKE '%SDR%'
    OR event_booked_by_id.user_role_name LIKE '%SDR%'
    GROUP BY 1
), crm_activity_prep AS (
    SELECT
      sfdc_record_id,
      min_task_completed_date_by_bdr_sdr
    FROM crm_tasks
    UNION
    SELECT
      sfdc_record_id,
      min_task_completed_date_by_bdr_sdr
    FROM crm_events
),  crm_activity AS (
    SELECT
      sfdc_record_id,
      MIN(min_task_completed_date_by_bdr_sdr) AS min_task_completed_date_by_bdr_sdr
    FROM crm_activity_prep
    GROUP BY 1
), biz_person_with_touchpoints AS (
    SELECT
      biz_touchpoints.*,
      biz_person.bizible_contact_id,
      biz_person.bizible_lead_id
    FROM biz_touchpoints
    JOIN biz_person
      ON biz_touchpoints.bizible_person_id = biz_person.person_id
    QUALIFY ROW_NUMBER() OVER(PARTITION BY bizible_lead_id,bizible_contact_id ORDER BY bizible_touchpoint_date DESC) = 1
), sfdc_contacts AS (
    SELECT
    sha2(
        TRIM(
            LOWER(
                contact_email ||
                ENCRYPT_RAW(
                  to_binary('SALT_EMAIL6', 'utf-8'),
                  to_binary('FEDCBAA123456785365637265EEEEEEA', 'HEX'),
                  to_binary('416C736F4E637265FFFFFFAB', 'HEX')
                )['ciphertext']::VARCHAR
            )
        )
    ) AS contact_email_hash,
    sha2(
        TRIM(
            LOWER(
                contact_name ||
                ENCRYPT_RAW(
                  to_binary('SALT_NAME8', 'utf-8'),
                  to_binary('FEDCBAA123456785365637265EEEEEEA', 'HEX'),
                  to_binary('416C736F4E637265FFFFFFAB', 'HEX')
                )['ciphertext']::VARCHAR
            )
        )
    ) AS contact_name_hash,
    "CONTACT_ID",
  "CONTACT_FIRST_NAME",
  "CONTACT_LAST_NAME",
  "EMAIL_DOMAIN",
  "EMAIL_DOMAIN_TYPE",
  "ACCOUNT_ID",
  "MASTER_RECORD_ID",
  "OWNER_ID",
  "RECORD_TYPE_ID",
  "REPORTS_TO_ID",
  "CONTACT_TITLE",
  "IT_JOB_TITLE_HIERARCHY",
  "CONTACT_ROLE",
  "MOBILE_PHONE",
  "PERSON_SCORE",
  "DEPARTMENT",
  "CONTACT_STATUS",
  "REQUESTED_CONTACT",
  "INACTIVE_CONTACT",
  "HAS_OPTED_OUT_EMAIL",
  "INVALID_EMAIL_ADDRESS",
  "EMAIL_IS_BOUNCED",
  "EMAIL_BOUNCED_DATE",
  "EMAIL_BOUNCED_REASON",
  "MAILING_ADDRESS",
  "MAILING_CITY",
  "MAILING_STATE",
  "MAILING_STATE_CODE",
  "MAILING_COUNTRY",
  "MAILING_COUNTRY_CODE",
  "MAILING_ZIP_CODE",
  "ZOOMINFO_COMPANY_ID",
  "ZOOMINFO_CONTACT_ID",
  "ZOOMINFO_COMPANY_REVENUE",
  "ZOOMINFO_COMPANY_EMPLOYEE_COUNT",
  "COGNISM_EMPLOYEE_COUNT",
  "ZOOMINFO_CONTACT_CITY",
  "ZOOMINFO_COMPANY_CITY",
  "ZOOMINFO_COMPANY_INDUSTRY",
  "ZOOMINFO_COMPANY_STATE",
  "ZOOMINFO_CONTACT_STATE",
  "ZOOMINFO_COMPANY_COUNTRY",
  "ZOOMINFO_CONTACT_COUNTRY",
  "ZOOMINFO_PHONE_NUMBER",
  "ZOOMINFO_MOBILE_PHONE_NUMBER",
  "ZOOMINFO_DO_NOT_CALL_DIRECT_PHONE",
  "ZOOMINFO_DO_NOT_CALL_MOBILE_PHONE",
  "USING_CE",
  "EE_TRIAL_START_DATE",
  "EE_TRIAL_END_DATE",
  "INDUSTRY",
  "RESPONDED_TO_GITHOST_PRICE_CHANGE",
  "CORE_CHECK_IN_NOTES",
  "LEAD_SOURCE",
  "LEAD_SOURCE_TYPE",
  "BEHAVIOR_SCORE",
  "OUTREACH_STAGE",
  "OUTREACH_STEP_NUMBER",
  "ACCOUNT_TYPE",
  "ASSIGNED_DATETIME",
  "MARKETO_QUALIFIED_LEAD_TIMESTAMP",
  "MARKETO_QUALIFIED_LEAD_DATETIME",
  "MARKETO_QUALIFIED_LEAD_DATE",
  "MQL_DATETIME_INFERRED",
  "INQUIRY_DATETIME",
  "INQUIRY_DATETIME_INFERRED",
  "ACCEPTED_DATETIME",
  "QUALIFYING_DATETIME",
  "QUALIFIED_DATETIME",
  "UNQUALIFIED_DATETIME",
  "INITIAL_RECYCLE_DATETIME",
  "MOST_RECENT_RECYCLE_DATETIME",
  "BAD_DATA_DATETIME",
  "WORKED_DATETIME",
  "WEB_PORTAL_PURCHASE_DATETIME",
  "MARKETO_LAST_INTERESTING_MOMENT",
  "MARKETO_LAST_INTERESTING_MOMENT_DATE",
  "LAST_UTM_CAMPAIGN",
  "LAST_UTM_CONTENT",
  "PROSPECT_SHARE_STATUS",
  "PARTNER_PROSPECT_STATUS",
  "PARTNER_PROSPECT_ID",
  "PARTNER_PROSPECT_OWNER_NAME",
  "SEQUENCE_STEP_TYPE",
  "NAME_OF_ACTIVE_SEQUENCE",
  "SEQUENCE_TASK_DUE_DATE",
  "SEQUENCE_STATUS",
  "IS_ACTIVELY_BEING_SEQUENCED",
  "IS_FIRST_ORDER_INITIAL_MQL",
  "IS_FIRST_ORDER_MQL",
  "IS_FIRST_ORDER_PERSON",
  "TRUE_INITIAL_MQL_DATE",
  "TRUE_MQL_DATE",
  "INITIAL_MARKETO_MQL_DATE_TIME",
  "LAST_TRANSFER_DATE_TIME",
  "TIME_FROM_LAST_TRANSFER_TO_SEQUENCE",
  "TIME_FROM_MQL_TO_LAST_TRANSFER",
  "IS_HIGH_PRIORITY",
  "HIGH_PRIORITY_DATETIME",
  "PTP_SCORE_DATE",
  "PTP_SCORE_GROUP",
  "PQL_NAMESPACE_CREATOR_JOB_DESCRIPTION",
  "PQL_NAMESPACE_ID",
  "PQL_NAMESPACE_NAME",
  "PQL_NAMESPACE_USERS",
  "IS_PRODUCT_QUALIFIED_LEAD",
  "PTP_DAYS_SINCE_TRIAL_START",
  "PTP_INSIGHTS",
  "IS_PTP_CONTACT",
  "PTP_NAMESPACE_ID",
  "PTP_PAST_INSIGHTS",
  "PTP_PAST_SCORE_GROUP",
  "LEAD_SCORE_CLASSIFICATION",
  "IS_DEFAULTED_TRIAL",
  "NET_NEW_SOURCE_CATEGORIES",
  "SOURCE_BUCKETS",
  "MQL_WORKED_BY_USER_ID",
  "MQL_WORKED_BY_USER_MANAGER_ID",
  "LAST_WORKED_BY_DATE",
  "LAST_WORKED_BY_DATETIME",
  "LAST_WORKED_BY_USER_MANAGER_ID",
  "LAST_WORKED_BY_USER_ID",
  "ACCOUNT_DEMOGRAPHICS_SALES_SEGMENT",
  "ACCOUNT_DEMOGRAPHICS_SALES_SEGMENT_GROUPED",
  "ACCOUNT_DEMOGRAPHICS_GEO",
  "ACCOUNT_DEMOGRAPHICS_REGION",
  "ACCOUNT_DEMOGRAPHICS_AREA",
  "ACCOUNT_DEMOGRAPHICS_SEGMENT_REGION_GROUPED",
  "ACCOUNT_DEMOGRAPHICS_TERRITORY",
  "ACCOUNT_DEMOGRAPHICS_EMPLOYEE_COUNT",
  "ACCOUNT_DEMOGRAPHICS_MAX_FAMILY_EMPLOYEE",
  "ACCOUNT_DEMOGRAPHICS_UPA_COUNTRY",
  "ACCOUNT_DEMOGRAPHICS_UPA_STATE",
  "ACCOUNT_DEMOGRAPHICS_UPA_CITY",
  "ACCOUNT_DEMOGRAPHICS_UPA_STREET",
  "ACCOUNT_DEMOGRAPHICS_UPA_POSTAL_CODE",
  "PATHFACTORY_EXPERIENCE_NAME",
  "PATHFACTORY_ENGAGEMENT_SCORE",
  "PATHFACTORY_CONTENT_COUNT",
  "PATHFACTORY_CONTENT_LIST",
  "PATHFACTORY_CONTENT_JOURNEY",
  "PATHFACTORY_TOPIC_LIST",
  "HAS_ACCOUNT_SIX_SENSE_6_QA",
  "SIX_SENSE_ACCOUNT_6_QA_END_DATE",
  "SIX_SENSE_ACCOUNT_6_QA_START_DATE",
  "SIX_SENSE_ACCOUNT_BUYING_STAGE",
  "SIX_SENSE_ACCOUNT_PROFILE_FIT",
  "SIX_SENSE_CONTACT_GRADE",
  "SIX_SENSE_CONTACT_PROFILE",
  "SIX_SENSE_CONTACT_UPDATE_DATE",
  "TRACTION_FIRST_RESPONSE_TIME",
  "TRACTION_FIRST_RESPONSE_TIME_SECONDS",
  "TRACTION_RESPONSE_TIME_IN_BUSINESS_HOURS",
  "USERGEM_PAST_ACCOUNT_ID",
  "USERGEM_PAST_ACCOUNT_TYPE",
  "USERGEM_PAST_CONTACT_RELATIONSHIP",
  "USERGEM_PAST_COMPANY",
  "GROOVE_ACTIVE_FLOWS_COUNT",
  "GROOVE_ADDED_TO_FLOW_DATE",
  "GROOVE_FLOW_COMPLETED_DATE",
  "IS_CREATED_BY_GROOVE",
  "GROOVE_LAST_ENGAGEMENT_DATETIME",
  "GROOVE_LAST_ENGAGEMENT_TYPE",
  "GROOVE_LAST_FLOW_NAME",
  "GROOVE_LAST_FLOW_STATUS",
  "GROOVE_LAST_FLOW_STEP_NUMBER",
  "GROOVE_LAST_FLOW_STEP_TYPE",
  "GROOVE_LAST_STEP_COMPLETED_DATETIME",
  "GROOVE_LAST_STEP_SKIPPED",
  "GROOVE_LAST_TOUCH_DATETIME",
  "GROOVE_LAST_TOUCH_TYPE",
  "GROOVE_LOG_A_CALL_URL",
  "GROOVE_NEXT_STEP_DUE_DATE",
  "GROOVE_MOBILE_NUMBER",
  "GROOVE_PHONE_NUMBER",
  "GROOVE_OVERDUE_DAYS",
  "GROOVE_REMOVED_FROM_FLOW_DATE",
  "GROOVE_REMOVED_FROM_FLOW_REASON",
  "GROOVE_CREATE_OPPORTUNITY_URL",
  "GROOVE_ENGAGEMENT_SCORE",
  "GROOVE_OUTBOUND_EMAIL_COUNTER",
  "ACCOUNT_OWNER",
  "AE_COMMENTS",
  "BUSINESS_DEVELOPMENT_REP_NAME",
  "OUTBOUND_BUSINESS_DEVELOPMENT_REP_NAME",
  "CREATED_BY_ID",
  "CREATED_DATE",
  "IS_DELETED",
  "LAST_ACTIVITY_DATE",
  "LAST_CU_REQUEST_DATE",
  "LAST_CU_UPDATE_DATE",
  "LAST_MODIFIED_BY_ID",
  "LAST_MODIFIED_DATE",
  "SYSTEMMODSTAMP"
    FROM "PREP".sfdc.sfdc_contact_source
    WHERE is_deleted = 'FALSE'
), sfdc_leads AS (
    SELECT
    sha2(
        TRIM(
            LOWER(
                lead_email ||
                ENCRYPT_RAW(
                  to_binary('SALT_EMAIL6', 'utf-8'),
                  to_binary('FEDCBAA123456785365637265EEEEEEA', 'HEX'),
                  to_binary('416C736F4E637265FFFFFFAB', 'HEX')
                )['ciphertext']::VARCHAR
            )
        )
    ) AS lead_email_hash,
    sha2(
        TRIM(
            LOWER(
                lead_name ||
                ENCRYPT_RAW(
                  to_binary('SALT_NAME8', 'utf-8'),
                  to_binary('FEDCBAA123456785365637265EEEEEEA', 'HEX'),
                  to_binary('416C736F4E637265FFFFFFAB', 'HEX')
                )['ciphertext']::VARCHAR
            )
        )
    ) AS lead_name_hash,
    "LEAD_ID",
  "LEAD_FIRST_NAME",
  "LEAD_LAST_NAME",
  "EMAIL_DOMAIN",
  "EMAIL_DOMAIN_TYPE",
  "MASTER_RECORD_ID",
  "CONVERTED_ACCOUNT_ID",
  "CONVERTED_CONTACT_ID",
  "CONVERTED_OPPORTUNITY_ID",
  "OWNER_ID",
  "RECORD_TYPE_ID",
  "ROUND_ROBIN_ID",
  "INSTANCE_UUID",
  "LEAN_DATA_MATCHED_ACCOUNT",
  "IS_CONVERTED",
  "CONVERTED_DATE",
  "TITLE",
  "IT_JOB_TITLE_HIERARCHY",
  "IS_DO_NOT_CALL",
  "HAS_OPTED_OUT_EMAIL",
  "EMAIL_BOUNCED_DATE",
  "EMAIL_BOUNCED_REASON",
  "BEHAVIOR_SCORE",
  "LEAD_SOURCE",
  "LEAD_FROM",
  "LEAD_SOURCE_TYPE",
  "LEAD_CONVERSION_APPROVAL_STATUS",
  "STREET",
  "CITY",
  "STATE",
  "STATE_CODE",
  "COUNTRY",
  "COUNTRY_CODE",
  "POSTAL_CODE",
  "ZOOMINFO_COMPANY_COUNTRY",
  "ZOOMINFO_CONTACT_COUNTRY",
  "ZOOMINFO_COMPANY_STATE",
  "ZOOMINFO_CONTACT_STATE",
  "REQUESTED_CONTACT",
  "COMPANY",
  "ZOOMINFO_COMPANY_ID",
  "ZOOMINFO_COMPANY_REVENUE",
  "ZOOMINFO_COMPANY_EMPLOYEE_COUNT",
  "ZOOMINFO_CONTACT_CITY",
  "ZOOMINFO_COMPANY_CITY",
  "ZOOMINFO_COMPANY_INDUSTRY",
  "ZOOMINFO_PHONE_NUMBER",
  "ZOOMINFO_MOBILE_PHONE_NUMBER",
  "ZOOMINFO_DO_NOT_CALL_DIRECT_PHONE",
  "ZOOMINFO_DO_NOT_CALL_MOBILE_PHONE",
  "BUYING_PROCESS",
  "CORE_CHECK_IN_NOTES",
  "INDUSTRY",
  "IS_LARGE_ACCOUNT",
  "OUTREACH_STAGE",
  "OUTREACH_STEP_NUMBER",
  "IS_INTERESTED_GITLAB_EE",
  "IS_INTERESTED_IN_HOSTED",
  "ASSIGNED_DATETIME",
  "MATCHED_ACCOUNT_TOP_LIST",
  "MATCHED_ACCOUNT_OWNER_ROLE",
  "MATCHED_ACCOUNT_SDR_ASSIGNED",
  "MATCHED_ACCOUNT_GTM_STRATEGY",
  "MATCHED_ACCOUNT_BDR_PROSPECTING_STATUS",
  "MATCHED_ACCOUNT_TYPE",
  "MATCHED_ACCOUNT_ACCOUNT_OWNER_NAME",
  "MARKETO_QUALIFIED_LEAD_DATE",
  "MARKETO_QUALIFIED_LEAD_DATETIME",
  "MQL_DATETIME_INFERRED",
  "INQUIRY_DATETIME",
  "INQUIRY_DATETIME_INFERRED",
  "ACCEPTED_DATETIME",
  "QUALIFYING_DATETIME",
  "QUALIFIED_DATETIME",
  "UNQUALIFIED_DATETIME",
  "INITIAL_RECYCLE_DATETIME",
  "MOST_RECENT_RECYCLE_DATETIME",
  "BAD_DATA_DATETIME",
  "WORKED_DATETIME",
  "WEB_PORTAL_PURCHASE_DATETIME",
  "SALES_SEGMENTATION",
  "PERSON_SCORE",
  "LEAD_STATUS",
  "LAST_UTM_CAMPAIGN",
  "LAST_UTM_CONTENT",
  "CRM_PARTNER_ID",
  "PROSPECT_SHARE_STATUS",
  "PARTNER_PROSPECT_STATUS",
  "PARTNER_PROSPECT_ID",
  "PARTNER_PROSPECT_OWNER_NAME",
  "IS_PARTNER_RECALLED",
  "NAME_OF_ACTIVE_SEQUENCE",
  "SEQUENCE_TASK_DUE_DATE",
  "SEQUENCE_STATUS",
  "SEQUENCE_STEP_TYPE",
  "IS_ACTIVELY_BEING_SEQUENCED",
  "GA_CLIENT_ID",
  "EMPLOYEE_BUCKET",
  "IS_FIRST_ORDER_INITIAL_MQL",
  "IS_FIRST_ORDER_MQL",
  "IS_FIRST_ORDER_PERSON",
  "TRUE_INITIAL_MQL_DATE",
  "TRUE_MQL_DATE",
  "LAST_TRANSFER_DATE_TIME",
  "INITIAL_MARKETO_MQL_DATE_TIME",
  "TIME_FROM_LAST_TRANSFER_TO_SEQUENCE",
  "TIME_FROM_MQL_TO_LAST_TRANSFER",
  "IS_HIGH_PRIORITY",
  "HIGH_PRIORITY_DATETIME",
  "PTP_SCORE_DATE",
  "PTP_SCORE_GROUP",
  "IS_PRODUCT_QUALIFIED_LEAD",
  "PTP_DAYS_SINCE_TRIAL_START",
  "PTP_INSIGHTS",
  "IS_PTP_CONTACT",
  "PTP_NAMESPACE_ID",
  "PTP_PAST_INSIGHTS",
  "PTP_PAST_SCORE_GROUP",
  "IS_DEFAULTED_TRIAL",
  "PQL_NAMESPACE_CREATOR_JOB_DESCRIPTION",
  "PQL_NAMESPACE_ID",
  "PQL_NAMESPACE_NAME",
  "PQL_NAMESPACE_USERS",
  "LEAD_SCORE_CLASSIFICATION",
  "ASSIGNMENT_DATE",
  "ASSIGNMENT_TYPE",
  "NET_NEW_SOURCE_CATEGORIES",
  "SOURCE_BUCKETS",
  "MQL_WORKED_BY_USER_ID",
  "MQL_WORKED_BY_USER_MANAGER_ID",
  "LAST_WORKED_BY_DATE",
  "LAST_WORKED_BY_DATETIME",
  "LAST_WORKED_BY_USER_MANAGER_ID",
  "LAST_WORKED_BY_USER_ID",
  "TSP_OWNER",
  "TSP_REGION",
  "TSP_SUB_REGION",
  "TSP_TERRITORY",
  "ACCOUNT_DEMOGRAPHICS_SALES_SEGMENT",
  "ACCOUNT_DEMOGRAPHICS_SALES_SEGMENT_DEPRECATED",
  "ACCOUNT_DEMOGRAPHICS_SALES_SEGMENT_GROUPED",
  "ACCOUNT_DEMOGRAPHICS_GEO",
  "ACCOUNT_DEMOGRAPHICS_REGION",
  "ACCOUNT_DEMOGRAPHICS_AREA",
  "ACCOUNT_DEMOGRAPHICS_SEGMENT_REGION_GROUPED",
  "ACCOUNT_DEMOGRAPHICS_TERRITORY",
  "ACCOUNT_DEMOGRAPHICS_EMPLOYEE_COUNT",
  "ACCOUNT_DEMOGRAPHICS_MAX_FAMILY_EMPLOYEE",
  "ACCOUNT_DEMOGRAPHICS_UPA_COUNTRY",
  "ACCOUNT_DEMOGRAPHICS_UPA_STATE",
  "ACCOUNT_DEMOGRAPHICS_UPA_CITY",
  "ACCOUNT_DEMOGRAPHICS_UPA_STREET",
  "ACCOUNT_DEMOGRAPHICS_UPA_POSTAL_CODE",
  "HAS_ACCOUNT_SIX_SENSE_6_QA",
  "SIX_SENSE_ACCOUNT_6_QA_END_DATE",
  "SIX_SENSE_ACCOUNT_6_QA_START_DATE",
  "SIX_SENSE_ACCOUNT_BUYING_STAGE",
  "SIX_SENSE_ACCOUNT_PROFILE_FIT",
  "SIX_SENSE_LEAD_GRADE",
  "SIX_SENSE_LEAD_PROFILE_FIT",
  "SIX_SENSE_LEAD_UPDATE_DATE",
  "SIX_SENSE_SEGMENTS",
  "GROOVE_ACTIVE_FLOWS_COUNT",
  "GROOVE_ADDED_TO_FLOW_DATE",
  "IS_GROOVE_CONVERTED",
  "GROOVE_FLOW_COMPLETED_DATE",
  "IS_CREATED_BY_GROOVE",
  "GROOVE_LAST_ENGAGEMENT_DATETIME",
  "GROOVE_LAST_ENGAGEMENT_TYPE",
  "GROOVE_LAST_FLOW_NAME",
  "GROOVE_LAST_FLOW_STATUS",
  "GROOVE_LAST_FLOW_STEP_NUMBER",
  "GROOVE_LAST_FLOW_STEP_TYPE",
  "GROOVE_LAST_STEP_COMPLETED_DATETIME",
  "GROOVE_LAST_STEP_SKIPPED",
  "GROOVE_LAST_TOUCH_DATETIME",
  "GROOVE_LAST_TOUCH_TYPE",
  "GROOVE_LOG_A_CALL_URL",
  "GROOVE_NEXT_STEP_DUE_DATE",
  "GROOVE_MOBILE_NUMBER",
  "GROOVE_PHONE_NUMBER",
  "GROOVE_OVERDUE_DAYS",
  "GROOVE_REMOVED_FROM_FLOW_DATE",
  "GROOVE_REMOVED_FROM_FLOW_REASON",
  "TRACTION_FIRST_RESPONSE_TIME",
  "TRACTION_FIRST_RESPONSE_TIME_SECONDS",
  "TRACTION_RESPONSE_TIME_IN_BUSINESS_HOURS",
  "USERGEM_PAST_ACCOUNT_ID",
  "USERGEM_PAST_ACCOUNT_TYPE",
  "USERGEM_PAST_CONTACT_RELATIONSHIP",
  "USERGEM_PAST_COMPANY",
  "PATHFACTORY_EXPERIENCE_NAME",
  "PATHFACTORY_ENGAGEMENT_SCORE",
  "PATHFACTORY_CONTENT_COUNT",
  "PATHFACTORY_CONTENT_LIST",
  "PATHFACTORY_CONTENT_JOURNEY",
  "PATHFACTORY_TOPIC_LIST",
  "MARKETO_LAST_INTERESTING_MOMENT",
  "MARKETO_LAST_INTERESTING_MOMENT_DATE",
  "BUSINESS_DEVELOPMENT_LOOK_UP",
  "BUSINESS_DEVELOPMENT_REPRESENTATIVE_CONTACT",
  "BUSINESS_DEVELOPMENT_REPRESENTATIVE",
  "CRM_SALES_DEV_REP_ID",
  "COMPETITION",
  "COGNISM_COMPANY_OFFICE_CITY",
  "COGNISM_COMPANY_OFFICE_STATE",
  "COGNISM_COMPANY_OFFICE_COUNTRY",
  "COGNISM_CITY",
  "COGNISM_STATE",
  "COGNISM_COUNTRY",
  "COGNISM_EMPLOYEE_COUNT",
  "LEANDATA_MATCHED_ACCOUNT_BILLING_STATE",
  "LEANDATA_MATCHED_ACCOUNT_BILLING_POSTAL_CODE",
  "LEANDATA_MATCHED_ACCOUNT_BILLING_COUNTRY",
  "LEANDATA_MATCHED_ACCOUNT_EMPLOYEE_COUNT",
  "LEANDATA_MATCHED_ACCOUNT_SALES_SEGMENT",
  "CREATED_BY_ID",
  "CREATED_DATE",
  "IS_DELETED",
  "LAST_ACTIVITY_DATE",
  "LAST_MODIFIED_ID",
  "LAST_MODIFIED_DATE",
  "SYSTEMMODSTAMP"
    FROM "PREP".sfdc.sfdc_lead_source
    WHERE is_deleted = 'FALSE'
),  was_converted_lead AS (
    SELECT DISTINCT
      contact_id,
      1 AS was_converted_lead
    FROM "PREP".sfdc.sfdc_contact_source
    INNER JOIN "PREP".sfdc.sfdc_lead_source
      ON sfdc_contact_source.contact_id = sfdc_lead_source.converted_contact_id
),  marketo_persons AS (
    SELECT
      marketo_lead_id,
      sfdc_type,
      sfdc_lead_id,
      sfdc_contact_id
    FROM "PREP".marketo.marketo_lead_source
    LEFT JOIN "PREP".marketo.marketo_activity_delete_lead_source
      ON marketo_lead_source.marketo_lead_id=marketo_activity_delete_lead_source.lead_id
    WHERE marketo_activity_delete_lead_source.activity_date IS NULL
    QUALIFY ROW_NUMBER() OVER(PARTITION BY sfdc_lead_id,sfdc_contact_id  ORDER BY updated_at DESC) = 1
),  crm_person_final AS (
    SELECT
      --id
      md5(cast(coalesce(cast(sfdc_contacts.contact_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS dim_crm_person_id,
      sfdc_contacts.contact_id                      AS sfdc_record_id,
      bizible_person_id                             AS bizible_person_id,
      'contact'                                     AS sfdc_record_type,
      contact_email_hash                            AS email_hash,
      email_domain,
      email_domain_type,
      marketo_lead_id,
      --keys
      master_record_id,
      owner_id,
      record_type_id,
      sfdc_contacts.account_id                      AS dim_crm_account_id,
      reports_to_id,
      owner_id                                      AS dim_crm_user_id,
      --info
      person_score,
      behavior_score,
      contact_title                                 AS title,
      contact_role                                  AS person_role,
      it_job_title_hierarchy,
      contact_role,
      has_opted_out_email,
      email_bounced_date,
      email_bounced_reason,
      contact_status                                AS status,
      lead_source,
      lead_source_type,
      inactive_contact,
      was_converted_lead.was_converted_lead         AS was_converted_lead,
      source_buckets,
      net_new_source_categories,
      bizible_touchpoint_position,
      bizible_marketing_channel_path,
      bizible_touchpoint_date,
      marketo_last_interesting_moment,
      marketo_last_interesting_moment_date,
      outreach_step_number,
      NULL                                          AS matched_account_owner_role,
      NULL                                          AS matched_account_account_owner_name,
      NULL                                          AS matched_account_sdr_assigned,
      NULL                                          AS matched_account_type,
      NULL                                          AS matched_account_gtm_strategy,
      NULL                                          AS matched_account_bdr_prospecting_status,
      is_first_order_initial_mql,
      is_first_order_mql,
      is_first_order_person,
      last_utm_content,
      last_utm_campaign,
      sequence_step_type,
      name_of_active_sequence,
      sequence_task_due_date,
      sequence_status,
      is_actively_being_sequenced,
      high_priority_datetime,
      CASE
        WHEN high_priority_datetime IS NOT NULL
          THEN TRUE
        ELSE FALSE
      END AS is_high_priority,
      prospect_share_status,
      partner_prospect_status,
      partner_prospect_id,
      partner_prospect_owner_name,
      mailing_country                               AS country,
      mailing_state                                 AS state,
      last_activity_date,
      NULL                                          AS employee_bucket,
      CASE
        WHEN account_demographics_sales_segment IS NULL OR UPPER(account_demographics_sales_segment) LIKE '%NOT FOUND%'
          THEN 'UNKNOWN'
        ELSE account_demographics_sales_segment
      END AS account_demographics_sales_segment,
      account_demographics_sales_segment_grouped,
      CASE
        WHEN account_demographics_geo IS NULL OR UPPER(account_demographics_geo) LIKE '%NOT FOUND%'
          THEN 'UNKNOWN'
        ELSE account_demographics_geo
      END AS account_demographics_geo,
      CASE
        WHEN account_demographics_region IS NULL OR UPPER(account_demographics_region) LIKE '%NOT FOUND%'
          THEN 'UNKNOWN'
        ELSE account_demographics_region
      END AS account_demographics_region,
      CASE
        WHEN account_demographics_area IS NULL OR UPPER(account_demographics_area) LIKE '%NOT FOUND%'
          THEN 'UNKNOWN'
        ELSE account_demographics_area
      END AS account_demographics_area,
      account_demographics_segment_region_grouped,
      account_demographics_territory,
      account_demographics_employee_count,
      account_demographics_max_family_employee,
      account_demographics_upa_country,
      account_demographics_upa_state,
      account_demographics_upa_city,
      account_demographics_upa_street,
      account_demographics_upa_postal_code,
      NULL                                          AS crm_partner_id,
      NULL                                          AS ga_client_id,
      NULL                                          AS cognism_company_office_city,
      NULL                                          AS cognism_company_office_state,
      NULL                                          AS cognism_company_office_country,
      NULL                                          AS cognism_city,
      NULL                                          AS cognism_state,
      NULL                                          AS cognism_country,
      cognism_employee_count,
      NULL                                          AS leandata_matched_account_billing_state,
      NULL                                          AS leandata_matched_account_billing_postal_code,
      NULL                                          AS leandata_matched_account_billing_country,
      NULL                                          AS leandata_matched_account_employee_count,
      NULL                                          AS leandata_matched_account_sales_segment,
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
      traction_first_response_time,
      traction_first_response_time_seconds,
      traction_response_time_in_business_hours,
      usergem_past_account_id,
      usergem_past_account_type,
      usergem_past_contact_relationship,
      usergem_past_company,
      last_transfer_date_time,
      time_from_last_transfer_to_sequence,
      time_from_mql_to_last_transfer,
      ptp_score_date                                 AS propensity_to_purchase_score_date,
      ptp_score_group                                AS propensity_to_purchase_score_group,
      pql_namespace_creator_job_description,
      pql_namespace_id,
      pql_namespace_name,
      pql_namespace_users,
      is_product_qualified_lead,
      ptp_days_since_trial_start                     AS propensity_to_purchase_days_since_trial_start,
      ptp_insights                                   AS propensity_to_purchase_insights,
      is_ptp_contact,
      ptp_namespace_id                               AS propensity_to_purchase_namespace_id,
      ptp_past_insights                              AS propensity_to_purchase_past_insights,
      ptp_past_score_group                           AS propensity_to_purchase_past_score_group,
      has_account_six_sense_6_qa,
      six_sense_account_6_qa_end_date,
      six_sense_account_6_qa_start_date,
      six_sense_account_buying_stage,
      six_sense_account_profile_fit,
      six_sense_contact_grade                        AS six_sense_person_grade,
      six_sense_contact_profile                      AS six_sense_person_profile,
      six_sense_contact_update_date                  AS six_sense_person_update_date,
      sfdc_account_source.six_sense_segments,
      mql_worked_by_user_id,
      mql_worked_by_user_manager_id,
      last_worked_by_date,
      last_worked_by_datetime,
      last_worked_by_user_manager_id,
      last_worked_by_user_id,
      groove_active_flows_count,
      groove_added_to_flow_date,
      NULL AS groove_email,
      groove_flow_completed_date,
      is_created_by_groove,
      groove_last_engagement_datetime,
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
      groove_next_step_due_date,
      groove_mobile_number,
      groove_phone_number,
      groove_overdue_days,
      groove_removed_from_flow_date,
      groove_removed_from_flow_reason,
      groove_create_opportunity_url,
      NULL AS groove_email_domain,
      groove_engagement_score,
      groove_outbound_email_counter,
      NULL AS is_groove_converted,
      lead_score_classification,
      is_defaulted_trial,
      NULL                                           AS zoominfo_company_employee_count,
      zoominfo_contact_id,
      NULL                                           AS is_partner_recalled,
      CASE
        WHEN crm_activity.min_task_completed_date_by_bdr_sdr IS NOT NULL
          THEN TRUE
        ELSE FALSE
      END AS is_bdr_sdr_worked,
      NULL AS assignment_date,
      NULL AS assignment_type,
      created_date
    FROM sfdc_contacts
    LEFT JOIN biz_person_with_touchpoints
      ON sfdc_contacts.contact_id = biz_person_with_touchpoints.bizible_contact_id
    LEFT JOIN was_converted_lead
      ON was_converted_lead.contact_id = sfdc_contacts.contact_id
    LEFT JOIN marketo_persons
      ON sfdc_contacts.contact_id = marketo_persons.sfdc_contact_id and sfdc_type = 'Contact'
    LEFT JOIN crm_activity
      ON sfdc_contacts.contact_id=crm_activity.sfdc_record_id
    LEFT JOIN sfdc_account_source
      ON sfdc_contacts.account_id=sfdc_account_source.account_id
    UNION
    SELECT
      --id
      md5(cast(coalesce(cast(lead_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS dim_crm_person_id,
      lead_id                                    AS sfdc_record_id,
      bizible_person_id                          AS bizible_person_id,
      'lead'                                     AS sfdc_record_type,
      lead_email_hash                            AS email_hash,
      email_domain,
      email_domain_type,
      marketo_lead_id,
      --keys
      master_record_id,
      owner_id,
      record_type_id,
      lean_data_matched_account                  AS dim_crm_account_id,
      NULL                                       AS reports_to_id,
      owner_id                                   AS dim_crm_user_id,
      --info
      person_score,
      behavior_score,
      title,
      NULL                                       AS person_role,
      it_job_title_hierarchy,
      NULL                                       AS contact_role,
      has_opted_out_email,
      email_bounced_date,
      email_bounced_reason,
      lead_status                                AS status,
      lead_source,
      lead_source_type,
      NULL                                       AS inactive_contact,
      0                                          AS was_converted_lead,
      source_buckets,
      net_new_source_categories,
      bizible_touchpoint_position,
      bizible_marketing_channel_path,
      bizible_touchpoint_date,
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
      last_utm_content,
      last_utm_campaign,
      sequence_step_type,
      name_of_active_sequence,
      sequence_task_due_date,
      sequence_status,
      is_actively_being_sequenced,
      high_priority_datetime,
      CASE
        WHEN high_priority_datetime IS NOT NULL
          THEN TRUE
        ELSE FALSE
      END AS is_high_priority,
      prospect_share_status,
      partner_prospect_status,
      partner_prospect_id,
      partner_prospect_owner_name,
      country,
      state,
      last_activity_date,
      employee_bucket,
      CASE
        WHEN account_demographics_sales_segment IS NULL OR UPPER(account_demographics_sales_segment) LIKE '%NOT FOUND%'
          THEN 'UNKNOWN'
        ELSE account_demographics_sales_segment
      END AS account_demographics_sales_segment,
      account_demographics_sales_segment_grouped,
      CASE
        WHEN account_demographics_geo IS NULL OR UPPER(account_demographics_geo) LIKE '%NOT FOUND%'
          THEN 'UNKNOWN'
        ELSE account_demographics_geo
      END AS account_demographics_geo,
      CASE
        WHEN account_demographics_region IS NULL OR UPPER(account_demographics_region) LIKE '%NOT FOUND%'
          THEN 'UNKNOWN'
        ELSE account_demographics_region
      END AS account_demographics_region,
      CASE
        WHEN account_demographics_area IS NULL OR UPPER(account_demographics_area) LIKE '%NOT FOUND%'
          THEN 'UNKNOWN'
        ELSE account_demographics_area
      END AS account_demographics_area,
      account_demographics_segment_region_grouped,
      account_demographics_territory,
      account_demographics_employee_count,
      account_demographics_max_family_employee,
      account_demographics_upa_country,
      account_demographics_upa_state,
      account_demographics_upa_city,
      account_demographics_upa_street,
      account_demographics_upa_postal_code,
      crm_partner_id,
      ga_client_id,
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
      traction_first_response_time,
      traction_first_response_time_seconds,
      traction_response_time_in_business_hours,
      usergem_past_account_id,
      usergem_past_account_type,
      usergem_past_contact_relationship,
      usergem_past_company,
      last_transfer_date_time,
      time_from_last_transfer_to_sequence,
      time_from_mql_to_last_transfer,
      ptp_score_date                                 AS propensity_to_purchase_score_date,
      ptp_score_group                                AS propensity_to_purchase_score_group,
      pql_namespace_creator_job_description,
      pql_namespace_id,
      pql_namespace_name,
      pql_namespace_users,
      is_product_qualified_lead,
      ptp_days_since_trial_start                     AS propensity_to_purchase_days_since_trial_start,
      ptp_insights                                   AS propensity_to_purchase_insights,
      is_ptp_contact,
      ptp_namespace_id                               AS propensity_to_purchase_namespace_id,
      ptp_past_insights                              AS propensity_to_purchase_past_insights,
      ptp_past_score_group                           AS propensity_to_purchase_past_score_group,
      has_account_six_sense_6_qa,
      six_sense_account_6_qa_end_date,
      six_sense_account_6_qa_start_date,
      six_sense_account_buying_stage,
      six_sense_account_profile_fit,
      six_sense_lead_grade,
      six_sense_lead_profile_fit,
      six_sense_lead_update_date,
      six_sense_segments,
      mql_worked_by_user_id,
      mql_worked_by_user_manager_id,
      last_worked_by_date,
      last_worked_by_datetime,
      last_worked_by_user_manager_id,
      last_worked_by_user_id,
      groove_active_flows_count,
      groove_added_to_flow_date,
      NULL AS groove_email,
      groove_flow_completed_date,
      is_created_by_groove,
      groove_last_engagement_datetime,
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
      groove_next_step_due_date,
      groove_mobile_number,
      groove_phone_number,
      groove_overdue_days,
      groove_removed_from_flow_date,
      groove_removed_from_flow_reason,
      NULL AS groove_create_opportunity_url,
      NULL AS groove_email_domain,
      NULL AS groove_engagement_score,
      NULL AS groove_outbound_email_counter,
      is_groove_converted,
      lead_score_classification,
      is_defaulted_trial,
      zoominfo_company_employee_count,
      NULL AS zoominfo_contact_id,
      is_partner_recalled,
      CASE
        WHEN crm_tasks.min_task_completed_date_by_bdr_sdr IS NOT NULL
          THEN TRUE
        ELSE FALSE
      END AS is_bdr_sdr_worked,
      assignment_date,
      assignment_type,
      created_date
    FROM sfdc_leads
    LEFT JOIN biz_person_with_touchpoints
      ON sfdc_leads.lead_id = biz_person_with_touchpoints.bizible_lead_id
    LEFT JOIN marketo_persons
      ON sfdc_leads.lead_id = marketo_persons.sfdc_lead_id and sfdc_type = 'Lead'
    LEFT JOIN crm_tasks
      ON sfdc_leads.lead_id=crm_tasks.sfdc_record_id
    WHERE is_converted = 'FALSE'
), final AS (
    SELECT
      crm_person_final.*,
      LOWER(COALESCE(
                     account_demographics_upa_country,
                     zoominfo_company_country,
                     country
                    )
       ) AS two_letter_person_first_country,
      CASE
        -- remove a few case where value is only numbers
        WHEN (TRY_TO_NUMBER(two_letter_person_first_country)) IS NOT NULL THEN
             NULL
        WHEN LEN(two_letter_person_first_country) = 2 AND prep_location_country.country_name IS NOT NULL THEN
            INITCAP(prep_location_country.country_name)
        WHEN LEN(two_letter_person_first_country) = 2 THEN
            -- This condition would be for a country code that isn't on the model
            UPPER(two_letter_person_first_country)
        ELSE
            INITCAP(two_letter_person_first_country)
      END AS person_first_country,
      prep_date.fiscal_year  AS created_date_fiscal_year,
      CONCAT(
        UPPER(crm_person_final.account_demographics_sales_segment),
        '-',
        UPPER(crm_person_final.account_demographics_geo),
        '-',
        UPPER(crm_person_final.account_demographics_region),
        '-',
        UPPER(crm_person_final.account_demographics_area),
        '-',
        prep_date.fiscal_year
      ) AS dim_account_demographics_hierarchy_sk,
      CASE
        WHEN LOWER(email_domain) = 'gitlab.com'
          THEN TRUE
        WHEN LOWER(account_demographics_geo) = 'jihu'
          THEN TRUE
        ELSE FALSE
      END AS is_exclude_from_reporting,
    --MQL and Most Recent Touchpoint info
      prep_bizible_touchpoint_information.bizible_mql_touchpoint_id,
      prep_bizible_touchpoint_information.bizible_mql_touchpoint_date,
      prep_bizible_touchpoint_information.bizible_mql_form_url,
      prep_bizible_touchpoint_information.bizible_mql_sfdc_campaign_id,
      prep_bizible_touchpoint_information.bizible_mql_ad_campaign_name,
      prep_bizible_touchpoint_information.bizible_mql_marketing_channel,
      prep_bizible_touchpoint_information.bizible_mql_marketing_channel_path,
      prep_bizible_touchpoint_information.bizible_most_recent_touchpoint_id,
      prep_bizible_touchpoint_information.bizible_most_recent_touchpoint_date,
      prep_bizible_touchpoint_information.bizible_most_recent_form_url,
      prep_bizible_touchpoint_information.bizible_most_recent_sfdc_campaign_id,
      prep_bizible_touchpoint_information.bizible_most_recent_ad_campaign_name,
      prep_bizible_touchpoint_information.bizible_most_recent_marketing_channel,
      prep_bizible_touchpoint_information.bizible_most_recent_marketing_channel_path
    FROM crm_person_final
    LEFT JOIN prep_date
      ON prep_date.date_actual = crm_person_final.created_date::DATE
    LEFT JOIN prep_bizible_touchpoint_information
      ON crm_person_final.sfdc_record_id=prep_bizible_touchpoint_information.sfdc_record_id
    LEFT JOIN prep_location_country
      ON two_letter_person_first_country = LOWER(prep_location_country.iso_2_country_code)
      -- Only join when the value is 2 letters
      AND LEN(two_letter_person_first_country) = 2
    WHERE crm_person_final.sfdc_record_id != '00Q4M00000kDDKuUAO' --DQ issue: https://gitlab.com/gitlab-data/analytics/-/issues/11559
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2020-12-08'::DATE        AS model_created_date,
      '2024-12-02'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common_prep.prep_crm_touchpoint as
WITH bizible_person_touchpoint_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_bizible_touchpoint_source
    WHERE is_deleted = 'FALSE'
), bizible_person_touchpoint_base AS (
  SELECT DISTINCT
    bizible_person_touchpoint_source.*,
    LOWER(bizible_form_url) AS bizible_form_url_prep,
    REPLACE(bizible_form_url_prep,'.html','') AS bizible_form_url_clean,
    pathfactory_content_type,
    prep_campaign.type
  FROM bizible_person_touchpoint_source
  LEFT JOIN "PROD".legacy.sheetload_bizible_to_pathfactory_mapping
    ON bizible_form_url_clean=bizible_url
  LEFT JOIN "PROD".common_prep.prep_campaign
      ON bizible_person_touchpoint_source.campaign_id = prep_campaign.dim_campaign_id
), final AS (
  SELECT
    bizible_person_touchpoint_base.*,
     CASE
      WHEN bizible_touchpoint_type = 'Web Chat'
        OR LOWER(bizible_ad_campaign_name) LIKE '%webchat%'
        OR bizible_ad_campaign_name = 'FY24_Qualified.com web conversation'
        THEN 'Web Chat'
      WHEN bizible_touchpoint_type IN ('Web Form', 'marketotouchpoin')
        AND bizible_form_url_clean IN ('gitlab.com/-/trial_registrations/new',
                                'gitlab.com/-/trial_registrations',
                                'gitlab.com/-/trials/new')
        THEN 'GitLab Dot Com Trial'
      WHEN bizible_touchpoint_type IN ('Web Form', 'marketotouchpoin')
        AND bizible_form_url_clean IN (
                                'about.gitlab.com/free-trial/index',
                                'about.gitlab.com/free-trial',
                                'about.gitlab.com/free-trial/self-managed',
                                'about.gitlab.com/free-trial/self-managed/index',
                                'about.gitlab.com/fr-fr/free-trial',
                                'about.gitlab.com/ja-jp/free-trial'
                                )
        THEN 'GitLab Self-Managed Trial'
      WHEN  bizible_form_url_clean LIKE '%/sign_up%'
        OR bizible_form_url_clean LIKE '%/users%'
        THEN 'Sign Up Form'
      WHEN bizible_form_url_clean IN ('about.gitlab.com/sales',
        'about.gitlab.com/ja-jp/sales',
        'about.gitlab.com/de-de/sales',
        'about.gitlab.com/fr-fr/sales',
        'about.gitlab.com/es/sales',
        'about.gitlab.com/dedicated',
        'about.gitlab.com/pt-br/sales'
        )
        OR bizible_form_url_clean LIKE 'about.gitlab.com/pricing/smb%'
        THEN 'Contact Sales Form'
      WHEN bizible_form_url_clean LIKE '%/resources/%'
        THEN 'Resources'
      WHEN bizible_touchpoint_type IN ('Web Form', 'marketotouchpoin')
        AND
          (
            (bizible_form_url_clean LIKE '%page.gitlab.com%')
            OR (bizible_form_url_clean LIKE '%about.gitlab.com/gartner%%')
          )
        THEN 'Online Content'
      WHEN bizible_form_url_clean LIKE 'learn.gitlab.com%'
        THEN 'Online Content'
      WHEN bizible_marketing_channel = 'Event'
        THEN type
      WHEN (LOWER(bizible_ad_campaign_name) LIKE '%lead%'
        AND LOWER(bizible_ad_campaign_name) LIKE '%linkedin%')
        OR
        (
          type  = 'Paid Social'
          -- they are all ABM LinkedIN Lead Gen but the name doesn't say that.
          AND (bizible_ad_campaign_name LIKE '%2023_ABM%'
            OR bizible_ad_campaign_name LIKE '%2024_ABM%')
        )
        THEN 'Lead Gen Form'
      WHEN bizible_marketing_channel = 'IQM'
        THEN 'IQM'
      WHEN bizible_form_url_clean LIKE '%/education/%'
        OR LOWER(bizible_ad_campaign_name) LIKE '%education%'
        THEN 'Education'
      WHEN bizible_form_url_clean LIKE '%/company/%'
        THEN 'Company Pages'
      WHEN bizible_touchpoint_type = 'CRM'
        AND (LOWER(bizible_ad_campaign_name) LIKE '%partner%'
          OR LOWER(bizible_medium) LIKE '%partner%')
        THEN 'Partner Sourced'
      WHEN bizible_form_url_clean ='about.gitlab.com/company/contact/'
        OR bizible_form_url_clean LIKE '%/releases/%'
        OR bizible_form_url_clean LIKE '%/blog/%'
        OR bizible_form_url_clean LIKE '%/community/%'
        THEN 'Newsletter/Release/Blog Sign-Up'
      WHEN type  = 'Survey'
        OR bizible_form_url_clean LIKE '%survey%'
          OR LOWER(bizible_ad_campaign_name) LIKE '%survey%'
        THEN 'Survey'
      WHEN bizible_form_url_clean LIKE '%/solutions/%'
        OR bizible_form_url_clean IN ('about.gitlab.com/enterprise/','about.gitlab.com/small-business/')
        THEN 'Solutions'
      WHEN bizible_form_url_clean LIKE '%/blog%'
        THEN 'Blog'
      WHEN bizible_form_url_clean LIKE '%/webcast/%'
        THEN 'Webcast'
      WHEN bizible_form_url_clean LIKE '%/services%'
        THEN 'GitLab Professional Services'
      WHEN bizible_form_url_clean LIKE '%/fifteen%'
        THEN  'Event Registration'
      WHEN bizible_ad_campaign_name LIKE '%PQL%'
        THEN 'Product Qualified Lead'
      WHEN bizible_marketing_channel_path LIKE '%Content Syndication%'
        THEN 'Content Syndication'
      WHEN (bizible_form_url_clean LIKE '%about.gitlab.com/events%')
        THEN 'Event Registration'
      ELSE 'Other'
    END AS touchpoint_offer_type_wip,
    CASE
      WHEN pathfactory_content_type IS NOT NULL
        THEN pathfactory_content_type
      WHEN (touchpoint_offer_type_wip = 'Online Content'
        AND bizible_form_url_clean LIKE '%registration-page%'
        OR bizible_form_url_clean LIKE '%registrationpage%'
        OR bizible_form_url_clean LIKE '%inperson%'
        OR bizible_form_url_clean LIKE '%in-person%'
        OR bizible_form_url_clean LIKE '%landing-page%')
        OR touchpoint_offer_type_wip = 'Event Registration'
        THEN 'Event Registration'
      WHEN touchpoint_offer_type_wip = 'Online Content'
        AND bizible_form_url_clean LIKE '%ebook%'
        THEN 'eBook'
      WHEN (touchpoint_offer_type_wip = 'Online Content'
        AND bizible_form_url_clean LIKE '%webcast%')
        OR bizible_form_url_clean IN ('about.gitlab.com/seventeen',
                                      'about.gitlab.com/sixteen',
                                      'about.gitlab.com/eighteen',
                                      'about.gitlab.com/nineteen',
                                      'about.gitlab.com/fr-fr/seventeen',
                                      'about.gitlab.com/de-de/seventeen',
                                      'about.gitlab.com/es/seventeen')
        THEN 'Webcast'
      WHEN touchpoint_offer_type_wip = 'Online Content'
        AND bizible_form_url_clean LIKE '%demo%'
        THEN 'Demo'
      WHEN touchpoint_offer_type_wip = 'Online Content'
        THEN 'Other Online Content'
      ELSE touchpoint_offer_type_wip
    END AS touchpoint_offer_type,
    CASE
      WHEN bizible_marketing_channel = 'Event'
        OR touchpoint_offer_type = 'Event Registration'
          OR touchpoint_offer_type = 'Webcast'
          OR touchpoint_offer_type = 'Workshop'
        THEN 'Events'
      WHEN touchpoint_offer_type_wip = 'Online Content'
        THEN 'Online Content'
      WHEN touchpoint_offer_type IN ('Content Syndication','Newsletter/Release/Blog Sign-Up','Blog','Resources')
        THEN 'Online Content'
      WHEN touchpoint_offer_type = 'Sign Up Form'
        THEN 'Sign Up Form'
      WHEN touchpoint_offer_type IN ('GitLab Dot Com Trial', 'GitLab Self-Managed Trial')
        THEN 'Trials'
      WHEN touchpoint_offer_type = 'Web Chat'
        THEN 'Web Chat'
      WHEN touchpoint_offer_type = 'Contact Sales Form'
        THEN 'Contact Sales Form'
      WHEN touchpoint_offer_type = 'Partner Sourced'
        THEN 'Partner Sourced'
      WHEN touchpoint_offer_type = 'Lead Gen Form'
        THEN 'Lead Gen Form'
      ELSE 'Other'
    END AS touchpoint_offer_type_grouped
  FROM bizible_person_touchpoint_base
)
SELECT
      *,
      '@rkohnke'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2024-01-31'::DATE        AS model_created_date,
      '2024-12-18'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common_prep.prep_bizible_marketing_channel_path as
WITH source_data AS (
    SELECT *
    FROM "PROD".common_mapping.map_bizible_marketing_channel_path
    WHERE bizible_marketing_channel_path_name_grouped IS NOT NULL
), unioned AS (
    SELECT DISTINCT
      md5(cast(coalesce(cast(bizible_marketing_channel_path_name_grouped as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))  AS dim_bizible_marketing_channel_path_id,
      bizible_marketing_channel_path_name_grouped                     AS bizible_marketing_channel_path_name
    FROM source_data
    UNION ALL
    SELECT
      MD5('-1')                                   AS dim_bizible_marketing_channel_path_id,
      'Missing bizible_marketing_channel_path_name'       AS bizible_marketing_channel_path_name
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@mcooperDD'::VARCHAR       AS updated_by,
      '2020-12-18'::DATE        AS model_created_date,
      '2021-02-26'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM unioned;

CREATE TABLE "PROD".common_prep.prep_sales_territory as
WITH source_data AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_sfdc_account
    WHERE dim_parent_sales_territory_name_source IS NOT NULL
), unioned AS (
    SELECT DISTINCT
      md5(cast(coalesce(cast(dim_parent_sales_territory_name_source as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))  AS dim_sales_territory_id,
      dim_parent_sales_territory_name_source                     AS sales_territory_name
    FROM source_data
    UNION ALL
    SELECT
      MD5('-1')                                   AS dim_sales_territory_id,
      'Missing sales_territory_name'       AS sales_territory_name
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@lisvinueza'::VARCHAR       AS updated_by,
      '2020-12-18'::DATE        AS model_created_date,
      '2023-05-21'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM unioned;

CREATE TABLE "PROD".common_prep.prep_bizible_touchpoint_keystone as
WITH parse_keystone AS (
    SELECT *
    FROM "PREP".gitlab_data_yaml.content_keystone_source,
), union_types AS (
    SELECT
        content_name,
        gitlab_epic,
        gtm,
        type,
        url_slug,
        'form_urls' AS join_string_type,
        flattened_parsed_keystone.value::VARCHAR AS join_string
    FROM parse_keystone,
        LATERAL FLATTEN(input => parse_keystone.full_value:form_urls) flattened_parsed_keystone
    UNION ALL
    SELECT
        content_name,
        gitlab_epic,
        gtm,
        type,
        url_slug,
        'landing_page_url' AS join_string_type,
        flattened_parsed_keystone.value::VARCHAR AS join_string
    FROM parse_keystone,
        LATERAL FLATTEN(input => parse_keystone.full_value:landing_page_urls) flattened_parsed_keystone
    UNION ALL
    SELECT
        content_name,
        gitlab_epic,
        gtm,
        type,
        url_slug,
        'pathfactory_pages' AS join_string_type,
        flattened_parsed_keystone.value::VARCHAR AS join_string
    FROM parse_keystone,
        LATERAL FLATTEN(input => parse_keystone.full_value:pathfactory_pages) flattened_parsed_keystone
    UNION ALL
    SELECT
        content_name,
        gitlab_epic,
        gtm,
        type,
        url_slug,
        'utm_campaign_name' AS join_string_type,
        flattened_parsed_keystone.value::VARCHAR AS join_string
    FROM parse_keystone,
        LATERAL FLATTEN(input => parse_keystone.full_value:utm_campaign_name) flattened_parsed_keystone
    UNION ALL
    SELECT
        content_name,
        gitlab_epic,
        gtm,
        type,
        url_slug,
        'sfdc_campaigns' AS join_string_type,
        flattened_parsed_keystone.value::VARCHAR AS join_string
    FROM parse_keystone,
        LATERAL FLATTEN(input => parse_keystone.full_value:sfdc_campaigns) flattened_parsed_keystone
), prep_crm_unioned_touchpoint AS (
    SELECT
        touchpoint_id AS dim_crm_touchpoint_id,
        campaign_id AS dim_campaign_id,
        bizible_form_url,
        bizible_landing_page,
        PARSE_URL(bizible_landing_page_raw)['parameters']['utm_campaign']::VARCHAR    AS bizible_landing_page_utm_campaign,
        PARSE_URL(bizible_form_url_raw)['parameters']['utm_campaign']::VARCHAR        AS bizible_form_page_utm_campaign,
        COALESCE(bizible_landing_page_utm_campaign, bizible_form_page_utm_campaign)   AS utm_campaign
    FROM "PROD".common_prep.prep_crm_attribution_touchpoint
    UNION ALL
    SELECT
        touchpoint_id AS dim_crm_touchpoint_id,
        campaign_id AS dim_campaign_id,
        bizible_form_url,
        bizible_landing_page,
        PARSE_URL(bizible_landing_page_raw)['parameters']['utm_campaign']::VARCHAR    AS bizible_landing_page_utm_campaign,
        PARSE_URL(bizible_form_url_raw)['parameters']['utm_campaign']::VARCHAR        AS bizible_form_page_utm_campaign,
        COALESCE(bizible_landing_page_utm_campaign, bizible_form_page_utm_campaign)   AS utm_campaign
    FROM "PROD".common_prep.prep_crm_touchpoint
 ), combined_model AS (
    SELECT
        prep_crm_unioned_touchpoint.dim_crm_touchpoint_id,
        COALESCE(
            sfdc_campaigns.content_name,
            utm_campaigns.content_name,
            form_urls.content_name,
            landing_pages.content_name,
            pathfactory_landing.content_name
        ) AS content_name,
        COALESCE(
            sfdc_campaigns.gitlab_epic,
            utm_campaigns.gitlab_epic,
            form_urls.gitlab_epic,
            landing_pages.gitlab_epic,
            pathfactory_landing.gitlab_epic
        ) AS gitlab_epic,
        COALESCE(
            sfdc_campaigns.gtm,
            utm_campaigns.gtm,
            form_urls.gtm,
            landing_pages.gtm,
            pathfactory_landing.gtm
        ) AS gtm,
        COALESCE(
            sfdc_campaigns.url_slug,
            utm_campaigns.url_slug,
            form_urls.url_slug,
            landing_pages.url_slug,
            pathfactory_landing.url_slug
        ) AS url_slug,
        COALESCE(
            sfdc_campaigns.type,
            utm_campaigns.type,
            form_urls.type,
            landing_pages.type,
            pathfactory_landing.type
        ) AS type
    FROM prep_crm_unioned_touchpoint
    LEFT JOIN union_types sfdc_campaigns
        ON sfdc_campaigns.join_string_type = 'sfdc_campaigns'
        AND prep_crm_unioned_touchpoint.dim_campaign_id = sfdc_campaigns.join_string
    LEFT JOIN union_types utm_campaigns
        ON utm_campaigns.join_string_type = 'utm_campaign_name'
        AND prep_crm_unioned_touchpoint.utm_campaign = utm_campaigns.join_string
    LEFT JOIN union_types form_urls
        ON form_urls.join_string_type = 'form_urls'
        AND prep_crm_unioned_touchpoint.bizible_form_url = form_urls.join_string
    LEFT JOIN union_types landing_pages
        ON landing_pages.join_string_type = 'landing_page_url'
        AND prep_crm_unioned_touchpoint.bizible_landing_page = landing_pages.join_string
    LEFT JOIN union_types pathfactory_landing
        ON pathfactory_landing.join_string_type = 'pathfactory_pages'
        AND prep_crm_unioned_touchpoint.bizible_landing_page = pathfactory_landing.join_string
    LEFT JOIN union_types pathfactory_form
        ON pathfactory_form.join_string_type = 'pathfactory_pages'
        AND prep_crm_unioned_touchpoint.bizible_form_url = pathfactory_form.join_string
), final AS (
    SELECT *
    FROM combined_model
    WHERE content_name IS NOT NULL
)
SELECT *
FROM final;

CREATE TABLE "PROD".common_prep.prep_industry as
WITH source_data AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_sfdc_account
    WHERE dim_account_industry_name_source IS NOT NULL
), unioned AS (
    SELECT DISTINCT
      md5(cast(coalesce(cast(dim_account_industry_name_source as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))  AS dim_industry_id,
      dim_account_industry_name_source                     AS industry_name
    FROM source_data
    UNION ALL
    SELECT
      MD5('-1')                                   AS dim_industry_id,
      'Missing industry_name'       AS industry_name
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@mcooperDD'::VARCHAR       AS updated_by,
      '2020-12-18'::DATE        AS model_created_date,
      '2021-02-02'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM unioned;

CREATE TABLE "PROD".restricted_safe_common_prep.prep_crm_account as
WITH map_merged_crm_account AS (
    SELECT *
    FROM "PROD".restricted_safe_common_mapping.map_merged_crm_account
), prep_crm_person AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_person
), sfdc_user_roles_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_user_roles_source
), dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), crm_user AS (
    SELECT *
    FROM
        "PROD".common_prep.prep_crm_user
), sfdc_account AS (
    SELECT
        *
    FROM
        "PREP".sfdc.sfdc_account_source
    WHERE account_id IS NOT NULL
), sfdc_users AS (
    SELECT
        *
    FROM
      "PREP".sfdc.sfdc_users_source
), sfdc_record_type AS (
    SELECT *
    FROM "PROD".legacy.sfdc_record_type
), pte_scores AS (
    SELECT
      crm_account_id                                                                                           AS account_id,
      score                                                                                                    AS score,
      decile                                                                                                   AS decile,
      score_group                                                                                              AS score_group,
      MIN(score_date)                                                                                          AS valid_from,
      COALESCE(LEAD(valid_from) OVER (PARTITION BY crm_account_id ORDER BY valid_from), DATEADD('day',1,CURRENT_DATE())) AS valid_to,
      CASE
        WHEN ROW_NUMBER() OVER (PARTITION BY crm_account_id ORDER BY valid_from DESC) = 1
          THEN TRUE
        ELSE FALSE
      END                                                                                                      AS is_current
    FROM "PREP".data_science.pte_scores_source
    group by 1,2,3,4
    ORDER BY valid_from, valid_to
), ptc_scores AS (
    SELECT
      crm_account_id                                                                                           AS account_id,
      score                                                                                                    AS score,
      decile                                                                                                   AS decile,
      score_group                                                                                              AS score_group,
      MIN(score_date)                                                                                          AS valid_from,
      COALESCE(LEAD(valid_from) OVER (PARTITION BY crm_account_id ORDER BY valid_from), DATEADD('day',1,CURRENT_DATE())) AS valid_to,
      CASE
        WHEN ROW_NUMBER() OVER (PARTITION BY crm_account_id ORDER BY valid_from DESC) = 1
          THEN TRUE
        ELSE FALSE
      END                                                                                                      AS is_current
    FROM "PREP".data_science.ptc_scores_source
    group by 1,2,3,4
    ORDER BY valid_from, valid_to
), current_fiscal_year AS (
    SELECT fiscal_year
    FROM dim_date
    WHERE date_actual = CURRENT_DATE()
), final AS (
    SELECT
      --crm account information
      --primary key
      sfdc_account.account_id                                             AS dim_crm_account_id,
      --surrogate keys
      sfdc_account.ultimate_parent_account_id                             AS dim_parent_crm_account_id,
      sfdc_account.owner_id                                               AS dim_crm_user_id,
      map_merged_crm_account.dim_crm_account_id                           AS merged_to_account_id,
      sfdc_account.record_type_id                                         AS record_type_id,
      account_owner.user_id                                               AS crm_account_owner_id,
      proposed_account_owner.user_id                                      AS proposed_crm_account_owner_id,
      technical_account_manager.user_id                                   AS technical_account_manager_id,
      sfdc_account.executive_sponsor_id,
      sfdc_account.master_record_id,
      prep_crm_person.dim_crm_person_id                                   AS dim_crm_person_primary_contact_id,
      --account people
      account_owner.name                                                  AS account_owner,
      proposed_account_owner.name                                         AS proposed_crm_account_owner,
      technical_account_manager.name                                      AS technical_account_manager,
      -- account owner fields
      account_owner.user_segment                                          AS crm_account_owner_sales_segment,
      account_owner.user_geo                                              AS crm_account_owner_geo,
      account_owner.user_region                                           AS crm_account_owner_region,
      account_owner.user_area                                             AS crm_account_owner_area,
      account_owner.user_segment_geo_region_area                          AS crm_account_owner_sales_segment_geo_region_area,
      account_owner.title                                                 AS crm_account_owner_title,
      sfdc_user_roles_source.name                                         AS crm_account_owner_role,
      ----ultimate parent crm account info
       sfdc_account.ultimate_parent_account_name                          AS parent_crm_account_name,
      --technical account manager attributes
      technical_account_manager.manager_name AS tam_manager,
      --executive sponsor field
      executive_sponsor.name AS executive_sponsor,
      --D&B Fields
      sfdc_account.dnb_match_confidence_score,
      sfdc_account.dnb_match_grade,
      sfdc_account.dnb_connect_company_profile_id,
      sfdc_account.dnb_duns,
      sfdc_account.dnb_global_ultimate_duns,
      sfdc_account.dnb_domestic_ultimate_duns,
      sfdc_account.dnb_exclude_company,
      --6 sense fields
      sfdc_account.has_six_sense_6_qa,
      sfdc_account.risk_rate_guid,
      sfdc_account.six_sense_account_profile_fit,
      sfdc_account.six_sense_account_reach_score,
      sfdc_account.six_sense_account_profile_score,
      sfdc_account.six_sense_account_buying_stage,
      sfdc_account.six_sense_account_numerical_reach_score,
      sfdc_account.six_sense_account_update_date,
      sfdc_account.six_sense_account_6_qa_end_date,
      sfdc_account.six_sense_account_6_qa_age_days,
      sfdc_account.six_sense_account_6_qa_start_date,
      sfdc_account.six_sense_account_intent_score,
      sfdc_account.six_sense_segments,
       --Qualified Fields
      sfdc_account.qualified_days_since_last_activity,
      sfdc_account.qualified_signals_active_session_time,
      sfdc_account.qualified_signals_bot_conversation_count,
      sfdc_account.qualified_condition,
      sfdc_account.qualified_score,
      sfdc_account.qualified_trend,
      sfdc_account.qualified_meetings_booked,
      sfdc_account.qualified_signals_rep_conversation_count,
      sfdc_account.qualified_signals_research_state,
      sfdc_account.qualified_signals_research_score,
      sfdc_account.qualified_signals_session_count,
      sfdc_account.qualified_visitors_count,
      --descriptive attributes
      sfdc_account.account_name                                           AS crm_account_name,
      sfdc_account.account_sales_segment                                  AS parent_crm_account_sales_segment,
      -- Add legacy field to support public company metrics reporting: https://gitlab.com/gitlab-data/analytics/-/issues/20290
      sfdc_account.account_sales_segment_legacy                           AS parent_crm_account_sales_segment_legacy,
      sfdc_account.account_geo                                            AS parent_crm_account_geo,
      sfdc_account.account_region                                         AS parent_crm_account_region,
      sfdc_account.account_area                                           AS parent_crm_account_area,
      sfdc_account.account_territory                                      AS parent_crm_account_territory,
      sfdc_account.account_business_unit                                  AS parent_crm_account_business_unit,
      sfdc_account.account_role_type                                      AS parent_crm_account_role_type,
        CONCAT(
               UPPER(account_owner_role),
               '-',
               current_fiscal_year.fiscal_year
               )                                                                                                                     AS dim_crm_parent_account_hierarchy_sk,
      sfdc_account.account_max_family_employee                            AS parent_crm_account_max_family_employee,
      sfdc_account.account_upa_country                                    AS parent_crm_account_upa_country,
      sfdc_account.account_upa_country_name                               AS parent_crm_account_upa_country_name,
      sfdc_account.account_upa_state                                      AS parent_crm_account_upa_state,
      sfdc_account.account_upa_city                                       AS parent_crm_account_upa_city,
      sfdc_account.account_upa_street                                     AS parent_crm_account_upa_street,
      sfdc_account.account_upa_postal_code                                AS parent_crm_account_upa_postal_code,
      sfdc_account.account_employee_count                                 AS crm_account_employee_count,
      sfdc_account.parent_account_industry_hierarchy                      AS parent_crm_account_industry,
      sfdc_account.gtm_strategy                                           AS crm_account_gtm_strategy,
      CASE
        WHEN sfdc_account.account_sales_segment IN ('Large', 'PubSec') THEN 'Large'
        WHEN sfdc_account.account_sales_segment = 'Unknown' THEN 'SMB'
        ELSE sfdc_account.account_sales_segment
      END                                                                 AS parent_crm_account_sales_segment_grouped,
      CASE
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_geo) = 'AMER' AND UPPER(sfdc_account.account_region) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_geo) IN ('AMER', 'LATAM') AND UPPER(sfdc_account.account_region) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_geo) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN sfdc_account.account_geo
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_region) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_geo) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(sfdc_account.account_sales_segment) NOT IN ('LARGE', 'PUBSEC')
    THEN sfdc_account.account_sales_segment
  ELSE 'Missing segment_region_grouped'
END AS parent_crm_account_segment_region_stamped_grouped,
      CASE
        WHEN LOWER(sfdc_account.gtm_strategy) IN ('account centric', 'account based - net new', 'account based - expand') THEN 'Focus Account'
        ELSE 'Non - Focus Account'
      END                                                                 AS crm_account_focus_account,
      sfdc_account.account_owner_user_segment                             AS crm_account_owner_user_segment,
      sfdc_account.billing_country                                        AS crm_account_billing_country,
      sfdc_account.billing_country_code                                   AS crm_account_billing_country_code,
      sfdc_account.account_type                                           AS crm_account_type,
      sfdc_account.industry                                               AS crm_account_industry,
      sfdc_account.sub_industry                                           AS crm_account_sub_industry,
      sfdc_account.account_owner                                          AS crm_account_owner,
      CASE
         WHEN sfdc_account.account_max_family_employee > 2000 THEN 'Employees > 2K'
         WHEN sfdc_account.account_max_family_employee <= 2000 AND sfdc_account.account_max_family_employee > 1500 THEN 'Employees > 1.5K'
         WHEN sfdc_account.account_max_family_employee <= 1500 AND sfdc_account.account_max_family_employee > 1000  THEN 'Employees > 1K'
         ELSE 'Employees < 1K'
      END                                                                 AS crm_account_employee_count_band,
      sfdc_account.partner_vat_tax_id,
      sfdc_account.account_manager,
      sfdc_account.crm_business_dev_rep_id,
      sfdc_account.dedicated_service_engineer,
      sfdc_account.account_tier,
      sfdc_account.account_tier_notes,
      sfdc_account.license_utilization,
      sfdc_account.support_level,
      sfdc_account.named_account,
      sfdc_account.billing_postal_code,
      sfdc_account.partner_type,
      sfdc_account.partner_status,
      sfdc_account.gitlab_customer_success_project,
      sfdc_account.demandbase_account_list,
      sfdc_account.demandbase_intent,
      sfdc_account.demandbase_page_views,
      sfdc_account.demandbase_score,
      sfdc_account.demandbase_sessions,
      sfdc_account.demandbase_trending_offsite_intent,
      sfdc_account.demandbase_trending_onsite_engagement,
      sfdc_account.account_domains,
      sfdc_account.account_domain_1,
      sfdc_account.account_domain_2,
      sfdc_account.is_locally_managed_account,
      sfdc_account.is_strategic_account,
      sfdc_account.partner_track,
      sfdc_account.partners_partner_type,
      sfdc_account.gitlab_partner_program,
      sfdc_account.zoom_info_company_name,
      sfdc_account.zoom_info_company_revenue,
      sfdc_account.zoom_info_company_employee_count,
      sfdc_account.zoom_info_company_industry,
      sfdc_account.zoom_info_company_city,
      sfdc_account.zoom_info_company_state_province,
      sfdc_account.zoom_info_company_country,
      sfdc_account.account_phone,
      sfdc_account.zoominfo_account_phone,
      sfdc_account.abm_tier,
      sfdc_account.health_number,
      sfdc_account.health_score_color,
      sfdc_account.partner_account_iban_number,
      sfdc_account.gitlab_com_user,
      sfdc_account.zi_technologies                                        AS crm_account_zi_technologies,
      sfdc_account.zoom_info_website                                      AS crm_account_zoom_info_website,
      sfdc_account.zoom_info_company_other_domains                        AS crm_account_zoom_info_company_other_domains,
      sfdc_account.zoom_info_dozisf_zi_id                                 AS crm_account_zoom_info_dozisf_zi_id,
      sfdc_account.zoom_info_parent_company_zi_id                         AS crm_account_zoom_info_parent_company_zi_id,
      sfdc_account.zoom_info_parent_company_name                          AS crm_account_zoom_info_parent_company_name,
      sfdc_account.zoom_info_ultimate_parent_company_zi_id                AS crm_account_zoom_info_ultimate_parent_company_zi_id,
      sfdc_account.zoom_info_ultimate_parent_company_name                 AS crm_account_zoom_info_ultimate_parent_company_name,
      sfdc_account.zoom_info_number_of_developers                         AS crm_account_zoom_info_number_of_developers,
      sfdc_account.zoom_info_total_funding                                AS crm_account_zoom_info_total_funding,
      sfdc_account.forbes_2000_rank,
      sfdc_account.parent_account_industry_hierarchy,
      sfdc_account.crm_sales_dev_rep_id,
      sfdc_account.admin_manual_source_number_of_employees,
      sfdc_account.admin_manual_source_account_address,
      sfdc_account.eoa_sentiment,
      sfdc_account.gs_health_user_engagement,
      sfdc_account.gs_health_cd,
      sfdc_account.gs_health_devsecops,
      sfdc_account.gs_health_ci,
      sfdc_account.gs_health_scm,
      sfdc_account.risk_impact,
      sfdc_account.risk_reason,
      sfdc_account.last_timeline_at_risk_update,
      sfdc_account.last_at_risk_update_comments,
      sfdc_account.bdr_prospecting_status,
      sfdc_account.gs_health_csm_sentiment,
      sfdc_account.bdr_next_steps,
      sfdc_account.bdr_account_research,
      sfdc_account.bdr_account_strategy,
      sfdc_account.account_bdr_assigned_user_role,
      sfdc_account.gs_csm_compensation_pool,
      sfdc_account.groove_notes,
      sfdc_account.groove_engagement_status,
      sfdc_account.groove_inferred_status,
      sfdc_account.compensation_target_account,
      sfdc_account.pubsec_type,
      --degenerative dimensions
      sfdc_account.is_sdr_target_account,
      sfdc_account.is_focus_partner,
      IFF(sfdc_record_type.record_type_label = 'Partner'
          AND sfdc_account.partner_type IN ('Alliance', 'Channel')
          AND sfdc_account.partner_status = 'Authorized',
          TRUE, FALSE)                                                    AS is_reseller,
      sfdc_account.is_jihu_account                                        AS is_jihu_account,
      sfdc_account.is_first_order_available,
      sfdc_account.is_key_account                                         AS is_key_account,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies,'ARE_USED: Jenkins')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_jenkins_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: SVN')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_svn_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Tortoise SVN')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_tortoise_svn_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Google Cloud Platform')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_gcp_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Atlassian')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_atlassian_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: GitHub')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_github_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: GitHub Enterprise')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_github_enterprise_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: AWS')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_aws_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Kubernetes')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_kubernetes_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Apache Subversion')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_apache_subversion_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Apache Subversion (SVN)')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_apache_subversion_svn_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Hashicorp')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_hashicorp_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Amazon AWS CloudTrail')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_aws_cloud_trail_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: CircleCI')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_circle_ci_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: BitBucket')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_bit_bucket_present,
      sfdc_account.is_excluded_from_zoom_info_enrich,
      --dates
  TO_NUMBER(TO_CHAR(sfdc_account.created_date::DATE,'YYYYMMDD'),'99999999')
                      AS crm_account_created_date_id,
      sfdc_account.created_date                                           AS crm_account_created_date,
  TO_NUMBER(TO_CHAR(sfdc_account.abm_tier_1_date::DATE,'YYYYMMDD'),'99999999')
                   AS abm_tier_1_date_id,
      sfdc_account.abm_tier_1_date,
  TO_NUMBER(TO_CHAR(sfdc_account.abm_tier_2_date::DATE,'YYYYMMDD'),'99999999')
                   AS abm_tier_2_date_id,
      sfdc_account.abm_tier_2_date,
  TO_NUMBER(TO_CHAR(sfdc_account.abm_tier_3_date::DATE,'YYYYMMDD'),'99999999')
                   AS abm_tier_3_date_id,
      sfdc_account.abm_tier_3_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gtm_acceleration_date::DATE,'YYYYMMDD'),'99999999')
             AS gtm_acceleration_date_id,
      sfdc_account.gtm_acceleration_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gtm_account_based_date::DATE,'YYYYMMDD'),'99999999')
            AS gtm_account_based_date_id,
      sfdc_account.gtm_account_based_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gtm_account_centric_date::DATE,'YYYYMMDD'),'99999999')
          AS gtm_account_centric_date_id,
      sfdc_account.gtm_account_centric_date,
  TO_NUMBER(TO_CHAR(sfdc_account.partners_signed_contract_date::DATE,'YYYYMMDD'),'99999999')
     AS partners_signed_contract_date_id,
      CAST(sfdc_account.partners_signed_contract_date AS date)            AS partners_signed_contract_date,
  TO_NUMBER(TO_CHAR(sfdc_account.technical_account_manager_date::DATE,'YYYYMMDD'),'99999999')
    AS technical_account_manager_date_id,
      sfdc_account.technical_account_manager_date,
  TO_NUMBER(TO_CHAR(sfdc_account.customer_since_date::DATE,'YYYYMMDD'),'99999999')
               AS customer_since_date_id,
      sfdc_account.customer_since_date,
  TO_NUMBER(TO_CHAR(sfdc_account.next_renewal_date::DATE,'YYYYMMDD'),'99999999')
                 AS next_renewal_date_id,
      sfdc_account.next_renewal_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gs_first_value_date::DATE,'YYYYMMDD'),'99999999')
               AS gs_first_value_date_id,
      sfdc_account.gs_first_value_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gs_last_csm_activity_date::DATE,'YYYYMMDD'),'99999999')
         AS gs_last_csm_activity_date_id,
      sfdc_account.gs_last_csm_activity_date,
      sfdc_account.bdr_recycle_date,
      sfdc_account.actively_working_start_date,
      --measures
      sfdc_account.count_active_subscription_charges,
      sfdc_account.count_active_subscriptions,
      sfdc_account.count_billing_accounts,
      sfdc_account.count_licensed_users,
      sfdc_account.count_of_new_business_won_opportunities,
      sfdc_account.count_open_renewal_opportunities,
      sfdc_account.count_opportunities,
      sfdc_account.count_products_purchased,
      sfdc_account.count_won_opportunities,
      sfdc_account.count_concurrent_ee_subscriptions,
      sfdc_account.count_ce_instances,
      sfdc_account.count_active_ce_users,
      sfdc_account.count_open_opportunities,
      sfdc_account.count_using_ce,
      sfdc_account.carr_this_account,
      sfdc_account.carr_account_family,
      sfdc_account.potential_users,
      sfdc_account.number_of_licenses_this_account,
      sfdc_account.decision_maker_count_linkedin,
      sfdc_account.number_of_employees,
      crm_user.user_role_type                                             AS user_role_type,
      crm_user.user_role_name                                             AS owner_role,
      sfdc_account.lam                                                    AS parent_crm_account_lam,
      sfdc_account.lam_dev_count                                          AS parent_crm_account_lam_dev_count,
      -- PtC and PtE
      pte_scores.score                                               AS pte_score,
      pte_scores.decile                                              AS pte_decile,
      pte_scores.score_group                                         AS pte_score_group,
      ptc_scores.score                                               AS ptc_score,
      ptc_scores.decile                                              AS ptc_decile,
      ptc_scores.score_group                                         AS ptc_score_group,
      sfdc_account.ptp_insights                                      AS ptp_insights,
      sfdc_account.ptp_score_value                                   AS ptp_score_value,
      sfdc_account.ptp_score                                         AS ptp_score,
      --metadata
      sfdc_account.created_by_id,
      created_by.name                                                     AS created_by_name,
      sfdc_account.last_modified_by_id,
      last_modified_by.name                                               AS last_modified_by_name,
  TO_NUMBER(TO_CHAR(sfdc_account.last_modified_date::DATE,'YYYYMMDD'),'99999999')
                AS last_modified_date_id,
      sfdc_account.last_modified_date,
  TO_NUMBER(TO_CHAR(sfdc_account.last_activity_date::DATE,'YYYYMMDD'),'99999999')
                AS last_activity_date_id,
      sfdc_account.last_activity_date,
      sfdc_account.is_deleted
    FROM sfdc_account
    LEFT JOIN map_merged_crm_account
      ON sfdc_account.account_id = map_merged_crm_account.sfdc_account_id
    LEFT JOIN sfdc_record_type
      ON sfdc_account.record_type_id = sfdc_record_type.record_type_id
    LEFT JOIN prep_crm_person
      ON sfdc_account.primary_contact_id = prep_crm_person.sfdc_record_id
    LEFT JOIN pte_scores
      ON sfdc_account.account_id = pte_scores.account_id
        AND pte_scores.is_current = TRUE
    LEFT JOIN ptc_scores
      ON sfdc_account.account_id = ptc_scores.account_id
        AND ptc_scores.is_current = TRUE
    LEFT OUTER JOIN sfdc_users AS technical_account_manager
      ON sfdc_account.technical_account_manager_id = technical_account_manager.user_id
    LEFT JOIN sfdc_users AS account_owner
      ON sfdc_account.owner_id = account_owner.user_id
    LEFT JOIN sfdc_users AS proposed_account_owner
      ON proposed_account_owner.user_id = sfdc_account.proposed_account_owner
    LEFT JOIN sfdc_users AS executive_sponsor
      ON executive_sponsor.user_id = sfdc_account.executive_sponsor_id
    LEFT JOIN sfdc_users created_by
      ON sfdc_account.created_by_id = created_by.user_id
    LEFT JOIN sfdc_users AS last_modified_by
      ON sfdc_account.last_modified_by_id = last_modified_by.user_id
    LEFT JOIN crm_user
      ON sfdc_account.owner_id = crm_user.dim_crm_user_id
     LEFT JOIN sfdc_user_roles_source
      ON account_owner.user_role_id = sfdc_user_roles_source.id
     LEFT JOIN current_fiscal_year
)
SELECT
      *,
      '@msendal'::VARCHAR       AS created_by,
      '@jonglee1218'::VARCHAR       AS updated_by,
      '2020-06-01'::DATE        AS model_created_date,
      '2024-10-14'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".restricted_safe_common_prep.prep_charge_mrr as
WITH prep_date AS (
    SELECT *
    FROM "PROD".common_prep.prep_date
), prep_charge AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_charge
)
, mrr AS (
    SELECT
      prep_date.date_id,
      "SUBSCRIPTION_NAME",
  "SUBSCRIPTION_NAME_SLUGIFY",
  "SUBSCRIPTION_VERSION",
  "SUBSCRIPTION_CREATED_BY_ID",
  "RATE_PLAN_CHARGE_NUMBER",
  "RATE_PLAN_CHARGE_VERSION",
  "RATE_PLAN_CHARGE_SEGMENT",
  "DIM_CHARGE_ID",
  "DIM_PRODUCT_DETAIL_ID",
  "DIM_AMENDMENT_ID_CHARGE",
  "DIM_SUBSCRIPTION_ID",
  "DIM_BILLING_ACCOUNT_ID",
  "DIM_CRM_ACCOUNT_ID",
  "DIM_PARENT_CRM_ACCOUNT_ID",
  "DIM_ORDER_ID",
  "EFFECTIVE_START_DATE_ID",
  "EFFECTIVE_END_DATE_ID",
  "SUBSCRIPTION_STATUS",
  "RATE_PLAN_NAME",
  "RATE_PLAN_CHARGE_NAME",
  "RATE_PLAN_CHARGE_DESCRIPTION",
  "IS_LAST_SEGMENT",
  "DISCOUNT_LEVEL",
  "CHARGE_TYPE",
  "RATE_PLAN_CHARGE_AMENDEMENT_TYPE",
  "UNIT_OF_MEASURE",
  "IS_PAID_IN_FULL",
  "MONTHS_OF_FUTURE_BILLINGS",
  "IS_INCLUDED_IN_ARR_CALC",
  "SUBSCRIPTION_START_DATE",
  "SUBSCRIPTION_END_DATE",
  "EFFECTIVE_START_DATE",
  "EFFECTIVE_END_DATE",
  "EFFECTIVE_START_MONTH",
  "EFFECTIVE_END_MONTH",
  "CHARGED_THROUGH_DATE",
  "CHARGE_CREATED_DATE",
  "CHARGE_UPDATED_DATE",
  "CHARGE_TERM",
  "BILLING_PERIOD",
  "SPECIFIC_BILLING_PERIOD",
  "MRR",
  "PREVIOUS_MRR_CALC",
  "PREVIOUS_MRR",
  "DELTA_MRR_CALC",
  "DELTA_MRR",
  "DELTA_MRC",
  "ARR",
  "PREVIOUS_ARR",
  "DELTA_ARC",
  "DELTA_ARR",
  "LIST_PRICE",
  "EXTENDED_LIST_PRICE",
  "QUANTITY",
  "PREVIOUS_QUANTITY_CALC",
  "PREVIOUS_QUANTITY",
  "DELTA_QUANTITY_CALC",
  "DELTA_QUANTITY",
  "TCV",
  "DELTA_TCV",
  "ESTIMATED_TOTAL_FUTURE_BILLINGS",
  "IS_MANUAL_CHARGE",
  "TYPE_OF_ARR_CHANGE"
    FROM prep_charge
    INNER JOIN prep_date
      ON prep_charge.effective_start_month = prep_date.date_actual
    WHERE prep_charge.subscription_status NOT IN ('Draft')
      AND prep_charge.charge_type = 'Recurring'
      /* This excludes Education customers (charge name EDU or OSS) with free subscriptions.
         Pull in seats from Paid EDU Plans with no ARR */
      AND (prep_charge.mrr != 0 OR LOWER(prep_charge.rate_plan_charge_name) = 'max enrollment')
      AND prep_charge.is_included_in_arr_calc = TRUE
)
SELECT
      *,
      '@jpeguero'::VARCHAR       AS created_by,
      '@jpeguero'::VARCHAR       AS updated_by,
      '2023-08-14'::DATE        AS model_created_date,
      '2023-08-14'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM mrr;

CREATE TABLE "PREP".sfdc.sfdc_lead_source as
WITH source AS (
  SELECT *
  FROM "RAW".salesforce_v2_stitch.lead
),
renamed AS (
  SELECT
    --id
    id AS lead_id,
    name AS lead_name,
    firstname AS lead_first_name,
    lastname AS lead_last_name,
    email AS lead_email,
    SPLIT_PART(email, '@', 2) AS email_domain,
    CASE
  WHEN leadsource IN ('DiscoverOrg', 'Zoominfo', 'Purchased List', 'GitLab.com') THEN 'Bulk load or list purchase or spam impacted'
  WHEN TRIM(split_part(email,'@',2)) IS NULL THEN 'Missing email domain'
  WHEN split_part(email,'@',2) LIKE ANY ('%yahoo%',
    '%rediff%',
    '%gmail%',
    '%hotmail%',
    '%outlook%',
    '%verizon.net%',
    '%live%',
    '%sbcglobal.net%',
    '%laposte%',
    '%yandex%',
    '%bk.ru%',
    '%inbox%',
    '%protonmail.%',
    '%posteo%',
    '%pm.me%',
    '%email.%',
    '%fastmail.%',
    '%att.net%',
    '%rocketmail%'
  )
  OR split_part(email,'@',2) IN ('qq.com',
    '163.com',
    'mail.ru',
    'googlemail.com',
    'yandex.ru',
    'protonmail.com',
    'icloud.com',
    't-mobile.com',
    'example.com',
    '126.com',
    'me.com',
    'web.de',
    'naver.com',
    'foxmail.com',
    'aol.com',
    'msn.com',
    'ya.ru',
    'ymail.com',
    'orange.fr',
    'free.fr',
    'comcast.net',
    'mac.com',
    'gitlab.com',
    'gitlab.localhost',
    'yahoo.co.uk',
    'ukr.net',
    'live.com',
    'gmx.de',
    'gmx.net',
    'wp.pl',
    'mail.com',
    'live.fr',
    'ancestry.com'
  )
  THEN 'Personal email domain'
  ELSE 'Business email domain'
END
 AS email_domain_type,
    --keys
    masterrecordid AS master_record_id,
    convertedaccountid AS converted_account_id,
    convertedcontactid AS converted_contact_id,
    convertedopportunityid AS converted_opportunity_id,
    ownerid AS owner_id,
    recordtypeid AS record_type_id,
    round_robin_id__c AS round_robin_id,
    instance_uuid__c AS instance_uuid,
    lean_data_matched_account__c AS lean_data_matched_account,
    --lead info
    isconverted AS is_converted,
    converteddate AS converted_date,
    title AS title,
    CASE
    WHEN LOWER(INSERT(INSERT(title, 1, 0, ''), LEN(title)+2, 0, '')) LIKE ANY (
      '%head% it%', '%vp%technology%','%director%technology%', '%director%engineer%',
      '%chief%information%', '%chief%technology%', '%president%technology%', '%vp%technology%',
      '%director%development%', '% it%director%', '%director%information%', '%director% it%',
      '%chief%engineer%', '%director%quality%', '%vp%engineer%', '%head%information%',
      '%vp%information%', '%president%information%', '%president%engineer%',
      '%president%development%', '%director% it%', '%engineer%director%', '%head%engineer%',
      '%engineer%head%', '%chief%software%', '%director%procurement%', '%procurement%director%',
      '%head%procurement%', '%procurement%head%', '%chief%procurement%', '%vp%procurement%',
      '%procurement%vp%', '%president%procurement%', '%procurement%president%', '%head%devops%'
      )
      OR ARRAY_CONTAINS('cio'::VARIANT, SPLIT(LOWER(title), ' '))
      OR ARRAY_CONTAINS('cio'::VARIANT, SPLIT(LOWER(title), ','))
      OR ARRAY_CONTAINS('cto'::VARIANT, SPLIT(LOWER(title), ' '))
      OR ARRAY_CONTAINS('cto'::VARIANT, SPLIT(LOWER(title), ','))
      OR ARRAY_CONTAINS('cfo'::VARIANT, SPLIT(LOWER(title), ' '))
      OR ARRAY_CONTAINS('cfo'::VARIANT, SPLIT(LOWER(title), ','))
        THEN 'IT Decision Maker'
    WHEN LOWER(INSERT(INSERT(title, 1, 0, ''), LEN(title)+2, 0, '')) LIKE ANY (
      '%manager%information%', '%manager%technology%', '%database%administrat%', '%manager%engineer%',
      '%engineer%manager%', '%information%manager%', '%technology%manager%', '%manager%development%',
      '%manager%quality%', '%manager%network%', '% it%manager%', '%manager% it%',
      '%manager%systems%', '%manager%application%', '%technical%manager%', '%manager%technical%',
      '%manager%infrastructure%', '%manager%implementation%', '%devops%manager%', '%manager%devops%',
      '%manager%software%', '%procurement%manager%', '%manager%procurement%'
      )
      AND NOT ARRAY_CONTAINS('project'::VARIANT, SPLIT(LOWER(title), ' '))
        THEN 'IT Manager'
    WHEN LOWER(INSERT(INSERT(title, 1, 0, ''), LEN(title)+2, 0, '')) LIKE ANY (
      '% it %', '% it,%', '%infrastructure%', '%engineer%',
      '%techno%', '%information%', '%developer%', '%database%',
      '%solutions architect%', '%system%', '%software%', '%technical lead%',
      '%programmer%', '%network administrat%', '%application%', '%procurement%',
      '%development%', '%tech%lead%'
      )
        THEN 'IT Individual Contributor'
    ELSE NULL
  END AS it_job_title_hierarchy,
    donotcall AS is_do_not_call,
    hasoptedoutofemail AS has_opted_out_email,
    emailbounceddate AS email_bounced_date,
    emailbouncedreason AS email_bounced_reason,
    behavior_score__c AS behavior_score,
    leadsource AS lead_source,
    lead_from__c AS lead_from,
    lead_source_type__c AS lead_source_type,
    lead_conversion_approval_status__c AS lead_conversion_approval_status,
    street AS street,
    city AS city,
    state AS state,
    statecode AS state_code,
    country AS country,
    countrycode AS country_code,
    postalcode AS postal_code,
    zi_company_country__c AS zoominfo_company_country,
    zi_contact_country__c AS zoominfo_contact_country,
    zi_company_state__c AS zoominfo_company_state,
    zi_contact_state__c AS zoominfo_contact_state,
    -- info
    requested_contact__c AS requested_contact,
    company AS company,
    dozisf__zoominfo_company_id__c AS zoominfo_company_id,
    zi_company_revenue__c AS zoominfo_company_revenue,
    zi_employee_count__c AS zoominfo_company_employee_count,
    zi_contact_city__c AS zoominfo_contact_city,
    zi_company_city__c AS zoominfo_company_city,
    zi_industry__c AS zoominfo_company_industry,
    zi_phone_number__c AS zoominfo_phone_number,
    zi_mobile_phone_number__c AS zoominfo_mobile_phone_number,
    zi_do_not_call_direct_phone__c AS zoominfo_do_not_call_direct_phone,
    zi_do_not_call_mobile_phone__c AS zoominfo_do_not_call_mobile_phone,
    buying_process_for_procuring_gitlab__c AS buying_process,
    core_check_in_notes__c AS core_check_in_notes,
    industry AS industry,
    largeaccount__c AS is_large_account,
    outreach_stage__c AS outreach_stage,
    sequence_step_number__c AS outreach_step_number,
    interested_in_gitlab_ee__c AS is_interested_gitlab_ee,
    interested_in_hosted_solution__c AS is_interested_in_hosted,
    lead_assigned_datetime__c::TIMESTAMP AS assigned_datetime,
    matched_account_top_list__c AS matched_account_top_list,
    matched_account_owner_role__c AS matched_account_owner_role,
    matched_account_sdr_assigned__c AS matched_account_sdr_assigned,
    matched_account_gtm_strategy__c AS matched_account_gtm_strategy,
    NULL AS matched_account_bdr_prospecting_status,
    engagio__matched_account_type__c AS matched_account_type,
    engagio__matched_account_owner_name__c AS matched_account_account_owner_name,
    mql_date__c AS marketo_qualified_lead_date,
    mql_datetime__c AS marketo_qualified_lead_datetime,
    mql_datetime_inferred__c AS mql_datetime_inferred,
    inquiry_datetime__c AS inquiry_datetime,
    inquiry_datetime_inferred__c AS inquiry_datetime_inferred,
    accepted_datetime__c AS accepted_datetime,
    qualifying_datetime__c AS qualifying_datetime,
    qualified_datetime__c AS qualified_datetime,
    unqualified_datetime__c AS unqualified_datetime,
    nurture_datetime__c AS initial_recycle_datetime,
    initial_nurture_datetime__c AS most_recent_recycle_datetime,
    bad_data_datetime__c AS bad_data_datetime,
    worked_date__c AS worked_datetime,
    web_portal_purchase_datetime__c AS web_portal_purchase_datetime,
    CASE WHEN LOWER(sales_segmentation__c) = 'smb' THEN 'SMB'
     WHEN LOWER(sales_segmentation__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(sales_segmentation__c) IS NULL THEN 'SMB'
     WHEN LOWER(sales_segmentation__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(sales_segmentation__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation__c) = 'lrg' THEN 'Large'
     WHEN LOWER(sales_segmentation__c) = 'jihu' THEN 'JiHu'
     WHEN sales_segmentation__c IS NOT NULL THEN initcap(sales_segmentation__c)
END AS sales_segmentation,
    mkto71_lead_score__c AS person_score,
    status AS lead_status,
    last_utm_campaign__c AS last_utm_campaign,
    last_utm_content__c AS last_utm_content,
    crm_partner_id_lookup__c AS crm_partner_id,
    vartopiadrs__partner_prospect_acceptance__c AS prospect_share_status,
    vartopiadrs__partner_prospect_status__c AS partner_prospect_status,
    vartopiadrs__vartopia_prospect_id__c AS partner_prospect_id,
    vartopiadrs__partner_prospect_owner_name__c AS partner_prospect_owner_name,
    partner_recalled__c AS is_partner_recalled,
    name_of_active_sequence__c AS name_of_active_sequence,
    sequence_task_due_date__c::DATE AS sequence_task_due_date,
    sequence_status__c AS sequence_status,
    sequence_step_type2__c AS sequence_step_type,
    actively_being_sequenced__c::BOOLEAN AS is_actively_being_sequenced,
    gaclientid__c AS ga_client_id,
    employee_buckets__c AS employee_bucket,
    fo_initial_mql__c AS is_first_order_initial_mql,
    fo_mql__c AS is_first_order_mql,
    is_first_order_person__c AS is_first_order_person,
    true_initial_mql_date__c AS true_initial_mql_date,
    true_mql_date__c AS true_mql_date,
    last_transfer_date_time__c AS last_transfer_date_time,
    NULL AS initial_marketo_mql_date_time,
	  time_from_last_transfer_to_sequence__c AS time_from_last_transfer_to_sequence,
	  time_from_mql_to_last_transfer__c AS time_from_mql_to_last_transfer,
    NULL AS is_high_priority,
    high_priority_timestamp__c AS high_priority_datetime,
    ptp_score_date__c AS ptp_score_date,
    ptp_score_group__c AS ptp_score_group,
    pql_product_qualified_lead__c AS is_product_qualified_lead,
    ptp_days_since_trial_start__c AS ptp_days_since_trial_start,
    ptp_insights__c AS ptp_insights,
    ptp_is_ptp_contact__c AS is_ptp_contact,
    ptp_namespace_id__c AS ptp_namespace_id,
    ptp_past_insights__c AS ptp_past_insights,
    ptp_past_score_group__c AS ptp_past_score_group,
    is_defaulted_trial__c as is_defaulted_trial,
    pqlnamespacecreatorjobdescription__c AS pql_namespace_creator_job_description,
    pql_namespace_id__c AS pql_namespace_id,
    pql_namespace_name__c AS pql_namespace_name,
    pqlnamespaceusers__c AS pql_namespace_users,
    lead_score_classification__c AS lead_score_classification,
    assignment_date__c AS assignment_date,
    assignment_type__c AS assignment_type,
    CASE
      WHEN leadsource in ('CORE Check-Up','Free Registration')
        THEN 'Core'
      WHEN leadsource in ('GitLab Subscription Portal', 'Gitlab.com', 'GitLab.com', 'Trial - Gitlab.com', 'Trial - GitLab.com')
        THEN 'GitLab.com'
      WHEN leadsource in ('Education', 'OSS')
        THEN 'Marketing/Community'
      WHEN leadsource in ('CE Download', 'Demo', 'Drift', 'Email Request', 'Email Subscription', 'Gated Content - General', 'Gated Content - Report', 'Gated Content - Video'
                           , 'Gated Content - Whitepaper', 'Live Event', 'Newsletter', 'Request - Contact', 'Request - Professional Services', 'Request - Public Sector'
                           , 'Security Newsletter', 'Trial - Enterprise', 'Virtual Sponsorship', 'Web Chat', 'Web Direct', 'Web', 'Webcast')
        THEN 'Marketing/Inbound'
      WHEN leadsource in ('Advertisement', 'Conference', 'Field Event', 'Gong', 'Owned Event','UserGems Contact Tracking','UserGems - Meeting Assistant','UserGems - New Hires & Promotions')
        THEN 'Marketing/Outbound'
      WHEN leadsource in ('Clearbit', 'Datanyze','GovWin IQ', 'Leadware', 'LinkedIn', 'Prospecting - LeadIQ', 'Prospecting - General', 'Prospecting', 'SDR Generated')
        THEN 'Prospecting'
      WHEN leadsource in ('Employee Referral', 'External Referral', 'Partner', 'Word of mouth')
        THEN 'Referral'
      WHEN leadsource in ('AE Generated')
        THEN 'Sales'
      WHEN leadsource in ('DiscoverOrg')
        THEN 'DiscoverOrg'
      ELSE 'Other'
    END                               AS net_new_source_categories,
   CASE
      WHEN leadsource in ('CORE Check-Up', 'CE Download', 'CE Usage Ping','CE Version Check')
        THEN 'core'
      WHEN leadsource in ('Consultancy Request','Contact Request','Content','Demo','Drift','Education','EE Version Check','Email Request','Email Subscription','Enterprise Trial','Gated Content - eBook','Gated Content - General','Gated Content - Report','Gated Content - Video','Gated Content - Whitepaper','GitLab.com','MovingtoGitLab','Newsletter','OSS','Request - Community','Request - Contact','Request - Professional Services','Request - Public Sector','Security Newsletter','Startup Application','Web','Web Chat','White Paper','Trust Center')
        THEN 'inbound'
      WHEN leadsource in ('6sense', 'AE Generated', 'Clearbit','Datanyze','DiscoverOrg','Gemnasium','GitLab Hosted','Gitorious','gmail','Gong','GovWin IQ','Leadware','LinkedIn','Live Event','Prospecting','Prospecting - General','Prospecting - LeadIQ','SDR Generated','seamless.ai','UserGems Contact Tracking','UserGems - Meeting Assistant','UserGems - New Hires & Promotions','Zoominfo')
        THEN 'outbound'
      WHEN leadsource in ('Advertisement', 'Conference', 'Content Syndication', 'Executive Roundtable', 'Field Event', 'Owned Event','Promotion','Vendor Arranged Meetings','Virtual Sponsorship')
        THEN 'paid demand gen'
      WHEN leadsource in ('Purchased List')
        THEN 'purchased list'
      WHEN leadsource in ('Employee Referral', 'Event Partner', 'Existing Client', 'External Referral','Partner','Seminar - Partner','Word of mouth')
        THEN 'referral'
      WHEN leadsource in('Trial - Enterprise','Trial - GitLab.com')
        THEN 'trial'
      WHEN leadsource in ('Webcast','Webinar', 'CSM Webinar')
        THEN 'virtual event'
      WHEN leadsource in ('GitLab Subscription Portal','Web Direct')
        THEN 'web direct'
      ELSE 'Other'
    END                               AS source_buckets,
    -- worked by
    mql_worked_by_user_name__c AS mql_worked_by_user_id,
    mql_worked_by_user_manager_name__c AS mql_worked_by_user_manager_id,
    last_worked_by_date_time__c::DATE AS last_worked_by_date,
    last_worked_by_date_time__c::TIMESTAMP AS last_worked_by_datetime,
    last_worked_by_user_manager_name__c AS last_worked_by_user_manager_id,
    last_worked_by_user_name__c AS last_worked_by_user_id,
    -- territory success planning info
    leandata_owner__c AS tsp_owner,
    leandata_region__c AS tsp_region,
    leandata_sub_region__c AS tsp_sub_region,
    leandata_territory__c AS tsp_territory,
    -- account demographics fields
    account_demographics_sales_segment_2__c AS account_demographics_sales_segment,
    account_demographics_sales_segment__c AS account_demographics_sales_segment_deprecated,
    CASE
      WHEN account_demographics_sales_segment_2__c IN ('Large', 'PubSec') THEN 'Large'
      ELSE account_demographics_sales_segment_2__c
    END AS account_demographics_sales_segment_grouped,
    account_demographics_geo__c AS account_demographics_geo,
    account_demographics_region__c AS account_demographics_region,
    account_demographics_area__c AS account_demographics_area,
    CASE
  WHEN UPPER(account_demographics_sales_segment_2__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_geo__c) = 'AMER' AND UPPER(account_demographics_region__c) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(account_demographics_sales_segment_2__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_geo__c) IN ('AMER', 'LATAM') AND UPPER(account_demographics_region__c) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(account_demographics_sales_segment_2__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_geo__c) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN account_demographics_geo__c
  WHEN UPPER(account_demographics_sales_segment_2__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_region__c) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(account_demographics_sales_segment_2__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_geo__c) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(account_demographics_sales_segment_2__c) NOT IN ('LARGE', 'PUBSEC')
    THEN account_demographics_sales_segment_2__c
  ELSE 'Missing segment_region_grouped'
END
    AS account_demographics_segment_region_grouped,
    account_demographics_territory__c AS account_demographics_territory,
    account_demographics_employee_count__c AS account_demographics_employee_count,
    account_demographics_max_family_employe__c AS account_demographics_max_family_employee,
    account_demographics_upa_country__c AS account_demographics_upa_country,
    account_demographics_upa_state__c AS account_demographics_upa_state,
    account_demographics_upa_city__c AS account_demographics_upa_city,
    account_demographics_upa_street__c AS account_demographics_upa_street,
    account_demographics_upa_postal_code__c AS account_demographics_upa_postal_code,
     --6 Sense Fields
    x6sense_account_6qa__c::BOOLEAN AS has_account_six_sense_6_qa,
    x6sense_account_6qa_end_date__c::DATE AS six_sense_account_6_qa_end_date,
    x6sense_account_6qa_start_date__c::DATE AS six_sense_account_6_qa_start_date,
    x6sense_account_buying_stage__c AS six_sense_account_buying_stage,
    x6sense_account_profile_fit__c AS six_sense_account_profile_fit,
    x6sense_lead_grade__c AS six_sense_lead_grade,
    x6sense_lead_profile_fit__c AS six_sense_lead_profile_fit,
    x6sense_lead_update_date__c::DATE AS six_sense_lead_update_date,
    x6sense_segments__c AS six_sense_segments,
    --Groove
    groove_active_flows_count__c AS groove_active_flows_count,
    groove_added_to_flow_date__c::DATE AS groove_added_to_flow_date,
    dascoopcomposer__groove_convert__c AS is_groove_converted,
    groove_flow_completed_date__c::DATE AS groove_flow_completed_date,
    dascoopcomposer__is_created_by_groove__c AS is_created_by_groove,
    groove_last_engagement__c AS groove_last_engagement_datetime,
    groove_last_engagement_type__c AS groove_last_engagement_type,
    groove_last_flow_name__c AS groove_last_flow_name,
    groove_last_flow_status__c AS groove_last_flow_status,
    groove_last_flow_step_number__c AS groove_last_flow_step_number,
    groove_last_flow_step_type__c AS groove_last_flow_step_type,
    groove_last_step_completed__c AS groove_last_step_completed_datetime,
    groove_last_step_skipped__c AS groove_last_step_skipped,
    groove_last_touch__c AS groove_last_touch_datetime,
    groove_last_touch_type__c AS groove_last_touch_type,
    dascoopcomposer__groove_log_a_call__c AS groove_log_a_call_url,
    groove_next_step_due_date__c::DATE AS groove_next_step_due_date,
    dascoopcomposer__normalized_mobile__c AS groove_mobile_number,
    dascoopcomposer__normalized_phone__c AS groove_phone_number,
    groove_overdue_days__c AS groove_overdue_days,
    groove_removed_from_flow_date__c::DATE AS groove_removed_from_flow_date,
    groove_removed_from_flow_reason__c AS groove_removed_from_flow_reason,
    --Traction Fields
    tracrtc__first_response_time_start__c AS traction_first_response_time,
    tracrtc__first_response_time_in_seconds__c AS traction_first_response_time_seconds,
    tracrtc__response_time_within_business_hours__c AS traction_response_time_in_business_hours,
    --UserGems
    usergem__pastaccount__c AS usergem_past_account_id,
    usergem__pastaccounttype__c AS usergem_past_account_type,
    usergem__pastcontactrelationship__c AS usergem_past_contact_relationship,
    usergem__pastcompany__c AS usergem_past_company,
    --path factory info
    pathfactory_experience_name__c AS pathfactory_experience_name,
    pathfactory_engagement_score__c AS pathfactory_engagement_score,
    pathfactory_content_count__c AS pathfactory_content_count,
    pathfactory_content_list__c AS pathfactory_content_list,
    pathfactory_content_journey__c AS pathfactory_content_journey,
    pathfactory_topic_list__c AS pathfactory_topic_list,
    --marketo sales insight
    mkto_si__last_interesting_moment_desc__c AS marketo_last_interesting_moment,
    mkto_si__last_interesting_moment_date__c AS marketo_last_interesting_moment_date,
    --gitlab internal
    bdr_lu__c AS business_development_look_up,
    business_development_rep_contact__c AS business_development_representative_contact,
    business_development_representative__c AS business_development_representative,
    sdr_lu__c AS crm_sales_dev_rep_id,
    competition__c AS competition,
    -- Cognism Data
    cognism_company_office_city__c AS cognism_company_office_city,
    cognism_company_office_state__c AS cognism_company_office_state,
    cognism_company_office_country__c AS cognism_company_office_country,
    cognism_city__c as cognism_city,
    cognism_state__c as cognism_state,
    cognism_country__c as cognism_country,
    cognism_number_of_employees__c AS cognism_employee_count,
    --LeanData
    NULL AS leandata_matched_account_billing_state,
    NULL AS leandata_matched_account_billing_postal_code,
    NULL AS leandata_matched_account_billing_country,
    NULL AS leandata_matched_account_employee_count,
    lean_data_matched_account_sales_segment__c AS leandata_matched_account_sales_segment,
    --metadata
    createdbyid AS created_by_id,
    createddate AS created_date,
    isdeleted AS is_deleted,
    lastactivitydate::DATE AS last_activity_date,
    lastmodifiedbyid AS last_modified_id,
    lastmodifieddate AS last_modified_date,
    systemmodstamp
  FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_contact_source as
WITH source AS (
  SELECT *
  FROM "RAW".salesforce_v2_stitch.contact
),
renamed AS (
  SELECT
    -- id
    id AS contact_id,
    name AS contact_name,
    firstname AS contact_first_name,
    lastname AS contact_last_name,
    email AS contact_email,
    SPLIT_PART(email, '@', 2) AS email_domain,
    CASE
  WHEN leadsource IN ('DiscoverOrg', 'Zoominfo', 'Purchased List', 'GitLab.com') THEN 'Bulk load or list purchase or spam impacted'
  WHEN TRIM(split_part(email,'@',2)) IS NULL THEN 'Missing email domain'
  WHEN split_part(email,'@',2) LIKE ANY ('%yahoo%',
    '%rediff%',
    '%gmail%',
    '%hotmail%',
    '%outlook%',
    '%verizon.net%',
    '%live%',
    '%sbcglobal.net%',
    '%laposte%',
    '%yandex%',
    '%bk.ru%',
    '%inbox%',
    '%protonmail.%',
    '%posteo%',
    '%pm.me%',
    '%email.%',
    '%fastmail.%',
    '%att.net%',
    '%rocketmail%'
  )
  OR split_part(email,'@',2) IN ('qq.com',
    '163.com',
    'mail.ru',
    'googlemail.com',
    'yandex.ru',
    'protonmail.com',
    'icloud.com',
    't-mobile.com',
    'example.com',
    '126.com',
    'me.com',
    'web.de',
    'naver.com',
    'foxmail.com',
    'aol.com',
    'msn.com',
    'ya.ru',
    'ymail.com',
    'orange.fr',
    'free.fr',
    'comcast.net',
    'mac.com',
    'gitlab.com',
    'gitlab.localhost',
    'yahoo.co.uk',
    'ukr.net',
    'live.com',
    'gmx.de',
    'gmx.net',
    'wp.pl',
    'mail.com',
    'live.fr',
    'ancestry.com'
  )
  THEN 'Personal email domain'
  ELSE 'Business email domain'
END
 AS email_domain_type,
    -- keys
    accountid AS account_id,
    masterrecordid AS master_record_id,
    ownerid AS owner_id,
    recordtypeid AS record_type_id,
    reportstoid AS reports_to_id,
    --contact info
    title AS contact_title,
    CASE
    WHEN LOWER(INSERT(INSERT(title, 1, 0, ''), LEN(title)+2, 0, '')) LIKE ANY (
      '%head% it%', '%vp%technology%','%director%technology%', '%director%engineer%',
      '%chief%information%', '%chief%technology%', '%president%technology%', '%vp%technology%',
      '%director%development%', '% it%director%', '%director%information%', '%director% it%',
      '%chief%engineer%', '%director%quality%', '%vp%engineer%', '%head%information%',
      '%vp%information%', '%president%information%', '%president%engineer%',
      '%president%development%', '%director% it%', '%engineer%director%', '%head%engineer%',
      '%engineer%head%', '%chief%software%', '%director%procurement%', '%procurement%director%',
      '%head%procurement%', '%procurement%head%', '%chief%procurement%', '%vp%procurement%',
      '%procurement%vp%', '%president%procurement%', '%procurement%president%', '%head%devops%'
      )
      OR ARRAY_CONTAINS('cio'::VARIANT, SPLIT(LOWER(title), ' '))
      OR ARRAY_CONTAINS('cio'::VARIANT, SPLIT(LOWER(title), ','))
      OR ARRAY_CONTAINS('cto'::VARIANT, SPLIT(LOWER(title), ' '))
      OR ARRAY_CONTAINS('cto'::VARIANT, SPLIT(LOWER(title), ','))
      OR ARRAY_CONTAINS('cfo'::VARIANT, SPLIT(LOWER(title), ' '))
      OR ARRAY_CONTAINS('cfo'::VARIANT, SPLIT(LOWER(title), ','))
        THEN 'IT Decision Maker'
    WHEN LOWER(INSERT(INSERT(title, 1, 0, ''), LEN(title)+2, 0, '')) LIKE ANY (
      '%manager%information%', '%manager%technology%', '%database%administrat%', '%manager%engineer%',
      '%engineer%manager%', '%information%manager%', '%technology%manager%', '%manager%development%',
      '%manager%quality%', '%manager%network%', '% it%manager%', '%manager% it%',
      '%manager%systems%', '%manager%application%', '%technical%manager%', '%manager%technical%',
      '%manager%infrastructure%', '%manager%implementation%', '%devops%manager%', '%manager%devops%',
      '%manager%software%', '%procurement%manager%', '%manager%procurement%'
      )
      AND NOT ARRAY_CONTAINS('project'::VARIANT, SPLIT(LOWER(title), ' '))
        THEN 'IT Manager'
    WHEN LOWER(INSERT(INSERT(title, 1, 0, ''), LEN(title)+2, 0, '')) LIKE ANY (
      '% it %', '% it,%', '%infrastructure%', '%engineer%',
      '%techno%', '%information%', '%developer%', '%database%',
      '%solutions architect%', '%system%', '%software%', '%technical lead%',
      '%programmer%', '%network administrat%', '%application%', '%procurement%',
      '%development%', '%tech%lead%'
      )
        THEN 'IT Individual Contributor'
    ELSE NULL
  END AS it_job_title_hierarchy,
    role__c AS contact_role,
    mobilephone AS mobile_phone,
    mkto71_lead_score__c AS person_score,
    department AS department,
    contact_status__c AS contact_status,
    requested_contact__c AS requested_contact,
    inactive_contact__c AS inactive_contact,
    hasoptedoutofemail AS has_opted_out_email,
    invalid_email_address__c AS invalid_email_address,
    isemailbounced AS email_is_bounced,
    emailbounceddate AS email_bounced_date,
    emailbouncedreason AS email_bounced_reason,
    mailingstreet AS mailing_address,
    mailingcity AS mailing_city,
    mailingstate AS mailing_state,
    mailingstatecode AS mailing_state_code,
    mailingcountry AS mailing_country,
    mailingcountrycode AS mailing_country_code,
    mailingpostalcode AS mailing_zip_code,
    -- info
    dozisf__zoominfo_company_id__c AS zoominfo_company_id,
    dozisf__zoominfo_id__c AS zoominfo_contact_id,
    zi_company_revenue__c AS zoominfo_company_revenue,
    zi_employee_count__c AS zoominfo_company_employee_count,
    cognism_number_of_employees__c AS cognism_employee_count,
    zi_contact_city__c AS zoominfo_contact_city,
    zi_company_city__c AS zoominfo_company_city,
    zi_industry__c AS zoominfo_company_industry,
    zi_company_state__c AS zoominfo_company_state,
    zi_contact_state__c AS zoominfo_contact_state,
    zi_company_country__c AS zoominfo_company_country,
    zi_contact_country__c AS zoominfo_contact_country,
    zi_phone_number__c AS zoominfo_phone_number,
    zi_mobile_phone_number__c AS zoominfo_mobile_phone_number,
    zi_do_not_call_direct_phone__c AS zoominfo_do_not_call_direct_phone,
    zi_do_not_call_mobile_phone__c AS zoominfo_do_not_call_mobile_phone,
    using_ce__c AS using_ce,
    ee_trial_start_date__c AS ee_trial_start_date,
    ee_trial_end_date__c AS ee_trial_end_date,
    industry__c AS industry,
    -- maybe we can exclude this if it's not relevant
    responded_to_githost_price_change__c AS responded_to_githost_price_change,
    core_check_in_notes__c AS core_check_in_notes,
    leadsource AS lead_source,
    lead_source_type__c AS lead_source_type,
    behavior_score__c AS behavior_score,
    outreach_stage__c AS outreach_stage,
    sequence_step_number__c AS outreach_step_number,
    account_type__c AS account_type,
    contact_assigned_datetime__c::TIMESTAMP AS assigned_datetime,
    mql_timestamp__c AS marketo_qualified_lead_timestamp,
    mql_datetime__c AS marketo_qualified_lead_datetime,
    mql_date__c AS marketo_qualified_lead_date,
    mql_datetime_inferred__c AS mql_datetime_inferred,
    inquiry_datetime__c AS inquiry_datetime,
    inquiry_datetime_inferred__c AS inquiry_datetime_inferred,
    accepted_datetime__c AS accepted_datetime,
    qualifying_datetime__c AS qualifying_datetime,
    qualified_datetime__c AS qualified_datetime,
    unqualified_datetime__c AS unqualified_datetime,
    nurture_datetime__c AS initial_recycle_datetime,
    initial_nurture_datetime__c AS most_recent_recycle_datetime,
    bad_data_datetime__c AS bad_data_datetime,
    worked_date__c AS worked_datetime,
    web_portal_purchase_datetime__c AS web_portal_purchase_datetime,
    mkto_si__last_interesting_moment__c AS marketo_last_interesting_moment,
    mkto_si__last_interesting_moment_date__c AS marketo_last_interesting_moment_date,
    last_utm_campaign__c AS last_utm_campaign,
    last_utm_content__c AS last_utm_content,
    vartopiadrs__partner_prospect_acceptance__c AS prospect_share_status,
    vartopiadrs__partner_prospect_status__c AS partner_prospect_status,
    vartopiadrs__vartopia_prospect_id__c AS partner_prospect_id,
    vartopiadrs__partner_prospect_owner_name__c AS partner_prospect_owner_name,
    sequence_step_type2__c AS sequence_step_type,
    name_of_active_sequence__c AS name_of_active_sequence,
    sequence_task_due_date__c::DATE AS sequence_task_due_date,
    sequence_status__c AS sequence_status,
    actively_being_sequenced__c::BOOLEAN AS is_actively_being_sequenced,
    fo_initial_mql__c AS is_first_order_initial_mql,
    fo_mql__c AS is_first_order_mql,
    is_first_order_person__c AS is_first_order_person,
    true_initial_mql_date__c AS true_initial_mql_date,
    true_mql_date__c AS true_mql_date,
    initial_mql_date__c AS initial_marketo_mql_date_time,
	  last_transfer_date_time__c AS last_transfer_date_time,
	  time_from_last_transfer_to_sequence__c AS time_from_last_transfer_to_sequence,
	  time_from_mql_to_last_transfer__c AS time_from_mql_to_last_transfer,
    high_priority__c AS is_high_priority,
    high_priority_timestamp__c AS high_priority_datetime,
    ptp_score_date__c AS ptp_score_date,
    ptp_score_group__c AS ptp_score_group,
    pqlnamespacecreatorjobdescription__c AS pql_namespace_creator_job_description,
    pql_namespace_id__c AS pql_namespace_id,
    pql_namespace_name__c AS pql_namespace_name,
    pqlnamespaceusers__c AS pql_namespace_users,
    pql_product_qualified_lead__c AS is_product_qualified_lead,
    ptp_days_since_trial_start__c AS ptp_days_since_trial_start,
    ptp_insights__c AS ptp_insights,
    ptp_is_ptp_contact__c AS is_ptp_contact,
    ptp_namespace_id__c AS ptp_namespace_id,
    ptp_past_insights__c AS ptp_past_insights,
    ptp_past_score_group__c AS ptp_past_score_group,
    lead_score_classification__c AS lead_score_classification,
    is_defaulted_trial__c as is_defaulted_trial,
    CASE
      WHEN leadsource in ('CORE Check-Up','Free Registration')
        THEN 'Core'
      WHEN leadsource in ('GitLab Subscription Portal', 'Gitlab.com', 'GitLab.com', 'Trial - Gitlab.com', 'Trial - GitLab.com')
        THEN 'GitLab.com'
      WHEN leadsource in ('Education', 'OSS')
        THEN 'Marketing/Community'
      WHEN leadsource in ('CE Download', 'Demo', 'Drift', 'Email Request', 'Email Subscription', 'Gated Content - General', 'Gated Content - Report', 'Gated Content - Video'
                           , 'Gated Content - Whitepaper', 'Live Event', 'Newsletter', 'Request - Contact', 'Request - Professional Services', 'Request - Public Sector'
                           , 'Security Newsletter', 'Trial - Enterprise', 'Virtual Sponsorship', 'Web Chat', 'Web Direct', 'Web', 'Webcast')
        THEN 'Marketing/Inbound'
      WHEN leadsource in ('Advertisement', 'Conference', 'Field Event', 'Gong', 'Owned Event','UserGems Contact Tracking','UserGems - Meeting Assistant','UserGems - New Hires & Promotions')
        THEN 'Marketing/Outbound'
      WHEN leadsource in ('Clearbit', 'Datanyze','GovWin IQ', 'Leadware', 'LinkedIn', 'Prospecting - LeadIQ', 'Prospecting - General', 'Prospecting', 'SDR Generated')
        THEN 'Prospecting'
      WHEN leadsource in ('Employee Referral', 'External Referral', 'Partner', 'Word of mouth')
        THEN 'Referral'
      WHEN leadsource in ('AE Generated')
        THEN 'Sales'
      WHEN leadsource in ('DiscoverOrg')
        THEN 'DiscoverOrg'
      ELSE 'Other'
    END                               AS net_new_source_categories,
   CASE
      WHEN leadsource in ('CORE Check-Up', 'CE Download', 'CE Usage Ping','CE Version Check')
        THEN 'core'
      WHEN leadsource in ('Consultancy Request','Contact Request','Content','Demo','Drift','Education','EE Version Check','Email Request','Email Subscription','Enterprise Trial','Gated Content - eBook','Gated Content - General','Gated Content - Report','Gated Content - Video','Gated Content - Whitepaper','GitLab.com','MovingtoGitLab','Newsletter','OSS','Request - Community','Request - Contact','Request - Professional Services','Request - Public Sector','Security Newsletter','Startup Application','Web','Web Chat','White Paper','Trust Center')
        THEN 'inbound'
      WHEN leadsource in ('6sense', 'AE Generated', 'Clearbit','Datanyze','DiscoverOrg','Gemnasium','GitLab Hosted','Gitorious','gmail','Gong','GovWin IQ','Leadware','LinkedIn','Live Event','Prospecting','Prospecting - General','Prospecting - LeadIQ','SDR Generated','seamless.ai','UserGems Contact Tracking','UserGems - Meeting Assistant','UserGems - New Hires & Promotions','Zoominfo')
        THEN 'outbound'
      WHEN leadsource in ('Advertisement', 'Conference', 'Content Syndication', 'Executive Roundtable', 'Field Event', 'Owned Event','Promotion','Vendor Arranged Meetings','Virtual Sponsorship')
        THEN 'paid demand gen'
      WHEN leadsource in ('Purchased List')
        THEN 'purchased list'
      WHEN leadsource in ('Employee Referral', 'Event Partner', 'Existing Client', 'External Referral','Partner','Seminar - Partner','Word of mouth')
        THEN 'referral'
      WHEN leadsource in('Trial - Enterprise','Trial - GitLab.com')
        THEN 'trial'
      WHEN leadsource in ('Webcast','Webinar', 'CSM Webinar')
        THEN 'virtual event'
      WHEN leadsource in ('GitLab Subscription Portal','Web Direct')
        THEN 'web direct'
      ELSE 'Other'
    END                               AS source_buckets,
    -- worked by
    mql_worked_by_user_name__c AS mql_worked_by_user_id,
    mql_worked_by_user_manager_name__c AS mql_worked_by_user_manager_id,
    last_worked_by_date_time__c::DATE AS last_worked_by_date,
    last_worked_by_date_time__c::TIMESTAMP AS last_worked_by_datetime,
    last_worked_by_user_manager_name__c AS last_worked_by_user_manager_id,
    last_worked_by_user_name__c AS last_worked_by_user_id,
    -- account demographics fields
    account_demographics_sales_segment__c AS account_demographics_sales_segment,
    CASE
      WHEN account_demographics_sales_segment__c IN ('Large', 'PubSec') THEN 'Large'
      ELSE account_demographics_sales_segment__c
    END AS account_demographics_sales_segment_grouped,
    account_demographics_geo__c AS account_demographics_geo,
    account_demographics_region__c AS account_demographics_region,
    account_demographics_area__c AS account_demographics_area,
    CASE
  WHEN UPPER(account_demographics_sales_segment__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_geo__c) = 'AMER' AND UPPER(account_demographics_region__c) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(account_demographics_sales_segment__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_geo__c) IN ('AMER', 'LATAM') AND UPPER(account_demographics_region__c) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(account_demographics_sales_segment__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_geo__c) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN account_demographics_geo__c
  WHEN UPPER(account_demographics_sales_segment__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_region__c) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(account_demographics_sales_segment__c) IN ('LARGE', 'PUBSEC') AND UPPER(account_demographics_geo__c) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(account_demographics_sales_segment__c) NOT IN ('LARGE', 'PUBSEC')
    THEN account_demographics_sales_segment__c
  ELSE 'Missing segment_region_grouped'
END
    AS account_demographics_segment_region_grouped,
    account_demographics_territory__c AS account_demographics_territory,
    account_demographic_employee_count__c AS account_demographics_employee_count,
    account_demographics_max_family_employe__c AS account_demographics_max_family_employee,
    account_demographics_upa_country__c AS account_demographics_upa_country,
    account_demographics_upa_state__c AS account_demographics_upa_state,
    account_demographics_upa_city__c AS account_demographics_upa_city,
    account_demographics_upa_street__c AS account_demographics_upa_street,
    account_demographics_upa_postal_code__c AS account_demographics_upa_postal_code,
    --path factory info
    pathfactory_experience_name__c AS pathfactory_experience_name,
    pathfactory_engagement_score__c AS pathfactory_engagement_score,
    pathfactory_content_count__c AS pathfactory_content_count,
    pathfactory_content_list__c AS pathfactory_content_list,
    pathfactory_content_journey__c AS pathfactory_content_journey,
    pathfactory_topic_list__c AS pathfactory_topic_list,
    --6 Sense Fields
    x6sense_account_6qa__c::BOOLEAN AS has_account_six_sense_6_qa,
    x6sense_account_6qa_end_date__c::DATE AS six_sense_account_6_qa_end_date,
    x6sense_account_6qa_start_date__c::DATE AS six_sense_account_6_qa_start_date,
    x6sense_account_buying_stage__c AS six_sense_account_buying_stage,
    x6sense_account_profile_fit__c AS six_sense_account_profile_fit,
    x6sense_contact_grade__c AS six_sense_contact_grade,
    x6sense_contact_profile__c AS six_sense_contact_profile,
    x6sense_contact_update_date__c::DATE AS six_sense_contact_update_date,
    --Traction Fields
    tracrtc__first_response_time_start__c AS traction_first_response_time,
    tracrtc__first_response_time_in_seconds__c AS traction_first_response_time_seconds,
    tracrtc__response_time_within_business_hours__c AS traction_response_time_in_business_hours,
    --UserGems
    usergem__pastaccount__c AS usergem_past_account_id,
    usergem__pastaccounttype__c AS usergem_past_account_type,
    usergem__pastcontactrelationship__c AS usergem_past_contact_relationship,
    usergem__pastcompany__c AS usergem_past_company,
    --Groove
    groove_active_flows_count__c AS groove_active_flows_count,
    groove_added_to_flow_date__c::DATE AS groove_added_to_flow_date,
    groove_flow_completed_date__c::DATE AS groove_flow_completed_date,
    dascoopcomposer__is_created_by_groove__c AS is_created_by_groove,
    groove_last_engagement__c AS groove_last_engagement_datetime,
    groove_last_engagement_type__c AS groove_last_engagement_type,
    groove_last_flow_name__c AS groove_last_flow_name,
    groove_last_flow_status__c AS groove_last_flow_status,
    groove_last_flow_step_number__c AS groove_last_flow_step_number,
    groove_last_flow_step_type__c AS groove_last_flow_step_type,
    groove_last_step_completed__c AS groove_last_step_completed_datetime,
    groove_last_step_skipped__c AS groove_last_step_skipped,
    groove_last_touch__c AS groove_last_touch_datetime,
    groove_last_touch_type__c AS groove_last_touch_type,
    dascoopcomposer__groove_log_a_call__c AS groove_log_a_call_url,
    groove_next_step_due_date__c::DATE AS groove_next_step_due_date,
    dascoopcomposer__normalized_mobile__c AS groove_mobile_number,
    dascoopcomposer__normalized_phone__c AS groove_phone_number,
    groove_overdue_days__c AS groove_overdue_days,
    groove_removed_from_flow_date__c::DATE AS groove_removed_from_flow_date,
    groove_removed_from_flow_reason__c AS groove_removed_from_flow_reason,
    dascoopcomposer__groove_create_opportunity__c AS groove_create_opportunity_url,
    groove_engagement_score__c AS groove_engagement_score,
    groove_outbound_email_counter__c AS groove_outbound_email_counter,
    --gl info
    account_owner__c AS account_owner,
    ae_comments__c AS ae_comments,
    business_development_rep__c AS business_development_rep_name,
    outbound_bdr__c AS outbound_business_development_rep_name,
    -- metadata
    createdbyid AS created_by_id,
    createddate AS created_date,
    isdeleted AS is_deleted,
    lastactivitydate::DATE AS last_activity_date,
    lastcurequestdate AS last_cu_request_date,
    lastcuupdatedate AS last_cu_update_date,
    lastmodifiedbyid AS last_modified_by_id,
    lastmodifieddate AS last_modified_date,
    systemmodstamp
  FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sheetload.sheetload_devrel_influenced_campaigns_source as
WITH source AS (
  SELECT *
  FROM "RAW".sheetload.devrel_influenced_campaigns
), renamed AS (
  SELECT
    campaign_name::VARCHAR  as campaign_name,
    campaign_type::VARCHAR  as campaign_type,
    description::VARCHAR    as description,
    influence_type::VARCHAR as influence_type,
    url::VARCHAR  as url,
    dri::VARCHAR  as dri
  FROM source
)
SELECT *
FROM renamed
WHERE campaign_name IS NOT NULL;

CREATE TABLE "PROD".legacy.sfdc_account_snapshots_source as
WITH source AS (
  SELECT *
  FROM "RAW".snapshots.sfdc_account_snapshots
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY
      dbt_valid_from::DATE,
      id
    ORDER BY dbt_valid_from DESC
  ) = 1
),
/*
  ATTENTION: When a field is added to this snapshot model, add it to the SFDC_ACCOUNT_SOURCE model to keep the live and snapshot models in alignment.
*/
renamed AS (
  SELECT
    id                                                                                AS account_id,
    name                                                                              AS account_name,
    -- keys
    account_id_18__c                                                                  AS account_id_18,
    masterrecordid                                                                    AS master_record_id,
    ownerid                                                                           AS owner_id,
    parentid                                                                          AS parent_id,
    primary_contact_id__c                                                             AS primary_contact_id,
    recordtypeid                                                                      AS record_type_id,
    ultimate_parent_account_id__c                                                     AS ultimate_parent_id,
    ultimate_parent_account_text__c                                                   AS ultimate_parent_account_name,
    partner_vat_tax_id__c                                                             AS partner_vat_tax_id,
    -- key people GL side
    gitlab_com_user__c                                                                AS gitlab_com_user,
    account_manager__c                                                                AS account_manager,
    account_owner_calc__c                                                             AS account_owner,
    account_owner_team__c                                                             AS account_owner_team,
    account_owner_role__c                                                             AS account_owner_role,
    proposed_account_owner__c                                                         AS proposed_account_owner,
    business_development_rep__c                                                       AS crm_business_dev_rep_id,
    dedicated_service_engineer__c                                                     AS dedicated_service_engineer,
    sdr_assigned__c                                                                   AS crm_sales_dev_rep_id,
    -- solutions_architect__c                     AS solutions_architect,
    technical_account_manager_lu__c                                                   AS technical_account_manager_id,
    executive_sponsor__c                                                              AS executive_sponsor_id,
    -- info
    "PROD".preparation.ID15TO18(SUBSTRING(REGEXP_REPLACE(
      ultimate_parent_account__c, '_HL_ENCODED_/|<a\\s+href="/', ''
    ), 0, 15))                                                                        AS ultimate_parent_account_id,
    type                                                                              AS account_type,
    dfox_industry__c                                                                  AS df_industry,
    parent_lam_industry_acct_heirarchy__c                                             AS industry,
    sub_industry__c                                                                   AS sub_industry,
    parent_lam_industry_acct_heirarchy__c                                             AS parent_account_industry_hierarchy,
    account_tier__c                                                                   AS account_tier,
    account_tier_notes__c                                                             AS account_tier_notes,
    customer_since__c::DATE                                                           AS customer_since_date,
    carr_this_account__c                                                              AS carr_this_account,
    carr_acct_family__c                                                               AS carr_account_family,
    next_renewal_date__c                                                              AS next_renewal_date,
    license_utilization__c                                                            AS license_utilization,
    support_level__c                                                                  AS support_level,
    named_account__c                                                                  AS named_account,
    billingcountry                                                                    AS billing_country,
    account_demographics_upa_country__c                                               AS billing_country_code,
    billingpostalcode                                                                 AS billing_postal_code,
    sdr_target_account__c::BOOLEAN                                                    AS is_sdr_target_account,
    lam_tier__c                                                                       AS lam,
    lam_dev_count__c                                                                  AS lam_dev_count,
    jihu_account__c::BOOLEAN                                                          AS is_jihu_account,
    partners_signed_contract_date__c                                                  AS partners_signed_contract_date,
    partner_account_iban_number__c                                                    AS partner_account_iban_number,
    partners_partner_type__c                                                          AS partner_type,
    partners_partner_status__c                                                        AS partner_status,
    bdr_prospecting_status__c                                                         AS bdr_prospecting_status,
    first_order_available__c::BOOLEAN                                                 AS is_first_order_available,
    REPLACE(
      zi_technologies__c,
      'The technologies that are used and not used at this account, according to ZoomInfo, after completing a scan are:', -- noqa:L016
      ''
    )                                                                                 AS zi_technologies,
    technical_account_manager_date__c::DATE                                           AS technical_account_manager_date,
    gitlab_customer_success_project__c::VARCHAR                                       AS gitlab_customer_success_project,
    forbes_2000_rank__c                                                               AS forbes_2000_rank,
    potential_users__c                                                                AS potential_users,
    number_of_licenses_this_account__c                                                AS number_of_licenses_this_account,
    decision_maker_count_linkedin__c                                                  AS decision_maker_count_linkedin,
    numberofemployees                                                                 AS number_of_employees,
    phone                                                                             AS account_phone,
    zi_phone__c                                                                       AS zoominfo_account_phone,
    number_of_employees_manual_source_admin__c                                        AS admin_manual_source_number_of_employees,
    account_address_manual_source_admin__c                                            AS admin_manual_source_account_address,
    focus_partner__c                                                                  AS is_focus_partner,
    bdr_next_steps__c                                                                 AS bdr_next_steps,
    bdr_next_step_date__c::DATE                                                       AS bdr_recycle_date,
    actively_working_start_date__c::DATE                                              AS actively_working_start_date,
    bdr_account_research__c                                                           AS bdr_account_research,
    bdr_account_strategy__c                                                           AS bdr_account_strategy,
    account_bdr_assigned_user_role__c                                                 AS account_bdr_assigned_user_role,
    domains__c                                                                        AS account_domains,
    dascoopcomposer__domain_1__c                                                      AS account_domain_1,
    dascoopcomposer__domain_2__c                                                      AS account_domain_2,
    fy22_new_logo_target_list__c                                                      AS compensation_target_account,
    split_hierarchy__c                                                                AS is_split_hierarchy,
    --6 Sense Fields
    x6sense_6qa__c::BOOLEAN                                                           AS has_six_sense_6_qa,
    riskrate_third_party_guid__c                                                      AS risk_rate_guid,
    x6sense_account_profile_fit__c                                                    AS six_sense_account_profile_fit,
    x6sense_account_reach_score__c                                                    AS six_sense_account_reach_score,
    x6sense_account_profile_score__c                                                  AS six_sense_account_profile_score,
    x6sense_account_buying_stage__c                                                   AS six_sense_account_buying_stage,
    x6sense_account_numerical_reach_score__c                                          AS six_sense_account_numerical_reach_score,
    x6sense_account_update_date__c::DATE                                              AS six_sense_account_update_date,
    x6sense_account_6qa_end_date__c::DATE                                             AS six_sense_account_6_qa_end_date,
    x6sense_account_6qa_age_in_days__c                                                AS six_sense_account_6_qa_age_days,
    x6sense_account_6qa_start_date__c::DATE                                           AS six_sense_account_6_qa_start_date,
    x6sense_account_intent_score__c                                                   AS six_sense_account_intent_score,
    x6sense_segments__c                                                               AS six_sense_segments,
    --Qualified Fields
    days_since_last_activity_qualified__c                                             AS qualified_days_since_last_activity,
    qualified_signals_active_session_time__c                                          AS qualified_signals_active_session_time,
    qualified_signals_bot_conversation_count__c                                       AS qualified_signals_bot_conversation_count,
    q_condition__c                                                                    AS qualified_condition,
    q_score__c                                                                        AS qualified_score,
    q_trend__c                                                                        AS qualified_trend,
    q_meetings_booked__c                                                              AS qualified_meetings_booked,
    qualified_signals_rep_conversation_count__c                                       AS qualified_signals_rep_conversation_count,
    signals_research_state__c                                                         AS qualified_signals_research_state,
    signals_research_score__c                                                         AS qualified_signals_research_score,
    qualified_signals_session_count__c                                                AS qualified_signals_session_count,
    q_visitor_count__c                                                                AS qualified_visitors_count,
    -- account demographics fields
    -- Add sales_segment_cleaning macro to avoid duplication in downstream models
    CASE WHEN LOWER(account_demographics_sales_segment__c) = 'smb' THEN 'SMB'
     WHEN LOWER(account_demographics_sales_segment__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(account_demographics_sales_segment__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(account_demographics_sales_segment__c) IS NULL THEN 'SMB'
     WHEN LOWER(account_demographics_sales_segment__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(account_demographics_sales_segment__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(account_demographics_sales_segment__c) = 'lrg' THEN 'Large'
     WHEN LOWER(account_demographics_sales_segment__c) = 'jihu' THEN 'JiHu'
     WHEN account_demographics_sales_segment__c IS NOT NULL THEN initcap(account_demographics_sales_segment__c)
END             AS account_sales_segment,
    -- Add legacy field to support public company metrics reporting: https://gitlab.com/gitlab-data/analytics/-/issues/20290
    CASE WHEN LOWER(old_segment__c) = 'smb' THEN 'SMB'
     WHEN LOWER(old_segment__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(old_segment__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(old_segment__c) IS NULL THEN 'SMB'
     WHEN LOWER(old_segment__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(old_segment__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(old_segment__c) = 'lrg' THEN 'Large'
     WHEN LOWER(old_segment__c) = 'jihu' THEN 'JiHu'
     WHEN old_segment__c IS NOT NULL THEN initcap(old_segment__c)
END                                    AS account_sales_segment_legacy,
    account_demographics_geo__c                                                       AS account_geo,
    account_demographics_region__c                                                    AS account_region,
    account_demographics_area__c                                                      AS account_area,
    account_demographics_territory__c                                                 AS account_territory,
    account_demographics_business_unit__c                                             AS account_business_unit,
    account_demographics_role_type__c                                                 AS account_role_type,
    account_demographics_employee_count__c                                            AS account_employee_count,
    account_demographic_max_family_employees__c                                       AS account_max_family_employee,
    account_demographics_upa_country__c                                               AS account_upa_country,
    account_demographics_upa_country_name__c                                          AS account_upa_country_name,
    account_demographics_upa_state__c                                                 AS account_upa_state,
    account_demographics_upa_city__c                                                  AS account_upa_city,
    account_demographics_upa_street__c                                                AS account_upa_street,
    account_demographics_upa_postal_code__c                                           AS account_upa_postal_code,
    --D&B Fields
    dnbconnect__d_b_match_confidence_code__c::NUMERIC                                 AS dnb_match_confidence_score,
    dnbconnect__d_b_match_grade__c::TEXT                                              AS dnb_match_grade,
    dnbconnect__d_b_connect_company_profile__c::TEXT                                  AS dnb_connect_company_profile_id,
    IFF(duns__c REGEXP '^\\d{9}$', duns__c, NULL)                                     AS dnb_duns,
    IFF(global_ultimate_duns__c REGEXP '^\\d{9}$', global_ultimate_duns__c, NULL)     AS dnb_global_ultimate_duns,
    IFF(domestic_ultimate_duns__c REGEXP '^\\d{9}$', domestic_ultimate_duns__c, NULL) AS dnb_domestic_ultimate_duns,
    dnb_exclude_company__c::BOOLEAN                                                   AS dnb_exclude_company,
    -- present state info
    gs_health_score__c                                                                AS health_number,
    gs_health_score_color__c                                                          AS health_score_color,
    -- opportunity metrics
    count_of_active_subscription_charges__c                                           AS count_active_subscription_charges,
    count_of_active_subscriptions__c                                                  AS count_active_subscriptions,
    count_of_billing_accounts__c                                                      AS count_billing_accounts,
    license_user_count__c                                                             AS count_licensed_users,
    count_of_new_business_won_opps__c                                                 AS count_of_new_business_won_opportunities,
    count_of_open_renewal_opportunities__c                                            AS count_open_renewal_opportunities,
    count_of_opportunities__c                                                         AS count_opportunities,
    count_of_products_purchased__c                                                    AS count_products_purchased,
    count_of_won_opportunities__c                                                     AS count_won_opportunities,
    concurrent_ee_subscriptions__c                                                    AS count_concurrent_ee_subscriptions,
    ce_instances__c                                                                   AS count_ce_instances,
    active_ce_users__c                                                                AS count_active_ce_users,
    number_of_open_opportunities__c                                                   AS count_open_opportunities,
    using_ce__c                                                                       AS count_using_ce,
    --account based marketing fields
    abm_tier__c                                                                       AS abm_tier,
    gtm_strategy__c                                                                   AS gtm_strategy,
    gtm_acceleration_date__c                                                          AS gtm_acceleration_date,
    gtm_account_based_date__c                                                         AS gtm_account_based_date,
    gtm_account_centric_date__c                                                       AS gtm_account_centric_date,
    abm_tier_1_date__c                                                                AS abm_tier_1_date,
    abm_tier_2_date__c                                                                AS abm_tier_2_date,
    abm_tier_3_date__c                                                                AS abm_tier_3_date,
    --demandbase fields
    account_list__c                                                                   AS demandbase_account_list,
    intent__c                                                                         AS demandbase_intent,
    page_views__c                                                                     AS demandbase_page_views,
    score__c                                                                          AS demandbase_score,
    sessions__c                                                                       AS demandbase_sessions,
    trending_offsite_intent__c                                                        AS demandbase_trending_offsite_intent,
    trending_onsite_engagement__c                                                     AS demandbase_trending_onsite_engagement,
    -- sales segment fields
    account_demographics_sales_segment__c                                             AS ultimate_parent_sales_segment,
    sales_segmentation_new__c                                                         AS division_sales_segment,
    account_owner_user_segment__c                                                     AS account_owner_user_segment,
    -- ************************************
    -- sales segmentation deprecated fields - 2020-09-03
    -- left temporary for the sake of MVC and avoid breaking SiSense existing charts
    ultimate_parent_sales_segment_employees__c                                        AS sales_segment,
    sales_segmentation_new__c                                                         AS account_segment,
    -- ************************************
    -- NF: 2020-12-17
    -- these three fields are used to identify accounts owned by
    -- reps within hierarchies that they do not fully own
    -- or even within different regions
    locally_managed__c                                                                AS is_locally_managed_account,
    strategic__c                                                                      AS is_strategic_account,
    -- ************************************
    -- New SFDC Account Fields for FY22 Planning
    next_fy_account_owner_temp__c                                                     AS next_fy_account_owner_temp,
    next_fy_planning_notes_temp__c                                                    AS next_fy_planning_notes_temp,
    --*************************************
    -- Partner Account fields
    partner_track__c                                                                  AS partner_track,
    partners_partner_type__c                                                          AS partners_partner_type,
    gitlab_partner_programs__c                                                        AS gitlab_partner_program,
    --*************************************
    -- Zoom Info Fields
    zi_account_name__c                                                                AS zoom_info_company_name,
    zi_revenue__c                                                                     AS zoom_info_company_revenue,
    zi_employees__c                                                                   AS zoom_info_company_employee_count,
    zi_industry__c                                                                    AS zoom_info_company_industry,
    zi_city__c                                                                        AS zoom_info_company_city,
    zi_state_province__c                                                              AS zoom_info_company_state_province,
    zi_country__c                                                                     AS zoom_info_company_country,
    exclude_from_zoominfo_enrich__c                                                   AS is_excluded_from_zoom_info_enrich,
    zi_website__c                                                                     AS zoom_info_website,
    zi_company_other_domains__c                                                       AS zoom_info_company_other_domains,
    dozisf__zoominfo_id__c                                                            AS zoom_info_dozisf_zi_id,
    zi_parent_company_zoominfo_id__c                                                  AS zoom_info_parent_company_zi_id,
    zi_parent_company_name__c                                                         AS zoom_info_parent_company_name,
    zi_ultimate_parent_company_zoominfo_id__c                                         AS zoom_info_ultimate_parent_company_zi_id,
    zi_ultimate_parent_company_name__c                                                AS zoom_info_ultimate_parent_company_name,
    zi_number_of_developers__c                                                        AS zoom_info_number_of_developers,
    zi_total_funding__c                                                               AS zoom_info_total_funding,
    pubsec_type__c                                                                    AS pubsec_type,
    ptp_insights__c                                                                   AS ptp_insights,
    ptp_score_value__c                                                                AS ptp_score_value,
    ptp_score__c                                                                      AS ptp_score,
    -- NF: Added on 20220427 to support EMEA reporting
    key_account__c                                                                    AS is_key_account,
    -- Gainsight Fields
    gs_first_value_date__c                                                            AS gs_first_value_date,
    gs_last_tam_activity_date__c                                                      AS gs_last_csm_activity_date,
    eoa_sentiment__c                                                                  AS eoa_sentiment,
    gs_health_user_engagement__c                                                      AS gs_health_user_engagement,
    gs_health_cd__c                                                                   AS gs_health_cd,
    gs_health_devsecops__c                                                            AS gs_health_devsecops,
    gs_health_ci__c                                                                   AS gs_health_ci,
    gs_health_scm__c                                                                  AS gs_health_scm,
    health__c                                                                         AS gs_health_csm_sentiment,
    csm_compensation_pool__c                                                          AS gs_csm_compensation_pool,
    -- Risk Fields
    risk_impact__c                                                                    AS risk_impact,
    risk_reason__c                                                                    AS risk_reason,
    last_timeline_at_risk_update__c                                                   AS last_timeline_at_risk_update,
    last_at_risk_update_comments__c                                                   AS last_at_risk_update_comments,
    --Groove Fields
    dascoopcomposer__engagement_status__c                                             AS groove_engagement_status,
    dascoopcomposer__groove_notes__c                                                  AS groove_notes,
    dascoopcomposer__inferred_status__c                                               AS groove_inferred_status,
    -- metadata
    createdbyid                                                                       AS created_by_id,
    createddate                                                                       AS created_date,
    isdeleted                                                                         AS is_deleted,
    lastmodifiedbyid                                                                  AS last_modified_by_id,
    lastmodifieddate                                                                  AS last_modified_date,
    lastactivitydate                                                                  AS last_activity_date,
    CONVERT_TIMEZONE(
      'America/Los_Angeles', CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())
    )                                                                                 AS _last_dbt_run,
    systemmodstamp,
    -- snapshot metadata
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to
  FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PROD".common_mapping.map_bizible_campaign_grouping as
WITH bizible_touchpoints AS (
    SELECT
      touchpoint_id,
      campaign_id,
      bizible_touchpoint_type,
      bizible_touchpoint_source,
      bizible_landing_page,
      bizible_landing_page_raw,
      bizible_referrer_page,
      bizible_referrer_page_raw,
      bizible_form_url,
      bizible_form_url_raw,
      bizible_ad_campaign_name,
      bizible_marketing_channel_path,
      bizible_medium,
      bizible_ad_content
    FROM "PREP".sfdc.sfdc_bizible_touchpoint_source
    WHERE is_deleted = 'FALSE'
), bizible_attribution_touchpoints AS (
    SELECT
      touchpoint_id,
      campaign_id,
      bizible_touchpoint_type,
      bizible_touchpoint_source,
      bizible_landing_page,
      bizible_landing_page_raw,
      bizible_referrer_page,
      bizible_referrer_page_raw,
      bizible_form_url,
      bizible_form_url_raw,
      bizible_ad_campaign_name,
      bizible_marketing_channel_path,
      bizible_medium,
      bizible_ad_content
    FROM "PREP".sfdc.sfdc_bizible_attribution_touchpoint_source
    WHERE is_deleted = 'FALSE'
), bizible AS (
    SELECT *
    FROM bizible_touchpoints
    UNION ALL
    SELECT *
    FROM bizible_attribution_touchpoints
), campaign AS (
    SELECT *
    FROM "PROD".common_prep.prep_campaign
), touchpoints_with_campaign AS (
    SELECT
      md5(cast(coalesce(cast(campaign.dim_campaign_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(campaign.dim_parent_campaign_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(bizible.bizible_touchpoint_type as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(bizible.bizible_landing_page as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(bizible.bizible_referrer_page as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(bizible.bizible_form_url as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(bizible.bizible_ad_campaign_name as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(bizible.bizible_marketing_channel_path as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))																										AS bizible_campaign_grouping_id,
      bizible.touchpoint_id                                 AS dim_crm_touchpoint_id,
      campaign.dim_campaign_id,
      campaign.dim_parent_campaign_id,
      bizible.bizible_touchpoint_type,
      bizible.bizible_touchpoint_source,
      bizible.bizible_landing_page,
      bizible.bizible_landing_page_raw,
      bizible.bizible_referrer_page,
      bizible.bizible_referrer_page_raw,
      bizible.bizible_form_url,
      bizible.bizible_ad_campaign_name,
      bizible.bizible_marketing_channel_path,
      bizible.bizible_ad_content,
      bizible.bizible_medium,
      bizible.bizible_form_url_raw,
      CASE
   WHEN campaign.dim_parent_campaign_id = '7014M000001dowZQAQ' -- based on issue https://gitlab.com/gitlab-com/marketing/marketing-strategy-performance/-/issues/246
    OR (bizible_medium = 'sponsorship'
      AND bizible_touchpoint_source IN ('issa','stackoverflow','securityweekly-appsec','unix&linux','stackexchange'))
    THEN 'Publishers/Sponsorships'
    WHEN  (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%smbnurture%'
      OR bizible_form_url LIKE '%smbnurture%'
      OR bizible_referrer_page LIKE '%smbnurture%'
      OR bizible_ad_campaign_name LIKE '%smbnurture%'
      OR bizible_landing_page LIKE '%smbagnostic%'
      OR bizible_form_url LIKE '%smbagnostic%'
      OR bizible_referrer_page LIKE '%smbagnostic%'
      OR bizible_ad_campaign_name LIKE '%smbagnostic%'))
      OR bizible_ad_campaign_name = 'Nurture - SMB Mixed Use Case'
      THEN 'SMB Nurture'
    WHEN  (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%cicdseeingisbelieving%'
      OR bizible_form_url LIKE '%cicdseeingisbelieving%'
      OR bizible_referrer_page LIKE '%cicdseeingisbelieving%'
      OR bizible_ad_campaign_name LIKE '%cicdseeingisbelieving%'))
      OR bizible_ad_campaign_name = '20201215_HowCiDifferent' --added 2022-04-06 Agnes O DemAND Gen issue 2330
      THEN 'CI/CD Seeing is Believing'
    WHEN  (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%simplifydevops%'
      OR bizible_form_url LIKE '%simplifydevops%'
      OR bizible_referrer_page LIKE '%simplifydevops%'
      OR bizible_ad_campaign_name LIKE '%simplifydevops%'))
      OR campaign.dim_parent_campaign_id = '7014M000001doAGQAY'
      OR campaign.dim_campaign_id LIKE '7014M000001dn6z%'
      THEN 'Simplify DevOps'
    WHEN  (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%21q4-jp%'
      OR bizible_form_url LIKE '%21q4-jp%'
      OR bizible_referrer_page LIKE '%21q4-jp%'
      OR bizible_ad_campaign_name LIKE '%21q4-jp%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name ='2021_Social_Japan_LinkedIn Lead Gen')
      THEN 'Japan-Digital Readiness'
    WHEN  (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%lower-tco%'
      OR bizible_form_url LIKE '%lower-tco%'
      OR bizible_referrer_page LIKE '%lower-tco%'
      OR bizible_ad_campaign_name LIKE '%operationalefficiencies%'
      OR bizible_ad_campaign_name LIKE '%operationalefficiences%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND (bizible_ad_campaign_name LIKE '%_Operational Efficiencies%'
          OR bizible_ad_campaign_name LIKE '%operationalefficiencies%'))
      THEN 'Increase Operational Efficiencies'
    WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%reduce-cycle-time%'
      OR bizible_form_url LIKE '%reduce-cycle-time%'
      OR bizible_referrer_page LIKE '%reduce-cycle-time%'
      OR bizible_ad_campaign_name LIKE '%betterproductsfaster%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND (bizible_ad_campaign_name LIKE '%_Better Products Faster%'
          OR bizible_ad_campaign_name LIKE '%betterproductsfaster%'))
      THEN 'Deliver Better Products Faster'
    WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%secure-apps%'
      OR bizible_form_url LIKE '%secure-apps%'
      OR bizible_referrer_page LIKE '%secure-apps%'
      OR bizible_ad_campaign_name LIKE '%reducesecurityrisk%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND (bizible_ad_campaign_name LIKE '%_Reduce Security Risk%'
          OR bizible_ad_campaign_name LIKE '%reducesecurityrisk%'))
      THEN 'Reduce Security AND Compliance Risk'
    WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%jenkins-alternative%'
      OR bizible_form_url LIKE '%jenkins-alternative%'
      OR bizible_referrer_page LIKE '%jenkins-alternative%'
      OR bizible_ad_campaign_name LIKE '%cicdcmp2%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND (bizible_ad_campaign_name LIKE '%_Jenkins%'
          OR bizible_ad_campaign_name LIKE '%cicdcmp2%'))
      THEN 'Jenkins Take Out'
    WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%single-application-ci%'
      OR bizible_form_url LIKE '%single-application-ci%'
      OR bizible_referrer_page LIKE '%single-application-ci%'
      OR bizible_ad_campaign_name LIKE '%cicdcmp3%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name LIKE '%cicdcmp3%')
      THEN 'Automated Software Delivery'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%github-actions-alternative%'
      OR bizible_form_url LIKE '%github-actions-alternative%'
      OR bizible_referrer_page LIKE '%github-actions-alternative%'
      OR bizible_ad_campaign_name LIKE '%octocat%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name ILIKE '%_OctoCat%')
      OR  bizible_ad_campaign_name = '20200122_MakingCaseCICD'
      THEN 'OctoCat'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%integration-continue-pour-construire-et-tester-plus-rapidement%'
      OR bizible_form_url LIKE '%integration-continue-pour-construire-et-tester-plus-rapidement%'
      OR bizible_referrer_page LIKE '%integration-continue-pour-construire-et-tester-plus-rapidement%'
      OR (bizible_ad_campaign_name LIKE '%singleappci%' AND BIZIBLE_AD_CONTENT LIKE '%french%')))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name ILIKE '%Singleappci_French%')
      THEN 'Automated Software Delivery - FR'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%nutze-continuous-integration-fuer-schnelleres-bauen-und-testen%'
      OR bizible_form_url LIKE '%nutze-continuous-integration-fuer-schnelleres-bauen-und-testen%'
      OR bizible_referrer_page LIKE '%nutze-continuous-integration-fuer-schnelleres-bauen-und-testen%'
      OR (bizible_ad_campaign_name LIKE '%singleappci%' AND BIZIBLE_AD_CONTENT LIKE '%paesslergerman%')))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name ILIKE '%Singleappci_German%')
      THEN 'Automated Software Delivery - DE'
  WHEN (bizible_touchpoint_type = 'Web Form' --added 2021-11-22 MSandP: 585
      AND ( bizible_form_url_raw LIKE '%whygitlabdevopsplatform-apac%'
      OR bizible_landing_page_raw LIKE '%whygitlabdevopsplatform-apac%'
      OR bizible_referrer_page_raw LIKE '%whygitlabdevopsplatform-apac%'))
      OR bizible_ad_campaign_name = '20211208_GitHubCompetitive_APAC'
  THEN 'FY22 GitHub Competitive Campaign - APAC' --added 2022-04-06 Agnes O DemAND Gen issue 2330
  WHEN (bizible_touchpoint_type = 'Web Form' --added 2021-11-22 MSandP: 585
      AND ( bizible_form_url_raw LIKE '%whygitlabdevopsplatform%'
      OR bizible_landing_page_raw LIKE '%whygitlabdevopsplatform%'
      OR bizible_referrer_page_raw LIKE '%whygitlabdevopsplatform%'
      OR bizible_form_url_raw LIKE '%githubcompete%'
      OR bizible_landing_page_raw LIKE '%githubcompete%'
      OR bizible_referrer_page_raw LIKE '%githubcompete%'
      OR bizible_form_url_raw LIKE '%gitlabcicdwithgithub%' --added 2022-09-28 Agnes O MS & P issue 897
      OR bizible_landing_page_raw LIKE '%gitlabcicdwithgithub%'--added 2022-09-28 Agnes O MS & P issue 897
      OR bizible_referrer_page_raw LIKE '%gitlabcicdwithgithub%'--added 2022-09-28 Agnes O MS & P issue 897
      OR bizible_form_url_raw LIKE '%conversica-move-to-gitlab%'
      OR bizible_landing_page_raw LIKE '%conversica-move-to-gitlab%'
      OR bizible_referrer_page_raw LIKE '%conversica-move-to-gitlab%' -- added 2022-04-06 Agnes O MS & P issue 874
        ))
    OR bizible_ad_campaign_name = '20211202_GitHubCompetitive'
    OR bizible_ad_campaign_name LIKE '%competegh%' --added 2022-04-06 Agnes O DemAND Gen issue 2330
    OR bizible_ad_campaign_name = '20220713_GitHubtoGitLabMigration_AMER_EMEA' -- added 2022-04-06 Agnes O MS & P issue 874
    OR (campaign.dim_parent_campaign_id = '7014M000001vm9KQAQ' AND bizible_ad_campaign_name ILIKE '%github%') --added 2022-09-28 Agnes O MS & P issue 897
  THEN 'FY22 GitHub Competitive Campaign'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%use-continuous-integration-to-build-and-test-faster%'
      OR bizible_form_url LIKE '%use-continuous-integration-to-build-and-test-faster%'
      OR bizible_referrer_page LIKE '%use-continuous-integration-to-build-and-test-faster%'
      OR bizible_ad_campaign_name LIKE '%singleappci%'))
      OR bizible_ad_campaign_name ='20201013_ActualTechMedia_DeepMonitoringCI'
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND (bizible_ad_campaign_name LIKE '%_CI%'
          OR bizible_ad_campaign_name ILIKE '%singleappci%'))
    OR (campaign.dim_parent_campaign_id = '7014M000001vm9KQAQ' AND (bizible_ad_campaign_name LIKE '%_CI%'
      OR bizible_ad_campaign_name ILIKE '%singleappci%'))
      THEN 'Automated Software Delivery' --- Added by AO demAND gen issue 2262
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%shift-your-security-scanning-left%'
      OR bizible_form_url LIKE '%shift-your-security-scanning-left%'
      OR bizible_referrer_page LIKE '%shift-your-security-scanning-left%'
      OR bizible_form_url LIKE '%developer-survey%' -- Added by AO 2023-01-23
      OR bizible_landing_page LIKE '%developer-survey%' -- Added by AO 2023-01-23
      OR bizible_referrer_page LIKE '%developer-survey%' -- Added by AO 2023-01-23
      OR bizible_form_url LIKE '%2022-devsecops-report%' -- Added by AO 2023-01-23
      OR bizible_landing_page LIKE '%2022-devsecops-report%' -- Added by AO 2023-01-23
      OR bizible_referrer_page LIKE '%2022-devsecops-report%' -- Added by AO 2023-01-23
      OR bizible_ad_campaign_name LIKE '%devsecopsusecase%'
      OR bizible_ad_campaign_name ILIKE '%devsecopstechdemo%' -- Added by AO 2023-10-23 to fix wrongly named campaign utm
      OR bizible_ad_campaign_name LIKE '%seccomp%')) -- Added by AO 2023-10-23 to include newer Sec & Comp utm
      OR campaign.dim_parent_campaign_id = '7014M000001dnVOQAY' -- GCP Partner campaign
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND (bizible_ad_campaign_name ILIKE '%_DevSecOps%'
          OR bizible_ad_campaign_name LIKE '%devsecopsusecase%'
          OR bizible_ad_campaign_name LIKE '%seccomp%')) --Added by AO 2023-10-26 to include new Security & Compliance utm
      OR (campaign.dim_parent_campaign_id = '7014M000001vm9KQAQ'
      AND (bizible_ad_campaign_name ILIKE '%DevSecOps%'
      OR bizible_ad_campaign_name LIKE '%Fuzzing%' -- Added by AO demand gen issue 2262
      OR bizible_ad_campaign_name LIKE '%SecComp%'
      OR campaign.gtm_motion = 'Security & Compliance')) -- Added by AO 2023-10-23 to include newer Sec & Comp tech demo
      OR (lower(campaign.type) = 'content syndication'
      AND campaign.gtm_motion = 'Security & Compliance') --Added by AO 2023-10-26
      THEN 'DevSecOps Platform'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_form_url_raw LIKE '%utm_campaign=autosd%'
      OR bizible_landing_page_raw LIKE '%utm_campaign=autosd%'
      OR bizible_referrer_page_RAW LIKE '%utm_campaign=autosd%'))
      OR bizible_ad_campaign_name = 'autosd'
      OR bizible_ad_campaign_name ILIKE '%AutomatedSoftwareDelivery%' -- added by AO MS & P issue 896
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name ILIKE '%autosd%') --- Added by AO MS&P issue 825
      OR (campaign.dim_parent_campaign_id = '7014M000001vm9KQAQ'
      AND (bizible_ad_campaign_name ILIKE '%AutoSD%'
      OR campaign.gtm_motion = 'Automated Software Delivery')) --- Added by AO 2023-10-23 to include Auto SD tech demo
      OR (lower(campaign.type) = 'content syndication'
      AND campaign.gtm_motion = 'Automated Software Delivery') -- Added by AO 2023-10-26
    THEN 'Automated Software Delivery'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%aws-gitlab-serverless%'
      OR bizible_landing_page LIKE '%trek10-aws-cicd%'
      OR bizible_form_url LIKE '%aws-gitlab-serverless%'
      OR bizible_form_url LIKE '%trek10-aws-cicd%'
      OR bizible_referrer_page LIKE '%aws-gitlab-serverless%'
      OR bizible_ad_campaign_name LIKE '%awspartner%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name ILIKE '%_AWS%')
      THEN 'AWS'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%simplify-collaboration-with-version-control%'
      OR bizible_form_url LIKE '%simplify-collaboration-with-version-control%'
      OR bizible_referrer_page LIKE '%simplify-collaboration-with-version-control%'
      OR bizible_ad_campaign_name LIKE '%vccusecase%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND (bizible_ad_campaign_name LIKE '%_VCC%'
          OR bizible_ad_campaign_name LIKE '%vccusecase%'))
      THEN 'Automated Software Delivery' -- Updated by AO 2023-10-23 to align with 1HFY24 campaigns structure
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_landing_page LIKE '%gitops-infrastructure-automation%'
      OR bizible_form_url LIKE '%gitops-infrastructure-automation%'
      OR bizible_referrer_page LIKE '%gitops-infrastructure-automation%'
      OR bizible_ad_campaign_name LIKE '%iacgitops%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND (bizible_ad_campaign_name LIKE '%_GitOps%'
          OR bizible_ad_campaign_name LIKE '%iacgitops%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001vm9KQAQ' AND bizible_ad_campaign_name ILIKE '%GitOps%') --- Added by AO demAND gen issue 2327
      THEN 'Automated Software Delivery'
  WHEN  (bizible_touchpoint_type = 'Web Form'
      AND (bizible_ad_campaign_name LIKE '%evergreen%'
      OR bizible_form_url_raw LIKE '%utm_campaign=evergreen%'
      OR bizible_landing_page_raw LIKE '%utm_campaign=evergreen%'
      OR bizible_referrer_page_RAW LIKE '%utm_campaign=evergreen%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name ILIKE '%_Evergreen%')
    Then 'Evergreen'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_ad_campaign_name LIKE 'brand%'
      OR bizible_ad_campaign_name LIKE 'Brand%'
      OR bizible_form_url_raw LIKE '%utm_campaign=brand%'
      OR bizible_landing_page_raw LIKE '%utm_campaign=brand%'
      OR bizible_referrer_page_RAW LIKE '%utm_campaign=brand%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001dn8MQAQ'
      AND bizible_ad_campaign_name ILIKE '%_Brand%')
    Then 'Brand'
  WHEN (bizible_touchpoint_type = 'Web Form' --added 2021-06-04 MSandP: 332
      AND (bizible_landing_page LIKE '%contact-us-ultimate%'
      OR bizible_form_url LIKE '%contact-us-ultimate%'
      OR bizible_referrer_page LIKE '%contact-us-ultimate%'
      OR bizible_ad_campaign_name LIKE '%premtoultimatesp%'))
      THEN 'Premium to Ultimate'
  WHEN (bizible_touchpoint_type = 'Web Form' --added 2021-06-04 MSandP: 346
      AND ( bizible_form_url_raw LIKE '%webcast-gitops-multicloudapp%'
      OR bizible_landing_page_raw LIKE '%webcast-gitops-multicloudapp%'
      OR bizible_referrer_page_RAW LIKE '%webcast-gitops-multicloudapp%'))
      OR (campaign.dim_parent_campaign_id LIKE '%7014M000001dpmf%')
    Then 'Automated Software Delivery'
  WHEN (bizible_touchpoint_type = 'Web Form' --added 2021-06-04 MSandP: 346
      AND ( bizible_form_url_raw LIKE '%devopsgtm%'
      OR bizible_landing_page_raw LIKE '%devopsgtm%'
      OR bizible_landing_page_raw LIKE '%events-amer-enterprise%'---Added by AO MSandP issue:811
      OR bizible_landing_page_raw LIKE '%events-pd-emea%'----Added by AO MSandP issue:811
      OR bizible_landing_page_raw LIKE '%events-pd-technical-apac%'---Added by AO MSandP issue:811
      OR bizible_referrer_page_raw LIKE '%devsecopsplat%'
      OR bizible_landing_page_raw LIKE '%devsecopsplat%'
      OR bizible_referrer_page_RAW LIKE '%devopsgtm%'))
      OR campaign.dim_parent_campaign_id LIKE '%7014M000001dpT9%'
      OR (campaign.dim_parent_campaign_id LIKE '%7014M000001dn8M%'
      AND (bizible_ad_campaign_name LIKE '%devopsgtm%'
            OR bizible_ad_campaign_name LIKE '%devsecopsplat%')) -- Added by AO 2023-10-26 to include LI DevOps campaign
      OR campaign.dim_campaign_id LIKE '%7014M000001vbtw%'
      OR campaign.dim_campaign_id LIKE '%7018X000001lmtN%' -- Added by AO MSandP issue 880
      OR (campaign.dim_parent_campaign_id = '7014M000001vm9KQAQ'
      AND (bizible_ad_campaign_name ILIKE '%MLOps%'
      OR bizible_ad_campaign_name ILIKE '%Dora%'
      OR bizible_ad_campaign_name ILIKE '%DevOps%'
      OR bizible_ad_campaign_name ILIKE '%DOP%' -- Added by AO demAND gen issue 2262
      OR campaign.gtm_motion = 'DevSecOps Platform'))-- Added by AO 2023-10-26 to include newer DevSecOps platform tech demo
      OR (lower(campaign.type) = 'content syndication'
      AND campaign.gtm_motion = 'DevSecOps Platform') -- Added by AO 2023-10-26
    Then 'DevSecOps Platform'
  WHEN (bizible_touchpoint_type = 'Web Form' --added 2021-06-04 MSandP: 346
      AND (( bizible_form_url_raw LIKE '%utm_campaign=devopsgtm%' AND bizible_form_url_raw LIKE '%utm_content=partnercredit%'
      OR bizible_landing_page_raw LIKE '%utm_campaign=devopsgtm%' AND bizible_landing_page_raw LIKE '%utm_content=partnercredit%'
      OR bizible_referrer_page_raw LIKE '%utm_campaign=devopsgtm%' AND bizible_referrer_page_raw LIKE '%utm_content=partnercredit%')
          OR(
        bizible_form_url_raw LIKE '%cloud-credits-promo%'
        OR bizible_landing_page_raw LIKE '%cloud-credits-promo%'
        OR bizible_referrer_page_raw LIKE '%cloud-credits-promo%'
        )))
      OR campaign.dim_parent_campaign_id LIKE '%7014M000001vcDr%'
        -- OR campaign.dim_parent_campaign_id LIKE '%7014M000001dn8M%')
      OR campaign.dim_campaign_id LIKE '%7014M000001vcDr%'
    Then 'Cloud Partner Campaign'
  WHEN (bizible_touchpoint_type = 'Web Form' --added 2021-06-04 MSandP: 346
      AND (( bizible_form_url_raw LIKE '%utm_campaign=gitlab14%'
      OR bizible_landing_page_raw LIKE '%utm_campaign=gitlab14%'
      OR bizible_referrer_page_raw LIKE '%utm_campaign=gitlab14%')
        OR(
        bizible_form_url_raw LIKE '%the-shift-to-modern-devops%'
        OR bizible_landing_page_raw LIKE '%the-shift-to-modern-devops%'
        OR bizible_referrer_page_raw LIKE '%the-shift-to-modern-devops%'
        )))
    Then 'GitLab 14 webcast'
  WHEN
    campaign.dim_campaign_id LIKE '%7014M000001drcQ%'
    Then '20210512_ISSAWebcast'
  WHEN (bizible_touchpoint_type = 'Web Form' --added 2021-0830 MSandP: 325
      AND (( bizible_form_url_raw LIKE '%psdigitaltransformation%'
      OR bizible_landing_page_raw LIKE '%psdigitaltransformation%'
      OR bizible_referrer_page_raw LIKE '%psdigitaltransformation%')
        OR(
        bizible_form_url_raw LIKE '%psglobal%'
        OR bizible_landing_page_raw LIKE '%psglobal%'
        OR bizible_referrer_page_raw LIKE '%psglobal%'
        )))
  Then 'PubSec Nurture'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (bizible_form_url_raw LIKE '%utm_campaign=cdusecase%'
      OR bizible_landing_page_raw LIKE '%utm_campaign=cdusecase%'
      OR bizible_referrer_page_RAW LIKE '%utm_campaign=cdusecase%'))
      OR (campaign.dim_parent_campaign_id = '7014M000001vm9KQAQ' AND bizible_ad_campaign_name LIKE '%CD_%') --- Added by AO demAND gen issue 2262
    THEN 'Automated Software Delivery'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (contains(bizible_ad_campaign_name, 'speedsecurity')
      OR lower(campaign.gtm_motion) = 'trading off speed for security'))
    THEN 'Trading off Speed for Security'
  WHEN (bizible_touchpoint_type = 'Web Form'
      AND (contains(bizible_ad_campaign_name, 'aisdlc')
      OR lower(campaign.gtm_motion) = 'ai throughout the sdlc'))
    THEN 'AI throughout the SDLC'
  ELSE 'None' END AS bizible_integrated_campaign_grouping,
  CASE
    -- if content syndication, use SFDC value dirrectly
    WHEN lower(campaign.type) = 'content syndication'
      THEN campaign.gtm_motion
    WHEN bizible_integrated_campaign_grouping LIKE '%Automated Software Delivery%'
        THEN 'Automated Software Delivery'
    WHEN bizible_integrated_campaign_grouping IN ('CI/CD Seeing is Believing','Jenkins Take Out','OctoCat','Premium to Ultimate','20210512_ISSAWebcast', 'GitOps Use Case','GitOps GTM webcast','VCC Use Case')
        THEN 'Automated Software Delivery'
    WHEN dim_parent_campaign_id = '7014M000001vm9KQAQ' AND campaign.gtm_motion IN ('CI (CI/CD)',  'GITOPS', 'Automated Software Delivery') -- override for TechDemo Series
        THEN 'Automated Software Delivery'
    WHEN bizible_integrated_campaign_grouping = 'DevSecOps Platform'
        THEN 'DevSecOps Platform'
    WHEN bizible_integrated_campaign_grouping IN ('Deliver Better Products Faster','Reduce Security AND Compliance Risk','Simplify DevOps', 'DevOps GTM', 'Cloud Partner Campaign', 'GitLab 14 webcast','DOI Webcast','FY22 GitHub Competitive Campaign', 'FY22 GitHub Competitive Campaign - APAC')
        THEN 'DevSecOps Platform'
    WHEN dim_parent_campaign_id = '7014M000001vm9KQAQ' AND campaign.gtm_motion IN ('DevOps Platform', 'DevSecOps Platform') -- override for TechDemo Series
        THEN 'DevSecOps Platform'
    ELSE NULL
    END                                                                                               AS gtm_motion,
  IFF(bizible_integrated_campaign_grouping <> 'None' or dim_parent_campaign_id = '7014M000001vm9KQAQ','DemAND Gen','Other') -- override for TechDemo Series
                                                                                                        AS touchpoint_segment,
  CASE
    WHEN touchpoint_id ILIKE 'a6061000000CeS0%' -- Specific touchpoint overrides
      THEN 'Field Event'
    WHEN bizible_marketing_channel_path = 'CPC.AdWords'
      THEN 'Google AdWords'
    WHEN bizible_marketing_channel_path IN ('Email.Other', 'Email.Newsletter','Email.Outreach')
      THEN 'Email'
    WHEN bizible_marketing_channel_path IN ('Field Event','Partners.Google','Brand.Corporate Event','Conference','Speaking Session')
      OR (bizible_medium = 'Field Event (old)' AND bizible_marketing_channel_path = 'Other')
      THEN 'Field Event'
    WHEN bizible_marketing_channel_path IN ('Paid Social.Facebook','Paid Social.LinkedIn','Paid Social.Twitter','Paid Social.YouTube')
      THEN 'Paid Social'
    WHEN bizible_marketing_channel_path IN ('Social.Facebook','Social.LinkedIn','Social.Twitter','Social.YouTube')
      THEN 'Social'
    WHEN bizible_marketing_channel_path IN ('Marketing Site.Web Referral','Web Referral')
      THEN 'Web Referral'
    WHEN bizible_marketing_channel_path IN ('Marketing Site.Web Direct', 'Web Direct') -- Added to Web Direct
      OR dim_campaign_id IN (
                              '701610000008ciRAAQ', -- Trial - GitLab.com
                              '70161000000VwZbAAK', -- Trial - Self-Managed
                              '70161000000VwZgAAK', -- Trial - SaaS
                              '70161000000CnSLAA0', -- 20181218_DevOpsVirtual
                              '701610000008cDYAAY'  -- 2018_MovingToGitLab
                            )
      THEN 'Web Direct'
    WHEN bizible_marketing_channel_path LIKE 'Organic Search.%'
      OR bizible_marketing_channel_path = 'Marketing Site.Organic'
      THEN 'Organic Search'
    WHEN bizible_marketing_channel_path IN ('Sponsorship')
      THEN 'Paid Sponsorship'
    ELSE 'Unknown'
  END                                                                                                 AS integrated_campaign_grouping
  FROM bizible
  LEFT JOIN campaign
    ON bizible.campaign_id = campaign.dim_campaign_id
 )
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@degan'::VARCHAR       AS updated_by,
      '2021-03-02'::DATE        AS model_created_date,
      '2023-10-18'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM touchpoints_with_campaign;

CREATE TABLE "PROD".common_mapping.map_bizible_marketing_channel_path as
WITH touchpoints AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_bizible_touchpoint_source
), final AS (
    SELECT DISTINCT
      bizible_marketing_channel_path                                    AS bizible_marketing_channel_path,
      CASE WHEN bizible_marketing_channel_path IN ('Other','Direct','Organic Search.Bing','Web Referral',
                                      'Social.Twitter','Social.Other' ,'Social.LinkedIn','Social.Facebook',
                                      'Organic Search.Yahoo','Organic Search.Google','Email','Organic Search.Other',
                                      'Event.Webcast','Event.Workshop','Content.PF Content',
                                      'Event.Self-Service Virtual Event')
                                                        THEN 'Inbound Free Channels'
      WHEN bizible_marketing_channel_path IN ('Event.Virtual Sponsorship','Paid Search.Other','Event.Executive Roundtables'
                                    ,'Paid Social.Twitter','Paid Social.Other','Display.Other','Paid Search.AdWords'
                                    ,'Paid Search.Bing','Display.Google','Paid Social.Facebook','Paid Social.LinkedIn'
                                    ,'Referral.Referral Program','Content.Content Syndication','Event.Owned Event'
                                    ,'Other.Direct Mail','Event.Speaking Session','Content.Gated Content'
                                    ,'Event.Field Event','Other.Survey','Event.Sponsored Webcast'
                                    ,'Swag.Virtual','Swag.Direct Mail','Event.Conference','Event.Vendor Arranged Meetings')
                                                        THEN 'Inbound Paid'
      WHEN bizible_marketing_channel_path IN ('IQM.IQM')       THEN 'Outbound'
      WHEN bizible_marketing_channel_path IN ('Trial.Trial')   THEN 'Trial'
      ELSE 'Other'
     END
 AS bizible_marketing_channel_path_name_grouped
    FROM touchpoints
    WHERE bizible_touchpoint_position LIKE '%FT%'
)
SELECT
      *,
      '@paul_armstrong'::VARCHAR       AS created_by,
      '@mcooperDD'::VARCHAR       AS updated_by,
      '2020-11-13'::DATE        AS model_created_date,
      '2021-02-26'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".restricted_safe_common_mapping.map_crm_account as
WITH account_prep AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_sfdc_account
), sales_segment AS (
    SELECT *
    FROM "PROD".common_prep.prep_sales_segment
), sales_territory AS (
    SELECT *
    FROM "PROD".common_prep.prep_sales_territory
), industry AS (
    SELECT *
    FROM "PROD".common_prep.prep_industry
), location_country AS (
    SELECT *
    FROM "PROD".common_prep.prep_location_country
), final AS (
    SELECT
  COALESCE(account_prep.dim_parent_crm_account_id, MD5(-1))
                              AS dim_parent_crm_account_id,
  COALESCE(account_prep.dim_crm_account_id, MD5(-1))
                                     AS dim_crm_account_id,
  COALESCE(sales_segment_ultimate_parent.dim_sales_segment_id, MD5(-1))
                  AS dim_parent_sales_segment_id,
  COALESCE(sales_territory_ultimate_parent.dim_sales_territory_id, MD5(-1))
              AS dim_parent_sales_territory_id,
  COALESCE(industry_ultimate_parent.dim_industry_id, MD5(-1))
                            AS dim_parent_industry_id,
  COALESCE(sales_segment.dim_sales_segment_id, MD5(-1))
                                  AS dim_account_sales_segment_id,
  COALESCE(sales_territory.dim_sales_territory_id, MD5(-1))
                              AS dim_account_sales_territory_id,
  COALESCE(industry.dim_industry_id, MD5(-1))
                                            AS dim_account_industry_id,
  COALESCE(location_country.dim_location_country_id::varchar, MD5(-1))
                   AS dim_account_location_country_id,
  COALESCE(location_country.dim_location_region_id, MD5(-1))
                             AS dim_account_location_region_id
    FROM account_prep
    LEFT JOIN sales_segment AS sales_segment_ultimate_parent
      ON account_prep.dim_parent_sales_segment_name_source = sales_segment_ultimate_parent.sales_segment_name
    LEFT JOIN sales_territory AS sales_territory_ultimate_parent
      ON account_prep.dim_parent_sales_territory_name_source = sales_territory_ultimate_parent.sales_territory_name
    LEFT JOIN industry AS industry_ultimate_parent
      ON account_prep.dim_parent_industry_name_source = industry_ultimate_parent.industry_name
    LEFT JOIN sales_segment
      ON account_prep.dim_parent_sales_segment_name_source = sales_segment.sales_segment_name
    LEFT JOIN sales_territory
      ON account_prep.dim_parent_sales_territory_name_source = sales_territory.sales_territory_name
    LEFT JOIN industry
      ON account_prep.dim_account_industry_name_source = industry.industry_name
    LEFT JOIN location_country
      ON account_prep.dim_account_location_country_name_source = location_country.country_name
)
SELECT
      *,
      '@snalamaru'::VARCHAR       AS created_by,
      '@lisvinueza'::VARCHAR       AS updated_by,
      '2020-11-23'::DATE        AS model_created_date,
      '2023-05-21'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common.dim_date as
WITH dates AS (
  SELECT
    "DATE_ID",
  "DATE_DAY",
  "DATE_ACTUAL",
  "DAY_NAME",
  "MONTH_ACTUAL",
  "YEAR_ACTUAL",
  "QUARTER_ACTUAL",
  "DAY_OF_WEEK",
  "FIRST_DAY_OF_WEEK",
  "WEEK_OF_YEAR",
  "DAY_OF_MONTH",
  "DAY_OF_QUARTER",
  "DAY_OF_YEAR",
  "FISCAL_YEAR",
  "FISCAL_QUARTER",
  "DAY_OF_FISCAL_QUARTER",
  "DAY_OF_FISCAL_YEAR",
  "MONTH_NAME",
  "FIRST_DAY_OF_MONTH",
  "LAST_DAY_OF_MONTH",
  "FIRST_DAY_OF_YEAR",
  "LAST_DAY_OF_YEAR",
  "FIRST_DAY_OF_QUARTER",
  "LAST_DAY_OF_QUARTER",
  "FIRST_DAY_OF_FISCAL_QUARTER",
  "LAST_DAY_OF_FISCAL_QUARTER",
  "FIRST_DAY_OF_FISCAL_YEAR",
  "LAST_DAY_OF_FISCAL_YEAR",
  "WEEK_OF_FISCAL_YEAR",
  "WEEK_OF_FISCAL_QUARTER",
  "MONTH_OF_FISCAL_YEAR",
  "LAST_DAY_OF_WEEK",
  "QUARTER_NAME",
  "FISCAL_QUARTER_NAME",
  "FISCAL_QUARTER_NAME_FY",
  "FISCAL_QUARTER_NUMBER_ABSOLUTE",
  "FISCAL_MONTH_NAME",
  "FISCAL_MONTH_NAME_FY",
  "HOLIDAY_DESC",
  "IS_HOLIDAY",
  "LAST_MONTH_OF_FISCAL_QUARTER",
  "IS_FIRST_DAY_OF_LAST_MONTH_OF_FISCAL_QUARTER",
  "LAST_MONTH_OF_FISCAL_YEAR",
  "IS_FIRST_DAY_OF_LAST_MONTH_OF_FISCAL_YEAR",
  "SNAPSHOT_DATE_FPA",
  "SNAPSHOT_DATE_FPA_FIFTH",
  "SNAPSHOT_DATE_BILLINGS",
  "DAYS_IN_MONTH_COUNT",
  "DAYS_IN_FISCAL_QUARTER_COUNT",
  "WEEK_OF_MONTH_NORMALISED",
  "DAY_OF_FISCAL_QUARTER_NORMALISED",
  "WEEK_OF_FISCAL_QUARTER_NORMALISED",
  "DAY_OF_FISCAL_YEAR_NORMALISED",
  "IS_FIRST_DAY_OF_FISCAL_QUARTER_WEEK",
  "DAYS_UNTIL_LAST_DAY_OF_MONTH",
  "CURRENT_DATE_ACTUAL",
  "CURRENT_DAY_NAME",
  "CURRENT_FIRST_DAY_OF_WEEK",
  "CURRENT_DAY_OF_FISCAL_QUARTER_NORMALISED",
  "CURRENT_WEEK_OF_FISCAL_QUARTER_NORMALISED",
  "CURRENT_WEEK_OF_FISCAL_QUARTER",
  "CURRENT_FISCAL_YEAR",
  "CURRENT_FIRST_DAY_OF_FISCAL_YEAR",
  "CURRENT_FISCAL_QUARTER_NAME_FY",
  "CURRENT_FIRST_DAY_OF_MONTH",
  "CURRENT_FIRST_DAY_OF_FISCAL_QUARTER",
  "CURRENT_DAY_OF_MONTH",
  "CURRENT_DAY_OF_FISCAL_QUARTER",
  "CURRENT_DAY_OF_FISCAL_YEAR",
  "IS_FISCAL_MONTH_TO_DATE",
  "IS_FISCAL_QUARTER_TO_DATE",
  "IS_FISCAL_YEAR_TO_DATE",
  "FISCAL_DAYS_AGO",
  "FISCAL_WEEKS_AGO",
  "FISCAL_MONTHS_AGO",
  "FISCAL_QUARTERS_AGO",
  "FISCAL_YEARS_AGO",
  "IS_CURRENT_DATE"
  FROM "PROD".common_prep.prep_date
)
SELECT
      *,
      '@msendal'::VARCHAR       AS created_by,
      '@jpeguero'::VARCHAR       AS updated_by,
      '2020-06-01'::DATE        AS model_created_date,
      '2023-08-14'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM dates;

CREATE TABLE "PROD".common_prep.prep_location_country as
WITH location_region AS (
    SELECT *
    FROM "PROD".common_prep.prep_location_region
), maxmind_countries_source AS (
    SELECT *
    FROM "PREP".sheetload.sheetload_maxmind_countries_source
), zuora_country_geographic_region AS (
    SELECT *
    FROM "PREP".seed_finance.zuora_country_geographic_region
), joined AS (
    SELECT
      geoname_id                                                AS dim_location_country_id,
      country_name                                              AS country_name,
      UPPER(country_iso_code)                                   AS iso_2_country_code,
      UPPER(iso_alpha_3_code)                                   AS iso_3_country_code,
      continent_name,
      CASE
        WHEN continent_name IN ('Africa', 'Europe') THEN 'EMEA'
        WHEN continent_name IN ('North America')    THEN 'AMER'
        WHEN continent_name IN ('South America')    THEN 'LATAM'
        WHEN continent_name IN ('Oceania','Asia')   THEN 'APAC'
        ELSE 'Missing location_region_name'
      END                                                      AS location_region_name_map,
      is_in_european_union
    FROM maxmind_countries_source
    LEFT JOIN  zuora_country_geographic_region
      ON UPPER(maxmind_countries_source.country_iso_code) = UPPER(zuora_country_geographic_region.iso_alpha_2_code)
    WHERE country_iso_code IS NOT NULL
), final AS (
    SELECT
      joined.dim_location_country_id,
      location_region.dim_location_region_id,
      joined.location_region_name_map,
      joined.country_name,
      joined.iso_2_country_code,
      joined.iso_3_country_code,
      joined.continent_name,
      joined.is_in_european_union
    FROM joined
    LEFT JOIN location_region
      ON joined.location_region_name_map = location_region.location_region_name
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@mcooperDD'::VARCHAR       AS updated_by,
      '2021-01-25'::DATE        AS model_created_date,
      '2021-01-25'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common_prep.prep_bizible_touchpoint_information as
WITH sfdc_lead_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_lead_source
), sfdc_contact_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_contact_source
), sfdc_bizible_person_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_bizible_person_source
), sfdc_bizible_touchpoint_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_bizible_touchpoint_source
)
, prep_lead AS (
    SELECT
        lead_id AS sfdc_record_id,
        converted_contact_id,
        marketo_qualified_lead_datetime,
        mql_datetime_inferred
    FROM sfdc_lead_source
    WHERE is_deleted = 'FALSE'
), prep_contact AS (
    SELECT
        contact_id AS sfdc_record_id,
        marketo_qualified_lead_datetime,
        mql_datetime_inferred
    FROM sfdc_contact_source
    WHERE is_deleted = 'FALSE'
), prep_bizible AS (
    SELECT
        sfdc_bizible_touchpoint_source.*,
        sfdc_bizible_person_source.bizible_contact_id,
        sfdc_bizible_person_source.bizible_lead_id
    FROM sfdc_bizible_touchpoint_source
    LEFT JOIN sfdc_bizible_person_source
        ON sfdc_bizible_touchpoint_source.bizible_person_id = sfdc_bizible_person_source.person_id
    WHERE sfdc_bizible_person_source.is_deleted = 'FALSE'
        AND sfdc_bizible_touchpoint_source.is_deleted = 'FALSE'
), prep_person AS (
    SELECT
        sfdc_record_id,
        bizible_person_id
    FROM prep_lead
    LEFT JOIN prep_bizible
        ON prep_lead.sfdc_record_id=prep_bizible.bizible_lead_id
    UNION ALL
    SELECT
        sfdc_record_id,
        bizible_person_id
    FROM prep_contact
    LEFT JOIN prep_bizible
        ON prep_contact.sfdc_record_id=prep_bizible.bizible_contact_id
), marketing_qualified_leads AS (
    SELECT
        md5(cast(coalesce(cast(COALESCE(converted_contact_id, sfdc_record_id) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(marketo_qualified_lead_datetime::timestamp as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS mql_event_id,
        sfdc_record_id,
        MAX(marketo_qualified_lead_datetime)::timestamp AS mql_date_latest
    FROM prep_lead
    WHERE marketo_qualified_lead_datetime IS NOT NULL
        OR mql_datetime_inferred IS NOT NULL
    GROUP BY 1,2
), marketing_qualified_contacts AS (
    SELECT
        md5(cast(coalesce(cast(sfdc_record_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(marketo_qualified_lead_datetime::timestamp as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS mql_event_id,
        sfdc_record_id,
        MAX(marketo_qualified_lead_datetime)::timestamp AS mql_date_latest
    FROM prep_contact
    WHERE marketo_qualified_lead_datetime IS NOT NULL
        OR mql_datetime_inferred IS NOT NULL
    GROUP BY 1,2
    HAVING sfdc_record_id NOT IN (
                         SELECT sfdc_record_id
                         FROM marketing_qualified_leads
                         )
), mql_person_prep AS (
    SELECT
        sfdc_record_id,
        mql_date_latest
    FROM marketing_qualified_leads
    UNION ALL
    SELECT
        sfdc_record_id,
        mql_date_latest
    FROM marketing_qualified_contacts
), bizible_mql_touchpoint_information_base AS (
    SELECT DISTINCT
        prep_person.sfdc_record_id,
        prep_bizible.touchpoint_id,
        prep_bizible.bizible_touchpoint_date,
        prep_bizible.bizible_form_url,
        prep_bizible.campaign_id AS sfdc_campaign_id,
        prep_bizible.bizible_ad_campaign_name,
        prep_bizible.bizible_marketing_channel,
        prep_bizible.bizible_marketing_channel_path,
        ROW_NUMBER () OVER (PARTITION BY prep_person.sfdc_record_id ORDER BY prep_bizible.bizible_touchpoint_date DESC) AS touchpoint_order_by_person
    FROM prep_person
    LEFT JOIN mql_person_prep
        ON prep_person.sfdc_record_id=mql_person_prep.sfdc_record_id
    LEFT JOIN prep_bizible
        ON prep_person.bizible_person_id = prep_bizible.bizible_person_id
    WHERE prep_bizible.touchpoint_id IS NOT null
        AND mql_person_prep.mql_date_latest IS NOT null
        AND prep_bizible.bizible_touchpoint_date::DATE <= mql_person_prep.mql_date_latest::DATE
    ORDER BY prep_bizible.bizible_touchpoint_date DESC
), bizible_mql_touchpoint_information_final AS (
  SELECT
      sfdc_record_id AS biz_mql_person_id,
      touchpoint_id AS bizible_mql_touchpoint_id,
      bizible_touchpoint_date AS bizible_mql_touchpoint_date,
      bizible_form_url AS bizible_mql_form_url,
      sfdc_campaign_id AS bizible_mql_sfdc_campaign_id,
      bizible_ad_campaign_name AS bizible_mql_ad_campaign_name,
      bizible_marketing_channel AS bizible_mql_marketing_channel,
      bizible_marketing_channel_path AS bizible_mql_marketing_channel_path
  FROM bizible_mql_touchpoint_information_base
  WHERE touchpoint_order_by_person = 1
), bizible_most_recent_touchpoint_information_base AS (
    SELECT DISTINCT
        prep_person.sfdc_record_id,
        prep_bizible.touchpoint_id,
        prep_bizible.bizible_touchpoint_date,
        prep_bizible.bizible_form_url,
        prep_bizible.campaign_id AS sfdc_campaign_id,
        prep_bizible.bizible_ad_campaign_name,
        prep_bizible.bizible_marketing_channel,
        prep_bizible.bizible_marketing_channel_path,
        ROW_NUMBER () OVER (PARTITION BY prep_person.sfdc_record_id ORDER BY prep_bizible.bizible_touchpoint_date DESC) AS touchpoint_order_by_person
    FROM prep_person
    LEFT JOIN prep_bizible
        ON prep_person.bizible_person_id = prep_bizible.bizible_person_id
    WHERE prep_bizible.touchpoint_id IS NOT null
), bizible_most_recent_touchpoint_information_final AS (
  SELECT
      sfdc_record_id AS biz_most_recent_person_id,
      touchpoint_id AS bizible_most_recent_touchpoint_id,
      bizible_touchpoint_date AS bizible_most_recent_touchpoint_date,
      bizible_form_url AS bizible_most_recent_form_url,
      sfdc_campaign_id AS bizible_most_recent_sfdc_campaign_id,
      bizible_ad_campaign_name AS bizible_most_recent_ad_campaign_name,
      bizible_marketing_channel AS bizible_most_recent_marketing_channel,
      bizible_marketing_channel_path AS bizible_most_recent_marketing_channel_path
  FROM bizible_most_recent_touchpoint_information_base
  WHERE touchpoint_order_by_person = 1
), final AS (
    SELECT
        bizible_most_recent_touchpoint_information_final.biz_most_recent_person_id AS sfdc_record_id,
        bizible_mql_touchpoint_information_final.bizible_mql_touchpoint_id,
        bizible_mql_touchpoint_information_final.bizible_mql_touchpoint_date,
        bizible_mql_touchpoint_information_final.bizible_mql_form_url,
        bizible_mql_touchpoint_information_final.bizible_mql_sfdc_campaign_id,
        bizible_mql_touchpoint_information_final.bizible_mql_ad_campaign_name,
        bizible_mql_touchpoint_information_final.bizible_mql_marketing_channel,
        bizible_mql_touchpoint_information_final.bizible_mql_marketing_channel_path,
        bizible_most_recent_touchpoint_information_final.bizible_most_recent_touchpoint_id,
        bizible_most_recent_touchpoint_information_final.bizible_most_recent_touchpoint_date,
        bizible_most_recent_touchpoint_information_final.bizible_most_recent_form_url,
        bizible_most_recent_touchpoint_information_final.bizible_most_recent_sfdc_campaign_id,
        bizible_most_recent_touchpoint_information_final.bizible_most_recent_ad_campaign_name,
        bizible_most_recent_touchpoint_information_final.bizible_most_recent_marketing_channel,
        bizible_most_recent_touchpoint_information_final.bizible_most_recent_marketing_channel_path
    FROM bizible_most_recent_touchpoint_information_final
    LEFT JOIN bizible_mql_touchpoint_information_final
        ON bizible_most_recent_touchpoint_information_final.biz_most_recent_person_id=bizible_mql_touchpoint_information_final.biz_mql_person_id
)
SELECT
      *,
      '@rkohnke'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2024-05-17'::DATE        AS model_created_date,
      '2024-07-09'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common_prep.prep_crm_task as
WITH source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_task_source
), renamed AS(
    SELECT
      task_id,
      --keys
      md5(cast(coalesce(cast(source.task_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))             AS dim_crm_task_sk,
      source.task_id                                                AS dim_crm_task_pk,
      source.account_id                                             AS dim_crm_account_id,
      source.owner_id                                               AS dim_crm_user_id,
      source.assigned_employee_number,
      source.lead_or_contact_id,
      source.account_or_opportunity_id,
      source.record_type_id                                         AS sfdc_record_type_id,
      source.related_to_account_name,
      source.related_lead_id,
      source.related_contact_id,
      source.related_opportunity_id                                 AS dim_crm_opportunity_id,
      source.related_account_id,
      source.related_to_id,
      COALESCE(source.related_lead_id, source.related_contact_id)   AS sfdc_record_id,
      -- Task infomation
      source.comments,
      source.full_comments,
      source.task_subject,
      source.partner_marketing_task_subject,
      source.task_date,
      source.task_created_at                                        AS task_created_date,
      FIRST_VALUE(source.task_created_at) OVER (PARTITION BY source.related_opportunity_id ORDER BY source.task_created_at ASC) AS first_opportunity_task_created_date,
      source.task_created_by_id,
      source.task_status,
      source.task_subtype,
      source.task_type,
      source.task_priority,
      source.close_task,
      source.task_completed_at                                      AS task_completed_date,
      source.is_closed,
      source.is_deleted,
      source.is_archived,
      source.is_high_priority,
      source.persona_functions,
      source.persona_levels,
      source.outreach_meeting_type,
      source.customer_interaction_sentiment,
      source.task_owner_role,
      source.is_created_by_groove,
      -- Activity infromation
      source.activity_disposition,
      source.activity_source,
      source.csm_activity_type,
      source.sa_activity_type,
      source.gs_activity_type,
      source.gs_sentiment,
      source.gs_meeting_type,
      source.is_gs_exec_sponsor_present,
      source.is_meeting_cancelled,
      source.products_positioned,
      -- Call information
      source.call_type,
      source.call_purpose,
      source.call_disposition,
      source.call_duration_in_seconds,
      source.call_recording,
      source.is_answered,
      source.is_correct_contact,
      -- Reminder information
      source.is_reminder_set,
      source.reminder_at                                            AS reminder_date,
      -- Recurrence information
      source.is_recurrence,
      source.task_recurrence_interval,
      source.task_recurrence_instance,
      source.task_recurrence_type,
      source.task_recurrence_activity_id,
      source.task_recurrence_end_date                               AS task_recurrence_date,
      source.task_recurrence_day_of_week,
      source.task_recurrence_timezone,
      source.task_recurrence_start_date,
      source.task_recurrence_day_of_month,
      source.task_recurrence_month,
      -- Sequence information
      source.active_sequence_name,
      source.sequence_step_number,
      -- Docs/Video Conferencing
      source.google_doc_link,
      source.zoom_app_ics_sequence,
      source.zoom_app_use_personal_zoom_meeting_id,
      source.zoom_app_join_before_host,
      source.zoom_app_make_it_zoom_meeting,
      source.chorus_call_id,
      -- Counts
      source.account_or_opportunity_count,
      source.lead_or_contact_count,
      -- metadata
      source.last_modified_id,
      source.last_modified_at                                                                           AS last_modified_date,
      source.system_modified_at                                                                         AS systemmodstamp,
      -- flags
      IFF(
        source.task_subject LIKE '%Reminder%',
          1,
        0
        )                                                                                               AS is_reminder_task,
      IFF(
        source.task_status = 'Completed',
          1,
        0
        )                                                                                               AS is_completed_task,
      IFF(
        source.owner_id != '0054M000004M9pdQAC',
          1,
        0
        )                                                                                               AS is_gainsight_integration_user_task,
      IFF(
        source.task_type ='Demand Gen'
          OR LOWER(source.task_subject) LIKE '%demand gen%'
            OR LOWER(source.full_comments) LIKE '%demand gen%',
          1,
        0
        )                                                                                               AS is_demand_gen_task,
       IFF(
        source.task_type ='Demo'
          OR LOWER(source.task_subject) LIKE '%demo%'
            OR LOWER(source.full_comments) LIKE '%demo%',
           1,
        0
        )                                                                                                AS is_demo_task,
       IFF(
        source.task_type ='Workshop'
          OR LOWER(source.task_subject) LIKE '%workshop%'
            OR LOWER(source.full_comments) LIKE '%workshop%',
          1,
        0
        )                                                                                                AS is_workshop_task,
      IFF(
        source.task_type LIKE '%meeting%'
          OR LOWER(source.task_subject) LIKE '%meeting%'
            OR LOWER(source.full_comments) LIKE '%meeting%',
          1,
        0
        )                                                                                               AS is_meeting_task,
      IFF(
        (
        source.task_type='Email'
          AND LOWER(source.task_subject) LIKE '%[email] [out]%'
          )
            OR (
                source.task_type ='Other'
                  AND LOWER(source.task_subject) LIKE '%email sent%'
                  ),
          1,
        0
        )                                                                                               AS is_email_task,
      IFF(
        source.task_subject LIKE '%[In]%',
          1,
         0
         )                                                                                              AS is_incoming_email_task,
      IFF(
        source.task_subject LIKE '%[Out]%',
          1,
         0
         )                                                                                              AS is_outgoing_email_task,
      IFF(
        is_email_task = 1
          AND LOWER(source.task_priority) ='high',
          1,
        0
        )                                                                                               AS is_high_priority_email_task,
      IFF(
        is_email_task = 1
          AND LOWER(source.task_priority) ='low',
            1,
          0
          )                                                                                             AS is_low_priority_email_task,
       IFF(
        is_email_task = 1
          AND LOWER(source.task_priority) ='normal',
            1,
          0
          )                                                                                             AS is_normal_priority_email_task,
        IFF(
          source.task_type='Call'
            OR source.task_subtype ='Call',
            1,
          0
          )                                                                                             AS is_call_task,
        IFF(
          is_call_task = 1
            AND source.call_duration_in_seconds >= 60,
            1,
          0
          )                                                                                             AS is_call_longer_1min_task,
        IFF(
          is_call_task = 1
            AND lower(source.task_priority) ='high',
            1,
          0
          )                                                                                             AS is_high_priority_call_task,
        IFF(
          is_call_task = 1
            AND lower(source.task_priority) ='low',
            1,
          0
          )                                                                                             AS is_low_priority_call_task,
        IFF(
          is_call_task = 1
            AND lower(source.task_priority) ='normal',
            1,
          0
          )                                                                                             AS is_normal_priority_call_task,
        IFF(
          is_call_task = 1
            AND (
                 source.call_disposition IN (
                                            'Not Answered','Correct Contact: Not Answered/Other','Call - No Answer','No Number Found','Busy',
                                            'Bad Number','Automated Switchboard','Incorrect Contact: Left Message','Not Answered (legacy)',
                                            'Incorrect Contact: Not Answered/Other','Main Company Line - Can''t Transfer Line','',' '
                                            )
                  OR source.call_disposition IS NULL
                  ),
            1,
          0
          )                                                                                             AS is_not_answered_call_task,
        IFF(
          is_call_task = 1
            AND source.call_disposition IN (
                                            'CC: Answered: Info Gathered: Not Opp yet',
                                            'CC: Answered: Not Interested','Incorrect Contact: Answered','CC: Answered: Personal Use'
                                            ),
            1,
          0
          )                                                                                             AS is_answered_meaningless_call_task,
        IFF(
          is_call_task = 1
            AND source.call_disposition IN (
                                            'CC:Answered: Info Gathered: Potential Opp',
                                            'Correct Contact: Answered','CC: Answered: Asked for Call Back','Correct Contact: IQM Set',
                                            'Correct Contact: Discovery Call Set','CC: Answered: Using Competition','Incorrect Contact: Answered: Gave Referral',
                                            'Correct Contact: Answered (Do not use)','Answered (legacy)'
                                            ),
            1,
          0
          )                                                                                             AS is_answered_meaningfull_call_task,
        IFF(
          is_email_task = 1
            AND source.task_created_at = first_opportunity_task_created_date,
            1,
          0
          )                                                                                             AS is_opportunity_initiation_email_task,
        IFF(
          is_email_task = 1
            AND source.task_created_at != first_opportunity_task_created_date,
              1,
            0
            )                                                                                           AS is_opportunity_followup_email_task,
        IFF(
          is_call_task = 1
            AND  source.task_created_at = first_opportunity_task_created_date,
            1,
          0
          )                                                                                             AS is_opportunity_initiation_call_task,
        IFF(
          is_call_task = 1
            AND  source.task_created_at != first_opportunity_task_created_date,
            1,
          0
          )                                                                                             AS is_opportunity_followup_call_task,
      -- Calculated averaged and percents
       DATEDIFF(hour, source.task_date, source.task_created_at)                                       AS hours_waiting_before_task,
       ROUND(
        IFF(
            is_email_task = 1,
              hours_waiting_before_task,
            NULL
            ),
          1)                                                                                            AS hours_waiting_before_email_task,
       ROUND(
         IFF(
           is_call_task = 1,
             source.call_duration_in_seconds,
           NULL
           ),
        0
        )                                                                                              AS call_task_duration_in_seconds,
       ROUND(
         IFF(
           is_call_task = 1,
             hours_waiting_before_task,
           NULL
           ),
        1)                                                                                              AS hours_waiting_before_call_task
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PROD".common_prep.prep_crm_event as
WITH source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_event_source
), renamed AS(
    SELECT
      event_id,
    --keys
      md5(cast(coalesce(cast(source.event_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))            AS dim_crm_event_sk,
      source.event_id                                               AS dim_crm_event_pk,
      source.account_id                                             AS dim_crm_account_id,
      source.owner_id                                               AS dim_crm_user_id,
      source.lead_or_contact_id,
      source.related_account_name,
      source.related_lead_id,
      source.related_contact_id,
      source.related_opportunity_id                                 AS dim_crm_opportunity_id,
      source.related_account_id,
      source.related_to_id,
      source.created_by_id,
      source.booked_by_dim_crm_user_id,
      source.what_id,
      COALESCE(source.related_lead_id, source.related_contact_id)   AS sfdc_record_id,
    -- Task infomation
      source.event_subject,
      source.event_source,
      source.outreach_meeting_type,
      source.event_type,
      source.event_disposition,
      source.event_description,
      source.event_subtype,
      source.booked_by_employee_number,
      source.sa_activity_type,
      source.event_show_as,
      source.assigned_to_role,
      source.csm_activity_type,
      source.customer_interaction_sentiment,
      source.google_doc_link,
      source.comments,
      source.qualified_convo_or_meeting,
      FIRST_VALUE(source.created_at) OVER (PARTITION BY source.related_opportunity_id ORDER BY source.created_at ASC) AS first_opportunity_event_created_date,
      source.partner_marketing_task_subject,
    --Dates and Datetimes
      source.event_start_date_time,
      source.reminder_date_time,
      source.event_end_date_time,
      source.event_date,
      source.event_date_time,
      source.created_at,
      source.event_end_date,
    --Event Flags
      source.is_all_day_event,
      source.is_archived,
      source.is_child_event,
      source.is_group_event,
      source.is_private_event,
      source.is_recurrence,
      source.has_reminder_set,
      source.is_answered,
      source.is_correct_contact,
      source.is_meeting_canceled,
      source.is_closed_event,
    --Recurrence Info
      source.event_recurrence_activity_id,
      source.event_recurrence_day_of_week,
      source.event_recurrence_day_of_month,
      source.event_recurrence_end_date,
      source.event_recurrence_instance,
      source.event_recurrence_interval,
      source.event_recurrence_month_of_year,
      source.event_recurrence_start_date_time,
      source.event_recurrence_timezone_key,
      source.event_recurrence_type,
      source.is_recurrence_2_exclusion,
      source.is_recurrence_2,
      source.is_recurrence_2_exception,
      -- metadata
      source.last_modified_id,
      source.last_modified_date,
      source.systemmodstamp,
      source.is_deleted
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PROD".common_prep.prep_sales_segment as
WITH source_data AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_sfdc_account
    WHERE dim_parent_sales_segment_name_source IS NOT NULL
), unioned AS (
    SELECT DISTINCT
      md5(cast(coalesce(cast(dim_parent_sales_segment_name_source as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))   AS dim_sales_segment_id,
      dim_parent_sales_segment_name_source                                      AS sales_segment_name,
      dim_parent_sales_segment_grouped_source                                   AS sales_segment_grouped
    FROM source_data
    UNION ALL
    SELECT
      MD5('-1')                                                                 AS dim_sales_segment_id,
      'Missing sales_segment_name'                                              AS sales_segment_name,
      'Missing sales_segment_grouped'                                           AS sales_segment_grouped
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@lisvinueza'::VARCHAR       AS updated_by,
      '2020-12-18'::DATE        AS model_created_date,
      '2023-05-21'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM unioned;

CREATE TABLE "PROD".common_prep.prep_crm_user_daily_snapshot as
WITH sfdc_user_roles_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_user_roles_source
), dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), sfdc_users_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_users_source
), sfdc_user_snapshots_source AS (
    SELECT *
    FROM "PROD".legacy.sfdc_user_snapshots_source
)
, sheetload_mapping_sdr_sfdc_bamboohr_source AS (
    SELECT *
    FROM "PREP".sheetload.sheetload_mapping_sdr_sfdc_bamboohr_source
), snapshot_dates AS (
    SELECT *
    FROM dim_date
    WHERE date_actual >= '2020-03-01' and date_actual <= CURRENT_DATE
   -- this filter will only be applied on an incremental run
   AND date_id > (SELECT MAX(snapshot_id) FROM "PROD".common_prep.prep_crm_user_daily_snapshot)
), sfdc_users AS (
    SELECT
      md5(cast(coalesce(cast(sfdc_user_snapshots_source.user_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(snapshot_dates.date_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))    AS crm_user_snapshot_id,
      snapshot_dates.date_id                                                                           AS snapshot_id,
      snapshot_dates.fiscal_year                                                                       AS snapshot_fiscal_year,
      snapshot_dates.date_actual                                                                       AS snapshot_date,
      sfdc_user_snapshots_source.*
    FROM
      sfdc_user_snapshots_source
      INNER JOIN snapshot_dates
        ON snapshot_dates.date_actual >= sfdc_user_snapshots_source.dbt_valid_from
        AND snapshot_dates.date_actual < COALESCE(sfdc_user_snapshots_source.dbt_valid_to, '9999-12-31'::TIMESTAMP)
), current_fiscal_year AS (
    SELECT
      fiscal_year
    FROM dim_date
    WHERE date_actual = CURRENT_DATE()
), final AS (
    SELECT
      sfdc_users.crm_user_snapshot_id,
      sfdc_users.snapshot_id,
      sfdc_users.snapshot_date,
      sfdc_users.user_id                                                                                                              AS dim_crm_user_id,
      sfdc_users.employee_number,
      sfdc_users.name                                                                                                                 AS user_name,
      sfdc_users.title,
      sfdc_users.department,
      sfdc_users.team,
      sfdc_users.manager_id,
      sfdc_users.manager_name,
      sfdc_users.user_email,
      sfdc_users.is_active,
      sfdc_users.start_date,
      sfdc_users.ramping_quota,
      sfdc_users.user_timezone,
      sfdc_users.user_role_id,
      md5(cast(coalesce(cast(sfdc_user_roles_source.name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                         AS dim_crm_user_role_name_id,
      sfdc_user_roles_source.name                                                                                                     AS user_role_name,
      sfdc_users.user_role_type                                                                                                       AS user_role_type,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_1 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_1_id,
      sfdc_users.user_role_level_1                                                                                                    AS user_role_level_1,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_2 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_2_id,
      sfdc_users.user_role_level_2                                                                                                    AS user_role_level_2,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_3 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_3_id,
      sfdc_users.user_role_level_3                                                                                                    AS user_role_level_3,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_4 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_4_id,
      sfdc_users.user_role_level_4                                                                                                    AS user_role_level_4,
      md5(cast(coalesce(cast(sfdc_users.user_role_level_5 as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                        AS dim_crm_user_role_level_5_id,
      sfdc_users.user_role_level_5                                                                                                    AS user_role_level_5,
      md5(cast(coalesce(cast(sfdc_users.user_segment as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                             AS dim_crm_user_sales_segment_id,
      sfdc_users.user_segment                                                                                                         AS crm_user_sales_segment,
      sfdc_users.user_segment_grouped                                                                                                 AS crm_user_sales_segment_grouped,
      md5(cast(coalesce(cast(sfdc_users.user_geo as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                                 AS dim_crm_user_geo_id,
      sfdc_users.user_geo                                                                                                             AS crm_user_geo,
      md5(cast(coalesce(cast(sfdc_users.user_region as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                              AS dim_crm_user_region_id,
      sfdc_users.user_region                                                                                                          AS crm_user_region,
      md5(cast(coalesce(cast(sfdc_users.user_area as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                                AS dim_crm_user_area_id,
      sfdc_users.user_area                                                                                                            AS crm_user_area,
      md5(cast(coalesce(cast(sfdc_users.user_business_unit as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                       AS dim_crm_user_business_unit_id,
      sfdc_users.user_business_unit                                                                                                   AS crm_user_business_unit,
      md5(cast(coalesce(cast(sfdc_users.user_role_type as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                                                           AS dim_crm_user_role_type_id,
      CASE
        WHEN sfdc_users.is_hybrid_user = 'Yes'
          THEN 1
        WHEN sfdc_users.is_hybrid_user = 'No'
          THEN  0
        WHEN sfdc_users.is_hybrid_user IS NULL
          THEN 0
        ELSE 0
      END                                                                                                                             AS is_hybrid_user,
      CASE
        WHEN sfdc_users.snapshot_fiscal_year < 2024
          THEN CONCAT(
                      UPPER(sfdc_users.user_segment),
                      '-',
                      UPPER(sfdc_users.user_geo),
                      '-',
                      UPPER(sfdc_users.user_region),
                      '-',
                      UPPER(sfdc_users.user_area),
                      '-',
                      sfdc_users.snapshot_fiscal_year
                      )
        WHEN sfdc_users.snapshot_fiscal_year = 2024 AND LOWER(sfdc_users.user_business_unit) = 'comm'
          THEN CONCAT(
                      UPPER(sfdc_users.user_business_unit),
                      '-',
                      UPPER(sfdc_users.user_geo),
                      '-',
                      UPPER(sfdc_users.user_segment),
                      '-',
                      UPPER(sfdc_users.user_region),
                      '-',
                      UPPER(sfdc_users.user_area),
                      '-',
                      sfdc_users.snapshot_fiscal_year
                      )
        WHEN sfdc_users.snapshot_fiscal_year = 2024 AND LOWER(sfdc_users.user_business_unit) = 'entg'
          THEN CONCAT(
                      UPPER(sfdc_users.user_business_unit),
                      '-',
                      UPPER(sfdc_users.user_geo),
                      '-',
                      UPPER(sfdc_users.user_region),
                      '-',
                      UPPER(sfdc_users.user_area),
                      '-',
                      UPPER(sfdc_users.user_segment),
                      '-',
                      sfdc_users.snapshot_fiscal_year
                      )
        WHEN sfdc_users.snapshot_fiscal_year = 2024
          AND (sfdc_users.user_business_unit IS NOT NULL AND LOWER(sfdc_users.user_business_unit) NOT IN ('comm', 'entg'))  -- account for non-sales reps
          THEN CONCAT(
                      UPPER(sfdc_users.user_business_unit),
                      '-',
                      UPPER(sfdc_users.user_segment),
                      '-',
                      UPPER(sfdc_users.user_geo),
                      '-',
                      UPPER(sfdc_users.user_region),
                      '-',
                      UPPER(sfdc_users.user_area),
                      '-',
                      sfdc_users.snapshot_fiscal_year
                      )
        WHEN sfdc_users.snapshot_fiscal_year = 2024 AND sfdc_users.user_business_unit IS NULL -- account for nulls/possible data issues
          THEN CONCAT(
                      UPPER(sfdc_users.user_segment),
                      '-',
                      UPPER(sfdc_users.user_geo),
                      '-',
                      UPPER(sfdc_users.user_region),
                      '-',
                      UPPER(sfdc_users.user_area),
                      '-',
                      sfdc_users.snapshot_fiscal_year
                      )
        WHEN sfdc_users.snapshot_fiscal_year >= 2025
          THEN CONCAT(
                      UPPER(sfdc_user_roles_source.name),
                      '-',
                      sfdc_users.snapshot_fiscal_year
                      )
        END                                                                                                                           AS dim_crm_user_hierarchy_sk,
      COALESCE(
               sfdc_users.user_segment_geo_region_area,
               CONCAT(sfdc_users.user_segment,'-' , sfdc_users.user_geo, '-', sfdc_users.user_region, '-', sfdc_users.user_area)
               )                                                                                                                      AS crm_user_sales_segment_geo_region_area,
      sfdc_users.user_segment_region_grouped                                                                                          AS crm_user_sales_segment_region_grouped,
      sheetload_mapping_sdr_sfdc_bamboohr_source.sdr_segment                                                                          AS sdr_sales_segment,
      sheetload_mapping_sdr_sfdc_bamboohr_source.sdr_region,
      sfdc_users.created_date,
         CASE
        WHEN LOWER(sfdc_users.user_business_unit) = 'entg'
          THEN user_geo
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
          AND
            (
            LOWER(sfdc_users.user_segment) = 'smb'
            AND LOWER(sfdc_users.user_geo) = 'amer'
            AND LOWER(sfdc_users.user_area) = 'lowtouch'
            )
          THEN 'AMER Low-Touch'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
          AND
            (
            LOWER(sfdc_users.user_segment) = 'mid-market'
            AND (LOWER(sfdc_users.user_geo) = 'amer' OR LOWER(sfdc_users.user_geo) = 'emea')
            AND LOWER(sfdc_users.user_role_type) = 'first order'
            )
          THEN 'MM First Orders'  --mid-market FO(?)
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
          AND LOWER(sfdc_users.user_geo) = 'emea'
          AND
            (
            LOWER(sfdc_users.user_segment) != 'mid-market'
            AND LOWER(sfdc_users.user_role_type) != 'first order'
            )
          THEN  'EMEA'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
          AND LOWER(sfdc_users.user_geo) = 'amer'
          AND
            (
            LOWER(sfdc_users.user_segment) != 'mid-market'
            AND LOWER(sfdc_users.user_role_type) != 'first order'
            )
          AND
            (
            LOWER(sfdc_users.user_segment) != 'smb'
            AND LOWER(sfdc_users.user_area) != 'lowtouch'
            )
          THEN 'AMER'
        ELSE 'Other'
      END                                                                                                                             AS crm_user_sub_business_unit,
      -- Division (X-Ray 3rd hierarchy)
      CASE
        WHEN LOWER(sfdc_users.user_business_unit) = 'entg'
          THEN sfdc_users.user_region
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND (LOWER(crm_user_sub_business_unit) = 'amer' OR LOWER(crm_user_sub_business_unit) = 'emea')
              AND LOWER(sfdc_users.user_segment) = 'mid-market'
          THEN 'Mid-Market'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND (LOWER(crm_user_sub_business_unit) = 'amer' OR LOWER(crm_user_sub_business_unit) = 'emea')
              AND LOWER(sfdc_users.user_segment) = 'smb'
          THEN 'SMB'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'mm first orders'
          THEN 'MM First Orders'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'amer low-touch'
          THEN 'AMER Low-Touch'
        ELSE 'Other'
      END                                                                                                                             AS crm_user_division,
      -- ASM (X-Ray 4th hierarchy): definition pending
      CASE
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'amer'
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'emea'
              AND (LOWER(crm_user_division) = 'dach' OR LOWER(crm_user_division) = 'neur' OR LOWER(crm_user_division) = 'seur')
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'emea'
              AND LOWER(crm_user_division) = 'meta'
          THEN sfdc_users.user_segment --- pending/ waiting for Meri?
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'apac'
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'pubsec'
              AND LOWER(crm_user_division) != 'sled'
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'entg'
            AND LOWER(crm_user_sub_business_unit) = 'pubsec'
              AND LOWER(crm_user_division) = 'sled'
          THEN sfdc_users.user_region
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND (LOWER(crm_user_sub_business_unit) = 'amer' OR LOWER(crm_user_sub_business_unit) = 'emea')
          THEN sfdc_users.user_area
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'mm first orders'
          THEN sfdc_users.user_geo
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'amer low-touch'
              AND LOWER(sfdc_users.user_role_type) = 'first order'
          THEN 'LowTouch FO'
        WHEN
          LOWER(sfdc_users.user_business_unit) = 'comm'
            AND LOWER(crm_user_sub_business_unit) = 'amer low-touch'
              AND LOWER(sfdc_users.user_role_type) != 'first order'
          THEN 'LowTouch Pool'
        ELSE 'Other'
      END                                                                                                         AS asm
    FROM sfdc_users
    LEFT JOIN sfdc_user_roles_source
      ON sfdc_users.user_role_id = sfdc_user_roles_source.id
    LEFT JOIN sheetload_mapping_sdr_sfdc_bamboohr_source
      ON sfdc_users.user_id = sheetload_mapping_sdr_sfdc_bamboohr_source.user_id
    LEFT JOIN current_fiscal_year
)
SELECT
      *,
      '@michellecooper'::VARCHAR       AS created_by,
      '@chrissharp'::VARCHAR       AS updated_by,
      '2023-03-10'::DATE        AS model_created_date,
      '2024-03-28'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
                CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".restricted_safe_common_prep.prep_crm_account_daily_snapshot as
WITH map_merged_crm_account AS (
    SELECT *
    FROM "PROD".restricted_safe_common_mapping.map_merged_crm_account
), prep_crm_person AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_person
), sfdc_user_roles_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_user_roles_source
), dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), crm_user AS (
    SELECT *
    FROM
        "PROD".common_prep.prep_crm_user_daily_snapshot
), snapshot_dates AS (
    SELECT *
    FROM dim_date
    WHERE date_actual >= '2020-03-01' and date_actual <= CURRENT_DATE
   -- this filter will only be applied on an incremental run
   AND date_id > (SELECT max(snapshot_id) FROM "PROD".restricted_safe_common_prep.prep_crm_account_daily_snapshot)
), lam_corrections AS (
    SELECT
      snapshot_dates.date_id                  AS snapshot_id,
      dim_parent_crm_account_id               AS dim_parent_crm_account_id,
      dev_count                               AS dev_count,
      estimated_capped_lam                    AS estimated_capped_lam,
      dim_parent_crm_account_sales_segment    AS parent_crm_account_sales_segment
    FROM "PREP".driveload.driveload_lam_corrections_source
    INNER JOIN snapshot_dates
        ON snapshot_dates.date_actual >= valid_from
          AND snapshot_dates.date_actual < COALESCE(valid_to, '9999-12-31'::TIMESTAMP)
), sfdc_account AS (
    SELECT
        md5(cast(coalesce(cast(sfdc_account_snapshots_source.account_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(snapshot_dates.date_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))   AS crm_account_snapshot_id,
        snapshot_dates.date_id                                                                                AS snapshot_id,
        snapshot_dates.date_actual                                                                            AS snapshot_date,
        snapshot_dates.fiscal_year                                                                            AS snapshot_fiscal_year,
        sfdc_account_snapshots_source.*
    FROM
        "PROD".legacy.sfdc_account_snapshots_source
         INNER JOIN snapshot_dates
           ON snapshot_dates.date_actual >= sfdc_account_snapshots_source.dbt_valid_from
           AND snapshot_dates.date_actual < COALESCE(sfdc_account_snapshots_source.dbt_valid_to, '9999-12-31'::TIMESTAMP)
    WHERE account_id IS NOT NULL
      AND snapshot_date > (SELECT MAX(snapshot_date) FROM "PROD".restricted_safe_common_prep.prep_crm_account_daily_snapshot)
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY
          snapshot_id,
          account_id
        ORDER BY dbt_valid_from DESC
        ) = 1
), sfdc_users AS (
    SELECT
      md5(cast(coalesce(cast(sfdc_user_snapshots_source.user_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(snapshot_dates.date_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))    AS crm_user_snapshot_id,
      snapshot_dates.date_id                                                                           AS snapshot_id,
      sfdc_user_snapshots_source.*
    FROM
      "PROD".legacy.sfdc_user_snapshots_source
       INNER JOIN snapshot_dates
         ON snapshot_dates.date_actual >= sfdc_user_snapshots_source.dbt_valid_from
         AND snapshot_dates.date_actual < COALESCE(sfdc_user_snapshots_source.dbt_valid_to, '9999-12-31'::TIMESTAMP)
), sfdc_record_type AS (
    SELECT *
    FROM "PROD".legacy.sfdc_record_type
), pte_scores AS (
    SELECT
      crm_account_id                                                                                           AS account_id,
      score                                                                                                    AS score,
      decile                                                                                                   AS decile,
      score_group                                                                                              AS score_group,
      MIN(score_date)                                                                                          AS valid_from,
      COALESCE(LEAD(valid_from) OVER (PARTITION BY crm_account_id ORDER BY valid_from), DATEADD('day',1,CURRENT_DATE())) AS valid_to,
      CASE
        WHEN ROW_NUMBER() OVER (PARTITION BY crm_account_id ORDER BY valid_from DESC) = 1
          THEN TRUE
        ELSE FALSE
      END                                                                                                      AS is_current
    FROM "PREP".data_science.pte_scores_source
    group by 1,2,3,4
    ORDER BY valid_from, valid_to
), ptc_scores AS (
    SELECT
      crm_account_id                                                                                           AS account_id,
      score                                                                                                    AS score,
      decile                                                                                                   AS decile,
      score_group                                                                                              AS score_group,
      MIN(score_date)                                                                                          AS valid_from,
      COALESCE(LEAD(valid_from) OVER (PARTITION BY crm_account_id ORDER BY valid_from), DATEADD('day',1,CURRENT_DATE())) AS valid_to,
      CASE
        WHEN ROW_NUMBER() OVER (PARTITION BY crm_account_id ORDER BY valid_from DESC) = 1
          THEN TRUE
        ELSE FALSE
      END                                                                                                      AS is_current
    FROM "PREP".data_science.ptc_scores_source
    group by 1,2,3,4
    ORDER BY valid_from, valid_to
), current_fiscal_year AS (
    SELECT fiscal_year
    FROM dim_date
    WHERE date_actual = CURRENT_DATE()
), final AS (
    SELECT
      --crm account information
      sfdc_account.crm_account_snapshot_id,
      sfdc_account.snapshot_id,
      sfdc_account.snapshot_date,
      --primary key
      sfdc_account.account_id                                             AS dim_crm_account_id,
      --surrogate keys
      sfdc_account.ultimate_parent_account_id                             AS dim_parent_crm_account_id,
      sfdc_account.owner_id                                               AS dim_crm_user_id,
      map_merged_crm_account.dim_crm_account_id                           AS merged_to_account_id,
      sfdc_account.record_type_id                                         AS record_type_id,
      account_owner.user_id                                               AS crm_account_owner_id,
      proposed_account_owner.user_id                                      AS proposed_crm_account_owner_id,
      technical_account_manager.user_id                                   AS technical_account_manager_id,
      sfdc_account.executive_sponsor_id,
      sfdc_account.master_record_id,
      prep_crm_person.dim_crm_person_id                                   AS dim_crm_person_primary_contact_id,
      --account people
      account_owner.name                                                  AS account_owner,
      proposed_account_owner.name                                         AS proposed_crm_account_owner,
      technical_account_manager.name                                      AS technical_account_manager,
      -- account owner fields
      account_owner.user_segment                                          AS crm_account_owner_sales_segment,
      account_owner.user_geo                                              AS crm_account_owner_geo,
      account_owner.user_region                                           AS crm_account_owner_region,
      account_owner.user_area                                             AS crm_account_owner_area,
      account_owner.user_segment_geo_region_area                          AS crm_account_owner_sales_segment_geo_region_area,
      account_owner.title                                                 AS crm_account_owner_title,
      sfdc_user_roles_source.name                                         AS crm_account_owner_role,
      ----ultimate parent crm account info
       sfdc_account.ultimate_parent_account_name                          AS parent_crm_account_name,
      --technical account manager attributes
      technical_account_manager.manager_name AS tam_manager,
      --executive sponsor field
      executive_sponsor.name AS executive_sponsor,
      --D&B Fields
      sfdc_account.dnb_match_confidence_score,
      sfdc_account.dnb_match_grade,
      sfdc_account.dnb_connect_company_profile_id,
      sfdc_account.dnb_duns,
      sfdc_account.dnb_global_ultimate_duns,
      sfdc_account.dnb_domestic_ultimate_duns,
      sfdc_account.dnb_exclude_company,
      --6 sense fields
      sfdc_account.has_six_sense_6_qa,
      sfdc_account.risk_rate_guid,
      sfdc_account.six_sense_account_profile_fit,
      sfdc_account.six_sense_account_reach_score,
      sfdc_account.six_sense_account_profile_score,
      sfdc_account.six_sense_account_buying_stage,
      sfdc_account.six_sense_account_numerical_reach_score,
      sfdc_account.six_sense_account_update_date,
      sfdc_account.six_sense_account_6_qa_end_date,
      sfdc_account.six_sense_account_6_qa_age_days,
      sfdc_account.six_sense_account_6_qa_start_date,
      sfdc_account.six_sense_account_intent_score,
      sfdc_account.six_sense_segments,
       --Qualified Fields
      sfdc_account.qualified_days_since_last_activity,
      sfdc_account.qualified_signals_active_session_time,
      sfdc_account.qualified_signals_bot_conversation_count,
      sfdc_account.qualified_condition,
      sfdc_account.qualified_score,
      sfdc_account.qualified_trend,
      sfdc_account.qualified_meetings_booked,
      sfdc_account.qualified_signals_rep_conversation_count,
      sfdc_account.qualified_signals_research_state,
      sfdc_account.qualified_signals_research_score,
      sfdc_account.qualified_signals_session_count,
      sfdc_account.qualified_visitors_count,
      --descriptive attributes
      sfdc_account.account_name                                           AS crm_account_name,
      sfdc_account.account_sales_segment                                  AS parent_crm_account_sales_segment,
      -- Add legacy field to support public company metrics reporting: https://gitlab.com/gitlab-data/analytics/-/issues/20290
      sfdc_account.account_sales_segment_legacy                           AS parent_crm_account_sales_segment_legacy,
      sfdc_account.account_geo                                            AS parent_crm_account_geo,
      sfdc_account.account_region                                         AS parent_crm_account_region,
      sfdc_account.account_area                                           AS parent_crm_account_area,
      sfdc_account.account_territory                                      AS parent_crm_account_territory,
      sfdc_account.account_business_unit                                  AS parent_crm_account_business_unit,
      sfdc_account.account_role_type                                      AS parent_crm_account_role_type,
      CASE
        WHEN sfdc_account.snapshot_fiscal_year < 2024
          THEN CONCAT(
                      UPPER(parent_crm_account_sales_segment),
                      '-',
                      UPPER(parent_crm_account_geo),
                      '-',
                      UPPER(parent_crm_account_region),
                      '-',
                      UPPER(parent_crm_account_area),
                      '-',
                      sfdc_account.snapshot_fiscal_year
                      )
        WHEN sfdc_account.snapshot_fiscal_year = 2024 AND LOWER(parent_crm_account_business_unit) = 'comm'
          THEN CONCAT(
                      UPPER(parent_crm_account_business_unit),
                      '-',
                      UPPER(parent_crm_account_geo),
                      '-',
                      UPPER(parent_crm_account_sales_segment),
                      '-',
                      UPPER(parent_crm_account_region),
                      '-',
                      UPPER(parent_crm_account_area),
                      '-',
                      sfdc_account.snapshot_fiscal_year
                      )
        WHEN sfdc_account.snapshot_fiscal_year = 2024 AND LOWER(parent_crm_account_business_unit) = 'entg'
          THEN CONCAT(
                      UPPER(parent_crm_account_business_unit),
                      '-',
                      UPPER(parent_crm_account_geo),
                      '-',
                      UPPER(parent_crm_account_region),
                      '-',
                      UPPER(parent_crm_account_area),
                      '-',
                      UPPER(parent_crm_account_sales_segment),
                      '-',
                      sfdc_account.snapshot_fiscal_year
                      )
        WHEN sfdc_account.snapshot_fiscal_year = 2024
          AND (parent_crm_account_business_unit IS NOT NULL AND LOWER(parent_crm_account_business_unit) NOT IN ('comm', 'entg'))  -- account for non-sales reps
          THEN CONCAT(
                      UPPER(parent_crm_account_business_unit),
                      '-',
                      UPPER(parent_crm_account_sales_segment),
                      '-',
                      UPPER(parent_crm_account_geo),
                      '-',
                      UPPER(parent_crm_account_region),
                      '-',
                      UPPER(parent_crm_account_area),
                      '-',
                      sfdc_account.snapshot_fiscal_year
                      )
        WHEN sfdc_account.snapshot_fiscal_year = 2024 AND parent_crm_account_business_unit IS NULL -- account for nulls/possible data issues
          THEN CONCAT(
                      UPPER(parent_crm_account_sales_segment),
                      '-',
                      UPPER(parent_crm_account_geo),
                      '-',
                      UPPER(parent_crm_account_region),
                      '-',
                      UPPER(parent_crm_account_area),
                      '-',
                      sfdc_account.snapshot_fiscal_year
                      )
        WHEN sfdc_account.snapshot_fiscal_year >= 2025
          THEN CONCAT(
                      UPPER(account_owner_role),
                      '-',
                      sfdc_account.snapshot_fiscal_year
                      )
        END                                                                                                                           AS dim_crm_parent_account_hierarchy_sk,
      sfdc_account.account_max_family_employee                            AS parent_crm_account_max_family_employee,
      sfdc_account.account_upa_country                                    AS parent_crm_account_upa_country,
      sfdc_account.account_upa_country_name                               AS parent_crm_account_upa_country_name,
      sfdc_account.account_upa_state                                      AS parent_crm_account_upa_state,
      sfdc_account.account_upa_city                                       AS parent_crm_account_upa_city,
      sfdc_account.account_upa_street                                     AS parent_crm_account_upa_street,
      sfdc_account.account_upa_postal_code                                AS parent_crm_account_upa_postal_code,
      sfdc_account.account_employee_count                                 AS crm_account_employee_count,
      sfdc_account.parent_account_industry_hierarchy                      AS parent_crm_account_industry,
      sfdc_account.gtm_strategy                                           AS crm_account_gtm_strategy,
      CASE
        WHEN sfdc_account.account_sales_segment IN ('Large', 'PubSec') THEN 'Large'
        WHEN sfdc_account.account_sales_segment = 'Unknown' THEN 'SMB'
        ELSE sfdc_account.account_sales_segment
      END                                                                 AS parent_crm_account_sales_segment_grouped,
      CASE
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_geo) = 'AMER' AND UPPER(sfdc_account.account_region) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_geo) IN ('AMER', 'LATAM') AND UPPER(sfdc_account.account_region) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_geo) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN sfdc_account.account_geo
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_region) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(sfdc_account.account_sales_segment) IN ('LARGE', 'PUBSEC') AND UPPER(sfdc_account.account_geo) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(sfdc_account.account_sales_segment) NOT IN ('LARGE', 'PUBSEC')
    THEN sfdc_account.account_sales_segment
  ELSE 'Missing segment_region_grouped'
END AS parent_crm_account_segment_region_stamped_grouped,
      CASE
        WHEN LOWER(sfdc_account.gtm_strategy) IN ('account centric', 'account based - net new', 'account based - expand') THEN 'Focus Account'
        ELSE 'Non - Focus Account'
      END                                                                 AS crm_account_focus_account,
      sfdc_account.account_owner_user_segment                             AS crm_account_owner_user_segment,
      sfdc_account.billing_country                                        AS crm_account_billing_country,
      sfdc_account.billing_country_code                                   AS crm_account_billing_country_code,
      sfdc_account.account_type                                           AS crm_account_type,
      sfdc_account.industry                                               AS crm_account_industry,
      sfdc_account.sub_industry                                           AS crm_account_sub_industry,
      sfdc_account.account_owner                                          AS crm_account_owner,
      CASE
         WHEN sfdc_account.account_max_family_employee > 2000 THEN 'Employees > 2K'
         WHEN sfdc_account.account_max_family_employee <= 2000 AND sfdc_account.account_max_family_employee > 1500 THEN 'Employees > 1.5K'
         WHEN sfdc_account.account_max_family_employee <= 1500 AND sfdc_account.account_max_family_employee > 1000  THEN 'Employees > 1K'
         ELSE 'Employees < 1K'
      END                                                                 AS crm_account_employee_count_band,
      sfdc_account.partner_vat_tax_id,
      sfdc_account.account_manager,
      sfdc_account.crm_business_dev_rep_id,
      sfdc_account.dedicated_service_engineer,
      sfdc_account.account_tier,
      sfdc_account.account_tier_notes,
      sfdc_account.license_utilization,
      sfdc_account.support_level,
      sfdc_account.named_account,
      sfdc_account.billing_postal_code,
      sfdc_account.partner_type,
      sfdc_account.partner_status,
      sfdc_account.gitlab_customer_success_project,
      sfdc_account.demandbase_account_list,
      sfdc_account.demandbase_intent,
      sfdc_account.demandbase_page_views,
      sfdc_account.demandbase_score,
      sfdc_account.demandbase_sessions,
      sfdc_account.demandbase_trending_offsite_intent,
      sfdc_account.demandbase_trending_onsite_engagement,
      sfdc_account.account_domains,
      sfdc_account.account_domain_1,
      sfdc_account.account_domain_2,
      sfdc_account.is_locally_managed_account,
      sfdc_account.is_strategic_account,
      sfdc_account.partner_track,
      sfdc_account.partners_partner_type,
      sfdc_account.gitlab_partner_program,
      sfdc_account.zoom_info_company_name,
      sfdc_account.zoom_info_company_revenue,
      sfdc_account.zoom_info_company_employee_count,
      sfdc_account.zoom_info_company_industry,
      sfdc_account.zoom_info_company_city,
      sfdc_account.zoom_info_company_state_province,
      sfdc_account.zoom_info_company_country,
      sfdc_account.account_phone,
      sfdc_account.zoominfo_account_phone,
      sfdc_account.abm_tier,
      sfdc_account.health_number,
      sfdc_account.health_score_color,
      sfdc_account.partner_account_iban_number,
      sfdc_account.gitlab_com_user,
      sfdc_account.zi_technologies                                        AS crm_account_zi_technologies,
      sfdc_account.zoom_info_website                                      AS crm_account_zoom_info_website,
      sfdc_account.zoom_info_company_other_domains                        AS crm_account_zoom_info_company_other_domains,
      sfdc_account.zoom_info_dozisf_zi_id                                 AS crm_account_zoom_info_dozisf_zi_id,
      sfdc_account.zoom_info_parent_company_zi_id                         AS crm_account_zoom_info_parent_company_zi_id,
      sfdc_account.zoom_info_parent_company_name                          AS crm_account_zoom_info_parent_company_name,
      sfdc_account.zoom_info_ultimate_parent_company_zi_id                AS crm_account_zoom_info_ultimate_parent_company_zi_id,
      sfdc_account.zoom_info_ultimate_parent_company_name                 AS crm_account_zoom_info_ultimate_parent_company_name,
      sfdc_account.zoom_info_number_of_developers                         AS crm_account_zoom_info_number_of_developers,
      sfdc_account.zoom_info_total_funding                                AS crm_account_zoom_info_total_funding,
      sfdc_account.forbes_2000_rank,
      sfdc_account.parent_account_industry_hierarchy,
      sfdc_account.crm_sales_dev_rep_id,
      sfdc_account.admin_manual_source_number_of_employees,
      sfdc_account.admin_manual_source_account_address,
      sfdc_account.eoa_sentiment,
      sfdc_account.gs_health_user_engagement,
      sfdc_account.gs_health_cd,
      sfdc_account.gs_health_devsecops,
      sfdc_account.gs_health_ci,
      sfdc_account.gs_health_scm,
      sfdc_account.risk_impact,
      sfdc_account.risk_reason,
      sfdc_account.last_timeline_at_risk_update,
      sfdc_account.last_at_risk_update_comments,
      sfdc_account.bdr_prospecting_status,
      sfdc_account.gs_health_csm_sentiment,
      sfdc_account.bdr_next_steps,
      sfdc_account.bdr_account_research,
      sfdc_account.bdr_account_strategy,
      sfdc_account.account_bdr_assigned_user_role,
      sfdc_account.gs_csm_compensation_pool,
      sfdc_account.groove_notes,
      sfdc_account.groove_engagement_status,
      sfdc_account.groove_inferred_status,
      sfdc_account.compensation_target_account,
      sfdc_account.pubsec_type,
      --degenerative dimensions
      sfdc_account.is_sdr_target_account,
      sfdc_account.is_focus_partner,
      IFF(sfdc_record_type.record_type_label = 'Partner'
          AND sfdc_account.partner_type IN ('Alliance', 'Channel')
          AND sfdc_account.partner_status = 'Authorized',
          TRUE, FALSE)                                                    AS is_reseller,
      sfdc_account.is_jihu_account                                        AS is_jihu_account,
      sfdc_account.is_first_order_available,
      sfdc_account.is_key_account                                         AS is_key_account,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies,'ARE_USED: Jenkins')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_jenkins_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: SVN')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_svn_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Tortoise SVN')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_tortoise_svn_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Google Cloud Platform')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_gcp_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Atlassian')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_atlassian_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: GitHub')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_github_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: GitHub Enterprise')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_github_enterprise_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: AWS')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_aws_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Kubernetes')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_kubernetes_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Apache Subversion')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_apache_subversion_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Apache Subversion (SVN)')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_apache_subversion_svn_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Hashicorp')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_hashicorp_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: Amazon AWS CloudTrail')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_aws_cloud_trail_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: CircleCI')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_circle_ci_present,
      CASE
        WHEN CONTAINS (sfdc_account.zi_technologies, 'ARE_USED: BitBucket')
          THEN 1
        ELSE 0
      END                                                                 AS is_zi_bit_bucket_present,
      sfdc_account.is_excluded_from_zoom_info_enrich,
      --dates
  TO_NUMBER(TO_CHAR(sfdc_account.created_date::DATE,'YYYYMMDD'),'99999999')
                      AS crm_account_created_date_id,
      sfdc_account.created_date                                           AS crm_account_created_date,
  TO_NUMBER(TO_CHAR(sfdc_account.abm_tier_1_date::DATE,'YYYYMMDD'),'99999999')
                   AS abm_tier_1_date_id,
      sfdc_account.abm_tier_1_date,
  TO_NUMBER(TO_CHAR(sfdc_account.abm_tier_2_date::DATE,'YYYYMMDD'),'99999999')
                   AS abm_tier_2_date_id,
      sfdc_account.abm_tier_2_date,
  TO_NUMBER(TO_CHAR(sfdc_account.abm_tier_3_date::DATE,'YYYYMMDD'),'99999999')
                   AS abm_tier_3_date_id,
      sfdc_account.abm_tier_3_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gtm_acceleration_date::DATE,'YYYYMMDD'),'99999999')
             AS gtm_acceleration_date_id,
      sfdc_account.gtm_acceleration_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gtm_account_based_date::DATE,'YYYYMMDD'),'99999999')
            AS gtm_account_based_date_id,
      sfdc_account.gtm_account_based_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gtm_account_centric_date::DATE,'YYYYMMDD'),'99999999')
          AS gtm_account_centric_date_id,
      sfdc_account.gtm_account_centric_date,
  TO_NUMBER(TO_CHAR(sfdc_account.partners_signed_contract_date::DATE,'YYYYMMDD'),'99999999')
     AS partners_signed_contract_date_id,
      CAST(sfdc_account.partners_signed_contract_date AS date)            AS partners_signed_contract_date,
  TO_NUMBER(TO_CHAR(sfdc_account.technical_account_manager_date::DATE,'YYYYMMDD'),'99999999')
    AS technical_account_manager_date_id,
      sfdc_account.technical_account_manager_date,
  TO_NUMBER(TO_CHAR(sfdc_account.customer_since_date::DATE,'YYYYMMDD'),'99999999')
               AS customer_since_date_id,
      sfdc_account.customer_since_date,
  TO_NUMBER(TO_CHAR(sfdc_account.next_renewal_date::DATE,'YYYYMMDD'),'99999999')
                 AS next_renewal_date_id,
      sfdc_account.next_renewal_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gs_first_value_date::DATE,'YYYYMMDD'),'99999999')
               AS gs_first_value_date_id,
      sfdc_account.gs_first_value_date,
  TO_NUMBER(TO_CHAR(sfdc_account.gs_last_csm_activity_date::DATE,'YYYYMMDD'),'99999999')
         AS gs_last_csm_activity_date_id,
      sfdc_account.gs_last_csm_activity_date,
      sfdc_account.bdr_recycle_date,
      sfdc_account.actively_working_start_date,
      --measures
      sfdc_account.count_active_subscription_charges,
      sfdc_account.count_active_subscriptions,
      sfdc_account.count_billing_accounts,
      sfdc_account.count_licensed_users,
      sfdc_account.count_of_new_business_won_opportunities,
      sfdc_account.count_open_renewal_opportunities,
      sfdc_account.count_opportunities,
      sfdc_account.count_products_purchased,
      sfdc_account.count_won_opportunities,
      sfdc_account.count_concurrent_ee_subscriptions,
      sfdc_account.count_ce_instances,
      sfdc_account.count_active_ce_users,
      sfdc_account.count_open_opportunities,
      sfdc_account.count_using_ce,
      sfdc_account.carr_this_account,
      sfdc_account.carr_account_family,
      sfdc_account.potential_users,
      sfdc_account.number_of_licenses_this_account,
      sfdc_account.decision_maker_count_linkedin,
      sfdc_account.number_of_employees,
      crm_user.user_role_type                                             AS user_role_type,
      crm_user.user_role_name                                             AS owner_role,
      IFNULL(lam_corrections.estimated_capped_lam, sfdc_account.lam)      AS parent_crm_account_lam,
      IFNULL(lam_corrections.dev_count, sfdc_account.lam_dev_count)       AS parent_crm_account_lam_dev_count,
      -- PtC and PtE
      pte_scores.score                                               AS pte_score,
      pte_scores.decile                                              AS pte_decile,
      pte_scores.score_group                                         AS pte_score_group,
      ptc_scores.score                                               AS ptc_score,
      ptc_scores.decile                                              AS ptc_decile,
      ptc_scores.score_group                                         AS ptc_score_group,
      sfdc_account.ptp_insights                                      AS ptp_insights,
      sfdc_account.ptp_score_value                                   AS ptp_score_value,
      sfdc_account.ptp_score                                         AS ptp_score,
      --metadata
      sfdc_account.created_by_id,
      created_by.name                                                     AS created_by_name,
      sfdc_account.last_modified_by_id,
      last_modified_by.name                                               AS last_modified_by_name,
  TO_NUMBER(TO_CHAR(sfdc_account.last_modified_date::DATE,'YYYYMMDD'),'99999999')
                AS last_modified_date_id,
      sfdc_account.last_modified_date,
  TO_NUMBER(TO_CHAR(sfdc_account.last_activity_date::DATE,'YYYYMMDD'),'99999999')
                AS last_activity_date_id,
      sfdc_account.last_activity_date,
      sfdc_account.is_deleted
    FROM sfdc_account
    LEFT JOIN map_merged_crm_account
      ON sfdc_account.account_id = map_merged_crm_account.sfdc_account_id
    LEFT JOIN sfdc_record_type
      ON sfdc_account.record_type_id = sfdc_record_type.record_type_id
    LEFT JOIN prep_crm_person
      ON sfdc_account.primary_contact_id = prep_crm_person.sfdc_record_id
    LEFT OUTER JOIN sfdc_users AS technical_account_manager
      ON sfdc_account.technical_account_manager_id = technical_account_manager.user_id
        AND sfdc_account.snapshot_id = technical_account_manager.snapshot_id
    LEFT JOIN sfdc_users AS account_owner
      ON account_owner.user_id = sfdc_account.owner_id
        AND account_owner.snapshot_id = sfdc_account.snapshot_id
    LEFT JOIN sfdc_users AS proposed_account_owner
      ON proposed_account_owner.user_id = sfdc_account.proposed_account_owner
        AND proposed_account_owner.snapshot_id = sfdc_account.snapshot_id
    LEFT JOIN sfdc_users AS executive_sponsor
      ON executive_sponsor.user_id = sfdc_account.executive_sponsor_id
        AND executive_sponsor.snapshot_id = sfdc_account.snapshot_id
    LEFT JOIN lam_corrections
      ON sfdc_account.ultimate_parent_account_id = lam_corrections.dim_parent_crm_account_id
        AND sfdc_account.snapshot_id = lam_corrections.snapshot_id
        AND sfdc_account.account_sales_segment = lam_corrections.parent_crm_account_sales_segment
    LEFT JOIN sfdc_users AS created_by
      ON sfdc_account.created_by_id = created_by.user_id
        AND sfdc_account.snapshot_id = created_by.snapshot_id
    LEFT JOIN sfdc_users AS last_modified_by
      ON sfdc_account.last_modified_by_id = last_modified_by.user_id
        AND sfdc_account.snapshot_id = last_modified_by.snapshot_id
    LEFT JOIN pte_scores
      ON sfdc_account.account_id = pte_scores.account_id
        AND sfdc_account.snapshot_date >= pte_scores.valid_from::DATE
        AND  sfdc_account.snapshot_date < pte_scores.valid_to::DATE
    LEFT JOIN ptc_scores
      ON sfdc_account.account_id = ptc_scores.account_id
        AND sfdc_account.snapshot_date >= ptc_scores.valid_from::DATE
        AND  sfdc_account.snapshot_date < ptc_scores.valid_to::DATE
    LEFT JOIN crm_user
      ON sfdc_account.owner_id = crm_user.dim_crm_user_id
        AND sfdc_account.snapshot_id = crm_user.snapshot_id
     LEFT JOIN sfdc_user_roles_source
      ON account_owner.user_role_id = sfdc_user_roles_source.id
     LEFT JOIN current_fiscal_year
)
SELECT
      *,
      '@michellecooper'::VARCHAR       AS created_by,
      '@chrissharp'::VARCHAR       AS updated_by,
      '2023-03-27'::DATE        AS model_created_date,
      '2024-03-25'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
                CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".restricted_safe_common_prep.prep_charge as
WITH map_merged_crm_account AS (
    SELECT *
    FROM "PROD".restricted_safe_common_mapping.map_merged_crm_account
), zuora_rate_plan AS (
    SELECT *
    FROM "PREP".zuora.zuora_rate_plan_source
), zuora_rate_plan_charge AS (
    SELECT *
    FROM "PREP".zuora.zuora_rate_plan_charge_source
), zuora_order_action_rate_plan AS (
    SELECT *
    FROM "PREP".zuora_query_api.zuora_query_api_order_action_rate_plan_source
), zuora_order_action AS (
    SELECT *
    FROM "PREP".zuora_order.zuora_order_action_source
), revenue_contract_line AS (
    SELECT *
    FROM "PREP".zuora_revenue.zuora_revenue_revenue_contract_line_source
), zuora_order AS (
    SELECT *
    FROM "PREP".zuora_order.zuora_order_source
), charge_contractual_value AS (
    SELECT *
    FROM "PREP".zuora_query_api.zuora_query_api_charge_contractual_value_source
), booking_transaction AS (
    SELECT *
    FROM "PREP".zuora.zuora_booking_transaction_source
)
, sfdc_account AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_account_source
    WHERE account_id IS NOT NULL
), zuora_account AS (
    SELECT *
    FROM "PREP".zuora.zuora_account_source
    WHERE is_deleted = FALSE
    --Exclude Batch20 which are the test accounts. This method replaces the manual dbt seed exclusion file.
      AND LOWER(batch) != 'batch20'
), zuora_subscription AS (
    SELECT *
    FROM "PREP".zuora.zuora_subscription_source
    WHERE is_deleted = FALSE
      AND exclude_from_analysis IN ('False', '')
), active_zuora_subscription AS (
    SELECT *
    FROM zuora_subscription
    WHERE subscription_status IN ('Active', 'Cancelled')
), mje AS (
    SELECT
      *,
      CASE
        WHEN debit_activity_type = 'Revenue' AND  credit_activity_type = 'Contract Liability'
          THEN -amount
        WHEN credit_activity_type = 'Revenue' AND  debit_activity_type = 'Contract Liability'
          THEN amount
        ELSE amount
      END                                                                                       AS adjustment_amount
    FROM "PREP".zuora_revenue.zuora_revenue_manual_journal_entry_source
), true_up_lines_dates AS (
    SELECT
      subscription_name,
      revenue_contract_line_attribute_16,
      MIN(revenue_start_date)               AS revenue_start_date,
      MAX(revenue_end_date)                 AS revenue_end_date
    FROM revenue_contract_line
    GROUP BY 1,2
), true_up_lines AS (
    SELECT
      revenue_contract_line_id,
      revenue_contract_id,
      zuora_account.account_id                                  AS dim_billing_account_id,
      map_merged_crm_account.dim_crm_account_id                 AS dim_crm_account_id,
      MD5(rate_plan_charge_id)                                  AS dim_charge_id,
      active_zuora_subscription.subscription_id                 AS dim_subscription_id,
      active_zuora_subscription.subscription_name               AS subscription_name,
      active_zuora_subscription.subscription_status             AS subscription_status,
      product_rate_plan_charge_id                               AS dim_product_detail_id,
      true_up_lines_dates.revenue_start_date                    AS revenue_start_date,
      true_up_lines_dates.revenue_end_date                      AS revenue_end_date,
      revenue_contract_line.revenue_contract_line_created_date  AS revenue_contract_line_created_date,
      revenue_contract_line.revenue_contract_line_updated_date  AS revenue_contract_line_updated_date
    FROM revenue_contract_line
    INNER JOIN active_zuora_subscription
      ON revenue_contract_line.subscription_name = active_zuora_subscription.subscription_name
    INNER JOIN zuora_account
      ON revenue_contract_line.customer_number = zuora_account.account_number
    LEFT JOIN map_merged_crm_account
      ON zuora_account.crm_id = map_merged_crm_account.sfdc_account_id
    LEFT JOIN true_up_lines_dates
      ON revenue_contract_line.subscription_name = true_up_lines_dates.subscription_name
        AND revenue_contract_line.revenue_contract_line_attribute_16 = true_up_lines_dates.revenue_contract_line_attribute_16
    WHERE revenue_contract_line.revenue_contract_line_attribute_16 LIKE '%True-up ARR Allocation%'
), mje_summed AS (
    SELECT
      mje.revenue_contract_line_id,
      SUM(adjustment_amount) AS adjustment
    FROM mje
    INNER JOIN true_up_lines
      ON mje.revenue_contract_line_id = true_up_lines.revenue_contract_line_id
        AND mje.revenue_contract_id = true_up_lines.revenue_contract_id
    group by 1
), true_up_lines_subcription_grain AS (
    SELECT
      lns.dim_billing_account_id,
      lns.dim_crm_account_id,
      lns.dim_charge_id,
      lns.dim_subscription_id,
      lns.subscription_name,
      lns.subscription_status,
      lns.dim_product_detail_id,
      MIN(lns.revenue_contract_line_created_date)   AS revenue_contract_line_created_date,
      MAX(lns.revenue_contract_line_updated_date)   AS revenue_contract_line_updated_date,
      SUM(mje.adjustment)                           AS adjustment,
      MIN(revenue_start_date)                       AS revenue_start_date,
      MAX(revenue_end_date)                         AS revenue_end_date
    FROM true_up_lines lns
    LEFT JOIN mje_summed mje
      ON lns.revenue_contract_line_id = mje.revenue_contract_line_id
    WHERE adjustment IS NOT NULL
      AND ABS(ROUND(adjustment,5)) > 0
    group by 1,2,3,4,5,6,7
), charge_to_order AS (
    SELECT
      zuora_rate_plan_charge.rate_plan_charge_id,
      zuora_order_action.order_id
    FROM zuora_rate_plan
    INNER JOIN zuora_rate_plan_charge
      ON zuora_rate_plan.rate_plan_id = zuora_rate_plan_charge.rate_plan_id
    INNER JOIN zuora_order_action_rate_plan
      ON zuora_rate_plan.rate_plan_id = zuora_order_action_rate_plan.rate_plan_id
    INNER JOIN zuora_order_action
      ON zuora_order_action_rate_plan.order_action_id = zuora_order_action.order_action_id
    group by 1,2
), non_manual_charges AS (
    SELECT
      --Natural Key
      zuora_subscription.subscription_name,
      zuora_subscription.subscription_name_slugify,
      zuora_subscription.version                                        AS subscription_version,
      zuora_subscription.created_by_id                                  AS subscription_created_by_id,
      zuora_rate_plan_charge.rate_plan_charge_number,
      zuora_rate_plan_charge.version                                    AS rate_plan_charge_version,
      zuora_rate_plan_charge.segment                                    AS rate_plan_charge_segment,
      --Surrogate Key
      zuora_rate_plan_charge.rate_plan_charge_id                        AS dim_charge_id,
      --Common Dimension Keys
      zuora_rate_plan_charge.product_rate_plan_charge_id                AS dim_product_detail_id,
      zuora_rate_plan.amendement_id                                     AS dim_amendment_id_charge,
      zuora_rate_plan.subscription_id                                   AS dim_subscription_id,
      zuora_rate_plan_charge.account_id                                 AS dim_billing_account_id,
      map_merged_crm_account.dim_crm_account_id                         AS dim_crm_account_id,
      sfdc_account.ultimate_parent_account_id                           AS dim_parent_crm_account_id,
      charge_to_order.order_id                                          AS dim_order_id,
  TO_NUMBER(TO_CHAR(zuora_rate_plan_charge.effective_start_date::DATE,'YYYYMMDD'),'99999999')
  AS effective_start_date_id,
  TO_NUMBER(TO_CHAR(zuora_rate_plan_charge.effective_end_date::DATE,'YYYYMMDD'),'99999999')
    AS effective_end_date_id,
      --Information
      zuora_subscription.subscription_status                            AS subscription_status,
      zuora_rate_plan.rate_plan_name                                    AS rate_plan_name,
      zuora_rate_plan_charge.rate_plan_charge_name,
      zuora_rate_plan_charge.description                                AS rate_plan_charge_description,
      zuora_rate_plan_charge.is_last_segment,
      zuora_rate_plan_charge.discount_level,
      zuora_rate_plan_charge.charge_type,
      zuora_rate_plan.amendement_type                                   AS rate_plan_charge_amendement_type,
      zuora_rate_plan_charge.unit_of_measure,
      CASE
        WHEN DATE_TRUNC('month',zuora_rate_plan_charge.charged_through_date) = zuora_rate_plan_charge.effective_end_month::DATE
          THEN TRUE ELSE FALSE
      END                                                               AS is_paid_in_full,
      CASE
        WHEN charged_through_date IS NULL THEN zuora_subscription.current_term
        ELSE DATEDIFF('month',DATE_TRUNC('month', zuora_rate_plan_charge.charged_through_date::DATE), zuora_rate_plan_charge.effective_end_month::DATE)
      END                                                               AS months_of_future_billings,
      CASE
        WHEN effective_end_month > effective_start_month OR effective_end_month IS NULL
          THEN TRUE
        ELSE FALSE
      END                                                               AS is_included_in_arr_calc,
      --Dates
      zuora_subscription.subscription_start_date                        AS subscription_start_date,
      zuora_subscription.subscription_end_date                          AS subscription_end_date,
      zuora_rate_plan_charge.effective_start_date::DATE                 AS effective_start_date,
      zuora_rate_plan_charge.effective_end_date::DATE                   AS effective_end_date,
      zuora_rate_plan_charge.effective_start_month::DATE                AS effective_start_month,
      zuora_rate_plan_charge.effective_end_month::DATE                  AS effective_end_month,
      zuora_rate_plan_charge.charged_through_date::DATE                 AS charged_through_date,
      zuora_rate_plan_charge.created_date::DATE                         AS charge_created_date,
      zuora_rate_plan_charge.updated_date::DATE                         AS charge_updated_date,
      DATEDIFF(month, zuora_rate_plan_charge.effective_start_month::DATE, zuora_rate_plan_charge.effective_end_month::DATE)
                                                                        AS charge_term,
      zuora_rate_plan_charge.billing_period,
      zuora_rate_plan_charge.specific_billing_period,
      --Additive Fields
      zuora_rate_plan_charge.mrr,
      LAG(zuora_rate_plan_charge.mrr,1) OVER (PARTITION BY zuora_subscription.subscription_name, zuora_rate_plan_charge.rate_plan_charge_number
                                              ORDER BY zuora_rate_plan_charge.segment, zuora_subscription.version)
                                                                        AS previous_mrr_calc,
      CASE
        WHEN previous_mrr_calc IS NULL
          THEN 0 ELSE previous_mrr_calc
      END                                                               AS previous_mrr,
      zuora_rate_plan_charge.mrr - previous_mrr                         AS delta_mrr_calc,
      CASE
        WHEN LOWER(subscription_status) = 'active' AND subscription_end_date <= CURRENT_DATE AND is_last_segment = TRUE
          THEN -previous_mrr
        WHEN LOWER(subscription_status) = 'cancelled' AND is_last_segment = TRUE
          THEN -previous_mrr
        ELSE delta_mrr_calc
      END                                                               AS delta_mrr,
      zuora_rate_plan_charge.delta_mrc,
      zuora_rate_plan_charge.mrr * 12                                   AS arr,
      previous_mrr * 12                                                 AS previous_arr,
      zuora_rate_plan_charge.delta_mrc * 12                             AS delta_arc,
      delta_mrr * 12                                                    AS delta_arr,
      booking_transaction.list_price,
      charge_contractual_value.elp                                      AS extended_list_price,
      zuora_rate_plan_charge.quantity,
      LAG(zuora_rate_plan_charge.quantity,1) OVER (PARTITION BY zuora_subscription.subscription_name, zuora_rate_plan_charge.rate_plan_charge_number
                                                   ORDER BY zuora_rate_plan_charge.segment, zuora_subscription.version)
                                                                        AS previous_quantity_calc,
      CASE
        WHEN previous_quantity_calc IS NULL
          THEN 0 ELSE previous_quantity_calc
      END                                                               AS previous_quantity,
      zuora_rate_plan_charge.quantity - previous_quantity               AS delta_quantity_calc,
      CASE
        WHEN LOWER(subscription_status) = 'active' AND subscription_end_date <= CURRENT_DATE AND is_last_segment = TRUE
          THEN -previous_quantity
        WHEN LOWER(subscription_status) = 'cancelled' AND is_last_segment = TRUE
          THEN -previous_quantity
        ELSE delta_quantity_calc
      END                                                               AS delta_quantity,
      zuora_rate_plan_charge.tcv,
      zuora_rate_plan_charge.delta_tcv,
      CASE
        WHEN is_paid_in_full = FALSE THEN months_of_future_billings * zuora_rate_plan_charge.mrr
        ELSE 0
      END                                                               AS estimated_total_future_billings,
      0                                                                 AS is_manual_charge
    FROM zuora_rate_plan
    INNER JOIN zuora_rate_plan_charge
      ON zuora_rate_plan.rate_plan_id = zuora_rate_plan_charge.rate_plan_id
    INNER JOIN zuora_subscription
      ON zuora_rate_plan.subscription_id = zuora_subscription.subscription_id
    INNER JOIN zuora_account
      ON zuora_subscription.account_id = zuora_account.account_id
    LEFT JOIN map_merged_crm_account
      ON zuora_account.crm_id = map_merged_crm_account.sfdc_account_id
    LEFT JOIN sfdc_account
      ON map_merged_crm_account.dim_crm_account_id = sfdc_account.account_id
    LEFT JOIN charge_to_order
      ON zuora_rate_plan_charge.rate_plan_charge_id = charge_to_order.rate_plan_charge_id
    LEFT JOIN charge_contractual_value
      ON charge_contractual_value.rate_plan_charge_id = zuora_rate_plan_charge.rate_plan_charge_id
    LEFT JOIN booking_transaction
      ON booking_transaction.rate_plan_charge_id = zuora_rate_plan_charge.rate_plan_charge_id
 ), manual_charges_prep AS (
    SELECT
      dim_billing_account_id,
      dim_crm_account_id,
      dim_charge_id,
      dim_subscription_id,
      subscription_name,
      subscription_status,
      dim_product_detail_id,
      revenue_contract_line_created_date,
      revenue_contract_line_updated_date,
      adjustment/ROUND(MONTHS_BETWEEN(revenue_end_date::date, revenue_start_date::date),0)  AS mrr,
      NULL                                                                                  AS delta_tcv,
      'Seats'                                                                               AS unit_of_measure,
      0                                                                                     AS quantity,
      revenue_start_date::DATE                                                              AS effective_start_date,
      DATEADD('day',1,revenue_end_date::DATE)                                               AS effective_end_date
    FROM true_up_lines_subcription_grain
), manual_charges AS (
    SELECT
      active_zuora_subscription.subscription_name                                           AS subscription_name,
      active_zuora_subscription.subscription_name_slugify                                   AS subscription_name_slugify,
      active_zuora_subscription.version                                                     AS subscription_version,
      active_zuora_subscription.created_by_id                                               AS subscription_created_by_id,
      NULL                                                                                  AS rate_plan_charge_number,
      NULL                                                                                  AS rate_plan_charge_version,
      NULL                                                                                  AS rate_plan_charge_segment,
      manual_charges_prep.dim_charge_id                                                     AS dim_charge_id,
      manual_charges_prep.dim_product_detail_id                                             AS dim_product_detail_id,
      NULL                                                                                  AS dim_amendment_id_charge,
      active_zuora_subscription.subscription_id                                             AS dim_subscription_id,
      manual_charges_prep.dim_billing_account_id                                            AS dim_billing_account_id,
      zuora_account.crm_id                                                                  AS dim_crm_account_id,
      sfdc_account.ultimate_parent_account_id                                               AS dim_parent_crm_account_id,
      MD5(-1)                                                                               AS dim_order_id,
  TO_NUMBER(TO_CHAR(manual_charges_prep.effective_start_date::DATE,'YYYYMMDD'),'99999999')
                         AS effective_start_date_id,
  TO_NUMBER(TO_CHAR(manual_charges_prep.effective_end_date::DATE,'YYYYMMDD'),'99999999')
                           AS effective_end_date_id,
      active_zuora_subscription.subscription_status                                         AS subscription_status,
      'manual true up allocation'                                                           AS rate_plan_name,
      'manual true up allocation'                                                           AS rate_plan_charge_name,
      'manual true up allocation'                                                           AS rate_plan_charge_description,
      'TRUE'                                                                                AS is_last_segment,
      NULL                                                                                  AS discount_level,
      'Recurring'                                                                           AS charge_type,
      NULL                                                                                  AS rate_plan_charge_amendement_type,
      manual_charges_prep.unit_of_measure                                                   AS unit_of_measure,
      'TRUE'                                                                                AS is_paid_in_full,
      active_zuora_subscription.current_term                                                AS months_of_future_billings,
      CASE
        WHEN DATE_TRUNC('month', effective_end_date) > DATE_TRUNC('month', effective_start_date) OR DATE_TRUNC('month', effective_end_date) IS NULL
          THEN TRUE
        ELSE FALSE
      END                                                                                   AS is_included_in_arr_calc,
      active_zuora_subscription.subscription_start_date                                     AS subscription_start_date,
      active_zuora_subscription.subscription_end_date                                       AS subscription_end_date,
      effective_start_date                                                                  AS effective_start_date,
      effective_end_date                                                                    AS effective_end_date,
      DATE_TRUNC('month', effective_start_date)                                             AS effective_start_month,
      DATE_TRUNC('month', effective_end_date)                                               AS effective_end_month,
      DATEADD('day',1,effective_end_date)                                                   AS charged_through_date,
      revenue_contract_line_created_date                                                    AS charge_created_date,
      revenue_contract_line_updated_date                                                    AS charge_updated_date,
      DATEDIFF('month', effective_start_month::DATE, effective_end_month::DATE)             AS charge_term,
      NULL                                                                                  AS billing_period,
      NULL                                                                                  AS specific_billing_period,
      manual_charges_prep.mrr                                                               AS mrr,
      NULL                                                                                  AS previous_mrr_calc,
      NULL                                                                                  AS previous_mrr,
      NULL                                                                                  AS delta_mrr_calc,
      NULL                                                                                  AS delta_mrr,
      NULL                                                                                  AS delta_mrc,
      manual_charges_prep.mrr * 12                                                          AS arr,
      NULL                                                                                  AS previous_arr,
      NULL                                                                                  AS delta_arc,
      NULL                                                                                  AS delta_arr,
      NULL                                                                                  AS list_price,
      NULL                                                                                  AS extended_list_price,
      0                                                                                     AS quantity,
      NULL                                                                                  AS previous_quantity_calc,
      NULL                                                                                  AS previous_quantity,
      NULL                                                                                  AS delta_quantity_calc,
      NULL                                                                                  AS delta_quantity,
      NULL                                                                                  AS tcv,
      NULL                                                                                  AS delta_tcv,
      CASE
        WHEN is_paid_in_full = FALSE THEN months_of_future_billings * manual_charges_prep.mrr
        ELSE 0
      END                                                                                   AS estimated_total_future_billings,
      1                                                                                     AS is_manual_charge
    FROM manual_charges_prep
    INNER JOIN active_zuora_subscription
      ON manual_charges_prep.subscription_name = active_zuora_subscription.subscription_name
    INNER JOIN zuora_account
      ON active_zuora_subscription.account_id = zuora_account.account_id
    LEFT JOIN map_merged_crm_account
      ON zuora_account.crm_id = map_merged_crm_account.sfdc_account_id
    LEFT JOIN sfdc_account
      ON map_merged_crm_account.dim_crm_account_id = sfdc_account.account_id
), combined_charges AS (
    SELECT *
    FROM non_manual_charges
    UNION
    SELECT *
    FROM manual_charges
), arr_analysis_framework AS (
    SELECT
      combined_charges.*,
      CASE
        WHEN subscription_version = 1
          THEN 'New'
        WHEN LOWER(subscription_status) = 'active' AND subscription_end_date <= CURRENT_DATE
          THEN 'Churn'
        WHEN LOWER(subscription_status) = 'cancelled'
          THEN 'Churn'
        WHEN arr < previous_arr AND arr > 0
          THEN 'Contraction'
        WHEN arr > previous_arr AND subscription_version > 1
          THEN 'Expansion'
        WHEN arr = previous_arr
          THEN 'No Impact'
        ELSE NULL
      END                 AS type_of_arr_change
    FROM combined_charges
)
SELECT
      *,
      '@iweeks'::VARCHAR       AS created_by,
      '@apiaseczna'::VARCHAR       AS updated_by,
      '2021-04-28'::DATE        AS model_created_date,
      '2024-07-18'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM arr_analysis_framework;

CREATE TABLE "PROD".restricted_safe_common_prep.prep_sales_funnel_target as
WITH dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), sheetload_sales_targets_source AS (
    SELECT *
    FROM "PREP".sheetload.sheetload_sales_targets_source
)
, fiscal_months AS (
    SELECT DISTINCT
      fiscal_year,
      first_day_of_month
    FROM dim_date
), final AS (
    SELECT
      CASE WHEN sheetload_sales_targets_source.kpi_name = 'Net ARR Company'
        THEN 'Net ARR'
      WHEN fiscal_months.fiscal_year = 2024 AND sheetload_sales_targets_source.kpi_name = 'Net ARR'
        THEN 'Net ARR - Stretch'
      ELSE sheetload_sales_targets_source.kpi_name
      END                                                      AS kpi_name,
      sheetload_sales_targets_source.month,
      sheetload_sales_targets_source.sales_qualified_source,
      sheetload_sales_targets_source.order_type,
      sheetload_sales_targets_source.area,
      sheetload_sales_targets_source.allocated_target,
      sheetload_sales_targets_source.user_segment,
      sheetload_sales_targets_source.user_geo,
      sheetload_sales_targets_source.user_region,
      sheetload_sales_targets_source.user_area,
      sheetload_sales_targets_source.user_business_unit,
      sheetload_sales_targets_source.user_role_name,
      sheetload_sales_targets_source.role_level_1,
      sheetload_sales_targets_source.role_level_2,
      sheetload_sales_targets_source.role_level_3,
      sheetload_sales_targets_source.role_level_4,
      sheetload_sales_targets_source.role_level_5,
      CASE
        WHEN fiscal_months.fiscal_year = 2024 AND LOWER(sheetload_sales_targets_source.user_business_unit) = 'comm'
          THEN CONCAT(
                      UPPER(sheetload_sales_targets_source.user_business_unit),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_geo),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_segment),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_region),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_area),
                      '-',
                      fiscal_months.fiscal_year
                      )
        WHEN fiscal_months.fiscal_year = 2024 AND LOWER(sheetload_sales_targets_source.user_business_unit) = 'entg'
          THEN CONCAT(
                      UPPER(sheetload_sales_targets_source.user_business_unit),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_geo),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_region),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_area),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_segment),
                      '-',
                      fiscal_months.fiscal_year
                      )
        WHEN fiscal_months.fiscal_year = 2024
          AND (sheetload_sales_targets_source.user_business_unit IS NOT NULL AND LOWER(sheetload_sales_targets_source.user_business_unit) NOT IN ('comm', 'entg')) -- account for non-sales reps
          THEN CONCAT(
                      UPPER(sheetload_sales_targets_source.user_business_unit),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_segment),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_geo),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_region),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_area),
                      '-',
                      fiscal_months.fiscal_year
                      )
        WHEN fiscal_months.fiscal_year = 2024 AND sheetload_sales_targets_source.user_business_unit IS NULL -- account for nulls/possible data issues
          THEN CONCAT(
                      UPPER(sheetload_sales_targets_source.user_segment),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_geo),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_region),
                      '-',
                      UPPER(sheetload_sales_targets_source.user_area),
                      '-',
                      fiscal_months.fiscal_year
                      )
        WHEN fiscal_months.fiscal_year >= 2025
          THEN CONCAT( -- some targets don't use the role hierarchy so we still need to generate a geo key when role_name is null.
                    COALESCE(
                    UPPER(sheetload_sales_targets_source.user_role_name),
                    CONCAT(
                        UPPER(sheetload_sales_targets_source.user_segment),
                        '-',
                        UPPER(sheetload_sales_targets_source.user_geo),
                        '-',
                        UPPER(sheetload_sales_targets_source.user_region),
                        '-',
                        UPPER(sheetload_sales_targets_source.user_area))
                        ),
                    '-',
                    fiscal_months.fiscal_year
                    )
        END                                                                                                                         AS dim_crm_user_hierarchy_sk,
        fiscal_months.fiscal_year,
        fiscal_months.first_day_of_month
    FROM sheetload_sales_targets_source
    INNER JOIN fiscal_months
      ON sheetload_sales_targets_source.month = fiscal_months.first_day_of_month
)
SELECT *
FROM final;

CREATE TABLE "PROD".restricted_safe_common_prep.prep_sfdc_account as
WITH sfdc_account AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_account_source
    WHERE NOT is_deleted
), sfdc_account_with_ultimate_parent AS (
    SELECT
      sfdc_account.account_id                                                                                        AS dim_crm_account_id,
      sfdc_account.ultimate_parent_account_id                                                                        AS ultimate_parent_account_id,
      sfdc_account.account_sales_segment                                                                             AS ultimate_parent_sales_segment_name,
      sfdc_account.parent_account_industry_hierarchy                                                                 AS ultimate_parent_industry,
      sfdc_account.account_territory                                                                    AS ultimate_parent_territory,
      CASE
        WHEN ultimate_parent_sales_segment_name IN ('Large', 'PubSec')
          THEN 'Large'
        ELSE ultimate_parent_sales_segment_name
      END                                                                                                            AS ultimate_parent_sales_segment_grouped,
      sfdc_account.billing_country,
      sfdc_account.industry
    FROM sfdc_account
), final AS (
    SELECT
      dim_crm_account_id                                                                                             AS dim_crm_account_id,
      ultimate_parent_territory                                                                                      AS dim_parent_sales_territory_name_source,
      ultimate_parent_account_id                                                                                     AS dim_parent_crm_account_id,
      ultimate_parent_sales_segment_name                                                                             AS dim_parent_sales_segment_name_source,
      ultimate_parent_sales_segment_grouped                                                                          AS dim_parent_sales_segment_grouped_source,
      industry                                                                                                       AS dim_account_industry_name_source,
      ultimate_parent_industry                                                                                       AS dim_parent_industry_name_source,
      billing_country                                                                                                AS dim_account_location_country_name_source
    FROM sfdc_account_with_ultimate_parent
)
SELECT
      *,
      '@paul_armstrong'::VARCHAR       AS created_by,
      '@lisvinueza'::VARCHAR       AS updated_by,
      '2020-10-30'::DATE        AS model_created_date,
      '2023-05-21'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PREP".data_science.ptc_scores_source as
WITH source AS (
    SELECT *
    FROM "RAW".data_science.ptc_scores
), intermediate AS (
    SELECT
      d.value as data_by_row,
      uploaded_at
    FROM source,
    LATERAL FLATTEN(INPUT => PARSE_JSON(jsontext), outer => true) d
), parsed AS (
    SELECT
      data_by_row['crm_account_id']::VARCHAR                AS crm_account_id,
      data_by_row['score_date']::TIMESTAMP                  AS score_date,
      data_by_row['score']::NUMBER(38,4)                    AS score,
      data_by_row['decile']::INT                            AS decile,
      data_by_row['importance']::INT                        AS importance,
      data_by_row['grouping']::INT                          AS score_group,
      data_by_row['insights']::VARCHAR                      AS insights,
      data_by_row['renewal_date']::TIMESTAMP                AS renewal_date,
      data_by_row['downtier_likely']::BOOLEAN               AS downtier_likely,
      data_by_row['model_version']::FLOAT                   AS model_version,
      uploaded_at::TIMESTAMP                                AS uploaded_at
    FROM intermediate
)
SELECT *
FROM parsed;

CREATE TABLE "PREP".data_science.pte_scores_source as
WITH source AS (
    SELECT *
    FROM "RAW".data_science.pte_scores
), intermediate AS (
    SELECT
      d.value as data_by_row,
      uploaded_at
    FROM source,
    LATERAL FLATTEN(INPUT => PARSE_JSON(jsontext), outer => true) d
), parsed AS (
    SELECT
      data_by_row['crm_account_id']::VARCHAR                AS crm_account_id,
      data_by_row['score_date']::TIMESTAMP                  AS score_date,
      data_by_row['score']::NUMBER(38,4)                    AS score,
      data_by_row['decile']::INT                            AS decile,
      data_by_row['importance']::INT                        AS importance,
      data_by_row['grouping']::INT                          AS score_group,
      data_by_row['insights']::VARCHAR                      AS insights,
      data_by_row['model_version']::FLOAT                   AS model_version,
      uploaded_at::TIMESTAMP                                AS uploaded_at,
      data_by_row['uptier_likely']::BOOLEAN                 AS uptier_likely
    FROM intermediate
)
SELECT *
FROM parsed;

CREATE TABLE "PREP".sfdc.sfdc_bizible_touchpoint_source as
WITH source AS (
  SELECT *
  FROM "RAW".salesforce_v2_stitch.bizible2__bizible_touchpoint__c
), renamed AS (
    SELECT
      id                                      AS touchpoint_id,
      bizible2__bizible_person__c             AS bizible_person_id,
      -- sfdc object lookups
      bizible2__sf_campaign__c                AS campaign_id,
      bizible2__contact__c                    AS bizible_contact,
      bizible2__account__c                    AS bizible_account,
      -- attribution counts
      bizible2__count_first_touch__c          AS bizible_count_first_touch,
      bizible2__count_lead_creation_touch__c  AS bizible_count_lead_creation_touch,
      bizible2__count_u_shaped__c             AS bizible_count_u_shaped,
      -- touchpoint info
      bizible2__touchpoint_date__c            AS bizible_touchpoint_date,
      bizible2__touchpoint_position__c        AS bizible_touchpoint_position,
      bizible2__touchpoint_source__c          AS bizible_touchpoint_source,
      source_type__c                          AS bizible_touchpoint_source_type,
      bizible2__touchpoint_type__c            AS bizible_touchpoint_type,
      bizible2__ad_campaign_name__c           AS bizible_ad_campaign_name,
      bizible2__ad_content__c                 AS bizible_ad_content,
      bizible2__ad_group_name__c              AS bizible_ad_group_name,
      bizible2__form_url__c                   AS bizible_form_url,
      bizible2__form_url_raw__c               AS bizible_form_url_raw,
      bizible2__landing_page__c               AS bizible_landing_page,
      bizible2__landing_page_raw__c           AS bizible_landing_page_raw,
      bizible2__marketing_channel__c          AS bizible_marketing_channel,
      bizible2__marketing_channel_path__c     AS bizible_marketing_channel_path,
      bizible2__medium__c                     AS bizible_medium,
      bizible2__referrer_page__c              AS bizible_referrer_page,
      bizible2__referrer_page_raw__c          AS bizible_referrer_page_raw,
      bizible2__sf_campaign__c                AS bizible_salesforce_campaign,
      NULL                                    AS utm_budget,
      NULL                                    AS utm_offersubtype,
      NULL                                    AS utm_offertype,
      NULL                                    AS utm_targetregion,
      NULL                                    AS utm_targetsubregion,
      NULL                                    AS utm_targetterritory,
      NULL                                    AS utm_usecase,
      CASE
        WHEN SPLIT_PART(SPLIT_PART(bizible_form_url_raw,'utm_content=',2),'&',1)IS null
          THEN SPLIT_PART(SPLIT_PART(bizible_landing_page_raw,'utm_content=',2),'&',1)
        ELSE SPLIT_PART(SPLIT_PART(bizible_form_url_raw,'utm_content=',2),'&',1)
      END AS utm_content,
      isdeleted                               AS is_deleted,
      createddate                             AS bizible_created_date
    FROM source
)
SELECT *
FROM renamed
-- exclude records containing strings which cannot be parsed from the bizible_touchpoint lineage https://gitlab.com/gitlab-data/analytics/-/issues/18230 https://gitlab.com/gitlab-data/analytics/-/merge_requests/8744#note_1544239076
WHERE (bizible_form_url_raw LIKE 'http%' OR bizible_form_url_raw IS NULL)
  AND (bizible_landing_page_raw LIKE 'http%' OR bizible_landing_page_raw IS NULL);

CREATE TABLE "PREP".sfdc.sfdc_users_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.user
), renamed AS(
    SELECT
      -- ids
      id                                                                AS user_id,
      name                                                              AS name,
      email                                                             AS user_email,
      employeenumber                                                    AS employee_number,
      profileid                                                         AS profile_id,
      username                                                          AS user_name,
      -- info
      title                                                             AS title,
      team__c                                                           AS team,
      department                                                        AS department,
      managerid                                                         AS manager_id,
      manager_name__c                                                   AS manager_name,
      isactive                                                          AS is_active,
      userroleid                                                        AS user_role_id,
      user_role_type__c                                                 AS user_role_type,
      role_level_1__c                                                   AS user_role_level_1,
      role_level_2__c                                                   AS user_role_level_2,
      role_level_3__c                                                   AS user_role_level_3,
      role_level_4__c                                                   AS user_role_level_4,
      role_level_5__c                                                   AS user_role_level_5,
      start_date__c                                                     AS start_date,
      ramping_quota__c                                                  AS ramping_quota,
      CASE WHEN LOWER(user_segment__c) = 'smb' THEN 'SMB'
     WHEN LOWER(user_segment__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(user_segment__c) = 'public sector' THEN 'PubSec'
     WHEN LOWER(user_segment__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(user_segment__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(user_segment__c) IS NULL THEN 'SMB'
     WHEN LOWER(user_segment__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(user_segment__c) = 'lrg' THEN 'Large'
     WHEN LOWER(user_segment__c) = 'jihu' THEN 'JiHu'
     WHEN user_segment__c IS NOT NULL THEN user_segment__c
END   AS user_segment,
      user_geo__c                                                       AS user_geo,
      user_region__c                                                    AS user_region,
      user_area__c                                                      AS user_area,
      user_business_unit__c                                             AS user_business_unit,
      user_segment_geo_region_area__c                                   AS user_segment_geo_region_area,
      timezonesidkey                                                    AS user_timezone,
      CASE
        WHEN user_segment IN ('Large', 'PubSec') THEN 'Large'
        ELSE user_segment
      END                                                               AS user_segment_grouped,
      CASE
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo) = 'AMER' AND UPPER(user_region) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo) IN ('AMER', 'LATAM') AND UPPER(user_region) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN user_geo
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_region) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(user_segment) NOT IN ('LARGE', 'PUBSEC')
    THEN user_segment
  ELSE 'Missing segment_region_grouped'
END
                                                                        AS user_segment_region_grouped,
      hybrid__c                                                         AS is_hybrid_user,
      --metadata
      createdbyid                                                       AS created_by_id,
      createddate                                                       AS created_date,
      lastmodifiedbyid                                                  AS last_modified_id,
      lastmodifieddate                                                  AS last_modified_date,
      systemmodstamp,
      --dbt last run
      convert_timezone('America/Los_Angeles',convert_timezone('UTC',current_timestamp())) AS _last_dbt_run
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_campaign_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.campaign
), renamed AS(
    SELECT
        id                                                                  AS campaign_id,
        name                                                                AS campaign_name,
        isactive                                                            AS is_active,
        startdate                                                           AS start_date,
        enddate                                                             AS end_date,
        status                                                              AS status,
        IFF(type LIKE 'Field Event%', 'Field Event', type)                  AS type,
        --keys
        campaignmemberrecordtypeid                                          AS campaign_member_record_type_id,
        ownerid                                                             AS campaign_owner_id,
        parentid                                                            AS campaign_parent_id,
        --info
        description                                                         AS description,
        region__c                                                           AS region,
        sub_region__c                                                       AS sub_region,
        budget_holder__c                                                    AS budget_holder,
        will_there_be_mdf_funding__c                                        AS will_there_be_mdf_funding,
        mdf_request__c                                                      AS mdf_request_id,
        vartopiadrs__partner_account__c                                     AS campaign_partner_crm_id,
        --projections
        budgetedcost                                                        AS budgeted_cost,
        expectedresponse                                                    AS expected_response,
        expectedrevenue                                                     AS expected_revenue,
        bizible2__bizible_attribution_synctype__c                           AS bizible_touchpoint_enabled_setting,
        allocadia_id__c                                                     AS allocadia_id,
        is_a_channel_partner_involved__c                                    AS is_a_channel_partner_involved,
        is_an_alliance_partner_involved__c                                  AS is_an_alliance_partner_involved,
        in_person_virtual__c                                                AS is_this_an_in_person_event,
        alliance_partner_name__c                                            AS alliance_partner_name,
        channel_partner_name__c                                             AS channel_partner_name,
        sales_play__c                                                       AS sales_play,
        gtm_motion__c                                                       AS gtm_motion,
        total_planned_mql__c                                                AS total_planned_mqls,
        registration_goal__c                                                AS registration_goal,
        attendance_goal__c                                                  AS attendance_goal,
        --planned results
        planned_inquiry__c                                                  AS planned_inquiry,
        planned_mql__c                                                      AS planned_mql,
        planned_pipeline__c                                                 AS planned_pipeline,
        planned_sao__c                                                      AS planned_sao,
        planned_won__c                                                      AS planned_won,
        total_planned_mql__c                                                AS total_planned_mql,
        pipeline_roi__c                                                     AS planned_roi,
        --results
        actualcost                                                          AS actual_cost,
        amountallopportunities                                              AS amount_all_opportunities,
        amountwonopportunities                                              AS amount_won_opportunities,
        numberofcontacts                                                    AS count_contacts,
        numberofconvertedleads                                              AS count_converted_leads,
        numberofleads                                                       AS count_leads,
        numberofopportunities                                               AS count_opportunities,
        numberofresponses                                                   AS count_responses,
        numberofwonopportunities                                            AS count_won_opportunities,
        numbersent                                                          AS count_sent,
        strat_contribution__c                                               AS strategic_marketing_contribution,
        large_bucket__c                                                     AS large_bucket,
        NULL                                                                AS reporting_type,
        --metadata
        createddate                                                         AS created_date,
        createdbyid                                                         AS created_by_id,
        lastmodifiedbyid                                                    AS last_modified_by_id,
        lastmodifieddate                                                    AS last_modified_date,
        lastactivitydate                                                    AS last_activity_date,
        systemmodstamp,
        isdeleted                                                           AS is_deleted
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_account_source as
/*
  ATTENTION: When a field is added to this live model, add it to the SFDC_ACCOUNT_SNAPSHOTS_SOURCE model to keep the live and snapshot models in alignment.
*/
WITH source AS (
  SELECT *
  FROM "RAW".salesforce_v2_stitch.account
),
renamed AS (
  SELECT
    id                                                                                AS account_id,
    name                                                                              AS account_name,
    -- keys
    account_id_18__c                                                                  AS account_id_18,
    masterrecordid                                                                    AS master_record_id,
    ownerid                                                                           AS owner_id,
    parentid                                                                          AS parent_id,
    primary_contact_id__c                                                             AS primary_contact_id,
    recordtypeid                                                                      AS record_type_id,
    ultimate_parent_account_id__c                                                     AS ultimate_parent_id,
    partner_vat_tax_id__c                                                             AS partner_vat_tax_id,
    -- key people GL side
    gitlab_com_user__c                                                                AS gitlab_com_user,
    account_manager__c                                                                AS account_manager,
    account_owner_calc__c                                                             AS account_owner,
    account_owner_team__c                                                             AS account_owner_team,
    account_owner_role__c                                                             AS account_owner_role,
    proposed_account_owner__c                                                         AS proposed_account_owner,
    business_development_rep__c                                                       AS crm_business_dev_rep_id,
    dedicated_service_engineer__c                                                     AS dedicated_service_engineer,
    sdr_assigned__c                                                                   AS crm_sales_dev_rep_id,
    executive_sponsor__c                                                              AS executive_sponsor_id,
    -- solutions_architect__c                     AS solutions_architect,
    technical_account_manager_lu__c                                                   AS technical_account_manager_id,
    -- info
    "PREP".preparation.ID15TO18(SUBSTRING(REGEXP_REPLACE(
      ultimate_parent_account__c, '_HL_ENCODED_/|<a\\s+href="/', ''
    ), 0, 15))                                                                        AS ultimate_parent_account_id,
    ultimate_parent_account_text__c                                                   AS ultimate_parent_account_name,
    type                                                                              AS account_type,
    dfox_industry__c                                                                  AS df_industry,
    parent_lam_industry_acct_heirarchy__c                                             AS industry,
    sub_industry__c                                                                   AS sub_industry,
    parent_lam_industry_acct_heirarchy__c                                             AS parent_account_industry_hierarchy,
    account_tier__c                                                                   AS account_tier,
    account_tier_notes__c                                                             AS account_tier_notes,
    customer_since__c::DATE                                                           AS customer_since_date,
    carr_this_account__c                                                              AS carr_this_account,
    carr_acct_family__c                                                               AS carr_account_family,
    next_renewal_date__c                                                              AS next_renewal_date,
    license_utilization__c                                                            AS license_utilization,
    support_level__c                                                                  AS support_level,
    named_account__c                                                                  AS named_account,
    billingcountry                                                                    AS billing_country,
    account_demographics_upa_country__c                                               AS billing_country_code,
    billingpostalcode                                                                 AS billing_postal_code,
    sdr_target_account__c::BOOLEAN                                                    AS is_sdr_target_account,
    lam_tier__c                                                                       AS lam,
    lam_dev_count__c                                                                  AS lam_dev_count,
    jihu_account__c::BOOLEAN                                                          AS is_jihu_account,
    partners_signed_contract_date__c                                                  AS partners_signed_contract_date,
    partner_account_iban_number__c                                                    AS partner_account_iban_number,
    partners_partner_type__c                                                          AS partner_type,
    partners_partner_status__c                                                        AS partner_status,
    bdr_prospecting_status__c                                                         AS bdr_prospecting_status,
    first_order_available__c::BOOLEAN                                                 AS is_first_order_available,
    REPLACE(
      zi_technologies__c,
      'The technologies that are used and not used at this account, according to ZoomInfo, after completing a scan are:', -- noqa:L016
      ''
    )                                                                                 AS zi_technologies,
    technical_account_manager_date__c::DATE                                           AS technical_account_manager_date,
    gitlab_customer_success_project__c::VARCHAR                                       AS gitlab_customer_success_project,
    forbes_2000_rank__c                                                               AS forbes_2000_rank,
    potential_users__c                                                                AS potential_users,
    number_of_licenses_this_account__c                                                AS number_of_licenses_this_account,
    decision_maker_count_linkedin__c                                                  AS decision_maker_count_linkedin,
    numberofemployees                                                                 AS number_of_employees,
    phone                                                                             AS account_phone,
    zi_phone__c                                                                       AS zoominfo_account_phone,
    number_of_employees_manual_source_admin__c                                        AS admin_manual_source_number_of_employees,
    account_address_manual_source_admin__c                                            AS admin_manual_source_account_address,
    bdr_next_steps__c                                                                 AS bdr_next_steps,
    bdr_next_step_date__c::DATE                                                       AS bdr_recycle_date,
    actively_working_start_date__c::DATE                                              AS actively_working_start_date,
    bdr_account_research__c                                                           AS bdr_account_research,
    bdr_account_strategy__c                                                           AS bdr_account_strategy,
    account_bdr_assigned_user_role__c                                                 AS account_bdr_assigned_user_role,
    domains__c                                                                        AS account_domains,
    dascoopcomposer__domain_1__c                                                      AS account_domain_1,
    dascoopcomposer__domain_2__c                                                      AS account_domain_2,
    fy22_new_logo_target_list__c                                                      AS compensation_target_account,
    split_hierarchy__c                                                                AS is_split_hierarchy,
    -- account demographics fields
    -- Add sales_segment_cleaning macro to avoid duplication in downstream models
    CASE WHEN LOWER(account_demographics_sales_segment__c) = 'smb' THEN 'SMB'
     WHEN LOWER(account_demographics_sales_segment__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(account_demographics_sales_segment__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(account_demographics_sales_segment__c) IS NULL THEN 'SMB'
     WHEN LOWER(account_demographics_sales_segment__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(account_demographics_sales_segment__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(account_demographics_sales_segment__c) = 'lrg' THEN 'Large'
     WHEN LOWER(account_demographics_sales_segment__c) = 'jihu' THEN 'JiHu'
     WHEN account_demographics_sales_segment__c IS NOT NULL THEN initcap(account_demographics_sales_segment__c)
END             AS account_sales_segment,
    CASE WHEN LOWER(old_segment__c) = 'smb' THEN 'SMB'
     WHEN LOWER(old_segment__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(old_segment__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(old_segment__c) IS NULL THEN 'SMB'
     WHEN LOWER(old_segment__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(old_segment__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(old_segment__c) = 'lrg' THEN 'Large'
     WHEN LOWER(old_segment__c) = 'jihu' THEN 'JiHu'
     WHEN old_segment__c IS NOT NULL THEN initcap(old_segment__c)
END                                    AS account_sales_segment_legacy,
    account_demographics_geo__c                                                       AS account_geo,
    account_demographics_region__c                                                    AS account_region,
    account_demographics_area__c                                                      AS account_area,
    account_demographics_territory__c                                                 AS account_territory,
    account_demographics_business_unit__c                                             AS account_business_unit,
    account_demographics_role_type__c                                                 AS account_role_type,
    account_demographics_employee_count__c                                            AS account_employee_count,
    account_demographic_max_family_employees__c                                       AS account_max_family_employee,
    account_demographics_upa_country__c                                               AS account_upa_country,
    account_demographics_upa_country_name__c                                          AS account_upa_country_name,
    account_demographics_upa_state__c                                                 AS account_upa_state,
    account_demographics_upa_city__c                                                  AS account_upa_city,
    account_demographics_upa_street__c                                                AS account_upa_street,
    account_demographics_upa_postal_code__c                                           AS account_upa_postal_code,
    --D&B Fields
    dnbconnect__d_b_match_confidence_code__c::NUMERIC                                 AS dnb_match_confidence_score,
    dnbconnect__d_b_match_grade__c::TEXT                                              AS dnb_match_grade,
    dnbconnect__d_b_connect_company_profile__c::TEXT                                  AS dnb_connect_company_profile_id,
    IFF(duns__c REGEXP '^\\d{9}$', duns__c, NULL)                                     AS dnb_duns,
    IFF(global_ultimate_duns__c REGEXP '^\\d{9}$', global_ultimate_duns__c, NULL)     AS dnb_global_ultimate_duns,
    IFF(domestic_ultimate_duns__c REGEXP '^\\d{9}$', domestic_ultimate_duns__c, NULL) AS dnb_domestic_ultimate_duns,
    dnb_exclude_company__c::BOOLEAN                                                   AS dnb_exclude_company,
    -- present state info
    gs_health_score__c                                                                AS health_number,
    gs_health_score_color__c                                                          AS health_score_color,
    -- opportunity metrics
    count_of_active_subscription_charges__c                                           AS count_active_subscription_charges,
    count_of_active_subscriptions__c                                                  AS count_active_subscriptions,
    count_of_billing_accounts__c                                                      AS count_billing_accounts,
    license_user_count__c                                                             AS count_licensed_users,
    count_of_new_business_won_opps__c                                                 AS count_of_new_business_won_opportunities,
    count_of_open_renewal_opportunities__c                                            AS count_open_renewal_opportunities,
    count_of_opportunities__c                                                         AS count_opportunities,
    count_of_products_purchased__c                                                    AS count_products_purchased,
    count_of_won_opportunities__c                                                     AS count_won_opportunities,
    concurrent_ee_subscriptions__c                                                    AS count_concurrent_ee_subscriptions,
    NULL                                                                              AS count_ce_instances,
    NULL                                                                              AS count_active_ce_users,
    number_of_open_opportunities__c                                                   AS count_open_opportunities,
    using_ce__c                                                                       AS count_using_ce,
    --account based marketing fields
    NULL                                                                              AS abm_tier,
    gtm_strategy__c                                                                   AS gtm_strategy,
    gtm_acceleration_date__c                                                          AS gtm_acceleration_date,
    gtm_account_based_date__c                                                         AS gtm_account_based_date,
    gtm_account_centric_date__c                                                       AS gtm_account_centric_date,
    NULL                                                                              AS abm_tier_1_date,
    NULL                                                                              AS abm_tier_2_date,
    NULL                                                                              AS abm_tier_3_date,
    --demandbase fields
    NULL                                                                              AS demandbase_account_list,
    NULL                                                                              AS demandbase_intent,
    NULL                                                                              AS demandbase_page_views,
    NULL                                                                              AS demandbase_score,
    NULL                                                                              AS demandbase_sessions,
    NULL                                                                              AS demandbase_trending_offsite_intent,
    NULL                                                                              AS demandbase_trending_onsite_engagement,
    --6 Sense Fields
    x6sense_6qa__c::BOOLEAN                                                           AS has_six_sense_6_qa,
    riskrate_third_party_guid__c                                                      AS risk_rate_guid,
    x6sense_account_profile_fit__c                                                    AS six_sense_account_profile_fit,
    x6sense_account_reach_score__c                                                    AS six_sense_account_reach_score,
    x6sense_account_profile_score__c                                                  AS six_sense_account_profile_score,
    x6sense_account_buying_stage__c                                                   AS six_sense_account_buying_stage,
    x6sense_account_numerical_reach_score__c                                          AS six_sense_account_numerical_reach_score,
    x6sense_account_update_date__c::DATE                                              AS six_sense_account_update_date,
    x6sense_account_6qa_end_date__c::DATE                                             AS six_sense_account_6_qa_end_date,
    x6sense_account_6qa_age_in_days__c                                                AS six_sense_account_6_qa_age_days,
    x6sense_account_6qa_start_date__c::DATE                                           AS six_sense_account_6_qa_start_date,
    x6sense_account_intent_score__c                                                   AS six_sense_account_intent_score,
    x6sense_segments__c                                                               AS six_sense_segments,
    --Qualified Fields
    days_since_last_activity_qualified__c                                             AS qualified_days_since_last_activity,
    qualified_signals_active_session_time__c                                          AS qualified_signals_active_session_time,
    qualified_signals_bot_conversation_count__c                                       AS qualified_signals_bot_conversation_count,
    q_condition__c                                                                    AS qualified_condition,
    q_score__c                                                                        AS qualified_score,
    q_trend__c                                                                        AS qualified_trend,
    q_meetings_booked__c                                                              AS qualified_meetings_booked,
    qualified_signals_rep_conversation_count__c                                       AS qualified_signals_rep_conversation_count,
    signals_research_state__c                                                         AS qualified_signals_research_state,
    signals_research_score__c                                                         AS qualified_signals_research_score,
    qualified_signals_session_count__c                                                AS qualified_signals_session_count,
    q_visitor_count__c                                                                AS qualified_visitors_count,
    -- sales segment fields
    account_demographics_sales_segment__c                                             AS ultimate_parent_sales_segment,
    sales_segmentation_new__c                                                         AS division_sales_segment,
    account_owner_user_segment__c                                                     AS account_owner_user_segment,
    ultimate_parent_sales_segment_employees__c                                        AS sales_segment,
    sales_segmentation_new__c                                                         AS account_segment,
    NULL                                                                              AS is_locally_managed_account,
    strategic__c                                                                      AS is_strategic_account,
    -- ************************************
    -- New SFDC Account Fields for FY22 Planning
    next_fy_account_owner_temp__c                                                     AS next_fy_account_owner_temp,
    next_fy_planning_notes_temp__c                                                    AS next_fy_planning_notes_temp,
    --*************************************
    -- Partner Account fields
    partner_track__c                                                                  AS partner_track,
    partners_partner_type__c                                                          AS partners_partner_type,
    gitlab_partner_programs__c                                                        AS gitlab_partner_program,
    focus_partner__c                                                                  AS is_focus_partner,
    --*************************************
    -- Zoom Info Fields
    zi_account_name__c                                                                AS zoom_info_company_name,
    zi_revenue__c                                                                     AS zoom_info_company_revenue,
    zi_employees__c                                                                   AS zoom_info_company_employee_count,
    zi_industry__c                                                                    AS zoom_info_company_industry,
    zi_city__c                                                                        AS zoom_info_company_city,
    zi_state_province__c                                                              AS zoom_info_company_state_province,
    zi_country__c                                                                     AS zoom_info_company_country,
    exclude_from_zoominfo_enrich__c                                                   AS is_excluded_from_zoom_info_enrich,
    zi_website__c                                                                     AS zoom_info_website,
    zi_company_other_domains__c                                                       AS zoom_info_company_other_domains,
    dozisf__zoominfo_id__c                                                            AS zoom_info_dozisf_zi_id,
    zi_parent_company_zoominfo_id__c                                                  AS zoom_info_parent_company_zi_id,
    zi_parent_company_name__c                                                         AS zoom_info_parent_company_name,
    zi_ultimate_parent_company_zoominfo_id__c                                         AS zoom_info_ultimate_parent_company_zi_id,
    zi_ultimate_parent_company_name__c                                                AS zoom_info_ultimate_parent_company_name,
    zi_number_of_developers__c                                                        AS zoom_info_number_of_developers,
    zi_total_funding__c                                                               AS zoom_info_total_funding,
    pubsec_type__c                                                                    AS pubsec_type,
    ptp_insights__c                                                                   AS ptp_insights,
    ptp_score_value__c                                                                AS ptp_score_value,
    ptp_score__c                                                                      AS ptp_score,
    -- NF: Added on 20220427 to support EMEA reporting
    NULL                                                                              AS is_key_account,
    -- Gainsight Fields
    gs_first_value_date__c                                                            AS gs_first_value_date,
    gs_last_tam_activity_date__c                                                      AS gs_last_csm_activity_date,
    eoa_sentiment__c                                                                  AS eoa_sentiment,
    gs_health_user_engagement__c                                                      AS gs_health_user_engagement,
    gs_health_cd__c                                                                   AS gs_health_cd,
    gs_health_devsecops__c                                                            AS gs_health_devsecops,
    gs_health_ci__c                                                                   AS gs_health_ci,
    gs_health_scm__c                                                                  AS gs_health_scm,
    health__c                                                                         AS gs_health_csm_sentiment,
    csm_compensation_pool__c                                                          AS gs_csm_compensation_pool,
    -- Risk Fields
    risk_impact__c                                                                    AS risk_impact,
    risk_reason__c                                                                    AS risk_reason,
    last_timeline_at_risk_update__c                                                   AS last_timeline_at_risk_update,
    last_at_risk_update_comments__c                                                   AS last_at_risk_update_comments,
    --Groove Fields
    dascoopcomposer__engagement_status__c                                             AS groove_engagement_status,
    dascoopcomposer__groove_notes__c                                                  AS groove_notes,
    dascoopcomposer__inferred_status__c                                               AS groove_inferred_status,
    -- metadata
    createdbyid                                                                       AS created_by_id,
    createddate                                                                       AS created_date,
    isdeleted                                                                         AS is_deleted,
    lastmodifiedbyid                                                                  AS last_modified_by_id,
    lastmodifieddate                                                                  AS last_modified_date,
    lastactivitydate                                                                  AS last_activity_date,
    CONVERT_TIMEZONE(
      'America/Los_Angeles', CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP())
    )                                                                                 AS _last_dbt_run,
    systemmodstamp
  FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_user_roles_source as
with base as (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.userrole
)
SELECT *
FROM base;

CREATE TABLE "PREP".sfdc.sfdc_bizible_person_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.bizible2__bizible_person__c
), deduped AS (
    SELECT
      base.id                              AS person_id,
      CASE
        WHEN base.bizible2__lead__c IS NULL THEN contact.bizible2__lead__c
        ELSE base.bizible2__lead__c
      END                                  AS bizible_lead_id,
      base.bizible2__lead__c               AS base_lead_id,
      contact.bizible2__lead__c            AS contact_lead_id,
      base.bizible2__contact__c            AS bizible_contact_id,
      base.isdeleted::BOOLEAN              AS is_deleted
    FROM source AS base
    LEFT JOIN source AS contact
        ON base.bizible2__contact__c = contact.bizible2__contact__c
    WHERE is_deleted = 'FALSE'
    QUALIFY (ROW_NUMBER() OVER(PARTITION BY bizible_contact_id ORDER BY base.lastmodifieddate DESC, base.createddate DESC) = 1
        OR ROW_NUMBER() OVER(PARTITION BY bizible_lead_id ORDER BY base.lastmodifieddate DESC, base.createddate DESC) = 1 )
), final AS (
    SELECT
      person_id,
      bizible_lead_id,
      bizible_contact_id,
      is_deleted
    FROM deduped
)
SELECT *
FROM final;

CREATE TABLE "PREP".sfdc.sfdc_bizible_attribution_touchpoint_source as
WITH source AS (
  SELECT *
  FROM "RAW".salesforce_v2_stitch.bizible2__bizible_attribution_touchpoint__c
), renamed AS (
    SELECT
      id                                      AS touchpoint_id,
      -- sfdc object lookups
      bizible2__sf_campaign__c                AS campaign_id,
      bizible2__opportunity__c                AS opportunity_id,
      bizible2__contact__c                    AS bizible_contact,
      bizible2__account__c                    AS bizible_account,
      -- attribution counts
      bizible2__count_first_touch__c          AS bizible_count_first_touch,
      bizible2__count_lead_creation_touch__c  AS bizible_count_lead_creation_touch,
      bizible2__count_custom_model__c         AS bizible_attribution_percent_full_path,
      bizible2__count_u_shaped__c             AS bizible_count_u_shaped,
      bizible2__count_w_shaped__c             AS bizible_count_w_shaped,
      bizible2__count_custom_model_2__c       AS bizible_count_custom_model,
	-- attribution weights
      bizible2__attribution_first_touch__c    AS bizible_weight_first_touch,
      bizible2__attribution_lead_conversion_touch__c
                                              AS bizible_weight_lead_conversion,
      bizible2__attribution_custom_model__c   AS bizible_weight_full_path,
      bizible2__attribution_u_shaped__c       AS bizible_weight_u_shaped,
      bizible2__attribution_w_shaped__c       AS bizible_weight_w_shaped,
      bizible2__attribution_custom_model_2__c AS bizible_weight_custom_model,
      -- touchpoint info
      bizible2__touchpoint_date__c            AS bizible_touchpoint_date,
      bizible2__touchpoint_position__c        AS bizible_touchpoint_position,
      bizible2__touchpoint_source__c          AS bizible_touchpoint_source,
      source_type__c                          AS bizible_touchpoint_source_type,
      bizible2__touchpoint_type__c            AS bizible_touchpoint_type,
      bizible2__ad_campaign_name__c           AS bizible_ad_campaign_name,
      bizible2__ad_content__c                 AS bizible_ad_content,
      bizible2__ad_group_name__c              AS bizible_ad_group_name,
      bizible2__form_url__c                   AS bizible_form_url,
      bizible2__form_url_raw__c               AS bizible_form_url_raw,
      bizible2__landing_page__c               AS bizible_landing_page,
      bizible2__landing_page_raw__c           AS bizible_landing_page_raw,
      bizible2__marketing_channel__c          AS bizible_marketing_channel,
      bizible2__marketing_channel_path__c     AS bizible_marketing_channel_path,
      bizible2__medium__c                     AS bizible_medium,
      bizible2__referrer_page__c              AS bizible_referrer_page,
      bizible2__referrer_page_raw__c          AS bizible_referrer_page_raw,
      bizible2__sf_campaign__c                AS bizible_salesforce_campaign,
      NULL                                    AS utm_budget,
      NULL                                    AS utm_offersubtype,
      NULL                                    AS utm_offertype,
      NULL                                    AS utm_targetregion,
      NULL                                    AS utm_targetsubregion,
      NULL                                    AS utm_targetterritory,
      NULL                                    AS utm_usecase,
      CASE
        WHEN SPLIT_PART(SPLIT_PART(bizible_form_url_raw,'utm_content=',2),'&',1)IS null
          THEN SPLIT_PART(SPLIT_PART(bizible_landing_page_raw,'utm_content=',2),'&',1)
        ELSE SPLIT_PART(SPLIT_PART(bizible_form_url_raw,'utm_content=',2),'&',1)
      END AS utm_content,
      -- touchpoint revenue info
      bizible2__revenue_custom_model__c       AS bizible_revenue_full_path,
      bizible2__revenue_custom_model_2__c     AS bizible_revenue_custom_model,
      bizible2__revenue_first_touch__c        AS bizible_revenue_first_touch,
      bizible2__revenue_lead_conversion__c    AS bizible_revenue_lead_conversion,
      bizible2__revenue_u_shaped__c           AS bizible_revenue_u_shaped,
      bizible2__revenue_w_shaped__c           AS bizible_revenue_w_shaped,
      isdeleted::BOOLEAN                      AS is_deleted,
      createddate                             AS bizible_created_date
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".marketo.marketo_lead_source as
WITH source AS (
    SELECT *
    FROM "RAW".marketo.lead
), renamed AS (
    SELECT
        --Primary Key
        id::FLOAT                                 AS marketo_lead_id,
        --Info
        email::VARCHAR                            AS email,
    sha2(
        TRIM(
            LOWER(
                email ||
                ENCRYPT_RAW(
                  to_binary('SALT_EMAIL6', 'utf-8'),
                  to_binary('FEDCBAA123456785365637265EEEEEEA', 'HEX'),
                  to_binary('416C736F4E637265FFFFFFAB', 'HEX')
                )['ciphertext']::VARCHAR
            )
        )
    ) AS email_hash,
        sfdc_lead_id::VARCHAR                     AS sfdc_lead_id,
        sfdc_contact_id::VARCHAR                  AS sfdc_contact_id,
        first_name::VARCHAR                       AS first_name,
        last_name::VARCHAR                        AS last_name,
        company::VARCHAR                          AS company_name,
        title::VARCHAR                            AS job_title,
        CASE
    WHEN LOWER(INSERT(INSERT(job_title, 1, 0, ''), LEN(job_title)+2, 0, '')) LIKE ANY (
      '%head% it%', '%vp%technology%','%director%technology%', '%director%engineer%',
      '%chief%information%', '%chief%technology%', '%president%technology%', '%vp%technology%',
      '%director%development%', '% it%director%', '%director%information%', '%director% it%',
      '%chief%engineer%', '%director%quality%', '%vp%engineer%', '%head%information%',
      '%vp%information%', '%president%information%', '%president%engineer%',
      '%president%development%', '%director% it%', '%engineer%director%', '%head%engineer%',
      '%engineer%head%', '%chief%software%', '%director%procurement%', '%procurement%director%',
      '%head%procurement%', '%procurement%head%', '%chief%procurement%', '%vp%procurement%',
      '%procurement%vp%', '%president%procurement%', '%procurement%president%', '%head%devops%'
      )
      OR ARRAY_CONTAINS('cio'::VARIANT, SPLIT(LOWER(job_title), ' '))
      OR ARRAY_CONTAINS('cio'::VARIANT, SPLIT(LOWER(job_title), ','))
      OR ARRAY_CONTAINS('cto'::VARIANT, SPLIT(LOWER(job_title), ' '))
      OR ARRAY_CONTAINS('cto'::VARIANT, SPLIT(LOWER(job_title), ','))
      OR ARRAY_CONTAINS('cfo'::VARIANT, SPLIT(LOWER(job_title), ' '))
      OR ARRAY_CONTAINS('cfo'::VARIANT, SPLIT(LOWER(job_title), ','))
        THEN 'IT Decision Maker'
    WHEN LOWER(INSERT(INSERT(job_title, 1, 0, ''), LEN(job_title)+2, 0, '')) LIKE ANY (
      '%manager%information%', '%manager%technology%', '%database%administrat%', '%manager%engineer%',
      '%engineer%manager%', '%information%manager%', '%technology%manager%', '%manager%development%',
      '%manager%quality%', '%manager%network%', '% it%manager%', '%manager% it%',
      '%manager%systems%', '%manager%application%', '%technical%manager%', '%manager%technical%',
      '%manager%infrastructure%', '%manager%implementation%', '%devops%manager%', '%manager%devops%',
      '%manager%software%', '%procurement%manager%', '%manager%procurement%'
      )
      AND NOT ARRAY_CONTAINS('project'::VARIANT, SPLIT(LOWER(job_title), ' '))
        THEN 'IT Manager'
    WHEN LOWER(INSERT(INSERT(job_title, 1, 0, ''), LEN(job_title)+2, 0, '')) LIKE ANY (
      '% it %', '% it,%', '%infrastructure%', '%engineer%',
      '%techno%', '%information%', '%developer%', '%database%',
      '%solutions architect%', '%system%', '%software%', '%technical lead%',
      '%programmer%', '%network administrat%', '%application%', '%procurement%',
      '%development%', '%tech%lead%'
      )
        THEN 'IT Individual Contributor'
    ELSE NULL
  END AS it_job_title_hierarchy,
        country::VARCHAR                          AS country,
        mobile_phone::VARCHAR                     AS mobile_phone,
        sfdc_type::VARCHAR                        AS sfdc_type,
        inactive_lead_c::BOOLEAN                  AS is_lead_inactive,
        inactive_contact_c::BOOLEAN               AS is_contact_inactive,
        sales_segmentation_c::VARCHAR             AS sales_segmentation,
        is_email_bounced::BOOLEAN                 AS is_email_bounced,
        email_bounced_date::DATE                  AS email_bounced_date,
        unsubscribed::BOOLEAN                     AS is_unsubscribed,
        opt_in::BOOLEAN                           AS is_opt_in,
        compliance_segment_value::VARCHAR         AS compliance_segment_value,
        pql_product_qualified_lead_c::BOOLEAN     AS is_pql_marketo,
        cdbispaidtier_c::BOOLEAN                  AS is_paid_tier_marketo,
        ptpt_is_contact_c::BOOLEAN                AS is_ptpt_contact_marketo,
        ptp_is_ptp_contact_c::BOOLEAN             AS is_ptp_contact_marketo,
        cdb_impacted_by_user_limit_c::BOOLEAN     AS is_impacted_by_user_limit_marketo,
        currently_in_trial_c::BOOLEAN             AS is_currently_in_trial_marketo,
        trial_start_date_c::DATE                  AS trial_start_date_marketo,
        trial_end_date_c::DATE                    AS trial_end_date_marketo,
        updated_at::TIMESTAMP                     AS updated_at,
        _FIVETRAN_SYNCED,
        PRIORITY,
        URGENCY,
        RELATIVE_SCORE,
        RELATIVE_URGENCY,
        LEAD_SCORE,
        DEMOGRAPHIC_SCORE,
        LEAD_SOURCE,
        LEAD_STATUS,
        ACQUISITION_PROGRAM_ID,
        MKTO_ACQUISITION_DATE,
        PATH_FACTORY_ASSETS_VIEWED_C,
        PATH_FACTORY_CONTENT_COUNT_C,
        PATH_FACTORY_CONTENT_JOURNEY_C,
        PATH_FACTORY_ENGAGEMENT_SCORE_C,
        PATH_FACTORY_ENGAGEMENT_TIME_C,
        PATH_FACTORY_QUERY_STRING_C,
        BEHAVIOR_SCORE,
        GENERIC_EMAIL_DOMAIN,
        OPT_IN_DATE,
        RECORD_TYPE_ID_CONTACT,
        OWNER_PROFILE_C_LEAD,
        PHOTO_URL,
        STATE_CODE,
        MKTO_SI_SALES_INSIGHT_C,
        DEMANDBASE_SID_C,
        COUNTRY_CODE,
        SUB_REGION_C_LEAD,
        ACTIVE_USER_C,
        MKTO_SI_ADD_TO_MARKETO_CAMPAIGN_C,
        SALES_SEGMENTATION_C_LEAD,
        MQL_COUNTER_C,
        RAW_DATE_TIME_C,
        REGION_SUB_REGION_C_LEAD,
        CREATED_DATE_TIME_C,
        ZI_COMPANY_OTHER_DOMAINS_C,
        ATAM_SUB_REGION_C,
        ATAM_TERRITORY_C,
        TSP_UNIQUE_TERRITORY_NAME_C,
        ATAM_AREA_C,
        ATAM_REGION_C,
        BIZIBLE_2_ENGAGEMENT_SCORE_C,
        ATAM_APPROVED_NEXT_OWNER_C,
        ATAM_NEXT_OWNER_ROLE_C,
        ATAM_NEXT_OWNER_TEAM_C,
        ATAM_OWNER_DIFFERENCE_C,
        ATAM_OWNER_ROLE_ACRO_C,
        TSP_MANAGER_DIFFERENCE_C,
        MQL_DATE_C,
        INITIAL_MQL_DATE_C,
        INDUSTRY,
        ACTIVELY_BEING_SEQUENCED_C,
        NUMBER_OF_ACTIVE_SEQUENCES_C,
        SEQUENCE_STATUS_C,
        NURTURE_DATE_TIME_C,
        NURTURE_REASONS_C,
        OWNER_TEAM_C,
        REGION_C,
        BIZIBLE_2_LANDING_PAGE_FT_C,
        BIZIBLE_2_LANDING_PAGE_LC_C,
        BIZIBLE_2_MARKETING_CHANNEL_FT_C,
        BIZIBLE_2_MARKETING_CHANNEL_LC_C,
        BIZIBLE_2_TOUCHPOINT_DATE_FT_C,
        BIZIBLE_2_TOUCHPOINT_DATE_LC_C,
        BIZIBLE_2_TOUCHPOINT_SOURCE_FT_C,
        BIZIBLE_2_TOUCHPOINT_SOURCE_LC_C,
        LEAN_DATA_MATCHED_ACCOUNT_SALES_SEGMENT_C,
        LEAN_DATA_MATCHED_ACCOUNT_C,
        PATH_FACTORY_EXPERIENCE_NAME_C,
        PREVIOUS_NURTURE_REASON_C,
        PATH_FACTORY_ASSET_TYPE_C,
        PATH_FACTORY_CONTENT_LIST_C,
        PATH_FACTORY_FUNNEL_STATE_C,
        PATH_FACTORY_TOPIC_LIST_C,
        EMPLOYEE_BUCKETS_C,
        PHONE,
        WEBSITE,
        NEWSLETTER_SEGMENT_C_LEAD,
        SUBSCRIBE_WEBCAST_C,
        SUBSCRIBE_LIVE_EVENTS_C,
        GDPR_COMPLIANT_C,
        BIZIBLE_2_AD_CAMPAIGN_NAME_FT_C,
        BIZIBLE_2_AD_CAMPAIGN_NAME_LC_C,
        SIGN_UP_DATE,
        LEAN_DATA_TERRITORY_C,
        TRIAL_GIT_LAB_COM_C,
        OPT_OUT_DATE,
        SEC_PROJECT_NAMES,
        BIZIBLE_2_ACCOUNT_C,
        EMAIL_SUSPENDED,
        EMAIL_SUSPENDED_AT,
        EMAIL_SUSPENDED_CAUSE,
        LAST_UTM_CAMPAIGN_C,
        LAST_UTM_CONTENT_C,
        LAST_UTM_SOURCE_C,
        LAST_UTM_MEDIUM_C,
        PERSON_TIME_ZONE,
        ALL_REMOTE_FUNCTION,
        ALL_REMOTE_ROLE,
        DB_COMPANY_ADDRESS_C,
        DB_COMPANY_CITY_C,
        DB_COMPANY_COUNTRY_C,
        DB_COMPANY_NAME_C,
        DB_COMPANY_PHONE_C,
        DB_COMPANY_POSTAL_C,
        DB_COMPANY_STATE_C,
        DB_EMPLOYEE_COUNT_C,
        DB_INDUSTRY_C,
        DB_PRIMARY_SIC_C,
        DB_SUB_INDUSTRY_C,
        DB_WEBSITE_C,
        REASONFOR_ALL_REMOTE,
        GIT_LAB_COM_USER_C,
        ACCEPTED_DATE_TIME_C,
        NAME_OF_ACTIVE_SEQUENCE_C,
        EE_TRIAL_START_C,
        EE_TRIAL_START_DATE_C,
        TRIAL_ENTERPRISE_C,
        TRIAL_LICENSE_KEY,
        EE_TRIAL_END_DATE_C,
        PUBLIC_SECTOR_PARTNER_C,
        INITIAL_START_DATE_C,
        PARENT_ACCOUNT_SHIPPING_COUNTRY_C,
        VARTOPIA_DRS_DOMAIN_C,
        MAX_FOR_POTENTIAL_EE_USERS_C,
        MQL_DATE_TIME_C,
        ZENDESK_LAST_SYNC_DATE_C_LEAD,
        ORIGINAL_SOURCE_TYPE,
        ULTIMATE_PARENT_ACCOUNT_ZIP_DISC_ORG_F_3_C,
        COUNT_OF_OPEN_RENEWAL_OPPORTUNITIES_C,
        UNIQUE_WEB_VISITORS_ROLLING_30_C,
        ZI_COMPANY_NAICS_CODE_C,
        SALES_SEGMENTATION_UPDATED_C,
        CURRENT_CUSTOMER_C,
        NUMBER_OF_EMPLOYEES_DATA_FOX_C,
        REGISTRATION_SOURCE_TYPE,
        ZI_PRODUCTS_AND_SERVICES_C,
        DB_AUDIENCE_C,
        TZ_LT_INFO_C,
        ZZZ_ULT_PARENT_EMPLOYES_NUM_C,
        ULTIMATE_PARENT_SALES_SEGMENT_EMP_TEXT_C,
        VAT_ID_C,
        RECURLY_FIRST_NAME_C,
        BILLING_STATE_CODE,
        PARENT_ACCOUNT_SHIPPING_STATE_C,
        BUSINESS_DEVELOPMENT_REP_CONTACT_C,
        VARTOPIA_DRS_NUMBER_OF_EXPIRED_REGISTRATIONS_C_CONTACT,
        GS_PLAN_ACTIVE_C,
        ACCOUNT_PHONE_C,
        PRODUCTS_PURCHASED_C,
        VARTOPIA_DRS_CLOSED_WON_REGISTRATIONS_C_CONTACT,
        PUB_SEC_OWNER_C_LEAD,
        ZI_EMPLOYMENT_HISTORY_C,
        MKTO_COMPANY_NOTES,
        ENGAGIO_LEFT_COMPANY_C,
        DFOX_LAST_SYNCED_DATE_C_ACCOUNT,
        ENGAGIO_ENGAGEMENT_MINUTES_LAST_7_DAYS_C_ACCOUNT,
        RING_LEAD_STREET_ADDRESS_C,
        ZOOM_INFO_CONTACT_PROFILE_URL_C,
        LEAN_DATA_MATCHED_ACCOUNT_INDUSTRY_C,
        ADDRESS,
        TEMP_DF_PARENT_ACCOUNT_C,
        ENGAGIO_DEPARTMENT_C,
        ROUND_ROBIN_ID_C,
        LICENSE_UTILIZATION_C,
        ACTIVE_USER_C_ACCOUNT,
        ULTIMATE_PARENT_POTENTIAL_EEUSERS_C,
        ABM_TIER_3_DATE_C,
        DSCORGPKG_EMAIL_INVALID_C,
        GACID,
        ZI_CONTACT_ZIP_CODE_C,
        RING_LEAD_CITY_C,
        MIGRATION_SERVICES_REQUESTED,
        LICENSE_USER_COUNT_C,
        BDR_JOB_TITLE,
        GIT_LABCOM_USER_ID_C,
        DFOX_SOURCED_FROM_DATA_FOX_C_ACCOUNT,
        INDUSTRY_C,
        REGION_C_ACCOUNT,
        ACCOUNT_MANAGER_C,
        UPA_ACCOUNT_TERRITORY_ZIP_F_3_C,
        TWITTER_HANDLE_C,
        WEBCAST_SPEAKER_REFERENCE_C_ACCOUNT,
        AD_IMPRESSIONS_ROLLING_90_C,
        INFERRED_CITY,
        ZENDESK_CREATED_UPDATED_FLAG_C,
        ZENDESK_ZENDESK_ORGANIZATION_C,
        CHANNEL_MANAGER_C,
        TZ_TIMEZONE_C_ACCOUNT,
        RECURLY_PAST_DUE_C,
        ULTIMATE_PARENT_ACCOUNT_BILLING_STATE_C,
        NEXT_FY_USER_SEGMENT_TEMP_C,
        LEAN_DATA_MATCHED_ACCOUNT_NAME_C,
        EMAIL_2_C,
        ZENDESK_ZENDESK_ID_C,
        SALUTATION,
        COUNT_OF_COUNT_OF_CHILD_ACCOUNTS_C,
        DOZISF_ZOOM_INFO_LAST_UPDATED_C_ACCOUNT,
        ZI_CONTACT_STATE_C,
        PATH_FACTORY_CONTENT_SLUG_C,
        ULTIMATE_PARENT_ACCOUNT_ZIP_DATA_FOX_C,
        LEAN_DATA_MATCHED_ACCOUNT_EMPLOYEES_C,
        ZI_WEBSITE_C,
        NAMED_ACCOUNT_C,
        IMPLEMENTATION_SERVICE_REQUESTED,
        ALYCECOM_MOST_RECENT_GIFT_INVITATION_SENT_DATE_C_ACCOUNT,
        TEMP_DF_HIER_ULTIMATE_PARENT_BILLING_ZI_C,
        ZI_NUMBER_OF_DEVELOPERS_C,
        LEAN_DATA_MATCHED_ACCOUNT_BILLING_COUNTRY_C,
        ABM_TIER_C,
        RATINGSCALE,
        BUSINESS_DEVELOPMENT_REP_C_ACCOUNT,
        SPECIALIZED_TRAININGS_REQUESTED,
        COMPANY_LOCAL,
        MKTO_2_INFERRED_CITY_C,
        NEXT_FY_PLANNING_NOTES_TEMP_C,
        HOME_OFFICE_CITY,
        SHIPPING_LATITUDE,
        TZ_TIMEZONE_IANA_C,
        DSCORGPKG_JOB_FUNCTION_C,
        TZ_TIMEZONE_C,
        EVENT_MEETING_TIME,
        NUMBER_OF_LICENSES_C,
        COMPANY_NATURAL_NAME_C,
        ACCOUNT_ADDRESS_MANUAL_SOURCE_USER_C,
        DOZISF_ZOOM_INFO_FIRST_UPDATED_C,
        QUALIFYING_DATE_TIME_C,
        MKTO_71_ORIGINAL_UTM_MEDIUM_C,
        RECURLY_PLAN_NAME_C,
        LAST_UTM_OFFERTYPE_C,
        ULTIMATE_PARENT_ACCOUNT_COUNTRY_DATA_FOX_C,
        RECURLY_ACCOUNT_CODE_C,
        ACCOUNT_ID_18_C,
        SFDC_LEAD_OWNER_ID,
        ZI_MANAGEMENT_LEVEL_C,
        ZI_COMPANY_EMPLOYEE_RANGE_C,
        ZI_COMPANY_CITY_C,
        GS_MONITORING_ACTIVE_C,
        ENGAGIO_MATCHED_ACCOUNT_ENGAGE_MINS_LAST_7_DAYS_C,
        BDR_LAST_NAME,
        RECURLY_PLAN_CODE_C,
        SDR_C,
        MATCHED_ACCOUNT_GTM_STRATEGY_C,
        CITY,
        VARTOPIA_DRS_NUMBER_OF_CLOSED_WON_REGISTRATIONS_C_CONTACT,
        NDE_NODE_GENERATED_CHECKBOX_C,
        GIT_LAB_COM_USER_C_ACCOUNT,
        B_TLKWEBCAST_CAMPAIGN_REFERENCE,
        RING_LEAD_STATE_C,
        LEAN_DATA_MATCHED_ACCOUNT_WEBSITE_C,
        CORE_USER_C,
        ROLE_C,
        TZ_TIMEZONE_FULL_C,
        SIG_REFERENCE_C_ACCOUNT,
        SOLUTIONS_TO_BE_REPLACED_C,
        RING_LEAD_COUNTRY_C,
        INTENT_C,
        DOZISF_ZOOM_INFO_ID_C,
        ZI_COMPANY_ZIP_CODE_C,
        CONTACT_COMPANY,
        CORE_CHECK_IN_NOTES_FORMATTED_2_C,
        ZENDESK_RESULT_C_LEAD,
        RING_LEAD_PHONE_C,
        UNQUALIFIED_DATE_TIME_C,
        B_TLKRECORDED_MINUTES_VIEWED,
        B_TLKWEBCAST_TITLE,
        ENGAGIO_MATCHED_ACCOUNT_EMPLOYEES_C,
        LOCALLY_MANAGED_C,
        SDR_ASSIGNED_C,
        TRENDING_OFFSITE_INTENT_C,
        ANONYMOUS_IP,
        VERIFY_ACTIVE_C,
        ULTIMATE_PARENT_ACCOUNT_ZIP_DISC_ORG_C,
        BDR_FIRST_NAME,
        MARKETING_COMM_OPT_OUT_C_ACCOUNT,
        CORE_CHECK_IN_NOTES_C,
        WON_RENEWAL_OPP_THIS_MONTH_C,
        COUNT_OF_CROSS_SELL_OPPS_C,
        HEALTH_C,
        BDR_EMAIL_ADDRESS,
        ACCOUNT_C,
        ZI_STREET_C,
        ZENDESK_LAST_SYNC_DATE_C,
        ULTIMATE_PARENT_ADDRESS_SOURCE_FORMULA_C,
        IS_PARTNER,
        ENTITY_BENEFICIARY_INFORMATION_C,
        ZI_CONTACT_STREET_C,
        TSP_LAST_CHANGE_DATE_C,
        TECH_STACK_C,
        INTERESTED_IN_GIT_LAB_EE_C,
        ALLIANCES_DISCOUNT_C,
        GS_LIFECYCLE_STAGE_C,
        WORLD_TOUR_CITY,
        ST_MONITOR_APPETITE_FOR_REPLACEMENT_C,
        ULTIMATE_PARENT_OLD_C,
        ULTIMATE_PARENT_ACCOUNT_SHIPPING_STATE_C,
        DEPARTMENT,
        PREVIOUS_UNQUALIFIED_REASON,
        HOME_OFFICE_POSTAL_CODE,
        FREE_COM_USER_C,
        ENGAGIO_MATCHED_ACCOUNT_TYPE_C,
        ZI_CITY_C,
        TERMINUS_CLICKS_C_ACCOUNT,
        LOGO_REFERENCE_C_ACCOUNT,
        OSS_REASON_FOR_APPLICATION_C,
        PATH_FACTORY_CONTENT_LANGUAGE_C,
        HOW_ARE_YOU_USING_GIT_LAB_C,
        DATA_FOX_PARENT_ACCOUNT_WORK_TEMP_C,
        ENGAGIO_STATUS_C,
        TEMP_DF_HIER_ULTIMATE_PARENT_NAMED_C,
        ENGAGIO_ROLE_C,
        TEMP_ULTIMATE_PARENT_ID_MATCH_C,
        IACV_THIS_ACCOUNT_Q_4_2018_C,
        SDR_ASSIGNED_ROLE_C,
        SUPPORT_LEVEL_NUMERIC_C,
        IS_LEAD,
        SURGE_HEAT_C,
        CUSTOMER_C,
        ZI_COMPANY_COUNTRY_C,
        VARTOPIA_DRS_TOTAL_NUMBER_OF_REGISTRATIONS_C_CONTACT,
        STATE,
        LEAN_DATA_MATCHED_ACCOUNT_TYPE_C,
        ENGAGIO_NUMBER_OF_PEOPLE_C,
        PLAN_ACTIVE_C,
        ENGAGIO_PIPELINE_PREDICT_SCORE_C,
        ZI_ULTIMATE_PARENT_COMPANY_ZOOMINFO_ID_C,
        B_TLKTOTAL_MINUTES_VIEWED,
        WEBCAST_ACTIVITY_ACTIVITY_TYPE,
        VARTOPIA_DRS_NUMBER_OF_APPROVED_REGISTRATIONS_C_CONTACT,
        ALERTS_C,
        ZI_ACCOUNT_NAME_C,
        PARTNERS_IS_ACTIVE_C,
        ZENDESK_RESULT_C,
        VARTOPIA_DRS_CLOSED_LOST_REGISTRATIONS_C_CONTACT,
        SECURE_ACTIVE_C,
        MARKETING_SUSPENDED,
        COOKIES,
        DIETARY_RESTRICTION_C,
        TZ_TIMEZONE_FULL_C_ACCOUNT,
        ZI_NAICS_CODE_C,
        ACCOUNT_TERRITORY_C,
        ENGAGIO_QUALIFICATION_SCORE_C,
        NDE_NODE_CONTEXT_FORMULA_C_ACCOUNT,
        COMPANY_SEARCH_QUERY_C,
        SALES_REFERENCE_C_ACCOUNT,
        COUNT_OF_OPPORTUNITIES_C,
        ZI_TOTAL_FUNDING_C,
        SUB_INDUSTRY_C_ACCOUNT,
        IS_A_CONTRACTED_PARTNER_C,
        PUB_SEC_OWNER_C,
        ORIGINAL_SOURCE_INFO,
        M_QLDATE_2,
        INFER_INFER_SCORE_C,
        TEMP_DF_HIER_ULTIMATE_PAR_BILL_COUNTRY_C,
        ZI_COMPANY_STATE_C,
        ACCOUNT_OWNER_C,
        ENGAGIO_MATCH_TIME_C,
        REGISTRATION_SOURCE_INFO,
        ZI_COUNTRY_C,
        CUSTOMER_HEALTH_SCORE_DATE_C,
        ULTIMATE_PARENT_SALES_SEGMENT_EMPLOYEES_C,
        ATAM_ADDRESS_POSTAL_CODE_C,
        GS_SECURITY_ACTIVE_C,
        IACV_THIS_ACCOUNT_Q_3_2018_C,
        ACCOUNT_STREET_ADDRESS_MANUAL_ADMIN_C,
        DOMAINS_C,
        EMAIL_OPT_OUT_C,
        EVENTS_SEGMENT,
        ULTIMATE_PARENT_SALES_SEGMENTATION_C,
        ANNUAL_REVENUE,
        ZI_CONTACT_ACCURACY_GRADE_C,
        ZI_FAX_C,
        IS_CONTACT_C,
        PERSON_PRIMARY_LEAD_INTEREST,
        PHOTO_URL_ACCOUNT,
        ATTEND_ORGANIZED_GIT_LAB_MEETUP_C,
        TECHNICAL_ACCOUNT_MANAGER_C,
        GENERIC_1,
        TEMP_DUPLICATED_ACCOUNT_C,
        ZI_COMPANY_REVENUE_RANGE_C,
        DOUBLE_OPT_IN_DATE,
        ZI_EMPLOYEES_C,
        SUPPORT_EDU_OSS_C,
        O_SSCERTIFIED_NOTFOR_PROFIT,
        ENGAGIO_ENGAGEMENT_MINUTES_LAST_3_MONTHS_C,
        MKTO_71_ORIGINAL_UTM_SOURCE_C,
        CAB_REFERENCE_C,
        BLACK_LISTED,
        ZENDESK_IS_CREATED_UPDATED_FLAG_C,
        DO_NOT_ROUTE_C,
        GTM_STRATEGY_C,
        BILLING_POSTAL_CODE,
        ABERDEEN_CLOUD_PROVIDER_C,
        CONVERTED_DATE_C,
        MAIN_PHONE,
        IF_USING_CE_HOW_ARE_YOU_USING_CE_C,
        ENTITY_OVERRIDE_C,
        COMPANY_DESC_RESELLER_C,
        IS_GIT_LAB_GEO_CUSTOMER_C,
        FAX,
        ZENDESK_ZENDESK_OUTOF_SYNC_C,
        IMPARTNER_PRM_IS_DEAL_REGISTRATION_C,
        ZI_STATE_PROVINCE_C,
        WEB_PORTAL_PURCHASE_DATE_TIME_C,
        B_TLKQUESTIONS_TEXT,
        TOTAL_ACCOUNT_VALUE_C,
        UNQUALIFIED_REASONS_C,
        PRINTFECTION_CODE,
        VARTOPIA_DRS_DENIED_REGISTRATIONS_C_CONTACT,
        INFERRED_PHONE_AREA_CODE,
        MAILING_COUNTRY_CODE,
        ZI_COMPANY_IS_DEFUNCT_C,
        ZI_INDUSTRY_C,
        ULTIMATE_PARENT_ACCOUNT_STATE_DATA_FOX_C,
        LEAN_DATA_OWNER_C,
        ACCOUNT_STATE_MANUAL_USER_C,
        LAST_TSP_UPDATE_REASON_C,
        DOMAIN_C,
        ULTIMATE_PARENT_ACCOUNT_BILLING_ZIP_C,
        LEAD_OWNER_SLACK_ID,
        ZI_ULTIMATE_PARENT_COMPANY_NAME_C,
        IS_SP_URL_FILLED_C,
        OSS_PROJECT_LINK_C,
        LEAD_PERSON,
        BILLING_LONGITUDE,
        ZI_EMPLOYEE_COUNT_C,
        DOUBLE_OPT_IN,
        MATCHED_ACCOUNT_SDR_ASSIGNED_C,
        MKTO_2_INFERRED_STATE_REGION_C,
        RECURLY_LAST_NAME_C,
        VARTOPIA_DRS_NUMBER_OF_CLOSED_LOST_REGISTRATIONS_C_CONTACT,
        LAST_UNIQUE_VISITORS_SNAPSHOT_C,
        MAILING_ADDRESS,
        ULTIMATE_PARENT_ACCOUNT_SEGMENT_ROLLUP_C,
        SUBSCRIBERS_BRIGHT_TALKUSER_ID,
        PARTNER_ACCOUNT_C,
        EO_ACUSTOMER_NAME,
        PRODUCT_CATEGORY_C,
        BILLING_STREET,
        ZI_CONTACT_ACCURACY_SCORE_C_CONTACT,
        B_TLKVIEWING_URL,
        INFERRED_POSTAL_CODE,
        NDE_NODE_GENERATED_FORMULA_C,
        CE_DOWNLOAD_DATE,
        INFERRED_COMPANY,
        GS_CI_ACTIVE_C,
        ENTITY_CONTACT_INFORMATION_C,
        ACCOUNT_OWNER_MANAGER_EMAIL_C,
        NEXT_FY_USER_REGION_TEMP_C,
        ZI_CONTACT_ACCURACY_SCORE_C,
        CE_INSTANCES_C,
        ZI_DESCRIPTION_C,
        CMRR_ALL_ACCOUNTS_C,
        PARENT_ACCOUNT_SHIPPING_ZIP_C,
        EDUCATION_REQUESTED,
        TSP_LAST_UPDATE_TIMESTAMP_C,
        MIDDLE_NAME_LEAD,
        NUMBER_OF_DEVELOPERS_BUCKET_C,
        ZI_CONTACT_COUNTRY_C,
        HOW_CAN_WE_HELP_C,
        VARTOPIA_DRS_NUMBER_OF_DENIED_REGISTRATIONS_C_CONTACT,
        ZENDESK_LAST_SYNC_STATUS_C,
        TEMP_DF_HIER_ULTIMATE_PARENT_SHIPPING_S_C,
        DATA_QUALITY_SCORE_C,
        MKTO_2_LEAD_SCORE_C,
        RING_LEAD_EMAIL_ADDRESS_C,
        ACCOUNT_COUNTRY_MANUAL_USER_C,
        COMMENT_CAPTURE,
        MATCHED_ACCOUNT_TERRITORY_C,
        SHIPPING_COUNTRY_CODE_C,
        HOME_OFFICE_COUNTRY,
        ACCOUNT_OWNER_TEAM_C,
        ACCOUNT_OWNER_EMAIL_C,
        RECURLY_UUID_C,
        ZENDESK_ZENDESK_ORGANIZATION_ID_C,
        LAST_UTM_TERM_C,
        COUNT_OF_OPEN_NEW_ADD_ON_OPPS_C,
        ZI_COMPANY_TICKER_C,
        ENGAGIO_MATCHED_ACCOUNT_ENGAGIO_STATUS_C,
        FIELD_MARKETING_MANAGER_C,
        ALLIANCE_RECORD_C_ACCOUNT,
        ST_PACKAGE_CONTRACT_END_DATE_C,
        TOTAL_CUSTOMER_VALUE_C,
        CUSTOMER_SINCE_C,
        ZQU_COUNTY_C,
        ZI_CERTIFICATION_DATE_C,
        VARTOPIA_DRS_CREATED_FROM_REGISTRATION_C_CONTACT,
        BUSINESS_DEVELOPMENT_REPRESENTATIVE_C,
        MKTO_71_ORIGINAL_UTM_TERM_C,
        ZI_REVENUE_C,
        MKTO_SI_SALES_INSIGHT_C_ACCOUNT,
        ENGAGIO_ENGAGEMENT_MINUTES_LAST_7_DAYS_C,
        MKTO_71_ORIGINAL_UTM_CAMPAIGN_C,
        ACCOUNT_STREET_MANUAL_USER_C,
        USING_CE_C_LEAD,
        SOLUTIONS_FEATURES_OF_INTEREST_C,
        SUCCESS_ENGINEER_C,
        ENGAGIO_MATCHED_ACCOUNT_ENGAGE_MINS_LAST_3_MONTHS_C,
        SUBSCRIBE_SUBPROCESSOR,
        VARTOPIA_DRS_VARTOPIA_PARTNER_TRANSACTION_ID_C,
        ST_MONITOR_TECH_C,
        ULTIMATE_PARENT_C,
        AD_IMPRESSIONS_ROLLING_30_C,
        GEMSTONE_TYPE_C,
        ST_PLAN_TECH_C,
        OUTBOUND_BDR_C,
        ACCOUNT_STATE_MANUAL_ADMIN_C,
        TZ_TIMEZONE_IANA_C_ACCOUNT,
        LEAN_DATA_MATCHED_ACCOUNT_BILLING_STATE_C,
        VARTOPIA_DRS_APPROVED_REGISTRATION_C,
        ZI_COMPANY_LINKED_IN_URL_C,
        WEB_VISIT_DATA_UP_TO_DATE_AS_OF_C,
        BILLING_LATITUDE,
        ACCOUNT_CITY_MANUAL_USER_C,
        ENGAGIO_MQADATE_C,
        ZI_TICKER_SYMBOL_C,
        OSS_SUPPORTING_EVIDENCE_C,
        RECORD_TYPE_ID,
        PERSON_TYPE,
        NDE_NODE_GENERATED_LEAD_FORMULA_C,
        AE_COMMENTS_C_CONTACT,
        UPA_ACCOUNT_TERRITORY_ZIP_C,
        EMAIL_BOUNCED_REASON,
        TOTAL_TECH_ENG_DESIGN_DEV_USERS_C,
        NEXT_FY_USER_AREA_TEMP_C,
        ULTIMATE_PARENT_ACCOUNT_SHIPPING_COUNTRY_C,
        NDE_NODE_PRIORITY_C,
        NAME_LOCAL,
        SIC_CODE,
        VARTOPIA_DRS_VARTOPIA_ACCESS_C,
        CURRENT_MRR_C,
        LEAN_DATA_REGION_C,
        ATAM_ADDRESS_CITY_C,
        ABERDEEN_TECHNOLOGY_STACK_C,
        UPA_ACCOUNT_TERRITORY_STATE_C,
        COMPETITORS_C,
        OSS_PROJECT_DESCRIPTION_C,
        Y_CBATCH,
        FIRST_ORDER_AVAILABLE_C,
        SOLUTIONS_ARCHITECT_C,
        B_TLKACTIVITY_MESSAGE,
        ULTIMATE_PARENT_ID_C,
        DOZISF_ZOOM_INFO_FIRST_UPDATED_C_ACCOUNT,
        BAD_DATA_DATE_TIME_C,
        NDE_YOU_SHOULD_MENTION_C_ACCOUNT,
        X_30_DAY_OPT_OUT_C,
        LAST_NAME_LOCAL,
        WEB_VISITS_ROLLING_30_C,
        PRODUCTS_SOLD_RESELLER_C,
        PREVIOUS_BAD_DATA_REASON,
        TSP_OVERRIDE_STATUS_C,
        BILLING_STATE,
        MAILING_STATE_CODE,
        CAB_REFERENCE_C_ACCOUNT,
        BDR_PHONE_NUMBER,
        PRODUCT_OSS_EDU_C,
        DB_COMPANY_CITY_C_CONTACT,
        TEMP_DF_PARENT_ACCOUNT_ID_C,
        POTENTIAL_USERS_C,
        SFSSDUPE_CATCHER_OVERRIDE_DUPE_CATCHER_C,
        TEMP_DF_HIER_ULTIMATE_PAR_SHIP_COUNTRY_C,
        PARENT_ACCOUNT_OWNER_C,
        FEDERAL_ACCOUNT_C,
        LATEST_LEAD_CONVERSION_NUMBER_OF_EMPLOY_C,
        BILLING_COUNTRY_CODE,
        ULTIMATE_PARENT_ACCOUNT_ZIP_DATA_FOX_F_3_C,
        PATH_FACTORY_EXTERNAL_ID_C,
        PARENT_ACCOUNT_BILLING_STATE_C,
        ENGAGIO_MATCHED_ACCOUNT_HQ_STATE_C,
        PARENT_ACCOUNT_BILLING_ZIP_C,
        MAILING_LONGITUDE,
        ACCOUNT_ADDRESS_MANUAL_DATE_O_C,
        DEV_OPS_VIRTUAL_CUSTOM_C,
        LEAN_DATA_REPORTING_TARGET_ACCOUNT_C,
        PACKAGE_ACTIVE_C,
        ALLIANCE_RECORD_C,
        HEALTH_SCORE_REASONS_C,
        LEAD_PARTITION_ID,
        RING_LEAD_ZIP_POSTAL_CODE_C,
        SHIPPING_COUNTRY_CODE,
        CONSENT_TO_DATA_SHARING_WITH_WHITESOURCE_C,
        ZENDESK_LAST_SYNC_STATUS_C_LEAD,
        TEMP_DF_ULTIMATE_PARENT_ACCOUNT_LU_C,
        AD_CLICKS_ROLLING_90_C,
        NON_CRIMEAN_C,
        ZI_TECHNOLOGIES_C,
        ZI_PARENT_COMPANY_NAME_C,
        ASSOCIATED_TERMINUS_ACCOUNTS_C,
        TECHNICAL_ACCOUNT_MANAGER_LU_C,
        JB_TEST_SALES_SEGMENT_C,
        BILLING_COUNTRY,
        LAST_EVENT_NOTES_C,
        CASE_STUDY_REFERENCE_C_ACCOUNT,
        TEMP_DF_HIER_ULTIMATE_PARENT_SHIPPING_Z_C,
        ULTIMATE_PARENT_SALES_SEGMENTATION_DEL_C,
        ORIGINAL_SEARCH_ENGINE,
        ULTIMATE_PARENT_ACCOUNT_STATE_DISC_ORG_C,
        RING_LEAD_GENERAL_ARCHIVE_C,
        ZI_CONTACT_CITY_C,
        B_TLKWEBCAST_ID,
        NUMBER_OF_EMPLOYEES,
        GS_CD_ACTIVE_C,
        NDE_NODE_PRIORITY_C_CONTACT,
        ENGAGIO_MATCHED_ACCOUNT_OWNER_NAME_C,
        ABERDEEN_NUMBER_OF_DEVELOPERS_C,
        LEAN_DATA_MATCHED_ACCOUNT_BILLING_POSTAL_CODE_C,
        GS_SCM_ACTIVE_C,
        ENGAGIO_WEB_VISITS_LAST_3_MONTHS_C,
        NDE_NODE_CONTEXT_FORMULA_C,
        CIMINUTEUSAGE,
        ORIGINAL_REFERRER,
        DSCORGPKG_IT_BUDGET_C_ACCOUNT,
        ACCOUNT_CITY_MANUAL_ADMIN_C,
        SDR_ACCOUNT_TEAM_C,
        JOIN_URL,
        B_TLKLAST_ACTIVITY_DATE,
        DSCORGPKG_FISCAL_YEAR_END_C_ACCOUNT,
        ST_PLAN_CONTRACT_END_DATE_C,
        ZENDESK_TAGS_C,
        TZ_UTF_OFFSET_C,
        ULTIMATE_PARENT_SALES_SEGMENT_TEXT_C,
        EVENT_SPEAKER_REFERENCE_C,
        OUTREACH_STAGE_C,
        LEAN_DATA_MATCHED_ACCOUNT_ANNUAL_REVENUE_C,
        ROLE_PROSPECT_PLAYS_IN_EVALUATION_C,
        ENGAGIO_ENGAGEMENT_MINUTES_LAST_3_MONTHS_C_ACCOUNT,
        GATRACKID_C,
        SHIPPING_LONGITUDE,
        NDE_NODE_CONTEXT_C,
        ULTIMATE_PARENT_ACCOUNT_NAMED_C,
        FIRST_NAME_LOCAL,
        NDE_NODE_GENERATED_C,
        HIGH_LEVEL_BUSINESS_NEED_IMPACT_ON_BIZ_C,
        TERMINUS_IMPRESSIONS_C_ACCOUNT,
        SHIPPING_STATE_CODE,
        ZI_COMPANY_REVENUE_C,
        MKTO_IS_PARTNER,
        MKTO_NAME,
        INQUIRY_DATE_TIME_C,
        AATEST_C,
        DOAC_REFERENCE_C_ACCOUNT,
        MAILING_LATITUDE,
        NEXT_FY_TSP_TERRITORY_TEMP_C,
        INFERRED_METROPOLITAN_AREA,
        PATH_FACTORY_TRACK_CUSTOM_URL_C,
        ZENDESK_CREATE_IN_ZENDESK_C_ACCOUNT,
        DATA_QUALITY_DESCRIPTION_C_ACCOUNT,
        ZI_MOBILE_PHONE_NUMBER_C,
        ENTITY_BANK_INFORMATION_C,
        ULTIMATE_PARENT_IS_CURRENT_ACCOUNT_C,
        TEMP_DF_ULTIMATE_PARENT_ACCOUNT_C,
        TALK_ABOUT_GIT_LAB_C,
        ENGAGIO_ENGAGED_PEOPLE_C,
        NDE_NODE_CONTEXT_C_ACCOUNT,
        ULTIMATE_PARENT_ACCOUNT_SHIPPING_ZIP_C,
        HOME_OFFICE_STREET,
        TEMP_DF_HIER_ULTIMATE_PARENT_OWNER_C,
        IS_GIT_LAB_EECUSTOMER_C,
        SUBSCRIBED_SECURITY_ALERTS_C,
        SOLUTIONS_ARCHITECT_LOOKUP_C,
        ZENDESK_CREATE_IN_ZENDESK_C,
        INITIAL_MQL_DATE_TIME_C,
        GS_HEALTH_SCORE_LABEL_C,
        PARTNER_ACCOUNT_ID,
        ZI_PHONE_C,
        EVENT_SPEAKER_REFERENCE_C_ACCOUNT,
        CONTRACTED_CHANNEL_TEAM_USE_ONLY_C,
        LEAN_DATA_ROUTING_STATUS_C,
        SUBSCRIPTION_AMOUNT_C,
        PATH_FACTORY_TRACK_ID_C,
        TEMP_DATA_FOX_MIS_MATCH_C,
        ENGAGIO_INTENT_MINUTES_LAST_30_DAYS_C_ACCOUNT,
        ASSOCIATED_TERMINUS_ACCOUNTS_UP_TO_DATE_AS_OF_C,
        GCLID,
        COUNT_OF_OPEN_RENEWAL_OPPS_C,
        ZI_COMPANY_STREET_C,
        EDUCATION_USER_CASE_C,
        PARTNERS_PUBLIC_SECTOR_PARTNER_C,
        ANALYST_REFERENCE_C_ACCOUNT,
        ENGAGIO_MATCHED_ACCOUNT_C,
        CUSTOMER_SLACK_CHANNEL_C,
        HAS_OPTED_OUT_OF_FAX,
        VARTOPIA_DRS_COMPANY_ADMIN_C,
        DOZISF_ZOOM_INFO_LAST_UPDATED_C,
        ENGAGIO_MATCHED_ACCOUNT_NAME_C,
        SUBSCRIBE_PARTNERS,
        INFERRED_STATE_REGION,
        OTHER_COUNTRY_CODE,
        ULTIMATE_PARENT_ACCOUNT_OWNER_C,
        EDUCATION_USE_CASE_NOTES_C,
        ACCOUNT_TIER_NOTES_HISTORY_C,
        CURRENT_DEV_OPS_OR_SDLC_TOOLS_NOTES_C,
        SFSSDUPE_CATCHER_OVERRIDE_DUPE_CATCHER_C_CONTACT,
        PATH_FACTORY_CONTENT_SOURCE_URL_C,
        REGION_SUB_REGION_C,
        POTENTIAL_EE_USERS_TOTAL_C,
        DB_COMPANY_COUNTRY_C_CONTACT,
        ISGROUPNAMESPACEOWNER_C,
        MARKETING_COMM_OPT_OUT_C,
        DB_COMPANY_STATE_C_CONTACT,
        BAD_DATA_REASONS_C,
        LAST_VISIT_MOMENT_C,
        ZI_EMPLOYEE_COUNT_C_CONTACT,
        HOW_MANY_SEATS_ARE_THEY_INTERESTED_IN_PU_C,
        NDE_NODE_PRIORITY_C_ACCOUNT,
        CONTRIBUTED_TO_OPEN_SOURCE_C,
        LAST_VISIT_SESSIONS_SNAPSHOT_C,
        RECURLY_SUBSCRIBER_C,
        INTERESTED_IN_HOSTED_SOLUTION_C,
        VIDEO_TESTIMONIAL_REFERENCE_C_ACCOUNT,
        SUCCESS_PLAN_URL_C,
        AD_DATA_UP_TO_DATE_AS_OF_C,
        LEAN_DATA_SUB_REGION_C,
        EVENT_DATE_CODE,
        ACCOUNT_OWNERSHIP_NOTES_C,
        POTENTIAL_EE_USERS_C,
        ZI_CERTIFIED_ACTIVE_COMPANY_C,
        ACCOUNT_TYPE_C,
        POSTAL_CODE,
        LAST_SALE_VIA_PARTNER_C,
        MKTO_2_INFERRED_COUNTRY_C,
        MKTO_PERSON_NOTES,
        LAST_AD_CLICK_DATE_C,
        NEXT_FY_ACCOUNT_OWNER_TEMP_C,
        TEMP_ULTIMATE_PARENT_ACCOUNT_DISCO_ORG_ID_C,
        ENGAGIO_IN_PLAY_C,
        CREATED_AT,
        OSS_GIT_LAB_PROFILE_C,
        ZI_NAICS_CODE_C_LEAD,
        BUSINESS_DEVELOPMENT_REP_C,
        TZ_LT_INFO_C_ACCOUNT,
        EDUCATION_LICENSE_USAGE_C,
        E_EP_91_RELEASE_LICENSE_KEY,
        CREATE_ACTIVE_C,
        UPA_IS_HOLDING_COMPANY_C,
        WEBCAST_SPEAKER_REFERENCE_C,
        MKTO_71_ORIGINAL_UTM_CONTENT_C,
        ZI_WITHIN_EU_C,
        HOLDING_COMPANY_NAME_C,
        LAST_EMAIL_DATE_1,
        ATAM_ADDRESS_STREET_C,
        PATH_FACTORY_CONTENT_TITLE_C,
        SUBSCRIBE_ALL_REMOTE,
        REQUEST_FOR_LEAD_CONVERSION_C,
        SUB_REGION_C,
        DATA_QUALITY_DESCRIPTION_C,
        RELEASE_ACTIVE_C,
        SURVEY_NAME,
        DOZISF_ZOOM_INFO_COMPANY_ID_C,
        TERRITORIES_COVERED_C,
        ENGAGIO_TOP_URLS_C,
        PARTNERS_PARTNER_STATUS_C,
        VARTOPIA_DRS_EXPIRED_REGISTRATIONS_C_CONTACT,
        TRIGGER_WORKFLOW_C_LEAD,
        RECURLY_IN_TRIAL_C,
        ENTITY_C,
        MANAGE_ACTIVE_C,
        EVENTATTENDAGAIN,
        DEPLOYMENT_PREFERENCE_C,
        ULTIMATE_PARENT_SALES_SEGMENT_TEXT_DEL_C,
        DIGITAL_OCEAN_PROMO_CODE_C,
        ULTIMATE_PARENT_ADDRESS_COUNTRY_C,
        ZI_SUPPLEMENTAL_EMAIL_C,
        B_TLKLIVE_MINUTES_VIEWED,
        ENGAGIO_FIRST_ENGAGEMENT_DATE_C,
        DFOX_ID_C_ACCOUNT,
        ZI_ZOOM_INFO_CONTACT_PROFILE_URL_C,
        TZ_UTF_OFFSET_C_ACCOUNT,
        USING_CE_C,
        TERMINUS_SPEND_C_ACCOUNT,
        SFSSDUPE_CATCHER_OVERRIDE_DUPE_CATCHER_C_ACCOUNT,
        ESTIMATE_TOTAL_SEATS_AVAIL_AT_COMPANY_C,
        DO_NOT_CONTACT_C,
        FY_22_ON_BRONZE_STARTER_C,
        COUNT_OF_CUSTOMER_ONBOARDINGS_1_4_C,
        HOME_OFFICE_STATE,
        ORIGINAL_SEARCH_PHRASE,
        ZI_PARENT_COMPANY_ZOOMINFO_ID_C,
        MKTO_IS_CUSTOMER,
        LEAN_DATA_REPORTING_TARGET_ACCOUNT_NUMBER_C,
        DOZISF_ZOOM_INFO_ID_C_ACCOUNT,
        IS_ANONYMOUS,
        SUFFIX,
        HAMSTER_RENEWAL_DATE,
        NDE_NODE_PRIORITY_FORMULA_C,
        IS_FILE_LOCKING_CUSTOMER_C,
        MKTO_2_INFERRED_COMPANY_C,
        ATAM_ACCOUNT_CARR_C,
        OUTBOUND_BDR_C_CONTACT,
        B_TLKQUESTIONS_ANSWERED,
        EMAIL_INVALID_CAUSE,
        ECUSTOMS_IM_STATUS_C_ACCOUNT,
        TERMINUS_VELOCITY_LEVEL_C_ACCOUNT,
        COMMENT_HISTORY,
        UNSUBSCRIBED_REASON,
        ZENDESK_NOTES_C_LEAD,
        CE_DOWNLOAD,
        BUYING_PROCESS_FOR_PROCURING_GIT_LAB_C,
        WEB_FORM_C,
        RECURLY_CLOSED_C,
        IS_CONTRACTED_PARTNER_C,
        ACCOUNT_TIER_C,
        CMRR_ALL_CHILD_ACCOUNTS_C,
        ZI_INDUSTRY_C_LEAD,
        ST_PACKAGE_TECH_C,
        ATAM_ADDRESS_STATE_C,
        IMPARTNER_PRM_DEAL_REGISTRATION_STATUS_C,
        RECURLY_COMPANY_C,
        ZI_COMPANY_DESCRIPTION_C,
        NDE_NODE_PRIORITY_FORMULA_C_ACCOUNT,
        ATAM_GEO_STORY_C,
        QUOTE_REFERENCE_C_ACCOUNT,
        DSCORGPKG_LEAD_SOURCE_C,
        QUALIFIED_DATE_TIME_C,
        ST_PLAN_APPETITE_FOR_REPLACEMENT_C,
        MATCHED_STATUS,
        ZI_ZIP_POSTAL_CODE_C,
        ENGAGIO_FIRST_ENGAGEMENT_DATE_C_ACCOUNT,
        AD_CLICKS_ROLLING_30_C,
        ZI_SIC_CODE_C,
        NEXT_FY_USER_GEO_TEMP_C,
        PARENT_ACCOUNT_BILLING_COUNTRY_C,
        ENGAGIO_HIGH_INTENT_KEYWORDS_C,
        RECURLY_UPDATED_AT_C,
        PERSON_SCORE_2,
        EDUCATION_ROLE_C,
        NDE_YOU_SHOULD_MENTION_C,
        NEW_LOGO_TARGET_ACCOUNT_C,
        ACCOUNT_ZIP_MANUAL_USER_C,
        SALES_SEGMENTATION_NEW_C,
        ECCN_QUARANTINE_C,
        DO_NOT_CALL,
        WEB_PORTAL_PURCHASE_COMPANY_SIZE_C,
        ATAM_ADDRESS_COUNTRY_C,
        COUNT_OF_OPEN_RENEWAL_OPPS_THIS_MONTH_C,
        TEMP_DF_HIER_ULTIMATE_PARENT_SEGMENT_E_C,
        ACCOUNT_COUNTRY_MANUAL_ADMIN_C,
        ENTITY_LEGAL_NAME_C,
        EVENT_DATE_CODE_4,
        EVENT_DATE_CODE_3,
        ENGAGIO_MATCHED_ACCOUNT_INDUSTRY_C,
        EVENT_DATE_CODE_2,
        EVENT_DATE_CODE_1,
        DO_NOT_CALL_REASON,
        OPEN_SOURCE_LICENSE_C,
        ZI_TECHNOLOGIES_C_LEAD,
        TEMP_DF_HIER_ULTIMATE_PARENT_BILLING_ST_C,
        TRANSFER_DATE_C,
        JB_OLD_SS_C,
        EMAIL_INVALID,
        SFDC_ACCOUNT_ID,
        IS_GIT_HOST_CUSTOMER_C,
        ACCOUNT_TIER_NOTES_C,
        DATA_QUALITY_SCORE_C_ACCOUNT,
        NEXT_RENEWAL_DATE_C,
        SAME_ACCT_OWNER_AND_UP_ACCT_OWNER_C,
        INQUIRY_SCORE,
        LEAD_SOURCE_C,
        COUNT_OF_NEW_BUSINESS_WON_OPPS_C,
        COUNT_OF_LOST_RENEWAL_OPPORTUNITIES_C,
        ACCOUNT_ZIP_MANUAL_ADMIN_C,
        ZENDESK_ZENDESK_OUTOF_SYNC_C_LEAD,
        INFERRED_COUNTRY,
        NUMBER_OF_OPEN_OPPORTUNITIES_C,
        WON_RENEWAL_OPP_LAST_MONTH_C,
        NAMESPACE,
        ST_PACKAGE_APPETITE_FOR_REPLACEMENT_C,
        UPA_ACCOUNT_TERRITORY_COUNTRY_C,
        BILLING_CITY,
        ZI_COMPANY_PHONE_C,
        TEMP_WEB_STORE_RENEWAL_ISSUE_STATUS_C,
        SUB_INDUSTRY_C,
        ZI_OWNER_C,
        ST_MONITOR_CONTRACT_END_DATE_C,
        MKTO_SI_HIDE_DATE_C,
        DO_YOU_HAVE_A_BUDGET_FOR_THIS_C,
        CONTACT_OWNER_TEAM_C,
        WHERE_ARE_YOU_IN_YOUR_C,
        IMPARTNER_PRM_DATE_ASSIGNED_TO_PARTNER_C,
        FIRST_ORDER_OPPORTUNITY_C,
        WHAT_RELEVANT_PRODUCT_S_WOULD_YOU_C,
        ZENDESK_TAGS_C_LEAD,
        DISCUSS_WHAT_STAGES_OF_DEV_OPS_C,
        DB_WATCH_LIST_CAMPAIGN_CODE_C,
        DB_WATCH_LIST_ACCOUNT_OWNER_C,
        DB_WATCH_LIST_ACCOUNT_TYPE_C,
        PARTNER_CONSENT_C,
        ZI_IT_DEPARTMENT_BUDGET_C,
        CDB_RESP_FOR_GROUP_SAAS_FREE_TIER_C,
        CDB_RESP_FOR_GROUP_SAAS_PREMIUM_TIER_C,
        CDB_RESP_FOR_GROUP_SAA_S_TRIAL_C,
        CDB_IS_GROUP_NAMESPACE_OWNER_C,
        CDB_IS_SELF_MANAGED_ULTIMATE_TIER_C,
        CDB_IND_NAMESPACE_IS_SAA_S_PREMIUM_TIE_C,
        CDB_GROUP_OWNER_OF_SAA_S_FREE_TIER_C,
        CDB_GROUP_MEMBER_OF_SAA_S_FREE_TIER_C,
        CDB_GROUP_MEMBER_OF_SAA_S_BRONZE_TIER_C,
        CDB_GIT_LAB_COM_EMAIL_OPTED_IN_C,
        CDB_IS_SELF_MANAGED_STARTER_TIER_C,
        CDB_GROUP_OWNER_OF_SAA_S_ULTIMATE_TIER_C,
        CDB_GROUP_MEMBER_OF_SAA_S_PREMIUM_TIER_C,
        CDB_IS_INDIVIDUAL_NAMESPACE_OWNER_C,
        CDB_IS_GIT_LAB_COM_USER_C,
        CDB_GROUP_OWNER_OF_SAA_S_PREMIUM_TIER_C,
        CDB_GROUP_OWNER_OF_SAA_S_BRONZE_TIER_C,
        CDB_IS_GROUP_NAMESPACE_MEMBER_C,
        CDB_RESP_FOR_GROUP_SAAS_BRONZE_TIER_C,
        CDB_IS_ZUORA_BILLING_CONTACT_C,
        CDB_IND_NAMESPACE_IS_SAA_S_ULTIMATE_TI_C,
        CDB_IND_NAMESPACE_IS_SAA_S_TRIAL_C,
        CDB_GROUP_MEMBER_OF_SAA_S_ULTIMATE_TIER_C,
        CDB_IS_CUSTOMER_DB_OWNER_C,
        CDB_RESP_FOR_GROUP_SAAS_ULTIMATE_TIER_C,
        CDB_IND_NAMESPACE_IS_SAA_S_FREE_TIER_C,
        CDB_GROUP_OWNER_OF_SAA_S_TRIAL_C,
        CDB_RESPONSIBLE_FOR_FREE_TIER_ONLY_C,
        CDB_IS_SELF_MANAGED_PREMIUM_TIER_C,
        CDB_IS_CUSTOMER_DB_USER_C,
        CDB_GROUP_MEMBER_OF_SAA_S_TRIAL_C,
        CDB_IND_NAMESPACE_IS_SAA_S_BRONZE_TIER_C,
        CDB_IND_NAMESPACE_IS_SAA_S_PREMIUM_TIE_C_CONTACT,
        DO_NOT_EMAIL_REASON,
        CDB_DIM_MARKETING_CONTACT_ID_C,
        CDB_GIT_LAB_COM_ACTIVE_STATE_C,
        CDB_LAST_NAME_C,
        CDB_CUSTOMER_DB_CUSTOMER_ID_C,
        CDB_GIT_LAB_COM_CREATED_DATE_C,
        CDB_CUSTOMER_DB_CONFIRMED_DATE_C,
        CDB_GIT_LAB_COM_CONFIRMED_DATE_C,
        CDB_GIT_LAB_COM_USER_NAME_C,
        CDB_CUSTOMER_DB_CREATED_DATE_C,
        CDB_DAYS_SINCE_SAA_S_TRIAL_ENDED_C,
        CDB_GIT_LAB_COM_LAST_LOGIN_DATE_C,
        CDB_FIRST_NAME_C,
        CDB_ZUORA_CONTACT_ID_C,
        CDB_ZUORA_ACTIVE_STATE_C,
        EMAIL_VERIFICATION_STATUS,
        SETUP_FOR_COMPANY_TEAM_USE_C,
        GACLIENTID_C,
        TSP_DECISION_RATIONALE_C,
        GIT_OPS_SALES_PLAY_C,
        ZI_COMPANY_SIC_CODE_C,
        TEMP_SUBSCRIPTION,
        TEMP_TERM_END_DATE,
        ZI_WEBSITE_C_LEAD,
        ZI_JOB_TITLE_C,
        ZI_FIRST_NAME_C,
        ZI_LAST_NAME_C,
        CRM_PARTNER_ID_C,
        ZI_PHONE_NUMBER_C,
        HEALTH_CHECK_EMPLOYEES_BUCKET_C,
        RING_LEAD_STATUS_C,
        ECIDS,
        KEY_PERSONA_FIRST_ACTION_TIMESTAMP_C,
        KEY_PERSONA_FIRST_ACTION_C,
        WORKED_DATE_C,
        LINKEDIN_SI_COMPANY_PROFILE_C,
        DECISION_MAKER_COUNT_LINKEDIN_C,
        ORDER_TYPE_2_3_OPPS_C,
        IMPARTNER_SYNC_C,
        ZI_SUB_INDUSTRY_C,
        QUALIFICATION_NOTES_C,
        AGGREGATE_DEVELOPER_COUNT_C,
        CDB_COMPANY_NAME_C,
        ZI_FORTUNE_RANKING_C,
        PARTNER_ACCOUNT_CUSTOM_C,
        DOZISF_ZOOM_INFO_NON_MATCHED_REASON_C,
        DOZISF_ZOOM_INFO_ENRICH_STATUS_C,
        PARTER_MISSING_INFO_FOR_CONVERSION_C,
        AVA_AVAAI_HOT_LEAD_C,
        AVA_AVAAI_FURTHER_ACTION_C,
        AVA_AVAAI_LEAD_AT_RISK_C,
        AVA_AVAAI_SMS_OPT_OUT_C,
        AVA_AVAAI_ACTION_REQUIRED_C,
        ZI_SUB_INDUSTRY_C_LEAD,
        VARTOPIA_DRS_PARTNER_ACCOUNT_C,
        CDB_COUNTRY_C,
        AVA_AVAAI_CONVERSICA_LEAD_STATUS_DATE_C,
        AVA_AVAAI_CONVERSICA_LEAD_STATUS_C,
        AVA_AVAAI_CONVERSATION_STAGE_C,
        AVA_AVAAI_LAST_MESSAGE_DATE_C,
        AVA_AVAAI_CONVERSATION_STATUS_DATE_C,
        AVA_AVAAI_CONVERSATION_STAGE_DATE_C,
        AVA_AVAAI_LAST_RESPONSE_DATE_C,
        AVA_AVAAI_HOT_LEAD_DATE_C,
        AVA_AVAAI_DATE_ADDED_C,
        AVA_AVAAI_LEAD_PROFILE_C,
        AVA_AVAAI_CONVERSATION_STATUS_C,
        AVA_AVAAI_FIRST_MESSAGE_DATE_C,
        AVA_AVAAI_DISCOVERED_EMAIL_1_C,
        HOW_MANY_PEOPLE_WILL_BE_EVALUATING_C,
        GROUP_NAMESPACE_ID_C,
        VARTOPIA_DRS_DATE_SHARED_C,
        VARTOPIA_DRS_PARTNER_PROSPECT_ADMIN_EMAIL_NEW_C,
        VARTOPIA_DRS_DATE_ASSIGNED_C,
        VARTOPIA_DRS_DATE_REJECTED_C,
        VARTOPIA_DRS_NUMBER_OF_TIMES_ASSIGNED_C,
        VARTOPIA_DRS_DATE_ACCEPTED_C,
        VARTOPIA_DRS_DATE_RECALLED_C,
        GS_HEALTH_SCM_C,
        GS_HEALTH_OVERALL_PRODUCT_USAGE_C,
        GS_HEALTH_CD_C,
        GS_HEALTH_LICENSE_UTILIZATION_C,
        GS_HEALTH_DEV_SEC_OPS_C,
        AVA_AVAAI_CONFIRMED_PHONE_1_C,
        GS_HEALTH_CI_C,
        PROPOSED_ACCOUNT_OWNER_C,
        PROPOSED_ISR_C,
        LAST_EVENT_PROGRAM_NAME,
        SUB_INDUSTRY_OVERRIDE_C,
        INDUSTRY_OVERRIDE_C,
        AVA_AVAAI_ACTION_REQUIRED_DATE_C,
        AVA_AVAAI_CONFIRMED_PHONE_2_C,
        PARENT_LAM_UPA_AGGREGATE_DEV_COUNT_C,
        AVA_AVAAI_FURTHER_ACTION_DATE_C,
        OUTREACH_ACTIVELY_BEING_SEQUENCED_C,
        EXCLUDE_FROM_ZOOM_INFO_ENRICH_C,
        PREVALENT_TIER_HIERARCHY_C,
        CDB_TIME_SINCE_SAA_S_TRIAL_ENDED_C,
        PQLNAMESPACE_USERS_C,
        PQLNUMBEROFSTAGESACTIVATEDBYNAMESPACE_C,
        PQLSTAGENAMESACTIVATEDBYNAMESPACE_C,
        CDB_TIME_SINCE_SAA_S_TRIAL_OWNER_SIGNUP_C,
        CDB_ZUORA_CREATED_DATE_C,
        CDB_TIME_SINCE_SM_OWNER_TRIAL_SIGN_UP_C,
        ACCOUNT_DEMOGRAPHICS_SALES_SEGMENT_C,
        ACCOUNT_DEMOGRAPHICS_TERRITORY_C_ACCOUNT,
        ACCOUNT_DEMOGRAPHICS_TERRITORY_C,
        ACCOUNT_DEMOGRAPHICS_SALES_SEGMENT_C_ACCOUNT,
        ACCOUNT_DEMOGRAPHICS_REGION_C_ACCOUNT,
        ACCOUNT_DEMOGRAPHICS_REGION_C,
        ACCOUNT_DEMOGRAPHICS_GEO_C,
        ACCOUNT_DEMOGRAPHICS_GEO_C_ACCOUNT,
        VARTOPIA_DRS_PARTNER_PROSPECT_ACCEPTANCE_C,
        ACCOUNT_DEMOGRAPHICS_UPA_STREET_C,
        ACCOUNT_DEMOGRAPHICS_EMPLOYEE_COUNT_C,
        ACCOUNT_DEMOGRAPHICS_UPA_STATE_C,
        LAM_C,
        ACCOUNT_DEMOGRAPHICS_INDUSTRY_C,
        ACCOUNT_DEMOGRAPHICS_AREA_C,
        ACCOUNT_DEMOGRAPHICS_SUB_INDUSTRY_C,
        ACCOUNT_DEMOGRAPHICS_UPA_COUNTRY_C,
        ACCOUNT_DEMOGRAPHICS_MAX_FAMILY_EMPLOYE_C,
        ACCOUNT_DEMOGRAPHICS_LAST_UPDATED_DATE_C,
        ACCOUNT_DEMOGRAPHICS_UPA_POSTAL_CODE_C,
        ACCOUNT_DEMOGRAPHICS_UPA_CITY_C,
        LAM_DEV_COUNT_C,
        BDR_PROSPECTING_STATUS_C,
        MATCHED_ACCOUNT_BDR_PROSPECTING_STATUS_C,
        PQL_NAMESPACE_NAME_C,
        PERSON_LINKEDIN_URL_C,
        RINGLEAD_MERGE_DATE_TIME_C,
        LAST_RINGLEAD_MERGE_DATE_TIME_C,
        DEDICATED_ENGINEERING_C,
        INTEGRATION_SERVICES_C,
        RESTRICTED_ACCOUNT_C,
        VARTOPIA_DRS_FIELDS_UPDATED_ON_C,
        EDUCATION_NEWSLETTER_C,
        VARTOPIA_DRS_VARTOPIA_PARTNER_ACCOUNT_C,
        PQL_NAMESPACE_ID_C,
        PQL_USAGE_PACKET_C,
        LAM_TIER_C,
        BLOCK_MARKETO_SYNC_C,
        LEAD_ACQUISITION_SOURCE_C,
        PTC_SCORE_VALUE_C,
        PTE_SCORE_VALUE_C,
        SALES_TERRITORY_C,
        HIGH_PRIORITY_C,
        UNSUBSCRIBED_REASON_DETAIL,
        MATCHED_ACCOUNT_KEY_ACCOUNT_C,
        SIGNUP_REASON_C,
        HIGH_PRIORITY_TIMESTAMP_C,
        MATCHED_ACCOUNT_LAM_DEV_COUNT_C,
        HIGH_CONVERSION_COHORT_C,
        IMPACTED_BY_USER_LIMIT_C,
        IMPACTED_BY_STORAGE_LIMIT_C,
        IMPACT_STRING_C,
        CDB_GIT_LAB_COM_USER_ID_C,
        CDB_IMPACTED_BY_STORAGE_LIMIT_C,
        PATHFACTORY_LANGUAGE,
        KEY_ACCOUNT_C,
        ACCOUNT_FAMILY_HIGHEST_ZSUB_END_DATE_C,
        USER_C,
        UNKNOWN_ACCOUNT_C,
        CUSTOMER_HEIRARCHY_C,
        ZI_DO_NOT_CALL_MOBILE_PHONE_C,
        ZI_DO_NOT_CALL_DIRECT_PHONE_C,
        CAMPAIGN_NOTES_C,
        PQLNAMESPACECREATORJOBDESCRIPTION_C,
        PQLNAMESOF_INTEGRATIONS_INSTALLED_C,
        PQLNUMBEROF_INTEGRATIONS_INSTALLED_C,
        EMAIL_DOMAIN,
        HIDDEN_DIRECT_PHONE_NUMBER_DNC_C,
        VARTOPIA_DRS_PARTNER_PROSPECT_STATUS_C,
        IS_FIRST_ORDER_PERSON_C,
        PARTNER_MANAGED_C,
        PROSPECT_HEIRARCHY_C,
        FORMER_CUSTOMER_ACCOUNT_C,
        TEAM_OPS_OPT_IN_C,
        CDB_USER_IS_MEMBER_OF_PUBLIC_ULTIMATE_C,
        CDB_USER_IS_MEMBER_OF_PRIVATE_ULTIMATE_C,
        PTPT_PAST_SCORE_GROUP_C,
        PTPT_NAMESPACE_ID_C,
        PTPT_SCORE_DATE_C,
        PTPT_INSIGHTS_C,
        PTPT_SCORE_GROUP_C,
        IMPARTNER_WEB_FORM_C,
        VARTOPIA_DRS_PARTNER_PROSPECT_ADMIN_EMAIL_C,
        VARTOPIA_DRS_VARTOPIA_TRANSACTION_ID_C,
        INELIGIBLE_REASON_C,
        ZOOM_APP_IS_CREATED_BY_ZOOM_APP_C,
        CHANNEL_RECORD_C,
        EMAIL_BOUNCE_CATEGORY,
        EMAIL_BOUNCES,
        EMAIL_BOUNCE_DETAILS,
        EMAIL_BOUNCE_SUBJECT_LANE,
        EMAIL_BOUNCE_DATE_MKTO,
        DELIVERS_AFTER_BOUNCES,
        EMAIL_DELIVERED_AFTER_BOUNCE,
        VARTOPIA_ACCEPTED_DATE_C,
        VARTOPIA_CREATED_DATE_C,
        VARTOPIA_RECALL_DATE_C,
        WORKING_CITY_C,
        WORKING_STATE_C,
        O_N_24_QA,
        O_N_24_SURVEY_QUESTION_4,
        O_N_24_SURVEY_QUESTION_5,
        O_N_24_SURVEY_QUESTION_1,
        O_N_24_SURVEY_QUESTION_2,
        O_N_24_SURVEY_QUESTION_3,
        ON_24_NOTE_UPLOAD_ACTIVATE,
        O_N_24_SURVEY_ANSWER_4,
        O_N_24_SURVEY_ANSWER_5,
        ON_24_POLL_QUESTION_1,
        ON_24_POLL_QUESTION_4,
        O_N_24_SURVEY_ANSWER_1,
        ON_24_POLL_QUESTION_5,
        O_N_24_SURVEY_ANSWER_2,
        ON_24_POLL_QUESTION_2,
        O_N_24_SURVEY_ANSWER_3,
        ON_24_POLL_QUESTION_3,
        ON_24_POLL_COMBINE_3,
        ON_24_POLL_ANSWER_2,
        ON_24_POLL_ANSWER_3,
        ON_24_POLL_ANSWER_4,
        ON_24_POLL_COMBINE_1,
        ON_24_POLL_ANSWER_5,
        ON_24_POLL_COMBINE_2,
        ON_24_POLL_ANSWER_1,
        ON_24_SURVEY_COMBINE_3,
        ON_24_SURVEY_COMBINE_2,
        ON_24_SURVEY_COMBINE_1,
        PARTNER_TYPE_C,
        LAST_LEAD_SOURCE_C,
        SCORE_C,
        LAST_LEAD_SOURCE_DETAILS_C,
        CDB_USER_LIMIT_ENFORCEMENT_DATE_C,
        CDB_USER_LIMIT_NOTIFICATION_DATE_C,
        PREFERRED_LANGUAGE_C,
        ACCOUNT_DEMOGRAPHICS_SALES_SEGMENT_2_C,
        CDB_USER_LIMIT_IMPACTED_NAMESPACE_C,
        PUBSEC_TYPE_C_CONTACT,
        PUBSEC_TYPE_C,
        HIDDEN_MOBILE_PHONE_NUMBER_DNC_C,
        STAMPED_ACCOUNT_DEMO_SEGMENT_C,
        RECORD_SALES_OWNER_EMAIL,
        VARTOPIA_DRS_CLOSED_LOST_REGISTRATIONS_PERCENTAGE_C_CONTACT,
        VARTOPIA_DRS_EXPIRED_REGISTRATIONS_PERCENTAGE_C,
        VARTOPIA_DRS_APPROVED_REGISTRATION_PERCENTAGE_C_CONTACT,
        VARTOPIA_DRS_CLOSED_WON_REGISTRATIONS_PERCENTAGE_C,
        VARTOPIA_DRS_CLOSED_WON_REGISTRATIONS_PERCENTAGE_C_CONTACT,
        VARTOPIA_DRS_APPROVED_REGISTRATION_PERCENTAGE_C,
        VARTOPIA_DRS_CLOSED_LOST_REGISTRATIONS_PERCENTAGE_C,
        VARTOPIA_DRS_DENIED_REGISTRATIONS_PECENTAGE_C,
        VARTOPIA_DRS_DENIED_REGISTRATIONS_PECENTAGE_C_CONTACT,
        VARTOPIA_DRS_EXPIRED_REGISTRATIONS_PERCENTAGE_C_CONTACT,
        UNSUBSCRIBE_ALL_MARKETING,
        COMPANY_ADDRESS_POSTAL_CODE_C,
        COMPANY_ADDRESS_CITY_C,
        COMPANY_ADDRESS_STATE_C,
        COMPANY_ADDRESS_COUNTRY_C,
        COMPANY_ADDRESS_STREET_C,
        ACCOUNT_DEMOGRAPHICS_UPA_STATE_NAME_C,
        PARTNER_RECALLED_C,
        ACCOUNT_DEMOGRAPHICS_UPA_COUNTRY_NAME_C,
        OUTREACH_DATE_ADDED_TO_SEQUENCE_C,
        TRAC_HIER_DOMAIN_C,
        TRAC_HIER_OWNER_C,
        TRAC_HIER_EXCLUDED_FROM_ACCOUNT_HIERARCHIES_C,
        TRAC_HIER_GLOBAL_ULTIMATE_GROUPING_ID_C,
        TRAC_HIER_RE_RUN_TRACTION_HIERARCHIES_C,
        TRAC_HIER_DISABLE_HIERARCHIES_C,
        TRAC_HIER_HIERARCHY_ID_C,
        TRAC_HIER_PARENT_COMPANY_C,
        TRAC_HIER_DUNS_GLOBAL_ULTIMATE_PARENT_C,
        TRAC_RTC_DISABLE_COMPLETE_C,
        TRAC_RTC_RESTORE_TO_ORIGINAL_LEAD_C,
        TRAC_RTC_TIME_DELAY_PROCESSED_C_CONTACT,
        TRAC_RTC_REALTIME_CLEAN_FAILED_C,
        TRAC_RTC_REALTIME_CLEAN_PROCESSED_C,
        TRAC_RTC_DATE_OF_LAST_COMPLETION_C_CONTACT,
        TRAC_RTC_REALTIME_CLEAN_CONTACT_MATCH_C,
        TRAC_RTC_REALTIME_CLEAN_FAILED_C_CONTACT,
        TRAC_RTC_TRACTION_COMPLETE_STATUS_TEXT_C,
        TRAC_RTC_TIME_DELAY_PROCESSED_C,
        TRAC_RTC_TRACTION_COMPLETE_DOMAIN_C_CONTACT,
        TRAC_RTC_WEBSITE_DOMAIN_C,
        TRAC_RTC_TRACTION_COMPLETE_STATUS_C,
        TRAC_RTC_ORIGINAL_COMPLETION_DATE_C_CONTACT,
        TRAC_RTC_REALTIME_CLEAN_COMPANY_MATCH_C,
        TRAC_RTC_RE_RUN_REALTIME_CLEAN_C_CONTACT,
        TRAC_RTC_TRACTION_COMPLETE_DOMAIN_C,
        TRAC_RTC_RE_RUN_REALTIME_CLEAN_C,
        TRAC_RTC_TRACTION_COMPLETE_LEAD_MATCH_C,
        TRAC_RTC_DISABLE_COMPLETE_C_CONTACT,
        TRAC_RTC_TRACTION_COMPLETE_CUSTOM_MATCH_C,
        TRAC_RTC_REALTIME_CLEAN_PROCESSED_C_CONTACT,
        TRAC_RTC_ORIGINAL_LEAD_DATA_C,
        TRAC_RTC_MATCH_TYPE_C,
        TRAC_RTC_REALTIME_CLEAN_ERROR_MESSAGE_C,
        TRAC_RTC_ACCOUNT_C,
        TRAC_RTC_ORIGINAL_COMPLETION_DATE_C,
        TRAC_RTC_DATE_OF_LAST_COMPLETION_C,
        TRAC_RTC_TRACTION_COMPLETE_MATCH_KEY_C,
        TRAC_HIER_PRIMARY_MASTER_ACCOUNT_C,
        TRAC_RTC_REALTIME_CLEAN_ERROR_MESSAGE_C_CONTACT,
        SINGLE_USE_FIELD,
        ENGAGEMENT_MANAGER_C,
        COGNISM_EMAIL_C,
        ZI_EMAIL_C,
        TRAC_HIER_LAST_BUILD_HIERARCHY_DATE_C,
        CANADA_EMAIL_NO_MATCH,
        CANADA_ZI,
        CANADA_ZI_EMAIL_NO_MATCH,
        PTP_PAST_INSIGHTS_C,
        PTP_INSIGHTS_C,
        PTP_SCORE_DATE_C,
        PTP_NAMESPACE_ID_C,
        PTP_SCORE_GROUP_C,
        PTP_PAST_SCORE_GROUP_C,
        ZI_RECORD_PURCHASED_DATE_C,
        PTP_DAYS_SINCE_TRIAL_START_C,
        PHOTOGRAPHY_WAIVER,
        CDB_GROUP_MAINTAINER_OF_SAA_S_PAID_TIER_C,
        DIETARY_ALLERGY_YESNO,
        DIETARY_RESTRICTION_ALLERGY,
        DIETARY_RESTRICTION_DETAIL,
        PHYSICAL_ASSISTANCE_NEEDS,
        EMERGENCY_CONTACT,
        EMERGENCY_CONTACT_PHONE_NUMBER,
        INTEGER_OPEN_FIELD,
        TEXT_AREA_OPEN_FIELD,
        STARTUPS_PROGRAM_STATUS_C,
        DIETARY_RESTRICTIONS_OTHER_2,
        PLANNING_TO_ATTEND_YES_NO,
        SPECIAL_EVENT_INVITE,
        EVENT_DATE_CODE_5,
        PHYSICAL_ASSISTANCE_DETAILS,
        CONTENT_SYNDICATION_ASSET,
        ZI_ULTIMATE_PARENT_ID_C,
        ZI_ULTIMATE_PARENT_NAME_C,
        JOIN_FOR_MAIN_EVENT,
        TRAC_RTC_FIRST_RESPONSE_TIME_IN_SECONDS_C_CONTACT,
        TRAC_RTC_FIRST_RESPONSE_TIME_START_C_CONTACT,
        TRAC_RTC_RESPONSE_TIME_WITHIN_BUSINESS_HOURS_C_CONTACT,
        ZOOM_INFO_ZILIST_TAG,
        CPE_CREDIT,
        IMPARTNER_PRM_PARTNER_ACCOUNT_C,
        INTEGRATE_LEAD_ID,
        VARTOPIA_DRS_ACTIVATE_ACCOUNT_MAPPING_C,
        VARTOPIA_DRS_REJECTION_REASON_C,
        NONPROFITMISSION,
        NONPROFITFOCUSAREA,
        CANADA_EMAIL_CHECK,
        DAYS_SINCE_LAST_ACTIVITY_QUALIFIED_C,
        SHIRT_SIZE_C,
        TRIAL_LICENSE_KEY_2023,
        CDB_DAYS_SINCE_SELF_MANAGED_OWNER_SIGNUP_C,
        PTP_SOURCE_C,
        CDB_DAYS_SINCE_SAA_S_SIGNUP_C,
        MATCHABLE_GENERIC_EMAIL,
        IS_DEFAULTED_TRIAL_C,
        SCORETESTING,
        DEMOGRAPHIC_SCORE_AT_MQL,
        BEHAVIOR_SCORE_AT_MQL,
        TRAC_RTC_TRACTION_COMPLETE_PAUSED_C_CONTACT,
        TRAC_RTC_TRACTION_COMPLETE_PAUSED_C,
        SECURITY_UNSUBSCRIBE,
        G_2_ACTION,
        SAFEBASE_CONTACT_REQUIRED_FOR_ACCOUNT_CREATION_C_CONTACT,
        SAFEBASE_INVITED_C,
        SAFEBASE_NDA_DONE_C,
        SAFEBASE_CONTACT_REQUIRED_FOR_ACCOUNT_CREATION_C,
        SUB_INDUSTRY_ACCT_HIERARCHY_C,
        LAST_CRMPARTNER_ID,
        SUBSCRIBE_COMMUNITY_NEWSLETTER,
        ABM_TIER_C_LEAD,
        SPECIAL_REQUESTS,
        LEAD_SCORE_CLASSIFICATION_C,
        PARTNER_TRIAL,
        GITLAB_HANDLE_BETA,
        GITLAB_PERSONA_BETA,
        GITLAB_PROJECT_ID_BETA,
        GITLAB_PERSONA_2_BETA
    FROM source
    QUALIFY ROW_NUMBER() OVER(PARTITION BY id ORDER BY updated_at DESC) = 1
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".marketo.marketo_activity_delete_lead_source as
WITH source AS (
    SELECT *
    FROM "RAW".marketo.activity_delete_lead
), renamed AS (
    SELECT
      id::NUMBER                                AS marketo_activity_delete_lead_id,
      lead_id::NUMBER                           AS lead_id,
      activity_date::TIMESTAMP_TZ               AS activity_date,
      activity_type_id::NUMBER                  AS activity_type_id,
      campaign_id::NUMBER                       AS campaign_id,
      primary_attribute_value_id::NUMBER        AS primary_attribute_value_id,
      primary_attribute_value::TEXT             AS primary_attribute_value,
      campaign::TEXT                            AS campaign
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".gitlab_data_yaml.content_keystone_source as
SELECT DISTINCT
      flattened_keystone.value:name::VARCHAR        AS content_name,
      flattened_keystone.value:gitlab_epic::VARCHAR AS gitlab_epic,
      flattened_keystone.value:gtm::VARCHAR         AS gtm,
      flattened_keystone.value:type::VARCHAR        AS type,
      flattened_keystone.value:url_slug::VARCHAR    AS url_slug,
      flattened_keystone.value                      AS full_value
FROM "RAW".gitlab_data_yaml.content_keystone,
    LATERAL FLATTEN(input => PARSE_JSON(content_keystone.jsontext)) AS flattened_keystone;

CREATE TABLE "PREP".sheetload.sheetload_mapping_sdr_sfdc_bamboohr_source as
WITH source AS (
    SELECT *
    FROM "RAW".sheetload.mapping_sdr_sfdc_bamboohr
), renamed as (
    SELECT
      user_id::VARCHAR                      AS user_id,
      first_name::VARCHAR                   AS first_name,
      last_name::VARCHAR                    AS last_name,
      username::VARCHAR                     AS username,
      active::NUMBER                        AS active,
      profile::VARCHAR                      AS profile,
      eeid::NUMBER                          AS eeid,
      sdr_segment::VARCHAR                  AS sdr_segment,
      sdr_region::VARCHAR                   AS sdr_region,
      sdr_order_type::VARCHAR               AS sdr_order_type
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".date.date_details_source as
WITH date_spine AS (
with rawdata as (
    with p as (
        select 0 as generated_number union all select 1
    ), unioned as (
    select
    p0.generated_number * power(2, 0)
     +
    p1.generated_number * power(2, 1)
     +
    p2.generated_number * power(2, 2)
     +
    p3.generated_number * power(2, 3)
     +
    p4.generated_number * power(2, 4)
     +
    p5.generated_number * power(2, 5)
     +
    p6.generated_number * power(2, 6)
     +
    p7.generated_number * power(2, 7)
     +
    p8.generated_number * power(2, 8)
     +
    p9.generated_number * power(2, 9)
     +
    p10.generated_number * power(2, 10)
     +
    p11.generated_number * power(2, 11)
     +
    p12.generated_number * power(2, 12)
     +
    p13.generated_number * power(2, 13)
     +
    p14.generated_number * power(2, 14)
    + 1
    as generated_number
    from
    p as p0
     cross join
    p as p1
     cross join
    p as p2
     cross join
    p as p3
     cross join
    p as p4
     cross join
    p as p5
     cross join
    p as p6
     cross join
    p as p7
     cross join
    p as p8
     cross join
    p as p9
     cross join
    p as p10
     cross join
    p as p11
     cross join
    p as p12
     cross join
    p as p13
     cross join
    p as p14
    )
    select *
    from unioned
    where generated_number <= 20176
    order by generated_number
),
all_periods as (
    select (
    dateadd(
        day,
        row_number() over (order by 1) - 1,
        to_date('11/01/2009', 'mm/dd/yyyy')
        )
    ) as date_day
    from rawdata
),
filtered as (
    select *
    from all_periods
    where date_day <= dateadd(year, 40, current_date)
)
select * from filtered
),
calculated AS (
  SELECT
    date_day,
    date_day                                                                                AS date_actual,
    DAYNAME(date_day)                                                                       AS day_name,
    DATE_PART('month', date_day)                                                            AS month_actual,
    DATE_PART('year', date_day)                                                             AS year_actual,
    DATE_PART(QUARTER, date_day)                                                            AS quarter_actual,
    DATE_PART(DAYOFWEEKISO, date_day)                                                       AS day_of_week,
    CASE WHEN day_name = 'Mon' THEN date_day
      ELSE DATE_TRUNC('week', date_day)
    END                                                                                     AS first_day_of_week,
    WEEK(date_day)                                                                          AS week_of_year,
    DATE_PART('day', date_day)                                                              AS day_of_month,
    ROW_NUMBER() OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day)          AS day_of_quarter,
    ROW_NUMBER() OVER (PARTITION BY year_actual ORDER BY date_day)                          AS day_of_year,
    CASE WHEN month_actual < 2
        THEN year_actual
      ELSE (year_actual + 1)
    END                                                                                     AS fiscal_year,
    CASE WHEN month_actual < 2 THEN '4'
      WHEN month_actual < 5 THEN '1'
      WHEN month_actual < 8 THEN '2'
      WHEN month_actual < 11 THEN '3'
      ELSE '4'
    END                                                                                     AS fiscal_quarter,
    ROW_NUMBER() OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day)          AS day_of_fiscal_quarter,
    ROW_NUMBER() OVER (PARTITION BY fiscal_year ORDER BY date_day)                          AS day_of_fiscal_year,
    TO_CHAR(date_day, 'MMMM')                                                               AS month_name,
    TRUNC(date_day, 'Month')                                                                AS first_day_of_month,
    LAST_VALUE(date_day) OVER (PARTITION BY year_actual, month_actual ORDER BY date_day)    AS last_day_of_month,
    FIRST_VALUE(date_day) OVER (PARTITION BY year_actual ORDER BY date_day)                 AS first_day_of_year,
    LAST_VALUE(date_day) OVER (PARTITION BY year_actual ORDER BY date_day)                  AS last_day_of_year,
    FIRST_VALUE(date_day) OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day) AS first_day_of_quarter,
    LAST_VALUE(date_day) OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day)  AS last_day_of_quarter,
    FIRST_VALUE(date_day) OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day) AS first_day_of_fiscal_quarter,
    LAST_VALUE(date_day) OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day)  AS last_day_of_fiscal_quarter,
    FIRST_VALUE(date_day) OVER (PARTITION BY fiscal_year ORDER BY date_day)                 AS first_day_of_fiscal_year,
    LAST_VALUE(date_day) OVER (PARTITION BY fiscal_year ORDER BY date_day)                  AS last_day_of_fiscal_year,
    DATEDIFF('week', first_day_of_fiscal_year, date_actual) + 1                             AS week_of_fiscal_year,
    FLOOR((DATEDIFF(DAY, first_day_of_fiscal_quarter, date_actual) / 7))
      AS week_of_fiscal_quarter,
    CASE WHEN EXTRACT('month', date_day) = 1 THEN 12
      ELSE EXTRACT('month', date_day) - 1
    END                                                                                     AS month_of_fiscal_year,
    LAST_VALUE(date_day) OVER (PARTITION BY first_day_of_week ORDER BY date_day)            AS last_day_of_week,
    (year_actual || '-Q' || EXTRACT(QUARTER FROM date_day))                                 AS quarter_name,
    (fiscal_year || '-' || DECODE(
      fiscal_quarter,
      1, 'Q1',
      2, 'Q2',
      3, 'Q3',
      4, 'Q4'
    ))                                                                                      AS fiscal_quarter_name,
    ('FY' || SUBSTR(fiscal_quarter_name, 3, 7))                                             AS fiscal_quarter_name_fy,
    DENSE_RANK() OVER (ORDER BY fiscal_quarter_name)                                        AS fiscal_quarter_number_absolute,
    fiscal_year || '-' || MONTHNAME(date_day)                                               AS fiscal_month_name,
    ('FY' || SUBSTR(fiscal_month_name, 3, 8))                                               AS fiscal_month_name_fy,
    (CASE WHEN MONTH(date_day) = 1 AND DAYOFMONTH(date_day) = 1 THEN 'New Year''s Day'
      WHEN MONTH(date_day) = 12 AND DAYOFMONTH(date_day) = 25 THEN 'Christmas Day'
      WHEN MONTH(date_day) = 12 AND DAYOFMONTH(date_day) = 26 THEN 'Boxing Day'
    END)::VARCHAR                                                                           AS holiday_desc,
    (CASE WHEN holiday_desc IS NULL THEN 0
      ELSE 1
    END)::BOOLEAN                                                                           AS is_holiday,
    DATE_TRUNC('month', last_day_of_fiscal_quarter)                                         AS last_month_of_fiscal_quarter,
    IFF(DATE_TRUNC('month', last_day_of_fiscal_quarter) = date_actual, TRUE, FALSE)         AS is_first_day_of_last_month_of_fiscal_quarter,
    DATE_TRUNC('month', last_day_of_fiscal_year)                                            AS last_month_of_fiscal_year,
    IFF(DATE_TRUNC('month', last_day_of_fiscal_year) = date_actual, TRUE, FALSE)            AS is_first_day_of_last_month_of_fiscal_year,
    DATEADD('day', 7, DATEADD('month', 1, first_day_of_month))                              AS snapshot_date_fpa,
    DATEADD('day', 4, DATEADD('month', 1, first_day_of_month))                              AS snapshot_date_fpa_fifth,
    DATEADD('day', 44, DATEADD('month', 1, first_day_of_month))                             AS snapshot_date_billings,
    COUNT(date_actual) OVER (PARTITION BY first_day_of_month)                               AS days_in_month_count,
    COUNT(date_actual) OVER (PARTITION BY fiscal_quarter_name_fy)                           AS days_in_fiscal_quarter_count,
    90 - DATEDIFF(DAY, date_actual, last_day_of_fiscal_quarter)                             AS day_of_fiscal_quarter_normalised,
    12 - FLOOR((DATEDIFF(DAY, date_actual, last_day_of_fiscal_quarter) / 7))                AS week_of_fiscal_quarter_normalised,
    CASE
      WHEN week_of_fiscal_quarter_normalised < 5
        THEN week_of_fiscal_quarter_normalised
      WHEN week_of_fiscal_quarter_normalised < 9
        THEN week_of_fiscal_quarter_normalised - 4
      ELSE week_of_fiscal_quarter_normalised - 8
    END                                                                                     AS week_of_month_normalised,
    365 - DATEDIFF(DAY, date_actual, last_day_of_fiscal_year)                               AS day_of_fiscal_year_normalised,
    CASE
      WHEN (
        (DATEDIFF(DAY, date_actual, last_day_of_fiscal_quarter) - 6) % 7 = 0
        OR date_actual = first_day_of_fiscal_quarter
      )
        THEN 1
      ELSE 0
    END                                                                                     AS is_first_day_of_fiscal_quarter_week,
    DATEDIFF('day', date_day, last_day_of_month)                                            AS days_until_last_day_of_month
  FROM date_spine
),
current_date_information AS (
  SELECT
    fiscal_year                       AS current_fiscal_year,
    first_day_of_fiscal_year          AS current_first_day_of_fiscal_year,
    fiscal_quarter_name_fy            AS current_fiscal_quarter_name_fy,
    first_day_of_month                AS current_first_day_of_month,
    first_day_of_fiscal_quarter       AS current_first_day_of_fiscal_quarter,
    date_actual                       AS current_date_actual,
    day_name                          AS current_day_name,
    first_day_of_week                 AS current_first_day_of_week,
    day_of_fiscal_quarter_normalised  AS current_day_of_fiscal_quarter_normalised,
    week_of_fiscal_quarter_normalised AS current_week_of_fiscal_quarter_normalised,
    week_of_fiscal_quarter            AS current_week_of_fiscal_quarter,
    day_of_month                      AS current_day_of_month,
    day_of_fiscal_quarter             AS current_day_of_fiscal_quarter,
    day_of_fiscal_year                AS current_day_of_fiscal_year
  FROM calculated
  WHERE CURRENT_DATE = date_actual
),
final AS (
  SELECT
    calculated.date_day,
    calculated.date_actual,
    calculated.day_name,
    calculated.month_actual,
    calculated.year_actual,
    calculated.quarter_actual,
    calculated.day_of_week,
    calculated.first_day_of_week,
    calculated.week_of_year,
    calculated.day_of_month,
    calculated.day_of_quarter,
    calculated.day_of_year,
    calculated.fiscal_year,
    calculated.fiscal_quarter,
    calculated.day_of_fiscal_quarter,
    calculated.day_of_fiscal_year,
    calculated.month_name,
    calculated.first_day_of_month,
    calculated.last_day_of_month,
    calculated.first_day_of_year,
    calculated.last_day_of_year,
    calculated.first_day_of_quarter,
    calculated.last_day_of_quarter,
    calculated.first_day_of_fiscal_quarter,
    calculated.last_day_of_fiscal_quarter,
    calculated.first_day_of_fiscal_year,
    calculated.last_day_of_fiscal_year,
    calculated.week_of_fiscal_year,
    calculated.week_of_fiscal_quarter,
    calculated.month_of_fiscal_year,
    calculated.last_day_of_week,
    calculated.quarter_name,
    calculated.fiscal_quarter_name,
    calculated.fiscal_quarter_name_fy,
    calculated.fiscal_quarter_number_absolute,
    calculated.fiscal_month_name,
    calculated.fiscal_month_name_fy,
    calculated.holiday_desc,
    calculated.is_holiday,
    calculated.last_month_of_fiscal_quarter,
    calculated.is_first_day_of_last_month_of_fiscal_quarter,
    calculated.last_month_of_fiscal_year,
    calculated.is_first_day_of_last_month_of_fiscal_year,
    calculated.snapshot_date_fpa,
    calculated.snapshot_date_fpa_fifth,
    calculated.snapshot_date_billings,
    calculated.days_in_month_count,
    calculated.days_in_fiscal_quarter_count,
    calculated.week_of_month_normalised,
    calculated.day_of_fiscal_quarter_normalised,
    calculated.week_of_fiscal_quarter_normalised,
    calculated.day_of_fiscal_year_normalised,
    calculated.is_first_day_of_fiscal_quarter_week,
    calculated.days_until_last_day_of_month,
    current_date_information.current_date_actual,
    current_date_information.current_day_name,
    current_date_information.current_first_day_of_week,
    current_date_information.current_day_of_fiscal_quarter_normalised,
    current_date_information.current_week_of_fiscal_quarter_normalised,
    current_date_information.current_week_of_fiscal_quarter,
    current_date_information.current_fiscal_year,
    current_date_information.current_first_day_of_fiscal_year,
    current_date_information.current_fiscal_quarter_name_fy,
    current_date_information.current_first_day_of_month,
    current_date_information.current_first_day_of_fiscal_quarter,
    current_date_information.current_day_of_month,
    current_date_information.current_day_of_fiscal_quarter,
    current_date_information.current_day_of_fiscal_year,
    IFF(calculated.day_of_month <= current_date_information.current_day_of_month, TRUE, FALSE)                                             AS is_fiscal_month_to_date,
    IFF(calculated.day_of_fiscal_quarter <= current_date_information.current_day_of_fiscal_quarter, TRUE, FALSE)                           AS is_fiscal_quarter_to_date,
    IFF(calculated.day_of_fiscal_year <= current_date_information.current_day_of_fiscal_year, TRUE, FALSE)                                 AS is_fiscal_year_to_date,
    DATEDIFF('days', calculated.date_actual, CURRENT_DATE)                                                                                 AS fiscal_days_ago,
    DATEDIFF('week', calculated.date_actual, CURRENT_DATE)                                                                                 AS fiscal_weeks_ago,
    DATEDIFF('months', calculated.first_day_of_month, current_date_information.current_first_day_of_month)                                 AS fiscal_months_ago,
    ROUND(DATEDIFF('months', calculated.first_day_of_fiscal_quarter, current_date_information.current_first_day_of_fiscal_quarter) / 3, 0) AS fiscal_quarters_ago,
    ROUND(DATEDIFF('months', calculated.first_day_of_fiscal_year, current_date_information.current_first_day_of_fiscal_year) / 12, 0)      AS fiscal_years_ago,
    IFF(calculated.date_actual = CURRENT_DATE, 1,0)                                                                                        AS is_current_date
  FROM calculated
  CROSS JOIN current_date_information
)
SELECT *
FROM final;

CREATE TABLE "PROD".legacy.sfdc_record_type as
WITH source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_record_type_source
)
SELECT *
FROM source;

CREATE TABLE "PROD".legacy.sheetload_bizible_to_pathfactory_mapping as
WITH source AS (
        SELECT *
        FROM "PREP".sheetload.sheetload_bizible_to_pathfactory_mapping_source
        )
        SELECT *
        FROM source;

CREATE TABLE "PROD".legacy.sfdc_user_snapshots_source as
WITH source AS (
    SELECT *
    FROM "RAW".snapshots.sfdc_user_snapshots
    QUALIFY ROW_NUMBER() OVER (
    PARTITION BY
        dbt_valid_from::DATE,
        id
    ORDER BY dbt_valid_from DESC
    ) = 1
), renamed AS(
    SELECT
      -- ids
      id                                                                AS user_id,
      name                                                              AS name,
      email                                                             AS user_email,
      employeenumber                                                    AS employee_number,
      -- info
      title                                                             AS title,
      team__c                                                           AS team,
      department                                                        AS department,
      managerid                                                         AS manager_id,
      manager_name__c                                                   AS manager_name,
      isactive                                                          AS is_active,
      userroleid                                                        AS user_role_id,
      user_role_type__c                                                 AS user_role_type,
      role_level_1__c                                                   AS user_role_level_1,
      role_level_2__c                                                   AS user_role_level_2,
      role_level_3__c                                                   AS user_role_level_3,
      role_level_4__c                                                   AS user_role_level_4,
      role_level_5__c                                                   AS user_role_level_5,
      start_date__c                                                     AS start_date,
      ramping_quota__c                                                  AS ramping_quota,
      CASE WHEN LOWER(user_segment__c) = 'smb' THEN 'SMB'
     WHEN LOWER(user_segment__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(user_segment__c) = 'public sector' THEN 'PubSec'
     WHEN LOWER(user_segment__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(user_segment__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(user_segment__c) IS NULL THEN 'SMB'
     WHEN LOWER(user_segment__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(user_segment__c) = 'lrg' THEN 'Large'
     WHEN LOWER(user_segment__c) = 'jihu' THEN 'JiHu'
     WHEN user_segment__c IS NOT NULL THEN user_segment__c
END   AS user_segment,
      user_geo__c                                                       AS user_geo,
      user_region__c                                                    AS user_region,
      user_area__c                                                      AS user_area,
      user_business_unit__c                                             AS user_business_unit,
      user_segment_geo_region_area__c                                   AS user_segment_geo_region_area,
      timezonesidkey                                                    AS user_timezone,
      CASE
        WHEN user_segment IN ('Large', 'PubSec') THEN 'Large'
        ELSE user_segment
      END                                                               AS user_segment_grouped,
      CASE
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo) = 'AMER' AND UPPER(user_region) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo) IN ('AMER', 'LATAM') AND UPPER(user_region) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN user_geo
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_region) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(user_segment) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(user_segment) NOT IN ('LARGE', 'PUBSEC')
    THEN user_segment
  ELSE 'Missing segment_region_grouped'
END
                                                                        AS user_segment_region_grouped,
      hybrid__c                                                         AS is_hybrid_user,
      --metadata
      createdbyid                                                       AS created_by_id,
      createddate                                                       AS created_date,
      lastmodifiedbyid                                                  AS last_modified_id,
      lastmodifieddate                                                  AS last_modified_date,
      systemmodstamp,
      --dbt last run
      convert_timezone('America/Los_Angeles',convert_timezone('UTC',current_timestamp())) AS _last_dbt_run,
      -- snapshot metadata
      dbt_scd_id,
      dbt_updated_at,
      dbt_valid_from,
      dbt_valid_to
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PROD".restricted_safe_common_mapping.map_merged_crm_account as
WITH last_account_snapshot AS (
    SELECT *
    FROM "PROD".legacy.sfdc_account_snapshots_source
    WHERE dbt_valid_to IS NULL
), unioned AS (
    SELECT
      account_id,
      master_record_id,
      is_deleted
    FROM "PREP".sfdc.sfdc_account_source
    UNION ALL
    /*
      Union in accounts which have been hard deleted but are captured in the snapshot models for completeness.
    */
    SELECT
      last_account_snapshot.account_id,
      last_account_snapshot.master_record_id,
      last_account_snapshot.is_deleted
    FROM last_account_snapshot
    LEFT JOIN "PREP".sfdc.sfdc_account_source
      ON last_account_snapshot.account_id = sfdc_account_source.account_id
    WHERE sfdc_account_source.account_id IS NULL
), recursive_cte(account_id, master_record_id, is_deleted, lineage) AS (
    SELECT
      account_id,
      master_record_id,
      is_deleted,
      TO_ARRAY(account_id) AS lineage
    FROM unioned
    WHERE master_record_id IS NULL
    UNION ALL
    SELECT
      iter.account_id,
      iter.master_record_id,
      iter.is_deleted,
      ARRAY_INSERT(anchor.lineage, 0, iter.account_id)  AS lineage
    FROM recursive_cte AS anchor
    INNER JOIN unioned AS iter
      ON iter.master_record_id = anchor.account_id
), final AS (
    SELECT
      account_id                                         AS sfdc_account_id,
      lineage[ARRAY_SIZE(lineage) - 1]::VARCHAR          AS merged_account_id,
      is_deleted,
      IFF(merged_account_id != account_id, TRUE, FALSE)  AS is_merged,
      IFF(is_deleted AND NOT is_merged, TRUE, FALSE)     AS deleted_not_merged,
      --return final common dimension mapping,
      IFF(deleted_not_merged, '-1', merged_account_id)   AS dim_crm_account_id
    FROM recursive_cte
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@michellecooper'::VARCHAR       AS updated_by,
      '2020-11-23'::DATE        AS model_created_date,
      '2023-04-13'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".restricted_safe_common_prep.prep_crm_opportunity as
WITH net_iacv_to_net_arr_ratio AS (
    SELECT *
    FROM "PREP".seed_sales.net_iacv_to_net_arr_ratio
), dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), sfdc_opportunity_stage_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_opportunity_stage_source
), sfdc_opportunity_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_opportunity_source_v1
), sfdc_opportunity_snapshots_source AS (
    SELECT *
    FROM "PROD".restricted_safe_legacy.sfdc_opportunity_snapshots_source_v1
), sfdc_opportunity_stage AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_opportunity_stage_source
), sfdc_record_type_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_record_type_source
), sfdc_account_snapshots_source AS (
    SELECT *
    FROM "PROD".legacy.sfdc_account_snapshots_source
)
, first_contact  AS (
    SELECT
      opportunity_id,                                                             -- opportunity_id
      contact_id                                                                  AS sfdc_contact_id,
      md5(cast(coalesce(cast(contact_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))                      AS dim_crm_person_id,
      ROW_NUMBER() OVER (PARTITION BY opportunity_id ORDER BY created_date ASC)   AS row_num
    FROM "PREP".sfdc.sfdc_opportunity_contact_role_source
), account_history_final AS (
  SELECT
    account_id_18 AS dim_crm_account_id,
    owner_id AS dim_crm_user_id,
    ultimate_parent_id AS dim_crm_parent_account_id,
    abm_tier_1_date,
    abm_tier_2_date,
    abm_tier,
    MIN(dbt_valid_from)::DATE AS valid_from,
    MAX(dbt_valid_to)::DATE AS valid_to
  FROM sfdc_account_snapshots_source
  WHERE abm_tier_1_date >= '2022-02-01'
    OR abm_tier_2_date >= '2022-02-01'
  group by 1,2,3,4,5,6
), attribution_touchpoints AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_bizible_attribution_touchpoint_source
    WHERE is_deleted = 'FALSE'
), linear_attribution_base AS ( --the number of attribution touches a given opp has in total
    --linear attribution IACV of an opp / all touches (count_touches) for each opp - weighted by the number of touches in the given bucket (campaign,channel,etc)
    SELECT
     opportunity_id                                         AS dim_crm_opportunity_id,
     COUNT(DISTINCT attribution_touchpoints.touchpoint_id)  AS count_crm_attribution_touchpoints
    FROM  attribution_touchpoints
    GROUP BY 1
), campaigns_per_opp as (
    SELECT
      opportunity_id                                        AS dim_crm_opportunity_id,
      COUNT(DISTINCT attribution_touchpoints.campaign_id)   AS count_campaigns
    FROM attribution_touchpoints
    GROUP BY 1
), snapshot_dates AS (
    SELECT *
    FROM dim_date
    WHERE date_actual::DATE >= '2020-02-01' -- Restricting snapshot model to only have data from this date forward. More information https://gitlab.com/gitlab-data/analytics/-/issues/14418#note_1134521216
      AND date_actual < CURRENT_DATE
      AND date_actual > (SELECT MAX(snapshot_date) FROM "PROD".restricted_safe_common_prep.prep_crm_opportunity_v1 WHERE is_live = 0)
), live_date AS (
    SELECT *
    FROM dim_date
    WHERE date_actual = CURRENT_DATE
), sfdc_account_snapshot AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_crm_account_daily_snapshot
), sfdc_user_snapshot AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_user_daily_snapshot
), sfdc_account AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_crm_account
), sfdc_user AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_user
), sfdc_opportunity_snapshot AS (
    SELECT
      sfdc_opportunity_snapshots_source.account_id                                                                  AS dim_crm_account_id,
      sfdc_opportunity_snapshots_source.opportunity_id                                                              AS dim_crm_opportunity_id,
      sfdc_opportunity_snapshots_source.owner_id                                                                    AS dim_crm_user_id,
      sfdc_account_snapshot.dim_crm_user_id                                                                         AS dim_crm_account_user_id,
      sfdc_opportunity_snapshots_source.parent_opportunity_id                                                       AS dim_parent_crm_opportunity_id,
      sfdc_opportunity_snapshots_source.order_type_stamped                                                          AS order_type,
      sfdc_opportunity_snapshots_source.opportunity_term                                                            AS opportunity_term_base,
      CASE sfdc_opportunity_snapshots_source.sales_qualified_source
    WHEN  'BDR Generated'
      THEN 'SDR Generated'
    WHEN 'Channel Generated'
      THEN 'Partner Generated'
    ELSE sfdc_opportunity_snapshots_source.sales_qualified_source
  END             AS sales_qualified_source,
      sfdc_opportunity_snapshots_source.user_segment_stamped                                                        AS crm_opp_owner_sales_segment_stamped,
      sfdc_opportunity_snapshots_source.user_geo_stamped                                                            AS crm_opp_owner_geo_stamped,
      sfdc_opportunity_snapshots_source.user_region_stamped                                                         AS crm_opp_owner_region_stamped,
      sfdc_opportunity_snapshots_source.user_area_stamped                                                           AS crm_opp_owner_area_stamped,
      sfdc_opportunity_snapshots_source.user_segment_geo_region_area_stamped                                        AS crm_opp_owner_sales_segment_geo_region_area_stamped,
      sfdc_opportunity_snapshots_source.user_business_unit_stamped                                                  AS crm_opp_owner_business_unit_stamped,
      sfdc_opportunity_snapshots_source.created_date::DATE                                                          AS created_date,
      sfdc_opportunity_snapshots_source.sales_accepted_date::DATE                                                   AS sales_accepted_date,
      sfdc_opportunity_snapshots_source.close_date::DATE                                                            AS close_date,
      sfdc_opportunity_snapshots_source.net_arr                                                                     AS raw_net_arr,
      md5(cast(coalesce(cast(sfdc_opportunity_snapshots_source.opportunity_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(snapshot_dates.date_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))   AS crm_opportunity_snapshot_id,
      snapshot_dates.date_id                                                                                        AS snapshot_id,
      snapshot_dates.date_actual                                                                                    AS snapshot_date,
      snapshot_dates.first_day_of_month                                                                             AS snapshot_month,
      snapshot_dates.fiscal_year                                                                                    AS snapshot_fiscal_year,
      snapshot_dates.fiscal_quarter_name_fy                                                                         AS snapshot_fiscal_quarter_name,
      snapshot_dates.first_day_of_fiscal_quarter                                                                    AS snapshot_fiscal_quarter_date,
      snapshot_dates.day_of_fiscal_quarter_normalised                                                               AS snapshot_day_of_fiscal_quarter_normalised,
      snapshot_dates.day_of_fiscal_year_normalised                                                                  AS snapshot_day_of_fiscal_year_normalised,
      snapshot_dates.last_day_of_fiscal_quarter                                                                     AS snapshot_last_day_of_fiscal_quarter,
      sfdc_account_snapshot.parent_crm_account_geo,
      sfdc_account_snapshot.crm_account_owner_sales_segment,
      sfdc_account_snapshot.crm_account_owner_geo,
      sfdc_account_snapshot.crm_account_owner_region,
      sfdc_account_snapshot.crm_account_owner_area,
      sfdc_account_snapshot.crm_account_owner_sales_segment_geo_region_area,
      account_owner.dim_crm_user_hierarchy_sk                                                                       AS dim_crm_user_hierarchy_account_user_sk,
      account_owner.user_role_name                                                                                  AS crm_account_owner_role,
      account_owner.user_role_level_1                                                                               AS crm_account_owner_role_level_1,
      account_owner.user_role_level_2                                                                               AS crm_account_owner_role_level_2,
      account_owner.user_role_level_3                                                                               AS crm_account_owner_role_level_3,
      account_owner.user_role_level_4                                                                               AS crm_account_owner_role_level_4,
      account_owner.user_role_level_5                                                                               AS crm_account_owner_role_level_5,
      account_owner.title                                                                                           AS crm_account_owner_title,
      fulfillment_partner.crm_account_name AS fulfillment_partner_account_name,
      fulfillment_partner.partner_track AS fulfillment_partner_partner_track,
      partner_account.crm_account_name AS partner_account_account_name,
      partner_account.partner_track AS partner_account_partner_track,
      sfdc_account_snapshot.is_jihu_account,
      sfdc_account_snapshot.dim_parent_crm_account_id,
      CASE
        WHEN sfdc_opportunity_snapshots_source.stage_name IN ('8-Closed Lost', 'Closed Lost', '9-Unqualified',
                                                              'Closed Won', '10-Duplicate')
            THEN 0
        ELSE 1
      END                                                                                                         AS is_open,
      CASE
        WHEN sfdc_opportunity_snapshots_source.user_segment_stamped IS NULL
          OR is_open = 1
          THEN sfdc_account_snapshot.crm_account_owner_sales_segment
        ELSE sfdc_opportunity_snapshots_source.user_segment_stamped
      END                                                                                                         AS opportunity_owner_user_segment,
      sfdc_user_snapshot.user_role_name                                                                           AS opportunity_owner_role,
      sfdc_user_snapshot.user_role_level_1                                                                        AS crm_opp_owner_role_level_1,
      sfdc_user_snapshot.user_role_level_2                                                                        AS crm_opp_owner_role_level_2,
      sfdc_user_snapshot.user_role_level_3                                                                        AS crm_opp_owner_role_level_3,
      sfdc_user_snapshot.user_role_level_4                                                                        AS crm_opp_owner_role_level_4,
      sfdc_user_snapshot.user_role_level_5                                                                        AS crm_opp_owner_role_level_5,
      sfdc_user_snapshot.title                                                                                    AS opportunity_owner_title,
      sfdc_account_snapshot.crm_account_owner_role                                                                AS opportunity_account_owner_role,
      sfdc_opportunity_snapshots_source."OPPORTUNITY_NAME",
  sfdc_opportunity_snapshots_source."IS_CLOSED",
  sfdc_opportunity_snapshots_source."VALID_DEAL_COUNT",
  sfdc_opportunity_snapshots_source."DAYS_IN_STAGE",
  sfdc_opportunity_snapshots_source."DEPLOYMENT_PREFERENCE",
  sfdc_opportunity_snapshots_source."GENERATED_SOURCE",
  sfdc_opportunity_snapshots_source."LEAD_SOURCE",
  sfdc_opportunity_snapshots_source."MERGED_OPPORTUNITY_ID",
  sfdc_opportunity_snapshots_source."DUPLICATE_OPPORTUNITY_ID",
  sfdc_opportunity_snapshots_source."CONTRACT_RESET_OPPORTUNITY_ID",
  sfdc_opportunity_snapshots_source."ACCOUNT_OWNER",
  sfdc_opportunity_snapshots_source."OPPORTUNITY_OWNER",
  sfdc_opportunity_snapshots_source."OPPORTUNITY_OWNER_MANAGER",
  sfdc_opportunity_snapshots_source."OPPORTUNITY_OWNER_DEPARTMENT",
  sfdc_opportunity_snapshots_source."CRM_SALES_DEV_REP_ID",
  sfdc_opportunity_snapshots_source."CRM_BUSINESS_DEV_REP_ID",
  sfdc_opportunity_snapshots_source."CRM_BUSINESS_DEV_REP_ID_LOOKUP",
  sfdc_opportunity_snapshots_source."OPPORTUNITY_DEVELOPMENT_REPRESENTATIVE",
  sfdc_opportunity_snapshots_source."SALES_PATH",
  sfdc_opportunity_snapshots_source."SALES_QUALIFIED_DATE",
  sfdc_opportunity_snapshots_source."IQM_SUBMITTED_BY_ROLE",
  sfdc_opportunity_snapshots_source."SALES_TYPE",
  sfdc_opportunity_snapshots_source."SUBSCRIPTION_TYPE",
  sfdc_opportunity_snapshots_source."NET_NEW_SOURCE_CATEGORIES",
  sfdc_opportunity_snapshots_source."SOURCE_BUCKETS",
  sfdc_opportunity_snapshots_source."STAGE_NAME",
  sfdc_opportunity_snapshots_source."DEAL_PATH",
  sfdc_opportunity_snapshots_source."ACV",
  sfdc_opportunity_snapshots_source."AMOUNT",
  sfdc_opportunity_snapshots_source."IS_CLOSED_DEALS",
  sfdc_opportunity_snapshots_source."COMPETITORS",
  sfdc_opportunity_snapshots_source."CRITICAL_DEAL_FLAG",
  sfdc_opportunity_snapshots_source."FORECAST_CATEGORY_NAME",
  sfdc_opportunity_snapshots_source."FORECASTED_IACV",
  sfdc_opportunity_snapshots_source."IACV_CREATED_DATE",
  sfdc_opportunity_snapshots_source."INCREMENTAL_ACV",
  sfdc_opportunity_snapshots_source."INVOICE_NUMBER",
  sfdc_opportunity_snapshots_source."IS_REFUND",
  sfdc_opportunity_snapshots_source."IS_DOWNGRADE",
  sfdc_opportunity_snapshots_source."IS_SWING_DEAL",
  sfdc_opportunity_snapshots_source."IS_EDU_OSS",
  sfdc_opportunity_snapshots_source."IS_PS_OPP",
  sfdc_opportunity_snapshots_source."NET_INCREMENTAL_ACV",
  sfdc_opportunity_snapshots_source."PRIMARY_CAMPAIGN_SOURCE_ID",
  sfdc_opportunity_snapshots_source."PROBABILITY",
  sfdc_opportunity_snapshots_source."PROFESSIONAL_SERVICES_VALUE",
  sfdc_opportunity_snapshots_source."EDU_SERVICES_VALUE",
  sfdc_opportunity_snapshots_source."INVESTMENT_SERVICES_VALUE",
  sfdc_opportunity_snapshots_source."PUSHED_COUNT",
  sfdc_opportunity_snapshots_source."REASON_FOR_LOSS",
  sfdc_opportunity_snapshots_source."REASON_FOR_LOSS_DETAILS",
  sfdc_opportunity_snapshots_source."REFUND_IACV",
  sfdc_opportunity_snapshots_source."DOWNGRADE_IACV",
  sfdc_opportunity_snapshots_source."RENEWAL_ACV",
  sfdc_opportunity_snapshots_source."RENEWAL_AMOUNT",
  sfdc_opportunity_snapshots_source."SALES_QUALIFIED_SOURCE_GROUPED",
  sfdc_opportunity_snapshots_source."SQS_BUCKET_ENGAGEMENT",
  sfdc_opportunity_snapshots_source."SDR_PIPELINE_CONTRIBUTION",
  sfdc_opportunity_snapshots_source."SOLUTIONS_TO_BE_REPLACED",
  sfdc_opportunity_snapshots_source."TECHNICAL_EVALUATION_DATE",
  sfdc_opportunity_snapshots_source."TOTAL_CONTRACT_VALUE",
  sfdc_opportunity_snapshots_source."RECURRING_AMOUNT",
  sfdc_opportunity_snapshots_source."TRUE_UP_AMOUNT",
  sfdc_opportunity_snapshots_source."PROSERV_AMOUNT",
  sfdc_opportunity_snapshots_source."OTHER_NON_RECURRING_AMOUNT",
  sfdc_opportunity_snapshots_source."UPSIDE_SWING_DEAL_IACV",
  sfdc_opportunity_snapshots_source."IS_WEB_PORTAL_PURCHASE",
  sfdc_opportunity_snapshots_source."PARTNER_INITIATED_OPPORTUNITY",
  sfdc_opportunity_snapshots_source."USER_SEGMENT",
  sfdc_opportunity_snapshots_source."SUBSCRIPTION_START_DATE",
  sfdc_opportunity_snapshots_source."SUBSCRIPTION_END_DATE",
  sfdc_opportunity_snapshots_source."SUBSCRIPTION_RENEWAL_DATE",
  sfdc_opportunity_snapshots_source."TRUE_UP_VALUE",
  sfdc_opportunity_snapshots_source."ORDER_TYPE_CURRENT",
  sfdc_opportunity_snapshots_source."ORDER_TYPE_GROUPED",
  sfdc_opportunity_snapshots_source."GROWTH_TYPE",
  sfdc_opportunity_snapshots_source."ARR_BASIS",
  sfdc_opportunity_snapshots_source."ARR",
  sfdc_opportunity_snapshots_source."XDR_NET_ARR_STAGE_3",
  sfdc_opportunity_snapshots_source."XDR_NET_ARR_STAGE_1",
  sfdc_opportunity_snapshots_source."NET_ARR_STAGE_1",
  sfdc_opportunity_snapshots_source."ENTERPRISE_AGILE_PLANNING_NET_ARR",
  sfdc_opportunity_snapshots_source."DUO_NET_ARR",
  sfdc_opportunity_snapshots_source."DAYS_IN_SAO",
  sfdc_opportunity_snapshots_source."NEW_LOGO_COUNT",
  sfdc_opportunity_snapshots_source."USER_SEGMENT_STAMPED",
  sfdc_opportunity_snapshots_source."USER_SEGMENT_STAMPED_GROUPED",
  sfdc_opportunity_snapshots_source."USER_GEO_STAMPED",
  sfdc_opportunity_snapshots_source."USER_REGION_STAMPED",
  sfdc_opportunity_snapshots_source."USER_AREA_STAMPED",
  sfdc_opportunity_snapshots_source."USER_SEGMENT_REGION_STAMPED_GROUPED",
  sfdc_opportunity_snapshots_source."USER_SEGMENT_GEO_REGION_AREA_STAMPED",
  sfdc_opportunity_snapshots_source."CRM_OPP_OWNER_USER_ROLE_TYPE_STAMPED",
  sfdc_opportunity_snapshots_source."USER_BUSINESS_UNIT_STAMPED",
  sfdc_opportunity_snapshots_source."CRM_OPP_OWNER_STAMPED_NAME",
  sfdc_opportunity_snapshots_source."CRM_ACCOUNT_OWNER_STAMPED_NAME",
  sfdc_opportunity_snapshots_source."SAO_CRM_OPP_OWNER_SALES_SEGMENT_STAMPED",
  sfdc_opportunity_snapshots_source."SAO_CRM_OPP_OWNER_SALES_SEGMENT_GEO_REGION_AREA_STAMPED",
  sfdc_opportunity_snapshots_source."SAO_CRM_OPP_OWNER_SALES_SEGMENT_STAMPED_GROUPED",
  sfdc_opportunity_snapshots_source."SAO_CRM_OPP_OWNER_GEO_STAMPED",
  sfdc_opportunity_snapshots_source."SAO_CRM_OPP_OWNER_REGION_STAMPED",
  sfdc_opportunity_snapshots_source."SAO_CRM_OPP_OWNER_AREA_STAMPED",
  sfdc_opportunity_snapshots_source."SAO_CRM_OPP_OWNER_SEGMENT_REGION_STAMPED_GROUPED",
  sfdc_opportunity_snapshots_source."OPPORTUNITY_CATEGORY",
  sfdc_opportunity_snapshots_source."OPPORTUNITY_HEALTH",
  sfdc_opportunity_snapshots_source."RISK_TYPE",
  sfdc_opportunity_snapshots_source."RISK_REASONS",
  sfdc_opportunity_snapshots_source."TAM_NOTES",
  sfdc_opportunity_snapshots_source."PRIMARY_SOLUTION_ARCHITECT",
  sfdc_opportunity_snapshots_source."PRODUCT_DETAILS",
  sfdc_opportunity_snapshots_source."PRODUCT_CATEGORY",
  sfdc_opportunity_snapshots_source."PRODUCTS_PURCHASED",
  sfdc_opportunity_snapshots_source."OPPORTUNITY_DEAL_SIZE",
  sfdc_opportunity_snapshots_source."PAYMENT_SCHEDULE",
  sfdc_opportunity_snapshots_source."COMP_NEW_LOGO_OVERRIDE",
  sfdc_opportunity_snapshots_source."IS_PIPELINE_CREATED_ELIGIBLE",
  sfdc_opportunity_snapshots_source."NEXT_STEPS",
  sfdc_opportunity_snapshots_source."AUTO_RENEWAL_STATUS",
  sfdc_opportunity_snapshots_source."QSR_NOTES",
  sfdc_opportunity_snapshots_source."QSR_STATUS",
  sfdc_opportunity_snapshots_source."MANAGER_CONFIDENCE",
  sfdc_opportunity_snapshots_source."RENEWAL_RISK_CATEGORY",
  sfdc_opportunity_snapshots_source."RENEWAL_SWING_ARR",
  sfdc_opportunity_snapshots_source."RENEWAL_MANAGER",
  sfdc_opportunity_snapshots_source."RENEWAL_FORECAST_HEALTH",
  sfdc_opportunity_snapshots_source."STARTUP_TYPE",
  sfdc_opportunity_snapshots_source."SALES_SEGMENT",
  sfdc_opportunity_snapshots_source."PARENT_SEGMENT",
  sfdc_opportunity_snapshots_source."DAYS_IN_0_PENDING_ACCEPTANCE",
  sfdc_opportunity_snapshots_source."DAYS_IN_1_DISCOVERY",
  sfdc_opportunity_snapshots_source."DAYS_IN_2_SCOPING",
  sfdc_opportunity_snapshots_source."DAYS_IN_3_TECHNICAL_EVALUATION",
  sfdc_opportunity_snapshots_source."DAYS_IN_4_PROPOSAL",
  sfdc_opportunity_snapshots_source."DAYS_IN_5_NEGOTIATING",
  sfdc_opportunity_snapshots_source."STAGE_0_PENDING_ACCEPTANCE_DATE",
  sfdc_opportunity_snapshots_source."STAGE_1_DISCOVERY_DATE",
  sfdc_opportunity_snapshots_source."STAGE_2_SCOPING_DATE",
  sfdc_opportunity_snapshots_source."STAGE_3_TECHNICAL_EVALUATION_DATE",
  sfdc_opportunity_snapshots_source."STAGE_4_PROPOSAL_DATE",
  sfdc_opportunity_snapshots_source."STAGE_5_NEGOTIATING_DATE",
  sfdc_opportunity_snapshots_source."STAGE_6_AWAITING_SIGNATURE_DATE",
  sfdc_opportunity_snapshots_source."STAGE_6_CLOSED_WON_DATE",
  sfdc_opportunity_snapshots_source."STAGE_6_CLOSED_LOST_DATE",
  sfdc_opportunity_snapshots_source."DIVISION_SALES_SEGMENT_STAMPED",
  sfdc_opportunity_snapshots_source."DR_PARTNER_DEAL_TYPE",
  sfdc_opportunity_snapshots_source."DR_PARTNER_ENGAGEMENT",
  sfdc_opportunity_snapshots_source."DR_DEAL_ID",
  sfdc_opportunity_snapshots_source."DR_PRIMARY_REGISTRATION",
  sfdc_opportunity_snapshots_source."CHANNEL_TYPE",
  sfdc_opportunity_snapshots_source."PARTNER_ACCOUNT",
  sfdc_opportunity_snapshots_source."DR_STATUS",
  sfdc_opportunity_snapshots_source."DISTRIBUTOR",
  sfdc_opportunity_snapshots_source."INFLUENCE_PARTNER",
  sfdc_opportunity_snapshots_source."IS_FOCUS_PARTNER",
  sfdc_opportunity_snapshots_source."FULFILLMENT_PARTNER",
  sfdc_opportunity_snapshots_source."PLATFORM_PARTNER",
  sfdc_opportunity_snapshots_source."PARTNER_TRACK",
  sfdc_opportunity_snapshots_source."RESALE_PARTNER_TRACK",
  sfdc_opportunity_snapshots_source."IS_PUBLIC_SECTOR_OPP",
  sfdc_opportunity_snapshots_source."IS_REGISTRATION_FROM_PORTAL",
  sfdc_opportunity_snapshots_source."CALCULATED_DISCOUNT",
  sfdc_opportunity_snapshots_source."PARTNER_DISCOUNT",
  sfdc_opportunity_snapshots_source."PARTNER_DISCOUNT_CALC",
  sfdc_opportunity_snapshots_source."PARTNER_MARGIN_PERCENTAGE",
  sfdc_opportunity_snapshots_source."COMP_CHANNEL_NEUTRAL",
  sfdc_opportunity_snapshots_source."AGGREGATE_PARTNER",
  sfdc_opportunity_snapshots_source."CP_CHAMPION",
  sfdc_opportunity_snapshots_source."CP_CLOSE_PLAN",
  sfdc_opportunity_snapshots_source."CP_DECISION_CRITERIA",
  sfdc_opportunity_snapshots_source."CP_DECISION_PROCESS",
  sfdc_opportunity_snapshots_source."CP_ECONOMIC_BUYER",
  sfdc_opportunity_snapshots_source."CP_HELP",
  sfdc_opportunity_snapshots_source."CP_IDENTIFY_PAIN",
  sfdc_opportunity_snapshots_source."CP_METRICS",
  sfdc_opportunity_snapshots_source."CP_PARTNER",
  sfdc_opportunity_snapshots_source."CP_PAPER_PROCESS",
  sfdc_opportunity_snapshots_source."CP_REVIEW_NOTES",
  sfdc_opportunity_snapshots_source."CP_RISKS",
  sfdc_opportunity_snapshots_source."CP_USE_CASES",
  sfdc_opportunity_snapshots_source."CP_VALUE_DRIVER",
  sfdc_opportunity_snapshots_source."CP_WHY_DO_ANYTHING_AT_ALL",
  sfdc_opportunity_snapshots_source."CP_WHY_GITLAB",
  sfdc_opportunity_snapshots_source."CP_WHY_NOW",
  sfdc_opportunity_snapshots_source."CP_SCORE",
  sfdc_opportunity_snapshots_source."SA_TECH_EVALUATION_CLOSE_STATUS",
  sfdc_opportunity_snapshots_source."SA_TECH_EVALUATION_END_DATE",
  sfdc_opportunity_snapshots_source."SA_TECH_EVALUATION_START_DATE",
  sfdc_opportunity_snapshots_source."FPA_MASTER_BOOKINGS_FLAG",
  sfdc_opportunity_snapshots_source."DOWNGRADE_REASON",
  sfdc_opportunity_snapshots_source."SSP_ID",
  sfdc_opportunity_snapshots_source."GA_CLIENT_ID",
  sfdc_opportunity_snapshots_source."VSA_READOUT",
  sfdc_opportunity_snapshots_source."VSA_START_DATE_NET_ARR",
  sfdc_opportunity_snapshots_source."VSA_START_DATE",
  sfdc_opportunity_snapshots_source."VSA_URL",
  sfdc_opportunity_snapshots_source."VSA_STATUS",
  sfdc_opportunity_snapshots_source."VSA_END_DATE",
  sfdc_opportunity_snapshots_source."DOWNGRADE_DETAILS",
  sfdc_opportunity_snapshots_source."WON_ARR_BASIS_FOR_CLARI",
  sfdc_opportunity_snapshots_source."ARR_BASIS_FOR_CLARI",
  sfdc_opportunity_snapshots_source."FORECASTED_CHURN_FOR_CLARI",
  sfdc_opportunity_snapshots_source."OVERRIDE_ARR_BASIS_CLARI",
  sfdc_opportunity_snapshots_source."INTENDED_PRODUCT_TIER",
  sfdc_opportunity_snapshots_source."PTC_PREDICTED_ARR",
  sfdc_opportunity_snapshots_source."PTC_PREDICTED_RENEWAL_RISK_CATEGORY",
  sfdc_opportunity_snapshots_source."_LAST_DBT_RUN",
  sfdc_opportunity_snapshots_source."DAYS_SINCE_LAST_ACTIVITY",
  sfdc_opportunity_snapshots_source."IS_DELETED",
  sfdc_opportunity_snapshots_source."LAST_ACTIVITY_DATE",
  sfdc_opportunity_snapshots_source."SALES_LAST_ACTIVITY_DATE",
  sfdc_opportunity_snapshots_source."RECORD_TYPE_ID",
  sfdc_opportunity_snapshots_source."DBT_SCD_ID",
  sfdc_opportunity_snapshots_source."DBT_VALID_FROM",
  sfdc_opportunity_snapshots_source."DBT_VALID_TO",
      0 AS is_live
    FROM sfdc_opportunity_snapshots_source
    INNER JOIN snapshot_dates
      ON sfdc_opportunity_snapshots_source.dbt_valid_from::DATE <= snapshot_dates.date_actual
        AND (sfdc_opportunity_snapshots_source.dbt_valid_to::DATE > snapshot_dates.date_actual OR sfdc_opportunity_snapshots_source.dbt_valid_to IS NULL)
    LEFT JOIN sfdc_account_snapshot AS fulfillment_partner
      ON sfdc_opportunity_snapshots_source.fulfillment_partner = fulfillment_partner.dim_crm_account_id
        AND snapshot_dates.date_id = fulfillment_partner.snapshot_id
    LEFT JOIN sfdc_account_snapshot AS partner_account
      ON sfdc_opportunity_snapshots_source.partner_account = partner_account.dim_crm_account_id
        AND snapshot_dates.date_id = partner_account.snapshot_id
    LEFT JOIN sfdc_account_snapshot
      ON sfdc_opportunity_snapshots_source.account_id = sfdc_account_snapshot.dim_crm_account_id
        AND snapshot_dates.date_id = sfdc_account_snapshot.snapshot_id
    LEFT JOIN sfdc_user_snapshot
      ON sfdc_opportunity_snapshots_source.owner_id = sfdc_user_snapshot.dim_crm_user_id
        AND snapshot_dates.date_id = sfdc_user_snapshot.snapshot_id
    LEFT JOIN sfdc_user_snapshot AS account_owner
      ON sfdc_account_snapshot.dim_crm_user_id = account_owner.dim_crm_user_id
        AND snapshot_dates.date_id = account_owner.snapshot_id
    WHERE sfdc_opportunity_snapshots_source.account_id IS NOT NULL
      AND sfdc_opportunity_snapshots_source.is_deleted = FALSE
), sfdc_opportunity_live AS (
    SELECT
      sfdc_opportunity_source.account_id                                                                    AS dim_crm_account_id,
      sfdc_opportunity_source.opportunity_id                                                                AS dim_crm_opportunity_id,
      sfdc_opportunity_source.owner_id                                                                      AS dim_crm_user_id,
      sfdc_account.dim_crm_user_id                                                                          AS dim_crm_account_user_id,
      sfdc_opportunity_source.parent_opportunity_id                                                         AS dim_parent_crm_opportunity_id,
      sfdc_opportunity_source.order_type_stamped                                                            AS order_type,
      sfdc_opportunity_source.opportunity_term                                                              AS opportunity_term_base,
      CASE sfdc_opportunity_source.sales_qualified_source
    WHEN  'BDR Generated'
      THEN 'SDR Generated'
    WHEN 'Channel Generated'
      THEN 'Partner Generated'
    ELSE sfdc_opportunity_source.sales_qualified_source
  END               AS sales_qualified_source,
      sfdc_opportunity_source.user_segment_stamped                                                          AS crm_opp_owner_sales_segment_stamped,
      sfdc_opportunity_source.user_geo_stamped                                                              AS crm_opp_owner_geo_stamped,
      sfdc_opportunity_source.user_region_stamped                                                           AS crm_opp_owner_region_stamped,
      sfdc_opportunity_source.user_area_stamped                                                             AS crm_opp_owner_area_stamped,
      sfdc_opportunity_source.user_segment_geo_region_area_stamped                                          AS crm_opp_owner_sales_segment_geo_region_area_stamped,
      sfdc_opportunity_source.user_business_unit_stamped                                                    AS crm_opp_owner_business_unit_stamped,
      sfdc_opportunity_source.created_date::DATE                                                            AS created_date,
      sfdc_opportunity_source.sales_accepted_date::DATE                                                     AS sales_accepted_date,
      sfdc_opportunity_source.close_date::DATE                                                              AS close_date,
      sfdc_opportunity_source.net_arr                                                                       AS raw_net_arr,
      md5(cast(coalesce(cast(sfdc_opportunity_source.opportunity_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast('99991231' as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))        AS crm_opportunity_snapshot_id,
      '99991231'                                                                                            AS snapshot_id,
      live_date.date_actual                                                                                 AS snapshot_date,
      live_date.first_day_of_month                                                                          AS snapshot_month,
      live_date.fiscal_year                                                                                 AS snapshot_fiscal_year,
      live_date.fiscal_quarter_name_fy                                                                      AS snapshot_fiscal_quarter_name,
      live_date.first_day_of_fiscal_quarter                                                                 AS snapshot_fiscal_quarter_date,
      live_date.day_of_fiscal_quarter_normalised                                                            AS snapshot_day_of_fiscal_quarter_normalised,
      live_date.day_of_fiscal_year_normalised                                                               AS snapshot_day_of_fiscal_year_normalised,
      live_date.last_day_of_fiscal_quarter                                                                  AS snapshot_last_day_of_fiscal_quarter,
      sfdc_account.parent_crm_account_geo                                                                   AS parent_crm_account_geo,
      account_owner.dim_crm_user_hierarchy_sk                                                               AS dim_crm_user_hierarchy_account_user_sk,
      account_owner.crm_user_sales_segment                                                                  AS crm_account_owner_sales_segment,
      account_owner.crm_user_geo                                                                            AS crm_account_owner_geo,
      account_owner.crm_user_region                                                                         AS crm_account_owner_region,
      account_owner.crm_user_area                                                                           AS crm_account_owner_area,
      account_owner.crm_user_sales_segment_geo_region_area                                                  AS crm_account_owner_sales_segment_geo_region_area,
      account_owner.user_role_name                                                                          AS crm_account_owner_role,
      account_owner.user_role_level_1                                                                       AS crm_account_owner_role_level_1,
      account_owner.user_role_level_2                                                                       AS crm_account_owner_role_level_2,
      account_owner.user_role_level_3                                                                       AS crm_account_owner_role_level_3,
      account_owner.user_role_level_4                                                                       AS crm_account_owner_role_level_4,
      account_owner.user_role_level_5                                                                       AS crm_account_owner_role_level_5,
      account_owner.title                                                                                   AS crm_account_owner_title,
      fulfillment_partner.crm_account_name                                                                  AS fulfillment_partner_account_name,
      fulfillment_partner.partner_track                                                                     AS fulfillment_partner_partner_track,
      partner_account.crm_account_name                                                                      AS partner_account_account_name,
      partner_account.partner_track                                                                         AS partner_account_partner_track,
      sfdc_account.is_jihu_account,
      sfdc_account.dim_parent_crm_account_id                                                                AS dim_parent_crm_account_id,
      CASE
        WHEN sfdc_opportunity_source.stage_name IN ('8-Closed Lost', 'Closed Lost', '9-Unqualified',
                                                    'Closed Won', '10-Duplicate')
            THEN 0
        ELSE 1
      END                                                                                                   AS is_open,
      CASE
        WHEN sfdc_opportunity_source.user_segment_stamped IS NULL
          OR is_open = 1
          THEN account_owner.crm_user_sales_segment
        ELSE sfdc_opportunity_source.user_segment_stamped
      END                                                                                                   AS opportunity_owner_user_segment,
      opportunity_owner.user_role_name                                                                      AS opportunity_owner_role,
      opportunity_owner.user_role_level_1                                                                   AS crm_opp_owner_role_level_1,
      opportunity_owner.user_role_level_2                                                                   AS crm_opp_owner_role_level_2,
      opportunity_owner.user_role_level_3                                                                   AS crm_opp_owner_role_level_3,
      opportunity_owner.user_role_level_4                                                                   AS crm_opp_owner_role_level_4,
      opportunity_owner.user_role_level_5                                                                   AS crm_opp_owner_role_level_5,
      opportunity_owner.title                                                                               AS opportunity_owner_title,
      sfdc_account.crm_account_owner_role                                                                   AS opportunity_account_owner_role,
      sfdc_opportunity_source."OPPORTUNITY_NAME",
  sfdc_opportunity_source."IS_CLOSED",
  sfdc_opportunity_source."VALID_DEAL_COUNT",
  sfdc_opportunity_source."DAYS_IN_STAGE",
  sfdc_opportunity_source."DEPLOYMENT_PREFERENCE",
  sfdc_opportunity_source."GENERATED_SOURCE",
  sfdc_opportunity_source."LEAD_SOURCE",
  sfdc_opportunity_source."MERGED_OPPORTUNITY_ID",
  sfdc_opportunity_source."DUPLICATE_OPPORTUNITY_ID",
  sfdc_opportunity_source."CONTRACT_RESET_OPPORTUNITY_ID",
  sfdc_opportunity_source."ACCOUNT_OWNER",
  sfdc_opportunity_source."OPPORTUNITY_OWNER",
  sfdc_opportunity_source."OPPORTUNITY_OWNER_MANAGER",
  sfdc_opportunity_source."OPPORTUNITY_OWNER_DEPARTMENT",
  sfdc_opportunity_source."CRM_SALES_DEV_REP_ID",
  sfdc_opportunity_source."CRM_BUSINESS_DEV_REP_ID",
  sfdc_opportunity_source."CRM_BUSINESS_DEV_REP_ID_LOOKUP",
  sfdc_opportunity_source."OPPORTUNITY_DEVELOPMENT_REPRESENTATIVE",
  sfdc_opportunity_source."SALES_PATH",
  sfdc_opportunity_source."SALES_QUALIFIED_DATE",
  sfdc_opportunity_source."IQM_SUBMITTED_BY_ROLE",
  sfdc_opportunity_source."SALES_TYPE",
  sfdc_opportunity_source."SUBSCRIPTION_TYPE",
  sfdc_opportunity_source."NET_NEW_SOURCE_CATEGORIES",
  sfdc_opportunity_source."SOURCE_BUCKETS",
  sfdc_opportunity_source."STAGE_NAME",
  sfdc_opportunity_source."DEAL_PATH",
  sfdc_opportunity_source."ACV",
  sfdc_opportunity_source."AMOUNT",
  sfdc_opportunity_source."IS_CLOSED_DEALS",
  sfdc_opportunity_source."COMPETITORS",
  sfdc_opportunity_source."CRITICAL_DEAL_FLAG",
  sfdc_opportunity_source."FORECAST_CATEGORY_NAME",
  sfdc_opportunity_source."FORECASTED_IACV",
  sfdc_opportunity_source."IACV_CREATED_DATE",
  sfdc_opportunity_source."INCREMENTAL_ACV",
  sfdc_opportunity_source."INVOICE_NUMBER",
  sfdc_opportunity_source."IS_REFUND",
  sfdc_opportunity_source."IS_DOWNGRADE",
  sfdc_opportunity_source."IS_SWING_DEAL",
  sfdc_opportunity_source."IS_EDU_OSS",
  sfdc_opportunity_source."IS_PS_OPP",
  sfdc_opportunity_source."NET_INCREMENTAL_ACV",
  sfdc_opportunity_source."PRIMARY_CAMPAIGN_SOURCE_ID",
  sfdc_opportunity_source."PROBABILITY",
  sfdc_opportunity_source."PROFESSIONAL_SERVICES_VALUE",
  sfdc_opportunity_source."EDU_SERVICES_VALUE",
  sfdc_opportunity_source."INVESTMENT_SERVICES_VALUE",
  sfdc_opportunity_source."PUSHED_COUNT",
  sfdc_opportunity_source."REASON_FOR_LOSS",
  sfdc_opportunity_source."REASON_FOR_LOSS_DETAILS",
  sfdc_opportunity_source."REFUND_IACV",
  sfdc_opportunity_source."DOWNGRADE_IACV",
  sfdc_opportunity_source."RENEWAL_ACV",
  sfdc_opportunity_source."RENEWAL_AMOUNT",
  sfdc_opportunity_source."SALES_QUALIFIED_SOURCE_GROUPED",
  sfdc_opportunity_source."SQS_BUCKET_ENGAGEMENT",
  sfdc_opportunity_source."SDR_PIPELINE_CONTRIBUTION",
  sfdc_opportunity_source."SOLUTIONS_TO_BE_REPLACED",
  sfdc_opportunity_source."TECHNICAL_EVALUATION_DATE",
  sfdc_opportunity_source."TOTAL_CONTRACT_VALUE",
  sfdc_opportunity_source."RECURRING_AMOUNT",
  sfdc_opportunity_source."TRUE_UP_AMOUNT",
  sfdc_opportunity_source."PROSERV_AMOUNT",
  sfdc_opportunity_source."OTHER_NON_RECURRING_AMOUNT",
  sfdc_opportunity_source."UPSIDE_SWING_DEAL_IACV",
  sfdc_opportunity_source."IS_WEB_PORTAL_PURCHASE",
  sfdc_opportunity_source."PARTNER_INITIATED_OPPORTUNITY",
  sfdc_opportunity_source."USER_SEGMENT",
  sfdc_opportunity_source."SUBSCRIPTION_START_DATE",
  sfdc_opportunity_source."SUBSCRIPTION_END_DATE",
  sfdc_opportunity_source."SUBSCRIPTION_RENEWAL_DATE",
  sfdc_opportunity_source."TRUE_UP_VALUE",
  sfdc_opportunity_source."ORDER_TYPE_CURRENT",
  sfdc_opportunity_source."ORDER_TYPE_GROUPED",
  sfdc_opportunity_source."GROWTH_TYPE",
  sfdc_opportunity_source."ARR_BASIS",
  sfdc_opportunity_source."ARR",
  sfdc_opportunity_source."XDR_NET_ARR_STAGE_3",
  sfdc_opportunity_source."XDR_NET_ARR_STAGE_1",
  sfdc_opportunity_source."NET_ARR_STAGE_1",
  sfdc_opportunity_source."ENTERPRISE_AGILE_PLANNING_NET_ARR",
  sfdc_opportunity_source."DUO_NET_ARR",
  sfdc_opportunity_source."DAYS_IN_SAO",
  sfdc_opportunity_source."NEW_LOGO_COUNT",
  sfdc_opportunity_source."USER_SEGMENT_STAMPED",
  sfdc_opportunity_source."USER_SEGMENT_STAMPED_GROUPED",
  sfdc_opportunity_source."USER_GEO_STAMPED",
  sfdc_opportunity_source."USER_REGION_STAMPED",
  sfdc_opportunity_source."USER_AREA_STAMPED",
  sfdc_opportunity_source."USER_SEGMENT_REGION_STAMPED_GROUPED",
  sfdc_opportunity_source."USER_SEGMENT_GEO_REGION_AREA_STAMPED",
  sfdc_opportunity_source."CRM_OPP_OWNER_USER_ROLE_TYPE_STAMPED",
  sfdc_opportunity_source."USER_BUSINESS_UNIT_STAMPED",
  sfdc_opportunity_source."CRM_OPP_OWNER_STAMPED_NAME",
  sfdc_opportunity_source."CRM_ACCOUNT_OWNER_STAMPED_NAME",
  sfdc_opportunity_source."SAO_CRM_OPP_OWNER_SALES_SEGMENT_STAMPED",
  sfdc_opportunity_source."SAO_CRM_OPP_OWNER_SALES_SEGMENT_GEO_REGION_AREA_STAMPED",
  sfdc_opportunity_source."SAO_CRM_OPP_OWNER_SALES_SEGMENT_STAMPED_GROUPED",
  sfdc_opportunity_source."SAO_CRM_OPP_OWNER_GEO_STAMPED",
  sfdc_opportunity_source."SAO_CRM_OPP_OWNER_REGION_STAMPED",
  sfdc_opportunity_source."SAO_CRM_OPP_OWNER_AREA_STAMPED",
  sfdc_opportunity_source."SAO_CRM_OPP_OWNER_SEGMENT_REGION_STAMPED_GROUPED",
  sfdc_opportunity_source."OPPORTUNITY_CATEGORY",
  sfdc_opportunity_source."OPPORTUNITY_HEALTH",
  sfdc_opportunity_source."RISK_TYPE",
  sfdc_opportunity_source."RISK_REASONS",
  sfdc_opportunity_source."TAM_NOTES",
  sfdc_opportunity_source."PRIMARY_SOLUTION_ARCHITECT",
  sfdc_opportunity_source."PRODUCT_DETAILS",
  sfdc_opportunity_source."PRODUCT_CATEGORY",
  sfdc_opportunity_source."PRODUCTS_PURCHASED",
  sfdc_opportunity_source."OPPORTUNITY_DEAL_SIZE",
  sfdc_opportunity_source."PAYMENT_SCHEDULE",
  sfdc_opportunity_source."COMP_NEW_LOGO_OVERRIDE",
  sfdc_opportunity_source."IS_PIPELINE_CREATED_ELIGIBLE",
  sfdc_opportunity_source."NEXT_STEPS",
  sfdc_opportunity_source."AUTO_RENEWAL_STATUS",
  sfdc_opportunity_source."QSR_NOTES",
  sfdc_opportunity_source."QSR_STATUS",
  sfdc_opportunity_source."MANAGER_CONFIDENCE",
  sfdc_opportunity_source."RENEWAL_RISK_CATEGORY",
  sfdc_opportunity_source."RENEWAL_SWING_ARR",
  sfdc_opportunity_source."RENEWAL_MANAGER",
  sfdc_opportunity_source."RENEWAL_FORECAST_HEALTH",
  sfdc_opportunity_source."STARTUP_TYPE",
  sfdc_opportunity_source."SALES_SEGMENT",
  sfdc_opportunity_source."PARENT_SEGMENT",
  sfdc_opportunity_source."DAYS_IN_0_PENDING_ACCEPTANCE",
  sfdc_opportunity_source."DAYS_IN_1_DISCOVERY",
  sfdc_opportunity_source."DAYS_IN_2_SCOPING",
  sfdc_opportunity_source."DAYS_IN_3_TECHNICAL_EVALUATION",
  sfdc_opportunity_source."DAYS_IN_4_PROPOSAL",
  sfdc_opportunity_source."DAYS_IN_5_NEGOTIATING",
  sfdc_opportunity_source."STAGE_0_PENDING_ACCEPTANCE_DATE",
  sfdc_opportunity_source."STAGE_1_DISCOVERY_DATE",
  sfdc_opportunity_source."STAGE_2_SCOPING_DATE",
  sfdc_opportunity_source."STAGE_3_TECHNICAL_EVALUATION_DATE",
  sfdc_opportunity_source."STAGE_4_PROPOSAL_DATE",
  sfdc_opportunity_source."STAGE_5_NEGOTIATING_DATE",
  sfdc_opportunity_source."STAGE_6_AWAITING_SIGNATURE_DATE",
  sfdc_opportunity_source."STAGE_6_CLOSED_WON_DATE",
  sfdc_opportunity_source."STAGE_6_CLOSED_LOST_DATE",
  sfdc_opportunity_source."DIVISION_SALES_SEGMENT_STAMPED",
  sfdc_opportunity_source."DR_PARTNER_DEAL_TYPE",
  sfdc_opportunity_source."DR_PARTNER_ENGAGEMENT",
  sfdc_opportunity_source."DR_DEAL_ID",
  sfdc_opportunity_source."DR_PRIMARY_REGISTRATION",
  sfdc_opportunity_source."CHANNEL_TYPE",
  sfdc_opportunity_source."PARTNER_ACCOUNT",
  sfdc_opportunity_source."DR_STATUS",
  sfdc_opportunity_source."DISTRIBUTOR",
  sfdc_opportunity_source."INFLUENCE_PARTNER",
  sfdc_opportunity_source."IS_FOCUS_PARTNER",
  sfdc_opportunity_source."FULFILLMENT_PARTNER",
  sfdc_opportunity_source."PLATFORM_PARTNER",
  sfdc_opportunity_source."PARTNER_TRACK",
  sfdc_opportunity_source."RESALE_PARTNER_TRACK",
  sfdc_opportunity_source."IS_PUBLIC_SECTOR_OPP",
  sfdc_opportunity_source."IS_REGISTRATION_FROM_PORTAL",
  sfdc_opportunity_source."CALCULATED_DISCOUNT",
  sfdc_opportunity_source."PARTNER_DISCOUNT",
  sfdc_opportunity_source."PARTNER_DISCOUNT_CALC",
  sfdc_opportunity_source."PARTNER_MARGIN_PERCENTAGE",
  sfdc_opportunity_source."COMP_CHANNEL_NEUTRAL",
  sfdc_opportunity_source."AGGREGATE_PARTNER",
  sfdc_opportunity_source."CP_CHAMPION",
  sfdc_opportunity_source."CP_CLOSE_PLAN",
  sfdc_opportunity_source."CP_DECISION_CRITERIA",
  sfdc_opportunity_source."CP_DECISION_PROCESS",
  sfdc_opportunity_source."CP_ECONOMIC_BUYER",
  sfdc_opportunity_source."CP_HELP",
  sfdc_opportunity_source."CP_IDENTIFY_PAIN",
  sfdc_opportunity_source."CP_METRICS",
  sfdc_opportunity_source."CP_PARTNER",
  sfdc_opportunity_source."CP_PAPER_PROCESS",
  sfdc_opportunity_source."CP_REVIEW_NOTES",
  sfdc_opportunity_source."CP_RISKS",
  sfdc_opportunity_source."CP_USE_CASES",
  sfdc_opportunity_source."CP_VALUE_DRIVER",
  sfdc_opportunity_source."CP_WHY_DO_ANYTHING_AT_ALL",
  sfdc_opportunity_source."CP_WHY_GITLAB",
  sfdc_opportunity_source."CP_WHY_NOW",
  sfdc_opportunity_source."CP_SCORE",
  sfdc_opportunity_source."SA_TECH_EVALUATION_CLOSE_STATUS",
  sfdc_opportunity_source."SA_TECH_EVALUATION_END_DATE",
  sfdc_opportunity_source."SA_TECH_EVALUATION_START_DATE",
  sfdc_opportunity_source."FPA_MASTER_BOOKINGS_FLAG",
  sfdc_opportunity_source."DOWNGRADE_REASON",
  sfdc_opportunity_source."SSP_ID",
  sfdc_opportunity_source."GA_CLIENT_ID",
  sfdc_opportunity_source."VSA_READOUT",
  sfdc_opportunity_source."VSA_START_DATE_NET_ARR",
  sfdc_opportunity_source."VSA_START_DATE",
  sfdc_opportunity_source."VSA_URL",
  sfdc_opportunity_source."VSA_STATUS",
  sfdc_opportunity_source."VSA_END_DATE",
  sfdc_opportunity_source."DOWNGRADE_DETAILS",
  sfdc_opportunity_source."WON_ARR_BASIS_FOR_CLARI",
  sfdc_opportunity_source."ARR_BASIS_FOR_CLARI",
  sfdc_opportunity_source."FORECASTED_CHURN_FOR_CLARI",
  sfdc_opportunity_source."OVERRIDE_ARR_BASIS_CLARI",
  sfdc_opportunity_source."INTENDED_PRODUCT_TIER",
  sfdc_opportunity_source."PTC_PREDICTED_ARR",
  sfdc_opportunity_source."PTC_PREDICTED_RENEWAL_RISK_CATEGORY",
  sfdc_opportunity_source."_LAST_DBT_RUN",
  sfdc_opportunity_source."DAYS_SINCE_LAST_ACTIVITY",
  sfdc_opportunity_source."IS_DELETED",
  sfdc_opportunity_source."LAST_ACTIVITY_DATE",
  sfdc_opportunity_source."SALES_LAST_ACTIVITY_DATE",
  sfdc_opportunity_source."RECORD_TYPE_ID",
      NULL                                                                                                  AS dbt_scd_id,
      CURRENT_DATE()                                                                                        AS dbt_valid_from,
      CURRENT_DATE()                                                                                        AS dbt_valid_to,
      1                                                                                                     AS is_live
    FROM sfdc_opportunity_source
    LEFT JOIN live_date
      ON CURRENT_DATE() = live_date.date_actual
    LEFT JOIN sfdc_account AS fulfillment_partner
      ON sfdc_opportunity_source.fulfillment_partner = fulfillment_partner.dim_crm_account_id
    LEFT JOIN sfdc_account AS partner_account
      ON sfdc_opportunity_source.partner_account = partner_account.dim_crm_account_id
    LEFT JOIN sfdc_account
      ON sfdc_opportunity_source.account_id= sfdc_account.dim_crm_account_id
    LEFT JOIN sfdc_user AS account_owner
      ON sfdc_account.dim_crm_user_id = account_owner.dim_crm_user_id
    LEFT JOIN sfdc_user AS opportunity_owner
      ON sfdc_opportunity_source.owner_id = opportunity_owner.dim_crm_user_id
    WHERE sfdc_opportunity_source.account_id IS NOT NULL
      AND sfdc_opportunity_source.is_deleted = FALSE
), sfdc_opportunity AS (
    SELECT *
    FROM sfdc_opportunity_snapshot
    UNION ALL
    SELECT *
    FROM sfdc_opportunity_live
), sfdc_zqu_quote_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_zqu_quote_source
    WHERE is_deleted = FALSE
), quote AS (
    SELECT DISTINCT
      sfdc_zqu_quote_source.zqu__opportunity                AS dim_crm_opportunity_id,
      sfdc_zqu_quote_source.zqu_quote_id                    AS dim_quote_id,
      sfdc_zqu_quote_source.zqu__start_date::DATE           AS quote_start_date,
      (ROW_NUMBER() OVER (PARTITION BY sfdc_zqu_quote_source.zqu__opportunity ORDER BY sfdc_zqu_quote_source.created_date DESC))
                                                            AS record_number
    FROM sfdc_zqu_quote_source
    INNER JOIN sfdc_opportunity
      ON sfdc_zqu_quote_source.zqu__opportunity = sfdc_opportunity.dim_crm_opportunity_id
    WHERE stage_name IN ('Closed Won', '8-Closed Lost')
      AND zqu__primary = TRUE
    QUALIFY record_number = 1
), sao_base AS (
  SELECT
   --IDs
    sfdc_opportunity.dim_crm_opportunity_id,
  --Opp Data
    sfdc_opportunity.sales_accepted_date,
    CASE
      WHEN sfdc_opportunity.is_edu_oss = 0
          AND sfdc_opportunity.stage_name != '10-Duplicate'
          AND sales_accepted_date BETWEEN valid_from AND valid_to
        THEN TRUE
      ELSE FALSE
    END AS is_abm_tier_sao
  FROM sfdc_opportunity
  LEFT JOIN account_history_final
    ON sfdc_opportunity.dim_crm_account_id=account_history_final.dim_crm_account_id
  WHERE abm_tier IS NOT NULL
  AND sales_accepted_date IS NOT NULL
  AND sales_accepted_date >= '2022-02-01'
  AND (abm_tier_1_date IS NOT NULL
    OR abm_tier_2_date IS NOT NULL)
  AND is_abm_tier_sao = TRUE
), cw_base AS (
  SELECT
   --IDs
    sfdc_opportunity.dim_crm_opportunity_id,
  --Opp Data
    sfdc_opportunity.close_date,
    CASE
      WHEN stage_name = 'Closed Won'
        AND close_date BETWEEN valid_from AND valid_to
        THEN TRUE
      ELSE FALSE
    END AS is_abm_tier_closed_won
  FROM sfdc_opportunity
  LEFT JOIN account_history_final
    ON sfdc_opportunity.dim_crm_account_id=account_history_final.dim_crm_account_id
  WHERE abm_tier IS NOT NULL
  AND close_date IS NOT NULL
  AND close_date >= '2022-02-01'
  AND (abm_tier_1_date IS NOT NULL
    OR abm_tier_2_date IS NOT NULL)
  AND is_abm_tier_closed_won = TRUE
), abm_tier_id AS (
    SELECT
        dim_crm_opportunity_id
    FROM sao_base
    UNION
    SELECT
        dim_crm_opportunity_id
    FROM cw_base
), abm_tier_unioned AS (
SELECT
  abm_tier_id.dim_crm_opportunity_id,
  is_abm_tier_sao,
  is_abm_tier_closed_won
FROM abm_tier_id
LEFT JOIN sao_base
  ON abm_tier_id.dim_crm_opportunity_id=sao_base.dim_crm_opportunity_id
LEFT JOIN cw_base
  ON abm_tier_id.dim_crm_opportunity_id=cw_base.dim_crm_opportunity_id
), final AS (
    SELECT DISTINCT
      -- opportunity information
      sfdc_opportunity.*,
      sfdc_opportunity.crm_opportunity_snapshot_id||'-'||sfdc_opportunity.is_live                  AS primary_key,
      -- dates & date ids
  TO_NUMBER(TO_CHAR(sfdc_opportunity.created_date::DATE,'YYYYMMDD'),'99999999')
                                          AS created_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.sales_accepted_date::DATE,'YYYYMMDD'),'99999999')
                                   AS sales_accepted_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.close_date::DATE,'YYYYMMDD'),'99999999')
                                            AS close_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_0_pending_acceptance_date::DATE,'YYYYMMDD'),'99999999')
                       AS stage_0_pending_acceptance_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_1_discovery_date::DATE,'YYYYMMDD'),'99999999')
                                AS stage_1_discovery_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_2_scoping_date::DATE,'YYYYMMDD'),'99999999')
                                  AS stage_2_scoping_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_3_technical_evaluation_date::DATE,'YYYYMMDD'),'99999999')
                     AS stage_3_technical_evaluation_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_4_proposal_date::DATE,'YYYYMMDD'),'99999999')
                                 AS stage_4_proposal_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_5_negotiating_date::DATE,'YYYYMMDD'),'99999999')
                              AS stage_5_negotiating_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_6_awaiting_signature_date::DATE,'YYYYMMDD'),'99999999')
                       AS stage_6_awaiting_signature_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_6_closed_won_date::DATE,'YYYYMMDD'),'99999999')
                               AS stage_6_closed_won_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.stage_6_closed_lost_date::DATE,'YYYYMMDD'),'99999999')
                              AS stage_6_closed_lost_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.technical_evaluation_date::DATE,'YYYYMMDD'),'99999999')
                             AS technical_evaluation_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.last_activity_date::DATE,'YYYYMMDD'),'99999999')
                                    AS last_activity_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.sales_last_activity_date::DATE,'YYYYMMDD'),'99999999')
                              AS sales_last_activity_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.subscription_start_date::DATE,'YYYYMMDD'),'99999999')
                               AS subscription_start_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.subscription_end_date::DATE,'YYYYMMDD'),'99999999')
                                 AS subscription_end_date_id,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.sales_qualified_date::DATE,'YYYYMMDD'),'99999999')
                                  AS sales_qualified_date_id,
      sfdc_opportunity_live.close_date                                                            AS close_date_live,
      close_date.first_day_of_fiscal_quarter                                                      AS close_fiscal_quarter_date,
      90 - DATEDIFF(DAY, sfdc_opportunity.snapshot_date, close_date.last_day_of_fiscal_quarter)   AS close_day_of_fiscal_quarter_normalised,
      -- The fiscal year has to be created from scratch instead of joining to the date model because of sales practices which put close dates out 100+ years in the future
      CASE
        WHEN DATE_PART('month', sfdc_opportunity.close_date) < 2
          THEN DATE_PART('year', sfdc_opportunity.close_date)
        ELSE (DATE_PART('year', sfdc_opportunity.close_date)+1)
      END                                                                                         AS close_fiscal_year,
      CASE
        WHEN DATE_PART('month', sfdc_opportunity_live.close_date) < 2
          THEN DATE_PART('year', sfdc_opportunity_live.close_date)
        ELSE (DATE_PART('year', sfdc_opportunity_live.close_date)+1)
      END                                                                                         AS close_fiscal_year_live,
  TO_NUMBER(TO_CHAR(sfdc_opportunity.iacv_created_date::DATE,'YYYYMMDD'),'99999999')
                                      AS arr_created_date_id,
      sfdc_opportunity.iacv_created_date                                                          AS arr_created_date,
      arr_created_date.fiscal_quarter_name_fy                                                     AS arr_created_fiscal_quarter_name,
      arr_created_date.first_day_of_fiscal_quarter                                                AS arr_created_fiscal_quarter_date,
      created_date.fiscal_quarter_name_fy                                                         AS created_fiscal_quarter_name,
      created_date.first_day_of_fiscal_quarter                                                    AS created_fiscal_quarter_date,
      subscription_start_date.fiscal_quarter_name_fy                                              AS subscription_start_date_fiscal_quarter_name,
      subscription_start_date.first_day_of_fiscal_quarter                                         AS subscription_start_date_fiscal_quarter_date,
      COALESCE(net_iacv_to_net_arr_ratio.ratio_net_iacv_to_net_arr,0)                             AS segment_order_type_iacv_to_net_arr_ratio,
      -- live fields
      sfdc_opportunity_live.sales_qualified_source                                                AS sales_qualified_source_live,
      sfdc_opportunity_live.sales_qualified_source_grouped                                        AS sales_qualified_source_grouped_live,
      sfdc_opportunity_live.is_edu_oss                                                            AS is_edu_oss_live,
      sfdc_opportunity_live.opportunity_category                                                  AS opportunity_category_live,
      sfdc_opportunity_live.is_jihu_account                                                       AS is_jihu_account_live,
      sfdc_opportunity_live.deal_path                                                             AS deal_path_live,
      sfdc_opportunity_live.parent_crm_account_geo                                                AS parent_crm_account_geo_live,
      sfdc_opportunity_live.order_type_grouped                                                    AS order_type_grouped_live,
      sfdc_opportunity_live.order_type                                                            AS order_type_live,
      -- net arr
      CASE
        WHEN sfdc_opportunity_stage.is_won = 1 -- only consider won deals
          AND sfdc_opportunity_live.opportunity_category <> 'Contract Reset' -- contract resets have a special way of calculating net iacv
          AND COALESCE(sfdc_opportunity.raw_net_arr,0) <> 0
          AND COALESCE(sfdc_opportunity.net_incremental_acv,0) <> 0
            THEN COALESCE(sfdc_opportunity.raw_net_arr / sfdc_opportunity.net_incremental_acv,0)
        ELSE NULL
      END                                                                     AS opportunity_based_iacv_to_net_arr_ratio,
      -- If there is no opportunity, use a default table ratio
      -- I am faking that using the upper CTE, that should be replaced by the official table
      -- calculated net_arr
      -- uses ratios to estimate the net_arr based on iacv if open or net_iacv if closed
      -- if there is an opportunity based ratio, use that, if not, use default from segment / order type
      -- NUANCE: Lost deals might not have net_incremental_acv populated, so we must rely on iacv
      -- Using opty ratio for open deals doesn't seem to work well
      CASE
        WHEN sfdc_opportunity.stage_name NOT IN ('8-Closed Lost', '9-Unqualified', 'Closed Won', '10-Duplicate')  -- OPEN DEAL
            THEN COALESCE(sfdc_opportunity.incremental_acv,0) * COALESCE(segment_order_type_iacv_to_net_arr_ratio,0)
        WHEN sfdc_opportunity.stage_name IN ('8-Closed Lost')                       -- CLOSED LOST DEAL and no Net IACV
          AND COALESCE(sfdc_opportunity.net_incremental_acv,0) = 0
            THEN COALESCE(sfdc_opportunity.incremental_acv,0) * COALESCE(segment_order_type_iacv_to_net_arr_ratio,0)
        WHEN sfdc_opportunity.stage_name IN ('8-Closed Lost', 'Closed Won')         -- REST of CLOSED DEAL
            THEN COALESCE(sfdc_opportunity.net_incremental_acv,0) * COALESCE(opportunity_based_iacv_to_net_arr_ratio,segment_order_type_iacv_to_net_arr_ratio)
        ELSE NULL
      END                                                                     AS calculated_from_ratio_net_arr,
      -- For opportunities before start of FY22, as Net ARR was WIP, there are a lot of opties with IACV or Net IACV and no Net ARR
      -- Those were later fixed in the opportunity object but stayed in the snapshot table.
      -- To account for those issues and give a directionally correct answer, we apply a ratio to everything before FY22
      CASE
        WHEN  sfdc_opportunity.snapshot_date::DATE < '2021-02-01' -- All deals before cutoff and that were not updated to Net ARR
          THEN calculated_from_ratio_net_arr
        WHEN  sfdc_opportunity.snapshot_date::DATE >= '2021-02-01'  -- After cutoff date, for all deals earlier than FY19 that are closed and have no net arr
              AND sfdc_opportunity.close_date::DATE < '2018-02-01'
              AND sfdc_opportunity.stage_name IN ('8-Closed Lost', 'Closed Lost', '9-Unqualified', 'Closed Won', '10-Duplicate')
              AND COALESCE(sfdc_opportunity.raw_net_arr,0) = 0
          THEN calculated_from_ratio_net_arr
        ELSE COALESCE(sfdc_opportunity.raw_net_arr,0) -- Rest of deals after cut off date
      END                                                                     AS net_arr,
      -- opportunity flags
      is_abm_tier_sao,
      is_abm_tier_closed_won,
      CASE
        WHEN (sfdc_opportunity.days_in_stage > 30
          OR sfdc_opportunity.incremental_acv > 100000
          OR sfdc_opportunity.pushed_count > 0)
          THEN TRUE
          ELSE FALSE
      END                                                                                         AS is_risky,
      CASE
        WHEN sfdc_opportunity.opportunity_term_base IS NULL THEN
          DATEDIFF('month', quote.quote_start_date, sfdc_opportunity.subscription_end_date)
        ELSE sfdc_opportunity.opportunity_term_base
      END                                                                                         AS opportunity_term,
      -- opportunity stage information
      sfdc_opportunity_stage.is_active                                                            AS is_active,
      sfdc_opportunity_stage.is_won                                                               AS is_won,
      IFF(sfdc_opportunity.stage_name IN ('1-Discovery', '2-Developing', '2-Scoping','3-Technical Evaluation', '4-Proposal', 'Closed Won','5-Negotiating', '6-Awaiting Signature', '7-Closing'), 1, 0) AS is_stage_1_plus,
      IFF(sfdc_opportunity.stage_name IN ('3-Technical Evaluation', '4-Proposal', 'Closed Won','5-Negotiating', '6-Awaiting Signature', '7-Closing'), 1, 0) AS is_stage_3_plus,
      IFF(sfdc_opportunity.stage_name IN ('4-Proposal', 'Closed Won','5-Negotiating', '6-Awaiting Signature', '7-Closing'), 1, 0) AS is_stage_4_plus,
      IFF(sfdc_opportunity.stage_name IN ('8-Closed Lost', 'Closed Lost'), 1, 0) AS is_lost,
      IFF(LOWER(sfdc_opportunity.subscription_type) like '%renewal%', 1, 0) AS is_renewal,
      IFF(sfdc_opportunity_live.opportunity_category IN ('Decommission'), 1, 0) AS is_decommissed,
     -- flags
      CASE
        WHEN sfdc_opportunity.sales_accepted_date IS NOT NULL
          AND sfdc_opportunity_live.is_edu_oss = 0
          AND sfdc_opportunity.stage_name != '10-Duplicate'
            THEN TRUE
        ELSE FALSE
      END                                                                                         AS is_sao,
      CASE
        WHEN is_sao = TRUE
          AND sfdc_opportunity_live.sales_qualified_source IN (
                                        'SDR Generated'
                                        , 'BDR Generated'
                                        )
            THEN TRUE
        ELSE FALSE
      END                                                                                         AS is_sdr_sao,
      CASE
        WHEN (
               (sfdc_opportunity.subscription_type = 'Renewal' AND sfdc_opportunity.stage_name = '8-Closed Lost')
                 OR sfdc_opportunity.stage_name = 'Closed Won'
              )
            AND (sfdc_opportunity_live.is_jihu_account != TRUE OR sfdc_opportunity_live.is_jihu_account IS NULL)
          THEN TRUE
        ELSE FALSE
      END                                                                                         AS is_net_arr_closed_deal,
      CASE
        WHEN (sfdc_opportunity.new_logo_count = 1
          OR sfdc_opportunity.new_logo_count = -1
          )
          AND (sfdc_opportunity_live.is_jihu_account != TRUE OR sfdc_opportunity_live.is_jihu_account IS NULL)
          THEN TRUE
        ELSE FALSE
      END                                                                                         AS is_new_logo_first_order,
      -- align is_booked_net_arr with fpa_master_bookings_flag definition from salesforce: https://gitlab.com/gitlab-com/sales-team/field-operations/systems/-/issues/1805
      -- coalesce both flags so we don't have NULL values for records before the fpa_master_bookings_flag was created
      COALESCE(
        sfdc_opportunity.fpa_master_bookings_flag,
        CASE
          WHEN (sfdc_opportunity_live.is_jihu_account != TRUE OR sfdc_opportunity_live.is_jihu_account IS NULL)
            AND (sfdc_opportunity_stage.is_won = 1
                  OR (
                      is_renewal = 1
                      AND is_lost = 1)
                    )
              THEN 1
            ELSE 0
        END)                                            AS is_booked_net_arr,
      /*
        Stop coalescing is_pipeline_created_eligible and is_net_arr_pipeline_created
      Definition changed for is_pipeline_created_eligible and if we coalesce both, the values will be inaccurate for
      snapshots before the definition changed in SFDC: https://gitlab.com/gitlab-com/sales-team/field-operations/systems/-/issues/5331
      Use is_net_arr_pipeline_created as the SSOT
      */
        CASE
          WHEN sfdc_opportunity_live.order_type IN ('1. New - First Order' ,'2. New - Connected', '3. Growth')
            AND sfdc_opportunity_live.is_edu_oss  = 0
            AND arr_created_date.first_day_of_fiscal_quarter IS NOT NULL
            AND sfdc_opportunity_live.opportunity_category IN ('Standard','Internal Correction','Ramp Deal','Credit','Contract Reset','Contract Reset/Ramp Deal')
            AND sfdc_opportunity.stage_name NOT IN ('00-Pre Opportunity','10-Duplicate', '9-Unqualified','0-Pending Acceptance')
            AND (net_arr > 0
              OR sfdc_opportunity_live.opportunity_category = 'Credit')
            AND sfdc_opportunity_live.sales_qualified_source != 'Web Direct Generated'
            AND (sfdc_opportunity_live.is_jihu_account != TRUE OR sfdc_opportunity_live.is_jihu_account IS NULL)
            AND sfdc_opportunity.stage_1_discovery_date IS NOT NULL
          THEN 1
          ELSE 0
        END                                                                                      AS is_net_arr_pipeline_created,
      CASE
        WHEN sfdc_opportunity.close_date <= CURRENT_DATE()
         AND sfdc_opportunity.is_closed = 'TRUE'
         AND sfdc_opportunity_live.is_edu_oss = 0
         AND (sfdc_opportunity_live.is_jihu_account != TRUE OR sfdc_opportunity_live.is_jihu_account IS NULL)
         AND (sfdc_opportunity.reason_for_loss IS NULL OR sfdc_opportunity.reason_for_loss != 'Merged into another opportunity')
         AND sfdc_opportunity_live.sales_qualified_source != 'Web Direct Generated'
         AND sfdc_opportunity_live.parent_crm_account_geo != 'JIHU'
         AND sfdc_opportunity.stage_name NOT IN ('10-Duplicate', '9-Unqualified')
            THEN TRUE
        ELSE FALSE
      END                                                                                         AS is_win_rate_calc,
      CASE
        WHEN sfdc_opportunity_stage.is_won = 'TRUE'
          AND sfdc_opportunity.is_closed = 'TRUE'
          AND sfdc_opportunity_live.is_edu_oss = 0
            THEN TRUE
        ELSE FALSE
      END                                                                                         AS is_closed_won,
      CASE
        WHEN LOWER(sfdc_opportunity_live.order_type_grouped) LIKE ANY ('%growth%', '%new%')
          AND sfdc_opportunity_live.is_edu_oss = 0
          AND is_stage_1_plus = 1
          AND sfdc_opportunity.forecast_category_name != 'Omitted'
          AND sfdc_opportunity.is_open = 1
          AND (sfdc_opportunity_live.is_jihu_account != TRUE OR sfdc_opportunity_live.is_jihu_account IS NULL)
         THEN 1
         ELSE 0
      END                                                                                         AS is_eligible_open_pipeline,
      CASE
        WHEN sfdc_opportunity.sales_accepted_date IS NOT NULL
          AND sfdc_opportunity_live.is_edu_oss = 0
          AND sfdc_opportunity.is_deleted = 0
            THEN 1
        ELSE 0
      END                                                                                         AS is_eligible_sao,
      CASE
        WHEN sfdc_opportunity_live.is_edu_oss = 0
          AND sfdc_opportunity.is_deleted = 0
          -- For ASP we care mainly about add on, new business, excluding contraction / churn
          AND sfdc_opportunity_live.order_type IN ('1. New - First Order','2. New - Connected','3. Growth')
          -- Exclude Decomissioned as they are not aligned to the real owner
          -- Contract Reset, Decomission
          AND sfdc_opportunity_live.opportunity_category IN ('Standard','Ramp Deal','Internal Correction')
          -- Exclude Deals with nARR < 0
          AND net_arr > 0
            THEN 1
          ELSE 0
      END                                                                                         AS is_eligible_asp_analysis,
      CASE
        WHEN sfdc_opportunity.close_date <= CURRENT_DATE()
         AND is_booked_net_arr = TRUE
         AND sfdc_opportunity_live.is_edu_oss = 0
         AND (sfdc_opportunity_live.is_jihu_account != TRUE OR sfdc_opportunity_live.is_jihu_account IS NULL)
         AND (sfdc_opportunity.reason_for_loss IS NULL OR sfdc_opportunity.reason_for_loss != 'Merged into another opportunity')
         AND sfdc_opportunity_live.sales_qualified_source != 'Web Direct Generated'
         AND sfdc_opportunity_live.deal_path != 'Web Direct'
         AND sfdc_opportunity_live.order_type IN ('1. New - First Order','2. New - Connected','3. Growth','4. Contraction','6. Churn - Final','5. Churn - Partial')
         AND sfdc_opportunity_live.parent_crm_account_geo != 'JIHU'
         AND (sfdc_opportunity_live.opportunity_category IN ('Standard') OR (
            /* Include only first year ramp deals. The ssp_id should be either equal to the SFDC id (18)
            or equal to the SFDC id (15) for first year ramp deals */
            sfdc_opportunity_live.opportunity_category = 'Ramp Deal' AND
            LEFT(sfdc_opportunity.dim_crm_opportunity_id, LENGTH(sfdc_opportunity.ssp_id)) = sfdc_opportunity.ssp_id))
            THEN 1
        ELSE 0
      END                                                                                         AS is_eligible_age_analysis,
      CASE
        WHEN sfdc_opportunity_live.is_edu_oss = 0
          AND sfdc_opportunity.is_deleted = 0
          AND (sfdc_opportunity_stage.is_won = 1
              OR (is_renewal = 1 AND is_lost = 1))
          AND sfdc_opportunity_live.order_type IN ('1. New - First Order','2. New - Connected','3. Growth','4. Contraction','6. Churn - Final','5. Churn - Partial')
            THEN 1
          ELSE 0
      END                                                                                         AS is_eligible_net_arr,
      CASE
        WHEN sfdc_opportunity_live.is_edu_oss = 0
          AND sfdc_opportunity.is_deleted = 0
          AND sfdc_opportunity_live.order_type IN ('4. Contraction','6. Churn - Final','5. Churn - Partial')
            THEN 1
          ELSE 0
      END                                                                                         AS is_eligible_churn_contraction,
      CASE
        WHEN sfdc_opportunity.stage_name IN ('10-Duplicate')
            THEN 1
        ELSE 0
      END                                                                                         AS is_duplicate,
      CASE
        WHEN sfdc_opportunity_live.opportunity_category IN ('Credit')
          THEN 1
        ELSE 0
      END                                                                                         AS is_credit,
      CASE
        WHEN sfdc_opportunity_live.opportunity_category IN ('Contract Reset')
          THEN 1
        ELSE 0
      END                                                                                         AS is_contract_reset,
      -- alliance type fields
      CASE
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE '%google%' OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE '%google%'
    THEN 'Google Cloud'
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE ANY ('%aws%', '%amazon%') OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE ANY ('%aws%', '%amazon%')
    THEN 'Amazon Web Services'
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE '%ibm (oem)%' OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE '%ibm (oem)%'
    THEN 'IBM (OEM)'
  WHEN NOT EQUAL_NULL(sfdc_opportunity.partner_track, 'Technology') AND NOT EQUAL_NULL(sfdc_opportunity.resale_partner_track, 'Technology') AND sfdc_opportunity.deal_path = 'Partner'
    THEN 'Channel Partners'
  WHEN ( sfdc_opportunity.fulfillment_partner_account_name IS NOT NULL OR sfdc_opportunity.partner_account_account_name IS NOT NULL )
    THEN 'Non-Alliance Partners'
  WHEN sfdc_opportunity.is_focus_partner = TRUE
    THEN 'Channel Focus Partner'
  ELSE 'Other Alliance Partners'
END AS alliance_type_current,
      CASE
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE '%google%' OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE '%google%'
    THEN 'GCP'
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE ANY ('%aws%', '%amazon%') OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE ANY ('%aws%', '%amazon%')
    THEN 'AWS'
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE '%ibm (oem)%' OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE '%ibm (oem)%'
    THEN 'IBM'
  WHEN NOT EQUAL_NULL(sfdc_opportunity.partner_track, 'Technology') AND NOT EQUAL_NULL(sfdc_opportunity.resale_partner_track, 'Technology') AND sfdc_opportunity.deal_path = 'Partner'
    THEN 'Channel Partners'
  WHEN ( sfdc_opportunity.fulfillment_partner_account_name IS NOT NULL OR sfdc_opportunity.partner_account_account_name IS NOT NULL )
    THEN 'Non-Alliance'
  WHEN sfdc_opportunity.is_focus_partner = TRUE
    THEN 'Channel Focus Partner'
  ELSE 'Other Alliance'
END AS alliance_type_short_current,
      CASE
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE '%google%' OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE '%google%'
    THEN 'Google Cloud'
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE ANY ('%aws%', '%amazon%') OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE ANY ('%aws%', '%amazon%')
    THEN 'Amazon Web Services'
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE '%ibm (oem)%' OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE '%ibm (oem)%'
    THEN 'IBM (OEM)'
  WHEN sfdc_opportunity.close_date >= '2022-02-01' AND NOT EQUAL_NULL(sfdc_opportunity.partner_track, 'Technology') AND NOT EQUAL_NULL(sfdc_opportunity.resale_partner_track, 'Technology') AND sfdc_opportunity.deal_path = 'Partner'
    THEN 'Channel Partners'
  WHEN sfdc_opportunity.close_date < '2022-02-01' AND ( sfdc_opportunity.fulfillment_partner_account_name IS NOT NULL OR sfdc_opportunity.partner_account_account_name IS NOT NULL )
    THEN 'Non-Alliance Partners'
  WHEN sfdc_opportunity.is_focus_partner = TRUE
    THEN 'Channel Focus Partner'
  ELSE 'Other Alliance Partners'
END AS alliance_type,
      CASE
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE '%google%' OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE '%google%'
    THEN 'GCP'
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE ANY ('%aws%', '%amazon%') OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE ANY ('%aws%', '%amazon%')
    THEN 'AWS'
  WHEN LOWER(sfdc_opportunity.fulfillment_partner_account_name) LIKE '%ibm (oem)%' OR LOWER(sfdc_opportunity.partner_account_account_name) LIKE '%ibm (oem)%'
    THEN 'IBM'
  WHEN sfdc_opportunity.close_date >= '2022-02-01' AND NOT EQUAL_NULL(sfdc_opportunity.partner_track, 'Technology') AND NOT EQUAL_NULL(sfdc_opportunity.resale_partner_track, 'Technology') AND sfdc_opportunity.deal_path = 'Partner'
    THEN 'Channel Partners'
  WHEN sfdc_opportunity.close_date < '2022-02-01' AND ( sfdc_opportunity.fulfillment_partner_account_name IS NOT NULL OR sfdc_opportunity.partner_account_account_name IS NOT NULL )
    THEN 'Non-Alliance'
  WHEN sfdc_opportunity.is_focus_partner = TRUE
    THEN 'Channel Focus Partner'
  ELSE 'Other Alliance Partners'
END AS alliance_type_short,
      sfdc_opportunity.fulfillment_partner_account_name AS resale_partner_name,
      --  quote information
      quote.dim_quote_id,
      quote.quote_start_date,
      -- contact information
      first_contact.dim_crm_person_id,
      first_contact.sfdc_contact_id,
      -- Record type information
      sfdc_record_type_source.record_type_name,
      -- attribution information
      linear_attribution_base.count_crm_attribution_touchpoints,
      campaigns_per_opp.count_campaigns,
      sfdc_opportunity.incremental_acv/linear_attribution_base.count_crm_attribution_touchpoints   AS weighted_linear_iacv,
     -- opportunity attributes
      CASE
        WHEN sfdc_opportunity.days_in_sao < 0                  THEN '1. Closed in < 0 days'
        WHEN sfdc_opportunity.days_in_sao BETWEEN 0 AND 30     THEN '2. Closed in 0-30 days'
        WHEN sfdc_opportunity.days_in_sao BETWEEN 31 AND 60    THEN '3. Closed in 31-60 days'
        WHEN sfdc_opportunity.days_in_sao BETWEEN 61 AND 90    THEN '4. Closed in 61-90 days'
        WHEN sfdc_opportunity.days_in_sao BETWEEN 91 AND 180   THEN '5. Closed in 91-180 days'
        WHEN sfdc_opportunity.days_in_sao BETWEEN 181 AND 270  THEN '6. Closed in 181-270 days'
        WHEN sfdc_opportunity.days_in_sao > 270                THEN '7. Closed in > 270 days'
        ELSE NULL
      END                                                                                         AS closed_buckets,
      CASE
        WHEN net_arr > -5000
            AND is_eligible_churn_contraction = 1
          THEN '1. < 5k'
        WHEN net_arr > -20000
          AND net_arr <= -5000
          AND is_eligible_churn_contraction = 1
          THEN '2. 5k-20k'
        WHEN net_arr > -50000
          AND net_arr <= -20000
          AND is_eligible_churn_contraction = 1
          THEN '3. 20k-50k'
        WHEN net_arr > -100000
          AND net_arr <= -50000
          AND is_eligible_churn_contraction = 1
          THEN '4. 50k-100k'
        WHEN net_arr < -100000
          AND is_eligible_churn_contraction = 1
          THEN '5. 100k+'
      END                                                 AS churn_contraction_net_arr_bucket,
      CASE
        WHEN sfdc_opportunity.created_date < '2022-02-01'
          THEN 'Legacy'
        WHEN sfdc_opportunity.crm_sales_dev_rep_id IS NOT NULL AND sfdc_opportunity.crm_business_dev_rep_id IS NOT NULL
          THEN 'SDR & BDR'
        WHEN sfdc_opportunity.crm_sales_dev_rep_id IS NOT NULL
          THEN 'SDR'
        WHEN sfdc_opportunity.crm_business_dev_rep_id IS NOT NULL
          THEN 'BDR'
        WHEN sfdc_opportunity.crm_business_dev_rep_id IS NULL AND sfdc_opportunity.crm_sales_dev_rep_id IS NULL
          THEN 'No XDR Assigned'
      END                                               AS sdr_or_bdr,
      CASE
        WHEN sfdc_opportunity_stage.is_won = 1
          THEN '1.Won'
        WHEN is_lost = 1
          THEN '2.Lost'
        WHEN sfdc_opportunity.is_open = 1
          THEN '0. Open'
        ELSE 'N/A'
      END                                                                                         AS stage_category,
      CASE
       WHEN sfdc_opportunity_live.order_type = '1. New - First Order'
         THEN '1. New'
       WHEN sfdc_opportunity_live.order_type IN ('2. New - Connected', '3. Growth', '5. Churn - Partial','6. Churn - Final','4. Contraction')
         THEN '2. Growth'
       ELSE '3. Other'
     END                                                                   AS deal_group,
     CASE
       WHEN sfdc_opportunity_live.order_type = '1. New - First Order'
         THEN '1. New'
       WHEN sfdc_opportunity_live.order_type IN ('2. New - Connected', '3. Growth')
         THEN '2. Growth'
       WHEN sfdc_opportunity_live.order_type IN ('4. Contraction')
         THEN '3. Contraction'
       WHEN sfdc_opportunity_live.order_type IN ('5. Churn - Partial','6. Churn - Final')
         THEN '4. Churn'
       ELSE '5. Other'
      END                                                                                       AS deal_category,
      COALESCE(sfdc_opportunity.reason_for_loss, sfdc_opportunity.downgrade_reason)               AS reason_for_loss_staged,
      CASE
        WHEN reason_for_loss_staged IN ('Do Nothing','Other','Competitive Loss','Operational Silos')
          OR reason_for_loss_staged IS NULL
          THEN 'Unknown'
        WHEN reason_for_loss_staged IN ('Missing Feature','Product value/gaps','Product Value / Gaps',
                                          'Stayed with Community Edition','Budget/Value Unperceived')
          THEN 'Product Value / Gaps'
        WHEN reason_for_loss_staged IN ('Lack of Engagement / Sponsor','Went Silent','Evangelist Left')
          THEN 'Lack of Engagement / Sponsor'
        WHEN reason_for_loss_staged IN ('Loss of Budget','No budget')
          THEN 'Loss of Budget'
        WHEN reason_for_loss_staged = 'Merged into another opportunity'
          THEN 'Merged Opp'
        WHEN reason_for_loss_staged = 'Stale Opportunity'
          THEN 'No Progression - Auto-close'
        WHEN reason_for_loss_staged IN ('Product Quality / Availability','Product quality/availability')
          THEN 'Product Quality / Availability'
        ELSE reason_for_loss_staged
     END                                                                                        AS reason_for_loss_calc,
     CASE
       WHEN (
              (
                is_renewal = 1
                  AND is_lost = 1
               )
                OR sfdc_opportunity_stage.is_won = 1
              )
               AND sfdc_opportunity_live.order_type IN ('4. Contraction','5. Churn - Partial')
          THEN 'Contraction'
               WHEN (
              (
                is_renewal = 1
                  AND is_lost = 1
               )
                OR sfdc_opportunity_stage.is_won = 1
              )
               AND sfdc_opportunity_live.order_type = '6. Churn - Final'
          THEN 'Churn'
        ELSE NULL
     END                                                                                        AS churn_contraction_type,
     CASE
        WHEN is_renewal = 1
          AND subscription_start_date_fiscal_quarter_date >= close_fiscal_quarter_date
         THEN 'On-Time'
        WHEN is_renewal = 1
          AND subscription_start_date_fiscal_quarter_date < close_fiscal_quarter_date
            THEN 'Late'
      END                                                                                       AS renewal_timing_status,
      CASE
        WHEN net_arr > -5000
          THEN '1. < 5k'
        WHEN net_arr > -20000 AND net_arr <= -5000
          THEN '2. 5k-20k'
        WHEN net_arr > -50000 AND net_arr <= -20000
          THEN '3. 20k-50k'
        WHEN net_arr > -100000 AND net_arr <= -50000
          THEN '4. 50k-100k'
        WHEN net_arr < -100000
          THEN '5. 100k+'
      END                                                                                       AS churned_contraction_net_arr_bucket,
      CASE
        WHEN sfdc_opportunity_live.deal_path = 'Direct'
          THEN 'Direct'
        WHEN sfdc_opportunity_live.deal_path = 'Web Direct'
          THEN 'Web Direct'
        WHEN sfdc_opportunity_live.deal_path = 'Partner'
            AND sfdc_opportunity_live.sales_qualified_source = 'Partner Generated'
          THEN 'Partner Sourced'
        WHEN sfdc_opportunity_live.deal_path = 'Partner'
            AND sfdc_opportunity_live.sales_qualified_source != 'Partner Generated'
          THEN 'Partner Co-Sell'
      END                                                                                       AS deal_path_engagement,
      CASE
        WHEN net_arr > 0 AND net_arr < 5000
          THEN '1 - Small (<5k)'
        WHEN net_arr >=5000 AND net_arr < 25000
          THEN '2 - Medium (5k - 25k)'
        WHEN net_arr >=25000 AND net_arr < 100000
          THEN '3 - Big (25k - 100k)'
        WHEN net_arr >= 100000
          THEN '4 - Jumbo (>100k)'
        ELSE 'Other'
      END                                                          AS deal_size,
      CASE
        WHEN net_arr > 0 AND net_arr < 1000
          THEN '1. (0k -1k)'
        WHEN net_arr >=1000 AND net_arr < 10000
          THEN '2. (1k - 10k)'
        WHEN net_arr >=10000 AND net_arr < 50000
          THEN '3. (10k - 50k)'
        WHEN net_arr >=50000 AND net_arr < 100000
          THEN '4. (50k - 100k)'
        WHEN net_arr >= 100000 AND net_arr < 250000
          THEN '5. (100k - 250k)'
        WHEN net_arr >= 250000 AND net_arr < 500000
          THEN '6. (250k - 500k)'
        WHEN net_arr >= 500000 AND net_arr < 1000000
          THEN '7. (500k-1000k)'
        WHEN net_arr >= 1000000
          THEN '8. (>1000k)'
        ELSE 'Other'
      END                                                                                         AS calculated_deal_size,
      CASE
        WHEN
          sfdc_opportunity.stage_name IN (
            '00-Pre Opportunity',
            '0-Pending Acceptance',
            '0-Qualifying',
            'Developing',
            '1-Discovery',
            '2-Developing',
            '2-Scoping'
          )
          THEN 'Pipeline'
        WHEN
          sfdc_opportunity.stage_name IN (
            '3-Technical Evaluation',
            '4-Proposal',
            '5-Negotiating',
            '6-Awaiting Signature',
            '7-Closing'
          )
          THEN '3+ Pipeline'
        WHEN sfdc_opportunity.stage_name IN ('8-Closed Lost', 'Closed Lost')
          THEN 'Lost'
        WHEN sfdc_opportunity.stage_name IN ('Closed Won')
          THEN 'Closed Won'
        ELSE 'Other'
      END AS stage_name_3plus,
      CASE
        WHEN
          sfdc_opportunity.stage_name IN (
            '00-Pre Opportunity',
            '0-Pending Acceptance',
            '0-Qualifying',
            'Developing',
            '1-Discovery',
            '2-Developing',
            '2-Scoping',
            '3-Technical Evaluation'
          )
          THEN 'Pipeline'
        WHEN
          sfdc_opportunity.stage_name IN (
            '4-Proposal', '5-Negotiating', '6-Awaiting Signature', '7-Closing'
          )
          THEN '4+ Pipeline'
        WHEN sfdc_opportunity.stage_name IN ('8-Closed Lost', 'Closed Lost')
          THEN 'Lost'
        WHEN sfdc_opportunity.stage_name IN ('Closed Won')
          THEN 'Closed Won'
        ELSE 'Other'
      END AS stage_name_4plus,
      -- counts and arr totals by pipeline stage
       CASE
        WHEN is_decommissed = 1
          THEN -1
        WHEN is_credit = 1
          THEN 0
        ELSE 1
      END                                               AS calculated_deal_count,
      CASE
        WHEN is_eligible_open_pipeline = 1
          AND is_stage_1_plus = 1
            THEN calculated_deal_count
        ELSE 0
      END                                               AS open_1plus_deal_count,
      CASE
        WHEN is_eligible_open_pipeline = 1
          AND is_stage_3_plus = 1
            THEN calculated_deal_count
        ELSE 0
      END                                               AS open_3plus_deal_count,
      CASE
        WHEN is_eligible_open_pipeline = 1
          AND is_stage_4_plus = 1
            THEN calculated_deal_count
        ELSE 0
      END                                               AS open_4plus_deal_count,
      CASE
        WHEN is_booked_net_arr = 1
          THEN calculated_deal_count
        ELSE 0
      END                                               AS booked_deal_count,
      CASE
        WHEN is_eligible_churn_contraction = 1
          THEN calculated_deal_count
        ELSE 0
      END                                               AS churned_contraction_deal_count,
      CASE
        WHEN (
              (
                is_renewal = 1
                  AND is_lost = 1
               )
                OR sfdc_opportunity_stage.is_won = 1
              )
              AND is_eligible_churn_contraction = 1
          THEN calculated_deal_count
        ELSE 0
      END                                                 AS booked_churned_contraction_deal_count,
      CASE
        WHEN
          (
            (
              is_renewal = 1
                AND is_lost = 1
              )
            OR sfdc_opportunity_stage.is_won = 1
            )
            AND is_eligible_churn_contraction = 1
          THEN net_arr
        ELSE 0
      END                                                 AS booked_churned_contraction_net_arr,
      CASE
        WHEN is_eligible_churn_contraction = 1
          THEN net_arr
        ELSE 0
      END                                                 AS churned_contraction_net_arr,
      CASE
        WHEN is_eligible_open_pipeline = 1
          THEN net_arr
        ELSE 0
      END                                                AS open_1plus_net_arr,
      CASE
        WHEN is_eligible_open_pipeline = 1
          AND is_stage_3_plus = 1
            THEN net_arr
        ELSE 0
      END                                                AS open_3plus_net_arr,
      CASE
        WHEN is_eligible_open_pipeline = 1
          AND is_stage_4_plus = 1
            THEN net_arr
        ELSE 0
      END                                                AS open_4plus_net_arr,
      CASE
        WHEN is_booked_net_arr = 1
          THEN net_arr
        ELSE 0
      END                                                 AS booked_net_arr,
      CASE
        WHEN sfdc_opportunity_live.deal_path = 'Partner'
          THEN REPLACE(COALESCE(sfdc_opportunity.partner_track, sfdc_opportunity.partner_account_partner_track, sfdc_opportunity.fulfillment_partner_partner_track,'Open'),'select','Select')
        ELSE 'Direct'
      END                                                                                           AS calculated_partner_track,
      CASE
        WHEN
        sfdc_opportunity.dim_parent_crm_account_id IN (
          '001610000111bA3',
          '0016100001F4xla',
          '0016100001CXGCs',
          '00161000015O9Yn',
          '0016100001b9Jsc'
        )
        AND sfdc_opportunity.close_date < '2020-08-01'
        THEN 1
      -- NF 2021 - Pubsec extreme deals
      WHEN
        sfdc_opportunity.dim_crm_opportunity_id IN ('0064M00000WtZKUQA3', '0064M00000Xb975QAB')
        AND (sfdc_opportunity.snapshot_date < '2021-05-01' OR sfdc_opportunity.is_live = 1)
        THEN 1
      -- exclude vision opps from FY21-Q2
      WHEN arr_created_fiscal_quarter_name = 'FY21-Q2'
        AND sfdc_opportunity.snapshot_day_of_fiscal_quarter_normalised = 90
        AND sfdc_opportunity.stage_name IN (
          '00-Pre Opportunity', '0-Pending Acceptance', '0-Qualifying'
        )
        THEN 1
      -- NF 20220415 PubSec duplicated deals on Pipe Gen -- Lockheed Martin GV - 40000 Ultimate Renewal
      WHEN
        sfdc_opportunity.dim_crm_opportunity_id IN (
          '0064M00000ZGpfQQAT', '0064M00000ZGpfVQAT', '0064M00000ZGpfGQAT'
        )
        THEN 1
       -- remove test accounts
       WHEN
         sfdc_opportunity.dim_crm_account_id = '0014M00001kGcORQA0'
         THEN 1
       --remove test accounts
       WHEN (sfdc_opportunity.dim_parent_crm_account_id = ('0016100001YUkWVAA1')
            OR sfdc_opportunity.dim_crm_account_id IS NULL)
         THEN 1
       -- remove jihu accounts
       WHEN sfdc_opportunity_live.is_jihu_account = 1
         THEN 1
       -- remove deleted opps
        WHEN sfdc_opportunity.is_deleted = 1
          THEN 1
         ELSE 0
      END AS is_excluded_from_pipeline_created,
      CASE
        WHEN sfdc_opportunity.is_open = 1
          THEN DATEDIFF(days, sfdc_opportunity.created_date, sfdc_opportunity.snapshot_date)
        WHEN sfdc_opportunity.is_open = 0 AND sfdc_opportunity.snapshot_date < sfdc_opportunity.close_date
          THEN DATEDIFF(days, sfdc_opportunity.created_date, sfdc_opportunity.snapshot_date)
        ELSE DATEDIFF(days, sfdc_opportunity.created_date, sfdc_opportunity.close_date)
      END                                                       AS calculated_age_in_days,
      CASE
        WHEN arr_created_fiscal_quarter_date = close_fiscal_quarter_date
          AND is_net_arr_pipeline_created = 1
            THEN net_arr
        ELSE 0
      END                                                         AS created_and_won_same_quarter_net_arr,
      IFF(sfdc_opportunity.comp_new_logo_override = 'Yes', 1, 0) AS is_comp_new_logo_override,
      IFF(arr_created_date.fiscal_quarter_name_fy = sfdc_opportunity.snapshot_fiscal_quarter_name AND is_net_arr_pipeline_created = 1, net_arr, 0) AS created_in_snapshot_quarter_net_arr,
      IFF(arr_created_date.fiscal_quarter_name_fy = sfdc_opportunity.snapshot_fiscal_quarter_name AND is_net_arr_pipeline_created = 1, calculated_deal_count, 0) AS created_in_snapshot_quarter_deal_count,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Other'),1,0) AS competitors_other_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'GitLab Core'),1,0) AS competitors_gitlab_core_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'None'),1,0) AS competitors_none_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'GitHub Enterprise'),1,0) AS competitors_github_enterprise_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'BitBucket Server'),1,0) AS competitors_bitbucket_server_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Unknown'),1,0) AS competitors_unknown_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'GitHub.com'),1,0) AS competitors_github_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'GitLab.com'),1,0) AS competitors_gitlab_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Jenkins'),1,0) AS competitors_jenkins_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Azure DevOps'),1,0) AS competitors_azure_devops_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'SVN'),1,0) AS competitors_svn_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'BitBucket.Org'),1,0) AS competitors_bitbucket_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Atlassian'),1,0) AS competitors_atlassian_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Perforce'),1,0) AS competitors_perforce_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Visual Studio Team Services'),1,0) AS competitors_visual_studio_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Azure'),1,0) AS competitors_azure_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Amazon Code Commit'),1,0) AS competitors_amazon_code_commit_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'CircleCI'),1,0) AS competitors_circleci_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'Bamboo'),1,0) AS competitors_bamboo_flag,
      IFF(CONTAINS(sfdc_opportunity.competitors, 'AWS'),1,0) AS competitors_aws_flag,
    CASE
        WHEN close_fiscal_year_live < 2024
          THEN CONCAT(
                    UPPER(sfdc_opportunity_live.crm_opp_owner_sales_segment_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_geo_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_region_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_area_stamped),
                    '-',
                    close_fiscal_year
                    )
        WHEN close_fiscal_year_live = 2024 AND LOWER(sfdc_opportunity_live.crm_opp_owner_business_unit_stamped) = 'comm'
          THEN CONCAT(
                    UPPER(sfdc_opportunity.crm_opp_owner_business_unit_stamped),
                    '-',
                    UPPER(sfdc_opportunity.crm_opp_owner_geo_stamped),
                    '-',
                    UPPER(sfdc_opportunity.crm_opp_owner_sales_segment_stamped),
                    '-',
                    UPPER(sfdc_opportunity.crm_opp_owner_region_stamped),
                    '-',
                    UPPER(sfdc_opportunity.crm_opp_owner_area_stamped),
                    '-',
                    close_fiscal_year_live
                    )
        WHEN close_fiscal_year_live = 2024 AND LOWER(sfdc_opportunity_live.crm_opp_owner_business_unit_stamped) = 'entg'
          THEN CONCAT(
                    UPPER(sfdc_opportunity_live.crm_opp_owner_business_unit_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_geo_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_region_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_area_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_sales_segment_stamped),
                    '-',
                    close_fiscal_year_live
                    )
        WHEN close_fiscal_year_live = 2024
          AND (sfdc_opportunity_live.crm_opp_owner_business_unit_stamped IS NOT NULL AND LOWER(sfdc_opportunity_live.crm_opp_owner_business_unit_stamped) NOT IN ('comm', 'entg')) -- some opps are closed by non-sales reps, so fill in their values completely
          THEN CONCAT(
                    UPPER(sfdc_opportunity_live.crm_opp_owner_business_unit_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_sales_segment_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_geo_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_region_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_area_stamped),
                    '-',
                    close_fiscal_year_live
                    )
        WHEN close_fiscal_year_live = 2024 AND sfdc_opportunity_live.crm_opp_owner_business_unit_stamped IS NULL -- done for data quality issues
          THEN CONCAT(
                    UPPER(sfdc_opportunity_live.crm_opp_owner_sales_segment_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_geo_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_region_stamped),
                    '-',
                    UPPER(sfdc_opportunity_live.crm_opp_owner_area_stamped),
                    '-',
                    close_fiscal_year_live
                    )
        WHEN close_fiscal_year_live >= 2025
          THEN CONCAT(
                      UPPER(COALESCE(sfdc_opportunity_live.opportunity_owner_role, sfdc_opportunity_live.opportunity_account_owner_role)),
                      '-',
                      close_fiscal_year_live
                      )
      END AS dim_crm_opp_owner_stamped_hierarchy_sk,
      UPPER(
        IFF(sfdc_opportunity_live.close_date < close_date_live.current_first_day_of_fiscal_year, sfdc_opportunity_live.dim_crm_user_hierarchy_account_user_sk, dim_crm_opp_owner_stamped_hierarchy_sk)
      ) AS dim_crm_current_account_set_hierarchy_sk,
      DATEDIFF(MONTH, arr_created_fiscal_quarter_date, close_fiscal_quarter_date) AS arr_created_to_close_diff,
      CASE
        WHEN arr_created_to_close_diff BETWEEN 0 AND 2 THEN 'CQ'
        WHEN arr_created_to_close_diff BETWEEN 3 AND 5 THEN 'CQ+1'
        WHEN arr_created_to_close_diff BETWEEN 6 AND 8 THEN 'CQ+2'
        WHEN arr_created_to_close_diff BETWEEN 9 AND 11 THEN 'CQ+3'
        WHEN arr_created_to_close_diff >= 12 THEN 'CQ+4 >='
      END AS landing_quarter_relative_to_arr_created_date,
      DATEDIFF(MONTH, sfdc_opportunity.snapshot_fiscal_quarter_date, close_fiscal_quarter_date) AS snapshot_to_close_diff,
      CASE
        WHEN snapshot_to_close_diff BETWEEN 0 AND 2 THEN 'CQ'
        WHEN snapshot_to_close_diff BETWEEN 3 AND 5 THEN 'CQ+1'
        WHEN snapshot_to_close_diff BETWEEN 6 AND 8 THEN 'CQ+2'
        WHEN snapshot_to_close_diff BETWEEN 9 AND 11 THEN 'CQ+3'
        WHEN snapshot_to_close_diff >= 12 THEN 'CQ+4 >='
      END AS landing_quarter_relative_to_snapshot_date,
    CASE
      WHEN is_renewal = 1
          AND is_eligible_age_analysis = 1
            THEN DATEDIFF(day, arr_created_date, close_date.date_actual)
      WHEN is_renewal = 0
          AND is_eligible_age_analysis = 1
            THEN DATEDIFF(day, sfdc_opportunity.created_date, close_date.date_actual)
    END                                                           AS cycle_time_in_days,
    -- Snapshot Quarter Metrics
    -- This code calculates sales metrics for each snapshot quarter
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = arr_created_fiscal_quarter_date
        AND is_net_arr_pipeline_created = 1
          THEN net_arr
      ELSE NULL
    END                                                         AS created_arr_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_closed_won = TRUE
          AND is_win_rate_calc = TRUE
            THEN calculated_deal_count
      ELSE NULL
    END                                                         AS closed_won_opps_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_win_rate_calc = TRUE
          THEN calculated_deal_count
      ELSE NULL
    END                                                         AS closed_opps_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_booked_net_arr = TRUE
          THEN net_arr
      ELSE NULL
    END                                                         AS booked_net_arr_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = arr_created_fiscal_quarter_date
        AND is_net_arr_pipeline_created = 1
          THEN calculated_deal_count
      ELSE NULL
    END                                                         AS created_deals_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_renewal = 1
          AND  is_eligible_age_analysis = 1
            THEN DATEDIFF(day, arr_created_date, close_date.date_actual)
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_renewal = 0
          AND  is_eligible_age_analysis = 1
            THEN DATEDIFF(day, sfdc_opportunity.created_date, close_date.date_actual)
      ELSE NULL
    END                                                         AS cycle_time_in_days_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_booked_net_arr = TRUE
        THEN calculated_deal_count
      ELSE NULL
    END                                                         AS booked_deal_count_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_eligible_open_pipeline = 1
            THEN net_arr
      ELSE NULL
    END                                                          AS open_1plus_net_arr_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_eligible_open_pipeline = 1
          AND is_stage_3_plus = 1
            THEN net_arr
      ELSE NULL
    END                                                          AS open_3plus_net_arr_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_eligible_open_pipeline = 1
          AND is_stage_4_plus = 1
            THEN net_arr
      ELSE NULL
    END                                                          AS open_4plus_net_arr_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_eligible_open_pipeline = 1
          THEN calculated_deal_count
      ELSE NULL
    END                                                         AS open_1plus_deal_count_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_eligible_open_pipeline = 1
        AND is_stage_3_plus = 1
          THEN calculated_deal_count
      ELSE NULL
    END                                                         AS open_3plus_deal_count_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_eligible_open_pipeline = 1
        AND is_stage_4_plus = 1
          THEN calculated_deal_count
      ELSE NULL
    END                                                         AS open_4plus_deal_count_in_snapshot_quarter,
    -- Fields to calculate average deal size. Net arr in the numerator / deal count in the denominator
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_booked_net_arr = TRUE
          AND net_arr > 0
        THEN 1
      ELSE NULL
    END                                                         AS positive_booked_deal_count_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_booked_net_arr = TRUE
          AND net_arr > 0
        THEN net_arr
      ELSE NULL
    END                                                         AS positive_booked_net_arr_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_eligible_open_pipeline = 1
            AND net_arr > 0
        THEN 1
      ELSE NULL
    END                                                         AS positive_open_deal_count_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND is_eligible_open_pipeline = 1
            AND net_arr > 0
        THEN net_arr
      ELSE NULL
    END                                                         AS positive_open_net_arr_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND sfdc_opportunity.is_closed = 'TRUE'
          THEN calculated_deal_count
        ELSE NULL
    END                                                         AS closed_deals_in_snapshot_quarter,
    CASE
      WHEN sfdc_opportunity.snapshot_fiscal_quarter_date = close_fiscal_quarter_date
        AND sfdc_opportunity.is_closed = 'TRUE'
          THEN net_arr
      ELSE NULL
    END                                                         AS closed_net_arr_in_snapshot_quarter,
    -- Overall Sales Metrics
    -- This code calculates sales metrics without specific quarter alignment
    CASE
      WHEN is_net_arr_pipeline_created = 1
          THEN net_arr
      ELSE NULL
    END                                                         AS created_arr,
    CASE
      WHEN is_closed_won = TRUE
          AND is_win_rate_calc = TRUE
            THEN calculated_deal_count
      ELSE NULL
    END                                                         AS closed_won_opps,
    CASE
      WHEN is_win_rate_calc = TRUE
          THEN calculated_deal_count
      ELSE NULL
    END                                                         AS closed_opps,
    CASE
      WHEN is_net_arr_pipeline_created = 1
          THEN calculated_deal_count
      ELSE NULL
    END                                                         AS created_deals,
    -- Fields to calculate average deal size. Net arr in the numerator / deal count in the denominator
    CASE
      WHEN is_booked_net_arr = TRUE
          AND net_arr > 0
        THEN 1
      ELSE NULL
    END                                                         AS positive_booked_deal_count,
    CASE
      WHEN is_booked_net_arr = TRUE
          AND net_arr > 0
        THEN net_arr
      ELSE NULL
    END                                                         AS positive_booked_net_arr,
    CASE
      WHEN is_eligible_open_pipeline = 1
            AND net_arr > 0
        THEN 1
      ELSE NULL
    END                                                         AS positive_open_deal_count,
    CASE
      WHEN is_eligible_open_pipeline = 1
            AND net_arr > 0
        THEN net_arr
      ELSE NULL
    END                                                         AS positive_open_net_arr,
    CASE
      WHEN sfdc_opportunity.is_closed = 'TRUE'
          THEN calculated_deal_count
        ELSE NULL
    END                                                         AS closed_deals,
    CASE
      WHEN sfdc_opportunity.is_closed = 'TRUE'
          THEN net_arr
      ELSE NULL
    END                                                         AS closed_net_arr
  FROM sfdc_opportunity
  INNER JOIN sfdc_opportunity_stage
    ON sfdc_opportunity.stage_name = sfdc_opportunity_stage.primary_label
  LEFT JOIN quote
    ON sfdc_opportunity.dim_crm_opportunity_id = quote.dim_crm_opportunity_id
  LEFT JOIN linear_attribution_base
    ON sfdc_opportunity.dim_crm_opportunity_id = linear_attribution_base.dim_crm_opportunity_id
  LEFT JOIN campaigns_per_opp
    ON sfdc_opportunity.dim_crm_opportunity_id = campaigns_per_opp.dim_crm_opportunity_id
  LEFT JOIN first_contact
    ON sfdc_opportunity.dim_crm_opportunity_id = first_contact.opportunity_id AND first_contact.row_num = 1
  LEFT JOIN sfdc_opportunity_live
    ON sfdc_opportunity_live.dim_crm_opportunity_id = sfdc_opportunity.dim_crm_opportunity_id
  LEFT JOIN dim_date AS close_date
    ON sfdc_opportunity.close_date = close_date.date_actual
  LEFT JOIN dim_date AS close_date_live
    ON sfdc_opportunity_live.close_date = close_date_live.date_actual
  LEFT JOIN dim_date AS created_date
    ON sfdc_opportunity.created_date = created_date.date_actual
  LEFT JOIN dim_date AS arr_created_date
    ON sfdc_opportunity.iacv_created_date::DATE = arr_created_date.date_actual
  LEFT JOIN dim_date AS subscription_start_date
    ON sfdc_opportunity.subscription_start_date::DATE = subscription_start_date.date_actual
  LEFT JOIN net_iacv_to_net_arr_ratio
    ON sfdc_opportunity.opportunity_owner_user_segment = net_iacv_to_net_arr_ratio.user_segment_stamped
      AND sfdc_opportunity.order_type = net_iacv_to_net_arr_ratio.order_type
  LEFT JOIN sfdc_record_type_source
    ON sfdc_opportunity.record_type_id = sfdc_record_type_source.record_type_id
  LEFT JOIN abm_tier_unioned
    ON sfdc_opportunity.dim_crm_opportunity_id=abm_tier_unioned.dim_crm_opportunity_id
      AND sfdc_opportunity.is_live = 1
)
SELECT
      *,
      '@michellecooper'::VARCHAR       AS created_by,
      '@rkohnke'::VARCHAR       AS updated_by,
      '2022-02-23'::DATE        AS model_created_date,
      '2024-09-20'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
                CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;

CREATE TABLE "PROD".common_prep.prep_location_region as
WITH source_data AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_users_source
    WHERE user_geo IS NOT NULL
), unioned AS (
    SELECT DISTINCT
      md5(cast(coalesce(cast(user_geo as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))  AS dim_location_region_id,
      user_geo                     AS location_region_name
    FROM source_data
    UNION ALL
    SELECT
      MD5('-1')                                   AS dim_location_region_id,
      'Missing location_region_name'       AS location_region_name
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@mcooperDD'::VARCHAR       AS updated_by,
      '2020-12-29'::DATE        AS model_created_date,
      '2020-12-29'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM unioned;

CREATE TABLE "PREP".zuora_order.zuora_order_action_source as
WITH source AS (
    SELECT *
    FROM "RAW".zuora_stitch_rest_api.orderaction
), renamed AS (
    SELECT
      --Primary Keys
      id::VARCHAR                               AS order_action_id,
      --Info
      accountid::VARCHAR                        AS account_id,
      autogenerated::VARCHAR                    AS auto_generated,
      autorenew::VARCHAR                        AS auto_renew,
      billtocontactid::VARCHAR                  AS bill_to_contact_id,
      cancellationeffectivedate::TIMESTAMP_TZ   AS cancellation_effective_date,
      cancellationpolicy::VARCHAR               AS cancellation_policy,
      changereason::VARCHAR                     AS change_reason,
      clearingexistingbilltocontact::VARCHAR    AS clearing_existing_bill_to_contact,
      clearingexistingpaymentterm::VARCHAR      AS clearing_existing_payment_term,
      contracteffectivedate::TIMESTAMP_TZ       AS contract_effective_date,
      createdbyid::VARCHAR                      AS created_by_id,
      createddate::TIMESTAMP_TZ                 AS created_date,
      currentterm::VARCHAR                      AS current_term,
      currenttermperiodtype::VARCHAR            AS current_term_period_type,
      customeracceptancedate::TIMESTAMP_TZ      AS customer_acceptance_date,
      defaultpaymentmethodid::VARCHAR           AS default_payment_method_id,
      effectivepolicy::VARCHAR                  AS effective_policy,
      orderactionbilltoid::VARCHAR              AS order_action_bill_to_id,
      orderid::VARCHAR                          AS order_id,
      parentaccountid::VARCHAR                  AS parent_account_id,
      paymentterm::VARCHAR                      AS payment_term,
      renewalterm::VARCHAR                      AS renewal_term,
      renewaltermperiodtype::VARCHAR            AS renewal_term_period_type,
      renewsetting::VARCHAR                     AS renew_setting,
      sequence::VARCHAR                         AS sequence,
      serviceactivationdate::TIMESTAMP_TZ       AS service_activation_date,
      soldtocontactid::VARCHAR                  AS sold_to_contact_id,
      subscriptionid::VARCHAR                   AS subscription_id,
      subscriptionowneraccountbilltoid::VARCHAR AS subscription_owner_account_bill_to_id,
      subscriptionowneraccountid::VARCHAR       AS subscription_owner_account_id,
      subscriptionowneraccountsoldtoid::VARCHAR AS subscription_owner_account_sold_to_id,
      subscriptionversionamendmentId::VARCHAR   AS amendment_id,
      subtype::VARCHAR                          AS subtype,
      termstartdate::TIMESTAMP_TZ               AS term_start_date,
      termtype::VARCHAR                         AS term_type,
      type::VARCHAR                             AS type,
      updatedbyid::VARCHAR                      AS updated_by_id,
      updateddate::TIMESTAMP_TZ                 AS updated_date
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora_order.zuora_order_source as
WITH source AS (
    SELECT *
    FROM "RAW".zuora_stitch_rest_api."ORDER"
), renamed AS (
    SELECT
      --Primary Keys
      id::VARCHAR                       AS order_id,
      --Info
      accountid::VARCHAR AS account_id,
      billtocontactid::VARCHAR AS bill_to_contact_id,
      createdbyid::VARCHAR AS created_by_id,
      createdbymigration::BOOLEAN AS created_by_migration,
      createddate::TIMESTAMP_TZ AS created_date,
      defaultpaymentmethodid::VARCHAR AS default_payment_method_id,
      description::VARCHAR AS description,
      orderdate::TIMESTAMP_TZ AS order_date,
      ordernumber::VARCHAR AS order_number,
      parentaccountid::VARCHAR AS parent_account_id,
      soldtocontactid::VARCHAR AS sold_to_contact_id,
      state::VARCHAR AS state,
      status::VARCHAR AS status,
      updatedbyid::VARCHAR AS updated_by_id,
      updateddate::VARCHAR AS updated_date
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora.zuora_rate_plan_charge_source as
-- depends_on: "PREP".seed_finance.zuora_excluded_accounts
-- values to consider renaming:
-- mrr
-- dmrc
-- dtcv
-- tcv
-- uom
WITH source AS (
    SELECT *
    FROM "RAW".zuora_stitch.rateplancharge
), renamed AS(
    SELECT
      id                                                    AS rate_plan_charge_id,
      name                                                  AS rate_plan_charge_name,
      --keys
      originalid                                            AS original_id,
      rateplanid                                            AS rate_plan_id,
      productrateplanchargeid                               AS product_rate_plan_charge_id,
      productrateplanid                                     AS product_rate_plan_id,
      productid                                             AS product_id,
      --recognition
      revenuerecognitionrulename                            AS revenue_recognition_rule_name,
      revreccode                                            AS revenue_recognition_code,
      revrectriggercondition                                AS revenue_recognition_trigger_condition,
      -- info
      effectivestartdate                                    AS effective_start_date,
      effectiveenddate                                      AS effective_end_date,
      date_trunc('month', effectivestartdate)::DATE         AS effective_start_month,
      date_trunc('month', effectiveenddate)::DATE           AS effective_end_month,
      enddatecondition                                      AS end_date_condition,
      mrr,
      quantity                                              AS quantity,
      tcv,
      uom                                                   AS unit_of_measure,
      accountid                                             AS account_id,
      accountingcode                                        AS accounting_code,
      applydiscountto                                       AS apply_discount_to,
      billcycleday                                          AS bill_cycle_day,
      billcycletype                                         AS bill_cycle_type,
      billingperiod                                         AS billing_period,
      billingperiodalignment                                AS billing_period_alignment,
      chargedthroughdate                                    AS charged_through_date,
      chargemodel                                           AS charge_model,
      chargenumber                                          AS rate_plan_charge_number,
      chargetype                                            AS charge_type,
      description                                           AS description,
      discountlevel                                         AS discount_level,
      dmrc                                                  AS delta_mrc, -- delta monthly recurring charge
      dtcv                                                  AS delta_tcv, -- delta total contract value
      islastsegment                                         AS is_last_segment,
      listpricebase                                         AS list_price_base,
      --numberofperiods                                       AS number_of_periods,
      overagecalculationoption                              AS overage_calculation_option,
      overageunusedunitscreditoption                        AS overage_unused_units_credit_option,
      processedthroughdate                                  AS processed_through_date,
      segment                                               AS segment,
      specificbillingperiod                                 AS specific_billing_period,
      specificenddate                                       AS specific_end_date,
      triggerdate                                           AS trigger_date,
      triggerevent                                          AS trigger_event,
      uptoperiods                                           AS up_to_period,
      uptoperiodstype                                       AS up_to_periods_type,
      version                                               AS version,
      --ext1, ext2, ext3, ... ext13
      --metadata
      createdbyid                                           AS created_by_id,
      createddate                                           AS created_date,
      updatedbyid                                           AS updated_by_id,
      updateddate                                           AS updated_date,
      deleted                                               AS is_deleted
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora.zuora_account_source as
-- depends_on: "PREP".seed_finance.zuora_excluded_accounts
WITH source AS (
    SELECT *
    FROM "RAW".zuora_stitch.account
), renamed AS(
    SELECT
      id                                                     AS account_id,
      -- keys
      communicationprofileid                                 AS communication_profile_id,
      nullif("PREP".preparation.id15to18(crmid), '')          AS crm_id,
      defaultpaymentmethodid                                 AS default_payment_method_id,
      invoicetemplateid                                      AS invoice_template_id,
      parentid                                               AS parent_id,
      soldtocontactid                                        AS sold_to_contact_id,
      billtocontactid                                        AS bill_to_contact_id,
      taxexemptcertificateid                                 AS tax_exempt_certificate_id,
      taxexemptcertificatetype                               AS tax_exempt_certificate_type,
      -- account info
      accountnumber                                          AS account_number,
      name                                                   AS account_name,
      notes                                                  AS account_notes,
      purchaseordernumber                                    AS purchase_order_number,
      accountcode__c                                         AS sfdc_account_code,
      status,
      entity__c                                              AS sfdc_entity,
      autopay                                                AS auto_pay,
      balance                                                AS balance,
      creditbalance                                          AS credit_balance,
      billcycleday                                           AS bill_cycle_day,
      currency                                               AS currency,
      conversionrate__c                                      AS sfdc_conversion_rate,
      paymentterm                                            AS payment_term,
      allowinvoiceedit                                       AS allow_invoice_edit,
      batch,
      invoicedeliveryprefsemail                              AS invoice_delivery_prefs_email,
      invoicedeliveryprefsprint                              AS invoice_delivery_prefs_print,
      paymentgateway                                         AS payment_gateway,
      customerservicerepname                                 AS customer_service_rep_name,
      salesrepname                                           AS sales_rep_name,
      additionalemailaddresses                               AS additional_email_addresses,
      --billtocontact                   as bill_to_contact,
      parent__c                                              AS sfdc_parent,
      sspchannel__c                                          AS ssp_channel,
      porequired__c                                          AS po_required,
      -- financial info
      lastinvoicedate                                        AS last_invoice_date,
      -- metadata
      createdbyid                                            AS created_by_id,
      createddate                                            AS created_date,
      updatedbyid                                            AS updated_by_id,
      updateddate                                            AS updated_date,
      deleted                                                AS is_deleted
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora.zuora_subscription_source as
-- depends_on: "PREP".seed_finance.zuora_excluded_accounts
WITH source AS (
    SELECT *
    FROM "RAW".zuora_stitch.subscription
), renamed AS (
    SELECT
      id                                          AS subscription_id,
      subscriptionversionamendmentid              AS amendment_id,
      name                                        AS subscription_name,
        trim(
        lower(
            regexp_replace(
                regexp_replace(
                    regexp_replace(
                        name
                    , '\\s+\\|{2}\\s+', '|')
                , '[ ]{2,}', ' ')
            , '[^A-Za-z0-9|]', '-')
            )
        )                 AS subscription_name_slugify,
      nullif(gitlabnamespacename__c, '')          AS namespace_name,
      --keys
      accountid                                   AS account_id,
      creatoraccountid                            AS creator_account_id,
      creatorinvoiceownerid                       AS creator_invoice_owner_id,
      invoiceownerid                              AS invoice_owner_id,
      nullif(opportunityid__c, '')                AS sfdc_opportunity_id,
      nullif(opportunityname__qt, '')             AS crm_opportunity_name,
      nullif(originalid, '')                      AS original_id,
      nullif(previoussubscriptionid, '')          AS previous_subscription_id,
      nullif(recurlyid__c, '')                    AS sfdc_recurly_id,
      cpqbundlejsonid__qt                         AS cpq_bundle_json_id,
      nullif(gitlabnamespaceid__c, '')            AS namespace_id,
      -- info
      status                                      AS subscription_status,
      autorenew                                   AS auto_renew_native_hist,
      autorenew__c                                AS auto_renew_customerdot_hist,
      version                                     AS version,
      termtype                                    AS term_type,
      notes                                       AS notes,
      isinvoiceseparate                           AS is_invoice_separate,
      currentterm                                 AS current_term,
      currenttermperiodtype                       AS current_term_period_type,
      endcustomerdetails__c                       AS sfdc_end_customer_details,
      eoastarterbronzeofferaccepted__c            AS eoa_starter_bronze_offer_accepted,
      turnoncloudlicensing__c                     AS turn_on_cloud_licensing,
      -- turnonusagepingrequiredmetrics__c           AS turn_on_usage_ping_required_metrics,
      turnonoperationalmetrics__c                 AS turn_on_operational_metrics,
      contractoperationalmetrics__c               AS contract_operational_metrics,
      multiyeardealsubscriptionlinkage__c         AS multi_year_deal_subscription_linkage,
      rampid                                      AS ramp_id,
      --key_dates
      cancelleddate                               AS cancelled_date,
      contractacceptancedate                      AS contract_acceptance_date,
      contracteffectivedate                       AS contract_effective_date,
      initialterm                                 AS initial_term,
      initialtermperiodtype                       AS initial_term_period_type,
      termenddate::DATE                           AS term_end_date,
      termstartdate::DATE                         AS term_start_date,
      subscriptionenddate::DATE                   AS subscription_end_date,
      subscriptionstartdate::DATE                 AS subscription_start_date,
      serviceactivationdate                       AS service_activiation_date,
      opportunityclosedate__qt                    AS opportunity_close_date,
      originalcreateddate                         AS original_created_date,
      --foreign synced info
      opportunityname__qt                         AS opportunity_name,
      purchase_order__c                           AS sfdc_purchase_order,
      --purchaseorder__c                            AS sfdc_purchase_order_,
      quotebusinesstype__qt                       AS quote_business_type,
      quotenumber__qt                             AS quote_number,
      quotetype__qt                               AS quote_type,
      --renewal info
      renewalsetting                              AS renewal_setting,
      renewal_subscription__c__c                  AS zuora_renewal_subscription_name,
      split(nullif(trim(
        lower(
            regexp_replace(
                regexp_replace(
                    regexp_replace(
                        renewal_subscription__c__c
                    , '\\s+\\|{2}\\s+', '|')
                , '[ ]{2,}', ' ')
            , '[^A-Za-z0-9|]', '-')
            )
        ), ''), '|')
                                                  AS zuora_renewal_subscription_name_slugify,
      renewalterm                                 AS renewal_term,
      renewaltermperiodtype                       AS renewal_term_period_type,
      exclude_from_renewal_report__c__c           AS exclude_from_renewal_report,
      contractautorenew__c                        AS contract_auto_renewal,
      turnonautorenew__c                          AS turn_on_auto_renewal,
      contractseatreconciliation__c               AS contract_seat_reconciliation,
      turnonseatreconciliation__c                 AS turn_on_seat_reconciliation,
      --metadata
      updatedbyid                                 AS updated_by_id,
      updateddate                                 AS updated_date,
      createdbyid                                 AS created_by_id,
      createddate                                 AS created_date,
      deleted                                     AS is_deleted,
      excludefromanalysis__c                      AS exclude_from_analysis
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora.zuora_booking_transaction_source as
WITH source AS (
  SELECT *
  FROM "RAW".zuora_stitch.bookingtransaction
),
renamed AS (
  SELECT
    -- primary key
    id                 AS booking_transaction_id,
    -- keys
    rateplanchargeid   AS rate_plan_charge_id,
    -- additive fields
    listprice             AS list_price
  FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora.zuora_rate_plan_source as
WITH source AS (
    SELECT *
    FROM "RAW".zuora_stitch.rateplan
), renamed AS(
    SELECT
      id                  AS rate_plan_id,
      name                AS rate_plan_name,
      --keys
      subscriptionid      AS subscription_id,
      productid           AS product_id,
      productrateplanid   AS product_rate_plan_id,
      -- info
      amendmentid         AS amendement_id,
      amendmenttype       AS amendement_type,
      --metadata
      updatedbyid         AS updated_by_id,
      updateddate         AS updated_date,
      createdbyid         AS created_by_id,
      createddate         AS created_date,
      deleted             AS is_deleted
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".driveload.driveload_lam_corrections_source as
WITH source AS (
    SELECT
      dim_parent_crm_account_id::VARCHAR                AS dim_parent_crm_account_id,
      parent_crm_account_sales_segment::VARCHAR         AS dim_parent_crm_account_sales_segment,
      dev_count::FLOAT                                  AS dev_count,
      estimated_capped_lam::FLOAT                       AS estimated_capped_lam,
      valid_from::DATE                                  AS valid_from,
      valid_to_final_date::DATETIME                     AS valid_to
    FROM "RAW".driveload.lam_corrections
)
SELECT *
FROM source;

CREATE TABLE "PREP".sfdc.sfdc_event_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.event
), renamed AS (
    SELECT
      id                                     AS event_id,
    --keys
      accountid::VARCHAR                     AS account_id,
      ownerid::VARCHAR                       AS owner_id,
      whoid::VARCHAR                         AS lead_or_contact_id,
      whatid::VARCHAR                        AS what_id,
      related_to_id__c::VARCHAR              AS related_to_id,
      createdbyid::VARCHAR                   AS created_by_id,
      booked_by__c::VARCHAR                  AS booked_by_dim_crm_user_id,
    --info
      subject::VARCHAR                       AS event_subject,
      activity_source__c::VARCHAR            AS event_source,
      outreach_meeting_type__c::VARCHAR      AS outreach_meeting_type,
      type::VARCHAR                          AS event_type,
      eventsubtype::VARCHAR                  AS event_subtype,
      event_disposition__c::VARCHAR          AS event_disposition,
      description::VARCHAR                   AS event_description,
      booked_by_employee_number__c::VARCHAR  AS booked_by_employee_number,
      sa_activity_type__c::VARCHAR           AS sa_activity_type,
      showas::VARCHAR                        AS event_show_as,
      assigned_to_role__c::VARCHAR           AS assigned_to_role,
      csm_activity_type__c::VARCHAR          AS csm_activity_type,
      customer_interaction_sentiment__c::VARCHAR
                                             AS customer_interaction_sentiment,
      google_doc_link__c::VARCHAR            AS google_doc_link,
      comments__c::VARCHAR                   AS comments,
      qualified_convo_or_meeting__c::VARCHAR AS qualified_convo_or_meeting,
    --Event Relations Info
      related_to_account__c::VARCHAR         AS related_account_id,
      related_to_account_name__c::VARCHAR    AS related_account_name,
      related_to_lead__c::VARCHAR            AS related_lead_id,
      related_to_opportunity__c::VARCHAR     AS related_opportunity_id,
      related_to_contact__c::VARCHAR         AS related_contact_id,
    --Dates and Datetimes
      startdatetime::TIMESTAMP               AS event_start_date_time,
      reminderdatetime::TIMESTAMP            AS reminder_date_time,
      enddatetime::TIMESTAMP                 AS event_end_date_time,
      activitydate::DATE                     AS event_date,
      activitydatetime::DATE                 AS event_date_time,
      createddate::TIMESTAMP                 AS created_at,
      enddate::TIMESTAMP                     AS event_end_date,
    --Event Flags
      isalldayevent::BOOLEAN                 AS is_all_day_event,
      isarchived::BOOLEAN                    AS is_archived,
      ischild::BOOLEAN                       AS is_child_event,
      isgroupevent::BOOLEAN                  AS is_group_event,
      isprivate::BOOLEAN                     AS is_private_event,
      isrecurrence::BOOLEAN                  AS is_recurrence,
      isreminderset::BOOLEAN                 AS has_reminder_set,
      is_answered__c::FLOAT                  AS is_answered,
      is_correct_contact__c::FLOAT           AS is_correct_contact,
      meeting_cancelled__c::BOOLEAN          AS is_meeting_canceled,
      close_task__c::BOOLEAN                 AS is_closed_event,
      CASE
    WHEN contains(subject, 'Microsite Program')
      THEN 'Microsite Program'
    WHEN contains(subject, 'Free Trial Program')
      THEN 'Free Trial Program'
    WHEN trim(subject) = 'GitLab Dedicated Landing Pages'
      THEN 'GitLab Dedicated Landing Pages'
    WHEN trim(subject) = 'Partner Concierge Program'
      THEN 'Partner Concierge Program'
    ELSE NULL
  END
                                             AS partner_marketing_task_subject,
    --Recurrence Info
      recurrenceactivityid::VARCHAR          AS event_recurrence_activity_id,
      recurrencedayofweekmask::VARCHAR       AS event_recurrence_day_of_week,
      recurrencedayofmonth::VARCHAR          AS event_recurrence_day_of_month,
      recurrenceenddateonly::TIMESTAMP       AS event_recurrence_end_date,
      recurrenceinstance::VARCHAR            AS event_recurrence_instance,
      recurrenceinterval::VARCHAR            AS event_recurrence_interval,
      recurrencemonthofyear::VARCHAR         AS event_recurrence_month_of_year,
      recurrencestartdatetime::TIMESTAMP     AS event_recurrence_start_date_time,
      recurrencetimezonesidkey::VARCHAR      AS event_recurrence_timezone_key,
      recurrencetype::VARCHAR                AS event_recurrence_type,
      isrecurrence2exclusion::BOOLEAN        AS is_recurrence_2_exclusion,
      isrecurrence2::BOOLEAN                 AS is_recurrence_2,
      isrecurrence2exception::BOOLEAN        AS is_recurrence_2_exception,
      -- metadata
      lastmodifiedbyid                       AS last_modified_id,
      lastmodifieddate                       AS last_modified_date,
      systemmodstamp,
      isdeleted::BOOLEAN                     AS is_deleted
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_opportunity_contact_role_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.opportunitycontactrole
), renamed AS (
    SELECT
      -- keys
      id               AS opportunity_contact_role_id,
      contactid        AS contact_id,
      opportunityid    AS opportunity_id,
      createdbyid      AS created_by_id,
      lastmodifiedbyid AS last_modified_by_id,
      -- info
      role             AS contact_role,
      isprimary        AS is_primary_contact,
      createddate      AS created_date,
      lastmodifieddate AS last_modified_date
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_zqu_quote_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.zqu__quote__c
), renamed AS (
    SELECT
      id::VARCHAR                                            AS zqu_quote_id,
      quote_id_18__c::VARCHAR                                AS quote_id_18,
      quote_id__c::VARCHAR                                   AS quote_id,
      account_id__c::VARCHAR                                 AS account_id,
      opportunity_id__c::VARCHAR                             AS opportunity_id,
      invoice_number__c::VARCHAR                             AS invoice_number,
      admin_primary_backfill__c::BOOLEAN                     AS admin_primary_backfill,
      approval_stage_fmt__c::VARCHAR                         AS approval_stage_fmt,
      approval_stage__c::VARCHAR                             AS approval_stage,
      asm__c::VARCHAR                                        AS asm,
      bill_to_address_1__c::VARCHAR                          AS bill_to_address_1,
      bill_to_address_2__c::VARCHAR                          AS bill_to_address_2,
      bill_to_contact_updated__c::BOOLEAN                    AS bill_to_contact_updated,
      bill_to_country__c::VARCHAR                            AS bill_to_country,
      bill_to_email_address__c::VARCHAR                      AS bill_to_email_address,
      bill_to_phone__c::VARCHAR                              AS bill_to_phone,
      calculated_discount__c::FLOAT                          AS calculated_discount,
      charge_summary_sub_total__c::FLOAT                     AS charge_summary_sub_total,
      click_through_eula_contract_language__c::VARCHAR       AS click_through_eula_contract_language,
      delta_arr__c::FLOAT                                    AS delta_arr,
      distributor__c::VARCHAR                                AS distributor,
      gitlab_privacy_url__c::VARCHAR                         AS gitlab_privacy_url,
      has_githost_cb__c::BOOLEAN                             AS has_githost_cb,
      has_invoice_owner__c::FLOAT                            AS has_invoice_owner,
      invoice_paid__c::BOOLEAN                               AS invoice_paid,
      key_assumptions__c::VARCHAR                            AS key_assumptions,
      mailing_street__c::VARCHAR                             AS mailing_street,
      name::VARCHAR                                          AS zqu_quote_name,
      nrv_roll_up__c::FLOAT                                  AS nrv_roll_up,
      opportunity_amount__c::FLOAT                           AS opportunity_amount,
      opportunity_stage__c::VARCHAR                          AS opportunity_stage,
      quote_amendment_last_modified_date__c::TIMESTAMP_TZ    AS quote_amendment_last_modified_date,
      quote_opportunity_amount_match__c::VARCHAR             AS quote_opportunity_amount_match,
      quote_rateplan_last_updated_time__c::TIMESTAMP_TZ      AS quote_rateplan_last_updated_time,
      ra_use_primary_quote__c::BOOLEAN                       AS ra_use_primary_quote,
      required_approvals_from_vp_of_sales_rd__c::VARCHAR     AS required_approvals_from_vp_of_sales_rd,
      resellerbilltostateprovince__c::VARCHAR                AS reseller_bill_to_state_province,
      bill_to_country_code__c::VARCHAR                       AS bill_to_country_code,
      bill_to_postal_code__c::VARCHAR                        AS bill_to_postal_code,
      clickthrougheularequired__c::VARCHAR                   AS click_through_eula_required,
      createdbyfirstname__c::VARCHAR                         AS created_by_first_name,
      invoice_owner_account_type__c::VARCHAR                 AS invoice_owner_account_type,
      invoice_owner_vat_id__c::VARCHAR                       AS invoice_owner_vat_id,
      invoice_paid_date__c::TIMESTAMP_TZ                     AS invoice_paid_date,
      max_premium_discount_2__c::FLOAT                       AS max_premium_discount_2,
      mrr_rollup__c::FLOAT                                   AS mrr_rollup,
      partner_registered__c::VARCHAR                         AS partner_registered,
      professional_services_amount__c::FLOAT                 AS professional_services_amount,
      bill_to_city__c::VARCHAR                               AS bill_to_city,
      bill_to_contact_info_updated__c::VARCHAR               AS bill_to_contact_info_updated,
      bill_to_initial_source__c::VARCHAR                     AS bill_to_initial_source,
      bill_to_street__c::VARCHAR                             AS bill_to_street,
      count_of_rate_plans__c::FLOAT                          AS count_of_rate_plans,
      createddate::TIMESTAMP_TZ                              AS created_date,
      entity_bank_information__c::VARCHAR                    AS entity_bank_information,
      invoiceownerpaymentterms__c::FLOAT                     AS invoice_owner_payment_terms,
      license_amount_v2__c::FLOAT                            AS license_amount_v2,
      partner_assisted__c::VARCHAR                           AS partner_assisted,
      previous_renewal_term__c::FLOAT                        AS previous_renewal_term,
      quote_end_date__c::TIMESTAMP_TZ                        AS quote_end_date,
      quote_entity_beneficiary_information__c::VARCHAR       AS quote_entity_beneficiary_information,
      quote_entity_legal_name__c::VARCHAR                    AS quote_entity_legal_name,
      resellerbilltocity__c::VARCHAR                         AS reseller_bill_to_city,
      bill_to_name__c::VARCHAR                               AS bill_to_name,
      bill_to_state__c::VARCHAR                              AS bill_to_state,
      change_sold_to_contact__c::VARCHAR                     AS change_sold_to_contact,
      createdbyemailaddress__c::VARCHAR                      AS created_by_email_address,
      entity_contact_information__c::VARCHAR                 AS entity_contact_information,
      has_githost__c::FLOAT                                  AS has_githost,
      invoice_amount__c::FLOAT                               AS invoice_amount,
      new_sub_on_addon_renewal_approved__c::BOOLEAN          AS new_sub_on_addon_renewal_approved,
      non_standard_contract_terms__c::VARCHAR                AS non_standard_contract_terms,
      ownerid::VARCHAR                                       AS owner_id,
      partner_fulfillment__c::VARCHAR                        AS partner_fulfillment,
      po_required__c::BOOLEAN                                AS po_required,
      professional_services_description__c::VARCHAR          AS professional_services_description,
      proserv_exception_approval_notes__c::VARCHAR           AS professional_services_exception_approval_notes,
      pub_sec_owner__c::VARCHAR                              AS pub_sec_owner,
      quote_amendment_count__c::FLOAT                        AS quote_amendment_count,
      quote_entity_contact_information__c::VARCHAR           AS quote_entity_contact_information,
      rate_plans__c::VARCHAR                                 AS rate_plans,
      rd__c::VARCHAR                                         AS rd,
      recordtypeid::VARCHAR                                  AS record_type_id,
      required_approvals_from_asm__c::VARCHAR                AS required_approvals_from_asm,
      invoice_owner_country__c::VARCHAR                      AS invoice_owner_country,
      purchase_order__c::VARCHAR                             AS purchase_order,
      required_approvals_from_ceo__c::VARCHAR                AS required_approvals_from_ceo,
      entity_beneficiary_information__c::VARCHAR             AS entity_beneficiary_information,
      highest_quote_rate_plan__c::VARCHAR                    AS highest_quote_rate_plan,
      quote_entity_override__c::BOOLEAN                      AS quote_entity_override,
      renewal_mrr__c::FLOAT                                  AS renewal_mrr,
      quote_tcv__c::FLOAT                                    AS quote_tcv,
      required_approvals_from_cfo__c::VARCHAR                AS required_approvals_from_cfo,
      required_approvals_from_cs__c::VARCHAR                 AS required_approvals_from_cs,
      required_approvals_from_legal__c::VARCHAR              AS required_approvals_from_legal,
      required_approvals_from_vp_of_channel__c::VARCHAR      AS required_approvals_from_vp_of_channel,
      required_approvals_from_enterprise_vp__c::VARCHAR      AS required_approvals_from_enterprise_vp,
      requires_deal_desk_review__c::BOOLEAN                  AS requires_deal_desk_review,
      resellerbilltocountry__c::VARCHAR                      AS reseller_bill_to_country,
      resellerbilltopostalcode__c::VARCHAR                   AS reseller_bill_to_postal_code,
      resellerbilltostreet__c::VARCHAR                       AS reseller_bill_to_street,
      click_through_eula_test__c::VARCHAR                    AS click_through_eula_test,
      gitlab_terms_url__c::VARCHAR                           AS gitlab_terms_url,
      invoice_owner_account_id__c::VARCHAR                   AS invoice_owner_account_id,
      project_scope__c::VARCHAR                              AS project_scope,
      quote_entity_bank_information__c::VARCHAR              AS quote_entity_bank_information,
      quote_entity_check_remittance__c::VARCHAR              AS quote_entity_check_remittance,
      quote_entity__c::VARCHAR                               AS quote_entity,
      required_approvals_from_cro__c::VARCHAR                AS required_approvals_from_cro,
      resellerbilltoemail__c::VARCHAR                        AS reseller_bill_to_email,
      resellerbilltofirstname__c::VARCHAR                    AS reseller_bill_to_first_name,
      resellerbilltolastname__c::VARCHAR                     AS reseller_bill_to_last_name,
      resellerbilltophone__c::VARCHAR                        AS reseller_bill_to_phone,
      reseller_bill_to__c::VARCHAR                           AS reseller_bill_to,
      license_amount__c::FLOAT                               AS license_amount,
      required_approvals_from_rd__c::VARCHAR                 AS required_approvals_from_rd,
      reseller_account_name__c::VARCHAR                      AS reseller_account_name,
      reseller_po_status__c::VARCHAR                         AS reseller_po_status,
      saas_addendum_existing_agreement_lang__c::VARCHAR      AS saas_addendum_existing_agreement_lang,
      send_githost_email_to_support__c::BOOLEAN              AS send_githost_email_to_support,
      sold_to_address_2__c::VARCHAR                          AS sold_to_address_2,
      sold_to_city__c::VARCHAR                               AS sold_to_city,
      sold_to_contact_updated__c::BOOLEAN                    AS sold_to_contact_updated,
      sold_to_country_code__c::VARCHAR                       AS sold_to_country_code,
      sold_to_country__c::VARCHAR                            AS sold_to_country,
      sold_to_email_address__c::VARCHAR                      AS sold_to_email_address,
      sold_to_email__c::VARCHAR                              AS sold_to_email,
      sold_to_name__c::VARCHAR                               AS sold_to_name,
      sold_to_phone__c::VARCHAR                              AS sold_to_phone,
      sold_to_state__c::VARCHAR                              AS sold_to_state,
      start_date_vs_close_date__c::FLOAT                     AS start_date_vs_close_date,
      submitter_comments__c::VARCHAR                         AS submitter_comments,
      subscription_agreement_effective_date_ca__c::VARCHAR   AS subscription_agreement_effective_date_ca,
      subscription_agreement_effective_date__c::TIMESTAMP_TZ AS subscription_agreement_effective_date,
      tax_exempt_checkbox__c::BOOLEAN                        AS tax_exempt_checkbox,
      tcv_including_discount__c::FLOAT                       AS tcv_including_discount,
      total_partner_discount__c::FLOAT                       AS total_partner_discount,
      trigger_workflow__c::BOOLEAN                           AS trigger_workflow,
      true_up_amount__c::FLOAT                               AS true_up_amount,
      vat_tax_id__c::VARCHAR                                 AS vat_tax_id,
      vp_of_sales__c::VARCHAR                                AS vp_of_sales,
      wip_arr_iacv_delta__c::FLOAT                           AS wip_arr_iacv_delta,
      x_trigger_quote_approval_check__c::BOOLEAN             AS x_trigger_quote_approval_check,
      reseller_type__c::VARCHAR                              AS reseller_type,
      sold_to_address_1__c::VARCHAR                          AS sold_to_address_1,
      sold_to_contact_is_null__c::BOOLEAN                    AS sold_to_contact_is_null,
      sold_to_initial_source__c::VARCHAR                     AS sold_to_initial_source,
      sold_to_postal_code__c::VARCHAR                        AS sold_to_postal_code,
      subscription_agreement_id__c::VARCHAR                  AS subscription_agreement_id,
      systemmodstamp::TIMESTAMP_TZ                           AS system_mod_stamp,
      task_schedule__c::VARCHAR                              AS task_schedule,
      watch_quote__c::BOOLEAN                                AS watch_quote,
      sold_to_contact_info_updated__c::VARCHAR               AS sold_to_contact_info_updated,
      subscription_agreement_amendments__c::VARCHAR          AS subscription_agreement_amendments,
      zqu__account__c::VARCHAR                               AS zqu__account,
      zqu__applycreditbalance__c::BOOLEAN                    AS zqu__apply_credit_balance,
      zqu__billingbatch__c::VARCHAR                          AS zqu__billing_batch,
      zqu__billingmethod__c::VARCHAR                         AS zqu__billing_method,
      zqu__billtocontact__c::VARCHAR                         AS zqu__bill_to_contact,
      zqu__cancellationdate__c::TIMESTAMP_TZ                 AS zqu_cancellation_date,
      zqu__cancellationeffectivedate__c::VARCHAR             AS zqu__cancellation_effective_date,
      zqu__certificate_id__c::VARCHAR                        AS zqu__certificate_id,
      zqu__certificate_type__c::VARCHAR                      AS zqu__certificate_type,
      zqu__company_code__c::VARCHAR                          AS zqu__company_code,
      zqu__currency__c::VARCHAR                              AS zqu__currency,
      zqu__deltatcv__c::FLOAT                                AS zqu__delta_tcv,
      zqu__electronicpaymentmethodid__c::VARCHAR             AS zqu__electronic_payment_method_id,
      zqu__existingproductsstored__c::BOOLEAN                AS zqu__existing_products_stored,
      zqu__existsubscriptionid__c::VARCHAR                   AS zqu__exist_subscription_id,
      zqu__generateinvoice__c::BOOLEAN                       AS zqu__generate_invoice,
      zqu__hidden_subscription_name__c::VARCHAR              AS zqu__hidden_subscription_name,
      zqu__initialterm__c::FLOAT                             AS zqu__initial_term,
      zqu__invoiceownerid__c::VARCHAR                        AS zqu__invoice_owner_id,
      zqu__invoiceownername__c::VARCHAR                      AS zqu__invoice_owner_name,
      zqu__amendment_name__c::VARCHAR                        AS zqu__amendment_name,
      zqu__approvalstatus__c::VARCHAR                        AS zqu__approval_status,
      zqu__calculate_quote_metrics_through__c::VARCHAR       AS zqu__calculate_quote_metrics_through,
      zqu__communicationprofile__c::VARCHAR                  AS zqu__communication_profile,
      zqu__description__c::VARCHAR                           AS zqu__description,
      zqu__invoiceprocessingoption__c::VARCHAR               AS zqu__invoice_processing_option,
      zqu__invoiceseparately__c::BOOLEAN                     AS zqu__invoice_separately,
      zqu__is_charge_expired__c::BOOLEAN                     AS zqu__is_charge_expired,
      zqu__is_parent_quote__c::BOOLEAN                       AS zqu__is_parent_quote,
      zqu__mrr__c::FLOAT                                     AS zqu__mrr,
      zqu__number__c::VARCHAR                                AS zqu__number,
      zqu__paymentgateway__c::VARCHAR                        AS zqu__payment_gateway,
      zqu__paymentmethod__c::VARCHAR                         AS zqu__payment_method,
      zqu__paymentterm__c::VARCHAR                           AS zqu__payment_term,
      zqu__previewed_delta_tcv__c::FLOAT                     AS zqu__previewed_delta_tcv,
      zqu__previewed_mrr__c::FLOAT                           AS zqu__previewed_mrr,
      zqu__previewed_subtotal__c::FLOAT                      AS zqu__previewed_subtotal,
      zqu__primary__c::BOOLEAN                               AS zqu__primary,
      zqu__processpayment__c::BOOLEAN                        AS zqu__process_payment,
      zqu__quotebusinesstype__c::VARCHAR                     AS zqu__quote_business_type,
      zqu__quotetemplate__c::VARCHAR                         AS zqu__quote_template,
      zqu__recordreadonly__c::BOOLEAN                        AS zqu__record_read_only,
      zqu__renewaltermperiodtype__c::VARCHAR                 AS zqu__renewal_term_period_type,
      zqu__soldtocontact__c::VARCHAR                         AS zqu__sold_to_contact,
      zqu__status__c::VARCHAR                                AS zqu__status,
      zqu__subscriptiontermenddate__c::TIMESTAMP_TZ          AS zqu__subscription_term_end_date,
      zqu__subscriptiontermstartdate__c::TIMESTAMP_TZ        AS zqu__subscription_term_start_date,
      zqu__subscriptiontype__c::VARCHAR                      AS zqu__subscriptiontype,
      zqu__subscription_name__c::VARCHAR                     AS zqu__subscription_name,
      zqu__subscription_term_type__c::VARCHAR                AS zqu__subscription_term_type,
      zqu__taxexempteffectivedate__c::TIMESTAMP_TZ           AS zqu__tax_exempt_effective_date,
      zqu__taxexemptexpirationdate__c::TIMESTAMP_TZ          AS zqu__tax_exempt_expiration_date,
      zqu__terms__c::VARCHAR                                 AS zqu__terms,
      zqu__zuoraentityid__c::VARCHAR                         AS zqu__zuora_entity_id,
      zqu__zuora_account_number__c::VARCHAR                  AS zqu__zuora_account_number,
      zqu__autorenew__c::BOOLEAN                             AS zqu__auto_renew,
      zqu__deltamrr__c::FLOAT                                AS zqu__delta_mrr,
      zqu__initialtermperiodtype__c::VARCHAR                 AS zqu__initial_term_period_type,
      zqu__invoicetemplate__c::VARCHAR                       AS zqu__invoice_template,
      zqu__issuing_jurisdiction__c::VARCHAR                  AS zqu__issuing_jurisdiction,
      zqu__opportunity__c::VARCHAR                           AS zqu__opportunity,
      zqu__previewed_delta_mrr__c::FLOAT                     AS zqu__previewed_delta_mrr,
      zqu__previewed_discount__c::FLOAT                      AS zqu__previewed_discount,
      zqu__previewed_tax__c::FLOAT                           AS zqu__previewed_tax,
      zqu__previewed_tcv__c::FLOAT                           AS zqu__previewed_tcv,
      zqu__previewed_total__c::FLOAT                         AS zqu__previewed_total,
      zqu__renewalsetting__c::VARCHAR                        AS zqu__renewal_setting,
      zqu__renewalterm__c::FLOAT                             AS zqu__renewal_term,
      zqu__startdate__c::TIMESTAMP_TZ                        AS zqu__start_date,
      zqu__subscriptionversion__c::FLOAT                     AS zqu__subscription_version,
      zqu__tax_exempt_description__c::VARCHAR                AS zqu__tax_exempt_description,
      zqu__tax_exempt__c::VARCHAR                            AS zqu__tax_exempt,
      zqu__tcv__c::FLOAT                                     AS zqu__tcv,
      zqu__termstartdate__c::TIMESTAMP_TZ                    AS zqu__term_start_date,
      zqu__total__c::FLOAT                                   AS zqu__total,
      zqu__validuntil__c::TIMESTAMP_TZ                       AS zqu__valid_until,
      zqu__vat_id__c::VARCHAR                                AS zqu__vat_id,
      zqu__zuorasubscriptionid__c::VARCHAR                   AS zqu__zuora_subscription_id,
      zqu__billcycleday__c::VARCHAR                          AS zqu__bill_cycle_day,
      zqu__billingcycleday__c::VARCHAR                       AS zqu__billing_cycle_day,
      zqu__zuoraaccountid__c::VARCHAR                        AS zqu__zuora_account_id,
      --metadata
      createdbyid::VARCHAR                                   AS created_by_id,
      createdbylastname__c::VARCHAR                          AS created_by_lastname,
      createdbyphone__c::VARCHAR                             AS created_by_phone,
      lastmodifiedbyid::VARCHAR                              AS last_modified_by_id,
      lastactivitydate::TIMESTAMP_TZ                         AS last_activity_date,
      lastmodifieddate::TIMESTAMP_TZ                         AS last_modified_date,
      NULL                           AS last_viewed_date,
      NULL                       AS last_referenced_date,
      isdeleted::BOOLEAN                                     AS is_deleted,
      _sdc_extracted_at::TIMESTAMP_TZ                        AS sdc_extracted_at,
      _sdc_received_at::TIMESTAMP_TZ                         AS sdc_received_at,
      _sdc_batched_at::TIMESTAMP_TZ                          AS sdc_batched_at,
      _sdc_sequence::NUMBER                                  AS sdc_sequence,
      _sdc_table_version::NUMBER                             AS sdc_table_version
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_opportunity_stage_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.opportunitystage
), renamed AS (
    SELECT
      id                   AS sfdc_id,
      masterlabel          AS primary_label,
      defaultprobability   AS default_probability,
      forecastcategoryname AS forecast_category_name,
      isactive             AS is_active,
      isclosed             AS is_closed,
      iswon                AS is_won
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_record_type_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.recordtype
), renamed AS (
    SELECT
         id                AS record_type_id,
         developername     AS record_type_name,
        --keys
         businessprocessid AS business_process_id,
        --info
         name              AS record_type_label,
         description       AS record_type_description,
         sobjecttype       AS record_type_modifying_object_type
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sfdc.sfdc_task_source as
WITH source AS (
    SELECT *
    FROM "RAW".salesforce_v2_stitch.task
), renamed AS(
    SELECT
      id                                        AS task_id,
      --keys
      accountid                                 AS account_id,
      ownerid                                   AS owner_id,
      assigned_employee_number__c               AS assigned_employee_number,
      whoid                                     AS lead_or_contact_id,
      whatid                                    AS account_or_opportunity_id,
      recordtypeid                              AS record_type_id,
      related_to_account_name__c                AS related_to_account_name,
      related_to_lead__c                        AS related_lead_id,
      related_to_contact__c                     AS related_contact_id,
      related_to_opportunity__c                 AS related_opportunity_id,
      related_to_account__c                     AS related_account_id,
      related_to_id__c                          AS related_to_id,
      -- Task infomation
      comments__c                               AS comments,
      description                               AS full_comments,
      subject                                   AS task_subject,
      CASE
    WHEN contains(subject, 'Microsite Program')
      THEN 'Microsite Program'
    WHEN contains(subject, 'Free Trial Program')
      THEN 'Free Trial Program'
    WHEN trim(subject) = 'GitLab Dedicated Landing Pages'
      THEN 'GitLab Dedicated Landing Pages'
    WHEN trim(subject) = 'Partner Concierge Program'
      THEN 'Partner Concierge Program'
    ELSE NULL
  END
                                                AS partner_marketing_task_subject,
      activitydate::DATE                        AS task_date,
      createddate::TIMESTAMP                    AS task_created_at,
      createdbyid                               AS task_created_by_id,
      status                                    AS task_status,
      tasksubtype                               AS task_subtype,
      type                                      AS task_type,
      priority                                  AS task_priority,
      close_task__c                             AS close_task,
      completeddatetime::TIMESTAMP              AS task_completed_at,
      isclosed                                  AS is_closed,
      isdeleted                                 AS is_deleted,
      isarchived                                AS is_archived,
      ishighpriority                            AS is_high_priority,
      persona_functions__c                      AS persona_functions,
      persona_levels__c                         AS persona_levels,
      outreach_meeting_type__c                  AS outreach_meeting_type,
      customer_interaction_sentiment__c         AS customer_interaction_sentiment,
      assigned_to_role__c                       AS task_owner_role,
      dascoopcomposer__is_created_by_groove__c  AS is_created_by_groove,
      -- Activity infromation
      activity_disposition__c                   AS activity_disposition,
      activity_source__c                        AS activity_source,
      csm_activity_type__c                      AS csm_activity_type,
      sa_activity_type__c                       AS sa_activity_type,
      gs_activity_type__c                       AS gs_activity_type,
      gs_sentiment__c                           AS gs_sentiment,
      gs_meeting_type__c                        AS gs_meeting_type,
      gs_exec_sponsor_present__c                AS is_gs_exec_sponsor_present,
      meeting_cancelled__c                      AS is_meeting_cancelled,
      products_positioned__c                    AS products_positioned,
      -- Call information
      calltype                                  AS call_type,
      call_purpose__c                           AS call_purpose,
      calldisposition                           AS call_disposition,
      calldurationinseconds                     AS call_duration_in_seconds,
      call_recording__c                         AS call_recording,
      is_answered__c                            AS is_answered,
      is_correct_contact__c                     AS is_correct_contact,
      -- Reminder information
      isreminderset                             AS is_reminder_set,
      reminderdatetime::TIMESTAMP               AS reminder_at,
      -- Recurrence information
      isrecurrence                              AS is_recurrence,
      recurrenceinterval                        AS task_recurrence_interval,
      recurrenceinstance                        AS task_recurrence_instance,
      recurrencetype                            AS task_recurrence_type,
      recurrenceactivityid                      AS task_recurrence_activity_id,
      recurrenceenddateonly::DATE               AS task_recurrence_end_date,
      recurrencedayofweekmask                   AS task_recurrence_day_of_week,
      recurrencetimezonesidkey                  AS task_recurrence_timezone,
      recurrencestartdateonly::DATE             AS task_recurrence_start_date,
      recurrencedayofmonth                      AS task_recurrence_day_of_month,
      recurrencemonthofyear                     AS task_recurrence_month,
      -- Sequence information
      name_of_active_sequence__c                AS active_sequence_name,
      sequence_step_number__c                   AS sequence_step_number,
      -- Docs/Video Conferencing
      google_doc_link__c                        AS google_doc_link,
      zoom_app__ics_sequence__c                 AS zoom_app_ics_sequence,
      zoom_app__use_personal_zoom_meeting_id__c AS zoom_app_use_personal_zoom_meeting_id,
      zoom_app__join_before_host__c             AS zoom_app_join_before_host,
      zoom_app__make_it_zoom_meeting__c         AS zoom_app_make_it_zoom_meeting,
      affectlayer__chorus_call_id__c            AS chorus_call_id,
      -- Counts
      whatcount                                 AS account_or_opportunity_count,
      whocount                                  AS lead_or_contact_count,
      -- metadata
      lastmodifiedbyid                          AS last_modified_id,
      lastmodifieddate::TIMESTAMP               AS last_modified_at,
      systemmodstamp::TIMESTAMP                 AS system_modified_at
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora_query_api.zuora_query_api_order_action_rate_plan_source as
WITH source AS (
    SELECT *
    FROM "RAW".zuora_query_api.orderactionrateplan
), renamed AS (
    SELECT
      "Id"::TEXT                                                           AS order_action_rate_plan_id,
      "OrderActionId"::TEXT                                                AS order_action_id,
      "RatePlanId"::TEXT                                                   AS rate_plan_id,
      "DELETED"::TEXT                                                      AS deleted,
      "CreatedById"::TEXT                                                  AS created_by_id,
      TO_TIMESTAMP(CONVERT_TIMEZONE('UTC', "CreatedDate"))::TIMESTAMP      AS created_date,
      "UpdatedById"::TEXT                                                  AS updated_by_id,
      TO_TIMESTAMP(CONVERT_TIMEZONE('UTC',"UpdatedDate"))::TIMESTAMP       AS updated_date,
      TO_TIMESTAMP_NTZ(CAST(_uploaded_at AS INT))::TIMESTAMP               AS uploaded_at
    FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora_query_api.zuora_query_api_charge_contractual_value_source as
WITH source AS (
  SELECT *
  FROM "RAW".zuora_query_api.chargecontractualvalue
),
renamed AS (
  SELECT
    "ID"::TEXT                                                    AS charge_contractual_value_id,
    "AMOUNT"::FLOAT                                                AS amount,
    "createdBy"::TEXT                                             AS created_by,
    TO_TIMESTAMP(CONVERT_TIMEZONE('UTC', "createdOn"))::TIMESTAMP AS created_on,
    "CURRENCY"::TEXT                                              AS currency,
    "ELP"::FLOAT                                                 AS elp,
    "elpTaxAmount"::FLOAT                                        AS elp_tax_amount,
    "estimatedEvergreenEndDate"::TEXT                             AS estimated_ever_green_end_date,
    "ratePlanChargeId"::TEXT                                      AS rate_plan_charge_id,
    "REASON"::TEXT                                                AS reason,
    "subscriptionId"::TEXT                                        AS subscription_id,
    "taxAmount"::TEXT                                             AS tax_amount,
    "updatedBy"::TEXT                                             AS updated_by,
    TO_TIMESTAMP(CONVERT_TIMEZONE('UTC', "updatedOn"))::TIMESTAMP AS updated_on,
    TO_TIMESTAMP_NTZ("_UPLOADED_AT"::INT)::TIMESTAMP              AS uploaded_at
  FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora_revenue.zuora_revenue_manual_journal_entry_source as
WITH zuora_revenue_manual_journal_entry AS (
    SELECT *
    FROM "RAW".zuora_revenue.bi3_mje
    QUALIFY ROW_NUMBER() OVER (PARTITION BY je_line_id ORDER BY incr_updt_dt DESC) = 1
), renamed AS (
    SELECT
      je_head_id::VARCHAR                           AS manual_journal_entry_header_id,
      je_head_name::VARCHAR                         AS manual_journal_entry_header_name,
      je_head_desc::VARCHAR                         AS manual_journal_entry_header_description,
      je_head_cat_code::VARCHAR                     AS manual_journal_entry_header_category_code,
      je_head_ex_rate_type::VARCHAR                 AS manual_journal_entry_header_exchange_rate_type,
      hash_total::VARCHAR                           AS hash_total,
      sob_id::VARCHAR                               AS set_of_books_id,
      sob_name::VARCHAR                             AS set_of_books_name,
      fn_cur::VARCHAR                               AS functional_currency,
      -- Data received from Zuora in YYYYMM format, formatted to YYYYMMDD in the below.
      CONCAT(rvsl_prd_id::VARCHAR,'01')             AS reversal_period_id,
      CONCAT(prd_id::VARCHAR,'01')                  AS period_id,
      je_head_atr1::VARCHAR                         AS manual_journal_entry_header_attribute_1,
      je_head_atr2::VARCHAR                         AS manual_journal_entry_header_attribute_2,
      je_head_atr3::VARCHAR                         AS manual_journal_entry_header_attribute_3,
      je_head_atr4::VARCHAR                         AS manual_journal_entry_header_attribute_4,
      je_head_atr5::VARCHAR                         AS manual_journal_entry_header_attribute_5,
      CONCAT(je_head_crtd_prd_id::VARCHAR,'01')     AS manual_journal_entry_header_created_period_id,
      je_line_id::VARCHAR                           AS manual_journal_entry_line_id,
      activity_type::VARCHAR                        AS activity_type,
      curr::VARCHAR                                 AS currency,
      dr_cc_id::VARCHAR                             AS debit_account_code_combination_id,
      cr_cc_id::VARCHAR                             AS credit_account_code_combination_id,
      ex_rate_date::DATETIME                        AS exchange_rate_date,
      ex_rate::VARCHAR                              AS exchange_rate,
      g_ex_rate::VARCHAR                            AS reporting_currency_exchange_rate,
      amount::FLOAT                                 AS amount,
      func_amount::FLOAT                            AS funcional_currency_amount,
      start_date::DATETIME                          AS manual_journal_entry_line_start_date,
      end_date::DATETIME                            AS manual_journal_entry_line_end_date,
      reason_code::VARCHAR                          AS reason_code,
      description::VARCHAR                          AS manual_journal_entry_line_description,
      comments::VARCHAR                             AS manual_journal_entry_line_comments,
      dr_segment1::VARCHAR                          AS debit_segment_1,
      dr_segment2::VARCHAR                          AS debit_segment_2,
      dr_segment3::VARCHAR                          AS debit_segment_3,
      dr_segment4::VARCHAR                          AS debit_segment_4,
      dr_segment5::VARCHAR                          AS debit_segment_5,
      dr_segment6::VARCHAR                          AS debit_segment_6,
      dr_segment7::VARCHAR                          AS debit_segment_7,
      dr_segment8::VARCHAR                          AS debit_segment_8,
      dr_segment9::VARCHAR                          AS debit_segment_9,
      dr_segment10::VARCHAR                         AS debit_segment_10,
      cr_segment1::VARCHAR                          AS credit_segment_1,
      cr_segment2::VARCHAR                          AS credit_segment_2,
      cr_segment3::VARCHAR                          AS credit_segment_3,
      cr_segment4::VARCHAR                          AS credit_segment_4,
      cr_segment5::VARCHAR                          AS credit_segment_5,
      cr_segment6::VARCHAR                          AS credit_segment_6,
      cr_segment7::VARCHAR                          AS credit_segment_7,
      cr_segment8::VARCHAR                          AS credit_segment_8,
      cr_segment9::VARCHAR                          AS credit_segment_9,
      cr_segment10::VARCHAR                         AS credit_segment_10,
      reference1::VARCHAR                           AS manual_journal_entry_reference_1,
      reference2::VARCHAR                           AS manual_journal_entry_reference_2,
      reference3::VARCHAR                           AS manual_journal_entry_reference_3,
      reference4::VARCHAR                           AS manual_journal_entry_reference_4,
      reference5::VARCHAR                           AS manual_journal_entry_reference_5,
      reference6::VARCHAR                           AS manual_journal_entry_reference_6,
      reference7::VARCHAR                           AS manual_journal_entry_reference_7,
      reference8::VARCHAR                           AS manual_journal_entry_reference_8,
      reference9::VARCHAR                           AS manual_journal_entry_reference_9,
      reference10::VARCHAR                          AS manual_journal_entry_reference_10,
      reference11::VARCHAR                          AS manual_journal_entry_reference_11,
      reference12::VARCHAR                          AS manual_journal_entry_reference_12,
      reference13::VARCHAR                          AS manual_journal_entry_reference_13,
      reference14::VARCHAR                          AS manual_journal_entry_reference_14,
      reference15::VARCHAR                          AS manual_journal_entry_reference_15,
      sec_atr_val::VARCHAR                          AS security_attribute_value,
      book_id::VARCHAR                              AS book_id,
      client_id::VARCHAR                            AS client_id,
      je_head_crtd_by::VARCHAR                      AS manual_journal_entry_header_created_by,
      je_head_crtd_dt::DATETIME                     AS manual_journal_entry_header_created_date,
      je_head_updt_by::VARCHAR                      AS manual_journal_entry_header_updated_by,
      je_head_updt_dt::DATETIME                     AS manual_journal_entry_header_updated_date,
      je_line_crtd_by::VARCHAR                      AS manual_journal_entry_line_created_by,
      je_line_crtd_dt::DATETIME                     AS manual_journal_entry_line_created_date,
      je_line_updt_by::VARCHAR                      AS manual_journal_entry_line_updated_by,
      je_line_updt_dt::DATETIME                     AS manual_journal_entry_line_updated_date,
      incr_updt_dt::DATETIME                        AS incremental_update_date,
      je_status_flag::VARCHAR                       AS manual_journal_entry_header_status,
      rev_rec_type_flag::VARCHAR                    AS is_revenue_recognition_type,
      je_type_flag::VARCHAR                         AS manual_journal_entry_header_type,
      summary_flag::VARCHAR                         AS is_summary,
      manual_reversal_flag::VARCHAR                 AS is_manual_reversal,
      reversal_status_flag::VARCHAR                 AS reversal_status,
      approval_status_flag::VARCHAR                 AS approval_status,
      reversal_approval_status_flag::VARCHAR        AS reversal_approval_status,
      rev_rec_type::VARCHAR                         AS revenue_recognition_type,
      error_msg::VARCHAR                            AS error_message,
      dr_activity_type::VARCHAR                     AS debit_activity_type,
      cr_activity_type::VARCHAR                     AS credit_activity_type,
      active_flag::VARCHAR                          AS is_active,
      appr_name::VARCHAR                            AS approver_name,
      rc_id::VARCHAR                                AS revenue_contract_id,
      doc_line_id::VARCHAR                          AS doc_line_id,
      rc_line_id::VARCHAR                           AS revenue_contract_line_id,
      cst_or_vc_type::VARCHAR                       AS is_cost_or_vairable_consideration,
      type_name::VARCHAR                            AS manual_journal_entry_line_type,
      dt_frmt::VARCHAR                              AS date_format,
      opn_int_flag::VARCHAR                         AS is_open_interface,
      auto_appr_flag::VARCHAR                       AS is_auto_approved,
      unbilled_flag::VARCHAR                        AS is_unbilled
    FROM zuora_revenue_manual_journal_entry
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".zuora_revenue.zuora_revenue_revenue_contract_line_source as
WITH zuora_revenue_revenue_contract_line AS (
    SELECT *
    FROM "RAW".zuora_revenue.bi3_rc_lns
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY incr_updt_dt DESC) = 1
), renamed AS (
    SELECT
      id::VARCHAR                                       AS revenue_contract_line_id,
      rc_id::VARCHAR                                    AS revenue_contract_id,
      type::VARCHAR                                     AS revenue_contract_line_type,
      rc_pob_id::VARCHAR                                AS revenue_contract_performance_obligation_id,
      ext_sll_prc::FLOAT                                AS extended_selling_price,
      ext_fv_prc::FLOAT                                 AS extended_fair_value_price,
      def_amt::FLOAT                                    AS deferred_amount,
      rec_amt::FLOAT                                    AS recognized_amount,
      cv_amt::FLOAT                                     AS carve_amount,
      alctbl_xt_prc::VARCHAR                            AS allocatable_price,
      alctd_xt_prc::VARCHAR                             AS allocated_price,
      bld_def_amt::VARCHAR                              AS billed_deferred_amount,
      bld_rec_amt::VARCHAR                              AS billed_recognized_amount,
      cstmr_nm::VARCHAR                                 AS customer_name,
      so_num::VARCHAR                                   AS sales_order_number,
      so_book_date::DATETIME                            AS sales_order_book_date,
      so_line_num::VARCHAR                              AS sales_order_line_number,
      so_line_id::VARCHAR                               AS sales_order_line_id,
      item_num::VARCHAR                                 AS item_number,
      bndl_cnfg_id::VARCHAR                             AS bundle_configuration_id,
      ord_qty::VARCHAR                                  AS order_quantity,
      inv_qty::VARCHAR                                  AS invoice_quantity,
      ret_qty::VARCHAR                                  AS return_quantity,
      start_date::VARCHAR                               AS revenue_start_date,
      end_date::VARCHAR                                 AS revenue_end_date,
      duration::VARCHAR                                 AS revenue_amortization_duration,
      ext_lst_prc::VARCHAR                              AS list_price,
      batch_id::VARCHAR                                 AS revenue_contract_batch_id,
      curr::VARCHAR                                     AS transactional_currency,
      f_cur::VARCHAR                                    AS functional_currency,
      f_ex_rate::VARCHAR                                AS functional_currency_exchage_rate,
      g_ex_rate::VARCHAR                                AS reporting_currency_exchange_rate,
      disc_amt::FLOAT                                   AS discount_amount,
      disc_pct::FLOAT                                   AS discount_percent,
      alctbl_fn_xt_prc::VARCHAR                         AS allocatable_functional_price,
      ref_doc_line_id::VARCHAR                          AS reference_document_line_id,
      lt_def_acnt::VARCHAR                              AS long_term_deferred_account,
      fv_grp_id::VARCHAR                                AS fair_value_group_id,
      fv_pct::FLOAT                                     AS fair_value_percent,
      fv_prc::FLOAT                                     AS fair_value_price,
      fv_type::VARCHAR                                  AS fair_value_type,
      err_msg::VARCHAR                                  AS error_message,
      def_segments::VARCHAR                             AS deferred_accounting_segment,
      rev_segments::VARCHAR                             AS revenue_accounting_segment,
      atr1::VARCHAR                                     AS revenue_contract_line_attribute_1,
      atr2::VARCHAR                                     AS revenue_contract_line_attribute_2,
      atr3::VARCHAR                                     AS revenue_contract_line_attribute_3,
      atr4::VARCHAR                                     AS revenue_contract_line_attribute_4,
      atr5::VARCHAR                                     AS revenue_contract_line_attribute_5,
      atr6::VARCHAR                                     AS revenue_contract_line_attribute_6,
      atr7::VARCHAR                                     AS revenue_contract_line_attribute_7,
      atr8::VARCHAR                                     AS revenue_contract_line_attribute_8,
      atr9::VARCHAR                                     AS revenue_contract_line_attribute_9,
      atr10::VARCHAR                                    AS revenue_contract_line_attribute_10,
      atr11::VARCHAR                                    AS revenue_contract_line_attribute_11,
      atr12::VARCHAR                                    AS revenue_contract_line_attribute_12,
      atr13::VARCHAR                                    AS revenue_contract_line_attribute_13,
      atr14::VARCHAR                                    AS revenue_contract_line_attribute_14,
      atr15::VARCHAR                                    AS revenue_contract_line_attribute_15,
      atr16::VARCHAR                                    AS revenue_contract_line_attribute_16,
      atr17::VARCHAR                                    AS revenue_contract_line_attribute_17,
      atr18::VARCHAR                                    AS revenue_contract_line_attribute_18,
      atr19::VARCHAR                                    AS revenue_contract_line_attribute_19,
      atr20::VARCHAR                                    AS revenue_contract_line_attribute_20,
      atr21::VARCHAR                                    AS revenue_contract_line_attribute_21,
      atr22::VARCHAR                                    AS revenue_contract_line_attribute_22,
      atr23::VARCHAR                                    AS revenue_contract_line_attribute_23,
      atr24::VARCHAR                                    AS revenue_contract_line_attribute_24,
      atr25::VARCHAR                                    AS revenue_contract_line_attribute_25,
      atr26::VARCHAR                                    AS revenue_contract_line_attribute_26,
      atr27::VARCHAR                                    AS revenue_contract_line_attribute_27,
      atr28::VARCHAR                                    AS revenue_contract_line_attribute_28,
      atr29::VARCHAR                                    AS revenue_contract_line_attribute_29,
      atr30::VARCHAR                                    AS revenue_contract_line_attribute_30,
      atr31::VARCHAR                                    AS revenue_contract_line_attribute_31,
      atr32::VARCHAR                                    AS revenue_contract_line_attribute_32,
      atr33::VARCHAR                                    AS revenue_contract_line_attribute_33,
      atr34::VARCHAR                                    AS revenue_contract_line_attribute_34,
      atr35::VARCHAR                                    AS revenue_contract_line_attribute_35,
      atr36::VARCHAR                                    AS revenue_contract_line_attribute_36,
      atr37::VARCHAR                                    AS revenue_contract_line_attribute_37,
      atr38::VARCHAR                                    AS revenue_contract_line_attribute_38,
      atr39::VARCHAR                                    AS revenue_contract_line_attribute_39,
      atr40::VARCHAR                                    AS revenue_contract_line_attribute_40,
      atr41::VARCHAR                                    AS revenue_contract_line_attribute_41,
      atr42::VARCHAR                                    AS revenue_contract_line_attribute_42,
      atr43::VARCHAR                                    AS revenue_contract_line_attribute_43,
      atr44::VARCHAR                                    AS revenue_contract_line_attribute_44,
      atr45::VARCHAR                                    AS revenue_contract_line_attribute_45,
      atr46::VARCHAR                                    AS revenue_contract_line_attribute_46,
      atr47::VARCHAR                                    AS revenue_contract_line_attribute_47,
      atr48::VARCHAR                                    AS revenue_contract_line_attribute_48,
      atr49::VARCHAR                                    AS revenue_contract_line_attribute_49,
      atr50::VARCHAR                                    AS revenue_contract_line_attribute_50,
      atr51::VARCHAR                                    AS revenue_contract_line_attribute_51,
      atr52::VARCHAR                                    AS revenue_contract_line_attribute_52,
      atr53::VARCHAR                                    AS revenue_contract_line_attribute_53,
      atr54::VARCHAR                                    AS revenue_contract_line_attribute_54,
      atr55::VARCHAR                                    AS revenue_contract_line_attribute_55,
      atr56::VARCHAR                                    AS revenue_contract_line_attribute_56,
      atr57::VARCHAR                                    AS revenue_contract_line_attribute_57,
      atr58::VARCHAR                                    AS revenue_contract_line_attribute_58,
      atr59::VARCHAR                                    AS revenue_contract_line_attribute_59,
      atr60::VARCHAR                                    AS revenue_contract_line_attribute_60,
      num1::VARCHAR                                     AS revenue_contract_line_number_1,
      num2::VARCHAR                                     AS revenue_contract_line_number_2,
      num3::VARCHAR                                     AS revenue_contract_line_number_3,
      num4::VARCHAR                                     AS revenue_contract_line_number_4,
      num5::VARCHAR                                     AS revenue_contract_line_number_5,
      num6::VARCHAR                                     AS revenue_contract_line_number_6,
      num7::VARCHAR                                     AS revenue_contract_line_number_7,
      num8::VARCHAR                                     AS revenue_contract_line_number_8,
      num9::VARCHAR                                     AS revenue_contract_line_number_9,
      num10::VARCHAR                                    AS revenue_contract_line_number_10,
      num11::VARCHAR                                    AS revenue_contract_line_number_11,
      num12::VARCHAR                                    AS revenue_contract_line_number_12,
      num13::VARCHAR                                    AS revenue_contract_line_number_13,
      num14::VARCHAR                                    AS revenue_contract_line_number_14,
      num15::VARCHAR                                    AS revenue_contract_line_number_15,
      date1::DATETIME                                   AS revenue_contract_line_date_1,
      date2::DATETIME                                   AS revenue_contract_line_date_2,
      date3::DATETIME                                   AS revenue_contract_line_date_3,
      date4::DATETIME                                   AS revenue_contract_line_date_4,
      date5::DATETIME                                   AS revenue_contract_line_date_5,
      model_id::VARCHAR                                 AS model_id,
      unschd_adj::VARCHAR                               AS unscheduled_adjustment,
      posted_pct::FLOAT                                 AS posted_percent,
      rel_pct::FLOAT                                    AS released_percent,
      term::VARCHAR                                     AS revenue_contract_line_term,
      vc_type_id::VARCHAR                               AS variable_consideration_type_id,
      po_num::VARCHAR                                   AS purchase_order_number,
      quote_num::VARCHAR                                AS quote_number,
      schd_ship_dt::DATETIME                            AS scheduled_ship_date,
      ship_dt::DATETIME                                 AS ship_date,
      sales_rep_name::VARCHAR                           AS sales_representative_name,
      cust_num::VARCHAR                                 AS customer_number,
      prod_ctgry::VARCHAR                               AS product_category,
      prod_class::VARCHAR                               AS product_class,
      prod_fmly::VARCHAR                                AS product_family,
      prod_ln::VARCHAR                                  AS product_line,
      business_unit::VARCHAR                            AS business_unit,
      ct_mod_date::DATETIME                             AS contract_modification_date,
      ct_num::VARCHAR                                   AS contract_number,
      ct_date::DATETIME                                 AS contract_date,
      ct_line_num::VARCHAR                              AS contract_line_number,
      ct_line_id::VARCHAR                               AS contract_line_id,
      cum_cv_amt::VARCHAR                               AS cumulative_carve_amount,
      cum_alctd_amt::VARCHAR                            AS cumulative_allocated_amount,
      comments::VARCHAR                                 AS revenue_contract_line_comment,
      prnt_ln_id::VARCHAR                               AS parent_revenue_contract_line_id,
      prnt_ref_ln_id::VARCHAR                           AS parent_reference_line_id,
      cv_eligible_flag::VARCHAR                         AS is_carve_eligible,
      return_flag::VARCHAR                              AS is_return,
      within_fv_range_flag::VARCHAR                     AS is_within_fair_value_range,
      stated_flag::VARCHAR                              AS is_stated,
      standalone_flag::VARCHAR                          AS is_standalone,
      disc_adj_flag::VARCHAR                            AS is_discount_adjustment,
      approval_status_flag::VARCHAR                     AS approval_status,
      fv_eligible_flag::VARCHAR                         AS is_fair_value_eligible,
      manual_fv_flag::VARCHAR                           AS is_manual_fair_value,
      rssp_calc_type::VARCHAR                           AS rssp_calculation_type,
      unbill_flag::VARCHAR                              AS is_unbilled,
      manual_crtd_flag::VARCHAR                         AS is_manual_created,
      vc_clearing_flag::VARCHAR                         AS is_variable_consideration_clearing,
      mje_line_flag::VARCHAR                            AS is_manual_journal_entry_line,
      update_or_insert_flag::VARCHAR                    AS is_update_or_insert,
      delink_lvl_flag::VARCHAR                          AS delink_level,
      CONCAT(crtd_prd_id::VARCHAR, '01')                AS created_period_id,
      book_id::VARCHAR                                  AS book_id,
      client_id::VARCHAR                                AS client_id,
      sec_atr_val::VARCHAR                              AS security_attribute_value,
      crtd_by::VARCHAR                                  AS revenue_contract_line_created_by,
      crtd_dt::DATETIME                                 AS revenue_contract_line_created_date,
      updt_by::VARCHAR                                  AS revenue_contract_line_updated_by,
      updt_dt::DATETIME                                 AS revenue_contract_line_updated_date,
      incr_updt_dt::VARCHAR                             AS incremental_update_date,
      offset_segments::VARCHAR                          AS offset_accounting_segment,
      sob_id::VARCHAR                                   AS set_of_books_id,
      fv_date::DATETIME                                 AS fair_value_date,
      orig_fv_date::DATETIME                            AS original_fair_value_date,
      vc_amt::FLOAT                                     AS varaiable_consideration_amount,
      unit_sell_prc::FLOAT                              AS unit_sell_price,
      unit_list_prc::FLOAT                              AS unit_list_price,
      impair_retrieve_amt::FLOAT                        AS impairment_retrieve_amount,
      bndl_prnt_id::VARCHAR                             AS bundle_parent_id,
      company_code::VARCHAR                             AS company_code,
      cancel_flag::VARCHAR                              AS is_cancelled,
      below_fv_prc::FLOAT                               AS below_fair_value_price,
      above_fv_prc::FLOAT                               AS above_fair_value_price,
      fv_tmpl_id::VARCHAR                               AS fair_value_template_id,
      fv_expr::VARCHAR                                  AS fair_value_expiration,
      below_mid_pct::FLOAT                              AS below_mid_percent,
      above_mid_pct::FLOAT                              AS above_mid_percent,
      ic_account::VARCHAR                               AS intercompany_account,
      ca_account::VARCHAR                               AS contract_asset_account,
      ci_account::VARCHAR                               AS ci_account,
      al_account::VARCHAR                               AS al_account,
      ar_account::VARCHAR                               AS ar_account,
      contra_ar_acct::VARCHAR                           AS contra_ar_account,
      payables_acct::VARCHAR                            AS payables_account,
      lt_def_adj_acct::VARCHAR                          AS long_term_deferred_adjustment_account,
      ub_liab_acct::VARCHAR                             AS ub_liability_account,
      alloc_rec_hold_flag::VARCHAR                      AS is_allocation_recognition_hold,
      alloc_schd_hold_flag::VARCHAR                     AS is_allocation_schedule_hold,
      alloc_trtmt_flag::VARCHAR                         AS is_allocation_treatment,
      contra_entry_flag::VARCHAR                        AS is_contra_entry,
      conv_wfall_flag::VARCHAR                          AS is_conv_waterfall,
      ct_mod_code_flag::VARCHAR                         AS contract_modification_code,
      impairment_type_flag::VARCHAR                     AS impairment_type,
      previous_fv_flag::VARCHAR                         AS previous_fair_value,
      reclass_flag::VARCHAR                             AS is_reclass,
      rev_rec_hold_flag::VARCHAR                        AS is_revenue_recognition_hold,
      rev_schd_hold_flag::VARCHAR                       AS is_revenue_schedule_hold,
      rev_schd_flag::VARCHAR                            AS is_revevnue_schedule,
      trnsfr_hold_flag::VARCHAR                         AS is_transfer_hold,
      alloc_delink_flag::VARCHAR                        AS is_allocation_delink,
      cancel_by_rord_flag::VARCHAR                      AS is_canceled_by_reduction_order,
      cv_eligible_lvl2_flag::VARCHAR                    AS is_level_2_carve_eligible,
      rc_level_range_flag::VARCHAR                      AS revenue_contract_level,
      rssp_fail_flag::VARCHAR                           AS is_rssp_failed,
      vc_eligible_flag::VARCHAR                         AS is_variable_consideration_eligible,
      ghost_line_flag::VARCHAR                          AS is_ghost_line,
      initial_ct_flag::VARCHAR                          AS is_initial_contract,
      material_rights_flag::VARCHAR                     AS is_material_rights,
      ramp_up_flag::VARCHAR                             AS is_ramp_up,
      lt_def_cogs_acct::VARCHAR                         AS long_term_deferred_cogs_account,
      lt_ca_account::VARCHAR                            AS long_term_ca_account,
      tot_bgd_hrs::FLOAT                                AS total_budget_hours,
      tot_bgd_cst::FLOAT                                AS total_budget_cost,
      fcst_date::DATETIME                               AS forecast_date,
      link_identifier::VARCHAR                          AS link_identifier,
      prod_life_term::VARCHAR                           AS product_life_term,
      ramp_identifier::VARCHAR                          AS ramp_identifier,
      mr_line_id::VARCHAR                               AS material_rights_line_id,
      price_point::VARCHAR                              AS price_point,
      tp_pct_ssp::FLOAT                                 AS transaction_price_ssp_percent,
      orig_quantity::FLOAT                              AS original_quantity,
      split_ref_doc_line_id::VARCHAR                    AS split_reference_document_line_id,
      overstated_amt::FLOAT                             AS overstated_amount,
      ovst_lst_amt::FLOAT                               AS overstated_list_price_amount,
      ref_rc_id::VARCHAR                                AS reference_revenue_contract_id,
      split_flag::VARCHAR                               AS is_split,
      ord_orch_flag::VARCHAR                            AS is_ord_orch,
      upd_model_id_flag::VARCHAR                        AS updated_model_id,
      new_pob_flag::VARCHAR                             AS is_new_performance_obligation,
      mr_org_prc::FLOAT                                 AS material_rights_org_percent,
      action_type::VARCHAR                              AS action_type,
      pord_def_amt::FLOAT                               AS pord_deferred_amount,
      pord_rec_amt::FLOAT                               AS pord_recognized_amount,
      net_sll_prc::FLOAT                                AS net_sell_price,
      net_lst_prc::FLOAT                                AS net_list_price,
      full_cm_flag::VARCHAR                             AS full_cm_flag,
      skip_ct_mod_flag::VARCHAR                         AS is_skip_contract_modification,
      step1_rc_level_range_flag::VARCHAR                AS step_1_revenue_contract_level_range,
      impairment_exception_flag::VARCHAR                AS is_impairment_exception,
      pros_defer_flag::VARCHAR                          AS is_pros_deferred,
      manual_so_flag::VARCHAR                           AS is_manual_sales_order,
      zero_doll_rec_flag::VARCHAR                       AS is_zero_dollar_recognition,
      cv_amt_imprtmt::VARCHAR                           AS carve_amount_imprtmt,
      full_pord_disc_flag::VARCHAR                      AS is_full_pord_discount,
      zero_dollar_rord_flag::VARCHAR                    AS is_zero_dollar_reduction_order,
      subscrp_id::VARCHAR                               AS subscription_id,
      subscrp_name::VARCHAR                             AS subscription_name,
      subscrp_version::VARCHAR                          AS subscription_version,
      subscrp_start_date::DATETIME                      AS subscription_start_date,
      subscrp_end_date::DATETIME                        AS subscription_end_date,
      subscrp_owner::VARCHAR                            AS subscription_owner,
      invoice_owner::VARCHAR                            AS invoice_owner,
      rp_id::VARCHAR                                    AS rate_plan_id,
      rp_name::VARCHAR                                  AS rate_plan_name,
      rpc_num::VARCHAR                                  AS rate_plan_charge_number,
      rpc_name::VARCHAR                                 AS rate_plan_charge_name,
      rpc_version::VARCHAR                              AS rate_plan_charge_version,
      rpc_model::VARCHAR                                AS rate_plan_charge_model,
      rpc_type::VARCHAR                                 AS rate_plan_charge_type,
      rpc_trigger_evt::VARCHAR                          AS rate_plan_charge_trigger_event,
      rpc_segment::VARCHAR                              AS rate_plan_charge_segment,
      rpc_id::VARCHAR                                   AS rate_plan_charge_id,
      orig_rpc_id::VARCHAR                              AS original_rate_plan_charge_id,
      subscrp_type::VARCHAR                             AS subscription_type,
      charge_level::VARCHAR                             AS charge_level,
      amendment_id::VARCHAR                             AS amendment_id,
      amendment_type::VARCHAR                           AS amendment_type,
      amendment_reason::VARCHAR                         AS amendment_reason,
      order_id::VARCHAR                                 AS order_id,
      order_item_id::VARCHAR                            AS order_item_id,
      order_action_id::VARCHAR                          AS order_action_id,
      account_id::VARCHAR                               AS billing_account_id,
      product_id::VARCHAR                               AS product_id,
      product_rp_id::VARCHAR                            AS product_rate_plan_id,
      product_rpc_id::VARCHAR                           AS product_rate_plan_charge_id,
      charge_crtd_date::DATETIME                        AS charge_created_date,
      charge_last_updt_date::DATETIME                   AS charge_last_updated_date,
      bill_id::VARCHAR                                  AS revenue_contract_bill_id,
      bill_item_id::VARCHAR                             AS revenue_contract_bill_item_id,
      zbill_batch_id::VARCHAR                           AS zbilling_batch_id,
      ramp_deal_ref::VARCHAR                            AS ramp_deal_id,
      seq_num::VARCHAR                                  AS sequence_number,
      avg_prcing_mthd::VARCHAR                          AS average_pricing_method,
      prc_frmt::VARCHAR                                 AS percent_format,
      prnt_chrg_segment::VARCHAR                        AS parent_charge_segment,
      prnt_chrg_num::VARCHAR                            AS parent_charge_number,
      entity_id::VARCHAR                                AS entity_id,
      ssp_sll_prc::FLOAT                                AS ssp_sell_price,
      ssp_lst_prc::FLOAT                                AS ssp_list_price,
      subscrp_trm_st_dt::DATETIME                       AS subscription_term_start_date,
      subscrp_trm_end_dt::DATETIME                      AS subscription_term_end_date,
      subscrp_term_num::VARCHAR                         AS subscrp_term_number,
      old_sell_prc::FLOAT                               AS old_sell_price,
      rstrct_so_val_upd_flag::VARCHAR                   AS is_restricted_sales_order_value_update,
      zbilling_cmplte_flag::VARCHAR                     AS is_zbilling_complete,
      zbil_unschd_adj_flag::VARCHAR                     AS is_zbilling_unscheduled_adjustment,
      zbill_cancel_line_flag::VARCHAR                   AS is_zbillling_cancelled_line,
      non_distinct_pob_flag::VARCHAR                    AS is_non_distinct_performance_obligation,
      zbill_ctmod_rule_flag::VARCHAR                    AS is_zbilling_contract_modification_rule,
      sys_inv_exist_flag::VARCHAR                       AS is_system_inv_exist,
      zbill_manual_so_flag::VARCHAR                     AS is_zbillling_manual_sales_order,
      so_term_change_flag::VARCHAR                      AS is_sales_order_term_change,
      ramp_alloc_pct::FLOAT                             AS ramp_allocation_percent,
      ramp_alctbl_prc::FLOAT                            AS ramp_allocatable_percent,
      ramp_alctd_prc::FLOAT                             AS ramp_allocted_percent,
      ramp_cv_amt::FLOAT                                AS ramp_carve_amount,
      ramp_cum_cv_amt::FLOAT                            AS ramp_cumulative_carve_amount,
      ramp_cum_alctd_amt::FLOAT                         AS ramp_cumulative_allocated_amount,
      ovg_exist_flag::VARCHAR                           AS is_overage_exists,
      zbill_ramp_flag::VARCHAR                          AS is_zbilling_ramp,
      update_by_rord_flag::VARCHAR                      AS is_updated_by_reduction_order,
      unbilled_evergreen_flag::VARCHAR                  AS is_unbilled_evergreen,
      k2_batch_id::VARCHAR                              AS k2_batch_id,
      reason_code::VARCHAR                              AS reason_code,
      CONCAT(updt_prd_id::VARCHAR, '01')                AS revenue_contract_line_updated_period_id,
      ramp_id::VARCHAR                                  AS ramp_id,
      CONCAT(unbl_rvsl_prd::VARCHAR, '01')              AS unbilled_reversal_period,
      ramp_cv_chg_flag::VARCHAR                         AS is_ramp_carve,
      zero_flip_flag::VARCHAR                           AS is_zero_f,
      pros_decrse_prc_flag::VARCHAR                     AS is_pros_decrse_p,
      CONCAT(defer_prd_id::VARCHAR, '01')               AS deferred_period_id
    FROM zuora_revenue_revenue_contract_line
)
SELECT *
FROM renamed;

CREATE TABLE "PREP".sheetload.sheetload_sales_targets_source as
WITH source AS (
        SELECT *
        FROM "RAW".sheetload.sales_targets
), renamed AS (
        SELECT
          scenario::VARCHAR                                                         AS scenario,
          kpi_name::VARCHAR                                                         AS kpi_name,
          month::VARCHAR                                                            AS month,
          CASE sales_qualified_source
    WHEN  'BDR Generated'
      THEN 'SDR Generated'
    WHEN 'Channel Generated'
      THEN 'Partner Generated'
    ELSE sales_qualified_source
  END::VARCHAR  AS sales_qualified_source,
          alliance_partner::VARCHAR                                                 AS alliance_partner,
          partner_category::VARCHAR                                                 AS partner_category,
          order_type::VARCHAR                                                       AS order_type,
          area::VARCHAR                                                             AS area,
          user_segment::VARCHAR                                                     AS user_segment,
          user_geo::VARCHAR                                                         AS user_geo,
          user_region::VARCHAR                                                      AS user_region,
          user_area::VARCHAR                                                        AS user_area,
          user_business_unit::VARCHAR                                               AS user_business_unit,
          user_role_name::VARCHAR                                                   AS user_role_name,
          role_level_1::VARCHAR                                                     AS role_level_1,
          role_level_2::VARCHAR                                                     AS role_level_2,
          role_level_3::VARCHAR                                                     AS role_level_3,
          role_level_4::VARCHAR                                                     AS role_level_4,
          role_level_5::VARCHAR                                                     AS role_level_5,
          TRY_TO_NUMBER(REPLACE(allocated_target, ',', ''), 38, 20)::FLOAT          AS allocated_target
        FROM source
)
        SELECT *
        FROM renamed
        UNION
        -- Added new logo KPI so it is easier to relate fct_sales_funnel_target_daily and fct_sales_funnel_actual
        -- This is because for the actual values there are two flags, one for Deals and another for New Logos
        -- Issue that introduced this methodology: https://gitlab.com/gitlab-data/analytics/-/issues/18838
        SELECT
          scenario,
          'New Logos' AS kpi_name,
          month,
          sales_qualified_source,
          alliance_partner,
          partner_category,
          order_type,
          area,
          user_segment,
          user_geo,
          user_region,
          user_area,
          user_business_unit,
          user_role_name,
          role_level_1,
          role_level_2,
          role_level_3,
          role_level_4,
          role_level_5,
          allocated_target
        FROM renamed
        WHERE kpi_name = 'Deals'
            AND order_type = '1. New - First Order';

CREATE TABLE "PREP".sheetload.sheetload_maxmind_countries_source as
WITH source AS (
    SELECT *
    FROM "RAW".sheetload.maxmind_countries
), parsed AS (
    SELECT
      geoname_id::NUMBER            AS geoname_id,
      locale_code::VARCHAR          AS locale_code,
      continent_code::VARCHAR       AS continent_code,
      continent_name::VARCHAR       AS continent_name,
      country_iso_code::VARCHAR     AS country_iso_code,
      country_name::VARCHAR         AS country_name,
      is_in_european_union::BOOLEAN AS is_in_european_union
    FROM source
)
SELECT *
FROM parsed;

CREATE TABLE "PREP".sheetload.sheetload_bizible_to_pathfactory_mapping_source as
WITH source AS (
        SELECT *
        FROM "RAW".sheetload.bizible_to_pathfactory_mapping
        )
        SELECT *
        FROM source;

CREATE TABLE "RAW".snapshots.sfdc_user_snapshots as
SELECT *
    FROM "RAW".salesforce_v2_stitch.user;

CREATE TABLE "PREP".sfdc.sfdc_opportunity_source as
/*
  ATTENTION: When a field is added to this live model, add it to the SFDC_OPPORTUNITY_SNAPSHOTS_SOURCE model to keep the live and snapshot models in alignment.
*/
WITH source AS (
  SELECT
    opportunity.*,
    CASE
      WHEN stagename = '0-Pending Acceptance' THEN x0_pending_acceptance_date__c
      WHEN stagename = '1-Discovery' THEN x1_discovery_date__c
      WHEN stagename = '2-Scoping' THEN x2_scoping_date__c
      WHEN stagename = '3-Technical Evaluation' THEN x3_technical_evaluation_date__c
      WHEN stagename = '4-Proposal' THEN x4_proposal_date__c
      WHEN stagename = '5-Negotiating' THEN x5_negotiating_date__c
      WHEN stagename = '6-Awaiting Signature' THEN x6_awaiting_signature_date__c
    END                                                                          AS calculation_days_in_stage_date,
    DATEDIFF(DAYS, calculation_days_in_stage_date::DATE, CURRENT_DATE::DATE) + 1 AS days_in_stage
  FROM "RAW".salesforce_v2_stitch.opportunity AS opportunity
),
renamed AS (
  SELECT
    -- keys
    accountid                                                                        AS account_id,
    id                                                                               AS opportunity_id,
    name                                                                             AS opportunity_name,
    ownerid                                                                          AS owner_id,
    -- logistical information
    isclosed                                                                         AS is_closed,
    iswon                                                                            AS is_won,
    valid_deal_count__c                                                              AS valid_deal_count,
    closedate                                                                        AS close_date,
    createddate                                                                      AS created_date,
    days_in_stage                                                                    AS days_in_stage,
    deployment_preference__c                                                         AS deployment_preference,
    sql_source__c                                                                    AS generated_source,
    leadsource                                                                       AS lead_source,
    merged_opportunity__c                                                            AS merged_opportunity_id,
    duplicate_opportunity__c                                                         AS duplicate_opportunity_id,
    contract_reset_opportunity__c                                                    AS contract_reset_opportunity_id,
    account_owner__c                                                                 AS account_owner,
    opportunity_owner__c                                                             AS opportunity_owner,
    manager_current__c                                                               AS opportunity_owner_manager,
    sales_market__c                                                                  AS opportunity_owner_department,
    sdr_lu__c                                                                        AS crm_sales_dev_rep_id,
    business_development_representative__c                                           AS crm_business_dev_rep_id,
    NULL                                                                             AS crm_business_dev_rep_id_lookup,
    NULL                                                                             AS opportunity_development_representative,
    sales_accepted_date__c                                                           AS sales_accepted_date,
    engagement_type__c                                                               AS sales_path,
    sales_qualified_date__c                                                          AS sales_qualified_date,
    iqm_submitted_by_role__c                                                         AS iqm_submitted_by_role,
    type                                                                             AS sales_type,
    type                                                                             AS subscription_type,
    CASE
      WHEN leadsource in ('CORE Check-Up','Free Registration')
        THEN 'Core'
      WHEN leadsource in ('GitLab Subscription Portal', 'Gitlab.com', 'GitLab.com', 'Trial - Gitlab.com', 'Trial - GitLab.com')
        THEN 'GitLab.com'
      WHEN leadsource in ('Education', 'OSS')
        THEN 'Marketing/Community'
      WHEN leadsource in ('CE Download', 'Demo', 'Drift', 'Email Request', 'Email Subscription', 'Gated Content - General', 'Gated Content - Report', 'Gated Content - Video'
                           , 'Gated Content - Whitepaper', 'Live Event', 'Newsletter', 'Request - Contact', 'Request - Professional Services', 'Request - Public Sector'
                           , 'Security Newsletter', 'Trial - Enterprise', 'Virtual Sponsorship', 'Web Chat', 'Web Direct', 'Web', 'Webcast')
        THEN 'Marketing/Inbound'
      WHEN leadsource in ('Advertisement', 'Conference', 'Field Event', 'Gong', 'Owned Event','UserGems Contact Tracking','UserGems - Meeting Assistant','UserGems - New Hires & Promotions')
        THEN 'Marketing/Outbound'
      WHEN leadsource in ('Clearbit', 'Datanyze','GovWin IQ', 'Leadware', 'LinkedIn', 'Prospecting - LeadIQ', 'Prospecting - General', 'Prospecting', 'SDR Generated')
        THEN 'Prospecting'
      WHEN leadsource in ('Employee Referral', 'External Referral', 'Partner', 'Word of mouth')
        THEN 'Referral'
      WHEN leadsource in ('AE Generated')
        THEN 'Sales'
      WHEN leadsource in ('DiscoverOrg')
        THEN 'DiscoverOrg'
      ELSE 'Other'
    END                               AS net_new_source_categories,
   CASE
      WHEN leadsource in ('CORE Check-Up', 'CE Download', 'CE Usage Ping','CE Version Check')
        THEN 'core'
      WHEN leadsource in ('Consultancy Request','Contact Request','Content','Demo','Drift','Education','EE Version Check','Email Request','Email Subscription','Enterprise Trial','Gated Content - eBook','Gated Content - General','Gated Content - Report','Gated Content - Video','Gated Content - Whitepaper','GitLab.com','MovingtoGitLab','Newsletter','OSS','Request - Community','Request - Contact','Request - Professional Services','Request - Public Sector','Security Newsletter','Startup Application','Web','Web Chat','White Paper','Trust Center')
        THEN 'inbound'
      WHEN leadsource in ('6sense', 'AE Generated', 'Clearbit','Datanyze','DiscoverOrg','Gemnasium','GitLab Hosted','Gitorious','gmail','Gong','GovWin IQ','Leadware','LinkedIn','Live Event','Prospecting','Prospecting - General','Prospecting - LeadIQ','SDR Generated','seamless.ai','UserGems Contact Tracking','UserGems - Meeting Assistant','UserGems - New Hires & Promotions','Zoominfo')
        THEN 'outbound'
      WHEN leadsource in ('Advertisement', 'Conference', 'Content Syndication', 'Executive Roundtable', 'Field Event', 'Owned Event','Promotion','Vendor Arranged Meetings','Virtual Sponsorship')
        THEN 'paid demand gen'
      WHEN leadsource in ('Purchased List')
        THEN 'purchased list'
      WHEN leadsource in ('Employee Referral', 'Event Partner', 'Existing Client', 'External Referral','Partner','Seminar - Partner','Word of mouth')
        THEN 'referral'
      WHEN leadsource in('Trial - Enterprise','Trial - GitLab.com')
        THEN 'trial'
      WHEN leadsource in ('Webcast','Webinar', 'CSM Webinar')
        THEN 'virtual event'
      WHEN leadsource in ('GitLab Subscription Portal','Web Direct')
        THEN 'web direct'
      ELSE 'Other'
    END                               AS source_buckets,
    stagename                                                                        AS stage_name,
    CASE
  WHEN deal_path__c = 'Channel' THEN 'Partner'
ELSE deal_path__c
END                                         AS deal_path,
    -- opportunity information
    acv_2__c                                                                         AS acv,
    amount                                                                           AS amount,
    IFF(acv_2__c >= 0, 1, 0)                                                         AS is_closed_deals, -- so that you can exclude closed deals that had negative impact
    competitors__c                                                                   AS competitors,
    critical_deal_flag__c                                                            AS critical_deal_flag,
    CASE WHEN arr_net__c < 5000 THEN '1 - Small (<5k)'
		WHEN arr_net__c < 25000 THEN '2 - Medium (5k - 25k)'
		WHEN arr_net__c < 100000 THEN '3 - Big (25k - 100k)'
		WHEN arr_net__c >= 100000 THEN '4 - Jumbo (>100k)'
	ELSE '5 - Unknown' END AS deal_size,
    forecastcategoryname                                                             AS forecast_category_name,
    incremental_acv_2__c                                                             AS forecasted_iacv,
    iacv_created_date__c                                                             AS iacv_created_date,
    incremental_acv__c                                                               AS incremental_acv,
    invoice_number__c                                                                AS invoice_number,
    is_refund_opportunity__c                                                         AS is_refund,
    is_downgrade_opportunity__c                                                      AS is_downgrade,
    swing_deal__c                                                                    AS is_swing_deal,
    is_edu_oss_opportunity__c                                                        AS is_edu_oss,
    is_ps_opportunity__c                                                             AS is_ps_opp,
    net_iacv__c                                                                      AS net_incremental_acv,
    campaignid                                                                       AS primary_campaign_source_id,
    probability                                                                      AS probability,
    professional_services_value__c                                                   AS professional_services_value,
    edu_services_value__c                                                            AS edu_services_value,
    investment_services_value__c                                                     AS investment_services_value,
    push_counter__c                                                                  AS pushed_count,
    reason_for_lost__c                                                               AS reason_for_loss,
    reason_for_lost_details__c                                                       AS reason_for_loss_details,
    refund_iacv__c                                                                   AS refund_iacv,
    downgrade_iacv__c                                                                AS downgrade_iacv,
    renewal_acv__c                                                                   AS renewal_acv,
    renewal_amount__c                                                                AS renewal_amount,
    CASE sql_source__c
    WHEN  'BDR Generated'
      THEN 'SDR Generated'
    WHEN 'Channel Generated'
      THEN 'Partner Generated'
    ELSE sql_source__c
  END                           AS sales_qualified_source,
    CASE
  WHEN sales_qualified_source = 'BDR Generated' THEN 'SDR Generated'
  WHEN sales_qualified_source = 'Channel Generated' THEN 'Partner Generated'
  WHEN sales_qualified_source LIKE ANY ('Web%', 'Missing%', 'Other') OR sales_qualified_source IS NULL THEN 'Web Direct Generated'
  ELSE sales_qualified_source
END                   AS sales_qualified_source_grouped,
    IFF( sales_qualified_source = 'Partner Generated', 'Partner Sourced', 'Co-sell')                            AS sqs_bucket_engagement,
    sdr_pipeline_contribution__c                                                     AS sdr_pipeline_contribution,
    solutions_to_be_replaced__c                                                      AS solutions_to_be_replaced,
    x3_technical_evaluation_date__c
      AS technical_evaluation_date,
    amount                                                                           AS total_contract_value,
    recurring_amount__c                                                              AS recurring_amount,
    true_up_amount__c                                                                AS true_up_amount,
    proserv_amount__c                                                                AS proserv_amount,
    other_non_recurring_amount__c                                                    AS other_non_recurring_amount,
    upside_swing_deal_iacv__c                                                        AS upside_swing_deal_iacv,
    web_portal_purchase__c                                                           AS is_web_portal_purchase,
    opportunity_term_new__c                                                          AS opportunity_term,
    NULL                                                                             AS partner_initiated_opportunity,
    user_segment_o__c                                                                AS user_segment,
    start_date__c::DATE                                                              AS subscription_start_date,
    end_date__c::DATE                                                                AS subscription_end_date,
    subscription_renewal_date__c::DATE                                               AS subscription_renewal_date,
    NULL                                                                             AS true_up_value,
    order_type_live__c                                                               AS order_type_current,
    order_type_test__c                                                               AS order_type_stamped,
    CASE
      WHEN order_type_stamped = '1. New - First Order'
        THEN '1) New - First Order'
      WHEN order_type_stamped IN ('2. New - Connected', '3. Growth', '4. Contraction', '5. Churn - Partial', '6. Churn - Final')
        THEN '2) Growth (Growth / New - Connected / Churn / Contraction)'
      WHEN order_type_stamped IN ('7. PS / Other')
        THEN '3) Consumption / PS / Other'
      ELSE 'Missing order_type_name_grouped'
    END                                                                              AS order_type_grouped,
    CASE
    WHEN order_type_test__c != '1. New - First Order' AND arr_basis__c = 0 THEN 'Add-On Growth'
    WHEN order_type_test__c NOT IN ('1. New - First Order', '4. Contraction', '5. Churn - Partial', '6. Churn - Final')  AND arr_basis__c != 0 THEN 'Growth on Renewal'
    WHEN order_type_test__c IN ('4. Contraction', '5. Churn - Partial') AND arr_basis__c != 0 THEN 'Contraction on Renewal'
    WHEN order_type_test__c IN ('6. Churn - Final') AND arr_basis__c != 0 THEN 'Lost on Renewal'
    ELSE 'Missing growth_type'
  END
      AS growth_type,
    arr_net__c                                                                       AS net_arr,
    arr_basis__c                                                                     AS arr_basis,
    arr__c                                                                           AS arr,
    stage_3_net_arr__c                                                               AS xdr_net_arr_stage_3,
    stage_1_xdr_net_arr__c                                                           AS xdr_net_arr_stage_1,
    stage_1_net_arr__c                                                               AS net_arr_stage_1,
    enterprise_agile_planning_net_arr__c                                             AS enterprise_agile_planning_net_arr,
    duo_net_arr__c                                                                   AS duo_net_arr,
    days_in_sao__c                                                                   AS days_in_sao,
    new_logo_count__c                                                                AS new_logo_count,
    CASE WHEN LOWER(user_segment_o__c) = 'smb' THEN 'SMB'
     WHEN LOWER(user_segment_o__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(user_segment_o__c) = 'public sector' THEN 'PubSec'
     WHEN LOWER(user_segment_o__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(user_segment_o__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(user_segment_o__c) IS NULL THEN 'SMB'
     WHEN LOWER(user_segment_o__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(user_segment_o__c) = 'lrg' THEN 'Large'
     WHEN LOWER(user_segment_o__c) = 'jihu' THEN 'JiHu'
     WHEN user_segment_o__c IS NOT NULL THEN user_segment_o__c
END
      AS user_segment_stamped,
    CASE
      WHEN user_segment_stamped IN ('Large', 'PubSec') THEN 'Large'
      ELSE user_segment_stamped
    END                                                                              AS user_segment_stamped_grouped,
    stamped_user_geo__c                                                              AS user_geo_stamped,
    stamped_user_region__c                                                           AS user_region_stamped,
    stamped_user_area__c                                                             AS user_area_stamped,
    CASE
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo_stamped) = 'AMER' AND UPPER(user_region_stamped) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo_stamped) IN ('AMER', 'LATAM') AND UPPER(user_region_stamped) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo_stamped) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN user_geo_stamped
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_region_stamped) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo_stamped) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(user_segment_stamped) NOT IN ('LARGE', 'PUBSEC')
    THEN user_segment_stamped
  ELSE 'Missing segment_region_grouped'
END
      AS user_segment_region_stamped_grouped,
    CONCAT(
      user_segment_stamped,
      '-',
      user_geo_stamped,
      '-',
      user_region_stamped,
      '-',
      user_area_stamped
    )                                                                                AS user_segment_geo_region_area_stamped,
    stamped_opp_owner_user_role_type__c                                              AS crm_opp_owner_user_role_type_stamped,
    stamped_opp_owner_user_business_unit__c                                          AS user_business_unit_stamped,
    stamped_opportunity_owner__c                                                     AS crm_opp_owner_stamped_name,
    stamped_account_owner__c                                                         AS crm_account_owner_stamped_name,
    sao_user_segment__c                                                              AS sao_crm_opp_owner_sales_segment_stamped,
    NULL                                                                             AS sao_crm_opp_owner_sales_segment_geo_region_area_stamped,
    CASE
      WHEN sao_crm_opp_owner_sales_segment_stamped IN ('Large', 'PubSec') THEN 'Large'
      ELSE sao_crm_opp_owner_sales_segment_stamped
    END                                                                              AS sao_crm_opp_owner_sales_segment_stamped_grouped,
    sao_user_geo__c                                                                  AS sao_crm_opp_owner_geo_stamped,
    sao_user_region__c                                                               AS sao_crm_opp_owner_region_stamped,
    sao_user_area__c                                                                 AS sao_crm_opp_owner_area_stamped,
    CASE
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_geo_stamped) = 'AMER' AND UPPER(sao_crm_opp_owner_region_stamped) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_geo_stamped) IN ('AMER', 'LATAM') AND UPPER(sao_crm_opp_owner_region_stamped) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_geo_stamped) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN sao_crm_opp_owner_geo_stamped
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_region_stamped) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_geo_stamped) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) NOT IN ('LARGE', 'PUBSEC')
    THEN sao_crm_opp_owner_sales_segment_stamped
  ELSE 'Missing segment_region_grouped'
END
      AS sao_crm_opp_owner_segment_region_stamped_grouped,
    opportunity_category__c                                                          AS opportunity_category,
    opportunity_health__c                                                            AS opportunity_health,
    NULL                                                                             AS risk_type,
    NULL                                                                             AS risk_reasons,
    tam_notes__c                                                                     AS tam_notes,
    solution_architect__c                                                            AS primary_solution_architect,
    product_details__c                                                               AS product_details,
    product_category__c                                                              AS product_category,
    products_purchased__c                                                            AS products_purchased,
    CASE
      WHEN web_portal_purchase__c THEN 'Web Direct'
      WHEN arr_net__c < 5000 THEN '<5K'
      WHEN arr_net__c < 25000 THEN '5-25K'
      WHEN arr_net__c < 100000 THEN '25-100K'
      WHEN arr_net__c < 250000 THEN '100-250K'
      WHEN arr_net__c > 250000 THEN '250K+'
      ELSE 'Missing opportunity_deal_size'
    END                                                                              AS opportunity_deal_size,
    payment_schedule__c                                                              AS payment_schedule,
    comp_new_logo_override__c                                                        AS comp_new_logo_override,
    is_pipeline_created_eligible_flag__c                                             AS is_pipeline_created_eligible,
    next_steps__c                                                                    AS next_steps,
    auto_renewal_status__c                                                           AS auto_renewal_status,
    qsr_notes__c                                                                     AS qsr_notes,
    qsr_status__c                                                                    AS qsr_status,
    manager_forecast_confidence__c                                                   AS manager_confidence,
    renewal_risk_forecast__c                                                         AS renewal_risk_category,
    renewal_swing_arr__c                                                             AS renewal_swing_arr,
    isr__c                                                                           AS renewal_manager,
    renewal_forecast_category__c                                                     AS renewal_forecast_health,
    startup_type__c                                                                  AS startup_type,
    -- ************************************
    -- sales segmentation deprecated fields - 2020-09-03
    -- left temporary for the sake of MVC and avoid breaking SiSense existing charts
    COALESCE(CASE WHEN LOWER(sales_segmentation_employees_o__c) = 'smb' THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) IS NULL THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'lrg' THEN 'Large'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'jihu' THEN 'JiHu'
     WHEN sales_segmentation_employees_o__c IS NOT NULL THEN initcap(sales_segmentation_employees_o__c)
END, 'Unknown')
      AS sales_segment,
    CASE WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'smb' THEN 'SMB'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) IS NULL THEN 'SMB'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'lrg' THEN 'Large'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'jihu' THEN 'JiHu'
     WHEN ultimate_parent_sales_segment_emp_o__c IS NOT NULL THEN initcap(ultimate_parent_sales_segment_emp_o__c)
END
      AS parent_segment,
      -- ************************************
    -- dates in stage fields
    days_in_0_pending_acceptance__c                                                  AS days_in_0_pending_acceptance,
    days_in_1_discovery__c                                                           AS days_in_1_discovery,
    days_in_2_scoping__c                                                             AS days_in_2_scoping,
    days_in_3_technical_evaluation__c                                                AS days_in_3_technical_evaluation,
    days_in_4_proposal__c                                                            AS days_in_4_proposal,
    days_in_5_negotiating__c                                                         AS days_in_5_negotiating,
    x0_pending_acceptance_date__c                                                    AS stage_0_pending_acceptance_date,
    x1_discovery_date__c                                                             AS stage_1_discovery_date,
    x2_scoping_date__c                                                               AS stage_2_scoping_date,
    x3_technical_evaluation_date__c                                                  AS stage_3_technical_evaluation_date,
    x4_proposal_date__c                                                              AS stage_4_proposal_date,
    x5_negotiating_date__c                                                           AS stage_5_negotiating_date,
    x6_awaiting_signature_date__c                                                    AS stage_6_awaiting_signature_date,
    x6_closed_won_date__c                                                            AS stage_6_closed_won_date,
    x7_closed_lost_date__c                                                           AS stage_6_closed_lost_date,
    -- sales segment fields
    COALESCE(CASE WHEN LOWER(sales_segmentation_employees_o__c) = 'smb' THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) IS NULL THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'lrg' THEN 'Large'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'jihu' THEN 'JiHu'
     WHEN sales_segmentation_employees_o__c IS NOT NULL THEN initcap(sales_segmentation_employees_o__c)
END, 'Unknown')
      AS division_sales_segment_stamped,
    -- channel reporting
    -- original issue: https://gitlab.com/gitlab-data/analytics/-/issues/6072
    dr_partner_deal_type__c                                                          AS dr_partner_deal_type,
    dr_partner_engagement__c                                                         AS dr_partner_engagement,
    vartopiadrs__dr_deal_reg_id__c                                                   AS dr_deal_id,
    vartopiadrs__primary_registration__c                                             AS dr_primary_registration,
    CASE
  WHEN sqs_bucket_engagement = 'Partner Sourced'
    AND order_type_stamped = '1. New - First Order'
    THEN 'Sourced - New'
  WHEN sqs_bucket_engagement = 'Partner Sourced'
    AND ( order_type_stamped != '1. New - First Order' OR order_type_stamped IS NULL)
    THEN 'Sourced - Growth'
  WHEN sqs_bucket_engagement = 'Co-sell'
    AND order_type_stamped = '1. New - First Order'
    THEN 'Co-sell - New'
  WHEN sqs_bucket_engagement = 'Co-sell'
    AND ( order_type_stamped != '1. New - First Order' OR order_type_stamped IS NULL)
    THEN 'Co-sell - Growth'
END
      AS channel_type,
    impartnerprm__partneraccount__c                                                  AS partner_account,
    vartopiadrs__dr_status1__c                                                       AS dr_status,
    distributor__c                                                                   AS distributor,
    influence_partner__c                                                             AS influence_partner,
    focus_partner__c                                                                 AS is_focus_partner,
    fulfillment_partner__c                                                           AS fulfillment_partner,
    platform_partner__c                                                              AS platform_partner,
    partner_track__c                                                                 AS partner_track,
    resale_partner_track__c                                                          AS resale_partner_track,
    public_sector_opp__c::BOOLEAN                                                    AS is_public_sector_opp,
    registration_from_portal__c::BOOLEAN                                             AS is_registration_from_portal,
    calculated_discount__c                                                           AS calculated_discount,
    partner_discount__c                                                              AS partner_discount,
    partner_discount_calc__c                                                         AS partner_discount_calc,
    partner_margin__c                                                                AS partner_margin_percentage,
    NULL                                                                             AS comp_channel_neutral,
    aggregate_partner__c                                                             AS aggregate_partner,
    -- command plan fields
    fm_champion__c                                                                   AS cp_champion,
    fm_close_plan__c                                                                 AS cp_close_plan,
    fm_decision_criteria__c                                                          AS cp_decision_criteria,
    fm_decision_process__c                                                           AS cp_decision_process,
    fm_economic_buyer__c                                                             AS cp_economic_buyer,
    fm_help__c                                                                       AS cp_help,
    fm_identify_pain__c                                                              AS cp_identify_pain,
    fm_metrics__c                                                                    AS cp_metrics,
    fm_partner__c                                                                    AS cp_partner,
    fm_paper_process__c                                                              AS cp_paper_process,
    fm_review_notes__c                                                               AS cp_review_notes,
    fm_risks__c                                                                      AS cp_risks,
    fm_use_cases__c                                                                  AS cp_use_cases,
    fm_value_driver__c                                                               AS cp_value_driver,
    fm_why_do_anything_at_all__c                                                     AS cp_why_do_anything_at_all,
    fm_why_gitlab__c                                                                 AS cp_why_gitlab,
    fm_why_now__c                                                                    AS cp_why_now,
    fm_score__c                                                                      AS cp_score,
    -- original issue: https://gitlab.com/gitlab-data/analytics/-/issues/6577
    sa_validated_tech_evaluation_close_statu__c                                      AS sa_tech_evaluation_close_status,
    sa_validated_tech_evaluation_end_date__c                                         AS sa_tech_evaluation_end_date,
    sa_validated_tech_evaluation_start_date__c                                       AS sa_tech_evaluation_start_date,
    -- flag to identify eligible booking deals, excluding jihu - issue: https://gitlab.com/gitlab-com/sales-team/field-operations/systems/-/issues/1805
    fp_a_master_bookings_flag__c::BOOLEAN                                            AS fpa_master_bookings_flag,
    downgrade_reason__c                                                              AS downgrade_reason,
    ssp_id__c                                                                        AS ssp_id,
    gaclientid__c                                                                    AS ga_client_id,
    -- vsa data - issue: https://gitlab.com/gitlab-com/sales-team/field-operations/customer-success-operations/-/issues/2399
    vsa_readout__c                                                                   AS vsa_readout,
    vsa_start_date_net_arr__c                                                        AS vsa_start_date_net_arr,
    vsa_start_date__c                                                                AS vsa_start_date,
    vsa_url__c                                                                       AS vsa_url,
    vsa_status__c                                                                    AS vsa_status,
    vsa_end_date__c                                                                  AS vsa_end_date,
    -- original issue: https://gitlab.com/gitlab-com/sales-team/field-operations/customer-success-operations/-/issues/2464
    downgrade_details__c                                                             AS downgrade_details,
    won_arr_basis_for_clari__c                                                       AS won_arr_basis_for_clari,
    arr_basis_for_clari__c                                                           AS arr_basis_for_clari,
    forecasted_churn_for_clari__c                                                    AS forecasted_churn_for_clari,
    override_arr_basis_clari__c                                                      AS override_arr_basis_clari,
    -- ps fields - issue: https://gitlab.com/gitlab-com/sales-team/field-operations/customer-success-operations/-/issues/2723
    intended_product_tier__c                                                         AS intended_product_tier,
    parent_opportunity__c                                                            AS parent_opportunity_id,
    -- ptc fields - issue: https://gitlab.com/gitlab-data/analytics/-/issues/19440
    ptc_predicted_arr__c                                                             AS ptc_predicted_arr,
    ptc_predicted_renewal_risk_category__c                                           AS ptc_predicted_renewal_risk_category,
    -- metadata
    CONVERT_TIMEZONE('America/Los_Angeles', CONVERT_TIMEZONE(
      'UTC',
      CURRENT_TIMESTAMP()
    ))                                                                               AS _last_dbt_run,
    DATEDIFF(
      DAYS, lastactivitydate::DATE,
      CURRENT_DATE
    )                                                                                AS days_since_last_activity,
    isdeleted                                                                        AS is_deleted,
    lastactivitydate                                                                 AS last_activity_date,
    sales_last_activity_date__c                                                      AS sales_last_activity_date,
    recordtypeid                                                                     AS record_type_id
  FROM source
)
SELECT *
FROM renamed;

CREATE TABLE "PROD".restricted_safe_legacy.sfdc_opportunity_snapshots_source as
/*
  ATTENTION: When a field is added to this snapshot model, add it to the SFDC_OPPORTUNITY_SOURCE model to keep the live and snapshot models in alignment.
*/
WITH source AS (
    SELECT
      opportunity.*,
      CASE
        WHEN stagename = '0-Pending Acceptance'     THEN x0_pending_acceptance_date__c
        WHEN stagename = '1-Discovery'              THEN x1_discovery_date__c
        WHEN stagename = '2-Scoping'                THEN x2_scoping_date__c
        WHEN stagename = '3-Technical Evaluation'   THEN x3_technical_evaluation_date__c
        WHEN stagename = '4-Proposal'               THEN x4_proposal_date__c
        WHEN stagename = '5-Negotiating'            THEN x5_negotiating_date__c
        WHEN stagename = '6-Awaiting Signature'     THEN x6_awaiting_signature_date__c
      END                                                                                   AS calculation_days_in_stage_date,
      DATEDIFF(days,calculation_days_in_stage_date::DATE,CURRENT_DATE::DATE) + 1            AS days_in_stage
    FROM "RAW".snapshots.sfdc_opportunity_snapshots  AS opportunity
    QUALIFY ROW_NUMBER() OVER (
    PARTITION BY
        dbt_valid_from::DATE,
        id
    ORDER BY dbt_valid_from DESC
    ) = 1
), renamed AS (
     SELECT
        -- keys
        accountid                                                                           AS account_id,
        id                                                                                  AS opportunity_id,
        name                                                                                AS opportunity_name,
        ownerid                                                                             AS owner_id,
        -- logistical information
        isclosed                                                                            AS is_closed,
        iswon                                                                               AS is_won,
        valid_deal_count__c                                                                 AS valid_deal_count,
        closedate                                                                           AS close_date,
        createddate                                                                         AS created_date,
        days_in_stage                                                                       AS days_in_stage,
        deployment_preference__c                                                            AS deployment_preference,
        sql_source__c                                                                       AS generated_source,
        leadsource                                                                          AS lead_source,
        merged_opportunity__c                                                               AS merged_opportunity_id,
        duplicate_opportunity__c                                                            AS duplicate_opportunity_id,
        contract_reset_opportunity__c                                                       AS contract_reset_opportunity_id,
        account_owner__c                                                                    AS account_owner,
        opportunity_owner__c                                                                AS opportunity_owner,
        manager_current__c                                                                  AS opportunity_owner_manager,
        sales_market__c                                                                     AS opportunity_owner_department,
        SDR_LU__c                                                                           AS crm_sales_dev_rep_id,
        business_development_representative__c                                              AS crm_business_dev_rep_id,
        BDR_LU__c                                                                           AS crm_business_dev_rep_id_lookup,
        BDR_SDR__c                                                                          AS opportunity_development_representative,
        sales_accepted_date__c                                                              AS sales_accepted_date,
        engagement_type__c                                                                  AS sales_path,
        sales_qualified_date__c                                                             AS sales_qualified_date,
        iqm_submitted_by_role__c                                                            AS iqm_submitted_by_role,
        type                                                                                AS sales_type,
        type                                                                                AS subscription_type,
        CASE
      WHEN leadsource in ('CORE Check-Up','Free Registration')
        THEN 'Core'
      WHEN leadsource in ('GitLab Subscription Portal', 'Gitlab.com', 'GitLab.com', 'Trial - Gitlab.com', 'Trial - GitLab.com')
        THEN 'GitLab.com'
      WHEN leadsource in ('Education', 'OSS')
        THEN 'Marketing/Community'
      WHEN leadsource in ('CE Download', 'Demo', 'Drift', 'Email Request', 'Email Subscription', 'Gated Content - General', 'Gated Content - Report', 'Gated Content - Video'
                           , 'Gated Content - Whitepaper', 'Live Event', 'Newsletter', 'Request - Contact', 'Request - Professional Services', 'Request - Public Sector'
                           , 'Security Newsletter', 'Trial - Enterprise', 'Virtual Sponsorship', 'Web Chat', 'Web Direct', 'Web', 'Webcast')
        THEN 'Marketing/Inbound'
      WHEN leadsource in ('Advertisement', 'Conference', 'Field Event', 'Gong', 'Owned Event','UserGems Contact Tracking','UserGems - Meeting Assistant','UserGems - New Hires & Promotions')
        THEN 'Marketing/Outbound'
      WHEN leadsource in ('Clearbit', 'Datanyze','GovWin IQ', 'Leadware', 'LinkedIn', 'Prospecting - LeadIQ', 'Prospecting - General', 'Prospecting', 'SDR Generated')
        THEN 'Prospecting'
      WHEN leadsource in ('Employee Referral', 'External Referral', 'Partner', 'Word of mouth')
        THEN 'Referral'
      WHEN leadsource in ('AE Generated')
        THEN 'Sales'
      WHEN leadsource in ('DiscoverOrg')
        THEN 'DiscoverOrg'
      ELSE 'Other'
    END                               AS net_new_source_categories,
   CASE
      WHEN leadsource in ('CORE Check-Up', 'CE Download', 'CE Usage Ping','CE Version Check')
        THEN 'core'
      WHEN leadsource in ('Consultancy Request','Contact Request','Content','Demo','Drift','Education','EE Version Check','Email Request','Email Subscription','Enterprise Trial','Gated Content - eBook','Gated Content - General','Gated Content - Report','Gated Content - Video','Gated Content - Whitepaper','GitLab.com','MovingtoGitLab','Newsletter','OSS','Request - Community','Request - Contact','Request - Professional Services','Request - Public Sector','Security Newsletter','Startup Application','Web','Web Chat','White Paper','Trust Center')
        THEN 'inbound'
      WHEN leadsource in ('6sense', 'AE Generated', 'Clearbit','Datanyze','DiscoverOrg','Gemnasium','GitLab Hosted','Gitorious','gmail','Gong','GovWin IQ','Leadware','LinkedIn','Live Event','Prospecting','Prospecting - General','Prospecting - LeadIQ','SDR Generated','seamless.ai','UserGems Contact Tracking','UserGems - Meeting Assistant','UserGems - New Hires & Promotions','Zoominfo')
        THEN 'outbound'
      WHEN leadsource in ('Advertisement', 'Conference', 'Content Syndication', 'Executive Roundtable', 'Field Event', 'Owned Event','Promotion','Vendor Arranged Meetings','Virtual Sponsorship')
        THEN 'paid demand gen'
      WHEN leadsource in ('Purchased List')
        THEN 'purchased list'
      WHEN leadsource in ('Employee Referral', 'Event Partner', 'Existing Client', 'External Referral','Partner','Seminar - Partner','Word of mouth')
        THEN 'referral'
      WHEN leadsource in('Trial - Enterprise','Trial - GitLab.com')
        THEN 'trial'
      WHEN leadsource in ('Webcast','Webinar', 'CSM Webinar')
        THEN 'virtual event'
      WHEN leadsource in ('GitLab Subscription Portal','Web Direct')
        THEN 'web direct'
      ELSE 'Other'
    END                               AS source_buckets,
        stagename                                                                           AS stage_name,
        CASE
  WHEN deal_path__c = 'Channel' THEN 'Partner'
ELSE deal_path__c
END                                            AS deal_path,
        -- opportunity information
        acv_2__c                                                                            AS acv,
        amount                                                                              AS amount,
        IFF(acv_2__c >= 0, 1, 0)                                                            AS is_closed_deals, -- so that you can exclude closed deals that had negative impact
        competitors__c                                                                      AS competitors,
        critical_deal_flag__c                                                               AS critical_deal_flag,
        CASE WHEN arr_net__c < 5000 THEN '1 - Small (<5k)'
		WHEN arr_net__c < 25000 THEN '2 - Medium (5k - 25k)'
		WHEN arr_net__c < 100000 THEN '3 - Big (25k - 100k)'
		WHEN arr_net__c >= 100000 THEN '4 - Jumbo (>100k)'
	ELSE '5 - Unknown' END AS deal_size,
        forecastcategoryname                                                                AS forecast_category_name,
        incremental_acv_2__c                                                                AS forecasted_iacv,
        iacv_created_date__c                                                                AS iacv_created_date,
        incremental_acv__c                                                                  AS incremental_acv,
        invoice_number__c                                                                   AS invoice_number,
        is_refund_opportunity__c                                                            AS is_refund,
        is_downgrade_opportunity__c                                                         AS is_downgrade,
        swing_deal__c                                                                       AS is_swing_deal,
        is_edu_oss_opportunity__c                                                           AS is_edu_oss,
        is_ps_opportunity__c                                                                AS is_ps_opp,
        net_iacv__c                                                                         AS net_incremental_acv,
        campaignid                                                                          AS primary_campaign_source_id,
        probability                                                                         AS probability,
        professional_services_value__c                                                      AS professional_services_value,
        edu_services_value__c                                                               AS edu_services_value,
        investment_services_value__c                                                        AS investment_services_value,
        push_counter__c                                                                     AS pushed_count,
        reason_for_lost__c                                                                  AS reason_for_loss,
        reason_for_lost_details__c                                                          AS reason_for_loss_details,
        refund_iacv__c                                                                      AS refund_iacv,
        downgrade_iacv__c                                                                   AS downgrade_iacv,
        renewal_acv__c                                                                      AS renewal_acv,
        renewal_amount__c                                                                   AS renewal_amount,
        CASE sql_source__c
    WHEN  'BDR Generated'
      THEN 'SDR Generated'
    WHEN 'Channel Generated'
      THEN 'Partner Generated'
    ELSE sql_source__c
  END                              AS sales_qualified_source,
        CASE
  WHEN sales_qualified_source = 'BDR Generated' THEN 'SDR Generated'
  WHEN sales_qualified_source = 'Channel Generated' THEN 'Partner Generated'
  WHEN sales_qualified_source LIKE ANY ('Web%', 'Missing%', 'Other') OR sales_qualified_source IS NULL THEN 'Web Direct Generated'
  ELSE sales_qualified_source
END                      AS sales_qualified_source_grouped,
        IFF( sales_qualified_source = 'Partner Generated', 'Partner Sourced', 'Co-sell')                               AS sqs_bucket_engagement,
        sdr_pipeline_contribution__c                                                        AS sdr_pipeline_contribution,
        solutions_to_be_replaced__c                                                         AS solutions_to_be_replaced,
        x3_technical_evaluation_date__c                                                     AS technical_evaluation_date,
        amount                                                                              AS total_contract_value,
        recurring_amount__c                                                                 AS recurring_amount,
        true_up_amount__c                                                                   AS true_up_amount,
        proserv_amount__c                                                                   AS proserv_amount,
        other_non_recurring_amount__c                                                       AS other_non_recurring_amount,
        upside_swing_deal_iacv__c                                                           AS upside_swing_deal_iacv,
        web_portal_purchase__c                                                              AS is_web_portal_purchase,
        opportunity_term_new__c                                                             AS opportunity_term,
        pio__c                                                                              AS partner_initiated_opportunity,
        user_segment_o__c                                                                   AS user_segment,
        start_date__c::DATE                                                                 AS subscription_start_date,
        end_date__c::DATE                                                                   AS subscription_end_date,
        subscription_renewal_date__c::DATE                                                  AS subscription_renewal_date,
        true_up_value__c                                                                    AS true_up_value,
        order_type_live__c                                                                  AS order_type_current,
        order_type_test__c                                                                  AS order_type_stamped,
        CASE
          WHEN order_type_stamped = '1. New - First Order'
            THEN '1) New - First Order'
          WHEN order_type_stamped IN ('2. New - Connected', '3. Growth', '4. Contraction', '5. Churn - Partial', '6. Churn - Final')
            THEN '2) Growth (Growth / New - Connected / Churn / Contraction)'
          WHEN order_type_stamped IN ('7. PS / Other')
            THEN '3) Consumption / PS / Other'
          ELSE 'Missing order_type_name_grouped'
        END                                                                                 AS order_type_grouped,
        CASE
    WHEN order_type_test__c != '1. New - First Order' AND arr_basis__c = 0 THEN 'Add-On Growth'
    WHEN order_type_test__c NOT IN ('1. New - First Order', '4. Contraction', '5. Churn - Partial', '6. Churn - Final')  AND arr_basis__c != 0 THEN 'Growth on Renewal'
    WHEN order_type_test__c IN ('4. Contraction', '5. Churn - Partial') AND arr_basis__c != 0 THEN 'Contraction on Renewal'
    WHEN order_type_test__c IN ('6. Churn - Final') AND arr_basis__c != 0 THEN 'Lost on Renewal'
    ELSE 'Missing growth_type'
  END
                                                                                            AS growth_type,
        arr_net__c                                                                          AS net_arr,
        arr_basis__c                                                                        AS arr_basis,
        arr__c                                                                              AS arr,
        stage_3_net_arr__c                                                                  AS xdr_net_arr_stage_3,
        stage_1_xdr_net_arr__c                                                              AS xdr_net_arr_stage_1,
        stage_1_net_arr__c                                                                  AS net_arr_stage_1,
        enterprise_agile_planning_net_arr__c                                                AS enterprise_agile_planning_net_arr,
        duo_net_arr__c                                                                      AS duo_net_arr,
        days_in_sao__c                                                                      AS days_in_sao,
        new_logo_count__c                                                                   AS new_logo_count,
        CASE WHEN LOWER(user_segment_o__c) = 'smb' THEN 'SMB'
     WHEN LOWER(user_segment_o__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(user_segment_o__c) = 'public sector' THEN 'PubSec'
     WHEN LOWER(user_segment_o__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(user_segment_o__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(user_segment_o__c) IS NULL THEN 'SMB'
     WHEN LOWER(user_segment_o__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(user_segment_o__c) = 'lrg' THEN 'Large'
     WHEN LOWER(user_segment_o__c) = 'jihu' THEN 'JiHu'
     WHEN user_segment_o__c IS NOT NULL THEN user_segment_o__c
END
                                                                                            AS user_segment_stamped,
        CASE
          WHEN user_segment_stamped IN ('Large', 'PubSec') THEN 'Large'
          ELSE user_segment_stamped
        END                                                                                 AS user_segment_stamped_grouped,
        stamped_user_geo__c                                                                 AS user_geo_stamped,
        stamped_user_region__c                                                              AS user_region_stamped,
        stamped_user_area__c                                                                AS user_area_stamped,
        CASE
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo_stamped) = 'AMER' AND UPPER(user_region_stamped) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo_stamped) IN ('AMER', 'LATAM') AND UPPER(user_region_stamped) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo_stamped) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN user_geo_stamped
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_region_stamped) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(user_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(user_geo_stamped) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(user_segment_stamped) NOT IN ('LARGE', 'PUBSEC')
    THEN user_segment_stamped
  ELSE 'Missing segment_region_grouped'
END
                                                                                            AS user_segment_region_stamped_grouped,
        CONCAT(user_segment_stamped,
               '-',
               user_geo_stamped,
               '-',
               user_region_stamped,
               '-',
               user_area_stamped
              )                                                                             AS user_segment_geo_region_area_stamped,
        stamped_opp_owner_user_role_type__c                                                 AS crm_opp_owner_user_role_type_stamped,
        stamped_opp_owner_user_business_unit__c                                             AS user_business_unit_stamped,
        stamped_opportunity_owner__c                                                        AS crm_opp_owner_stamped_name,
        stamped_account_owner__c                                                            AS crm_account_owner_stamped_name,
        sao_user_segment__c                                                                 AS sao_crm_opp_owner_sales_segment_stamped,
        sao_opp_owner_segment_geo_region_area__c                                            AS sao_crm_opp_owner_sales_segment_geo_region_area_stamped,
        CASE
          WHEN sao_crm_opp_owner_sales_segment_stamped IN ('Large', 'PubSec') THEN 'Large'
          ELSE sao_crm_opp_owner_sales_segment_stamped
        END                                                                                 AS sao_crm_opp_owner_sales_segment_stamped_grouped,
        sao_user_geo__c                                                                     AS sao_crm_opp_owner_geo_stamped,
        sao_user_region__c                                                                  AS sao_crm_opp_owner_region_stamped,
        sao_user_area__c                                                                    AS sao_crm_opp_owner_area_stamped,
        CASE
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_geo_stamped) = 'AMER' AND UPPER(sao_crm_opp_owner_region_stamped) = 'WEST'
    THEN 'US WEST'
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_geo_stamped) IN ('AMER', 'LATAM') AND UPPER(sao_crm_opp_owner_region_stamped) IN ('EAST', 'LATAM')
    THEN 'US EAST'
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_geo_stamped) IN ('APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN sao_crm_opp_owner_geo_stamped
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_region_stamped) = 'PUBSEC'
    THEN 'PUBSEC'
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) IN ('LARGE', 'PUBSEC') AND UPPER(sao_crm_opp_owner_geo_stamped) NOT IN ('WEST', 'EAST', 'APAC', 'PUBSEC','EMEA', 'GLOBAL')
    THEN 'LARGE OTHER'
  WHEN UPPER(sao_crm_opp_owner_sales_segment_stamped) NOT IN ('LARGE', 'PUBSEC')
    THEN sao_crm_opp_owner_sales_segment_stamped
  ELSE 'Missing segment_region_grouped'
END
                                                                                            AS sao_crm_opp_owner_segment_region_stamped_grouped,
        opportunity_category__c                                                             AS opportunity_category,
        opportunity_health__c                                                               AS opportunity_health,
        risk_type__c                                                                        AS risk_type,
        risk_reasons__c                                                                     AS risk_reasons,
        tam_notes__c                                                                        AS tam_notes,
        solution_architect__c                                                               AS primary_solution_architect,
        product_details__c                                                                  AS product_details,
        product_category__c                                                                 AS product_category,
        products_purchased__c                                                               AS products_purchased,
        CASE
          WHEN web_portal_purchase__c THEN 'Web Direct'
          WHEN arr_net__c < 5000 THEN '<5K'
          WHEN arr_net__c < 25000 THEN '5-25K'
          WHEN arr_net__c < 100000 THEN '25-100K'
          WHEN arr_net__c < 250000 THEN '100-250K'
          WHEN arr_net__c > 250000 THEN '250K+'
          ELSE 'Missing opportunity_deal_size'
        END opportunity_deal_size,
        payment_schedule__c                                                                 AS payment_schedule,
        comp_new_logo_override__c                                                           AS comp_new_logo_override,
        is_pipeline_created_eligible_flag__c                                                AS is_pipeline_created_eligible,
        next_steps__c                                                                       AS next_steps,
        auto_renewal_status__c                                                              AS auto_renewal_status,
        qsr_notes__c                                                                        AS qsr_notes,
        qsr_status__c                                                                       AS qsr_status,
        manager_forecast_confidence__c                                                      AS manager_confidence,
        renewal_risk_forecast__c                                                            AS renewal_risk_category,
        renewal_swing_arr__c                                                                AS renewal_swing_arr,
        isr__c                                                                              AS renewal_manager,
        renewal_forecast_category__c                                                        AS renewal_forecast_health,
        startup_type__c                                                                     AS startup_type,
      -- ************************************
      -- sales segmentation deprecated fields - 2020-09-03
      -- left temporary for the sake of MVC and avoid breaking SiSense existing charts
        COALESCE(CASE WHEN LOWER(sales_segmentation_employees_o__c) = 'smb' THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) IS NULL THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'lrg' THEN 'Large'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'jihu' THEN 'JiHu'
     WHEN sales_segmentation_employees_o__c IS NOT NULL THEN initcap(sales_segmentation_employees_o__c)
END, 'Unknown' )
                                                                                            AS sales_segment,
        CASE WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'smb' THEN 'SMB'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) IS NULL THEN 'SMB'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'lrg' THEN 'Large'
     WHEN LOWER(ultimate_parent_sales_segment_emp_o__c) = 'jihu' THEN 'JiHu'
     WHEN ultimate_parent_sales_segment_emp_o__c IS NOT NULL THEN initcap(ultimate_parent_sales_segment_emp_o__c)
END
                                                                                            AS parent_segment,
      -- ************************************
        -- dates in stage fields
        days_in_0_pending_acceptance__c                                                     AS days_in_0_pending_acceptance,
        days_in_1_discovery__c                                                              AS days_in_1_discovery,
        days_in_2_scoping__c                                                                AS days_in_2_scoping,
        days_in_3_technical_evaluation__c                                                   AS days_in_3_technical_evaluation,
        days_in_4_proposal__c                                                               AS days_in_4_proposal,
        days_in_5_negotiating__c                                                            AS days_in_5_negotiating,
        x0_pending_acceptance_date__c                                                       AS stage_0_pending_acceptance_date,
        x1_discovery_date__c                                                                AS stage_1_discovery_date,
        x2_scoping_date__c                                                                  AS stage_2_scoping_date,
        x3_technical_evaluation_date__c                                                     AS stage_3_technical_evaluation_date,
        x4_proposal_date__c                                                                 AS stage_4_proposal_date,
        x5_negotiating_date__c                                                              AS stage_5_negotiating_date,
        x6_awaiting_signature_date__c                                                       AS stage_6_awaiting_signature_date,
        x6_closed_won_date__c                                                               AS stage_6_closed_won_date,
        x7_closed_lost_date__c                                                              AS stage_6_closed_lost_date,
        -- sales segment fields
        COALESCE(CASE WHEN LOWER(sales_segmentation_employees_o__c) = 'smb' THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) LIKE ('mid%market') THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'unknown' THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) IS NULL THEN 'SMB'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'pubsec' THEN 'PubSec'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'mm' THEN 'Mid-Market'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'lrg' THEN 'Large'
     WHEN LOWER(sales_segmentation_employees_o__c) = 'jihu' THEN 'JiHu'
     WHEN sales_segmentation_employees_o__c IS NOT NULL THEN initcap(sales_segmentation_employees_o__c)
END, 'Unknown' )
                                                                                            AS division_sales_segment_stamped,
        -- channel reporting
        -- original issue: https://gitlab.com/gitlab-data/analytics/-/issues/6072
        dr_partner_deal_type__c                                                             AS dr_partner_deal_type,
        dr_partner_engagement__c                                                            AS dr_partner_engagement,
        vartopiadrs__dr_deal_reg_id__c                                                      AS dr_deal_id,
        vartopiadrs__primary_registration__c                                                AS dr_primary_registration,
        CASE
  WHEN sqs_bucket_engagement = 'Partner Sourced'
    AND order_type_stamped = '1. New - First Order'
    THEN 'Sourced - New'
  WHEN sqs_bucket_engagement = 'Partner Sourced'
    AND ( order_type_stamped != '1. New - First Order' OR order_type_stamped IS NULL)
    THEN 'Sourced - Growth'
  WHEN sqs_bucket_engagement = 'Co-sell'
    AND order_type_stamped = '1. New - First Order'
    THEN 'Co-sell - New'
  WHEN sqs_bucket_engagement = 'Co-sell'
    AND ( order_type_stamped != '1. New - First Order' OR order_type_stamped IS NULL)
    THEN 'Co-sell - Growth'
END
                                                                                            AS channel_type,
        impartnerprm__partneraccount__c                                                     AS partner_account,
        vartopiadrs__dr_status1__c                                                          AS dr_status,
        distributor__c                                                                      AS distributor,
        influence_partner__c                                                                AS influence_partner,
        focus_partner__c                                                                    AS is_focus_partner,
        fulfillment_partner__c                                                              AS fulfillment_partner,
        platform_partner__c                                                                 AS platform_partner,
        partner_track__c                                                                    AS partner_track,
        resale_partner_track__c                                                             AS resale_partner_track,
        public_sector_opp__c::BOOLEAN                                                       AS is_public_sector_opp,
        registration_from_portal__c::BOOLEAN                                                AS is_registration_from_portal,
        calculated_discount__c                                                              AS calculated_discount,
        partner_discount__c                                                                 AS partner_discount,
        partner_discount_calc__c                                                            AS partner_discount_calc,
        partner_margin__c                                                                   AS partner_margin_percentage,
        comp_channel_neutral__c                                                             AS comp_channel_neutral,
        aggregate_partner__c                                                                AS aggregate_partner,
        -- command plan fields
        fm_champion__c                                                                      AS cp_champion,
        fm_close_plan__c                                                                    AS cp_close_plan,
        fm_decision_criteria__c                                                             AS cp_decision_criteria,
        fm_decision_process__c                                                              AS cp_decision_process,
        fm_economic_buyer__c                                                                AS cp_economic_buyer,
        fm_help__c                                                                          AS cp_help,
        fm_identify_pain__c                                                                 AS cp_identify_pain,
        fm_metrics__c                                                                       AS cp_metrics,
        fm_partner__c                                                                       AS cp_partner,
        fm_paper_process__c                                                                 AS cp_paper_process,
        fm_review_notes__c                                                                  AS cp_review_notes,
        fm_risks__c                                                                         AS cp_risks,
        fm_use_cases__c                                                                     AS cp_use_cases,
        fm_value_driver__c                                                                  AS cp_value_driver,
        fm_why_do_anything_at_all__c                                                        AS cp_why_do_anything_at_all,
        fm_why_gitlab__c                                                                    AS cp_why_gitlab,
        fm_why_now__c                                                                       AS cp_why_now,
        fm_score__c                                                                         AS cp_score,
        -- original issue: https://gitlab.com/gitlab-data/analytics/-/issues/6577
        sa_validated_tech_evaluation_close_statu__c                                         AS sa_tech_evaluation_close_status,
        sa_validated_tech_evaluation_end_date__c                                            AS sa_tech_evaluation_end_date,
        sa_validated_tech_evaluation_start_date__c                                          AS sa_tech_evaluation_start_date,
        -- flag to identify eligible booking deals, excluding jihu - issue: https://gitlab.com/gitlab-com/sales-team/field-operations/systems/-/issues/1805
        fp_a_master_bookings_flag__c::BOOLEAN                                               AS fpa_master_bookings_flag,
        downgrade_reason__c                                                                 AS downgrade_reason,
        ssp_id__c                                                                           AS ssp_id,
        gaclientid__c                                                                       AS ga_client_id,
        -- vsa data - issue: https://gitlab.com/gitlab-com/sales-team/field-operations/customer-success-operations/-/issues/2399
        vsa_readout__c                                                                      AS vsa_readout,
        vsa_start_date_net_arr__c                                                           AS vsa_start_date_net_arr,
        vsa_start_date__c                                                                   AS vsa_start_date,
        vsa_url__c                                                                          AS vsa_url,
        vsa_status__c                                                                       AS vsa_status,
        vsa_end_date__c                                                                     AS vsa_end_date,
       -- original issue: https://gitlab.com/gitlab-com/sales-team/field-operations/customer-success-operations/-/issues/2464
        downgrade_details__c                            AS downgrade_details,
        won_arr_basis_for_clari__c                      AS won_arr_basis_for_clari,
        arr_basis_for_clari__c                          AS arr_basis_for_clari,
        forecasted_churn_for_clari__c                   AS forecasted_churn_for_clari,
        override_arr_basis_clari__c                     AS override_arr_basis_clari,
        -- ps fields - original issue: https://gitlab.com/gitlab-com/sales-team/field-operations/customer-success-operations/-/issues/2723
        intended_product_tier__c                        AS intended_product_tier,
        parent_opportunity__c                           AS parent_opportunity_id,
        -- ptc fields - issue: https://gitlab.com/gitlab-data/analytics/-/issues/19440
        PTC_Predicted_ARR__c                            AS ptc_predicted_arr,
        PTC_Predicted_Renewal_Risk_Category__c          AS ptc_predicted_renewal_risk_category,
        -- metadata
        convert_timezone('America/Los_Angeles',convert_timezone('UTC',
                 CURRENT_TIMESTAMP()))                                                      AS _last_dbt_run,
        DATEDIFF(days, lastactivitydate::date,
                         CURRENT_DATE)                                                      AS days_since_last_activity,
        isdeleted                                                                           AS is_deleted,
        lastactivitydate                                                                    AS last_activity_date,
        sales_last_activity_date__c                                                         AS sales_last_activity_date,
        recordtypeid                                                                        AS record_type_id,
        -- snapshot metadata
        dbt_scd_id,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
      FROM source
  )
SELECT *
FROM renamed;