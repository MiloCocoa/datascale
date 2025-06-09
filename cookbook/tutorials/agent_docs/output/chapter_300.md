## 3. Core CRM Entities

This section details the primary dimension and fact tables that capture the essential attributes and activities of key CRM entities. These tables serve as fundamental building blocks for comprehensive marketing and sales analytics.

Imagine you're a marketing analyst tasked with understanding the performance of various marketing campaigns and their impact on customer acquisition. To do this effectively, you need a structured and reliable source of data about your customers, their interactions, and the campaigns targeting them. This is where core CRM entities come into play. This section will describe the primary tables that will be used to explore the connections between these entities.

These tables form the foundation for building more complex analyses, such as attribution modeling, customer segmentation, and lifecycle stage analysis. Let's dive into the details of each entity.

### 3.1. CRM Touchpoint (`dim_crm_touchpoint`)

The `dim_crm_touchpoint` table stores descriptive attributes of each individual marketing touchpoint. This includes details about how and where the interaction occurred, as well as associated marketing metadata.

*   **Purpose**: Provides a detailed, de-duplicated record of every marketing interaction, enriched with parsed UTM parameters and derived channel groupings.

    For example, a touchpoint might represent a user clicking on an ad, filling out a form, or attending a webinar. Each touchpoint is associated with metadata like the campaign it belongs to, the channel through which it was delivered, and UTM parameters that provide further context.

*   **Source Models**: Primarily derived from [prep_crm_touchpoint](chapter_421.md) and [prep_crm_attribution_touchpoint](chapter_422.md), then joined with [map_bizible_campaign_grouping](chapter_423.md), `sheetload_devrel_influenced_campaigns_source`, and [prep_bizible_touchpoint_keystone](chapter_424.md).

    These source models perform the heavy lifting of cleaning, transforming, and enriching the raw touchpoint data.

*   **Key Fields**:

    *   `bizible_touchpoint_date`: The date when the touchpoint occurred.
    *   `bizible_touchpoint_type`: The type of touchpoint (e.g., 'Web Form', 'Web Chat').
    *   `bizible_touchpoint_position`: Indicates the position of the touchpoint in the customer journey (e.g., 'First Touch', 'Lead Creation').
    *   `bizible_marketing_channel`: The marketing channel through which the touchpoint was delivered (e.g., 'Paid Search', 'Email').
    *   `bizible_marketing_channel_path`: A more detailed categorization of the marketing channel (e.g., 'Paid Search.Google AdWords').
    *   `utm_campaign`: The UTM campaign parameter associated with the touchpoint.
    *   `utm_source`: The UTM source parameter associated with the touchpoint.
    *   `utm_medium`: The UTM medium parameter associated with the touchpoint.
    *   Parsed UTM parameters (`utm_campaign_date`, `utm_campaign_region`, `utm_content_offer`, etc.)
    *   `integrated_campaign_grouping`: A higher-level grouping of campaigns for reporting purposes.
    *   `gtm_motion`: The Go-To-Market motion associated with the touchpoint.
    *   `touchpoint_segment`: A segmentation of touchpoints based on their characteristics.
    *   `pipe_name`: A derived field indicating the pipeline stage associated with the touchpoint.
    *   `is_dg_influenced`: A flag indicating whether the touchpoint was influenced by a Digital Growth campaign.
    *   `is_devrel_influenced_campaign`: A flag indicating whether the touchpoint was influenced by a Developer Relations campaign.
    *   `keystone_content_name`: Name of the content as tracked in the keystone content YAML file.

*   **Calculations**: Includes complex parsing logic for UTM parameters to extract campaign and content details, as well as `pipe_name` and influence flags for reporting.

    For instance, the `pipe_name` field uses a series of CASE statements to categorize touchpoints based on their marketing channel path and other attributes:

    ```sql
     CASE
        WHEN dim_crm_touchpoint_id ILIKE 'a6061000000CeS0%' -- Specific touchpoint overrides
          THEN 'Field Event'
        WHEN bizible_marketing_channel_path = 'CPC.AdWords'
          THEN 'Google AdWords'
        WHEN bizible_marketing_channel_path IN ('Email.Other', 'Email.Newsletter','Email.Outreach')
          THEN 'Email'
        ELSE 'Unknown'
      END AS pipe_name
    ```

    This logic ensures consistent categorization of touchpoints for reporting and analysis.

### 3.2. CRM Person (`dim_crm_person`, `fct_crm_person`)

These tables provide a unified view of individuals (leads and contacts) within the CRM, capturing their demographic information, engagement data, and key lifecycle milestones.

#### 3.2.1. CRM Person Dimension (`dim_crm_person`)

*   **Purpose**: Stores master data attributes for individuals, providing a consistent view of leads and contacts across marketing and sales.

    This table acts as a central repository for information about each person in the CRM, allowing you to easily access their key attributes.

*   **Source Model**: Built directly from [prep_crm_person](chapter_411.md).

    The `prep_crm_person` model consolidates and cleanses data from various sources to create a unified person record.

*   **Key Fields**:

    *   `sfdc_record_id`: The unique identifier for the person in Salesforce.
    *   `email_hash`: An anonymized email identifier for privacy purposes.
    *   `email_domain`: The email domain of the person.
    *   `is_valuable_signup`: A flag indicating whether the person's signup is considered valuable.
    *   `marketo_lead_id`: The unique identifier for the person in Marketo.
    *   `owner_id`: The unique identifier of the user who owns the person record.
    *   `person_score`: A score representing the person's engagement and likelihood to convert.
    *   `title`: The person's job title.
    *   `country`: The person's country.
    *   `lead_source`: The original source of the lead (e.g., 'Web Form', 'Trade Show').
    *   `net_new_source_categories`: Broad categorization of the lead source.
    *   Account demographic fields (sales segment, geo, region, area).
    *   Various engagement scores from external tools (6Sense, UserGems, Groove, ZoomInfo).

#### 3.2.2. CRM Person Fact (`fct_crm_person`)

*   **Purpose**: Captures key dates and flags related to a person's progression through the marketing and sales funnel, enabling lifecycle stage analysis.

    This table tracks the important milestones in a person's journey, allowing you to understand how they move through the funnel.

*   **Source Models**: Combines [prep_crm_person](chapter_411.md) with MQL event data from `sfdc_leads` and `sfdc_contacts` (raw tables), and joins to account history from `sfdc_account_snapshots_source`.

    This model combines data from the `prep_crm_person` model with event data and account history to create a comprehensive view of a person's lifecycle.

*   **Key Dates**:

    *   `created_date`: The date when the person record was created.
    *   `inquiry_date`: The date when the person first expressed interest.
    *   `true_inquiry_date`: A more accurate date of first interest, accounting for data quality issues.
    *   `mql_date_first`: The date when the person first became a Marketing Qualified Lead (MQL).
    *   `mql_date_latest`: The date when the person most recently became an MQL.
    *   `accepted_date`: The date when the lead was accepted by sales.
    *   `qualified_date`: The date when the lead was qualified by sales.
    *   `converted_date`: The date when the lead was converted into an opportunity.

*   **Key Flags/Counts**:

    *   `is_mql`: A flag indicating whether the person is currently an MQL.
    *   `is_inquiry`: A flag indicating whether the person is an inquiry.
    *   `mql_count`: The number of times the person has been an MQL.
    *   `is_bdr_sdr_worked`: A flag indicating whether the person has been worked by a Business Development Representative (BDR) or Sales Development Representative (SDR).
    *   `is_partner_recalled`: A flag indicating if the person was recalled by a partner.
    *   `is_high_priority`: A flag to designate leads as high priority.
    *   ABM tier flags (`is_abm_tier_inquiry`, `is_abm_tier_mql`).
    *   Groove engagement metrics.

### 3.3. Campaign (`dim_campaign`, `fct_campaign`)

These tables provide comprehensive information about marketing campaigns, including their descriptive attributes and performance metrics.

#### 3.3.1. Campaign Dimension (`dim_campaign`)

*   **Purpose**: Stores static, descriptive attributes for marketing campaigns, including parent-child relationships and strategic groupings.

    This table provides the context for understanding your marketing campaigns, such as their type, status, and target audience.

*   **Source Model**: Derived from [prep_campaign](chapter_431.md).

    The `prep_campaign` model cleans and standardizes the raw campaign data.

*   **Key Fields**:

    *   `campaign_name`: The name of the campaign.
    *   `is_active`: A flag indicating whether the campaign is currently active.
    *   `status`: The current status of the campaign (e.g., 'Planned', 'In Progress', 'Completed').
    *   `type`: The type of campaign (e.g., 'Webinar', 'Email', 'Trade Show').
    *   `description`: A description of the campaign.
    *   `budget_holder`: The team or individual responsible for the campaign budget.
    *   `strategic_marketing_contribution`: A categorization of the campaign's strategic purpose.
    *   `large_bucket`: A higher-level grouping of campaigns for reporting purposes.
    *   `reporting_type`: A categorization of the campaigns for reporting purposes.
    *   `allocadia_id`: An identifier used to map campaigns to Allocadia, a marketing planning tool.
    *   Partner involvement flags.
    *   `sales_play`: Sales play associated with campaign.
    *   `total_planned_mqls`: The total number of MQLs planned for the campaign.
    *   `series_campaign_id`/`name`: If this campaign belongs to a series of campaigns, these fields capture its ID and name.
    *   `gtm_motion`: The go-to-market motion of the campaign

#### 3.3.2. Campaign Fact (`fct_campaign`)

*   **Purpose**: Contains additive measures and key dates for campaigns, facilitating quantitative performance analysis.

    This table provides the numbers you need to assess the effectiveness of your campaigns, such as their cost, revenue, and lead generation.

*   **Source Model**: Built directly from [prep_campaign](chapter_431.md).

    Like `dim_campaign`, the `fct_campaign` table is built from the `prep_campaign` model.

*   **Key Metrics**:

    *   `budgeted_cost`: The budgeted cost of the campaign.
    *   `expected_response`: The expected response rate of the campaign.
    *   `expected_revenue`: The expected revenue generated by the campaign.
    *   `actual_cost`: The actual cost of the campaign.
    *   `amount_all_opportunities`: The total value of all opportunities associated with the campaign.
    *   `amount_won_opportunities`: The total value of all won opportunities associated with the campaign.
    *   Various `count_` fields (contacts, leads, opportunities, responses, sent).
    *   Planned values for funnel stages (`planned_inquiry`, `planned_mql`, `planned_pipeline`, `planned_sao`, `planned_won`, `planned_roi`).

### 3.4. CRM Account (`dim_crm_account`)

The `dim_crm_account` table provides a holistic view of accounts within the CRM, encompassing their hierarchical structure, demographic information, and various health and engagement indicators.

*   **Purpose**: Serves as the central dimension for account-level analysis, integrating internal CRM data with external enrichment sources and data science scores.

    This table allows you to analyze your accounts based on a wide range of factors, from their industry and size to their health and engagement with your products.

*   **Source Models**: Based on [prep_crm_account](chapter_441.md) and joins with [prep_charge_mrr](chapter_445.md) for ARR cohort dates.

    The `prep_crm_account` model combines data from various sources to create a comprehensive account record. The `prep_charge_mrr` model provides data about the account's Annual Recurring Revenue (ARR).

*   **Key Fields**:

    *   `crm_account_name`: The name of the account.
    *   `dim_parent_crm_account_id`: The unique identifier of the parent account.
    *   `parent_crm_account_name`: The name of the parent account.
    *   `parent_crm_account_sales_segment`: The sales segment of the parent account.
    *   Other parent demographics.
    *   `crm_account_employee_count`: The number of employees at the account.
    *   `crm_account_gtm_strategy`: The Go-To-Market strategy for the account.
    *   `crm_account_focus_account`: A flag indicating whether the account is a focus account.
    *   Billing location.
    *   Industry.
    *   Various `is_` flags (e.g., `is_reseller`, `is_focus_partner`).
    *   `health_number`: Account health represented as a number
    *   `health_score_color`: Account health score represented as a color.
    *   D&B, 6sense, and Qualified fields.
    *   PTE/PTC/PTP scores.

### 3.5. CRM User (`dim_crm_user`)

The `dim_crm_user` table contains detailed information about CRM users, including their roles, departmental affiliations, and sales territories.

*   **Purpose**: Provides a comprehensive dimension for attributing activities and performance to specific users and their respective organizational hierarchies.

    This table allows you to analyze the performance of individual users and teams, as well as understand their roles and responsibilities within the organization.

*   **Source Model**: Derived from [prep_crm_user](chapter_451.md).

    The `prep_crm_user` model cleans and transforms the raw user data.

*   **Key Fields**:

    *   `employee_number`: The employee number of the user.
    *   `user_name`: The name of the user.
    *   `title`: The job title of the user.
    *   `department`: The department the user belongs to.
    *   `team`: The team the user belongs to.
    *   `manager_name`: The name of the user's manager.
    *   `user_email`: The email address of the user.
    *   `is_active`: A flag indicating whether the user is currently active.
    *   `user_role_name`: The role of the user.
    *   Various `user_role_level_` fields.
    *   `crm_user_sales_segment`: The sales segment of the user.
    *   Other geo/region/area fields.
    *   `sdr_sales_segment`/`sdr_region`:Captures SDR related segments
    *   Derived `crm_user_sub_business_unit`, `crm_user_division`, `asm` fields for specialized reporting.

By understanding these core CRM entities and their relationships, you'll be well-equipped to tackle a wide range of marketing and sales analytics challenges. The subsequent chapters on data preparation will provide further details on how these tables are constructed and maintained.