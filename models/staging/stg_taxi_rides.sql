{{
    config(
        materialized='view'
    )
}}

select
    md5(cast(pickup_datetime as string)) as trip_hkey,
    *
from {{ source('nyctaxi_data', 'trips') }}