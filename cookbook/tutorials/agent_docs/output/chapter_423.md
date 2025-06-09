#### 4.2.3. Bizible Campaign Grouping & Channel Path Mapping

These mapping tables are essential for ensuring consistent and insightful marketing analytics. Raw touchpoint data, especially from tools like Bizible, can be noisy and inconsistent. These tables provide a structured way to categorize and group this data, allowing for more meaningful comparisons and trend analysis.

*   Central Use Case: A marketing analyst wants to compare the performance of different marketing channels over time. Without consistent channel groupings, comparing "Paid Search - Google" from one month to "CPC - AdWords" from another would be inaccurate. These mapping tables solve this problem by providing a standardized way to group these disparate entries into a unified "Paid Search" category.

Let's delve into the specifics of each mapping table:

*   **`map_bizible_campaign_grouping`**: This table defines rules to group individual Bizible touchpoints into higher-level, integrated campaign groupings and GTM (Go-To-Market) motions.

    *   **Key Fields Impacted**: The primary goal of this mapping is to populate the `bizible_integrated_campaign_grouping`, `gtm_motion`, and `touchpoint_segment` fields within the [CRM Touchpoint Dimension](chapter_310.md). These fields are crucial for reporting and analyzing marketing performance at a strategic level.

    *   **Implementation Details**: The `map_bizible_campaign_grouping` table contains logic to evaluate various attributes of a touchpoint and its associated campaign. For instance, a rule might state that any touchpoint with `bizible_ad_campaign_name` containing "ABM" should be grouped into the "Account-Based Marketing" campaign grouping.

        *Example:*
        If a touchpoint's `bizible_ad_campaign_name` is "2023Q4_ABM_Webinar," this mapping would categorize it under the "Account-Based Marketing" grouping.

    *   **Code Example:**

        ```sql
        CASE
          WHEN LOWER(dim_campaign.budget_holder) = 'fmm'
            THEN 'Field Marketing'
          WHEN LOWER(dim_campaign.budget_holder) = 'dmp'
            THEN 'Digital Marketing'
          ...
        END AS integrated_budget_holder
        ```

        *Explanation*: This SQL code snippet is a simplified example of how budget holders from the `dim_campaign` table are mapped to integrated budget holder categories. Similar logic exists within the mapping table to group touchpoints based on various criteria.

*   **`map_bizible_marketing_channel_path`**: This table categorizes Bizible marketing channel paths into broader, more digestible grouped names. This allows for roll-up reporting and easier analysis of channel performance.

    *   **Key Fields Impacted**: The primary purpose is to populate the `bizible_marketing_channel_path_name_grouped` field, which is then used in the `prep_bizible_marketing_channel_path` preparation model.

    *   **Implementation Details**: This mapping is relatively straightforward, providing a direct mapping between specific channel paths and their grouped names. For example, "CPC.AdWords" would be mapped to "Inbound Paid."

    *   **Code Example:**
        ```sql
        CASE
          WHEN bizible_marketing_channel_path IN ('Other','Direct','Organic Search.Bing','Web Referral',
                                          'Social.Twitter','Social.Other' ,'Social.LinkedIn','Social.Facebook',
                                          'Organic Search.Yahoo','Organic Search.Google','Email','Organic Search.Other',
                                          'Event.Webcast','Event.Workshop','Content.PF Content',
                                          'Event.Self-Service Virtual Event')
                                            THEN 'Inbound Free Channels'
          WHEN bizible_marketing_channel_path IN ('Event.Virtual Sponsorship','Paid Search.Other','Event.Executive Roundtables'
                                        ,'Paid Social.Twitter','Paid Social.Other','Display.Other','Paid Search.AdWords'
                                        ,'Paid Search.Bing','Display.Google','Paid Social.Facebook','Paid Social.LinkedIn'
                                        ,'Referral.Referral Program','Content.Content Syndication','Event.Owned Event'
                                        ,'Other.Direct Mail','Event.Speaking Session','Content.Gated Content'
                                        ,'Event.Field Event','Other.Survey','Event.Sponsored Webcast'
                                        ,'Swag.Virtual','Swag.Direct Mail','Event.Conference','Event.Vendor Arranged Meetings')
                                            THEN 'Inbound Paid'
          WHEN bizible_marketing_channel_path IN ('IQM.IQM')       THEN 'Outbound'
          WHEN bizible_marketing_channel_path IN ('Trial.Trial')   THEN 'Trial'
          ELSE 'Other'
         END AS bizible_marketing_channel_path_name_grouped
        ```
        *Explanation*: This SQL code illustrates the mapping logic, grouping various specific `bizible_marketing_channel_path` values into broader categories.

In summary, these mapping tables play a vital role in transforming raw marketing touchpoint data into consistent and actionable insights. They provide a standardized framework for grouping and categorizing data, enabling more effective marketing analysis and decision-making.