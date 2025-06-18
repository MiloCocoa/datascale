## 3.4. CRM Account (`dim_crm_account`)

The `dim_crm_account` table provides a holistic view of accounts within the CRM, encompassing their hierarchical structure, demographic information, and various health and engagement indicators. This table serves as a critical dimension for understanding customer accounts and their relationships, enabling sophisticated analysis of marketing and sales performance at the account level.

### Motivation

In marketing and sales analytics, understanding the characteristics and health of customer accounts is paramount. The `dim_crm_account` table addresses this need by consolidating account-level information from various sources, including CRM data, external enrichment services, and data science models. This consolidation allows for:

*   **Account-Level Analysis**: Provides a central dimension for analyzing key metrics, such as marketing touchpoints, sales activities, and revenue, at the account level.
*   **Segmentation and Targeting**: Enables segmentation of accounts based on demographics, industry, health scores, and other attributes, facilitating targeted marketing and sales efforts.
*   **Relationship Understanding**: Captures the hierarchical relationships between accounts, allowing for analysis of parent-child account dynamics.
*   **Data Enrichment**: Integrates internal CRM data with external data sources, such as D&B and 6sense, to provide a more complete view of each account.

### Use Case

Imagine a marketing analyst tasked with identifying high-potential accounts for a targeted ABM (Account-Based Marketing) campaign. They need to identify accounts that:

1.  Are in a specific industry (e.g., Technology).
2.  Have a high "Product Expansion" (PTE) score, indicating a likelihood to expand their product usage.
3.  Are not already engaged in active sales opportunities.

Using the `dim_crm_account` table, the analyst can easily query for these criteria, joining it with other tables like `mart_crm_touchpoint` and `fct_crm_opportunity` to refine the target list further.

### Source Models

The `dim_crm_account` table is primarily based on the following source models:

*   **[prep_crm_account](chapter_441.md)**: This model is the core source, responsible for cleaning, transforming, and enriching raw Salesforce Account data. It incorporates data from various sources, including:
    *   Raw Salesforce Account data (`sfdc_account_source`).
    *   Mappings for merged accounts ([map_merged_crm_account](chapter_443.md)).
    *   Data from the [prep_crm_person](chapter_411.md) model to identify primary contacts.
    *   Data science scores (PTE, PTC).
*   **[prep_charge_mrr](chapter_445.md)**: This model calculates Monthly Recurring Revenue (MRR) based on Zuora billing data. It's joined to `dim_crm_account` to determine ARR cohort dates for accounts.

Here's a simplified example of how these models contribute to `dim_crm_account`:

```sql
SELECT
  pca.crm_account_name,
  pca.crm_account_industry,
  pca.crm_account_employee_count,
  pcm.crm_account_arr_cohort_month
FROM prep_crm_account pca
LEFT JOIN prep_charge_mrr pcm
  ON pca.dim_crm_account_id = pcm.dim_crm_account_id
```

### Key Fields

The `dim_crm_account` table contains a wide range of fields, providing a comprehensive view of each account. Here are some of the most important ones, grouped by category:

**Account Identifiers & Hierarchy:**

*   **`dim_crm_account_id`**:  The primary key for the account dimension.
*   **`crm_account_name`**: The name of the account in CRM.
*   **`dim_parent_crm_account_id`**:  Foreign key to the parent account in a hierarchical structure.
*   **`parent_crm_account_name`**: Name of the parent account.
*   **`parent_crm_account_sales_segment`**: Sales segment of the parent account.

**Account Demographics:**

*   **`crm_account_employee_count`**: The number of employees at the account.
*   **`crm_account_industry`**: The industry of the account.
*   **`crm_account_gtm_strategy`**: Go-to-market strategy for the account.
*   **`crm_account_focus_account`**: Flag indicating if the account is a focus account.

**Account Health & Engagement:**

*   **`health_number`**: A numerical health score for the account.
*   **`health_score_color`**: A color-coded representation of the health score.
*   **`pte_score`**: Product Expansion score from data science.
*   **`ptc_score`**: Product Contraction score from data science.
*    **`ptp_score`**:Propensity to Purchase score

**Billing & Partner Information:**

*   **`crm_account_billing_country`**: The billing country of the account.
*   **`is_reseller`**: Flag indicating if the account is a reseller.
*   **`is_focus_partner`**: Flag indicating if the account is a focus partner.

**Data Science Scores:**

*   Fields derived from the data science models providing insights into account health and potential.

Here are some example fields with their use cases:

| Field                       | Data Type | Description                                                                                                   | Use Case                                                                                                                                          |
| --------------------------- | --------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `crm_account_name`          | VARCHAR   | The name of the account.                                                                                     | Identifying and labeling accounts in reports.                                                                                                   |
| `crm_account_industry`      | VARCHAR   | The industry the account operates in.                                                                         | Segmenting accounts for targeted marketing campaigns.                                                                                             |
| `crm_account_employee_count` | INTEGER   | The number of employees at the account.                                                                         | Filtering accounts by size for resource allocation.                                                                                             |
| `health_number`             | INTEGER   | A numerical representation of the account's health.                                                            | Prioritizing accounts for customer success outreach.                                                                                            |
| `pte_score`                 | FLOAT     | A score indicating the likelihood of product expansion.                                                         | Identifying accounts for upselling and cross-selling opportunities.                                                                          |
| `crm_account_arr_cohort_month` | DATE      | The month the account joined, based on ARR.                                             | Cohort analysis of customer lifetime value.                                                                                                |
| `crm_account_gtm_strategy`             | VARCHAR | The go-to-market strategy.              | Understand which type of GTM strategy is working or not.                                                                                                |

### Internal Implementation

The creation of `dim_crm_account` involves several steps:

1.  **Data Extraction and Transformation**: The [prep_crm_account](chapter_441.md) model extracts and transforms data from the raw Salesforce Account table, performing data cleaning, standardization, and enrichment.

2.  **Joining with Billing Data**: The [prep_charge_mrr](chapter_445.md) model processes Zuora billing data to calculate MRR and ARR. This data is joined with the transformed account data to add revenue-related information and determine cohort dates.

3.  **Data Science Score Integration**: PTE and PTC scores from data science models are joined to the account data to provide insights into account health and potential.

4.  **Hierarchy Construction**: The table captures hierarchical relationships between accounts, allowing for analysis of parent-child account dynamics. This is achieved by referencing the `dim_parent_crm_account_id` field.

### Example Code

Here's an example of how you might query the `dim_crm_account` table to identify high-potential accounts for an ABM campaign:

```sql
SELECT
  dim_crm_account_id,
  crm_account_name,
  crm_account_industry,
  pte_score,
  crm_account_arr_cohort_month
FROM dim_crm_account
WHERE
  crm_account_industry = 'Technology'
  AND pte_score > 0.7
  AND health_number > 5
```

This query selects accounts in the Technology industry with a PTE score above 0.7 and a health score above 5. The results can then be used to create a targeted ABM campaign.

### Conclusion

The `dim_crm_account` table provides a valuable foundation for understanding and analyzing customer accounts. By consolidating account-level information from various sources, it enables sophisticated marketing and sales analytics, facilitates targeted campaign execution, and supports data-driven decision-making. Its comprehensive structure and integration with other key tables make it an essential component of the marketing data mart.
