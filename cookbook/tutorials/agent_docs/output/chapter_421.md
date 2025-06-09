#### 4.2.1. Bizible Touchpoint Prep (`prep_crm_touchpoint`)

##### Purpose

The `prep_crm_touchpoint` model is designed to transform raw Bizible touchpoint data into a structured and categorized format, which is essential for effective marketing analytics. This model addresses the challenge of working with unstructured raw data by cleaning, categorizing, and grouping touchpoints based on various attributes such as URLs and campaign names. The goal is to enrich these touchpoint records, making them easier to analyze and report on.

A central use case for this model is to identify and classify different types of marketing interactions, such as content offers, to understand which strategies are most effective. For example, we can use this model to differentiate between touchpoints related to webinars, ebooks, or product demos.

##### Sources

The `prep_crm_touchpoint` model derives its data from the following sources:

*   `sfdc_bizible_touchpoint_source` (raw): This is the primary source, providing the raw Bizible touchpoint data directly from Salesforce.
*   `sheetload_bizible_to_pathfactory_mapping` (legacy): This sheetload table provides a mapping between Bizible URLs and PathFactory content, used for enriching touchpoint records with content information.
*   [prep_campaign](chapter_431.md): This model, documented in [Campaign Prep](chapter_431.md), is used to join campaign information with touchpoint data, providing additional context for categorization.

##### Output

The primary output of the `prep_crm_touchpoint` model is enriched touchpoint records, specifically with the `touchpoint_offer_type` and `touchpoint_offer_type_grouped` fields. These fields categorize the touchpoints based on parsing rules applied to the URLs and campaign names.

*   `touchpoint_offer_type`: A detailed classification of the touchpoint, such as "Webinar", "eBook", or "Product Demo".
*   `touchpoint_offer_type_grouped`: A higher-level grouping of the offer type, such as "Events", "Online Content", or "Trials".

These enriched touchpoint records then feed into the [CRM Touchpoint Dimension](chapter_310.md) (`dim_crm_touchpoint`), providing a more detailed and structured view of marketing interactions.

##### Implementation Details

The `prep_crm_touchpoint` model cleans and categorizes raw Bizible touchpoint data by extracting offer types and grouping them. It identifies patterns in URLs and campaign names to classify touchpoints. Let's examine a simplified version of the code to understand how these calculations are performed:

```sql
CASE
  WHEN bizible_touchpoint_type = 'Web Chat'
    THEN 'Web Chat'
  WHEN bizible_touchpoint_type IN ('Web Form', 'marketotouchpoin')
    AND bizible_form_url_clean IN ('gitlab.com/-/trial_registrations/new',
                            'gitlab.com/-/trial_registrations',
                            'gitlab.com/-/trials/new')
    THEN 'GitLab Dot Com Trial'
  WHEN bizible_form_url_clean LIKE '%/sign_up%'
    OR bizible_form_url_clean LIKE '%/users%'
    THEN 'Sign Up Form'
    ...
  ELSE 'Other'
END AS touchpoint_offer_type_wip,
CASE
  WHEN pathfactory_content_type IS NOT NULL
    THEN pathfactory_content_type
  WHEN (touchpoint_offer_type_wip = 'Online Content'
    AND bizible_form_url_clean LIKE '%registration-page%'
    OR bizible_form_url_clean LIKE '%registrationpage%'
    OR bizible_form_url_clean LIKE '%inperson%'
    OR bizible_form_url_clean LIKE '%in-person%')
    OR touchpoint_offer_type_wip = 'Event Registration'
    THEN 'Event Registration'
  ...
  ELSE touchpoint_offer_type_wip
END AS touchpoint_offer_type,
```

In this code snippet:

*   The first `CASE` statement categorizes touchpoints based on `bizible_touchpoint_type` and cleaned URLs (`bizible_form_url_clean`).
*   The second `CASE` statement refines the categorization using `pathfactory_content_type` (from the sheetload mapping) and additional URL patterns.

The model also includes logic to group touchpoint offer types into higher-level categories:

```sql
CASE
  WHEN bizible_marketing_channel = 'Event'
    OR touchpoint_offer_type = 'Event Registration'
      OR touchpoint_offer_type = 'Webcast'
      OR touchpoint_offer_type = 'Workshop'
    THEN 'Events'
  WHEN touchpoint_offer_type_wip = 'Online Content'
    THEN 'Online Content'
  ...
  ELSE 'Other'
END AS touchpoint_offer_type_grouped
```

Here, touchpoints are grouped into categories like "Events", "Online Content", and "Other", providing a simplified view for reporting.

By implementing these transformations, the `prep_crm_touchpoint` model enriches raw Bizible touchpoint data, making it more accessible and useful for marketing analytics.