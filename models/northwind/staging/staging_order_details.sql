with staging_order_details as (
select * from {{source('northwind_data','order_details')}} 
)
select * from staging_order_details