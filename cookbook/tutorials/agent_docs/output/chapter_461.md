### 4.6.1. CRM Opportunity Prep (`prep_crm_opportunity`)

The `prep_crm_opportunity` model plays a crucial role in consolidating and enriching Salesforce Opportunity data. It addresses the challenge of fragmented opportunity information spread across various Salesforce sources and aims to provide a unified, comprehensive dataset for sales performance analysis and reporting. This enriched dataset includes historical snapshots, lead/contact information, quote details, and calculated metrics like Net ARR.

**Central Use Case:**

Imagine a sales analyst needing to report on the average sales cycle time for closed opportunities in the last quarter, segmented by sales region and product type. To accomplish this, the analyst requires a single table containing all relevant opportunity attributes (close date, sales region, product type), calculated metrics (cycle time), and historical context. `prep_crm_opportunity` provides this consolidated view, making the analysis efficient and accurate.

**How `prep_crm_opportunity` Solves This:**

1.  **Data Consolidation**:  It gathers opportunity data from the raw Salesforce opportunity table (`sfdc_opportunity_source`), historical snapshots (`sfdc_opportunity_snapshots_source`), and related tables (accounts, users, quotes).
2.  **Data Enrichment**:  It enriches the base opportunity data with related information, such as lead/contact details, account demographics, and user roles.
3.  **Metric Calculation**:  It calculates essential metrics like `net_arr` (using the `net_iacv_to_net_arr_ratio` seed table) and `cycle_time_in_days`.
4.  **Data Standardization**:  It standardizes data formats and values for consistency, ensuring accurate aggregation and reporting.
5.  **Historical Context**: It incorporates historical snapshots, allowing for time-series analysis and trend identification.

**Implementation Details:**

*   **Purpose**: Consolidates and enriches Salesforce Opportunity data, including historical snapshots, lead/contact info, quotes, and various derived flags and metrics like Net ARR calculations.

*Here's an example to calculate* `net_arr` *using* `net_iacv_to_net_arr_ratio` *seed data:*

```sql
   CASE
       WHEN fct_opportunity.is_live=1 THEN opp.incremental_acv * s.net_iacv_to_net_arr_ratio
        ELSE 0
   END AS calculated_net_arr
```

*   **Sources**:

    *   `sfdc_opportunity_source` (raw): Raw Salesforce Opportunity data.
    *   `sfdc_opportunity_snapshots_source` (legacy): Historical snapshots of Opportunity data.
    *   `net_iacv_to_net_arr_ratio` (seed): Ratios for converting Incremental ACV (IACV) to Net ARR. See [Net IACV to Net ARR Ratio](chapter_462.md).
    *   [Date Dimension](chapter_471.md): Date dimension table for date-based analysis.
    *   `sfdc_opportunity_stage_source` (raw): Raw Salesforce Opportunity Stage data.
    *   `sfdc_record_type_source` (raw): Raw Salesforce Record Type data.
    *   `sfdc_account_snapshots_source` (legacy): Historical snapshots of Salesforce Account data.  See [CRM Account Daily Snapshot Prep](chapter_442.md).
    *   `sfdc_opportunity_contact_role_source` (raw): Raw Salesforce Opportunity Contact Role data.
    *   `sfdc_bizible_attribution_touchpoint_source` (raw): Raw Bizible Attribution Touchpoint data.
    *   [CRM Account Daily Snapshot Prep](chapter_442.md): For stamped attributes.
    *   [CRM User Daily Snapshot Prep](chapter_452.md): User snapshot data.
    *   [CRM Account Prep](chapter_441.md): Current Account data.
    *   [CRM User Prep](chapter_451.md): Current User data.
    *   `sfdc_zqu_quote_source` (raw): Zuora Quotes data.
*   **Output**: A comprehensive opportunity dataset with detailed attributes, calculated metrics (e.g., `net_arr`, `cycle_time_in_days`), and various flags (e.g., `is_sao`, `is_net_arr_closed_deal`), used for sales performance analysis and contributing to user hierarchies.

**Key Fields and Logic:**

The model performs several key transformations:

1.  **Net ARR Calculation**:  Estimates Net ARR using the `net_iacv_to_net_arr_ratio` seed table, which provides ratios to convert Incremental ACV (IACV) to Net ARR, based on user segment and order type.
2.  **Cycle Time Calculation**:  Calculates the `cycle_time_in_days` by determining the difference between the opportunity created date and close date.
3.  **Flagging**:  Creates flags like `is_sao` (Sales Accepted Opportunity) and `is_net_arr_closed_deal` to identify key opportunity milestones and characteristics.

**Example Code Snippets:**

*Calculating the cycle time*

```sql
 DATEDIFF(day, sfdc_opportunity.created_date, sfdc_opportunity.close_date) AS cycle_time_in_days
```

*Checking if it is a Sales Accepted Opportunity*

```sql
   CASE
        WHEN sales_accepted_date IS NOT NULL THEN 1
        ELSE 0
      END AS is_sao
```

*   The above code snippet shows the extraction and transformation of Salesforce opportunity data using SQL.

*Purpose of Stamped Attributes:*

By incorporating `prep_crm_account_daily_snapshot` and `prep_crm_user_daily_snapshot`, `prep_crm_opportunity` captures a "snapshot" of key account and user attributes at the time the opportunity was active. This addresses the issue of data drift, where account or user characteristics change over time, potentially skewing historical analysis.

By creating `prep_crm_opportunity`, analysts gain access to a harmonized and augmented dataset that accelerates sales performance reporting, improves the accuracy of forecasts, and facilitates more insightful analysis of customer acquisition and revenue generation.
