with products as (

    select * from {{ ref('stg_thelook__products') }}

),

product_sales as (

    select
        product_id,
        count(*) as times_sold,
        round(sum(sale_price), 2) as total_revenue

    from {{ ref('stg_thelook__order_items') }}
    group by product_id

),

final as (

    select
        products.product_id,
        products.product_name,
        products.product_category,
        products.brand,
        products.department,
        products.retail_price,
        products.product_cost,
        round(products.retail_price - products.product_cost, 2) as unit_profit_margin,
        coalesce(product_sales.times_sold, 0) as times_sold,
        coalesce(product_sales.total_revenue, 0) as total_revenue

    from products
    left join product_sales on products.product_id = product_sales.product_id

)

select * from final