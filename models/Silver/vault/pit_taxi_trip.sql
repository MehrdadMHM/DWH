{{
    config(
        materialized='table'
    )
}}

select
    trip_hkey,
    current_timestamp() as snapshot_date,
    current_timestamp() as load_date,
    'nyctaxi_trips' as record_source
from {{ ref('hub_vendor') }}