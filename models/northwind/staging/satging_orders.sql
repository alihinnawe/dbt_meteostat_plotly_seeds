with staging_orders as (
SELECT 
 order_id
,customer_id
,employee_id
,order_date::DATE
,required_date::DATE 
,shipped_date::DATE
,ship_via
,ship_city
,ship_country
FROM {{source('northwind_data','orders')}}
)

select * from staging_orders
