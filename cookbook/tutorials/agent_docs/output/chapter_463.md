#### 4.6.3. Sales Funnel Target Prep (`prep_sales_funnel_target`)

This chapter details the `prep_sales_funnel_target` model, a critical component for aligning sales targets with actual performance. This model bridges the gap between planned sales goals and the hierarchical structure of the sales organization, enabling a clear comparison of targets against achievements.

**Use Case**:

Imagine a scenario where the VP of Sales needs to assess the performance of different sales teams against their assigned targets for a specific fiscal quarter. To achieve this, the sales targets, which are often initially defined in a spreadsheet, need to be transformed and aligned with the CRM user hierarchy to facilitate accurate reporting and analysis. The `prep_sales_funnel_target` model facilitates this alignment.

*   **Purpose**: Processes sales targets from sheetload data, aligning them with fiscal periods and CRM user hierarchies for reporting against actual performance.

    The primary goal of `prep_sales_funnel_target` is to convert raw sales target data from a flat, unstructured format (typically a spreadsheet) into a structured, queryable dataset. This involves:

    *   **Parsing and Cleaning**: Handling various data types and formats present in the raw sheetload data.
    *   **Fiscal Period Alignment**: Mapping targets to the correct fiscal periods based on date information.
    *   **CRM User Hierarchy Alignment**: Associating targets with the appropriate CRM user hierarchies, ensuring that targets are assigned to the correct teams and individuals.
*   **Sources**: [dim_date](chapter_471.md) and `sheetload_sales_targets_source` (raw).

    *   **`sheetload_sales_targets_source`**: This raw source represents the direct import of sales target data from a spreadsheet or similar file. It contains the initial, unstructured representation of the sales targets.
    *   **[dim_date](chapter_471.md)**: The [Date Dimension](chapter_471.md) table provides a standardized, comprehensive date spine, which is essential for aligning the sales targets with the correct fiscal periods.

*   **Output**: Sales targets data aligned with fiscal periods and user hierarchies, primarily feeding into [prep_crm_user_hierarchy](chapter_453.md).

    The output of `prep_sales_funnel_target` is a clean, transformed table containing the sales targets, aligned with fiscal periods and CRM user hierarchies. This table is then consumed by [prep_crm_user_hierarchy](chapter_453.md), which constructs a unified hierarchy for CRM users, enabling accurate reporting and analysis.

**Implementation Details**

The `prep_sales_funnel_target` model performs several key transformations:

1.  **Data Ingestion and Cleaning**: The model starts by reading the raw data from `sheetload_sales_targets_source`. It handles the parsing of different data types and formats, ensuring that the target values are correctly interpreted.
2.  **Fiscal Period Alignment**: Using the [dim_date](chapter_471.md) table, the model maps each sales target to the correct fiscal period. This involves joining the sales target data with the [Date Dimension](chapter_471.md) table on the month field and extracting the relevant fiscal year and period information.
3.  **CRM User Hierarchy Alignment**: The model associates the sales targets with the appropriate CRM user hierarchies. This involves joining the sales target data with the [CRM User Hierarchy](chapter_453.md) table (which is created in [prep_crm_user_hierarchy](chapter_453.md)) on the relevant user segmentation and geographical attributes.
4.  **Output Table**: The final output table contains the transformed sales targets, aligned with fiscal periods and CRM user hierarchies. This table is structured to facilitate easy querying and analysis.

**Code Snippets**

The following code snippet shows a simplified example of how the `prep_sales_funnel_target` model might perform the fiscal period alignment:

```sql
SELECT
    s.kpi_name,
    d.fiscal_year,
    d.first_day_of_month,
    s.allocated_target
FROM
    sheetload_sales_targets_source AS s
INNER JOIN
    dim_date AS d ON s.month = d.first_day_of_month
```

In this example, the `sheetload_sales_targets_source` table is joined with the `dim_date` table on the month field. This allows the model to extract the fiscal year and other relevant temporal attributes for each sales target.

The following code snippet shows a simplified example of how the `prep_sales_funnel_target` model might perform the CRM User Alignment:

```sql
SELECT
    s.kpi_name,
    s.user_segment,
    s.user_geo,
    s.allocated_target
FROM
    sheetload_sales_targets_source AS s
```

In this example, the model selects some of the fields that are related to the CRM user properties. After this selection, the resulting table would be used in the [prep_crm_user_hierarchy](chapter_453.md).

By transforming the raw sales target data into a structured, aligned format, the `prep_sales_funnel_target` model enables accurate reporting, analysis, and performance tracking. This, in turn, empowers the sales organization to make data-driven decisions and optimize their strategies.