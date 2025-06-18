#### 4.7.1. Date Dimension (`dim_date`)

The `dim_date` table solves the problem of inconsistent and unstructured date handling across various data sources. By providing a standardized date spine, it ensures uniform date-based analysis, enabling accurate temporal filtering and aggregation. This is crucial for tracking marketing performance trends over time, aligning data with fiscal calendars, and ensuring consistency in reporting.

**Use Case:** Analyzing website traffic trends over the past year.

Consider a scenario where you need to analyze the monthly website traffic for the past year. Different systems might log dates in various formats (YYYY-MM-DD, MM/DD/YYYY, etc.). Without a standard date dimension, aggregating this data would require complex and potentially error-prone transformations. The `dim_date` table simplifies this process by providing a consistent date spine, allowing you to easily group and analyze data by month, quarter, or year.

**High-Level Overview:**

The `dim_date` table provides a comprehensive date spine, enriched with various temporal attributes. These attributes enable consistent date-based analysis and reporting across the entire data mart.

**Key Features:**

*   **Standardized Date Spine**: Serves as a central repository for all date-related information.
*   **Temporal Attributes**: Includes attributes like day of the week, month, quarter, and fiscal year.
*   **Temporal Filtering & Aggregation**: Facilitates temporal filtering and aggregation.

**Source:**

The `dim_date` table is derived from the `prep_date` model, which uses the raw data from `date_details_source` and adds transformation logic.

**Implementation Details:**

Here's a breakdown of the implementation:

1.  **Source Data**: The `date_details_source` table (raw) likely contains basic date information, forming the foundation for the dimension.
2.  **Transformation with `prep_date`**: The `prep_date` model transforms the raw data by calculating additional fields. Below is a sample code representation of it:

    ```sql
    CREATE OR REPLACE VIEW "PROD".common_prep.prep_date AS
    WITH source AS (
      SELECT
      TO_NUMBER(TO_CHAR(date_actual::DATE,'YYYYMMDD'),'99999999')
                                    AS date_id,
        *
      FROM "PREP".date.date_details_source
    )
    SELECT *
    FROM source;
    ```

3.  **Final `dim_date` Table Creation**: The `dim_date` table is created from the transformed `prep_date` model.

    ```sql
    CREATE TABLE "PROD".common.dim_date as
    WITH dates AS (
      SELECT
        "DATE_ID",
      "DATE_DAY",
      "DATE_ACTUAL",
      "DAY_NAME",
      "MONTH_ACTUAL",
      "YEAR_ACTUAL",
      "QUARTER_ACTUAL",
      "DAY_OF_WEEK",
      "FIRST_DAY_OF_WEEK",
      "WEEK_OF_YEAR",
      "DAY_OF_MONTH",
      "DAY_OF_QUARTER",
      "DAY_OF_YEAR",
      "FISCAL_YEAR",
      "FISCAL_QUARTER",
      "DAY_OF_FISCAL_QUARTER",
      "DAY_OF_FISCAL_YEAR",
      "MONTH_NAME",
      "FIRST_DAY_OF_MONTH",
      "LAST_DAY_OF_MONTH",
      "FIRST_DAY_OF_YEAR",
      "LAST_DAY_OF_YEAR",
      "FIRST_DAY_OF_QUARTER",
      "LAST_DAY_OF_QUARTER",
      "FIRST_DAY_OF_FISCAL_QUARTER",
      "LAST_DAY_OF_FISCAL_QUARTER",
      "FIRST_DAY_OF_FISCAL_YEAR",
      "LAST_DAY_OF_FISCAL_YEAR",
      "WEEK_OF_FISCAL_YEAR",
      "WEEK_OF_FISCAL_QUARTER",
      "MONTH_OF_FISCAL_YEAR",
      "LAST_DAY_OF_WEEK",
      "QUARTER_NAME",
      "FISCAL_QUARTER_NAME",
      "FISCAL_QUARTER_NAME_FY",
      "FISCAL_QUARTER_NUMBER_ABSOLUTE",
      "FISCAL_MONTH_NAME",
      "FISCAL_MONTH_NAME_FY",
      "HOLIDAY_DESC",
      "IS_HOLIDAY",
      "LAST_MONTH_OF_FISCAL_QUARTER",
      "IS_FIRST_DAY_OF_LAST_MONTH_OF_FISCAL_QUARTER",
      "LAST_MONTH_OF_FISCAL_YEAR",
      "IS_FIRST_DAY_OF_LAST_MONTH_OF_FISCAL_YEAR",
      "SNAPSHOT_DATE_FPA",
      "SNAPSHOT_DATE_FPA_FIFTH",
      "SNAPSHOT_DATE_BILLINGS",
      "DAYS_IN_MONTH_COUNT",
      "DAYS_IN_FISCAL_QUARTER_COUNT",
      "WEEK_OF_MONTH_NORMALISED",
      "DAY_OF_FISCAL_QUARTER_NORMALISED",
      "WEEK_OF_FISCAL_QUARTER_NORMALISED",
      "DAY_OF_FISCAL_YEAR_NORMALISED",
      "IS_FIRST_DAY_OF_FISCAL_QUARTER_WEEK",
      "DAYS_UNTIL_LAST_DAY_OF_MONTH",
      "CURRENT_DATE_ACTUAL",
      "CURRENT_DAY_NAME",
      "CURRENT_FIRST_DAY_OF_WEEK",
      "CURRENT_DAY_OF_FISCAL_QUARTER_NORMALISED",
      "CURRENT_WEEK_OF_FISCAL_QUARTER_NORMALISED",
      "CURRENT_WEEK_OF_FISCAL_QUARTER",
      "CURRENT_FISCAL_YEAR",
      "CURRENT_FIRST_DAY_OF_FISCAL_YEAR",
      "CURRENT_FISCAL_QUARTER_NAME_FY",
      "CURRENT_FIRST_DAY_OF_MONTH",
      "CURRENT_FIRST_DAY_OF_FISCAL_QUARTER",
      "CURRENT_DAY_OF_MONTH",
      "CURRENT_DAY_OF_FISCAL_QUARTER",
      "CURRENT_DAY_OF_FISCAL_YEAR",
      "IS_FISCAL_MONTH_TO_DATE",
      "IS_FISCAL_QUARTER_TO_DATE",
      "IS_FISCAL_YEAR_TO_DATE",
      "FISCAL_DAYS_AGO",
      "FISCAL_WEEKS_AGO",
      "FISCAL_MONTHS_AGO",
      "FISCAL_QUARTERS_AGO",
      "FISCAL_YEARS_AGO",
      "IS_CURRENT_DATE"
      FROM "PROD".common_prep.prep_date
    )
    SELECT
          *,
          '@msendal'::VARCHAR       AS created_by,
          '@jpeguero'::VARCHAR       AS updated_by,
          '2020-06-01'::DATE        AS model_created_date,
          '2023-08-14'::DATE        AS model_updated_date,
          CURRENT_TIMESTAMP()               AS dbt_updated_at,
                CURRENT_TIMESTAMP()               AS dbt_created_at
        FROM dates;
    ```

**Key Fields & Usage:**

*   **`date_id`**: Primary key, date in integer format (YYYYMMDD).
*   **`date_actual`**: Date in standard date format.
*   **`day_name`**: Day of the week (e.g., Monday, Tuesday).
*   **`month_name`**: Month name (e.g., January, February).
*   **`fiscal_year`**: Fiscal year.
*   **`fiscal_quarter`**: Fiscal quarter (1, 2, 3, 4).
*   **`is_holiday`**: Boolean flag indicating if the date is a holiday.
*   **`first_day_of_month`**: First day of the month.
*   **`last_day_of_month`**: Last day of the month.

**SQL Example:**

To analyze website traffic trends by month, you would join the `dim_date` table with your website traffic data and group by `first_day_of_month`.

```sql
SELECT
    d.first_day_of_month,
    SUM(t.traffic_volume) AS total_traffic
FROM
    website_traffic t
JOIN
    dim_date d ON t.date = d.date_actual
WHERE
    d.date_actual BETWEEN DATEADD(year, -1, CURRENT_DATE) AND CURRENT_DATE
GROUP BY
    d.first_day_of_month
ORDER BY
    d.first_day_of_month;
```

**Benefits:**

*   **Data Consistency**: Ensures all date-related analyses use a consistent standard.
*   **Simplified Queries**: Simplifies complex date-based queries, making them easier to write and understand.
*   **Improved Reporting**: Enables accurate and reliable reporting by aligning data with a standard date spine.

The `dim_date` table is a critical component of the data mart, providing a foundation for consistent and accurate temporal analysis across various business functions. It ensures that all date-related data is standardized and enriched, simplifying complex queries and improving the reliability of reporting.
