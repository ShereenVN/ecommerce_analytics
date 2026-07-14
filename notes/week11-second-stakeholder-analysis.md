From: Head of Operations
To: You (Analytics Engineer)
Subject: Order Fulfilment Analysis


Hey,

We're trying to improve our shipping times. I need a view into:


How long it takes on average from order to shipment, and from order to delivery
What percentage of orders get returned or cancelled
I want to see this by product category — are some categories worse than others?
Monthly trends would help too.


Whatever format works best for analysis.


-----------------------------------------------------------------------------------


## Clarifying Questions

1. Monthly trends of what specifically — fulfilment times, return rates, cancellation rates, or all of them?
2. Should shipping time be measured in days, hours or weeks?
3. Do you want separate percentages for returned and cancelled orders, or combined?
4. An order can contain items from multiple product categories — should fulfilment time be calculated per order item or per order?
5. What should happen with NULL shipped_at or delivered_at values? Orders that are cancelled or still processing won't have these timestamps — should they be excluded from average fulfilment time calculations?
6. For the return/cancellation percentage, what is the denominator — all orders ever placed, or only completed and shipped orders?

## Assumptions Made

1. Monthly trends include all three metrics: average fulfilment times, return rate and cancellation rate
2. Shipping time measured in days — most natural unit for logistics analysis
3. Separate percentages for returned and cancelled — they represent different operational problems
4. Fulfilment time calculated per order item, since each item belongs to one product category
5. NULL shipped_at and delivered_at are excluded from average calculations — only include rows where the timestamp exists
6. Denominator for return/cancellation rate is all orders placed, to give a true picture of how many orders don't complete successfully


-----------------------------------------------------------------------------------

-- What fulfilment-related columns do we have?
SELECT 
    order_item_id,
    ordered_at,
    shipped_at,
    delivered_at,
    returned_at,
    order_status,
    product_category
FROM ecommerce_analytics.fct_order_items
LIMIT 20;

-- How many NULLs are there in shipped_at and delivered_at?
SELECT
    COUNT(*) as total_rows,
    COUNTIF(shipped_at IS NULL) as null_shipped,
    COUNTIF(delivered_at IS NULL) as null_delivered,
    COUNTIF(returned_at IS NULL) as null_returned
FROM ecommerce_analytics.fct_order_items;

-- Average days from order to shipment and delivery by product category
SELECT
    product_category,
    ROUND(AVG(DATE_DIFF(shipped_at, ordered_at, DAY)), 2) as avg_days_to_ship,
    ROUND(AVG(DATE_DIFF(delivered_at, ordered_at, DAY)), 2) as avg_days_to_deliver
FROM ecommerce_analytics.fct_order_items
WHERE shipped_at IS NOT NULL
AND delivered_at IS NOT NULL
GROUP BY product_category
ORDER BY avg_days_to_deliver DESC;

-- Return and cancellation rate by product category
SELECT
    product_category,
    COUNT(DISTINCT order_id) as total_orders,
    ROUND(COUNTIF(order_status = 'Returned') / COUNT(DISTINCT order_id) * 100, 2) as return_rate,
    ROUND(COUNTIF(order_status = 'Cancelled') / COUNT(DISTINCT order_id) * 100, 2) as cancel_rate
FROM ecommerce_analytics.fct_order_items
GROUP BY product_category
ORDER BY return_rate DESC;

-- Monthly trends by product category
SELECT
    product_category,
    DATE_TRUNC(ordered_at, MONTH) as order_month,
    ROUND(AVG(DATE_DIFF(shipped_at, ordered_at, DAY)), 2) as avg_days_to_ship,
    ROUND(AVG(DATE_DIFF(delivered_at, ordered_at, DAY)), 2) as avg_days_to_deliver,
    ROUND(COUNTIF(order_status = 'Returned') / COUNT(DISTINCT order_id) * 100, 2) as return_rate,
    ROUND(COUNTIF(order_status = 'Cancelled') / COUNT(DISTINCT order_id) * 100, 2) as cancel_rate
FROM ecommerce_analytics.fct_order_items
WHERE shipped_at IS NOT NULL
AND delivered_at IS NOT NULL
GROUP BY product_category, order_month
ORDER BY order_month, product_category;


-----------------------------------------------------------------------------------


## Model Design

### What I'm building:
- Model name: mart_order_fulfillment
- Layer: marts/core — it builds on top of fct_order_items which lives in core, and fulfilment data is operational rather than specific to one business department
- Materialization: table — queried repeatedly by operations stakeholders, so materializing avoids recomputing joins and aggregations every time
- Grain: one row per product_category per order_month

### Columns I plan to include:
- product_category
- order_month
- avg_days_to_ship
- avg_days_to_deliver
- total_orders
- return_rate
- cancel_rate

### Which existing models will I ref()?
- fct_order_items (contains all fulfilment timestamps, order status and product category)

### Assumptions I'm making:
- Time grain: monthly
- Fulfilment times only calculated where shipped_at and delivered_at are not NULL and DATE_DIFF >= 0 (negative values indicate data quality issues in source)
- Return and cancellation rates calculated against ALL orders placed (including cancelled/processing) to give a true picture
- Return rate and cancel rate are separate metrics, not combined