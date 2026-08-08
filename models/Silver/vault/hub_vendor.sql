{{
    config(
        materialized='incremental',
        unique_key='trip_hkey'
    )
}}

select distinct
    trip_hkey,
    pickup_zip as business_key,
    current_timestamp() as load_date,
    'nyctaxi_trips' as record_source
from {{ ref('stg_taxi_rides') }}
where pickup_zip is not null