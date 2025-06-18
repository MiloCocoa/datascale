## 4.6. Opportunity Data Preparation

This section delves into the critical processes involved in preparing Salesforce Opportunity data for marketing and sales analytics. Accurate opportunity data is paramount for understanding revenue generation, sales pipeline health, and forecasting future performance. This data preparation involves consolidating information from various Salesforce sources, creating historical snapshots for trend analysis, and calculating essential metrics related to revenue and pipeline stages.

### Motivation

Raw Opportunity data from Salesforce often requires extensive cleaning, transformation, and enrichment before it can be effectively used for analysis. Key challenges include:

*   **Data Consistency:** Ensuring consistent data types and formats across different Salesforce fields.
*   **Historical Tracking:** Capturing changes in opportunity data over time to understand pipeline evolution.
*   **Metric Calculation:** Deriving critical metrics like Net ARR (Annual Recurring Revenue) and cycle time to measure sales effectiveness.
*   **Data Enrichment:** Augmenting Opportunity data with related information from Accounts, Users, and other CRM entities.

### Use Case: Analyzing Opportunity Cycle Time

One common use case is analyzing the cycle time of opportunities, which is the duration between opportunity creation and closure (either won or lost). A shorter cycle time often indicates a more efficient sales process.

To perform this analysis, we need to:

1.  Consolidate Opportunity data with historical snapshots to track stage changes over time.
2.  Calculate the cycle time in days for each opportunity.
3.  Analyze the distribution of cycle times across different sales segments, regions, and time periods.

### 4.6.1. CRM Opportunity Prep (`prep_crm_opportunity`)

The `prep_crm_opportunity` model is central to preparing Opportunity data. It consolidates raw Salesforce Opportunity data, including historical snapshots, and calculates a variety of derived flags and metrics related to revenue and pipeline.

**Purpose:**

*   Cleans and standardizes raw Salesforce Opportunity data.
*   Enriches Opportunity data with related information from Accounts, Users, and other CRM sources.
*   Calculates essential metrics like Net ARR and cycle time.
*   Creates flags to identify key opportunity characteristics, such as SAOs (Sales Accepted Opportunities) and Net ARR closed deals.

**Source Models:**

The `prep_crm_opportunity` model relies on several source models:

*   **`sfdc_opportunity_source` (raw)**: Raw data for opportunities
*   **`sfdc_opportunity_snapshots_source` (legacy)**: Historical snapshots of opportunity data.
*   **`net_iacv_to_net_arr_ratio` (seed)**: Ratios to convert Incremental ACV (IACV) to Net ARR.
*   **`dim_date` ([Date Dimension](chapter_471.md))**: A comprehensive date dimension for temporal analysis.
*   **`sfdc_opportunity_stage_source` (raw)**: Raw data for opportunity stages.
*   **`sfdc_record_type_source` (raw)**: Raw data for record types.
*   **`sfdc_account_snapshots_source` (legacy)**: Historical snapshots of Salesforce account data.
*   **`sfdc_opportunity_contact_role_source` (raw)**: Raw opportunity contact roles.
*   **`sfdc_bizible_attribution_touchpoint_source` (raw)**: Raw Bizible attribution touchpoint data.
*   **`prep_crm_account_daily_snapshot` ([CRM Account Daily Snapshot Prep](chapter_442.md))**: Daily historical snapshots of CRM account data.
*   **`prep_crm_user_daily_snapshot` ([CRM User Daily Snapshot Prep](chapter_452.md))**: Daily snapshots of CRM user data.
*   **`prep_crm_account` ([CRM Account Prep](chapter_441.md))**: Cleaned and enriched raw Salesforce Account data
*   **`prep_crm_user` ([CRM User Prep](chapter_451.md))**: Cleaned and transformed raw Salesforce User data.
*   **`sfdc_zqu_quote_source`**: Raw Zuora Quotes data.

**Key Transformations:**

*   **Data Consolidation:** Combines data from `sfdc_opportunity_source` and `sfdc_opportunity_snapshots_source` to create a unified view of Opportunities.
*   **Net ARR Calculation:** Uses `net_iacv_to_net_arr_ratio` to convert Incremental ACV (IACV) to Net ARR when native Net ARR is not available, providing a consistent measure for revenue analysis.
    ```sql
    net_arr = COALESCE(sfdc_opportunity.raw_net_arr, sfdc_opportunity.incremental_acv * net_iacv_to_net_arr_ratio.ratio)
    ```
*   **Cycle Time Calculation:** Calculates `cycle_time_in_days` as the difference between `created_date` and `close_date`, providing a key metric for sales efficiency analysis.
    ```sql
    cycle_time_in_days = DATEDIFF(days, sfdc_opportunity.created_date, sfdc_opportunity.close_date)
    ```
*   **Flag Creation:** Generates flags like `is_sao` and `is_net_arr_closed_deal` based on specific criteria, enabling targeted analysis of different Opportunity types.
    ```sql
    is_sao = CASE WHEN sfdc_opportunity.sales_accepted_date IS NOT NULL THEN 1 ELSE 0 END
    ```
*   **Stamped Attributes**: Extracts data from  `prep_crm_account_daily_snapshot` and `prep_crm_user_daily_snapshot` to stamp historical Account and User attributes onto the Opportunity, providing valuable context for historical analysis.

**Example Code Snippet:**

```sql
WITH sfdc_opportunity AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_opportunity_source
),
net_iacv_to_net_arr_ratio AS (
    SELECT *
    FROM "PREP".seed_sales.net_iacv_to_net_arr_ratio
)
SELECT
    sfdc_opportunity.opportunity_id,
    sfdc_opportunity.name,
    sfdc_opportunity.created_date,
    sfdc_opportunity.close_date,
    DATEDIFF(days, sfdc_opportunity.created_date, sfdc_opportunity.close_date) AS cycle_time_in_days,
    COALESCE(sfdc_opportunity.raw_net_arr, sfdc_opportunity.incremental_acv * net_iacv_to_net_arr_ratio.ratio) AS net_arr
FROM sfdc_opportunity
LEFT JOIN net_iacv_to_net_arr_ratio
    ON sfdc_opportunity.user_segment_stamped = net_iacv_to_net_arr_ratio.user_segment_stamped
    AND sfdc_opportunity.order_type = net_iacv_to_net_arr_ratio.order_type
```

**Output:**

The `prep_crm_opportunity` model outputs a comprehensive dataset with detailed Opportunity attributes, calculated metrics, and relevant flags. This output serves as a foundation for a wide range of sales and marketing analyses, including:

*   Sales pipeline analysis.
*   Revenue forecasting.
*   Sales performance measurement.
*   Customer segmentation and targeting.

### 4.6.2. Net IACV to Net ARR Ratio (`net_iacv_to_net_arr_ratio`)

*   **Purpose**: A seed table providing ratios to convert Incremental ACV (IACV) to Net ARR, based on user segment and order type. This is used in [prep_crm_opportunity](chapter_461.md) for estimating Net ARR for opportunities that don't have it natively.
*   **Source**: `PREP.seed_sales.net_iacv_to_net_arr_ratio` (raw seed data).

### 4.6.3. Sales Funnel Target Prep (`prep_sales_funnel_target`)

*   **Purpose**: Processes sales targets from sheetload data, aligning them with fiscal periods and CRM user hierarchies for reporting against actual performance.
*   **Sources**: [Date Dimension](chapter_471.md) and `sheetload_sales_targets_source` (raw).
*   **Output**: Sales targets data aligned with fiscal periods and user hierarchies, primarily feeding into [CRM User Hierarchy Prep](chapter_453.md).
</content>