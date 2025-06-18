#### 4.1.2. Supporting Person Activity Data

These models address the need to incorporate sales activities, specifically tasks and events, into the broader context of CRM person data. By processing raw data from Salesforce on tasks and events, these models provide flags and metrics within the `prep_crm_person` model, enabling a holistic view of customer engagement. These models are essential to address questions like: "How active are our sales representatives with specific leads?" and "Are BDRs and SDRs actively working on MQLs?".

The core use case that these preparatory models enable is to flag whether a BDR or SDR has engaged with a specific lead or contact. This information is crucial for assessing the effectiveness of sales outreach and identifying leads that may require further attention.

Here's how the models contribute:

*   **`prep_crm_task`**: Processes raw Salesforce Task data.
*   **`prep_crm_event`**: Processes raw Salesforce Event data.

These models categorize and clean raw data, ultimately contributing to the `is_bdr_sdr_worked` flag in the [CRM Person Data Preparation](chapter_411.md) model, which is then used in both the [CRM Person Dimension](chapter_320.md) and the [CRM Person Fact](chapter_320.md).

Let's explore these models in detail:

*   **`prep_crm_task`**

    *   **Purpose:** This model focuses on cleaning and categorizing raw Salesforce Task data, sourced from the `sfdc_task_source` table. Its primary goal is to extract key information about tasks, such as their type, status, and associated performance metrics. This information is then used to determine the `is_bdr_sdr_worked` flag in the [CRM Person Data Preparation](chapter_411.md) model.
    *   **Source Model:** `sfdc_task_source`

        *   This source provides raw Salesforce Task data.

    *   **Key Transformations:**
        *   Extracting the task type and status.
        *   Categorizing tasks based on their subject and comments.
        *   Identifying tasks owned by BDRs and SDRs.
    *   **Example:**
        ```sql
        SELECT
          task_id,
          task_subject,
          task_status,
          owner_id
        FROM sfdc_task_source
        WHERE is_deleted = 'FALSE'
        ```
        This query selects a subset of fields from the raw `sfdc_task_source` table.
    *   **Output:** The primary output of this model is a cleaned and categorized dataset of Salesforce tasks. The `is_bdr_sdr_worked` flag in [CRM Person Data Preparation](chapter_411.md) utilizes this information to indicate whether a BDR or SDR has worked on a specific lead or contact.

*   **`prep_crm_event`**

    *   **Purpose**: The `prep_crm_event` model cleans and categorizes raw Salesforce Event data sourced from the `sfdc_event_source` table. Like `prep_crm_task`, it contributes to the `is_bdr_sdr_worked` flag in [CRM Person Data Preparation](chapter_411.md).
    *   **Source Model**: `sfdc_event_source`

        *   This source provides raw Salesforce Event data.

    *   **Key Transformations:**

        *   Extracting event types and related entity information.
        *   Categorizing events based on their subject.
        *   Identifying events associated with BDRs and SDRs.
    *   **Implementation Details:**

        *   The model performs joins with the `dim_crm_user` table to determine the roles of event attendees and organizers, using `employee_number` for matching.

    *   **Example:**
        ```sql
        SELECT
          event_id,
          event_subject,
          event_type,
          owner_id,
          booked_by_employee_number
        FROM sfdc_event_source
        ```
    *   **Output**: The primary output is a cleaned and categorized dataset of Salesforce events. The information is used to flag whether a BDR or SDR has engaged with a specific lead or contact within the [CRM Person Data Preparation](chapter_411.md) model.

In summary, the `prep_crm_task` and `prep_crm_event` models serve as critical data preparation steps to incorporate sales activities into the broader CRM data model. By extracting, cleaning, and categorizing task and event data, these models contribute to a more complete understanding of customer engagement, which then provides valuable insights.