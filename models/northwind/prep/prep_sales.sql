with first_join_revenue_calculation as (
    select 
        sod.order_id, 
        sp.product_name,
        sp.primary_count, 
        sp.package_type, 
        (sod.unit_price * sod.quantity) * (1 - sod.discount) as raw_revenue
    from {{ ref('staging_products') }} sp
    join {{ ref('staging_order_details') }} sod 
        on sp.product_id = sod.product_id
),

monthly_product_revenue as ( 
    select
        extract(year from o.order_date) as order_year,
        extract(month from o.order_date) as order_month,
        f.product_name,
        sum(f.raw_revenue) as total_revenue
    from {{ ref('staging_orders') }} o
    join first_join_revenue_calculation f 
        on o.order_id = f.order_id
)

select * 
from monthly_product_revenue
order by order_year desc, order_month desc, total_revenue desc