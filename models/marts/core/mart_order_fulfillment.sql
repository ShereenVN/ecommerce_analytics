with fulfillment_times as (
    select
        product_category,
        DATE_TRUNC(ordered_at, MONTH) as order_month,
        AVG(DATE_DIFF(shipped_at, ordered_at, DAY)) as avg_days_to_ship,
        AVG(DATE_DIFF(delivered_at, ordered_at, DAY)) as avg_days_to_deliver
    from {{ ref('fct_order_items') }}
    where shipped_at is not null
    and delivered_at is not null
    and DATE_DIFF(shipped_at, ordered_at, DAY) >= 0
    group by product_category, order_month
),

order_rates as (
    select
        product_category,
        DATE_TRUNC(ordered_at, MONTH) as order_month,
        COUNT(DISTINCT order_id) as total_orders,
        ROUND(COUNTIF(order_status = 'Returned') / COUNT(DISTINCT order_id) * 100, 2) as return_rate,
        ROUND(COUNTIF(order_status = 'Cancelled') / COUNT(DISTINCT order_id) * 100, 2) as cancel_rate
    from {{ ref('fct_order_items') }}
    group by product_category, order_month
),

final as (
    select
        order_rates.product_category,
        order_rates.order_month,
        order_rates.total_orders,
        ROUND(fulfillment_times.avg_days_to_ship, 2) as avg_days_to_ship,
        ROUND(fulfillment_times.avg_days_to_deliver, 2) as avg_days_to_deliver,
        order_rates.return_rate,
        order_rates.cancel_rate
    from order_rates
    left join fulfillment_times
        on order_rates.product_category = fulfillment_times.product_category
        and order_rates.order_month = fulfillment_times.order_month
)

select * from final