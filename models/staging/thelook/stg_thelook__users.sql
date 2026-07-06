with source as (

    select * from {{ source('thelook', 'users') }}

),

renamed as (

    select
        id as customer_id,
        first_name,
        last_name,
        email,
        age,
        gender,
        city,
        state,
        country,
        traffic_source,
        created_at as registered_at

    from source

)

select * from renamed