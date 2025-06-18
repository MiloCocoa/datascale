## 4.5.3. CRM User Hierarchy Prep (`prep_crm_user_hierarchy`)

In many analytical scenarios, it's crucial to understand how CRM users are structured within the organization. This structure often dictates reporting lines, sales territories, and overall performance evaluation. The `prep_crm_user_hierarchy` model addresses this need by creating a unified hierarchy that combines geographical and role-based organizational structures, enabling accurate historical reporting and alignment between sales and marketing efforts.

**Use Case: Analyzing Sales Performance by Region and Role Over Time**

Imagine you need to analyze sales performance in the EMEA region, broken down by different sales roles (e.g., Account Executive, Sales Manager) over the past few fiscal years. You want to track how performance has changed as the organizational structure evolved. This requires a model that captures both the geographical regions and the roles of CRM users, as well as how these structures have changed over time. The `prep_crm_user_hierarchy` model makes this analysis possible.

### Purpose

The primary purpose of the `prep_crm_user_hierarchy` model is to:

*   **Define and unify CRM user hierarchies:** Create a single, consistent view of the organizational structure, accommodating both geographical and role-based hierarchies.
*   **Incorporate historical data:** Capture changes in the hierarchy over different fiscal years, ensuring accurate historical reporting.
*   **Support sales and marketing alignment:** Provide a foundation for analyzing performance and aligning strategies across sales and marketing teams.

### Sources

To achieve these goals, `prep_crm_user_hierarchy` draws data from the following sources:

*   **[dim_date](chapter_471.md):** Provides fiscal year information and date attributes for historical analysis.
*   **[prep_crm_user_daily_snapshot](chapter_452.md):** Captures daily snapshots of CRM user data, including roles and geographical assignments.
*   **[prep_crm_user](chapter_451.md):** Contains the current state of CRM user attributes.
*   **[prep_crm_account_daily_snapshot](chapter_442.md):** Provides daily snapshots of CRM account data, used to determine account-based hierarchies.
*   **[prep_crm_opportunity](chapter_461.md):** Includes opportunity data stamped with user hierarchy information.
*   **[prep_sales_funnel_target](chapter_463.md):** Contains sales targets aligned with fiscal periods and user hierarchies.
*   **[prep_crm_person](chapter_411.md):** Used to consolidate information from various CRM sources and enrich it with activity and touchpoint details.

### Implementation Details

The model operates in several key steps:

1.  **Data Extraction and Transformation:**
    *   Extract relevant fields from the source models, including fiscal year, user attributes (segment, geo, region, area, business unit), role information, and hierarchy keys.
    *   Handles different hierarchy types including user geo and user role.
    *   Applies transformations such as uppercasing for standardization.
2.  **Hierarchy Definition:**
    *   Unions various CRM user hierarchies (geo-based and role-based) for different fiscal years.
    *   Considers the structure changes. For instance, before FY24, the hierarchy only uncluded segment, geo, region, and area. In FY25, the model switched to a role-based hierarchy.
3.  **Hierarchy Unification**
    *   The model first defines hierarchy sks (Surrogate Keys) for different fiscal years.
    *   Then unions them in `final_unioned`.
4.  **Hierarchy Combination**
    *   The model then creates the final hierarchy with the model `final`.
    *   It merges role and geo based dimensions to it, such as `crm_user_business_unit`, `crm_user_sales_segment`, etc.

### Output

The `prep_crm_user_hierarchy` model outputs a unified table containing the following key fields:

*   **`dim_crm_user_hierarchy_id`:** A unique identifier for each distinct user hierarchy combination. This is the main identifier to be used in other models.
*   **`dim_crm_user_hierarchy_sk`:** The snapshot-based surrogate key.
*   **`fiscal_year`:** The fiscal year to which the hierarchy applies.
*   **`crm_user_business_unit`:** The CRM user's business unit.
*   **`crm_user_sales_segment`:** The CRM user's sales segment.
*   **`crm_user_geo`:** The CRM user's geographical region.
*   **`crm_user_region`:** The CRM user's region.
*   **`crm_user_area`:** The CRM user's area.
*   **`crm_user_role_name`**: The CRM user's role name.
*   **`crm_user_role_level_1` to `crm_user_role_level_5`:** The different role levels.
*   **`crm_user_sales_segment_region_grouped`:** A grouped field of user segment and region.
*   **`is_current_crm_user_hierarchy`:** A flag indicating if this row represents the current user hierarchy.

This output provides a comprehensive and historically accurate view of CRM user hierarchies, enabling detailed analysis and reporting.

### Example

```sql
CREATE TABLE "PROD".common_prep.prep_crm_user_hierarchy as
WITH dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), prep_crm_user_daily_snapshot AS (
    SELECT *
    FROM "PROD".common_prep.prep_crm_user_daily_snapshot
), ...
```

This snippet shows how the model ingests prepared CRM user data, enhancing it with fiscal year and hierarchy information. This allows you to then use the output `dim_crm_user_hierarchy_id` to join to fact tables and perform perform your analysis. For example, this is how you would find your average net ARR amount for each role at the last quarter:

```sql
SELECT
    dim_crm_user_hierarchy.crm_user_role_name,
    AVG(fct_opportunity.net_arr)
FROM fct_opportunity
JOIN dim_crm_user_hierarchy ON fct_opportunity.dim_crm_user_hierarchy_id = dim_crm_user_hierarchy.dim_crm_user_hierarchy_id
WHERE dim_crm_user_hierarchy.fiscal_year = 2024
GROUP BY 1
```

### Benefits

By using the `prep_crm_user_hierarchy` model, you can:

*   **Improve Reporting Accuracy:** Ensure that reports accurately reflect organizational structures and changes over time.
*   **Enable Deeper Analysis:** Analyze sales performance, pipeline generation, and other key metrics by region, role, and organizational hierarchy.
*   **Facilitate Strategic Alignment:** Align sales and marketing strategies based on a clear understanding of organizational structure and performance.
