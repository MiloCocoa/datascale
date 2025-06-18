### 4.7.3. Supporting Lookup Tables (Sales Territory, Industry, Location)

In data warehousing, dimensions are often categorized and grouped for consistent reporting and analysis. This section details the creation and purpose of supporting lookup tables for key demographic and organizational attributes: Sales Territory, Industry, and Location. These tables ensure standardized data for various dimensions and preparatory models, enabling consistent joining across fact tables.

*   **Use Case**: Imagine needing to analyze marketing performance across different sales territories. Without a standardized `dim_sales_territory` table, you might encounter inconsistencies in territory names or struggle to aggregate data accurately. These lookup tables centralize and standardize these attributes.

#### `prep_sales_territory`

This preparatory model focuses on creating a standardized list of sales territories.

*   **Purpose**: Extracts unique sales territory names from Salesforce account data to provide a consistent, standardized list for territory-based analysis. This eliminates variations in territory naming conventions and ensures accurate reporting.
*   **Source**: Leverages the output of [prep_sfdc_account](chapter_471.md).
*   **Implementation**:

```sql
CREATE TABLE "PROD".common_prep.prep_sales_territory as
WITH source_data AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_sfdc_account
    WHERE dim_parent_sales_territory_name_source IS NOT NULL
), unioned AS (
    SELECT DISTINCT
      md5(cast(coalesce(cast(dim_parent_sales_territory_name_source as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))  AS dim_sales_territory_id,
      dim_parent_sales_territory_name_source                     AS sales_territory_name
    FROM source_data
    UNION ALL
    SELECT
      MD5('-1')                                   AS dim_sales_territory_id,
      'Missing sales_territory_name'       AS sales_territory_name
)
SELECT *
FROM unioned;
```

*   The model first selects the `dim_parent_sales_territory_name_source` column from the [prep_sfdc_account](chapter_471.md) table.
*   A `UNION ALL` operation is used to combine the extracted territory names with a default "Missing sales\_territory\_name" entry. This ensures that even if a territory is not found in the source data, it's still accounted for.
*   The `MD5` function is used to generate a unique `dim_sales_territory_id` for each distinct territory name, including the default "Missing" entry.

#### `prep_industry`

This preparatory model focuses on creating a standardized list of industries.

*   **Purpose**: Extracts unique industry names from Salesforce account data, providing a standardized list for industry-specific reporting. This ensures consistency in industry classifications.
*   **Source**: Leverages the output of [prep_sfdc_account](chapter_471.md).
*   **Implementation**:

```sql
CREATE TABLE "PROD".common_prep.prep_industry as
WITH source_data AS (
    SELECT *
    FROM "PROD".restricted_safe_common_prep.prep_sfdc_account
    WHERE dim_account_industry_name_source IS NOT NULL
), unioned AS (
    SELECT DISTINCT
      md5(cast(coalesce(cast(dim_account_industry_name_source as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))  AS dim_industry_id,
      dim_account_industry_name_source                     AS industry_name
    FROM source_data
    UNION ALL
    SELECT
      MD5('-1')                                   AS dim_industry_id,
      'Missing industry_name'       AS industry_name
)
SELECT *
FROM unioned;
```

*   Similar to `prep_sales_territory`, this model selects the `dim_account_industry_name_source` column from the [prep_sfdc_account](chapter_471.md) table.
*   A `UNION ALL` operation is used to combine the extracted industry names with a default "Missing industry\_name" entry.
*   The `MD5` function generates a unique `dim_industry_id` for each distinct industry name, including the default "Missing" entry.

#### `prep_location_country`

This preparatory model focuses on creating a standardized list of locations.

*   **Purpose**: Maps country ISO codes to full country names and aggregates these locations to broader regional categories (e.g., EMEA, AMER). This allows for regional-level analysis and reporting.
*   **Sources**: Combines data from the `sheetload_maxmind_countries_source` (raw MaxMind data) and `zuora_country_geographic_region` (Zuora geographic region data). It is also influenced by the output of [prep_location_region](chapter_475.md).
*   **Implementation**:

```sql
CREATE TABLE "PROD".common_prep.prep_location_country as
WITH location_region AS (
    SELECT *
    FROM "PROD".common_prep.prep_location_region
), maxmind_countries_source AS (
    SELECT *
    FROM "PREP".sheetload.sheetload_maxmind_countries_source
), zuora_country_geographic_region AS (
    SELECT *
    FROM "PREP".seed_finance.zuora_country_geographic_region
), joined AS (
    SELECT
      geoname_id                                                AS dim_location_country_id,
      country_name                                              AS country_name,
      UPPER(country_iso_code)                                   AS iso_2_country_code,
      UPPER(iso_alpha_3_code)                                   AS iso_3_country_code,
      continent_name,
      CASE
        WHEN continent_name IN ('Africa', 'Europe') THEN 'EMEA'
        WHEN continent_name IN ('North America')    THEN 'AMER'
        WHEN continent_name IN ('South America')    THEN 'LATAM'
        WHEN continent_name IN ('Oceania','Asia')   THEN 'APAC'
        ELSE 'Missing location_region_name'
      END                                                      AS location_region_name_map,
      is_in_european_union
    FROM maxmind_countries_source
    LEFT JOIN  zuora_country_geographic_region
      ON UPPER(maxmind_countries_source.country_iso_code) = UPPER(zuora_country_geographic_region.iso_alpha_2_code)
    WHERE country_iso_code IS NOT NULL
), final AS (
    SELECT
      joined.dim_location_country_id,
      location_region.dim_location_region_id,
      joined.location_region_name_map,
      joined.country_name,
      joined.iso_2_country_code,
      joined.iso_3_country_code,
      joined.continent_name,
      joined.is_in_european_union
    FROM joined
    LEFT JOIN location_region
      ON joined.location_region_name_map = location_region.location_region_name
)
SELECT *
FROM final;
```

*   This model first selects data from the `maxmind_countries_source` table, which provides a list of countries, their ISO codes, and continent information.
*   A `CASE` statement is used to map continent names to broader regional categories (EMEA, AMER, LATAM, APAC). If the continent name doesn't match any of these, it defaults to "Missing location\_region\_name".
*   The results are then joined with the `location_region` table (derived from [prep_location_region](chapter_475.md)) to link each country to its corresponding region.

#### `prep_location_region`

This preparatory model extracts geographic region names.

*   **Purpose**: Extracts unique geographic region names from Salesforce user data, standardizing regional classifications. This allows to categorize geographical territories.
*   **Source**: Leverages data from the `sfdc_users_source` table.
*   **Implementation**:

```sql
CREATE TABLE "PROD".common_prep.prep_location_region as
WITH source_data AS (
    SELECT *
    FROM "PREP".sfdc.sfdc_users_source
    WHERE user_geo IS NOT NULL
), unioned AS (
    SELECT DISTINCT
      md5(cast(coalesce(cast(user_geo as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))  AS dim_location_region_id,
      user_geo                     AS location_region_name
    FROM source_data
    UNION ALL
    SELECT
      MD5('-1')                                   AS dim_location_region_id,
      'Missing location_region_name'       AS location_region_name
)
SELECT *
FROM unioned;
```

*   This model selects data from the `sfdc_users_source` table.
*   A `UNION ALL` operation is used to combine the extracted location region names with a default "Missing location\_region\_name" entry.
*   The `MD5` function generates a unique `dim_location_region_id` for each distinct location region name, including the default "Missing" entry.
