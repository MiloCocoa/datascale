#### 4.4.5. Charge and MRR Data for Accounts

This section dives into how we utilize Zuora billing data to derive key account metrics, specifically focusing on Monthly Recurring Revenue (MRR) and ARR cohorts. Analyzing billing data is crucial for understanding revenue trends, customer lifetime value, and the overall financial health of our accounts. The transformations detailed here enable us to accurately track and report on these essential metrics.

*   **Use Case**: Accurately determine the ARR cohort for a given CRM account to understand when it became a revenue-generating entity. This enables cohort-based performance analysis and targeted marketing efforts.

The preparatory models responsible for this are:

*   [`prep_charge_mrr`](chapter_445.md): Calculates Monthly Recurring Revenue (MRR) based on Zuora charge data and identifies revenue cohorts (`crm_account_arr_cohort_month`, `crm_account_arr_cohort_quarter`) for accounts. It is built from [`prep_charge`](chapter_446.md) and [`prep_date`](chapter_471.md) and influences [CRM Account Dimension](chapter_3.4.md).
*   [`prep_charge`](chapter_446.md): Consolidates and cleans various Zuora and Zuora Revenue charge-related data for ARR analysis, including manual adjustments. It sources data from `zuora_rate_plan`, `zuora_rate_plan_charge`, `zuora_order_action_rate_plan`, `zuora_order_action`, `revenue_contract_line`, `zuora_order`, `charge_contractual_value`, `booking_transaction` (all raw `PREP` sources), and joins with `sfdc_account_source`, `zuora_account`, `zuora_subscription` (raw `PREP` sources), and [`map_merged_crm_account`](chapter_443.md).

Let's break down each model:

### `prep_charge_mrr`

This model is the primary engine for calculating MRR and assigning ARR cohorts.

**Purpose:**

*   Calculates the MRR for each account based on recurring charge data from Zuora.
*   Identifies the month and quarter in which an account first generated ARR, creating the `crm_account_arr_cohort_month` and `crm_account_arr_cohort_quarter` fields. This is essential for cohort analysis.

**Source Models:**

*   [`prep_charge`](chapter_446.md): Provides the cleaned and consolidated charge data.
*   [`prep_date`](chapter_471.md): Used to extract the first day of the month and fiscal quarter for cohort assignment.

**Key Transformations:**

1.  **Joining Charge Data with Date Dimension**: Links the cleaned charge data from `prep_charge` with the date dimension (`prep_date`) using the `effective_start_month` field. This enables temporal analysis of MRR.
2.  **Filtering Active Subscriptions**: Filters the data to include only "Active" and "Cancelled" subscriptions, providing a focused view of relevant accounts.
3.  **Cohort Assignment**: Calculates the minimum (earliest) `first_day_of_month` and `first_day_of_fiscal_quarter` for each account, effectively defining the account's ARR cohort.

**Influence on Downstream Models:**

*   [CRM Account Dimension](chapter_3.4.md) (`dim_crm_account`): The calculated ARR cohort fields are ingested into the [CRM Account Dimension](chapter_3.4.md), enabling reporting and analysis based on revenue cohorts.

**Example Code Snippet:**

```sql
SELECT
  prep_charge_mrr.dim_crm_account_id,
  MIN(prep_date.first_day_of_month) AS crm_account_arr_cohort_month,
  MIN(prep_date.first_day_of_fiscal_quarter) AS crm_account_arr_cohort_quarter
FROM prep_charge_mrr
LEFT JOIN prep_date
  ON prep_charge_mrr.date_id = prep_date.date_id
WHERE prep_charge_mrr.subscription_status IN ('Active', 'Cancelled')
GROUP BY 1
```

This snippet demonstrates the core logic of assigning ARR cohorts by finding the minimum `first_day_of_month` and `first_day_of_fiscal_quarter` for each account.

### `prep_charge`

This model serves as a crucial data preparation step, consolidating and cleaning charge data from various Zuora and Zuora Revenue sources.

**Purpose:**

*   To consolidate charge related information from different sources for comprehensive ARR analysis.
*   To perform data cleaning and standardization, addressing inconsistencies and ensuring data quality.
*   To apply manual adjustments to ARR calculations, accounting for real-world scenarios not captured in raw data.

**Source Models:**

*   **Zuora Data**: `zuora_rate_plan`, `zuora_rate_plan_charge`, `zuora_order_action_rate_plan`, `zuora_order_action`, `zuora_order`, `zuora_account`, `zuora_subscription`
*   **Zuora Revenue Data**:  `revenue_contract_line`
*   **Manual Adjustment Data**: `charge_contractual_value`, `booking_transaction`
*   **Mapping Data**: [`map_merged_crm_account`](chapter_443.md)
*   **Salesforce Data**:  `sfdc_account_source`

**Key Transformations:**

1.  **Data Consolidation**: Combines data from numerous raw Zuora tables to create a unified view of charge information.
2.  **Data Cleaning**: Standardizes data formats and handles inconsistencies across different data sources.
3.  **Manual Adjustments**: Incorporates data from `charge_contractual_value` and `booking_transaction` to account for manual adjustments to ARR.
4.  **Joining CRM Data**: Links Zuora data to Salesforce account data using [`map_merged_crm_account`](chapter_443.md), enriching the charge data with CRM context.

**Internal Implementation**

The `prep_charge` model implements various data quality checks and transformations on top of multiple raw data sources, ensuring the charge data is consistent and accurate.

**Example Code Snippet:**

The model contains a series of joins to bring together information from all of these sources

```sql
    FROM zuora_rate_plan
    INNER JOIN zuora_rate_plan_charge
      ON zuora_rate_plan.rate_plan_id = zuora_rate_plan_charge.rate_plan_id
    INNER JOIN zuora_subscription
      ON zuora_rate_plan.subscription_id = zuora_subscription.subscription_id
    INNER JOIN zuora_account
      ON zuora_subscription.account_id = zuora_account.account_id
    LEFT JOIN map_merged_crm_account
      ON zuora_account.crm_id = map_merged_crm_account.sfdc_account_id
    LEFT JOIN sfdc_account
      ON map_merged_crm_account.dim_crm_account_id = sfdc_account.account_id
    LEFT JOIN charge_to_order
      ON zuora_rate_plan_charge.rate_plan_charge_id = charge_to_order.rate_plan_charge_id
    LEFT JOIN charge_contractual_value
      ON charge_contractual_value.rate_plan_charge_id = zuora_rate_plan_charge.rate_plan_charge_id
    LEFT JOIN booking_transaction
      ON booking_transaction.rate_plan_charge_id = zuora_rate_plan_charge.rate_plan_charge_id
```

This excerpt illustrates the extensive joining logic required to integrate data from various Zuora sources, creating a consolidated view of charge information. This information is cleaned and formatted to prepare it for the next steps.

**In Summary**

Together, `prep_charge_mrr` and `prep_charge` create a robust framework for analyzing revenue and cohort data, providing essential insights for marketing, sales, and finance teams. They address the core need of converting raw billing data into actionable intelligence, enabling a data-driven approach to understanding and improving business performance.
