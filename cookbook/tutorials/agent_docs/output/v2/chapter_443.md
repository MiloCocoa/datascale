### 4.4.3. CRM Account Mapping Tables

These tables provide crucial mappings for accounts, ensuring data consistency and efficient joins across various fact tables. They solve the problem of fragmented account information by centralizing key relationships and resolving discrepancies arising from merged accounts.

#### Use Case: Consistent Reporting Across Fact Tables

Imagine a scenario where you need to analyze marketing touchpoints and sales opportunities at the account level. Each of these entities resides in different fact tables (`fct_crm_touchpoint`, `fct_crm_opportunity`). To accurately combine these data points, you need a reliable way to link them to a unified `dim_crm_account` dimension, and other relevant dimensions like sales segment or territory. These mapping tables facilitate this process.

#### Key Mapping Tables

This section details the two primary mapping tables involved:

*   `map_crm_account`
*   `map_merged_crm_account`

##### `map_crm_account`

This table serves as a central hub for mapping CRM account IDs to various relevant dimension IDs. It ensures consistent joining across fact tables by linking accounts to sales segments, territories, industries, and locations.

**Purpose:**

To standardize account-level reporting by providing a consistent set of dimension IDs for each CRM account.

**Source Models & Joins:**

This table joins the [prep_sfdc_account](chapter_471.md) with the following preparatory models:

*   [prep_sales_segment](chapter_472.md)
*   [prep_sales_territory](chapter_473.md)
*   [prep_industry](chapter_474.md)
*   [prep_location_country](chapter_475.md)

**Example Code:**

While the full SQL for creating the `map_crm_account` is extensive, here's a simplified example illustrating the joins:

```sql
SELECT
  a.dim_crm_account_id,
  ss.dim_sales_segment_id,
  st.dim_sales_territory_id,
  i.dim_industry_id,
  lc.dim_location_country_id
FROM prep_sfdc_account a
LEFT JOIN prep_sales_segment ss ON a.sales_segment = ss.sales_segment_name
LEFT JOIN prep_sales_territory st ON a.territory = st.sales_territory_name
LEFT JOIN prep_industry i ON a.industry = i.industry_name
LEFT JOIN prep_location_country lc ON a.country = lc.country_name
```

**Key Fields:**

*   `dim_crm_account_id`: The primary CRM account ID.
*   `dim_sales_segment_id`: Dimension ID for the sales segment.
*   `dim_sales_territory_id`: Dimension ID for the sales territory.
*   `dim_industry_id`: Dimension ID for the industry.
*   `dim_location_country_id`: Dimension ID for the location (country).

**Internal Implementation:**

The `map_crm_account` table is created through a series of left joins, ensuring that all CRM accounts are included, even if they don't have a corresponding entry in all the dimension tables. This is crucial for maintaining data completeness and preventing data loss during joins. The MD5 hashing function is used on source fields to generate the dimension IDs.

##### `map_merged_crm_account`

This table addresses the challenge of merged accounts in Salesforce. When two or more accounts are merged into a single "canonical" account, their historical data needs to be attributed to the correct, non-merged account ID. This mapping table resolves this issue by providing a consistent way to identify the canonical account ID for both live and historical data.

**Purpose:**

To resolve merged Salesforce accounts to their canonical ID for consistent data analysis, handling both live (`sfdc_account_source`) and historical (`sfdc_account_snapshots_source`) data.

**Source Models:**

*   `sfdc_account_source`:  Live Salesforce account data.
*   `sfdc_account_snapshots_source`: Historical snapshots of Salesforce account data.

**Example Code:**

```sql
WITH recursive_cte(account_id, master_record_id, is_deleted, lineage) AS (
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
)
SELECT
  account_id                                         AS sfdc_account_id,
  lineage[ARRAY_SIZE(lineage) - 1]::VARCHAR          AS merged_account_id,
  is_deleted,
  IFF(merged_account_id != account_id, TRUE, FALSE)  AS is_merged,
  IFF(is_deleted AND NOT is_merged, TRUE, FALSE)     AS deleted_not_merged,
  --return final common dimension mapping,
  IFF(deleted_not_merged, '-1', merged_account_id)   AS dim_crm_account_id
FROM recursive_cte
```

**Key Fields:**

*   `sfdc_account_id`: The original Salesforce account ID (may be merged).
*   `merged_account_id`: The canonical (non-merged) Salesforce account ID.
*   `dim_crm_account_id`: Dimension ID linked to the `dim_crm_account` table
*   `is_merged`: Flag indicating if the account has been merged.

**Internal Implementation:**

The `map_merged_crm_account` table employs a recursive common table expression (CTE) to trace the merge history of accounts. Starting with accounts that are *not* master records (i.e., they haven't been merged into another account), the CTE iteratively follows the `master_record_id` to identify the ultimate canonical account. This approach correctly handles complex merge chains, ensuring that all historical data is accurately attributed. Finally, the code uses conditional logic (IFF statements) and the `dim_crm_account_id` returns a `'-1'` placeholder when the account has been merged and is no longer directly represented in the dimension table.

#### Benefits

*   **Data Consistency**: Ensures that all fact tables are joined to the same, consistent account dimension.
*   **Accurate Reporting**: Correctly attributes historical data to the appropriate canonical account, even after merges.
*   **Simplified Analysis**: Streamlines account-level analysis by providing a unified view of customer interactions and activities.
*   **Efficient Joins**: Optimizes query performance by mapping string IDs to numeric dimension IDs.