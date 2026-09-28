with staging_products as (
select
    product_id,
    product_name,
    supplier_id,
    category_id,
    quantity_per_unit as raw_quantity_per_unit,
    /*  Look inside the quantity_per_unit text. 
    	Go to the very beginning, find the numbers there, and extract only those numbers as a text string."
 	*/
    substring(quantity_per_unit from '^\d+') as primary_count,
    -- fixing namings
    case 
        when quantity_per_unit like '%bottle%' then 'bottles'
        when quantity_per_unit like '%box%' or lower(quantity_per_unit) like '%boxes%' then 'boxes'
        when quantity_per_unit like '%jar%' then 'jars'
        when quantity_per_unit like '%bag%' then 'bags'
        when quantity_per_unit like '%pkg%' or lower(quantity_per_unit) like '%pkgs.' then 'packages'
        when quantity_per_unit like '%can%' then 'cans'
        when quantity_per_unit like '%tin%' then 'tins'
        else 'other'
    end as package_type

from {{source('northwind_data','products')}}
)

select * from staging_products