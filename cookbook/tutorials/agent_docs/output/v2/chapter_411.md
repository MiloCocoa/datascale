## 4.1. CRM Person Data Preparation

This chapter dives into the `prep_crm_person` model, a crucial step in preparing CRM data for analysis. It addresses the challenge of fragmented customer information scattered across various sources like Salesforce Leads and Contacts, Bizible, and Marketo. By consolidating and cleaning this data, `prep_crm_person` creates a unified view of each individual, enriching it with valuable marketing and engagement data. This unified record is then used to build the [CRM Person Dimension](chapter_320.md) and [CRM Person Fact](chapter_320.md), which serve as fundamental building blocks for marketing and sales analytics.

### 4.1.1. `prep_crm_person`

*   **Purpose**: Consolidates and cleans raw Salesforce Lead and Contact data, enriching it with Bizible, Marketo, activity, and external demographic data.

    Imagine you need to analyze the effectiveness of a recent marketing campaign. To do this effectively, you need a complete picture of each lead and contact who interacted with the campaign. This includes their basic information (name, email, company), their engagement history (website visits, form submissions), and their progression through the sales funnel (MQL date, conversion date).  `prep_crm_person` provides exactly that – a single, comprehensive record for each person.

*   **Sources**:

    The `prep_crm_person` model draws data from a variety of sources:

    *   `sfdc_contacts` (raw):  Raw data for contacts from Salesforce.
    *   `sfdc_leads` (raw): Raw data for leads from Salesforce.
    *   `biz_person_with_touchpoints` (from `sfdc_bizible_touchpoint_source` and `sfdc_bizible_person_source`): Enriched person data from Bizible, including touchpoint information.
    *   `marketo_persons` (from `marketo_lead_source` and `marketo_activity_delete_lead_source`): Person data from Marketo, including lead and activity information.
    *   [prep_crm_task](chapter_473.md): Prepared task data from Salesforce, used to determine if a BDR or SDR has worked on a person (`is_bdr_sdr_worked`).
    *   [prep_crm_event](chapter_474.md): Prepared event data from Salesforce, also contributing to the `is_bdr_sdr_worked` flag.
    *   `sfdc_account_source`: Raw account data from Salesforce.
    *   [prep_bizible_touchpoint_information](chapter_413.md):  Consolidated Bizible touchpoint information, including MQL and most recent touchpoints.
    *   [prep_location_country](chapter_475.md):  A mapping table for country codes to full country names and regions.
    *   [prep_date](chapter_471.md):  A date dimension table used for date calculations.

*   **Example Code Snippet:**

    While the full code for `prep_crm_person` is extensive, here’s a snippet illustrating how it combines data from Salesforce Leads and Bizible:

    ```sql
    SELECT
      --id
      md5(cast(coalesce(cast(sfdc_leads.lead_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS dim_crm_person_id,
      sfdc_leads.lead_id                                    AS sfdc_record_id,
      bizible_person_id                          AS bizible_person_id,
      'lead'                                     AS sfdc_record_type,
      -- ... other fields ...
    FROM sfdc_leads
    LEFT JOIN biz_person_with_touchpoints
      ON sfdc_leads.lead_id = biz_person_with_touchpoints.bizible_lead_id
    ```

    This SQL code shows how the model uses a `LEFT JOIN` to bring in Bizible data based on the `lead_id`, even if there's no corresponding Bizible record.

*   **Implementation Details:**

    The `prep_crm_person` model performs several key transformations:

    *   **ID Consolidation:** Creates a consistent `dim_crm_person_id` using a hashed value of the Salesforce `lead_id` or `contact_id`. This unified ID is critical for joining data across systems.
    *   **Data Cleaning:** Cleans and standardizes data fields such as email addresses, country names, and job titles.
    *   **Data Enrichment:** Enriches the person record with information from Bizible, Marketo, and other sources, such as engagement scores, touchpoint data, and lead source details.
    *   **Lifecycle Stage Mapping:** Derives key lifecycle dates such as inquiry date, MQL date, and conversion date based on various data sources.

*   **Output**: A unified person record with cleaned IDs, demographic info, touchpoint data, and lifecycle dates, ready for [CRM Person Dimension](chapter_320.md) and [CRM Person Fact](chapter_320.md).

    The final output of `prep_crm_person` is a table with a comprehensive set of fields, including:

    *   `dim_crm_person_id`: The unified person ID.
    *   `sfdc_record_id`: The Salesforce Lead or Contact ID.
    *   `email_hash`: A hashed version of the email address for anonymization.
    *   `inquiry_date`: The date the person first showed interest.
    *   `mql_date`: The date the person became marketing qualified.
    *   `converted_date`: The date the lead was converted to a contact.
    *   Various demographic and engagement fields.

    This output is then used to construct the `dim_crm_person` and `fct_crm_person` tables, enabling comprehensive analysis of customer behavior and marketing effectiveness.

In summary, `prep_crm_person` plays a critical role in creating a unified and enriched view of individuals within the CRM, which is essential for accurate and insightful marketing and sales analytics.