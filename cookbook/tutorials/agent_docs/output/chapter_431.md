## 4.3.1. Campaign Prep (`prep_campaign`)

The `prep_campaign` model is a crucial step in preparing campaign data for analysis. It addresses the challenge of working with raw Salesforce Campaign data, which often requires cleaning, standardization, and enrichment before it can be effectively used in downstream models. By performing these transformations, `prep_campaign` ensures data consistency and facilitates accurate reporting on campaign performance.

**Central Use Case:**

Imagine you need to analyze the performance of various marketing campaigns. You want to understand which campaigns are driving the most leads and revenue. However, the raw campaign data in Salesforce is inconsistent, with varying naming conventions, incomplete fields, and missing relationships between parent and child campaigns. The `prep_campaign` model solves this problem by cleaning and standardizing the data, making it ready for analysis in the [Campaign Dimension](chapter_3.3.md) and [Campaign Fact](chapter_3.3.md) tables.

This chapter will guide you through the purpose, source data, and output of the `prep_campaign` model, enabling you to understand how it prepares campaign data for effective analysis.

**Purpose:**

The primary purpose of `prep_campaign` is to clean and process raw Salesforce Campaign data. This includes:

*   Standardizing campaign attributes like `status` and `type`.
*   Establishing parent-child relationships between campaigns.
*   Identifying campaign series for aggregated reporting.

By achieving these objectives, `prep_campaign` creates a reliable foundation for building both the [Campaign Dimension](chapter_3.3.md) and [Campaign Fact](chapter_3.3.md) tables.

**Source:**

The sole source for `prep_campaign` is the `sfdc_campaign_source` table, which is a direct pull from Salesforce's Campaign object. This table contains all the raw data related to campaigns, including their properties, statuses, and relationships.

**Example Source Data:**

```sql
SELECT *
FROM "PREP".sfdc.sfdc_campaign_source
WHERE NOT is_deleted
```

**Internal Implementation:**

The `prep_campaign` model performs a series of transformations on the raw Salesforce Campaign data. Here's a simplified breakdown of the key steps:

1.  **Data Cleaning and Standardization:** The model cleans and standardizes key campaign attributes.
2.  **Parent-Child Relationship Handling:** The model establishes parent-child campaign relationships using the `campaign_parent_id` field. This allows for hierarchical analysis of campaigns.
3.  **Campaign Series Identification:**  The model identifies campaign series by looking for naming conventions in the campaign name or the parent campaign name.  This is useful for rolling up metrics across a related group of campaigns.

**Output:**

The `prep_campaign` model outputs a clean, standardized dataset that includes various descriptive attributes, dates, and calculated series information. This dataset is then used to populate the [Campaign Dimension](chapter_3.3.md) and [Campaign Fact](chapter_3.3.md) tables.

**Key Output Fields:**

*   `dim_campaign_id`: A unique identifier for each campaign.
*   `campaign_name`: The name of the campaign.
*   `is_active`: A flag indicating whether the campaign is active.
*   `status`: The status of the campaign (e.g., 'Planned', 'In Progress', 'Completed').
*   `type`: The type of campaign (e.g., 'Webinar', 'Email', 'Event').
*   `budget_holder`: The individual or team responsible for the campaign budget.
*   `dim_parent_campaign_id`:  Foreign key to parent campaign.
*    `series_campaign_id`: Foreign key to campaign series.
*    `series_campaign_name`: Name of campaign series.

**Example Output Data:**

```sql
SELECT
    dim_campaign_id,
    campaign_name,
    is_active,
    status,
    type,
    budget_holder,
    series_campaign_id,
    series_campaign_name
FROM "PROD".common_prep.prep_campaign
LIMIT 10
```

**Downstream Use:**

The `prep_campaign` model feeds directly into the [Campaign Dimension](chapter_3.3.md) and [Campaign Fact](chapter_3.3.md) tables. The [Campaign Dimension](chapter_3.3.md) uses the descriptive attributes to provide context for campaign analysis. The [Campaign Fact](chapter_3.3.md) uses the additive measures to quantify campaign performance.

By understanding the purpose, source, and output of the `prep_campaign` model, you can effectively leverage campaign data for meaningful marketing analytics. This model provides a clean, consistent, and enriched dataset that enables you to analyze campaign performance, optimize marketing strategies, and drive business growth.
