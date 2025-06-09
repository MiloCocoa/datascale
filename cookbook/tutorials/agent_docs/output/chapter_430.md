## 4.3. Campaign Data Preparation

### Motivation

Salesforce Campaign data is the cornerstone for understanding the effectiveness and reach of marketing initiatives. However, the raw data often requires cleaning, transformation, and standardization before it can be effectively used for analysis. This section details the process of preparing raw Salesforce Campaign data into structured datasets suitable for both dimension and fact tables.

### Use Case: Analyzing Campaign Performance

Imagine you need to analyze the performance of all marketing campaigns in the last quarter, broken down by campaign type and budget holder. To achieve this, you'll rely on clean and consistent campaign data. The preparation steps outlined in this section ensure that your queries return accurate and meaningful results.

### Core Elements

The primary model for campaign data preparation is `prep_campaign`. This model transforms raw Salesforce Campaign data from the `sfdc_campaign_source` table into a clean, standardized dataset.

#### Source Table: `sfdc_campaign_source`

This table contains the raw data extracted directly from Salesforce, including campaign attributes like name, status, type, and budget. It's the initial point for all campaign-related information. See [Source Data Overview](chapter_500.md) for details.

#### Transformation Steps in `prep_campaign`

1.  **Data Cleaning and Standardization**: The model handles inconsistencies and ensures data uniformity. For example, it might standardize date formats or trim whitespace from text fields.
2.  **Parent-Child Relationships**: It processes parent campaign relationships, linking campaigns to their parent campaigns to create a hierarchical structure.
3.  **Campaign Series Identification**:  Identifies and flags campaign series, grouping related campaigns for aggregated reporting.

#### Key Code Snippets

Here's a simplified example of the SQL code used in `prep_campaign`:

```sql
SELECT
    campaign_id,
    campaign_name,
    is_active,
    status,
    type,
    description,
    budget_holder
FROM sfdc_campaign_source
WHERE NOT is_deleted
```

This code snippet selects key attributes from the raw Salesforce Campaign data.

#### Relationship to Dimension and Fact Tables

The `prep_campaign` model serves as the source for the [Campaign Dimension](chapter_330.md) (`dim_campaign`) and the [Campaign Fact](chapter_330.md) (`fct_campaign`) tables.

*   **`dim_campaign`**: Stores descriptive attributes of campaigns (e.g., `campaign_name`, `type`, `budget_holder`).
*   **`fct_campaign`**: Contains additive measures and key dates (e.g., `budgeted_cost`, `expected_revenue`, `start_date`).

### Output Table: `prep_campaign`

The output of the `prep_campaign` model is a clean, standardized dataset with various descriptive attributes, dates, and calculated series information. This data is then used to populate the `dim_campaign` and `fct_campaign` tables.

#### Example

```sql
CREATE TABLE "PROD".common_prep.prep_campaign as
WITH sfdc_campaign_info AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_campaign_source
), final AS (
    SELECT
      dim_campaign_id,
      campaign_name,
      is_active,
      status,
      type,
      description,
      budget_holder
    FROM sfdc_campaign_info
)
SELECT *
FROM final;
```

This code creates the `prep_campaign` table, selecting descriptive fields like `dim_campaign_id`, `campaign_name`, `is_active`, `status`, `type`, and `budget_holder`.

### Internal Implementation

The `prep_campaign` model contains logic to:

*   **Handle Parent-Child Relationships**: Uses joins and recursive queries (not shown in the simplified example) to establish hierarchical relationships between campaigns.
*   **Identify Campaign Series**: Implements pattern matching and grouping logic to identify and group related campaigns into series.
*   **Create surrogate keys**: model generates a primary key that uniquely identifies each row in the `dim_campaign` table.

### Example: Campaign Hierarchy

Here is an example of how to identify campaign series:

```sql
WITH RECURSIVE campaign_hierarchy AS (
    SELECT
        dim_campaign_id,
        campaign_name,
        dim_parent_campaign_id
    FROM prep_campaign
    WHERE dim_parent_campaign_id IS NULL

    UNION ALL

    SELECT
        c.dim_campaign_id,
        c.campaign_name,
        c.dim_parent_campaign_id
    FROM prep_campaign c
    INNER JOIN campaign_hierarchy h ON c.dim_parent_campaign_id = h.dim_campaign_id
)
SELECT *
FROM campaign_hierarchy
```

This recursive CTE traverses the campaign hierarchy, starting from the top-level parent campaigns. It then joins back to the `prep_campaign` table to create a complete hierarchy.

### Benefits

*   **Data Consistency**: Ensures that campaign data is standardized and consistent across all reports and analyses.
*   **Improved Accuracy**: Cleans and transforms data to eliminate errors and inconsistencies.
*   **Simplified Analysis**: Provides a structured dataset that is easy to query and analyze.

### Conclusion

The campaign data preparation process detailed in this section is essential for reliable marketing analytics. By transforming raw Salesforce Campaign data into structured datasets, it enables accurate analysis of campaign performance, customer journeys, and attribution. This process provides a foundation for making data-driven decisions and optimizing marketing investments.
