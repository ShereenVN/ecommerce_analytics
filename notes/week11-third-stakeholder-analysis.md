From: Marketing Director
To: You (Analytics Engineer)
Subject: Re: Website Traffic Analysis


Thanks for the traffic source analysis — really useful!

Follow-up: can you also show me the website conversion funnel? Like, how many users view products, add to cart, and then actually purchase? I heard we have event tracking data somewhere.


-----------------------------------------------------------------------------------

## Clarifying Questions

1. Should the funnel count by sessions or by users?
2. Should anonymous users be included or excluded from the funnel?
3. Does he want the funnel broken down by traffic source, since that was his original interest?
4. What time grain — monthly like the previous model, or overall totals?
5. Is the cancel event a funnel step or a separate drop-off metric?
6. Should we show all funnel steps (home, department, product, cart, purchase, cancel) or just the core conversion steps?

## Assumptions Made

1. Counting by users (user_id) rather than sessions — more meaningful for conversion analysis
2. Anonymous users are excluded from the main funnel since they never reach purchase. Cancel events are 100% anonymous and purchase events are 0% anonymous, so the logged-in funnel is the clean story
3. Funnel broken down by traffic source to stay consistent with the marketing director's original interest
4. Monthly time grain to stay consistent with previous mart models
5. Cancel is treated as a separate metric, not a funnel step — it only appears for anonymous users and represents a different behaviour
6. Core funnel steps are: product → cart → purchase
7. Conversion rates calculated as: cart / product views, and purchase / cart adds


-----------------------------------------------------------------------------------


SELECT * FROM `bigquery-public-data.thelook_ecommerce.events` LIMIT 20;
SELECT DISTINCT event_type FROM `bigquery-public-data.thelook_ecommerce.events`;
SELECT COUNT(*) FROM `bigquery-public-data.thelook_ecommerce.events`;

-- Do anonymous users (NULL user_id) ever purchase?
SELECT 
    event_type,
    COUNT(*) as event_count,
    COUNTIF(user_id IS NULL) as anonymous_count,
    COUNTIF(user_id IS NOT NULL) as logged_in_count
FROM `bigquery-public-data.thelook_ecommerce.events`
GROUP BY event_type
ORDER BY event_type;

-- Can we link anonymous purchase events to orders?
SELECT 
    user_id,
    event_type,
    COUNT(*) as count
FROM `bigquery-public-data.thelook_ecommerce.events`
WHERE event_type = 'purchase'
GROUP BY user_id, event_type
ORDER BY user_id IS NULL DESC
LIMIT 20;


-----------------------------------------------------------------------------------

## Model Design

### What I'm building:
- Model name: mart_traffic_source_conversion
- Layer: marts/core — builds on top of stg_thelook__events which is a core staging model
- Materialization: table — queried repeatedly by marketing stakeholders
- Grain: one row per traffic_source per event_month

### Columns I plan to include:
- traffic_source
- event_month
- product_viewers
- cart_adds
- purchasers
- product_to_cart_rate
- cart_to_purchase_rate

### Which existing models will I ref()?
- stg_thelook__events (contains all funnel event data and traffic source)

### Assumptions I'm making:
- Time grain: monthly
- Anonymous users excluded — they never reach purchase so they distort the funnel
- Funnel steps: product → cart → purchase only (home, department and cancel excluded as they are not core conversion steps)
- Counting distinct users per step, not events — one user can view a product multiple times
- NULLIF used in conversion rate calculations to avoid division by zero
- Cancel events treated as out of scope for this model