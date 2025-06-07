## Chapter 5. Restricted Safe Preparation Tables
Details the creation of restricted safe preparation tables:

*   **5.1. prep_crm_account**
    *   Source: `sfdc_account`, `map_merged_crm_account`, `prep_crm_person`, `sfdc_user_roles_source`
    *   Key transformations: Combines account data with ultimate parent information, applies mappings, and derives metrics like employee count band

The `prep_crm_account` table is a restricted safe preparation table that aggregates and transforms data from various sources to create a comprehensive view of CRM accounts. It enriches account information with ultimate parent details, applies mappings for data consistency, and derives key metrics.

**Sources:**

*   `sfdc_account`: This source provides the base CRM account data directly from Salesforce. It includes standard account attributes such as name, industry, billing address, employee count, and owner information.  The SQL code to access this table is:
    ```sql
    SELECT * FROM "PREP".sfdc.sfdc_account_source
    ```
    and includes `WHERE account_id IS NOT NULL` clause.

*   `map_merged_crm_account`: This mapping table resolves merged account records, ensuring data consistency by linking child accounts to their master records.
    ```sql
    SELECT * FROM "PROD".restricted_safe_common_mapping.map_merged_crm_account
    ```

*   `prep_crm_person`: This table provides information about CRM persons associated with the accounts, including their roles and contact details.
    ```sql
    SELECT * FROM "PROD".common_prep.prep_crm_person
    ```

*   `sfdc_user_roles_source`: This source is used to pull in user role data from Salesforce, specifically used for account owner information.
    ```sql
    SELECT * FROM "PREP".sfdc.sfdc_user_roles_source
    ```

**Key Transformations:**

1.  **Ultimate Parent Information:** The table enriches account data by incorporating information from the ultimate parent account, providing a hierarchical view of the organization. This includes details such as the parent account's name, sales segment, industry, and territory.  The parent account id is obtained from `sfdc_account.ultimate_parent_account_id`.

2.  **Data Mapping:**  A mapping table (`map_merged_crm_account`) is used to resolve merged account records, ensuring that all related data is associated with the correct master account.

3.  **Employee Count Band:** The table derives a metric for employee count band (`crm_account_employee_count_band`) based on the account's employee count. This categorizes accounts into different size bands based on the number of employees. The logic is:
    ```sql
    CASE
         WHEN sfdc_account.account_max_family_employee > 2000 THEN 'Employees > 2K'
         WHEN sfdc_account.account_max_family_employee <= 2000 AND sfdc_account.account_max_family_employee > 1500 THEN 'Employees > 1.5K'
         WHEN sfdc_account.account_max_family_employee <= 1500 AND sfdc_account.account_max_family_employee > 1000  THEN 'Employees > 1K'
         ELSE 'Employees < 1K'
      END
    ```

4.  **Data Governance & Filtering:** The final SELECT statement includes the clause `WHERE sfdc_account.account_id IS NOT NULL` to exclude null account ID.

*   **5.2. prep_charge_mrr**
    *   Source: `prep_charge`, `prep_date`
    *   Key transformations: Calculates monthly recurring revenue (MRR) for active subscriptions

The `prep_charge_mrr` table is a restricted safe preparation table designed to calculate monthly recurring revenue (MRR) for active subscriptions. It combines charge data with date information to provide a time-series view of MRR.

**Sources:**

*   `prep_charge`: This table contains detailed information about individual charges, including the subscription name, charge amount, effective dates, and product details.  It is accessed using the SQL code:
    ```sql
    SELECT * FROM "PROD".restricted_safe_common_prep.prep_charge
    ```

*   `prep_date`: This table provides date dimension information, including attributes such as the first day of the month and the first day of the fiscal quarter.
    ```sql
    SELECT * FROM "PROD".common_prep.prep_date
    ```

**Key Transformations:**

1.  **Active Subscription Filtering:** The table filters for charges associated with active or cancelled subscriptions (`WHERE prep_charge.subscription_status IN ('Active', 'Cancelled')`).

2.  **Recurring Charge Selection:** The table focuses on recurring charges by including only records where `prep_charge.charge_type = 'Recurring'`.

3.  **MRR Calculation:** The table selects monthly recurring revenue (MRR) from the source `prep_charge.mrr` table.

4.  **ARR Cohort Month and Quarter:** The table determines the cohort month and quarter of the crm accounts ARR by taking the min of the date.

5.  **Data Governance & Filtering:**
    *   The final SELECT statement includes an exclusion for Education customers (charge name EDU or OSS) with free subscriptions by applying the clause `AND (prep_charge.mrr != 0 OR LOWER(prep_charge.rate_plan_charge_name) = 'max enrollment')`.
    *  The final SELECT statement includes the clause `AND prep_charge.is_included_in_arr_calc = TRUE` to only include rate plan charges that should be included in the ARR calculation.
</output>