```markdown
## Chapter 6. SFDC Preparation Tables
Details the creation of SFDC preparation tables:

*   **6.1. sfdc_lead_source**
    *   Source: `lead`
    *   Key transformations: cleaning and transformation of lead data

```sql
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
    is_interested_gitlab_ee__c AS is_interested_gitlab_ee,
    is_interested_in_hosted_solution__c AS is_interested_in_hosted,
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
    initial_recycle_datetime__c AS initial_recycle_datetime,
    most_recent_recycle_datetime__c AS most_recent_recycle_datetime,
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
    pql_namespace_users__c AS pql_namespace_users,
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
    account_demographics_segment_region_grouped__c AS account_demographics_segment_region_grouped,
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
    dascoopcomposer__is_created_by_groove__c AS is_created_by_groove,
    groove_flow_completed_date__c::DATE AS groove_flow_completed_date,
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
    groove_log_a_call_url__c AS groove_log_a_call_url,
    groove_next_step_due_date__c::DATE AS groove_next_step_due_date,
    dascoopcomposer__normalized_mobile__c AS groove_mobile_number,
    dascoopcomposer__normalized_phone__c AS groove_phone_number,
    groove_overdue_days__c AS groove_overdue_days,
    groove_removed_from_flow_date__c::DATE AS groove_removed_from_flow_date,
    groove_removed_from_flow_reason__c AS groove_removed_from_flow_reason,
    CREATED_BY_ID AS created_by_id,
    CREATED_DATE,
    IS_DELETED,
    LAST_ACTIVITY_DATE,
    LAST_MODIFIED_ID,
    LAST_MODIFIED_DATE,
    SYSTEMMODSTAMP
    FROM "RAW".salesforce_v2_stitch.lead
)
SELECT *
FROM renamed;
```

*   **6.2. sfdc_contact_source**
    *   Source: `contact`
    *   Key transformations: cleaning and transformation of contact data

```sql
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
    contact_role AS contact_role,
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
    zi_company_employee_count__c AS zoominfo_company_employee_count,
    cognism_number_of_employees__c AS cognism_employee_count,
    zi_contact_city__c AS zoominfo_contact_city,
    zi_company_city__c AS zoominfo_company_city,
    zi_company_industry__c AS zoominfo_company_industry,
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
    responded_to_githost_price_change__c AS responded_to_githost_price_change,
    core_check_in_notes__c AS core_check_in_notes,
    leadsource AS lead_source,
    lead_source_type__c AS lead_source_type,
    behavior_score__c AS behavior_score,
    outreach_stage__c AS outreach_stage,
    sequence_step_number__c AS outreach_step_number,
    account_type__c AS account_type,
    assigned_datetime__c::TIMESTAMP AS assigned_datetime,
    marketo_qualified_lead_timestamp AS marketo_qualified_lead_timestamp,
    marketo_qualified_lead_datetime AS marketo_qualified_lead_datetime,
    marketo_qualified_lead_date AS marketo_qualified_lead_date,
    mql_datetime_inferred__c AS mql_datetime_inferred,
    inquiry_datetime__c AS inquiry_datetime,
    inquiry_datetime_inferred__c AS inquiry_datetime_inferred,
    accepted_datetime__c AS accepted_datetime,
    qualifying_datetime__c AS qualifying_datetime,
    qualified_datetime