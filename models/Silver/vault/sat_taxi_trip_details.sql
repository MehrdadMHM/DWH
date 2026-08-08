{{
    config(
        materialized='incremental',
        unique_key='trip_hkey'
    )
}}

select
    trip_hkey,
    tpep_dropoff_datetime as dropoff_time,
    trip_distance,
    fare_amount,
    current_timestamp() as load_date,
    'nyctaxi_trips' as record_source
from {{ ref('stg_taxi_rides') }}
where trip_hkey is not null