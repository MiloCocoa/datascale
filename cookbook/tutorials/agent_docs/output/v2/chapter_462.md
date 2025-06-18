#### 4.6.2. Net IACV to Net ARR Ratio (`net_iacv_to_net_arr_ratio`)

In financial modeling, a common challenge is converting Incremental Annual Contract Value (IACV) to Net Annual Recurring Revenue (ARR). The `net_iacv_to_net_arr_ratio` seed table addresses this by providing conversion ratios tailored to specific user segments and order types. This allows for a more accurate estimation of Net ARR, particularly in scenarios where it isn't directly available.

*   **Purpose**: This table serves as a lookup, offering predefined ratios that translate IACV into Net ARR based on distinct user segments and order types. It's employed in the [CRM Opportunity Prep (`prep_crm_opportunity`)](chapter_461.md) model to infer Net ARR for opportunities lacking native Net ARR values.

*Use Case*: Imagine you're analyzing a sales opportunity for a "Mid-Market" customer with a "New" order type. The opportunity lists an IACV of \$10,000, but doesn't specify the Net ARR. By consulting the `net_iacv_to_net_arr_ratio` table, you find the corresponding ratio (e.g., 0.8). Multiplying the IACV by this ratio ( \$10,000 * 0.8) yields an estimated Net ARR of \$8,000.

*   **Source**:  `PREP.seed_sales.net_iacv_to_net_arr_ratio` (raw seed data). This indicates that the data is sourced from a manually maintained seed table, expected to be relatively static.

*Implementation Details*:

The `net_iacv_to_net_arr_ratio` table itself is quite simple. It's a basic lookup table with columns for `user_segment`, `order_type`, and `ratio_net_iacv_to_net_arr`.

In [CRM Opportunity Prep (`prep_crm_opportunity`)](chapter_461.md), the ratio is applied conditionally, as illustrated in the following SQL snippet:

```sql
SELECT
    sfdc_opportunity.*,
    net_iacv_to_net_arr_ratio.ratio_net_iacv_to_net_arr AS segment_order_type_iacv_to_net_arr_ratio,
    COALESCE(sfdc_opportunity.raw_net_arr,
             sfdc_opportunity.incremental_acv * net_iacv_to_net_arr_ratio.ratio_net_iacv_to_net_arr) AS net_arr
FROM sfdc_opportunity
LEFT JOIN net_iacv_to_net_arr_ratio
    ON sfdc_opportunity.user_segment_stamped = net_iacv_to_net_arr_ratio.user_segment
   AND sfdc_opportunity.order_type = net_iacv_to_net_arr_ratio.order_type

```

This code first attempts to retrieve the `raw_net_arr` value directly from the `sfdc_opportunity` table. If that value is null, it calculates an estimated `net_arr` by multiplying `incremental_acv` with the `ratio_net_iacv_to_net_arr` from the `net_iacv_to_net_arr_ratio` table, joining on `user_segment` and `order_type`. This ensures that a reasonable `net_arr` value is populated even when the raw data is missing.

*Considerations*:

*   **Data Staleness:** As a seed table, `net_iacv_to_net_arr_ratio` requires manual updates. It's essential to periodically review and adjust the ratios to reflect changes in pricing strategies or customer behavior.
*   **Granularity**: The accuracy of the estimated Net ARR depends on the granularity of the `user_segment` and `order_type` dimensions. If the segments are too broad, the ratios might not accurately reflect the specific circumstances of each opportunity.
*   **Alternatives**: More sophisticated models could be used to predict Net ARR, such as machine learning models trained on historical opportunity data. However, the `net_iacv_to_net_arr_ratio` table provides a simple and readily implementable solution.