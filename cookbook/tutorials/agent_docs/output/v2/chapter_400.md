## 4. Underlying Data Preparation

This section outlines the preparatory models that transform raw source data into the clean, structured, and enriched datasets used by the core dimension and fact tables. These models perform data cleaning, standardization, enrichment, and consolidation.

**Motivation**:

The raw data ingested from various sources like Salesforce, Marketo, and Zuora often comes in disparate formats, naming conventions, and levels of granularity. To perform effective marketing analytics, this raw data needs to be transformed into a consistent and reliable format. The "Underlying Data Preparation" layer addresses this challenge by providing a set of modular and well-defined data preparation models.

**Central Use Case: Analyzing Touchpoint Influence on MQLs**

Imagine you want to analyze which marketing touchpoints are most influential in converting leads into Marketing Qualified Leads (MQLs). To achieve this, you need to:

1.  **Clean and Standardize Touchpoint Data**: Parse UTM parameters, categorize marketing channels, and identify content types associated with each touchpoint.
2.  **Consolidate Person Data**: Create a unified view of leads and contacts, linking them to relevant touchpoint information and lifecycle milestones (e.g., inquiry date, MQL date).
3.  **Link Touchpoints to Persons**: Associate each touchpoint with the corresponding lead or contact in the CRM.
4.  **Calculate Influence Metrics**: Determine if a touchpoint occurred before or after the MQL date and assign appropriate attribution weights.

The preparatory models described in this section are designed to perform these tasks, enabling the analysis of touchpoint influence on MQLs.

### 4.1. CRM Person Data Preparation

This category focuses on the preparation of person-related data, consolidating information from various CRM sources and enriching it with activity and touchpoint details.

The primary model in this category is [`prep_crm_person`](chapter_411.md), which consolidates data from Salesforce Leads and Contacts, Bizible, Marketo, and other sources. Supporting models like [`prep_crm_task`](chapter_412.md) and [`prep_crm_event`](chapter_412.md) contribute to flags and metrics within `prep_crm_person`. Another key model is [`prep_bizible_touchpoint_information`](chapter_413.md), which identifies and consolidates the most recent and MQL-related Bizible touchpoint information for each person.

#### 4.1.1. `prep_crm_person`

*   **Purpose**: Consolidates and cleans raw Salesforce Lead and Contact data, enriching it with Bizible, Marketo, activity, and external demographic data.
*   **Sources**:
    *   `sfdc_contacts` (raw)
    *   `sfdc_leads` (raw)
    *   `biz_person_with_touchpoints` (from `sfdc_bizible_touchpoint_source` and `sfdc_bizible_person_source`)
    *   `marketo_persons` (from `marketo_lead_source` and `marketo_activity_delete_lead_source`)
    *   [`prep_crm_task`](chapter_412.md)
    *   [`prep_crm_event`](chapter_412.md) (for `is_bdr_sdr_worked`)
    *   `sfdc_account_source`
    *   [`prep_bizible_touchpoint_information`](chapter_413.md)
    *   [`prep_location_country`](chapter_475.md)
    *   [`prep_date`](chapter_471.md)
*   **Output**: A unified person record with cleaned IDs, demographic info, touchpoint data, and lifecycle dates, ready for [CRM Person Dimension](chapter_320.md) and [CRM Person Fact](chapter_320.md).

**Example Code Snippet:**

```sql
SELECT
  sfdc_record_id,
  email_hash,
  email_domain,
  is_valuable_signup,
  marketo_lead_id,
  owner_id,
  person_score,
  title,
  country,
  lead_source,
  net_new_source_categories
FROM prep_crm_person
```

This model performs several key transformations:

*   **ID Consolidation**: Cleans and standardizes IDs from different systems (Salesforce, Marketo, Bizible) to create a unified person identifier.
*   **Demographic Enrichment**: Extracts and standardizes demographic information like title, country, and industry.
*   **Lifecycle Milestones**: Identifies key dates in the lead/contact lifecycle, such as inquiry date, MQL date, and conversion date.
*   **Touchpoint Aggregation**: Consolidates touchpoint data from Bizible to understand the marketing interactions associated with each person.
*   **Activity Flags**: Derives flags based on tasks and events to signify sales engagement.

#### 4.1.2. Supporting Person Activity Data

These models process raw task and event data to support flags and metrics in `prep_crm_person`.

*   **`prep_crm_task`**: Cleans and categorizes raw Salesforce Task data (`sfdc_task_source`), extracting task types, statuses, and performance metrics. Used for the `is_bdr_sdr_worked` flag in [`prep_crm_person`](chapter_411.md).
*   **`prep_crm_event`**: Cleans and categorizes raw Salesforce Event data (`sfdc_event_source`), extracting event types and related entity information. Also contributes to the `is_bdr_sdr_worked` flag in [`prep_crm_person`](chapter_411.md).

**Example Code Snippet:**

```sql
-- prep_crm_task
SELECT
  task_id,
  task_status,
  task_priority,
  task_owner_role
FROM prep_crm_task

-- prep_crm_event
SELECT
  event_id,
  event_type,
  booked_by_employee_number
FROM prep_crm_event
```

These models parse and categorize task and event data to determine if a BDR or SDR has engaged with a lead or contact. The `is_bdr_sdr_worked` flag is crucial for understanding the impact of sales engagement on lead conversion.

#### 4.1.3. Bizible Touchpoint Information Prep (`prep_bizible_touchpoint_information`)

*   **Purpose**: Identifies and consolidates the most recent and MQL-related Bizible touchpoint information for each person.
*   **Sources**:
    *   `sfdc_lead_source` (raw)
    *   `sfdc_contact_source` (raw)
    *   `sfdc_bizible_person_source` (raw)
    *   `sfdc_bizible_touchpoint_source` (raw)
*   **Output**: MQL and most recent touchpoint IDs, dates, URLs, campaign names, and marketing channels, which then enrich [`prep_crm_person`](chapter_411.md).

**Example Code Snippet:**

```sql
SELECT
  sfdc_record_id,
  bizible_mql_touchpoint_id,
  bizible_mql_touchpoint_date,
  bizible_mql_marketing_channel,
  bizible_most_recent_touchpoint_id,
  bizible_most_recent_touchpoint_date,
  bizible_most_recent_marketing_channel
FROM prep_bizible_touchpoint_information
```

This model identifies the key touchpoints associated with a person's journey, specifically focusing on the touchpoint that led to MQL status and the most recent interaction. This information is then used to enrich the unified person record in `prep_crm_person`.

### 4.2. CRM Touchpoint Data Preparation

This category handles the preparation of raw Bizible touchpoint data, categorizing them, and linking them to internal content information.

The primary models in this category are [`prep_crm_touchpoint`](chapter_421.md) and [`prep_crm_attribution_touchpoint`](chapter_422.md), which clean and categorize raw Bizible touchpoint data. Mapping tables like [`map_bizible_campaign_grouping`](chapter_423.md) categorize Bizible data for consistent reporting. Finally, [`prep_bizible_touchpoint_keystone`](chapter_424.md) maps touchpoints to internal content information.

#### 4.2.1. Bizible Touchpoint Prep (`prep_crm_touchpoint`)

*   **Purpose**: Cleans and categorizes raw Bizible touchpoint data, extracting offer types and grouping them. It identifies patterns in URLs and campaign names to classify touchpoints.
*   **Sources**:
    *   `sfdc_bizible_touchpoint_source` (raw)
    *   `sheetload_bizible_to_pathfactory_mapping` (legacy)
    *   [`prep_campaign`](chapter_431.md)
*   **Output**: Enriched touchpoint records with `touchpoint_offer_type` and `touchpoint_offer_type_grouped`, which then feed into [CRM Touchpoint Dimension](chapter_310.md).

**Example Code Snippet:**

```sql
SELECT
  touchpoint_id,
  bizible_touchpoint_date,
  bizible_marketing_channel,
  touchpoint_offer_type,
  touchpoint_offer_type_grouped
FROM prep_crm_touchpoint
```

This model performs the following transformations:

*   **Offer Type Extraction**: Parses URLs and campaign names to identify the type of content or offer associated with the touchpoint.
*   **Offer Type Grouping**: Groups offer types into broader categories for simplified reporting.
*   **Campaign Linking**: Links touchpoints to campaigns in Salesforce for campaign performance analysis.

#### 4.2.2. Bizible Attribution Touchpoint Prep (`prep_crm_attribution_touchpoint`)

*   **Purpose**: Similar to `prep_crm_touchpoint` but specifically for Bizible attribution touchpoints, which are used in multi-touch attribution models.
*   **Sources**:
    *   `sfdc_bizible_attribution_touchpoint_source` (raw)
    *   `sheetload_bizible_to_pathfactory_mapping` (legacy)
    *   [`prep_campaign`](chapter_431.md)
*   **Output**: Enriched attribution touchpoint records, also feeding into [CRM Touchpoint Dimension](chapter_310.md).

This model performs the same transformations as `prep_crm_touchpoint` but focuses on attribution touchpoints, which are crucial for understanding the influence of different interactions across the customer journey.

#### 4.2.3. Bizible Campaign Grouping & Channel Path Mapping

These mapping tables categorize Bizible data for consistent reporting.

*   **`map_bizible_campaign_grouping`**: Defines rules to group Bizible touchpoints into integrated campaign groupings and GTM motions based on various touchpoint and campaign attributes. It's crucial for the `bizible_integrated_campaign_grouping`, `gtm_motion`, and `touchpoint_segment` fields in [CRM Touchpoint Dimension](chapter_310.md).

    **Example Code Snippet:**

    ```sql
    SELECT
      touchpoint_id,
      integrated_campaign_grouping,
      gtm_motion,
      touchpoint_segment
    FROM map_bizible_campaign_grouping
    ```

    This model provides a consistent way to categorize touchpoints based on the underlying campaign and its strategic intent.
*   **`map_bizible_marketing_channel_path`**: Categorizes Bizible marketing channel paths into broader, more digestible grouped names (e.g., 'Inbound Free Channels', 'Inbound Paid'). This is used for `bizible_marketing_channel_path_name_grouped` in `prep_bizible_marketing_channel_path`.

    **Example Code Snippet:**

    ```sql
    SELECT
      bizible_marketing_channel_path,
      bizible_marketing_channel_path_name_grouped
    FROM map_bizible_marketing_channel_path
    ```

    This mapping table simplifies the marketing channel path data for easier analysis and reporting.

#### 4.2.4. Bizible Touchpoint Keystone Prep (`prep_bizible_touchpoint_keystone`)

*   **Purpose**: Maps touchpoints to internal 'Keystone' content from a YAML file, providing additional content attributes like GTM motion and GitLab Epic.
*   **Sources**:
    *   `content_keystone_source` (raw)
    *   [`prep_crm_attribution_touchpoint`](chapter_422.md)
    *   [`prep_crm_touchpoint`](chapter_421.md)
*   **Output**: Touchpoint IDs linked to `content_name`, `gitlab_epic`, `gtm`, `url_slug`, and `type`, which enrich [CRM Touchpoint Dimension](chapter_310.md).

**Example Code Snippet:**

```sql
SELECT
  dim_crm_touchpoint_id,
  content_name,
  gitlab_epic,
  gtm,
  url_slug,
  type
FROM prep_bizible_touchpoint_keystone
```

This model enriches touchpoint data with internal content information, providing valuable context for understanding the content that customers are interacting with.

### 4.3. Campaign Data Preparation

This section covers the preparation of raw Salesforce campaign data for use in dimension and fact tables.

The primary model in this category is [`prep_campaign`](chapter_431.md), which cleans and processes raw Salesforce Campaign data, including parent campaign relationships and identifying campaign series.

#### 4.3.1. Campaign Prep (`prep_campaign`)

*   **Purpose**: Cleans and processes raw Salesforce Campaign data, including parent campaign relationships and identifying campaign series.
*   **Source**: `sfdc_campaign_source` (raw).
*   **Output**: A clean, standardized campaign dataset with various descriptive attributes, dates, and calculated series information, ready for [Campaign Dimension](chapter_330.md) and [Campaign Fact](chapter_330.md).

**Example Code Snippet:**

```sql
SELECT
  campaign_name,
  is_active,
  status,
  type,
  budget_holder,
  strategic_marketing_contribution,
  series_campaign_id,
  series_campaign_name
FROM prep_campaign
```

This model performs the following transformations:

*   **Descriptive Attribute Standardization**: Cleans and standardizes campaign attributes like name, status, and type.
*   **Relationship Extraction**: Identifies parent-child relationships between campaigns.
*   **Series Identification**: Groups campaigns into series for aggregated performance analysis.

### 4.4. CRM Account Data Preparation

This category focuses on the preparation of CRM account data, consolidating information from various Salesforce sources, snapshot data, and external enrichment services.

The primary model is [`prep_crm_account`](chapter_441.md), which cleans and enriches raw Salesforce Account data. The model is also incrementally updated through the historical snapshots from [`prep_crm_account_daily_snapshot`](chapter_442.md). There are also a series of supporting tables used for account mapping and enrichment.

#### 4.4.1. CRM Account Prep (`prep_crm_account`)

*   **Purpose**: Cleans and enriches raw Salesforce Account data, incorporating merged account logic, primary contact information, user roles, and data science scores.
*   **Sources**:
    *   `sfdc_account_source` (raw)
    *   [`map_merged_crm_account`](chapter_443.md)
    *   [`prep_crm_person`](chapter_411.md)
    *   `sfdc_user_roles_source` (raw)
    *   [`dim_date`](chapter_471.md)
    *   [`prep_crm_user`](chapter_451.md)
    *   `sfdc_users_source` (raw)
    *   `sfdc_record_type` (legacy)
    *   `pte_scores_source` (raw)
    *   `ptc_scores_source` (raw)
*   **Output**: A comprehensive account dataset with various descriptive attributes, flags, measures, and dates, primarily feeding [CRM Account Dimension](chapter_340.md).

**Example Code Snippet:**

```sql
SELECT
  crm_account_name,
  crm_account_employee_count,
  crm_account_gtm_strategy,
  crm_account_focus_account,
  health_number,
  health_score_color,
  pte_score,
  ptc_score
FROM prep_crm_account
```

This model consolidates a wealth of information about accounts:

*   **Core Account Attributes**: Cleans and standardizes key account attributes like name, employee count, industry, and GTM strategy.
*   **Relationship Resolution**: Uses the `map_merged_crm_account` table to resolve merged account IDs for consistent analysis.
*   **Contact and User Linking**: Links accounts to primary contacts and account owners, providing a holistic view of the account team.
*   **Data Science Score Incorporation**: Integrates data science scores (PTE and PTC) to assess account health and potential.

#### 4.4.2. CRM Account Daily Snapshot Prep (`prep_crm_account_daily_snapshot`)

*   **Purpose**: Creates daily historical snapshots of CRM account data for time-series analysis, incorporating merged account logic, person data, user roles, data science scores, and LAM corrections.
*   **Sources**:
    *   `sfdc_account_snapshots_source` (legacy)
    *   [`map_merged_crm_account`](chapter_443.md)
    *   [`prep_crm_person`](chapter_411.md)
    *   `sfdc_user_roles_source` (raw)
    *   [`dim_date`](chapter_471.md)
    *   [`prep_crm_user_daily_snapshot`](chapter_452.md)
    *   `sfdc_record_type` (legacy)
    *   `pte_scores_source` (raw)
    *   `ptc_scores_source` (raw)
    *   `driveload_lam_corrections_source` (raw)
*   **Output**: Historical snapshots of detailed CRM account information, used in [CRM Account Dimension](chapter_340.md) for cohort analysis and [`prep_crm_opportunity`](chapter_461.md) for stamped attributes.

This model generates daily snapshots of account data, enabling trend analysis and cohort studies:

*   **Historical Data Capture**: Creates a time-series view of account attributes, allowing for tracking changes over time.
*   **Snapshot Consistency**: Ensures consistency across snapshots by using the `map_merged_crm_account` table to resolve merged account IDs.
*   **Data Science and LAM Integration**: Incorporates data science scores and LAM corrections for a comprehensive view of account health and revenue potential.

#### 4.4.3. CRM Account Mapping Tables

These tables provide crucial mappings for accounts.

*   **`map_crm_account`**: Maps CRM account IDs to relevant dimension IDs for sales segment, territory, industry, and location, ensuring consistent joining across fact tables. It joins [`prep_sfdc_account`](chapter_471.md) with [`prep_sales_segment`](chapter_472.md), [`prep_sales_territory`](chapter_473.md), [`prep_industry`](chapter_474.md), and [`prep_location_country`](chapter_475.md).

    **Example Code Snippet:**

    ```sql
    SELECT
      crm_account_id,
      dim_sales_segment_id,
      dim_sales_territory_id,
      dim_industry_id,
      dim_location_country_id
    FROM map_crm_account
    ```

    This mapping table ensures consistent joins between the CRM account dimension and fact tables.
*   **`map_merged_crm_account`**: Resolves merged Salesforce accounts to their canonical ID for consistent data analysis, handling both live (`sfdc_account_source`) and historical (`sfdc_account_snapshots_source`) data. This ensures that all historical data points to the correct, non-merged account ID.

    **Example Code Snippet:**

    ```sql
    SELECT
      sfdc_account_id,
      merged_account_id,
      is_merged
    FROM map_merged_crm_account
    ```

    This mapping table is critical for maintaining data integrity when accounts are merged in Salesforce.

#### 4.4.4. Data Science Scores (PTE, PTC)

These raw data sources provide account-level scores from data science models, used for enrichment in account preparation.

*   **`pte_scores_source`**: Provides Product Expansion (PTE) scores for CRM accounts, indicating the likelihood of expansion.
*   **`ptc_scores_source`**: Provides Product Contraction (PTC) scores for CRM accounts, indicating the likelihood of contraction.

Both are sourced from `RAW.data_science` tables and feed into [`prep_crm_account`](chapter_441.md) and [`prep_crm_account_daily_snapshot`](chapter_442.md).

#### 4.4.5. Charge and MRR Data for Accounts

These models process Zuora billing data to support account metrics and cohorts.

*   **`prep_charge_mrr`**: Calculates Monthly Recurring Revenue (MRR) based on Zuora charge data and identifies revenue cohorts (`crm_account_arr_cohort_month`, `crm_account_arr_cohort_quarter`) for accounts. It is built from [`prep_charge`](chapter_446.md) and [`prep_date`](chapter_471.md) and influences [CRM Account Dimension](chapter_340.md).
*   **`prep_charge`**: Consolidates and cleans various Zuora and Zuora Revenue charge-related data for ARR analysis, including manual adjustments. It sources data from `zuora_rate_plan`, `zuora_rate_plan_charge`, `zuora_order_action_rate_plan`, `zuora_order_action`, `revenue_contract_line`, `zuora_order`, `charge_contractual_value`, `booking_transaction` (all raw `PREP` sources), and joins with `sfdc_account_source`, `zuora_account`, `zuora_subscription` (raw `PREP` sources), and [`map_merged_crm_account`](chapter_443.md).

### 4.5. CRM User Data Preparation

This category focuses on the preparation of CRM user data, including their roles and hierarchical structures for accurate reporting.

The core models in this category are [`prep_crm_user`](chapter_451.md), which cleans and transforms raw Salesforce User data, and [`prep_crm_user_daily_snapshot`](chapter_452.md), which generates daily snapshots for historical analysis. A key supporting model is [`prep_crm_user_hierarchy`](chapter_453.md), which defines and unions various CRM user hierarchies.

#### 4.5.1. CRM User Prep (`prep_crm_user`)

*   **Purpose**: Cleans and transforms raw Salesforce User data, including role hierarchy, sales segmentation, and manager information for the current state.
*   **Sources**:
    *   `sfdc_users_source` (raw)
    *   `sfdc_user_roles_source` (raw)
    *   [`dim_date`](chapter_471.md)
    *   `sheetload_mapping_sdr_sfdc_bamboohr_source` (raw)
*   **Output**: A clean, current view of CRM users with detailed attributes, ready for [CRM User Dimension](chapter_350.md).

**Example Code Snippet:**

```sql
SELECT
  employee_number,
  user_name,
  title,
  department,
  team,
  manager_name,
  user_role_name,
  crm_user_sales_segment,
  crm_user_geo,
  crm_user_region,
  crm_user_area
FROM prep_crm_user
```

This model performs several key transformations:

*   **User Attribute Standardization**: Cleans and standardizes user attributes like name, title, and department.
*   **Role Hierarchy Extraction**: Extracts role hierarchy information from Salesforce User Role data.
*   **Sales Segmentation**: Maps users to sales segments and territories for reporting.

#### 4.5.2. CRM User Daily Snapshot Prep (`prep_crm_user_daily_snapshot`)

*   **Purpose**: Generates daily snapshots of CRM user data for historical analysis, including role hierarchy and sales segmentation.
*   **Sources**:
    *   `sfdc_user_snapshots_source` (legacy)
    *   `sfdc_user_roles_source` (raw)
    *   [`dim_date`](chapter_471.md)
    *   `sheetload_mapping_sdr_sfdc_bamboohr_source` (raw)
*   **Output**: Historical snapshots of CRM user information, used in [`prep_crm_user_hierarchy`](chapter_453.md) and [`prep_crm_account_daily_snapshot`](chapter_442.md).

This model creates daily snapshots of user data, enabling historical analysis of user attributes and organizational structures.

#### 4.5.3. CRM User Hierarchy Prep (`prep_crm_user_hierarchy`)

*   **Purpose**: Defines and unions various CRM user hierarchies (geo-based and role-based) for different fiscal years, incorporating data from daily snapshots, sales funnel targets, and opportunities, ensuring accurate historical reporting for sales and marketing alignment.
*   **Sources**:
    *   [`dim_date`](chapter_471.md)
    *   [`prep_crm_user_daily_snapshot`](chapter_452.md)
    *   [`prep_crm_user`](chapter_451.md)
    *   [`prep_crm_account_daily_snapshot`](chapter_442.md)
    *   [`prep_crm_opportunity`](chapter_461.md)
    *   [`prep_sales_funnel_target`](chapter_463.md)
    *   [`prep_crm_person`](chapter_411.md)
*   **Output**: A unified hierarchy for CRM users based on fiscal year and role/geo, providing the `dim_crm_user_hierarchy_id` for use in various downstream models.

**Example Code Snippet:**

```sql
SELECT
  dim_crm_user_hierarchy_id,
  fiscal_year,
  crm_user_business_unit,
  crm_user_sales_segment,
  crm_user_geo,
  crm_user_region,
  crm_user_area,
  crm_user_role_name,
  crm_user_role_level_1,
  crm_user_role_level_2
FROM prep_crm_user_hierarchy
```

This model is critical for accurate reporting and analysis based on user hierarchies. It consolidates data from various sources to create a unified view of user hierarchies across different fiscal years.

### 4.6. Opportunity Data Preparation

This category processes Salesforce Opportunity data, including historical snapshots and calculated metrics related to revenue and pipeline.

The main model is [`prep_crm_opportunity`](chapter_461.md), which consolidates and enriches raw opportunity data. A seed table [`net_iacv_to_net_arr_ratio`](chapter_462.md) provides ratios for converting IACV to Net ARR. Finally, [`prep_sales_funnel_target`](chapter_463.md) processes sales targets for reporting.

#### 4.6.1. CRM Opportunity Prep (`prep_crm_opportunity`)

*   **Purpose**: Consolidates and enriches Salesforce Opportunity data, including historical snapshots, lead/contact info, quotes, and various derived flags and metrics like Net ARR calculations.
*   **Sources**:
    *   `sfdc_opportunity_source` (raw)
    *   `sfdc_opportunity_snapshots_source` (legacy)
    *   `net_iacv_to_net_arr_ratio` (seed)
    *   [`dim_date`](chapter_471.md)
    *   `sfdc_opportunity_stage_source` (raw)
    *   `sfdc_record_type_source` (raw)
    *   `sfdc_account_snapshots_source` (legacy)
    *   `sfdc_opportunity_contact_role_source` (raw)
    *   `sfdc_bizible_attribution_touchpoint_source` (raw)
    *   [`prep_crm_account_daily_snapshot`](chapter_442.md)
    *   [`prep_crm_user_daily_snapshot`](chapter_452.md)
    *   [`prep_crm_account`](chapter_441.md)
    *   [`prep_crm_user`](chapter_451.md)
    *   `sfdc_zqu_quote_source` (raw)
*   **Output**: A comprehensive opportunity dataset with detailed attributes, calculated metrics (e.g., `net_arr`, `cycle_time_in_days`), and various flags (e.g., `is_sao`, `is_net_arr_closed_deal`), used for sales performance analysis and contributing to user hierarchies.

**Example Code Snippet:**

```sql
SELECT
  opportunity_name,
  stage_name,
  net_arr,
  cycle_time_in_days,
  is_sao,
  is_net_arr_closed_deal
FROM prep_crm_opportunity
```

This model performs the following transformations:

*   **Opportunity Attribute Standardization**: Cleans and standardizes opportunity attributes like stage name, close date, and amount.
*   **Relationship Extraction**: Links opportunities to accounts, contacts, and quotes for a comprehensive view of the sales process.
*   **Metric Calculation**: Calculates key metrics like Net ARR, cycle time, and various conversion rates.
*   **Flag Derivation**: Derives flags to identify specific opportunity types and characteristics (e.g., SAO, Net ARR Closed Deal).
*   **User Hierarchy Integration**: links to CRM user hierarchy for detailed sales team performance

#### 4.6.2. Net IACV to Net ARR Ratio (`net_iacv_to_net_arr_ratio`)

*   **Purpose**: A seed table providing ratios to convert Incremental ACV (IACV) to Net ARR, based on user segment and order type. This is used in [`prep_crm_opportunity`](chapter_461.md) for estimating Net ARR for opportunities that don't have it natively.
*   **Source**: `PREP.seed_sales.net_iacv_to_net_arr_ratio` (raw seed data).

This table provides a default way to estimate Net ARR based on opportunity attributes when the Net ARR is null.

#### 4.6.3. Sales Funnel Target Prep (`prep_sales_funnel_target`)

*   **Purpose**: Processes sales targets from sheetload data, aligning them with fiscal periods and CRM user hierarchies for reporting against actual performance.
*   **Sources**:
    *   [`dim_date`](chapter_471.md)
    *   `sheetload_sales_targets_source` (raw)
*   **Output**: Sales targets data aligned with fiscal periods and user hierarchies, primarily feeding into [`prep_crm_user_hierarchy`](chapter_453.md).

This model prepares sales target data for performance analysis and alignment with organizational structures.

### 4.7. Core Utilities & Lookups

This category includes fundamental utility and lookup tables that provide standardized data for various dimensions and preparatory models.

#### 4.7.1. Date Dimension (`dim_date`)

*   **Purpose**: Provides a comprehensive date spine with various temporal attributes (e.g., day of week, month, quarter, fiscal year) for consistent date-based analysis.
*   **Source**: Derived from [`prep_date`](chapter_471.md).
*   **Output**: A detailed date dimension table that is widely used across the data mart for temporal filtering and aggregation.

**Example Code Snippet:**

```sql
SELECT
  date_actual,
  day_name,
  month_name,
  fiscal_year,
  fiscal_quarter_name,
  first_day_of_month,
  first_day_of_fiscal_quarter
FROM dim_date
```

The date dimension table is a fundamental utility that provides a consistent and comprehensive view of time.

#### 4.7.2. Sales Segment Dimension (`dim_sales_segment`)

*   **Purpose**: Standardizes and categorizes sales segment names for consistent reporting.
*   **Source**: Derived from [`prep_sales_segment`](chapter_472.md).
*   **Output**: A lookup table for sales segments, including a `sales_segment_grouped` field for higher-level aggregation.

**Example Code Snippet:**

```sql
SELECT
  sales_segment_name,
  sales_segment_grouped
FROM dim_sales_segment
```

This dimension table provides a consistent way to categorize accounts and users based on sales segment.

#### 4.7.3. Supporting Lookup Tables (Sales Territory, Industry, Location)

These preparatory models create lookup tables for various demographic and organizational attributes.

*   **`prep_sales_territory`**: Extracts unique sales territory names from Salesforce account data ([`prep_sfdc_account`](chapter_471.md)), providing a standardized list for territory-based analysis.
*   **`prep_industry`**: Extracts unique industry names from Salesforce account data ([`prep_sfdc_account`](chapter_471.md)), used for industry-specific reporting.
*   **`prep_location_country`**: Maps country ISO codes to full country names and aggregates to broader regional categories (e.g., EMEA, AMER), using MaxMind (`sheetload_maxmind_countries_source`) and Zuora geographic region data. It is influenced by [`prep_location_region`](chapter_475.md).
*   **`prep_location_region`**: Extracts unique geographic region names from Salesforce user data (`sfdc_users_source`), used to standardize regional classifications.

These lookup tables provide standardized values for key demographic and organizational attributes, ensuring consistency across the data mart.