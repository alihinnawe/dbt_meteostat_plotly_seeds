with staging_order_details as (
select * from {{source('northwind','order_details')}} 
)
select * from staging_order_details