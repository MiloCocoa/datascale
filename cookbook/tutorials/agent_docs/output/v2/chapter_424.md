### 4.2.4. Bizible Touchpoint Keystone Prep (`prep_bizible_touchpoint_keystone`)

The `prep_bizible_touchpoint_keystone` model addresses the need to enrich marketing touchpoint data with internal content metadata, facilitating more granular analysis and reporting. By mapping touchpoints to internal 'Keystone' content, we can provide additional attributes such as GTM motion and GitLab Epic, which are not readily available in the raw touchpoint data.

**Use Case:** A marketing analyst wants to report on touchpoints associated with specific keystone content pieces, understanding which content is driving the most engagement and how it aligns with different GTM motions. This requires linking touchpoint data with internal content metadata.

**Purpose:** Maps touchpoints to internal 'Keystone' content from a YAML file, providing additional content attributes like GTM motion and GitLab Epic.

**Core Logic:**

This model primarily performs a series of joins, leveraging URL or campaign information within touchpoints to connect to content metadata defined in a YAML file (`content_keystone_source`). It consolidates content attributes from disparate sources for use in downstream models.

**Data Flow:**

1.  Raw data from `content_keystone_source` (YAML file) is parsed and flattened.
2.  Touchpoint data from `prep_crm_attribution_touchpoint` and `prep_crm_touchpoint` are used as input.
3.  Touchpoint records are joined with parsed content metadata based on matching URLs or campaign identifiers.
4.  The resulting dataset links touchpoint IDs with content attributes such as `content_name`, `gitlab_epic`, `gtm`, `url_slug`, and `type`.

**Sources:**

*   `content_keystone_source` (raw): This is the raw YAML file containing internal content metadata.
*   [prep_crm_attribution_touchpoint](chapter_422.md): Enriched attribution touchpoint data.
*   [prep_crm_touchpoint](chapter_421.md): Enriched touchpoint data.

**Implementation Details:**

The data transformation pipeline involves the following key steps:

1.  **Parsing Keystone Content:**  The `content_keystone_source` YAML file is parsed using the `FLATTEN` function in Snowflake to transform the semi-structured data into a relational format. This allows easier joining with touchpoint data. The union_types CTE flattens different sections of the YAML file, such as `form_urls`, `landing_page_urls`, `pathfactory_pages`, `utm_campaign_name`, and `sfdc_campaigns`, so they can be joined to touchpoints.
    ```sql
    WITH union_types AS (
        SELECT
            content_name,
            gitlab_epic,
            gtm,
            type,
            url_slug,
            'form_urls' AS join_string_type,
            flattened_parsed_keystone.value::VARCHAR AS join_string
        FROM parse_keystone,
            LATERAL FLATTEN(input => parse_keystone.full_value:form_urls) flattened_parsed_keystone
        UNION ALL
        -- Additional UNION ALL clauses for landing_page_urls, pathfactory_pages, etc.
    )
    ```

2.  **Unioning Touchpoint Data:** The `prep_crm_attribution_touchpoint` and `prep_crm_touchpoint` models are combined to create a unified touchpoint dataset (`prep_crm_unioned_touchpoint`).  This ensures all touchpoints are considered for linking to keystone content.

    ```sql
    WITH prep_crm_unioned_touchpoint AS (
        SELECT
            touchpoint_id AS dim_crm_touchpoint_id,
            campaign_id AS dim_campaign_id,
            bizible_form_url,
            bizible_landing_page,
            PARSE_URL(bizible_landing_page_raw)['parameters']['utm_campaign']::VARCHAR    AS bizible_landing_page_utm_campaign,
            PARSE_URL(bizible_form_url_raw)['parameters']['utm_campaign']::VARCHAR        AS bizible_form_page_utm_campaign,
            COALESCE(bizible_landing_page_utm_campaign, bizible_form_page_utm_campaign)   AS utm_campaign
        FROM "PROD".common_prep.prep_crm_attribution_touchpoint
        UNION ALL
        -- Similar SELECT statement for prep_crm_touchpoint
    )
    ```

3.  **Joining Touchpoints with Keystone Content:**  The core logic involves joining the unified touchpoint dataset with the parsed keystone content based on various touchpoint attributes (e.g., URLs, campaign IDs). The `COALESCE` function ensures that the most relevant metadata is selected from the different join attempts.
    ```sql
    WITH combined_model AS (
        SELECT
            prep_crm_unioned_touchpoint.dim_crm_touchpoint_id,
            COALESCE(
                sfdc_campaigns.content_name,
                utm_campaigns.content_name,
                form_urls.content_name,
                landing_pages.content_name,
                pathfactory_landing.content_name
            ) AS content_name,
            -- Similar COALESCE for gitlab_epic, gtm, url_slug, type
        FROM prep_crm_unioned_touchpoint
        LEFT JOIN union_types sfdc_campaigns
            ON sfdc_campaigns.join_string_type = 'sfdc_campaigns'
            AND prep_crm_unioned_touchpoint.dim_campaign_id = sfdc_campaigns.join_string
        LEFT JOIN union_types utm_campaigns
            ON utm_campaigns.join_string_type = 'utm_campaign_name'
            AND prep_crm_unioned_touchpoint.utm_campaign = utm_campaigns.join_string
        -- Additional LEFT JOIN clauses for form_urls, landing_pages, pathfactory_landing
    )
    ```

4.  **Final Selection:** The final selection (`final` CTE) selects all the columns that are content names, gitlab epic, gtm, url slug and type from the `combined_model` CTE where the `content_name` is NOT NULL.

**Output:**

The model outputs touchpoint IDs linked to the following content attributes:

*   `content_name`: The name of the keystone content.
*   `gitlab_epic`: The GitLab Epic associated with the content.
*   `gtm`: The GTM motion associated with the content.
*   `url_slug`: The URL slug of the content.
*   `type`: The content type.

These attributes enrich the [CRM Touchpoint Dimension](chapter_310.md), enabling more detailed analysis of marketing touchpoint performance.

**Example:**

Let's say a touchpoint with `bizible_form_url` equal to `https://about.gitlab.com/analyst-reports/kuppingercole-leadership-compass/` is processed. If the `content_keystone_source` YAML file contains a mapping like:

```yaml
content:
  - name: KuppingerCole Leadership Compass Report
    url_slug: kuppingercole-leadership-compass
    gitlab_epic: &epic 1234
    gtm: Application Security
    type: Analyst Report
    form_urls:
      - https://about.gitlab.com/analyst-reports/kuppingercole-leadership-compass/
```

Then the `prep_bizible_touchpoint_keystone` model will output a record with:

*   `dim_crm_touchpoint_id`: \[Touchpoint ID]
*   `content_name`: KuppingerCole Leadership Compass Report
*   `gitlab_epic`: 1234
*   `gtm`: Application Security
*   `url_slug`: kuppingercole-leadership-compass
*   `type`: Analyst Report

This enriched data then populates the `dim_crm_touchpoint` table, allowing for detailed reports like "Number of touchpoints associated with Application Security GTM motion" or "Touchpoints related to content in GitLab Epic 1234."

**Benefits:**

*   **Enhanced Reporting:** Provides more granular data for analyzing touchpoint performance based on content attributes.
*   **Improved Attribution:**  Facilitates better attribution modeling by linking touchpoints to specific GTM motions and strategic content initiatives.
*   **Data-Driven Content Strategy:**  Informs content strategy by identifying high-performing content pieces and their impact on the customer journey.
*   **Simplifies Downstream Analysis:** By denormalizing these relationships, makes it easier and faster to perform common queries in analytics tools.
