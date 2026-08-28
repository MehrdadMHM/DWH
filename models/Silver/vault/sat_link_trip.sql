{{
    config(
        materialized='incremental',
        unique_key='link_hkey'
    )
}}

with source_data as (
    select
        link.link_hkey,
        stg.fare_amount,
        stg.trip_distance,
        -- ساخت HashDiff برای تشخیص تغییرات توصیفی
        md5(
            coalesce(cast(stg.fare_amount as string), '') || '-' ||
            coalesce(cast(stg.trip_distance as string), '')
        ) as hash_diff,
        current_timestamp() as load_date,
        'nyctaxi_trips' as record_source
    from {{ ref('stg_taxi_rides') }} stg
    join {{ ref('link_trip_connection') }} link 
      on stg.trip_hkey = link.vendor_hk
    
    -- اگر در آینده خواستید جدول STS را هم اعمال کنید، می‌توانید این خطوط را از حالت کامنت خارج کنید:
    -- join {{ ref('sts_link_trip') }} sts on link.link_hkey = sts.link_hkey
    -- where sts.end_date is null
)

select 
    src.link_hkey,
    src.fare_amount,
    src.trip_distance,
    src.hash_diff,
    src.load_date,
    src.record_source
from source_data src

{% if is_incremental() %}
-- در حالت افزایشی، فقط رکوردهایی را بیاور که یا کلیدشان جدید است یا HashDiff آن‌ها تغییر کرده است
where not exists (
    select 1 
    from {{ this }} t 
    where t.link_hkey = src.link_hkey 
      and t.hash_diff = src.hash_diff
)
{% endif %}