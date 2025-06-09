### 3.2. CRM Person (`dim_crm_person`, `fct_crm_person`)

In any CRM system, the "person" entity—representing individual leads and contacts—is central to both marketing and sales efforts. Accurately capturing and understanding these individuals is crucial for personalized communication, effective lead nurturing, and ultimately, driving conversions. The `dim_crm_person` and `fct_crm_person` tables serve this purpose in our data warehouse, providing a unified view of individuals within the CRM.

**Central Use Case:**

Imagine a marketing analyst tasked with understanding the characteristics of leads that convert into paying customers. They need to analyze demographic information (like job title, country) alongside engagement metrics (like lead source, marketing qualified lead (MQL) date) to identify patterns and improve lead qualification strategies. These tables provide the foundational data for this type of analysis.

This section details the structure and purpose of these two key tables, outlining how they work together to paint a comprehensive picture of each person in our CRM.

#### 3.2.1. CRM Person Dimension (`dim_crm_person`)

The `dim_crm_person` table acts as a central repository for master data about individuals. It stores relatively static attributes that describe a person, offering a consistent view of leads and contacts across the organization. This table avoids duplication of data and ensures consistency across reporting and analysis.

*   **Purpose:** Stores master data attributes for individuals, providing a consistent view of leads and contacts across marketing and sales.

*   **Source Model:** Built directly from [prep_crm_person](chapter_411.md).

    The `prep_crm_person` model consolidates data from various raw Salesforce sources (Leads and Contacts) and enriches it with information from Bizible, Marketo, and other external tools. This ensures that the `dim_crm_person` table contains a unified and comprehensive view of each individual. For more details on how `prep_crm_person` is built, see [CRM Person Data Preparation](chapter_410.md).

*   **Key Fields:**

    *   **`sfdc_record_id`**: The primary identifier for the person within Salesforce. This is the key field used to link `dim_crm_person` to other tables containing information about that person.
    *   **`email_hash`**: An anonymized hash of the person's email address. This is used for privacy-preserving analysis where the actual email address is not required.
    *   **`email_domain`**: The domain of the person's email address (e.g., 'example.com'). This can be used to identify the person's organization.
    *   **`is_valuable_signup`**: A boolean flag indicating whether the person signed up using a business email domain. This can be a useful indicator of lead quality.
    *   **`marketo_lead_id`**: The unique identifier for the person within Marketo, if the person is tracked in Marketo.
    *   **`owner_id`**: The Salesforce User ID of the person's owner. This allows you to analyze performance based on the sales representative responsible for the person.
    *   **`person_score`**: A score assigned to the person based on their engagement and other factors. This can be used to prioritize leads.
    *   **`title`**: The person's job title.
    *   **`country`**: The person's country.
    *   **`lead_source`**: The original source of the lead (e.g., 'Webinar', 'Referral').
    *   **`net_new_source_categories`**: Categorization of the lead source into broader categories (e.g., 'Marketing/Inbound', 'Prospecting').
    *   **`account_demographic_`**_\*_\*: Several fields containing demographic information about the person's associated account (e.g., `account_demographics_sales_segment`, `account_demographics_geo`).
    *   Various engagement scores from external tools (6Sense, UserGems, Groove, ZoomInfo). These fields provide additional insights into the person's engagement and activity levels.

**Example Code Snippet:**

To retrieve basic information about a set of leads, you can query the `dim_crm_person` table:

```sql
 SELECT
  sfdc_record_id,
  email_domain,
  title,
  country,
  lead_source
 FROM
  PROD.common.dim_crm_person
 WHERE
  lead_source = 'Webinar'
 LIMIT 100;
```

This query would return the Salesforce ID, email domain, title, country, and lead source for the first 100 leads in the `dim_crm_person` table that originated from a webinar.

#### 3.2.2. CRM Person Fact (`fct_crm_person`)

While `dim_crm_person` stores the static attributes, the `fct_crm_person` table captures key dates and flags related to a person's journey through the marketing and sales funnel. This table is crucial for understanding lifecycle progression and identifying bottlenecks in the conversion process.

*   **Purpose**: Captures key dates and flags related to a person's progression through the marketing and sales funnel, enabling lifecycle stage analysis.

    *   **Source Models**: Combines [prep_crm_person](chapter_411.md) with MQL event data from `sfdc_leads` and `sfdc_contacts` (raw tables), and joins to account history from `sfdc_account_snapshots_source`.

    This table extends the `prep_crm_person` with data about MQL events, which is directly sourced from Salesforce leads and contacts. Historical account data from account snapshots (`sfdc_account_snapshots_source`) is incorporated. It provides information on how the `prep_crm_person` model is build, see [CRM Person Data Preparation](chapter_410.md).

*   **Key Dates**:

    *   **`created_date`**: The date when the person's record was created in Salesforce.
    *   **`inquiry_date`**: The date when the person first expressed interest in our products or services.
    *   **`true_inquiry_date`**: A more accurate inquiry date, derived from various sources.
    *   **`mql_date_first`**: The date when the person first became a Marketing Qualified Lead (MQL).
    *   **`mql_date_latest`**: The date when the person most recently became an MQL.
    *   **`accepted_date`**: The date when the lead was accepted by sales.
    *   **`qualified_date`**: The date when the lead was qualified by sales.
    *   **`converted_date`**: The date when the lead was converted into an opportunity.

*   **Key Flags/Counts**:

    *   **`is_mql`**: A boolean flag indicating whether the person is currently an MQL.
    *   **`is_inquiry`**: A boolean flag indicating whether the person has ever inquired.
    *   **`mql_count`**: The total number of times the person has been an MQL.
    *   **`is_bdr_sdr_worked`**: A boolean flag indicating whether the person has been worked by a Business Development Representative (BDR) or Sales Development Representative (SDR).
    *   **`is_partner_recalled`**: A boolean flag indicating whether the person is related to the partner.
    *   **`is_high_priority`**: A boolean flag indicating whether the person has been marked as a high priority.
    *   ABM tier flags (`is_abm_tier_inquiry`, `is_abm_tier_mql`): Boolean flags indicating whether the person is associated with an account in an ABM tier and whether they have inquired or become an MQL while in that tier.
    *    Groove engagement metrics.

**Example Code Snippet:**

To analyze the conversion rate of leads to MQLs, you can join `dim_crm_person` with `fct_crm_person`:

```sql
 SELECT
  dim_crm_person.lead_source,
  COUNT(DISTINCT dim_crm_person.sfdc_record_id) AS total_leads,
  SUM(CASE WHEN fct_crm_person.is_mql = TRUE THEN 1 ELSE 0 END) AS mql_count,
  mql_count / total_leads AS mql_conversion_rate
 FROM
  PROD.common.dim_crm_person
 JOIN
  PROD.common.fct_crm_person
 ON
  dim_crm_person.dim_crm_person_id = fct_crm_person.dim_crm_person_id
 GROUP BY
  dim_crm_person.lead_source
 ORDER BY
  mql_conversion_rate DESC
 LIMIT 10;
```

This query would return the top 10 lead sources with the highest MQL conversion rate, allowing you to identify the most effective channels for generating qualified leads.

By combining the descriptive attributes in `dim_crm_person` with the lifecycle event data in `fct_crm_person`, you gain a powerful foundation for analyzing and optimizing your marketing and sales efforts. This enables you to understand your target audience, personalize engagement, and improve conversion rates.