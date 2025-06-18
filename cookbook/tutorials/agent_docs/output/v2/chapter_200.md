## 2. Marketing CRM Touchpoint Mart (`mart_crm_touchpoint`)

The `mart_crm_touchpoint` table is the cornerstone for marketing analytics. It addresses the challenge of unifying disparate data sources related to customer interactions, providing a single, comprehensive view of all marketing touchpoints. This enables marketers to analyze customer journeys, campaign performance, and attribution with greater precision.

**Central Use Case:**

Imagine a marketing analyst wants to understand the effectiveness of a recent email campaign. They need to know:

*   Which customers interacted with the email?
*   What were the key characteristics of these customers (e.g., job title, industry)?
*   Which campaign led to the most engagement?
*   Did these touchpoints eventually lead to MQLs (Marketing Qualified Leads)?
*   What was the overall revenue influenced by this campaign?

The `mart_crm_touchpoint` table consolidates all this information, enabling the analyst to answer these questions efficiently.

### Key Metrics & Calculated Fields

The `mart_crm_touchpoint` table includes a number of critical metrics and calculated fields that are essential for marketing analysis:

*   **`bizible_count_first_touch`**: A binary flag indicating whether a given touchpoint was the first interaction a customer had with the company. This helps identify initial touchpoints in the customer journey.
    ```sql
    CASE
        WHEN dim_crm_touchpoint.bizible_touchpoint_position LIKE '%FT%' THEN 1
        ELSE 0
    END AS bizible_count_first_touch
    ```

*   **`bizible_count_lead_creation_touch`**: Indicates whether the touchpoint led to the creation of a lead record in the CRM. This is crucial for lead generation analysis.
    ```sql
    fct_crm_touchpoint.bizible_count_lead_creation_touch
    ```

*   **`bizible_count_u_shaped`**: Attribution credit assigned to the touchpoint based on a U-shaped attribution model. This model typically gives significant weight to the first and last touchpoints in a customer journey.
    ```sql
    fct_crm_touchpoint.bizible_count_u_shaped
    ```

*   **`is_fmm_influenced`**: A flag indicating whether the touchpoint was influenced by a Field Marketing Manager (FMM) campaign or content. This is determined by examining the `budget_holder` of the campaign, the `user_role_name` of the campaign owner, the `utm_content` of the touchpoint, and the `type` of the campaign.
    ```sql
     CASE
        WHEN dim_campaign.budget_holder = 'fmm'
              OR campaign_rep_role_name = 'Field Marketing Manager'
              OR LOWER(dim_crm_touchpoint.utm_content) LIKE '%field%'
              OR LOWER(dim_campaign.type) = 'field event'
              OR LOWER(dim_crm_person.lead_source) = 'field event'
          THEN 1
        ELSE 0
      END AS is_fmm_influenced
    ```

*   **`is_fmm_sourced`**: Indicates whether the touchpoint was the first touch and was influenced by an FMM.
    ```sql
    CASE
        WHEN dim_crm_touchpoint.bizible_touchpoint_position LIKE '%FT%'
          AND is_fmm_influenced = 1
          THEN 1
        ELSE 0
      END AS is_fmm_sourced
    ```

*   **`integrated_budget_holder`**: Categorizes the budget holder responsible for the touchpoint (e.g., 'Field Marketing', 'Digital Marketing'). This is derived from the campaign's `budget_holder`, the touchpoint's `utm_budget` and `bizible_ad_campaign_name`, and the campaign owner's `user_role_name`.
    ```sql
    CASE
      WHEN LOWER(dim_campaign.budget_holder) = 'fmm'
        THEN 'Field Marketing'
      WHEN LOWER(dim_campaign.budget_holder) = 'dmp'
        THEN 'Digital Marketing'
      ...
    END AS integrated_budget_holder
    ```

*   **`count_inquiry`**: A binary flag indicating whether the touchpoint's position is 'LC' (Lead Creation) and not 'PostLC'.
    ```sql
     CASE
        WHEN dim_crm_touchpoint.bizible_touchpoint_position LIKE '%LC%'
          AND dim_crm_touchpoint.bizible_touchpoint_position NOT LIKE '%PostLC%'
          THEN 1
        ELSE 0
      END AS count_inquiry
    ```

*   **`count_true_inquiry`**: Checks if the `true_inquiry_date` is on or after the `bizible_touchpoint_date`.
    ```sql
    CASE
        WHEN fct_crm_person.true_inquiry_date >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN 1
        ELSE 0
      END AS count_true_inquiry
    ```

*   **`count_mql`**: A binary flag indicating whether the `mql_date_first` is on or after the `bizible_touchpoint_date`.
    ```sql
    CASE
        WHEN fct_crm_person.mql_date_first >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN 1
        ELSE 0
      END AS count_mql
    ```

*   **`count_net_new_mql`**: Equals `bizible_count_lead_creation_touch` if the touchpoint led to an MQL; otherwise, it's 0.
    ```sql
    CASE
        WHEN fct_crm_person.mql_date_first >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN fct_crm_touchpoint.bizible_count_lead_creation_touch
        ELSE 0
      END AS count_net_new_mql
    ```

*   **`count_accepted`**: A binary flag indicating if the `accepted_date` is on or after the `bizible_touchpoint_date`.
    ```sql
    CASE
        WHEN fct_crm_person.accepted_date >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN 1
        ELSE '0'
      END AS count_accepted
    ```

*   **`count_net_new_accepted`**: This equals `bizible_count_lead_creation_touch` if the touchpoint led to an Accepted Lead; otherwise, it is 0.
    ```sql
    CASE
        WHEN fct_crm_person.accepted_date >= dim_crm_touchpoint.bizible_touchpoint_date
          THEN fct_crm_touchpoint.bizible_count_lead_creation_touch
        ELSE 0
      END AS count_net_new_accepted
    ```

*   **`mql_crm_person_id`**: The `sfdc_record_id` of the person if the touchpoint resulted in an MQL.
    ```sql
    CASE
        WHEN count_mql=1 THEN dim_crm_person.sfdc_record_id
        ELSE NULL
      END AS mql_crm_person_id
    ```

*   **`pre_mql_weight`**: A fractional weight assigned to touchpoints that occurred before the first MQL date for a given person, calculated as 1 divided by the total number of pre-MQL touches for that person. This helps in attributing value to touchpoints early in the customer journey.
    ```sql
    1/count_of_pre_mql_tps.pre_mql_touches AS pre_mql_weight
    ```

These metrics and fields provide a comprehensive view of marketing touchpoint performance, enabling detailed analysis and informed decision-making.

### Source Models & Joins

The `mart_crm_touchpoint` is constructed by joining the `fct_crm_touchpoint` fact table with several dimension tables. This multi-table join strategy enriches the touchpoint data with contextual information from various CRM entities.

Here's a breakdown of the source models and joins involved:

```mermaid
graph LR
    fct_crm_touchpoint --> dim_crm_touchpoint
    fct_crm_touchpoint --> dim_campaign
    fct_crm_touchpoint --> fct_campaign
    fct_crm_touchpoint --> dim_crm_person
    fct_crm_touchpoint --> fct_crm_person
    fct_crm_touchpoint --> dim_crm_account
    fct_crm_touchpoint --> dim_crm_user
    fct_campaign --> campaign_owner(dim_crm_user aliased as campaign_owner)

    fct_crm_touchpoint(fct_crm_touchpoint)
    dim_crm_touchpoint([CRM Touchpoint Dimension](chapter_310.md))
    dim_campaign([Campaign Dimension](chapter_330.md))
    fct_campaign([Campaign Fact](chapter_430.md))
    dim_crm_person([CRM Person Dimension](chapter_320.md))
    fct_crm_person([CRM Person Fact](chapter_420.md))
    dim_crm_account([CRM Account Dimension](chapter_340.md))
    dim_crm_user([CRM User Dimension](chapter_350.md))
```

1.  **`fct_crm_touchpoint`**: This is the primary fact table, containing the core information about each touchpoint, including the IDs of related entities and key metrics.
2.  **[CRM Touchpoint Dimension](chapter_310.md) (`dim_crm_touchpoint`)**: This dimension table provides descriptive attributes of each touchpoint, such as the touchpoint type, source, and marketing channel.
3.  **[Campaign Dimension](chapter_330.md) (`dim_campaign`)**: This dimension table stores descriptive attributes of marketing campaigns, such as the campaign name, type, and status.
4.  **[Campaign Fact](chapter_430.md) (`fct_campaign`)**: This fact table contains additive measures and key dates for campaigns, facilitating quantitative performance analysis.
5.  **[CRM Person Dimension](chapter_320.md) (`dim_crm_person`)**: This dimension table stores master data attributes for individuals (leads and contacts), providing a consistent view across marketing and sales.
6.  **[CRM Person Fact](chapter_420.md) (`fct_crm_person`)**: This fact table captures key dates and flags related to a person's progression through the marketing and sales funnel, enabling lifecycle stage analysis.
7.  **[CRM Account Dimension](chapter_340.md) (`dim_crm_account`)**: This dimension table provides a holistic view of accounts within the CRM, encompassing their hierarchical structure, demographic information, and various health and engagement indicators.
8.  **[CRM User Dimension](chapter_350.md) (`dim_crm_user`)**: This dimension table contains detailed information about CRM users, including their roles, departmental affiliations, and sales territories. This table is joined twice, once for the touchpoint owner and once (aliased as `campaign_owner`) for the campaign owner.

By joining these tables, the `mart_crm_touchpoint` table provides a rich, integrated dataset that enables comprehensive marketing analytics.