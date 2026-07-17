-- Query 1: Revenue by traffic source, highest revenue first
-- Answers: which channels drive the most revenue and orders?
SELECT
    traffic_source,
    SUM(total_orders) as total_orders,
    SUM(customer_count) as total_customers,
    ROUND(SUM(total_revenue), 2) as total_revenue,
    ROUND(AVG(avg_order_value), 2) as avg_order_value
FROM ecommerce_analytics.mart_traffic_source_revenue
GROUP BY traffic_source
ORDER BY total_revenue DESC;

-- Query 2: Average shipping and delivery time by category, slowest first
-- Answers: which product categories have the worst fulfilment performance?
SELECT
    product_category,
    ROUND(AVG(avg_days_to_ship), 2) as avg_days_to_ship,
    ROUND(AVG(avg_days_to_deliver), 2) as avg_days_to_deliver,
    ROUND(AVG(return_rate), 2) as avg_return_rate,
    ROUND(AVG(cancel_rate), 2) as avg_cancel_rate
FROM ecommerce_analytics.mart_order_fulfillment
GROUP BY product_category
ORDER BY avg_days_to_deliver DESC;

-- Query 3: Conversion funnel by traffic source, best converting channels first
-- Answers: which channels drive the highest conversion from product view to purchase?
SELECT
    traffic_source,
    SUM(product_viewers) as total_product_viewers,
    SUM(cart_adds) as total_cart_adds,
    SUM(purchasers) as total_purchasers,
    ROUND(AVG(product_to_cart_rate), 2) as avg_product_to_cart_rate,
    ROUND(AVG(cart_to_purchase_rate), 2) as avg_cart_to_purchase_rate
FROM ecommerce_analytics.mart_traffic_source_conversion
GROUP BY traffic_source
ORDER BY avg_cart_to_purchase_rate DESC;

-- Query 4: Monthly revenue trend by traffic source
-- Answers: how has each channel's revenue trended over time?
SELECT
    order_month,
    traffic_source,
    total_orders,
    total_revenue,
    avg_order_value
FROM ecommerce_analytics.mart_traffic_source_revenue
ORDER BY order_month, total_revenue DESC;