From: Marketing Director
To: You (Analytics Engineer)
Subject: Website Traffic Analysis


Hi,

I need help understanding our website traffic better. Specifically:


Which traffic sources (organic, paid, social, etc.) bring us the most customers?
Which traffic sources generate the most revenue?
I want to see this broken down by month so I can spot trends.
It would also be useful to know the average order value per traffic source.


Can you build something in our data warehouse for this?

Thanks


-----------------------------------------------------------------------------------

## Clarifying Questions

1. Where are traffic sources stored in the data?
2. How do we connect traffic source to revenue?
3. When the director says "revenue," do they mean sale price or profit?
4. Does "most customers" mean total historical customers or new acquisitions?
5. Is "average order value" per item or per entire order?

## Assumptions Made

1. Traffic source is stored on dim_customers — customers are attributed to the channel they signed up through
2. Traffic source connects to revenue via customer_id through fct_order_items
3. Revenue = sale_price, not item_profit
4. Customer count = total historical customers per channel
5. Average order value = SUM(sale_price) / COUNT(DISTINCT order_id) per traffic source



-----------------------------------------------------------------------------------

SELECT 
    traffic_source, 
    COUNT(*) as customer_count 
FROM ecommerce_analytics.dim_customers 
GROUP BY traffic_source 
ORDER BY customer_count DESC;



SELECT 
    c.traffic_source,
    COUNT(DISTINCT f.order_id) as total_orders,
    ROUND(SUM(f.sale_price), 2) as total_revenue,
    ROUND(SUM(f.sale_price) / COUNT(DISTINCT f.order_id), 2) as avg_order_value
FROM ecommerce_analytics.fct_order_items f
JOIN ecommerce_analytics.dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.traffic_source
ORDER BY total_revenue DESC;



SELECT 
    c.traffic_source,
    DATE_TRUNC(f.ordered_at, MONTH) as order_month,
    COUNT(DISTINCT f.order_id) as total_orders,
    ROUND(SUM(f.sale_price), 2) as total_revenue
FROM ecommerce_analytics.fct_order_items f
JOIN ecommerce_analytics.dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.traffic_source, order_month
ORDER BY order_month, total_revenue DESC;


-----------------------------------------------------------------------------------

## Model Design

### What I'm building:
- Model name: mart_traffic_source_revenue
- Layer: marts/core — it builds directly on top of existing core marts (fct_order_items and dim_customers), so it belongs alongside them rather than in a separate marketing folder
- Materialization: table — this will be queried repeatedly by stakeholders and analysts, so materializing as a table avoids recomputing the joins and aggregations every time
- Grain: one row per traffic_source per order_month

### Columns I plan to include:
- traffic_source
- order_month
- total_orders
- customer_count
- total_revenue
- avg_order_value

### Which existing models will I ref()?
- fct_order_items (for order and revenue data)
- dim_customers (for traffic_source)

### Assumptions I'm making:
- Revenue means: sale_price (not item_profit — that is profit, not revenue)
- Time grain: monthly (DATE_TRUNC to month)
- Customer count means total distinct customers who ordered that month through that channel, not new customer acquisitions
- Average order value is calculated as total revenue divided by distinct order count, not average item price