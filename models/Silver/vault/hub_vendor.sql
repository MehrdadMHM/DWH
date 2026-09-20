{{ config(
    materialized='incremental',
    unique_key='trip_hkey'
) }}

select 
    trip_hkey,
    min(pickup_zip) as business_key,
    current_timestamp() as load_date,
    'nyctaxi_trips' as record_source
from {{ ref('stg_taxi_rides') }}
where pickup_zip is not null
group by trip_hkey, current_timestamp(), record_source

{% if is_incremental() %}
    -- این شرط باید بعد از یک WHERE یا AND درست قرار بگیرد
    having current_timestamp() > (select max(load_date) from {{ this }})
{% endif %}