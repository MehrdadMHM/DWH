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
        -- ساخت هش‌دیف برای ردیابی تغییرات توصیفی
        md5(
            coalesce(cast(stg.fare_amount as string), '') || '-' ||
            coalesce(cast(stg.trip_distance as string), '')
        ) as hash_diff,
        current_timestamp() as load_date,
        'nyctaxi_trips' as record_source
    from {{ ref('stg_taxi_rides') }} stg
    join {{ ref('link_trip_connection') }} link 
      on stg.trip_hkey = link.vendor_hk
)

select * from source_data

{% if is_incremental() %}
-- درج فقط در صورتی که رکورد جدیدی باشد یا تغییر در HashDiff رخ داده باشد
where link_hkey not in (select link_hkey from {{ this }})
   or hash_diff not in (
       select hash_diff 
       from (
           select hash_diff, 
                  row_number() over (partition by link_hkey order by load_date desc) as rn
           from {{ this }}
       ) where rn = 1
   )
{% endif %}