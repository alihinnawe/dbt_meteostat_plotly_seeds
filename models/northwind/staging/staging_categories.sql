with staging_categories as (
    select category_name, description from {{ source('northwind','categories') }}
)

select * from staging_categories