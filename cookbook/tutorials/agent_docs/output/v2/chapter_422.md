#### 4.2.2. Bizible Attribution Touchpoint Prep (`prep_crm_attribution_touchpoint`)

This model addresses the need for enriched Bizible attribution touchpoint data, which is crucial for accurate multi-touch attribution modeling. It transforms raw data into a usable format for downstream analysis, specifically within the [CRM Touchpoint Dimension](chapter_310.md).

*   **Purpose**: Similar to `prep_crm_touchpoint`, this model cleans and categorizes raw Bizible attribution touchpoints. These touchpoints are specifically used in multi-touch attribution models, providing a more comprehensive view of marketing influence than single-touch models.

    For example, consider a customer who interacts with multiple marketing campaigns before converting. A first-touch or last-touch model might only attribute the conversion to the initial or final touchpoint, respectively. However, a multi-touch attribution model, leveraging data prepared by this model, can distribute credit across all touchpoints that influenced the customer's journey.
*   **Sources**: This model relies on the following sources:

    *   `sfdc_bizible_attribution_touchpoint_source` (raw): Raw data from Salesforce containing Bizible attribution touchpoints. This is the primary source of touchpoint data.
    *   `sheetload_bizible_to_pathfactory_mapping` (legacy): A legacy mapping table (likely manually maintained) that maps Bizible URLs to PathFactory content. While marked as legacy, it's still used to enrich touchpoint records with PathFactory content information where available.
    *   [Campaign Prep](chapter_431.md): The `prep_campaign` model provides campaign-related information, allowing the model to link touchpoints to specific marketing campaigns.
*   **Output**: The model outputs enriched attribution touchpoint records, ready for use in the [CRM Touchpoint Dimension](chapter_310.md). The key transformations include:

    *   **Data Cleaning**: Addressing inconsistencies and errors in the raw data.
    *   **Categorization**: Grouping touchpoints based on various criteria (e.g., offer type).
    *   **Enrichment**: Adding data from the `sheetload_bizible_to_pathfactory_mapping` and `prep_campaign` models.

Let's look at an example of how this model transforms the data. Suppose the raw `sfdc_bizible_attribution_touchpoint_source` table contains a touchpoint record with a `bizible_form_url` of `https://example.com/ebook-download`. The `prep_crm_attribution_touchpoint` model can use the `sheetload_bizible_to_pathfactory_mapping` table to determine that this URL corresponds to an eBook content asset in PathFactory. It enriches the touchpoint record with this PathFactory content information.

Here's a simplified example of what the transformation logic might look like:

```sql
SELECT
    touchpoint_id,
    bizible_touchpoint_date,
    -- Other fields
    CASE
        WHEN sheetload.pathfactory_content_type IS NOT NULL THEN sheetload.pathfactory_content_type
        ELSE 'Unknown'
    END AS touchpoint_offer_type
FROM
    sfdc_bizible_attribution_touchpoint_source
LEFT JOIN
    sheetload_bizible_to_pathfactory_mapping AS sheetload
    ON sfdc_bizible_attribution_touchpoint_source.bizible_form_url = sheetload.bizible_url
```

This code snippet shows how the `pathfactory_content_type` from `sheetload_bizible_to_pathfactory_mapping` is used to populate the `touchpoint_offer_type` field.

The `prep_crm_attribution_touchpoint` model is crucial because it provides clean and enriched data for multi-touch attribution models. These models, in turn, provide a more accurate understanding of how marketing efforts influence customer behavior. This understanding is vital for optimizing marketing spend, improving campaign performance, and driving revenue growth.
