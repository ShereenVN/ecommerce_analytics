with source as (

    select * from {{ source('thelook', 'events') }}

),

renamed as (

    select
        id as event_id,
        user_id,
        session_id,
        event_type,
        traffic_source,
        created_at as event_at

    from source

)

select * from renamed