### 4.4.1. CRM Account Prep (`prep_crm_account`)

The `prep_crm_account` model addresses the challenge of consolidating and cleaning raw Salesforce Account data, enriching it with information from various sources to create a comprehensive and consistent view of each account. This model is essential for accurate reporting and analysis of account-level metrics.

**Use Case:**

Imagine you need to analyze the sales pipeline by account segment and ARR cohort. To do this effectively, you need a single table that combines core account attributes (like name, segment, and industry) with derived metrics (like ARR cohort) and data science scores (like PTE and PTC). The `prep_crm_account` model provides this unified dataset.

**High-Level Purpose:**

The primary goal of `prep_crm_account` is to:

*   Clean and standardize account data from Salesforce.
*   Incorporate data from merged accounts, ensuring data consistency.
*   Add primary contact information to each account.
*   Integrate user roles and data science scores.

The output of this model is a comprehensive account dataset that serves as the foundation for the [CRM Account Dimension](chapter_304.md).

**Source Models:**

The `prep_crm_account` model draws data from several sources:

*   `sfdc_account_source` (raw): Raw Salesforce Account data.

    ```sql
    SELECT *
    FROM "PREP".sfdc.sfdc_account_source
    ```

*   [map_merged_crm_account](chapter_443.md):  Maps merged Salesforce accounts to their canonical IDs.
*   [prep_crm_person](chapter_411.md): Provides primary contact information.
*   `sfdc_user_roles_source` (raw): Contains user role information from Salesforce.

    ```sql
    SELECT *
    FROM "PREP".sfdc.sfdc_user_roles_source
    ```

*   [dim_date](chapter_471.md):  A standard date dimension table.
*   [prep_crm_user](chapter_451.md):  Provides CRM user information.
*   `sfdc_users_source` (raw): Contains raw user data from Salesforce.

    ```sql
    SELECT *
    FROM "PREP".sfdc.sfdc_users_source
    ```

*   `sfdc_record_type` (legacy):  A legacy table containing record type information.

    ```sql
    SELECT *
    FROM "PROD".legacy.sfdc_record_type
    ```

*   `pte_scores_source` (raw): Contains Product Expansion (PTE) scores from data science.

    ```sql
    SELECT *
    FROM "PREP".data_science.pte_scores_source
    ```

*   `ptc_scores_source` (raw): Contains Product Contraction (PTC) scores from data science.

    ```sql
    SELECT *
    FROM "PREP".data_science.ptc_scores_source
    ```

**Key Transformations & Logic:**

The model performs the following key transformations:

1.  **Joining Data Sources:**  The model starts by joining the raw `sfdc_account_source` table with other relevant tables to enrich the account data. This includes joins to `map_merged_crm_account` to handle merged accounts, `prep_crm_person` to get primary contact information, and `pte_scores_source` and `ptc_scores_source` to incorporate data science scores.

2.  **Merging Account Logic:** The model uses the `map_merged_crm_account` table to ensure that all historical data points to the correct, non-merged account ID. This is crucial for accurate time-series analysis.

    ```sql
    LEFT JOIN map_merged_crm_account
      ON sfdc_account.account_id = map_merged_crm_account.sfdc_account_id
    ```

3.  **Incorporating Primary Contact Information:** The model joins with `prep_crm_person` to pull in information about the primary contact associated with each account.

    ```sql
    LEFT JOIN prep_crm_person
      ON sfdc_account.primary_contact_id = prep_crm_person.sfdc_record_id
    ```

4.  **Integrating Data Science Scores:** The model joins with `pte_scores_source` and `ptc_scores_source` to add Product Expansion (PTE) and Product Contraction (PTC) scores to each account.

    ```sql
    LEFT JOIN pte_scores
      ON sfdc_account.account_id = pte_scores.account_id
        AND pte_scores.is_current = TRUE

    LEFT JOIN ptc_scores
      ON sfdc_account.account_id = ptc_scores.account_id
        AND ptc_scores.is_current = TRUE
    ```

5.  **Creating Hierarchy Keys**: The model also uses the `dim_crm_user` and `dim_date` dimensions to create keys necessary for proper hierarchy mapping to organizational roles and time periods, critical for accurate reporting

**Output:**

The `prep_crm_account` model outputs a comprehensive dataset with the following key fields:

*   `dim_crm_account_id`: Primary key for the CRM account.
*   `dim_parent_crm_account_id`: Foreign key to the parent account.
*   `crm_account_name`: Name of the CRM account.
*   `crm_account_sales_segment`: Sales segment of the CRM account.
*   `crm_account_industry`: Industry of the CRM account.
*   `crm_account_billing_country`: Billing country of the CRM account.
*    Various `is_` flags (e.g., `is_reseller`, `is_focus_partner`).
*   `health_number`: Account health score.
*   `pte_score`, `ptc_score`: Data science scores for product expansion and contraction.
*   `crm_account_arr_cohort_month`, `crm_account_arr_cohort_quarter`: Revenue Cohort dates derived from the  [prep_charge_mrr](chapter_445.md) model, indicating when the account first achieved its ARR.

**SQL Code Snippet:**

Below is a snippet of the SQL code that constructs the `prep_crm_account` model. Note the joins and transformations discussed above.
```sql
SELECT
      --primary key
      sfdc_account.account_id                                             AS dim_crm_account_id,
      --surrogate keys
      sfdc_account.ultimate_parent_account_id                             AS dim_parent_crm_account_id,
      sfdc_account.owner_id                                               AS dim_crm_user_id,
      map_merged_crm_account.dim_crm_account_id                           AS merged_to_account_id,
      ...
    FROM sfdc_account
    LEFT JOIN map_merged_crm_account
      ON sfdc_account.account_id = map_merged_crm_account.sfdc_account_id
    LEFT JOIN sfdc_record_type
      ON sfdc_account.record_type_id = sfdc_record_type.record_type_id
    LEFT JOIN prep_crm_person
      ON sfdc_account.primary_contact_id = prep_crm_person.sfdc_record_id
    LEFT JOIN pte_scores
      ON sfdc_account.account_id = pte_scores.account_id
        AND pte_scores.is_current = TRUE
    LEFT JOIN ptc_scores
      ON sfdc_account.account_id = ptc_scores.account_id
        AND ptc_scores.is_current = TRUE
    ...
```

**Downstream Usage:**

The `prep_crm_account` model primarily feeds the [CRM Account Dimension](chapter_304.md), providing a clean, consistent, and enriched dataset for account-level analysis. It also supplies key stamped attributes to the [prep_crm_opportunity](chapter_461.md) model.

By understanding the purpose, sources, and logic of the `prep_crm_account` model, you can effectively leverage it for account-centric reporting and analysis.
