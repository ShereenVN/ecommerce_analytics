with order_items as (

    select * from {{ ref('stg_thelook__order_items') }}

),

orders as (

    select * from {{ ref('stg_thelook__orders') }}

),

products as (

    select * from {{ ref('stg_thelook__products') }}

),

final as (

    select
        order_items.order_item_id,
        order_items.order_id,
        order_items.customer_id,
        order_items.product_id,

        -- order context
        orders.order_status,
        order_items.ordered_at,
        order_items.shipped_at,
        order_items.delivered_at,
        order_items.returned_at,

        -- product context
        products.product_name,
        products.product_category,
        products.brand,
        products.department,

        -- measures
        order_items.sale_price,
        products.product_cost,
        round(order_items.sale_price - products.product_cost, 2) as item_profit

    from order_items
    left join orders on order_items.order_id = orders.order_id
    left join products on order_items.product_id = products.product_id
    where products.product_name is not null
)

select * from final