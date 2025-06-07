## Chapter 3. Fact Tables

This chapter details the creation of various fact tables within the data warehouse. Fact tables are central to the star schema design, storing quantitative data (measures) and foreign keys that link to dimension tables, enabling comprehensive analysis. Each fact table documentation includes:

*   **Source Tables:** The data sources from which the fact table is populated.
*   **Data Transformations:** A description of any data cleansing, conversion, or aggregation steps performed on the source data.
*   **Final Selection:**  The criteria used to select specific fields or records for inclusion in the fact table.
*   **Table Schema:**  A listing of the columns in the fact table, including their data types and descriptions.

### 3.1. fct_campaign

This fact table, `fct_campaign`, stores key performance indicators (KPIs) and descriptive attributes related to marketing campaigns. It allows for the analysis of campaign effectiveness and ROI.

*   **Source:** `prep_campaign`

    The `prep_campaign` table serves as the primary source. This table is expected to be a preprocessed or staging table containing campaign data extracted and transformed from source systems (e.g., Salesforce).  It should contain cleaned and standardized data. Please refer to `prep_campaign` documentation for detailed info.
*   **Data Transformations:**

    The provided code snippet performs primarily column selection and renaming, along with a date formatting step.

    *   **Date Formatting:** The code extracts date parts to create date IDs.  For example:

        ```sql
        TO_NUMBER(TO_CHAR(start_date::DATE,'YYYYMMDD'),'99999999') AS start_date_id
        ```

        This converts the `start_date` to a numerical `YYYYMMDD` format for efficient date-based filtering and analysis.
*   **Final Selection:**

    The final selection process focuses on choosing specific fields from `prep_campaign` that are most relevant for performance analysis.  These include campaign identifiers, user assignments, date-related attributes, planned values, and additive metrics like costs, responses, and opportunity amounts. There are no specific filtering criteria based on row values mentioned in the provided snippets.
*   **Table Schema:**

    | Column Name            | Data Type    | Description                                                                                                       |
    | ---------------------- | ------------ | ----------------------------------------------------------------------------------------------------------------- |
    | `dim_campaign_id`      | VARCHAR      | Primary key, foreign key referencing `dim_campaign`.                                                              |
    | `dim_parent_campaign_id` | VARCHAR      | Foreign key referencing the parent campaign, allowing for hierarchical analysis.                                    |
    | `campaign_owner_id`    | VARCHAR      | Foreign key referencing the user who owns the campaign.                                                              |
    | `created_by_id`        | VARCHAR      | Foreign key referencing the user who created the campaign.                                                            |
    | `start_date`           | DATE         | The date the campaign is scheduled to begin.                                                                      |
    | `start_date_id`        | NUMBER       | Numerical representation of the `start_date` (YYYYMMDD).                                                            |
    | `end_date`             | DATE         | The date the campaign is scheduled to end.                                                                        |
    | `end_date_id`          | NUMBER       | Numerical representation of the `end_date` (YYYYMMDD).                                                              |
    | `created_date`         | DATE         | The date the campaign record was created.                                                                          |
    | `created_date_id`      | NUMBER       | Numerical representation of the `created_date` (YYYYMMDD).                                                          |
    | `last_modified_date`   | DATE         | The date the campaign record was last modified.                                                                    |
    | `last_modified_date_id`| NUMBER       | Numerical representation of the `last_modified_date` (YYYYMMDD).                                                   |
    | `last_activity_date`   | DATE         | The date of the last activity associated with the campaign.                                                       |
    | `last_activity_date_id`| NUMBER       | Numerical representation of the `last_activity_date` (YYYYMMDD).                                                  |
    | `region`               | VARCHAR      | The geographic region targeted by the campaign.                                                                    |
    | `sub_region`           | VARCHAR      | The sub-region within the region targeted by the campaign.                                                          |
    | `planned_inquiry`      | NUMBER       | The number of inquiries expected from the campaign.                                                                 |
    | `planned_mql`          | NUMBER       | The number of marketing qualified leads (MQLs) expected from the campaign.                                        |
    | `planned_pipeline`     | NUMBER       | The expected value of the sales pipeline generated by the campaign.                                                   |
    | `planned_sao`          | NUMBER       | Planned Sales Accepted Opportunities.                                                                              |
    | `planned_won`          | NUMBER       | The expected revenue from opportunities won due to the campaign.                                                      |
    | `planned_roi`          | NUMBER       | The planned return on investment (ROI) for the campaign.                                                              |
    | `total_planned_mql`    | NUMBER       | The total number of MQLs planned for the campaign.                                                                  |
    | `budgeted_cost`        | NUMBER       | The budgeted cost for the campaign.                                                                                 |
    | `expected_response`    | NUMBER       | The number of responses expected from the campaign.                                                                 |
    | `expected_revenue`     | NUMBER       | The revenue expected to be generated by the campaign.                                                              |
    | `actual_cost`          | NUMBER       | The actual cost incurred by the campaign.                                                                           |
    | `amount_all_opportunities` | NUMBER       | The total value of all opportunities associated with the campaign.                                                     |
    | `amount_won_opportunities` | NUMBER       | The total value of opportunities won as a result of the campaign.                                                        |
    | `count_contacts`       | NUMBER       | The number of contacts associated with the campaign.                                                                 |
    | `count_converted_leads`| NUMBER       | The number of leads converted to contacts as a result of the campaign.                                               |
    | `count_leads`          | NUMBER       | The number of leads associated with the campaign.                                                                    |
    | `count_opportunities`  | NUMBER       | The number of opportunities associated with the campaign.                                                              |
    | `count_responses`      | NUMBER       | The number of responses received from the campaign.                                                                  |
    | `count_won_opportunities`| NUMBER       | The number of opportunities won as a result of the campaign.                                                           |
    | `count_sent`           | NUMBER       | The number of sent campaign emails.                                                                                 |
    | ...                    | ...          | ... (other campaign-related measures)                                                                              |

### 3.2. fct_crm_person

This fact table, `fct_crm_person`, tracks key metrics and events related to individuals (leads and contacts) in the CRM system. It is designed to analyze lead generation, conversion, and engagement.

*   **Source Tables:**

    *   `prep_crm_person`:  The primary source, containing preprocessed CRM person data (leads/contacts)
    *   `map_crm_account`: Mapping table to relate CRM person to CRM account dimensions.
    *   `dim_sales_segment`:  Dimension table providing sales segment information.
    *   `prep_sales_territory`: Staging table containing sales territory information.
    *   `prep_industry`: Staging table containing industry information.
    *   `prep_bizible_marketing_channel_path`: Staging table containing Bizible marketing channel path information.
    *   `prep_crm_user_hierarchy`: Staging table containing CRM user hierarchy information.
    *   `sfdc_contacts`: Source of Salesforce contact data
    *   `sfdc_leads`: Source of Salesforce lead data
*   **Data Transformations:**

    The data transformation process involves joining multiple sources to consolidate person-level information and calculating key metrics. Several important transformations are present:

    *   **Date Conversion:**  Dates from various sources (Salesforce, Marketo, etc.) are standardized and converted into numerical date IDs, including time zone conversions:

        ```sql
        TO_NUMBER(TO_CHAR(COALESCE(sfdc_leads.created_date, sfdc_lead_converted.created_date, sfdc_contacts.created_date)::DATE,'YYYYMMDD'),'99999999') AS created_date_id,
        ```

    *   **ABM Tier Flagging**: Applying logic that if a CRM Person is in an ABM tier for both inquiry and MQL then a flag of true is applied
*   **Final Selection:**

    The final selection aims to gather a comprehensive set of information about each CRM person, including their demographics, engagement metrics, MQL status, and account affiliations. The joins leverage foreign keys to connect to dimension tables and enrich the fact table with descriptive attributes. The ABM flags provide useful information for analyzing high-value accounts.

*   **Table Schema:**

    | Column Name                | Data Type | Description                                                                                                            |
    | -------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------- |
    | `dim_crm_person_id`        | VARCHAR   | Primary key, a unique identifier for the CRM person.                                                                 |
    | `sfdc_record_id`           | VARCHAR   | Salesforce record ID (Lead or Contact ID).                                                                           |
    | `bizible_person_id`        | VARCHAR   | Bizible person ID, if available.                                                                                       |
    | `dim_crm_account_id`       | VARCHAR   | Foreign key referencing the CRM account associated with the person.                                                      |
    | `dim_crm_user_id`          | VARCHAR   | Foreign key referencing the CRM user who owns the person record.                                                           |
    | `created_date`             | DATE      | The date the CRM person record was created.                                                                            |
    | `created_date_id`         | NUMBER  | Numerical format of `created_date` for efficient filtering and reporting.                                                |
    | `inquiry_date`             | DATE      | The date the person first showed interest (e.g., submitted a form).                                                    |
    | `inquiry_date_id`         | NUMBER  | Numerical format of `inquiry_date` for efficient filtering and reporting.                                                 |
    | `mql_date_first`           | DATE      | The date the person first became a marketing qualified lead.                                                              |
    | `mql_date_first_id`       | NUMBER  | Numerical format of `mql_date_first` for efficient filtering and reporting.                                                   |
    | `mql_date_latest`          | DATE      | The most recent date the person was identified as a marketing qualified lead.                                            |
    | `mql_date_latest_id`      | NUMBER  | Numerical format of `mql_date_latest` for efficient filtering and reporting.                                                  |
    | `is_mql`                   | BOOLEAN   | A flag indicating whether the person is currently considered an MQL.                                                      |
    | `is_inquiry`               | BOOLEAN   | A flag indicating whether the person has shown initial interest (e.g., submitted a form).                               |
    | `person_score`             | NUMBER    | A score representing the person's engagement and interest level.                                                          |
    | `mql_count`                | NUMBER    | The total number of times the person has been identified as an MQL.                                                      |
    | `account_demographics_sales_segment` | VARCHAR   |	Account Sales Segment                                                                                         |
    | ...                        | ...       | ... (other CRM person attributes and measures)                                                                          |

### 3.3. fct_crm_touchpoint

This fact table, `fct_crm_touchpoint`, records interactions (touchpoints) between the company and potential customers. It is used to analyze marketing campaign effectiveness, lead attribution, and customer engagement.

*   **Source Tables:**

    *   `prep_crm_touchpoint`:  The primary source, containing preprocessed data on marketing touchpoints.
    *   `map_crm_account`:  Mapping table for linking touchpoints to CRM accounts.
    *   `prep_crm_person`:  Source for CRM person (lead/contact) information related to the touchpoints.
    *   `dim_crm_user`: Provides information about users in the CRM system

*   **Data Transformations:**

    This fact table creation involves joining touchpoint data with account and person information to create a comprehensive view of customer interactions.  Key transformations include:

    *   **Surrogate Key Generation**: Surrogate keys are created using MD5 hashing to ensure uniqueness and efficiency in joins, especially when dealing with composite keys.

        ```sql
        md5(cast(coalesce(cast(fct_crm_touchpoint.dim_crm_person_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(dim_campaign.dim_campaign_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(dim_crm_touchpoint.bizible_touchpoint_date_time as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS touchpoint_person_campaign_date_id,
        ```

    *   **Case Statement and Data Mapping**: Logic that maps field marketing influence, and integrated budget holder attribution
    *   **Aggregation and Weighting**: Calculating mql weighting.
*   **Final Selection:**

    The final selection gathers a wide range of information about each touchpoint, CRM person, campaign, and CRM account.

*   **Table Schema:**

    | Column Name                     | Data Type | Description                                                                                                                               |
    | ------------------------------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
    | `dim_crm_touchpoint_id`         | VARCHAR   | Primary key, a unique identifier for the CRM touchpoint.                                                                                  |
    | `dim_crm_person_id`             | VARCHAR   | Foreign key referencing the CRM person (lead/contact) associated with the touchpoint.                                                        |
    | `dim_campaign_id`               | VARCHAR   | Foreign key referencing the marketing campaign associated with the touchpoint.                                                              |
    | `dim_crm_account_id`            | VARCHAR   | Foreign key referencing the CRM account associated with the touchpoint.                                                                      |
    | `bizible_count_first_touch`     | NUMBER    | The number of times this touchpoint was the first touch for a lead/contact, according to Bizible.                                              |
    | `bizible_count_lead_creation_touch` | NUMBER    | The number of times this touchpoint was associated with lead creation, according to Bizible.                                                 |
    | `bizible_count_u_shaped`        | NUMBER    | A fractional attribution score based on a U-shaped attribution model (Bizible).                                                              |
    | `integrated_budget_holder`      | VARCHAR   | A description about which budget holder group this touchpoint belongs to.                                                                        |
    | ...                             | ...       | ... (other touchpoint attributes and measures, including UTM parameters, marketing channel information, and CRM account details)          |

These fact tables provide a foundation for marketing and sales analytics, enabling reporting and analysis of campaign performance, customer engagement, and revenue attribution.
