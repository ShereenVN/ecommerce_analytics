with customers as (

    select * from {{ ref('stg_thelook__users') }}

),

orders as (

    select * from {{ ref('stg_thelook__orders') }}

),

customer_orders as (

    select
        customer_id,
        min(ordered_at) as first_order_at,
        max(ordered_at) as most_recent_order_at,
        count(order_id) as lifetime_order_count

    from orders
    group by customer_id

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.email,
        customers.age,
        customers.gender,
        customers.city,
        customers.state,
        customers.country,
        customers.traffic_source,
        customers.registered_at,
        coalesce(customer_orders.first_order_at, null) as first_order_at,
        coalesce(customer_orders.most_recent_order_at, null) as most_recent_order_at,
        coalesce(customer_orders.lifetime_order_count, 0) as lifetime_order_count

    from customers
    left join customer_orders on customers.customer_id = customer_orders.customer_id

)

select * from final