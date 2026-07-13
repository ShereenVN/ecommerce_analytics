with order_items as (
    select * from {{ ref('fct_order_items') }}
),

customers as (
    select * from {{ ref('dim_customers') }}
),

final as (
    select
        c.traffic_source,
        DATE_TRUNC(f.ordered_at, MONTH) as order_month,
        COUNT(DISTINCT f.order_id) as total_orders,
        COUNT(DISTINCT c.customer_id) as customer_count,
        ROUND(SUM(f.sale_price), 2) as total_revenue,
        ROUND(SUM(f.sale_price) / COUNT(DISTINCT f.order_id), 2) as avg_order_value
    from order_items f
    join customers c on f.customer_id = c.customer_id
    group by c.traffic_source, DATE_TRUNC(f.ordered_at, MONTH)
)

select * from final