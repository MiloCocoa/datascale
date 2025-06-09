### 3.5. CRM User (`dim_crm_user`)

The `dim_crm_user` table is a vital dimension in our data mart, offering a comprehensive view of users within our CRM system. It provides the necessary context to analyze activities and performance at the individual and organizational levels. This chapter details the purpose, source model, and key fields of the `dim_crm_user` table.

**Use Case:** Imagine wanting to analyze the performance of marketing campaigns based on the sales segment of the users who own those campaigns. To achieve this, you would need a reliable source that links campaign activities to user attributes, which is precisely what the `dim_crm_user` table provides.

*   **Purpose**: Provides a comprehensive dimension for attributing activities and performance to specific users and their respective organizational hierarchies.

    The main goal of `dim_crm_user` is to serve as a central repository for user-related information, enabling consistent and accurate attribution across different analyses. It helps answer questions like:

    *   How does campaign performance vary across different sales segments?
    *   Which user roles are most effective at converting leads?
    *   What are the key characteristics of high-performing users?
*   **Source Model**: Derived from [prep_crm_user](chapter_451.md).

    The `dim_crm_user` table is built from the `prep_crm_user` model. This preparatory model consolidates and cleans data from raw Salesforce User data, including role hierarchy and sales segmentation. By using a dedicated prep model, we ensure that the `dim_crm_user` table contains standardized and reliable information.

    Here’s a simplified example of how `prep_crm_user` prepares the data:

    ```sql
    SELECT
      user_id AS dim_crm_user_id,
      name AS user_name,
      title,
      department,
      team,
      is_active,
      user_role_name,
      crm_user_sales_segment
    FROM sfdc_users_source
    ```

    This SQL snippet showcases the selection and renaming of fields from the raw Salesforce User data (`sfdc_users_source`) to align with the `dim_crm_user` schema.
*   **Key Fields**: `employee_number`, `user_name`, `title`, `department`, `team`, `manager_name`, `user_email`, `is_active`, `user_role_name` (and various `user_role_level_` fields), `crm_user_sales_segment` (and other geo/region/area fields), `is_hybrid_user`, `sdr_sales_segment`, `sdr_region`, and derived `crm_user_sub_business_unit`, `crm_user_division`, `asm` fields for specialized reporting.

    The `dim_crm_user` table includes a variety of fields that capture different aspects of a CRM user's profile. Here are some of the key fields and their descriptions:

    *   `dim_crm_user_id`: Unique identifier for the CRM user.
    *   `employee_number`: The employee number of the user.
    *   `user_name`: The full name of the user.
    *   `title`: The job title of the user.
    *   `department`: The department the user belongs to.
    *   `team`: The team the user is a member of.
    *   `manager_name`: The name of the user's manager.
    *   `user_email`: The email address of the user.
    *   `is_active`: A boolean flag indicating whether the user is currently active.
    *   `user_role_name`: The name of the user's role.
    *   `crm_user_sales_segment`: The sales segment the user is assigned to.
    *    ...and other geo/region/area fields: geo/region/area of this CRM user
    *   `is_hybrid_user`: Indicates user work type
    *   `sdr_sales_segment`: Segment of Sales Development Rep
    *   `crm_user_sub_business_unit`: The sub business unit the user belongs to.
    *   `crm_user_division`: The division of the user
    *   `asm`: ASM fields for specialized reporting.

    These fields allow for detailed filtering, grouping, and analysis of user data. For example, you can use the `crm_user_sales_segment` field to segment users by their respective sales segments and then analyze their performance.

    Here's a code snippet that demonstrates how to select key fields from the `dim_crm_user` table:

    ```sql
    SELECT
        dim_crm_user_id,
        user_name,
        title,
        department,
        crm_user_sales_segment
    FROM PROD.common.dim_crm_user
    ```

    This SQL query retrieves the user ID, name, title, department, and sales segment for all users in the `dim_crm_user` table.

By understanding the purpose, source model, and key fields of the `dim_crm_user` table, you can leverage this dimension to gain valuable insights into your CRM users and their impact on your organization's performance.