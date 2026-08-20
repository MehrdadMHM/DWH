{{
    config(
        materialized='incremental',
        unique_key='link_hkey'
    )
}}

select distinct
    md5(cast(hub_vendor.trip_hkey as string) || '-' || cast(hub_destination.dest_hk as string)) as link_hkey,
    hub_vendor.trip_hkey as vendor_hk,
    hub_destination.dest_hk as dest_hk,
    current_timestamp() as load_date,
    'nyctaxi_trips' as record_source
from {{ ref('stg_taxi_rides') }} as stg
join {{ ref('hub_vendor') }} as hub_vendor on stg.trip_hkey = hub_vendor.trip_hkey
join {{ ref('hub_destination') }} as hub_destination on stg.dropoff_zip = hub_destination.dest_business_key