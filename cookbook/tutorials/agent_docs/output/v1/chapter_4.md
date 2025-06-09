## Chapter 4. Preparation Tables

This chapter details the creation of various preparation tables that serve as sources for fact and dimension tables within the data warehouse. Each section will describe the source tables, key data transformations applied, the final selection of fields, and the resulting table schema.

### Common Elements

Each preparation table documentation includes the following common elements:

*   **Source Tables:**  A list of the source tables used in the creation of the preparation table.
*   **Data Transformations:**  A detailed explanation of the data cleaning, transformation, and enrichment steps performed.  This includes any calculations, mappings, or data type conversions.
*   **Final Selection:**  Describes the final set of columns selected for inclusion in the preparation table.  This may involve renaming, reordering, or excluding columns from the source tables.
*   **Table Schema:** Presents the schema of the resulting preparation table, including column names, data types, and descriptions.

### 4.1. prep_crm_attribution_touchpoint

*   **Source:** `sfdc_bizible_attribution_touchpoint_source`
*   **Key transformations:**

    *   **URL Cleaning:** Cleans the `bizible_form_url` column by removing the ".html" extension and converting it to lowercase. This standardization is done using the following SQL:

        ```sql
        REPLACE(LOWER(bizible_form_url),'.html','') AS bizible_form_url_clean
        ```

    *   **Touchpoint Offer Type Categorization:** Categorizes touchpoints based on `bizible_touchpoint_type`, `bizible_ad_campaign_name`, and `bizible_form_url_clean` to derive `touchpoint_offer_type` and `touchpoint_offer_type_grouped`. This is achieved through a series of `CASE` statements, as seen in the example below.  These `CASE` statements cover various scenarios, mapping specific URL patterns and campaign names to predefined offer types.

        ```sql
        CASE
          WHEN bizible_touchpoint_type = 'Web Chat'
            OR LOWER(bizible_ad_campaign_name) LIKE '%webchat%'
            OR bizible_ad_campaign_name = 'FY24_Qualified.com web conversation'
            THEN 'Web Chat'
          WHEN bizible_touchpoint_type IN ('Web Form', 'marketotouchpoin')
            AND bizible_form_url_clean IN ('gitlab.com/-/trial_registrations/new',
                                    'gitlab.com/-/trial_registrations',
                                    'gitlab.com/-/trials/new')
            THEN 'GitLab Dot Com Trial'
        ...
        ELSE 'Other'
        END AS touchpoint_offer_type_wip
        ```

    *   Pathfactory Content Type Mapping: Uses `sheetload_bizible_to_pathfactory_mapping` to map PathFactory URLs to specific content types based on a lookup of the cleaned Bizible form URL.
*   **Final Selection:** The query selects all fields from the source table (`sfdc_bizible_attribution_touchpoint_source`) and appends the derived `bizible_form_url_clean`, `touchpoint_offer_type`, and `touchpoint_offer_type_grouped` columns.
*   **Table Schema:**

    | Column Name                     | Data Type | Description                                                                                                                               |
    | ------------------------------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
    | touchpoint_id                   | VARCHAR   | Unique identifier for the touchpoint.                                                                                                     |
    | campaign_id                     | VARCHAR   | Foreign key referencing the Campaign dimension.                                                                                           |
    | bizible_touchpoint_date         | DATE      | Date of the Bizible touchpoint.                                                                                                          |
    | bizible_touchpoint_position     | VARCHAR   | Position of the touchpoint in the customer journey (e.g., First Touch, Lead Creation).                                                   |
    | bizible_touchpoint_source       | VARCHAR   | Source of the touchpoint (e.g., Web, Email).                                                                                               |
    | source_type                     | VARCHAR   | Type of the touchpoint source.                                                                                                            |
    | bizible_touchpoint_type         | VARCHAR   | Type of the Bizible touchpoint (e.g., Web Form, Web Chat).                                                                                  |
    | bizible_ad_campaign_name        | VARCHAR   | Name of the ad campaign associated with the touchpoint.                                                                                    |
    | bizible_ad_content              | VARCHAR   | Content of the ad associated with the touchpoint.                                                                                         |
    | bizible_ad_group_name           | VARCHAR   | Name of the ad group associated with the touchpoint.                                                                                     |
    | bizible_form_url                | VARCHAR   | URL of the form associated with the touchpoint.                                                                                           |
    | bizible_form_url_raw            | VARCHAR   | Raw URL of the form associated with the touchpoint.                                                                                       |
    | bizible_landing_page            | VARCHAR   | Landing page URL associated with the touchpoint.                                                                                        |
    | bizible_landing_page_raw        | VARCHAR   | Raw landing page URL associated with the touchpoint.                                                                                    |
    | bizible_marketing_channel       | VARCHAR   | Bizible marketing channel.                                                                                                              |
    | bizible_marketing_channel_path  | VARCHAR   | Path of the Bizible marketing channel.                                                                                                    |
    | bizible_medium                  | VARCHAR   | Medium of the Bizible touchpoint.                                                                                                        |
    | bizible_referrer_page           | VARCHAR   | Referrer page URL associated with the touchpoint.                                                                                        |
    | bizible_referrer_page_raw       | VARCHAR   | Raw referrer page URL associated with the touchpoint.                                                                                    |
    | bizible_salesforce_campaign     | VARCHAR   | Salesforce campaign associated with the touchpoint.                                                                                       |
    | utm_budget                      | VARCHAR   | UTM parameter for budget.                                                                                                                 |
    | utm_offersubtype                | VARCHAR   | UTM parameter for offer subtype.                                                                                                          |
    | utm_offertype                   | VARCHAR   | UTM parameter for offer type.                                                                                                             |
    | utm_targetregion                | VARCHAR   | UTM parameter for target region.                                                                                                          |
    | utm_targetsubregion             | VARCHAR   | UTM parameter for target subregion.                                                                                                       |
    | utm_targetterritory             | VARCHAR   | UTM parameter for target territory.                                                                                                       |
    | utm_usecase                     | VARCHAR   | UTM parameter for use case.                                                                                                              |
    | utm_content                     | VARCHAR   | UTM parameter for content.                                                                                                                |
    | is_deleted                      | BOOLEAN   | Indicates if the touchpoint has been deleted.                                                                                             |
    | createddate                     | TIMESTAMP | Timestamp when the record was created.                                                                                                      |
    | bizible_form_url_clean          | VARCHAR   | Cleaned and lowercased Bizible form URL.                                                                                                   |
    | touchpoint_offer_type_wip         | VARCHAR   | Interim offer type                                                                                                                            |
    | pathfactory_content_type          | VARCHAR   | Interim offer type                                                                                                                            |
    | touchpoint_offer_type           | VARCHAR   | Derived touchpoint offer type based on URL and campaign information.                                                                       |
    | touchpoint_offer_type_grouped   | VARCHAR   | Grouped touchpoint offer type for higher-level analysis.                                                                                 |
    | created_by                   | VARCHAR   | User that created the record                                                                                                                                     |
    | updated_by                   | VARCHAR   | User that updated the record                                                                                                                                       |
    | model_created_date                     | DATE   | Date that the model was created.                                                                                                      |
    | model_updated_date        | DATE      | Date that the model was updated.                                                                                             |
    | dbt_updated_at      | TIMESTAMP    | dbt Timestamp                                                                                                            |
    | dbt_created_at | TIMESTAMP   |   dbt Timestamp                                                                                                        |

### 4.2. prep_date

*   **Source:** `date_details_source`
*   **Key transformations:**

    *   The prep_date table primarily selects and transforms data from a single source table, `date_details_source`.

    *   **Date ID Conversion:** Converts the `date_actual` field to a numeric `date_id` in YYYYMMDD format.

        ```sql
        TO_NUMBER(TO_CHAR(date_actual::DATE,'YYYYMMDD'),'99999999') AS date_id
        ```
*   **Final Selection:** The query selects all fields from the source table without any filtering, relying on `date_details_source` for the quality of information
*   **Table Schema:**

    | Column Name                 | Data Type | Description                                                      |
    | --------------------------- | --------- | ---------------------------------------------------------------- |
    | date_id                     | NUMBER    | Unique identifier for the date in YYYYMMDD format.                |
    | date_day                    | DATE      | Actual date.                                                     |
    | date_actual                 | DATE      | Actual date.                                                     |
    | day_name                    | VARCHAR   | Name of the day (e.g., Monday).                                 |
    | month_actual                | NUMBER    | Month of the year (1-12).                                        |
    | year_actual                 | NUMBER    | Year.                                                            |
    | quarter_actual              | NUMBER    | Quarter of the year (1-4).                                       |
    | day_of_week                 | NUMBER    | Day of the week (1-7).                                           |
    | first_day_of_week           | DATE      | First day of the week.                                           |
    | week_of_year                | NUMBER    | Week of the year (1-53).                                         |
    | day_of_month                | NUMBER    | Day of the month (1-31).                                         |
    | day_of_quarter              | NUMBER    | Day of the quarter.                                              |
    | day_of_year                 | NUMBER    | Day of the year.                                                 |
    | fiscal_year                 | NUMBER    | Fiscal year.                                                     |
    | fiscal_quarter              | NUMBER    | Fiscal quarter.                                                  |
    | day_of_fiscal_quarter       | NUMBER    | Day of the fiscal quarter.                                       |
    | day_of_fiscal_year          | NUMBER    | Day of the fiscal year.                                          |
    | month_name                  | VARCHAR   | Name of the month (e.g., January).                               |
    | first_day_of_month          | DATE      | First day of the month.                                          |
    | last_day_of_month           | DATE      | Last day of the month.                                           |
    | first_day_of_year           | DATE      | First day of the year.                                           |
    | last_day_of_year            | DATE      | Last day of the year.                                            |
    | first_day_of_quarter        | DATE      | First day of the quarter.                                        |
    | last_day_of_quarter         | DATE      | Last day of the quarter.                                         |
    | first_day_of_fiscal_quarter | DATE      | First day of the fiscal quarter.                                 |
    | last_day_of_fiscal_quarter  | DATE      | Last day of the fiscal quarter.                                  |
    | first_day_of_fiscal_year   | DATE      | First day of the fiscal year.                                   |
    | last_day_of_fiscal_year    | DATE      | Last day of the fiscal year.                                    |
    | week_of_fiscal_year        | NUMBER    | Week of the fiscal year.                                         |
    | week_of_fiscal_quarter     | NUMBER    | Week of the fiscal quarter.                                      |
    | month_of_fiscal_year        | NUMBER    | Month of the fiscal year.                                        |
    | last_day_of_week           | DATE      | Last day of the week.                                            |
    | quarter_name                | VARCHAR   | Name of the quarter (e.g., 2023-Q1).                            |
    | fiscal_quarter_name         | VARCHAR   | Name of the fiscal quarter.                                      |
    | fiscal_quarter_name_fy      | VARCHAR   | Name of the fiscal quarter with fiscal year.                      |
    | fiscal_quarter_number_absolute| NUMBER    | Absolute number of the Fiscal quarter           |
    | fiscal_month_name           | VARCHAR   | Name of the fiscal month  |
        | fiscal_month_name_fy           | VARCHAR   | Name of the fiscal month with fiscal year                                             |
    | holiday_desc                | VARCHAR   | Description of any holiday on that date.                        |
    | is_holiday                  | BOOLEAN   | Indicates if the date is a holiday.                             |
    | last_month_of_fiscal_quarter | DATE      | Last month of the fiscal quarter                       |
        | is_first_day_of_last_month_of_fiscal_quarter                 | BOOLEAN   |                                         |
    | last_month_of_fiscal_year | DATE      | Last month of the fiscal year                       |
    | is_first_day_of_last_month_of_fiscal_year                  | BOOLEAN   |                                              |
    | snapshot_date_fpa | DATE      |                        |
    | snapshot_date_fpa_fifth                  | BOOLEAN   |                                            |
    | snapshot_date_billings | DATE      |               |
    | days_in_month_count                 | BOOLEAN   |                                            |
    | days_in_fiscal_quarter_count                  | BOOLEAN   |                    |
    | week_of_month_normalised | BOOLEAN      |               |
    | day_of_fiscal_quarter_normalised | BOOLEAN      |                                                                |
    | week_of_fiscal_quarter_normalised  | BOOLEAN   |                            |
    | day_of_fiscal_year_normalised   | BOOLEAN   |                               |
    | is_first_day_of_fiscal_quarter_week   | BOOLEAN   |                       |
    | days_until_last_day_of_month| NUMBER   |      |
    | current_date_actual| NUMBER   |      |
    | current_day_name   | NUMBER   |            |
    | current_first_day_of_week   | NUMBER   |                     |
    | current_day_of_fiscal_quarter_normalised      | NUMBER   |                                               |
    | current_week_of_fiscal_quarter_normalised| NUMBER   |      |
    | current_week_of_fiscal_quarter| NUMBER   |  |
    | current_fiscal_year      | NUMBER   |              |
    | current_first_day_of_fiscal_year| NUMBER   |                                                   |
    | current_fiscal_quarter_name_fy| NUMBER   |              |
    | current_first_day_of_month| NUMBER   |              |
    | current_first_day_of_fiscal_quarter| NUMBER   |
    | current_day_of_month| NUMBER   |                  |
    | current_day_of_fiscal_quarter| NUMBER   |        |
    | current_day_of_fiscal_year| NUMBER   |                      |
    | is_fiscal_month_to_date| NUMBER   |                     |
    | is_fiscal_quarter_to_date| NUMBER   |             |
    | is_fiscal_year_to_date| NUMBER   |                    |
    | fiscal_days_ago| NUMBER   |                              |
    | fiscal_weeks_ago| NUMBER   |                          |
    | fiscal_months_ago| NUMBER   |                              |
    | fiscal_quarters_ago| NUMBER   |               |
    | fiscal_years_ago| NUMBER   |                         |
    | is_current_date | BOOLEAN   |              |
    | created_by                   | VARCHAR   |              |
    | updated_by                   | VARCHAR   |              |
    | model_created_date                     | DATE   |              |
    | model_updated_date        | DATE      |               |
    | dbt_updated_at      | TIMESTAMP    |                       |
    | dbt_created_at | TIMESTAMP   |              |

### 4.3. prep_crm_user_hierarchy

*   **Source:** `prep_crm_user_daily_snapshot`, `prep_crm_user`, `prep_crm_account_daily_snapshot`, `prep_sales_funnel_target`, `prep_crm_person`
*   **Key transformations:**

    *   **Unioning of User and Account Hierarchies:** Combines user-based and account-based hierarchies into a single table.
    *   **Fiscal Year Alignment:** The table is partitioned by fiscal year to ensure consistency in hierarchy definitions over time.
    *   **Handling of Historical Data:**  For previous fiscal years, the last valid hierarchy configuration is selected to maintain data integrity.
    *   **Hierarchy Logic Changes:** Incorporates logic to manage hierarchy changes, such as the transition from geo-based to role-based hierarchies in FY25.
*   **Final Selection:**

    *   Key identifiers and surrogate keys:
        *   `dim_crm_user_hierarchy_id`
        *    `dim_crm_user_hierarchy_sk`
    *   Hierarchical levels:
        *   `crm_user_business_unit`
        *    `crm_user_sales_segment`
        *   `crm_user_geo`
        *   `crm_user_region`
        *   `crm_user_area`
        *   `crm_user_role_name`
        *   `crm_user_role_level_1` through `crm_user_role_level_5`

*   **Table Schema:**

    | Column Name                           | Data Type | Description                                                                         |
    | ------------------------------------- | --------- | ----------------------------------------------------------------------------------- |
    | dim_crm_user_hierarchy_id             | VARCHAR   | Surrogate key for the CRM User Hierarchy dimension.                               |
    | dim_crm_user_hierarchy_sk             | VARCHAR   | Natural key used to construct hierarchy                                              |
    | fiscal_year                           | NUMBER    | Fiscal year of the hierarchy.                                                       |
    | crm_user_business_unit                | VARCHAR   | Business unit of the CRM user.                                                      |
    | dim_crm_user_business_unit_id         | VARCHAR   | Surrogate key for the CRM User Business Unit dimension.                             |
    | crm_user_sales_segment                | VARCHAR   | Sales segment of the CRM user.                                                      |
    | dim_crm_user_sales_segment_id         | VARCHAR   | Surrogate key for the CRM User Sales Segment dimension.                             |
    | crm_user_geo                          | VARCHAR   | Geographic region of the CRM user.                                                  |
    | dim_crm_user_geo_id                   | VARCHAR   | Surrogate key for the CRM User Geo dimension.                                       |
    | crm_user_region                       | VARCHAR   | Region of the CRM user.                                                             |
    | dim_crm_user_region_id                | VARCHAR   | Surrogate key for the CRM User Region dimension.                                    |
    | crm_user_area                         | VARCHAR   | Area of the CRM user.                                                               |
    | dim_crm_user_area_id                  | VARCHAR   | Surrogate key for the CRM User Area dimension.                                      |
    | crm_user_role_name                    | VARCHAR   | Name of the user's role.                                                            |
    | dim_crm_user_role_name_id             | VARCHAR   | Surrogate key for the CRM User Role Name dimension.                                 |
    | crm_user_role_level_1                 | VARCHAR   | Level 1 of the user's role hierarchy.                                              |
    | dim_crm_user_role_level_1_id          | VARCHAR   | Surrogate key for Level 1 of the CRM User Role hierarchy.                            |
    | crm_user_role_level_2                 | VARCHAR   | Level 2 of the user's role hierarchy.                                              |
    | dim_crm_user_role_level_2_id          | VARCHAR   | Surrogate key for Level 2 of the CRM User Role hierarchy.                            |
    | crm_user_role_level_3                 | VARCHAR   | Level 3 of the user's role hierarchy.                                              |
    | dim_crm_user_role_level_3_id          | VARCHAR   | Surrogate key for Level 3 of the CRM User Role hierarchy.                            |
    | crm_user_role_level_4                 | VARCHAR   | Level 4 of the user's role hierarchy.                                              |
    | dim_crm_user_role_level_4_id          | VARCHAR   | Surrogate key for Level 4 of the CRM User Role hierarchy.                            |
    | crm_user_role_level_5                 | VARCHAR   | Level 5 of the user's role hierarchy.                                              |
    | dim_crm_user_role_level_5_id          | VARCHAR   | Surrogate key for Level 5 of the CRM User Role hierarchy.                            |
    | crm_user_sales_segment_grouped        | VARCHAR   | Grouped sales segment of the CRM user.                                              |
    | pipe_council_grouping        | VARCHAR   | Aggregation of sales segment at higher level for council          |
    | crm_user_sales_segment_region_grouped | VARCHAR   | Consolidated sales segment and region.                                              |
    | is_current_crm_user_hierarchy         | NUMBER    | Flag indicating if the hierarchy is current.                                       |
   | created_by                   | VARCHAR   | User that created the record                                                                                                                                     |
    | updated_by                   | VARCHAR   | User that updated the record                                                                                                                                       |
    | model_created_date                     | DATE   | Date that the model was created.                                                                                                      |
    | model_updated_date        | DATE      | Date that the model was updated.                                                                                             |
    | dbt_updated_at      | TIMESTAMP    |                                                                  |
    | dbt_created_at | TIMESTAMP   |                                                                |

### 4.4. prep_crm_user

*   **Source:** `sfdc_users_source`, `sfdc_user_roles_source`, `sheetload_mapping_sdr_sfdc_bamboohr_source`
*   **Key transformations:**

    *   **Joining User Data:** Combines data from Salesforce user (`sfdc_users_source`) and user role (`sfdc_user_roles_source`) tables using `user_role_id`.
    *   **Mapping SDR Information:** Integrates SDR (Sales Development Representative) information from a sheetload mapping table (`sheetload_mapping_sdr_sfdc_bamboohr_source`) to enrich user attributes, including their sales segment and region.
    *   **Deriving User Attributes:**  Derives attributes like `crm_user_sales_segment_grouped` using `CASE` statements to group sales segments.

        ```sql
         CASE
          WHEN sfdc_users.user_segment IN ('Large', 'PubSec') THEN 'Large'
          ELSE sfdc_users.user_segment
        END AS crm_user_sales_segment_grouped
        ```

*   **Final Selection:** The query selects a wide range of user attributes, including personal information, role details, geographic information, and SDR assignments.

*   **Table Schema:**

    | Column Name                       | Data Type | Description                                                                                                |
    | --------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------- |
    | DIM_CRM_USER_ID                   | VARCHAR   | Unique identifier for the CRM user.                                                                         |
    | EMPLOYEE_NUMBER                   | NUMBER    | Employee number.                                                                                             |
    | USER_NAME                         | VARCHAR   | User's full name.                                                                                             |
    | TITLE                             | VARCHAR   | User's job title.                                                                                              |
    | DEPARTMENT                        | VARCHAR   | User's department.                                                                                             |
    | TEAM                              | VARCHAR   | User's team.                                                                                                |
    | MANAGER_ID                        | VARCHAR   | User ID of the user's manager.                                                                               |
    | MANAGER_NAME                      | VARCHAR   | Name of the user's manager.                                                                                     |
    | USER_EMAIL                        | VARCHAR   | User's email address.                                                                                          |
    | IS_ACTIVE                         | BOOLEAN   | Indicates if the user is active.                                                                              |
    | START_DATE                        | DATE      | User's start date.                                                                                             |
    | RAMPING_QUOTA                     | NUMBER    | Ramping quota for the user.                                                                                     |
    | USER_TIMEZONE                     | VARCHAR   | User's time zone.                                                                                             |
    | USER_ROLE_ID                      | VARCHAR   | User role ID.                                                                                                 |
    | DIM_CRM_USER_ROLE_NAME_ID         | VARCHAR   | Surrogate key for the CRM User Role Name dimension.                                                             |
    | USER_ROLE_NAME                    | VARCHAR   | Name of the user's role.                                                                                       |
    | USER_ROLE_TYPE                    | VARCHAR   | Type of the user's role.                                                                                        |
    | DIM_CRM_USER_ROLE_LEVEL_1_ID      | VARCHAR   | Surrogate key for Level 1 of the CRM User Role hierarchy.                                                      |
    | USER_ROLE_LEVEL_1                 | VARCHAR   | Level 1 of the user's role hierarchy.                                                                        |
    | DIM_CRM_USER_ROLE_LEVEL_2_ID      | VARCHAR   | Surrogate key for Level 2 of the CRM User Role hierarchy.                                                      |
    | USER_ROLE_LEVEL_2                 | VARCHAR   | Level 2 of the user's role hierarchy.                                                                        |
    | DIM_CRM_USER_ROLE_LEVEL_3_ID      | VARCHAR   | Surrogate key for Level 3 of the CRM User Role hierarchy.                                                      |
    | USER_ROLE_LEVEL_3                 | VARCHAR   | Level 3 of the user's role hierarchy.                                                                        |
    | DIM_CRM_USER_ROLE_LEVEL_4_ID      | VARCHAR   | Surrogate key for Level 4 of the CRM User Role hierarchy.                                                      |
    | USER_ROLE_LEVEL_4                 | VARCHAR   | Level 4 of the user's role hierarchy.                                                                        |
    | DIM_CRM_USER_ROLE_LEVEL_5_ID      | VARCHAR   | Surrogate key for Level 5 of the CRM User Role hierarchy.                                                      |
    | USER_ROLE_LEVEL_5                 | VARCHAR   | Level 5 of the user's role hierarchy.                                                                        |
    | DIM_CRM_USER_SALES_SEGMENT_ID     | VARCHAR   | Surrogate key for the CRM User Sales Segment dimension.                                                        |
    | CRM_USER_SALES_SEGMENT            | VARCHAR   | Sales segment of the CRM user.                                                                                |
    | CRM_USER_SALES_SEGMENT_GROUPED    | VARCHAR   | Grouped sales segment of the CRM user.                                                                        |
    | DIM_CRM_USER_GEO_ID               | VARCHAR   | Surrogate key for the CRM User Geo dimension.                                                                 |
    | CRM_USER_GEO                      | VARCHAR   | Geographic region of the CRM user.                                                                            |
    | DIM_CRM_USER_REGION_ID            | VARCHAR   | Surrogate key for the CRM User Region dimension.                                                              |
    | CRM_USER_REGION                   | VARCHAR   | Region of the CRM user.                                                                                       |
    | DIM_CRM_USER_AREA_ID              | VARCHAR   | Surrogate key for the CRM User Area dimension.                                                                |
    | CRM_USER_AREA                     | VARCHAR   | Area of the CRM user.                                                                                         |
    | DIM_CRM_USER_BUSINESS_UNIT_ID      | VARCHAR   | Surrogate key for the CRM User Business Unit dimension                                                                |
    | CRM_USER_BUSINESS_UNIT                     | VARCHAR   | Business unit of the CRM user                                                                                       |
    | DIM_CRM_USER_ROLE_TYPE_ID| VARCHAR   | Surrogate key for the CRM User Role Type dimension    |
    | IS_HYBRID_USER                   | NUMBER    | Indicates if the user is a hybrid user.                                                                      |
    | DIM_CRM_USER_HIERARCHY_SK         | VARCHAR   | Surrogate key for the CRM User Hierarchy dimension.                                                           |
    | CRM_USER_SALES_SEGMENT_GEO_REGION_AREA | VARCHAR   | Consolidated sales segment, geo, region, and area for the CRM user.                                        |
    | CRM_USER_SALES_SEGMENT_REGION_GROUPED | VARCHAR   | Region grouped based on the CRM sales segment
    | SDR_SALES_SEGMENT                 | VARCHAR   | SDR Sales Segment mapping from bamboo HR                                                       |
    | SDR_REGION                         | VARCHAR   | SDR Region mapping from bamboo HR                                                              |
    | CREATED_DATE                     | TIMESTAMP   | Start date when record was created                                                              |
  | CRM_USER_SUB_BUSINESS_UNIT                      | VARCHAR   |  Sub business unit of the CRM user                                                     |
    | CRM_USER_DIVISION| VARCHAR   |   Division of the CRM user                                          |
  | ASM| VARCHAR   |   Territory of the CRM user                                                 |
    | created_by                   | VARCHAR   |             |
    | updated_by                   | VARCHAR   |                       |
    | model_created_date                     | DATE   |      |
    | model_updated_date        | DATE      |    |
    | dbt_updated_at      | TIMESTAMP    |       |
    | dbt_created_at | TIMESTAMP   |                    |

### 4.5. prep_campaign

*   **Source:** `sfdc_campaign_source`
*   **Key transformations:**

    *   **Data Cleaning and Formatting:** Primarily cleans and formats campaign data extracted from `sfdc_campaign_source`. There are no substantial data derivations or aggregations.
    *   **Series Campaign Identification:** Identifies series campaigns by looking for "series" in the campaign name and populating `series_campaign_id` and `series_campaign_name` accordingly.

        ```sql
        CASE
            WHEN series.dim_parent_campaign_id IS NULL AND LOWER(series.campaign_name) LIKE '%series%'
                THEN series.dim_campaign_id
            WHEN  LOWER(series.parent_campaign_name) LIKE '%series%'
                THEN series.dim_parent_campaign_id
            ELSE NULL
        END AS series_campaign_id
        ```

*   **Final Selection:** The query includes campaign identifiers, details, and various flag indicators.
*   **Table Schema:**

    | Column Name                       | Data Type | Description                                                                                                       |
    | --------------------------------- | --------- | ----------------------------------------------------------------------------------------------------------------- |
    | dim_campaign_id                   | VARCHAR   | Unique identifier for the campaign.                                                                               |
    | campaign_name                     | VARCHAR   | Name of the campaign.                                                                                             |
    | is_active                         | BOOLEAN   | Indicates if the campaign is active.                                                                              |
    | status                            | VARCHAR   | Status of the campaign.                                                                                             |
    | type                              | VARCHAR   | Type of the campaign.                                                                                               |
    | description                       | VARCHAR   | Description of the campaign.                                                                                        |
    | budget_holder                     | VARCHAR   | Person or team responsible for the campaign budget.                                                                |
    | bizible_touchpoint_enabled_setting| VARCHAR   | Setting indicating if Bizible touchpoints are enabled for the campaign.                                          |
    | strategic_marketing_contribution  | VARCHAR   | Strategic marketing contribution of the campaign.                                                                 |
    | large_bucket                      | VARCHAR   | Large bucket category for the campaign.                                                                           |
    | reporting_type                    | VARCHAR   | Reporting type for the campaign.                                                                                    |
    | allocadia_id                      | VARCHAR   | Allocadia identifier for the campaign.                                                                              |
    | is_a_channel_partner_involved      | BOOLEAN   | Indicates if a channel partner is involved in the campaign.                                                      |
    | is_an_alliance_partner_involved    | BOOLEAN   | Indicates if an alliance partner is involved in the campaign.                                                       |
    | is_this_an_in_person_event        | BOOLEAN   | Indicates if the campaign is an in-person event.                                                                  |
    | alliance_partner_name             | VARCHAR   | Name of the alliance partner involved.                                                                            |
    | channel_partner_name              | VARCHAR   | Name of the channel partner involved.                                                                             |
    | sales_play                        | VARCHAR   | Sales play associated with the campaign.                                                                          |
    | gtm_motion                        | VARCHAR   | GTM (Go-To-Market) motion associated with the campaign.                                                             |
    | total_planned_mqls                | NUMBER    | Total planned MQLs (Marketing Qualified Leads) for the campaign.                                                   |
    | will_there_be_mdf_funding           | BOOLEAN   | Indicates if there will be MDF (Market Development Funds) funding for the campaign.                              |
    | mdf_request_id                    | VARCHAR   | MDF request identifier for the campaign.                                                                          |
    | campaign_partner_crm_id  | VARCHAR   |        |
    | series_campaign_id | VARCHAR   |                 |
    | series_campaign_name     | VARCHAR   |       |
    | created_by                   | VARCHAR   |      |
    | updated_by                   | VARCHAR   |                                                                                                                |
    | model_created_date                     | DATE   |                                                      |
    | model_updated_date        | DATE      |                    |
    | dbt_updated_at      | TIMESTAMP    |             |
    | dbt_created_at | TIMESTAMP   |                                                 |

### 4.6. prep_crm_person

*   **Source:** `sfdc_contacts`, `sfdc_leads`, `biz_person`, `biz_touchpoints`
*   **Key transformations:**

    *   **Data Union:** Combines data from `sfdc_contacts` and `sfdc_leads` to create a unified view of persons (leads and contacts).

    *   **Email Hashing**: Creates a SHA2 hash of the contact and lead email addresses for security and privacy.
    ```sql
        sha2(
        TRIM(
            LOWER(
                contact_email ||
                ENCRYPT_RAW(
                  to_binary('SALT_EMAIL6', 'utf-8'),
                  to_binary('FEDCBAA123456785365637265EEEEEEA', 'HEX'),
                  to_binary('416C736F4E637265FFFFFFAB', 'HEX')
                )['ciphertext']::VARCHAR
            )
        )
    ) AS contact_email_hash,
    ```
    *   **Inquiry and MQL Date Derivation:** Derives key dates such as inquiry date, first MQL date