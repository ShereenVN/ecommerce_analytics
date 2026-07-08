with source as (

    select * from {{ source('thelook', 'products') }}

),

renamed as (

    select
        id as product_id,
        name as product_name,
        category as product_category,
        brand,
        department,
        retail_price,
        cost as product_cost,
        distribution_center_id

    from source
)

select * from renamed
where product_name is not null