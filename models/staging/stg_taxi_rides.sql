{{
    config(
        materialized='view'
    )
}}

select
    md5(cast(tpep_pickup_datetime as string)) as trip_hkey,
    *
from {{ source('nyctaxi_data', 'trips') }}
