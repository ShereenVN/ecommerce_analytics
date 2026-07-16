with events as (
    select * from {{ ref('stg_thelook__events') }}
    where user_id is not null   -- anonymous users never reach purchase step, excluded from funnel
),

funnel as (
    select
        traffic_source,
        DATE_TRUNC(event_at, MONTH) as event_month,
        COUNT(DISTINCT CASE WHEN event_type = 'product' THEN user_id END) as product_viewers,
        COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_id END) as cart_adds,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) as purchasers,
        ROUND(COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_id END) / 
              NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'product' THEN user_id END), 0) * 100, 2) as product_to_cart_rate,
        ROUND(COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) / 
              NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_id END), 0) * 100, 2) as cart_to_purchase_rate
    from events
    group by traffic_source, event_month
)

select * from funnel