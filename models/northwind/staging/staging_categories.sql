WITH source_categories AS (
    SELECT
        description,
        category_name
    FROM {{ source('northwind_data', 'categories') }}
)

SELECT *
FROM source_categories