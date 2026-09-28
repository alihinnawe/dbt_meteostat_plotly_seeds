with first_join_revenue_calculation as (
    select 
        order_id, 
        product_name,
        primary_count, 
        package_type, 
        (unit_price * quantity) * (1 - discount) as raw_revenue
    from {{ref('staging_products')}}
    join {{ref('staging_order_details')}} 
        on  {{ref('staging_products')}}.product_id = {{ref('staging_order_details')}}.product_id
),
second_join_first_join_and_products as ( 
    select
        o.order_date, 
        -- o.required_date,
        -- o.ship_country,
        -- f.order_id,
        f.product_name,
        -- f.primary_count,
        -- f.package_type,
        -- f.raw_revenue,
        -- sum(f.raw_revenue),
        extract(year from  o.order_date) AS order_year,
        extract(month from o.order_date) AS order_month
    from {{ref('staging_orders')}} o
    join first_join_revenue_calculation f 
        on o.order_id = f.order_id
    -- group by f.order_id,
    	-- o.order_date,
    	-- o.required_date,
        -- o.ship_country,
        -- f.order_id,
        -- f.product_name,
        -- f.primary_count,
        -- f.package_type,
        -- f.raw_revenue     
)
select * 
from second_join_first_join_and_products
order by order_date desc;

