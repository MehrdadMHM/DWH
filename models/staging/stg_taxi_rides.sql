{{
    config(
        materialized='ephemeral'
    )
}}

select
    md5(cast(VendorID as string)) as trip_hkey,
    VendorID as vendor_id,
    tpep_pickup_datetime as pickup_datetime,
    year,
    month,
    day
from {{ source('default', 'TaxiData_Bronze') }}