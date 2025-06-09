### 4.5.1. CRM User Prep (`prep_crm_user`)

The `prep_crm_user` model is a crucial component in the overall data pipeline, focusing on preparing CRM user data for consumption by downstream models, particularly the [CRM User Dimension](chapter_305.md). It addresses the challenge of transforming raw, often inconsistent Salesforce user data into a clean, standardized, and enriched dataset. This ensures accurate reporting and analysis related to user activities, roles, and organizational hierarchies.

**Use Case:**

A common use case is to analyze sales performance by user segment. To achieve this, you need a reliable table that contains current information about each CRM user, including their role, segment, and reporting structure. The `prep_crm_user` model directly addresses this need by providing a consolidated and cleaned view of user data.

**High-Level Explanation:**

The `prep_crm_user` model performs the following key functions:

*   **Data Consolidation:** It gathers user data from the raw Salesforce `sfdc_users_source` table, along with role information from `sfdc_user_roles_source` and SDR mapping data from `sheetload_mapping_sdr_sfdc_bamboohr_source`.
*   **Data Cleaning and Transformation:** It standardizes the data by cleaning names, extracting relevant attributes, and transforming data types.
*   **Data Enrichment:** It enriches the user data by incorporating role hierarchy, sales segmentation, and manager information.

**Source Tables:**

The model relies on the following source tables:

*   **`sfdc_users_source` (raw):** This table contains the raw Salesforce User data, providing core attributes like employee number, name, title, department, and email.
*   **`sfdc_user_roles_source` (raw):** This table contains the raw Salesforce User Role data, defining user roles and their hierarchical relationships.
*   **`dim_date` ([Date Dimension](chapter_407.md)):** While not a direct source, the Date Dimension is used to derive the current fiscal year.
*   **`sheetload_mapping_sdr_sfdc_bamboohr_source` (raw):** This table provides a mapping between SDRs in Salesforce and BambooHR, enabling enrichment of user data with SDR-specific attributes.

**Implementation Details:**

Here's a breakdown of the model's implementation:

```sql
CREATE TABLE "PROD".common_prep.prep_crm_user as
WITH sfdc_user_roles_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_user_roles_source
), dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), sfdc_users_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_users_source
), sheetload_mapping_sdr_sfdc_bamboohr_source AS (
    SELECT *
    FROM "PREP".sheetload.sheetload_mapping_sdr_sfdc_bamboohr_source
), sfdc_users AS (
    SELECT
        *
    FROM
      sfdc_users_source
), current_fiscal_year AS (
    SELECT
      fiscal_year
    FROM dim_date
    WHERE date_actual = CURRENT_DATE()
)
```

This section defines the source tables and CTEs (Common Table Expressions) that are used throughout the transformation process.

```sql
, final AS (
    SELECT
      sfdc_users.user_id AS dim_crm_user_id,
      sfdc_users.employee_number,
      sfdc_users.name AS user_name,
      sfdc_users.title,
      sfdc_users.department,
      sfdc_users.team,
      sfdc_users.manager_id,
      sfdc_users.manager_name,
      sfdc_users.user_email,
      sfdc_users.is_active,
      sfdc_users.start_date,
      sfdc_users.ramping_quota,
      sfdc_users.user_timezone,
      sfdc_users.user_role_id,
      md5(cast(coalesce(cast(sfdc_user_roles_source.name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS dim_crm_user_role_name_id,
      sfdc_user_roles_source.name AS user_role_name,
      sfdc_users.user_role_type AS user_role_type,
      ...
    FROM sfdc_users
    LEFT JOIN sfdc_user_roles_source
      ON sfdc_users.user_role_id = sfdc_user_roles_source.id
    LEFT JOIN sheetload_mapping_sdr_sfdc_bamboohr_source
      ON sfdc_users.user_id = sheetload_mapping_sdr_sfdc_bamboohr_source.user_id
    LEFT JOIN current_fiscal_year
)
SELECT
      *,
      '@mcooperDD'::VARCHAR       AS created_by,
      '@chrissharp'::VARCHAR       AS updated_by,
      '2021-01-12'::DATE        AS model_created_date,
      '2024-02-28'::DATE        AS model_updated_date,
      CURRENT_TIMESTAMP()               AS dbt_updated_at,
            CURRENT_TIMESTAMP()               AS dbt_created_at
    FROM final;
```

This section performs the core data transformation and enrichment logic, joining the source tables and deriving new fields based on the combined data. Key transformations include:

*   **Joining User and Role Data:** The `sfdc_users` table is joined with the `sfdc_user_roles_source` table to incorporate user role information.
*   **Incorporating SDR Mapping:** The `sheetload_mapping_sdr_sfdc_bamboohr_source` table is used to map Salesforce users to SDR information, adding SDR-specific attributes to the user data.
*   **Calculating Hierarchy IDs:** Logic is implemented to calculate the `dim_crm_user_hierarchy_sk` based on user role names and the current fiscal year.

**Key Fields:**

The model outputs a comprehensive set of user attributes, including:

*   `dim_crm_user_id`: The primary key for the CRM user.
*   `employee_number`: The employee number from Salesforce.
*   `user_name`: The user's full name.
*   `title`: The user's job title.
*   `department`: The user's department.
*   `team`: The user's team.
*   `manager_name`: The name of the user's manager.
*   `user_role_name`: The user's role name.
*   `crm_user_sales_segment`: The user's sales segment.
*   `crm_user_geo`: The user's geographic region.
*   `is_active`: Flag indicating whether the user is active.

**Output Table:**

The model outputs a single table named `prep_crm_user`, which is stored in the `common_prep` schema. This table is designed to provide a clean, current view of CRM users with detailed attributes, ready for use by downstream models.

**Downstream Models:**

The `prep_crm_user` model directly feeds into the [CRM User Dimension](chapter_305.md) (`dim_crm_user`), providing the data necessary to populate this dimension table. It is also utilized in the [CRM User Hierarchy Prep](chapter_405.md) model (`prep_crm_user_hierarchy`).

**Conclusion:**

The `prep_crm_user` model plays a vital role in ensuring data quality and consistency for CRM user data. By consolidating, cleaning, and enriching raw Salesforce data, this model enables accurate and reliable analysis of user activities, roles, and organizational hierarchies, ultimately supporting better decision-making in sales and marketing.
