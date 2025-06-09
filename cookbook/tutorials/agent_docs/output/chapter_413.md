### 4.1.3. Bizible Touchpoint Information Prep (`prep_bizible_touchpoint_information`)

This model addresses the challenge of consolidating dispersed touchpoint data across multiple tables to provide a unified view of user interactions. It aims to identify the most relevant touchpoints for each person, focusing on MQL (Marketing Qualified Lead) and recent activities. This enables effective lead scoring, attribution modeling, and personalized marketing efforts.

**Use Case:**
Imagine a marketing analyst wants to understand the typical customer journey leading to an MQL. To do this, they need to quickly access the first touch, last touch, and key conversion touchpoints for each lead. The `prep_bizible_touchpoint_information` model simplifies this by pre-joining and filtering the touchpoint data, making it readily available.

**Data Flow and Transformation**
This model extracts data from four primary raw tables:

*   `sfdc_lead_source` (raw): Raw Salesforce Lead data.
*   `sfdc_contact_source` (raw): Raw Salesforce Contact data.
*   `sfdc_bizible_person_source` (raw): Raw Bizible person data linking individuals to Bizible.
*   `sfdc_bizible_touchpoint_source` (raw): Raw Bizible touchpoint data for all marketing interactions.

The model then performs a series of transformations to identify and consolidate relevant touchpoint information:

1.  **Identify MQL-Related Touchpoints:** For each person, find the touchpoint associated with their MQL event.
2.  **Identify Most Recent Touchpoint:** Determine the most recent touchpoint for each person, regardless of MQL status.
3.  **Consolidate Information:** Combine the MQL and most recent touchpoint data into a single record for each person.

**Key Fields in the Output**
The resulting table includes the following key fields, designed to enrich [prep_crm_person](chapter_411.md):

*   `bizible_mql_touchpoint_id`: The ID of the Bizible touchpoint associated with the MQL.
*   `bizible_mql_touchpoint_date`: The date of the MQL touchpoint.
*   `bizible_mql_form_url`: The URL of the form associated with the MQL touchpoint.
*   `bizible_mql_sfdc_campaign_id`: The Salesforce campaign ID related to the MQL touchpoint.
*   `bizible_mql_ad_campaign_name`: The name of the ad campaign associated with the MQL touchpoint.
*   `bizible_mql_marketing_channel`: The marketing channel for the MQL touchpoint.
*   `bizible_mql_marketing_channel_path`: The marketing channel path for the MQL touchpoint.
*   `bizible_most_recent_touchpoint_id`: The ID of the most recent Bizible touchpoint.
*   `bizible_most_recent_touchpoint_date`: The date of the most recent touchpoint.
*   `bizible_most_recent_form_url`: The URL of the form associated with the most recent touchpoint.
*   `bizible_most_recent_sfdc_campaign_id`: The Salesforce campaign ID related to the most recent touchpoint.
*   `bizible_most_recent_ad_campaign_name`: The name of the ad campaign associated with the most recent touchpoint.
*   `bizible_most_recent_marketing_channel`: The marketing channel for the most recent touchpoint.
*   `bizible_most_recent_marketing_channel_path`: The marketing channel path for the most recent touchpoint.

**SQL Snippet:**

```sql
SELECT
    sfdc_record_id,
    bizible_mql_touchpoint_id,
    bizible_mql_touchpoint_date,
    bizible_mql_form_url,
    bizible_mql_sfdc_campaign_id,
    bizible_mql_ad_campaign_name,
    bizible_mql_marketing_channel,
    bizible_mql_marketing_channel_path,
    bizible_most_recent_touchpoint_id,
    bizible_most_recent_touchpoint_date,
    bizible_most_recent_form_url,
    bizible_most_recent_sfdc_campaign_id,
    bizible_most_recent_ad_campaign_name,
    bizible_most_recent_marketing_channel,
    bizible_most_recent_marketing_channel_path
FROM
    prep_bizible_touchpoint_information
```

**Implementation Details**

The core logic involves two subqueries: one to find MQL touchpoints and another to find the most recent touchpoints. These are then joined to create a unified record.

```sql
WITH bizible_mql_touchpoint_information_base AS (
    SELECT DISTINCT
        prep_person.sfdc_record_id,
        prep_bizible.touchpoint_id,
        ...
        ROW_NUMBER () OVER (PARTITION BY prep_person.sfdc_record_id ORDER BY prep_bizible.bizible_touchpoint_date DESC) AS touchpoint_order_by_person
    FROM prep_person
    LEFT JOIN mql_person_prep
        ON prep_person.sfdc_record_id=mql_person_prep.sfdc_record_id
    LEFT JOIN prep_bizible
        ON prep_person.bizible_person_id = prep_bizible.bizible_person_id
    WHERE prep_bizible.touchpoint_id IS NOT null
        AND mql_person_prep.mql_date_latest IS NOT null
        AND prep_bizible.bizible_touchpoint_date::DATE <= mql_person_prep.mql_date_latest::DATE
    ORDER BY prep_bizible.bizible_touchpoint_date DESC
),
```

This snippet illustrates how the model uses a window function (`ROW_NUMBER()`) to order touchpoints by date for each person and then selects only the most recent one. Similar logic applies to identify MQL touchpoints.

By preparing and consolidating this touchpoint information, `prep_bizible_touchpoint_information` plays a crucial role in providing a comprehensive view of customer interactions, which can be used for more effective marketing and sales strategies.
