with source as (

    select * from {{ source('thelook', 'order_items') }}

),

renamed as (

    select
        id as order_item_id,
        order_id,
        user_id as customer_id,
        product_id,
        status as item_status,
        created_at as ordered_at,
        shipped_at,
        delivered_at,
        returned_at,
        sale_price

    from source

)

select * from renamed