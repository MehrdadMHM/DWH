{{
    config(
        materialized='incremental',
        unique_key='link_hkey'
    )
}}

select
    link.link_hkey,
    stg.fare_amount,
    stg.trip_distance,
    current_timestamp() as load_date,
    'nyctaxi_trips' as record_source
from {{ ref('stg_taxi_rides') }} stg
join {{ ref('link_trip_connection') }} link 
  on stg.trip_hkey = link.vendor_hk