## 4.5. CRM User Data Preparation

This section delves into the processes that ready CRM user data for analytical consumption. Accurate reporting hinges on having clean, well-structured user data that correctly reflects roles and organizational hierarchies. The preparatory models described here transform raw Salesforce user data into a usable format for downstream dimension and fact tables.

### Use Case: Understanding Sales Performance by Hierarchy

Imagine a sales manager needing to analyze the performance of their team. They need to filter sales data not only by individual reps but also by different levels within the sales hierarchy (e.g., region, team, individual contributor). To achieve this, we need to:

1.  Clean and standardize raw Salesforce user data.
2.  Establish the hierarchical relationships between users (manager-employee).
3.  Capture the historical context of these relationships, as they change over time.

### Core Models

The CRM user data preparation relies on these key models:

*   **`prep_crm_user`**: Cleans and transforms raw Salesforce User data, incorporating role hierarchy, sales segmentation, and manager information for the current state.
*   **`prep_crm_user_daily_snapshot`**: Generates daily snapshots of CRM user data for historical analysis, including role hierarchy and sales segmentation.
*   **`prep_crm_user_hierarchy`**: Defines and unions various CRM user hierarchies (geo-based and role-based) for different fiscal years, incorporating data from daily snapshots, sales funnel targets, and opportunities, ensuring accurate historical reporting for sales and marketing alignment.

### 4.5.1. `prep_crm_user`

This model's primary purpose is to create a clean, current view of CRM users. It addresses common data quality issues and enriches the raw data with calculated fields.

*   **Purpose**: Cleans and transforms raw Salesforce User data, including role hierarchy, sales segmentation, and manager information for the current state.
*   **Sources**:
    *   `sfdc_users_source` (raw): Raw user data from Salesforce.
    *   `sfdc_user_roles_source` (raw): Raw user role data from Salesforce.
    *   `dim_date` ([Date Dimension](chapter_471.md)):  For temporal attributes.
    *   `sheetload_mapping_sdr_sfdc_bamboohr_source` (raw):  Mapping for SDRs from SFDC to BambooHR for SDR-specific attributes.
*   **Output**: A clean, current view of CRM users with detailed attributes, ready for [CRM User Dimension](chapter_350.md).

**Key Transformations:**

*   **Data Cleaning**: Handles inconsistencies in naming conventions, data types, and missing values.
*   **Role Hierarchy**: Incorporates the user's role and their position within the role hierarchy.
*   **Sales Segmentation**:  Assigns users to specific sales segments for reporting and analysis.
*   **SDR Mapping**:  Uses the `sheetload_mapping_sdr_sfdc_bamboohr_source` table to add SDR-specific information (segment, region).

**Example Code Snippet:**

```sql
 SELECT
      sfdc_users.user_id                                                                                                              AS dim_crm_user_id,
      sfdc_users.employee_number,
      sfdc_users.name                                                                                                                 AS user_name,
      sfdc_users.title,
      sfdc_users.department,
      sfdc_users.team,
      sfdc_users.manager_id,
      sfdc_users.manager_name,
      sfdc_users.user_email,
      sfdc_users.is_active,
      sfdc_users.start_date,
      ...
    FROM sfdc_users
    LEFT JOIN sfdc_user_roles_source
      ON sfdc_users.user_role_id = sfdc_user_roles_source.id
    LEFT JOIN sheetload_mapping_sdr_sfdc_bamboohr_source
      ON sfdc_users.user_id = sheetload_mapping_sdr_sfdc_bamboohr_source.user_id
```

This code snippet illustrates how `prep_crm_user` joins raw user data with role and SDR mapping tables to enrich the user records.

### 4.5.2. `prep_crm_user_daily_snapshot`

To analyze sales performance over time, we need to capture changes in user attributes (e.g., role, segment) and hierarchy. This is where the daily snapshot model comes in.

*   **Purpose**: Generates daily snapshots of CRM user data for historical analysis, including role hierarchy and sales segmentation.
*   **Sources**:
    *   `sfdc_user_snapshots_source` (legacy): Historical snapshots of Salesforce user data.
    *   `sfdc_user_roles_source` (raw): Raw user role data from Salesforce.
    *   `dim_date` ([Date Dimension](chapter_471.md)): For temporal attributes.
    *   `sheetload_mapping_sdr_sfdc_bamboohr_source` (raw): Mapping for SDRs from SFDC to BambooHR.
*   **Output**: Historical snapshots of CRM user information, used in `prep_crm_user_hierarchy` ([CRM User Hierarchy Prep](chapter_453.md)) and `prep_crm_account_daily_snapshot` ([CRM Account Daily Snapshot Prep](chapter_442.md)).

**Key Transformations**:

*   **Daily Snapshots**: Creates a daily record of each user's attributes.
*   **Historical Context**:  Allows tracking changes in user roles, segments, and manager assignments over time.

**Example Code Snippet:**

```sql
SELECT
      sfdc_users.crm_user_snapshot_id,
      sfdc_users.snapshot_id,
      sfdc_users.snapshot_date,
      sfdc_users.user_id                                                                                                              AS dim_crm_user_id,
      sfdc_users.employee_number,
      sfdc_users.name                                                                                                                 AS user_name,
      sfdc_users.title,
      ...
    FROM
      sfdc_user_snapshots_source
      INNER JOIN snapshot_dates
        ON snapshot_dates.date_actual >= sfdc_user_snapshots_source.dbt_valid_from
        AND snapshot_dates.date_actual < COALESCE(sfdc_user_snapshots_source.dbt_valid_to, '9999-12-31'::TIMESTAMP)
```

This code snippet illustrates how `prep_crm_user_daily_snapshot` joins the raw user snapshot data with a date dimension to create a daily record.

### 4.5.3. `prep_crm_user_hierarchy`

This model unifies CRM user hierarchies (geo-based and role-based) for reporting.

*   **Purpose**: Defines and unions various CRM user hierarchies (geo-based and role-based) for different fiscal years, incorporating data from daily snapshots, sales funnel targets, and opportunities, ensuring accurate historical reporting for sales and marketing alignment.
*   **Sources**:
    *   `dim_date` ([Date Dimension](chapter_471.md)): For temporal attributes.
    *   `prep_crm_user_daily_snapshot` ([CRM User Daily Snapshot Prep](chapter_452.md)): Daily snapshots of CRM user data.
    *   `prep_crm_user` ([CRM User Prep](chapter_451.md)): Cleaned CRM user data.
    *   `prep_crm_account_daily_snapshot` ([CRM Account Daily Snapshot Prep](chapter_442.md)): Daily snapshots of CRM account data.
    *   `prep_crm_opportunity` ([CRM Opportunity Prep](chapter_461.md)): Cleaned CRM opportunity data.
    *   `prep_sales_funnel_target` ([Sales Funnel Target Prep](chapter_463.md)): Sales targets data.
    *   `prep_crm_person` ([CRM Person Prep](chapter_411.md)): Enriched CRM person data.
*   **Output**: A unified hierarchy for CRM users based on fiscal year and role/geo, providing the `dim_crm_user_hierarchy_id` for use in various downstream models.

**Key Transformations:**

*   **Hierarchy Definition**: Establishes relationships between users based on roles, geography, and reporting structures.
*   **Fiscal Year Alignment**:  Creates separate hierarchies for different fiscal years to account for organizational changes.
*   **Unification**: Combines geo-based and role-based hierarchies.

**Example Code Snippet:**

```sql
WITH user_geo_hierarchy_source AS (
  SELECT DISTINCT
    dim_date.fiscal_year,
    prep_crm_user_daily_snapshot.crm_user_sales_segment AS user_segment,
    prep_crm_user_daily_snapshot.crm_user_geo           AS user_geo,
    prep_crm_user_daily_snapshot.crm_user_region        AS user_region,
    prep_crm_user_daily_snapshot.crm_user_area          AS user_area,
    prep_crm_user_daily_snapshot.crm_user_business_unit AS user_business_unit,
    prep_crm_user_daily_snapshot.dim_crm_user_hierarchy_sk,
    NULL                                                AS user_role_name,
    NULL                                                AS user_role_level_1,
    NULL                                                AS user_role_level_2,
    NULL                                                AS user_role_level_3,
    NULL                                                AS user_role_level_4,
    NULL                                                AS user_role_level_5
  FROM prep_crm_user_daily_snapshot
  INNER JOIN dim_date
    ON prep_crm_user_daily_snapshot.snapshot_id = dim_date.date_id
  WHERE prep_crm_user_daily_snapshot.crm_user_sales_segment IS NOT NULL
    AND prep_crm_user_daily_snapshot.crm_user_geo IS NOT NULL
    AND prep_crm_user_daily_snapshot.crm_user_region IS NOT NULL
    AND prep_crm_user_daily_snapshot.crm_user_area IS NOT NULL
    AND IFF(dim_date.fiscal_year > 2023, prep_crm_user_daily_snapshot.crm_user_business_unit IS NOT NULL, 1 = 1) -- with the change in structure, business unit must be present after FY23
    AND IFF(dim_date.fiscal_year < dim_date.current_fiscal_year, dim_date.date_actual = dim_date.last_day_of_fiscal_year, dim_date.date_actual = dim_date.current_date_actual) -- take only the last valid hierarchy of the fiscal year for previous fiscal years
    AND dim_date.fiscal_year < 2025 -- stop geo hierarchy after 2024
    AND prep_crm_user_daily_snapshot.is_active = TRUE
)
```

This code snippet shows how `prep_crm_user_hierarchy` builds a geo-based hierarchy from daily user snapshots, taking into account fiscal year and active status. A similar code block would build the role-based hierarchy.

**Implementation Details**:

*   **Hierarchy Source Combination**: It uses a combination of snapshot data, live data, sheetload data, and stamped opportunity data.
*   **Fiscal Year Logic**: Each year potentially has a different structure, with 2024 being the turning point.

```mermaid
graph LR
subgraph Geo-Based Hierarchy (Pre-FY25)
    A[Segment] --> B(Geo)
    B --> C{Region}
    C --> D[Area]
end

subgraph Role-Based Hierarchy (FY25+)
    E[Role Level 1] --> F(Role Level 2)
    F --> G{Role Level 3}
    G --> H[Role Level 4]
    H --> I(Role Level 5)
end

J[Prep CRM User Daily Snapshot] -- Data Source --> A
J -- Data Source --> E
```

This diagram illustrates the two main types of user hierarchies (geo-based and role-based), which are combined by `prep_crm_user_hierarchy`.

### Central Table: `dim_crm_user`

The final output of this preparation process feeds into the `dim_crm_user` ([CRM User Dimension](chapter_350.md)) table. This table serves as the single source of truth for CRM user information, incorporating all the transformations and hierarchy definitions. By joining other tables to `dim_crm_user` using the `dim_crm_user_id`, it's possible to slice and dice metrics by any level of the user hierarchy.

In conclusion, these CRM user data preparation models address a common analytics challenge: accurately reflecting organizational structure and changes over time. By combining raw data with carefully defined transformations and hierarchy definitions, these models enable robust and insightful reporting on sales and marketing performance.
