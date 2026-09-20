{{
    config(
        materialized='table'
    )
}}

select
    link.link_hkey,
    link.vendor_hk,
    link.dest_hk,
    current_timestamp() as snapshot_date,
    current_timestamp() as load_date
from {{ ref('link_trip_connection') }} link