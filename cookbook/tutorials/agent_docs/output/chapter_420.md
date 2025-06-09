## 4.2. CRM Touchpoint Data Preparation

This chapter delves into the data preparation steps specifically for CRM touchpoint data. Marketing analytics relies heavily on understanding how customers interact with various touchpoints. Therefore, meticulously preparing this data is critical. This involves cleaning, categorizing, and enriching raw touchpoint data from Bizible, and linking them to internal content for comprehensive analysis.

### Use Case: Analyzing Touchpoint Attribution

Let's imagine a marketing analyst wants to determine which marketing activities are most effective at driving customer engagement. This requires a consolidated view of all touchpoints with enriched information for proper attribution.

To solve this, we rely on CRM touchpoint data.

### The `prep_crm_touchpoint` and `prep_crm_attribution_touchpoint` Models

These models serve as the foundation for preparing raw Bizible touchpoint data.

*   **Purpose**: They clean and categorize raw Bizible touchpoint data. They identify patterns in URLs and campaign names to classify touchpoints and extract offer types.
*   **Sources**:
    *   `sfdc_bizible_touchpoint_source` (raw): Raw Bizible touchpoint data.
    *   `sfdc_bizible_attribution_touchpoint_source` (raw): Raw Bizible attribution touchpoint data.
    *   `sheetload_bizible_to_pathfactory_mapping` (legacy): Manual mappings for Bizible URLs to PathFactory content (more on this later).
    *   [Campaign Prep (`prep_campaign`)](chapter_4.3.1.md): Used to bring in Campaign details.
*   **Output**: Enriched touchpoint records with `touchpoint_offer_type` and `touchpoint_offer_type_grouped`.

Here's a simplified snippet from the `prep_crm_touchpoint` model:

```sql
SELECT
  touchpoint_id,
  bizible_touchpoint_date,
  bizible_touchpoint_type,
  -- ... other fields
  CASE
    WHEN bizible_touchpoint_type = 'Web Chat' THEN 'Web Chat'
    WHEN bizible_touchpoint_type = 'Web Form' AND bizible_form_url LIKE '%trial%' THEN 'Trial Form'
    ELSE 'Other'
  END AS touchpoint_offer_type
FROM sfdc_bizible_touchpoint_source
```

This code snippet demonstrates how the model categorizes touchpoints based on their type and associated URLs. A similar process is followed in  `prep_crm_attribution_touchpoint`.

### Linking to Internal Content: `prep_bizible_touchpoint_keystone`

To further enhance our touchpoint data, we need to link it to our internal content. This is where the `prep_bizible_touchpoint_keystone` model comes in.

*   **Purpose**: Maps touchpoints to internal 'Keystone' content from a YAML file.
*   **Sources**:
    *   `content_keystone_source` (raw): Raw content metadata defined in YAML.
    *   [Bizible Attribution Touchpoint Prep (`prep_crm_attribution_touchpoint`)](chapter_4.2.2.md) and [Bizible Touchpoint Prep (`prep_crm_touchpoint`)](chapter_4.2.1.md): Enriched touchpoint records.
*   **Output**: Touchpoint IDs linked to `content_name`, `gitlab_epic`, `gtm`, `url_slug`, and `type`.

This model enriches the touchpoint data with the following information:

*   `content_name`: Name of the content.
*   `gitlab_epic`: Link to the related GitLab Epic.
*   `gtm`: Go-To-Market motion.
*   `url_slug`: URL slug of the content.
*   `type`: Type of content.

Here is a simplified code snippet:

```sql
SELECT
  touchpoint_id,
  content_name,
  gitlab_epic,
  gtm,
  url_slug,
  type
FROM prep_crm_touchpoint
LEFT JOIN content_keystone_source ON prep_crm_touchpoint.bizible_form_url = content_keystone_source.form_url
```

### Campaign Grouping and Channel Path Mapping

To create consistent reporting, we need a way to categorize and group campaign data. Mapping tables are used for this purpose.

*   **`map_bizible_campaign_grouping`**: Defines rules to group Bizible touchpoints into integrated campaign groupings and GTM motions based on various touchpoint and campaign attributes.

    *   **Purpose**: This model helps in consolidating various touchpoints and campaigns for consistent reporting.
    *   **Output**: `bizible_integrated_campaign_grouping`, `gtm_motion`, and `touchpoint_segment` fields.
*   **`map_bizible_marketing_channel_path`**: Categorizes Bizible marketing channel paths into broader, more digestible grouped names (e.g., 'Inbound Free Channels', 'Inbound Paid').

    *   **Purpose**: It helps in classifying marketing channels for high-level analysis.
    *   **Output**: `bizible_marketing_channel_path_name_grouped` in `prep_bizible_marketing_channel_path`.

### How it All Fits Together

These models work together to prepare the CRM touchpoint data:

1.  Raw Bizible touchpoint data is ingested via `sfdc_bizible_touchpoint_source` and `sfdc_bizible_attribution_touchpoint_source`.
2.  `prep_crm_touchpoint` and `prep_crm_attribution_touchpoint` models clean and categorize touchpoints based on their attributes (URLs, campaign names, etc.).
3.  `prep_bizible_touchpoint_keystone` links the touchpoints to internal content metadata.
4.  `map_bizible_campaign_grouping` and `map_bizible_marketing_channel_path` categorize campaigns and channel paths for consistent reporting.
5.  The cleaned and enriched touchpoint data is now ready for use in downstream models, such as the [Marketing CRM Touchpoint Mart (`mart_crm_touchpoint`)](chapter_002.md).
