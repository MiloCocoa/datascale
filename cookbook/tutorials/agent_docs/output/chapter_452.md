#### 4.5.2. CRM User Daily Snapshot Prep (`prep_crm_user_daily_snapshot`)

The `prep_crm_user_daily_snapshot` model addresses the need for historical CRM user data. Analyzing trends and changes in user attributes over time requires a series of snapshots, rather than just the current state. This model generates daily snapshots of CRM user data, capturing attributes like roles, sales segments, and active status. This is essential for understanding how the user base evolves and for accurate historical reporting.

**Use Case:**

Imagine needing to analyze how sales team composition has changed over the last fiscal year. Specifically, you want to track the number of active users in each sales segment (e.g., SMB, Mid-Market, Enterprise) on a monthly basis. To accomplish this, you need daily snapshots of CRM user data, including their sales segment assignments and active status. You can't rely solely on the current `dim_crm_user` table because it only reflects the latest information.

**Key Functionality:**

The `prep_crm_user_daily_snapshot` model creates these daily snapshots, enabling trend analysis and historical reporting.

**Source Models:**

The `prep_crm_user_daily_snapshot` model pulls data from the following sources:

*   `sfdc_user_snapshots_source` (legacy): Historical snapshots of Salesforce User data. This provides the base for creating daily snapshots.
*   `sfdc_user_roles_source` (raw): Raw data for Salesforce User Roles. This is used to include current information regarding user roles.
*   [dim_date](chapter_471.md): The Date dimension table, used to generate a complete date spine for creating daily snapshots.
*   `sheetload_mapping_sdr_sfdc_bamboohr_source` (raw): Raw data from SDR mappings from SFDC and BambooHR. This sheetload table provides additional attributes and mappings needed for accurate user snapshots.

**Implementation Details:**

The core logic involves joining data from these sources to create a daily snapshot of each CRM user. Since `sfdc_user_snapshots_source` is a legacy table, it's necessary to supplement it with data from other sources to get a full picture of user information at each point in time.

**Example:**

```sql
CREATE TABLE "PROD".common_prep.prep_crm_user_daily_snapshot as
WITH sfdc_user_roles_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_user_roles_source
), dim_date AS (
    SELECT *
    FROM "PROD".common.dim_date
), sfdc_users_source AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_users_source
), sfdc_user_snapshots_source AS (
    SELECT *
    FROM "PROD".legacy.sfdc_user_snapshots_source
)
, sheetload_mapping_sdr_sfdc_bamboohr_source AS (
    SELECT *
    FROM "PREP".sheetload.sheetload_mapping_sdr_sfdc_bamboohr_source
), snapshot_dates AS (
    SELECT *
    FROM dim_date
    WHERE date_actual >= '2020-03-01' and date_actual <= CURRENT_DATE
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
), final AS (
    SELECT
      sfdc_users.user_id                                                                                                              AS dim_crm_user_id,
      sfdc_users.employee_number,
      sfdc_users.name                                                                                                                 AS user_name,
...
```

**Key Transformations:**

*   **Date Spanning:** The model uses the `dim_date` table to generate a complete date spine, ensuring that a snapshot is created for every day within the defined range.
*   **Snapshotting:** Data from `sfdc_user_snapshots_source` is combined with information from other tables to construct a snapshot of each user’s attributes for each date in the date spine.
*   **Attribute Carry-Forward:** For attributes not present in the snapshot source, the model carries forward the most recent known value.

**Output:**

The `prep_crm_user_daily_snapshot` model outputs a table containing daily snapshots of CRM user data.

**Key Fields:**

*   `crm_user_snapshot_id`: A unique identifier for each user snapshot (combination of `dim_crm_user_id` and `snapshot_id`).
*   `snapshot_id`: The date ID representing the date of the snapshot.
*   `snapshot_date`: The actual date of the snapshot.
*   `dim_crm_user_id`: The foreign key to the [CRM User Dimension](chapter_350.md).
*   Other fields from the source models, representing user attributes at the time of the snapshot (e.g., `user_name`, `title`, `crm_user_sales_segment`, `is_active`).

**Downstream Usage:**

This model serves as a crucial input for:

*   [prep_crm_user_hierarchy](chapter_453.md): Used for creating user hierarchies that are time-sensitive for accurate sales and marketing alignment.
*   [prep_crm_account_daily_snapshot](chapter_442.md): Stamps user attributes onto account snapshots for historical analysis.
