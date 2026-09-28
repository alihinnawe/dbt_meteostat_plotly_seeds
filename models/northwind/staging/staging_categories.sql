with staging_categories as (
    select category_name, description from {{ source('northwind_data','categories') }}
)

select * from staging_categories