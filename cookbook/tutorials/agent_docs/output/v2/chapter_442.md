#### 4.4.2. CRM Account Daily Snapshot Prep (`prep_crm_account_daily_snapshot`)

The `prep_crm_account_daily_snapshot` model addresses the need for time-series analysis of CRM account data. Due to the dynamic nature of CRM data, a simple point-in-time query might not accurately reflect historical states. This model solves this by creating daily historical snapshots, which enable tracking trends and changes over time.

**Use Case:**

Imagine you want to analyze how the health scores of your key accounts have evolved over the past quarter. Simply querying the current `dim_crm_account` table will only give you the current health scores, not the historical progression. The `prep_crm_account_daily_snapshot` model provides the necessary historical data for this analysis.

*   **Purpose**: Creates daily historical snapshots of CRM account data for time-series analysis, incorporating merged account logic, person data, user roles, data science scores, and LAM corrections.

*In essence, this model transforms raw, ever-changing CRM data into a structured, historical dataset ready for trend analysis and cohort studies.*

Let's explore the inner workings of this model.

**Data Sources:**

The model relies on a combination of raw and pre-processed data:

1.  **`sfdc_account_snapshots_source` (Legacy):** This is the foundational source, containing historical snapshots of core account attributes. While marked as "legacy", it's still critical for historical data.
2.  **`[map_merged_crm_account](chapter_443.md)`:**  This mapping table resolves merged accounts, ensuring consistent identification across snapshots.
3.  **`[prep_crm_person](chapter_411.md)`:** This model provides person-related data linked to the accounts, such as primary contact information.
4.  **`sfdc_user_roles_source` (Raw):** Raw data about user roles within the CRM, contributing to user-related attributes on the account.
5.  **`[dim_date](chapter_471.md)`:**  The date dimension, crucial for partitioning and filtering the snapshots.
6.  **`[prep_crm_user_daily_snapshot](chapter_452.md)`:** Historical snapshots of CRM user data are incorporated.
7.  **`sfdc_record_type` (Legacy):** Legacy table defining record types for accounts.
8.  **`pte_scores_source` (Raw) and `ptc_scores_source` (Raw):** Raw data science scores (Product Expansion and Contraction scores) for account enrichment.
9.  **`driveload_lam_corrections_source` (Raw):** Manual corrections for Land-Adopt-Monitor (LAM) metrics, ensuring data accuracy.

**Key Transformations:**

The `prep_crm_account_daily_snapshot` model performs the following critical transformations:

1.  **Snapshot Creation:** It generates daily snapshots by combining data from the historical source (`sfdc_account_snapshots_source`) with current information from other sources.
2.  **Account Merging:** It applies the `[map_merged_crm_account](chapter_443.md)` mapping to resolve merged accounts, ensuring that all historical data points to the correct canonical account.
3.  **Data Enrichment:**
    *   It enriches account data with person information from `[prep_crm_person](chapter_411.md)`.
    *   It incorporates user role information from `sfdc_user_roles_source` and `[prep_crm_user_daily_snapshot](chapter_452.md)`.
    *   It adds data science scores (PTE and PTC) from `pte_scores_source` and `ptc_scores_source`.
    *   It applies LAM corrections from `driveload_lam_corrections_source`.
4.  **Temporal Alignment**: The model ensures data accuracy by using `dim_date` to properly align the snapshot data with the correct dates.

**Illustrative Code Snippet (Conceptual):**

While the complete SQL for this model is extensive, here's a simplified example to illustrate the core logic of creating a snapshot:

```sql
CREATE TABLE prep_crm_account_daily_snapshot AS
SELECT
    d.date_actual AS snapshot_date,
    a.*,
    p.person_info  -- Example: including person data from prep_crm_person
FROM dim_date d
CROSS JOIN sfdc_account_snapshots_source a
LEFT JOIN prep_crm_person p ON a.account_id = p.account_id
WHERE d.date_actual BETWEEN a.dbt_valid_from AND COALESCE(a.dbt_valid_to, CURRENT_DATE);
```

*This snippet shows how the `CROSS JOIN` with `dim_date` creates a row for every date within the validity period of the account snapshot. This is a simplified version and the actual code joins with several other models.*

**Model Output:**

The `prep_crm_account_daily_snapshot` model produces a table with the following characteristics:

*   **Granularity:** Daily snapshots of each CRM account.
*   **Key Fields:** Includes all key fields from the source tables, such as account attributes, health scores, and relevant dates.  A key field to understand is `snapshot_date` which indicates the date the snapshot represents.
*   **Purpose:** Used in the [CRM Account Dimension](chapter_3.4.md) for cohort analysis and in [prep_crm_opportunity](chapter_461.md) for stamping account attributes on opportunities.

**Downstream Usage:**

1.  **[CRM Account Dimension](chapter_3.4.md) (Cohort Analysis):** This mart uses the historical data to determine when accounts entered specific ARR cohorts.
2.  **[prep_crm_opportunity](chapter_461.md) (Attribute Stamping):** This preparatory model uses the daily snapshots to "stamp" accurate account attributes onto opportunities, reflecting the account's state at the time the opportunity was active.  This ensures accurate reporting on metrics that are dependent on time-varying account characteristics.

**Benefits:**

*   **Accurate Historical Reporting:** Provides a reliable basis for analyzing trends and changes in account data over time.
*   **Consistent Data:**  Resolves inconsistencies caused by account merging and data updates.
*   **Enriched Data:** Combines account data with relevant information from other CRM entities and external sources.
*   **Cohort Analysis Enabled:** Facilitates cohort analysis by tracking accounts and their attributes across different time periods.

**Implementation Details:**

*   **Incremental Updates:** The model can be implemented with incremental updates, processing only the new or changed data for each day. This significantly reduces processing time.
*   **Data Partitioning:** Partitioning the table by date can improve query performance for time-series analysis.

By generating daily snapshots and integrating data from multiple sources, the `prep_crm_account_daily_snapshot` model offers a robust and versatile foundation for understanding CRM account dynamics. It transforms a complex and ever-changing dataset into a well-structured resource for sophisticated marketing and sales analytics.
