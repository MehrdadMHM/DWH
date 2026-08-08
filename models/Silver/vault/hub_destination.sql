{{
    config(
        materialized='incremental',
        unique_key='dest_hk'
    )
}}

select distinct
    md5(cast(dropoff_zip as string)) as dest_hk,
    dropoff_zip as dest_business_key,
    current_timestamp() as load_date,
    'nyctaxi_trips' as record_source
from {{ ref('stg_taxi_rides') }}
where dropoff_zip is not null