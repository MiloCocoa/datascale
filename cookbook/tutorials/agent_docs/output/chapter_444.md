#### 4.4.4. Data Science Scores (PTE, PTC)

Data science models provide valuable insights into account behavior and potential. These scores are used to enrich account data, helping to identify accounts that are likely to expand or contract. This section documents the raw data sources for these scores and how they are incorporated into the data model.

**Motivation**

Marketing and sales teams need predictive indicators to prioritize their efforts. Data science models provide these indicators in the form of scores, allowing teams to focus on accounts with the highest potential for growth or those at risk of churn.

**Central Use Case**

A marketing manager wants to identify high-potential accounts for a product expansion campaign. By leveraging the Product Expansion (PTE) score, the manager can create a targeted list of accounts that are most likely to adopt new products or features.

**Data Sources**

The data science scores are sourced from tables within the `RAW.data_science` schema.

*   **`pte_scores_source`**: Contains Product Expansion (PTE) scores.
*   **`ptc_scores_source`**: Contains Product Contraction (PTC) scores.

**Data Dictionary**

Let's examine the key fields in each raw data source.

**`pte_scores_source`**

| Field          | Data Type | Description                                                                  |
| -------------- | --------- | ---------------------------------------------------------------------------- |
| `crm_account_id` | VARCHAR   | The CRM account identifier. This links the score to a specific account.   |
| `score_date`     | TIMESTAMP | The date when the PTE score was calculated.                               |
| `score`          | NUMBER    | The Product Expansion score. Higher scores indicate a greater likelihood of expansion. |
| `decile`         | INTEGER   | The decile ranking of the PTE score, from 1 to 10.                         |
| `score_group`    | INTEGER   | A grouping of PTE scores.                                                  |

**Example `pte_scores_source` Record**

```sql
SELECT * FROM "PREP".data_science.pte_scores_source LIMIT 1;
```

```
crm_account_id: '001RM00000qD49XXXX'
score_date: '2024-07-26 00:00:00.000 +0000'
score: 0.85
decile: 9
score_group: 4
```

**`ptc_scores_source`**

| Field          | Data Type | Description                                                                  |
| -------------- | --------- | ---------------------------------------------------------------------------- |
| `crm_account_id` | VARCHAR   | The CRM account identifier. This links the score to a specific account.   |
| `score_date`     | TIMESTAMP | The date when the PTC score was calculated.                               |
| `score`          | NUMBER    | The Product Contraction score. Higher scores indicate a greater likelihood of contraction. |
| `decile`         | INTEGER   | The decile ranking of the PTC score, from 1 to 10.                         |
| `score_group`    | INTEGER   | A grouping of PTC scores.                                                  |

**Example `ptc_scores_source` Record**

```sql
SELECT * FROM "PREP".data_science.ptc_scores_source LIMIT 1;
```

```
crm_account_id: '0011100002JefExXXX'
score_date: '2024-07-26 00:00:00.000 +0000'
score: 0.20
decile: 2
score_group: 1
```

**Data Preparation**

These raw data sources are consumed by the following preparatory models:

*   [CRM Account Prep (`prep_crm_account`)](chapter_441.md)
*   [CRM Account Daily Snapshot Prep (`prep_crm_account_daily_snapshot`)](chapter_442.md)

These models perform the necessary transformations and joins to incorporate the PTE and PTC scores into the [CRM Account Dimension](chapter_3.4.md) and other relevant tables.

**Implementation Details**

Within the preparatory models, the PTE and PTC scores are joined to the account data based on the `crm_account_id`. The most recent score for each account is typically selected to provide the most up-to-date assessment.

**Example Snippet from `prep_crm_account`**

```sql
LEFT JOIN pte_scores
  ON sfdc_account.account_id = pte_scores.account_id
    AND pte_scores.is_current = TRUE
LEFT JOIN ptc_scores
  ON sfdc_account.account_id = ptc_scores.account_id
    AND ptc_scores.is_current = TRUE
```

**Downstream Usage**

The PTE and PTC scores, once incorporated into the [CRM Account Dimension](chapter_3.4.md), can be used for:

*   **Segmentation**: Creating targeted lists of accounts for marketing campaigns.
*   **Prioritization**: Helping sales teams focus on accounts with the highest growth potential.
*   **Risk Management**: Identifying accounts that may be at risk of churn and require intervention.
*   **Reporting**: Measuring the overall health and potential of the customer base.
