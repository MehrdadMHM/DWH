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
        -- ساخت هش‌دیف برای تشخیص تغییرات
        md5(
            coalesce(cast(stg.fare_amount as string), '') || '-' ||
            coalesce(cast(stg.trip_distance as string), '')
        ) as hash_diff,
        current_timestamp() as load_date,
        'nyctaxi_trips' as record_source
    from {{ ref('stg_taxi_rides') }} stg
    join {{ ref('link_trip_connection') }} link 
      on stg.trip_hkey = link.vendor_hk
    -- اتصال به جدول STS برای بررسی وضعیت اعتبار و حذف نشدن رابطه
    join {{ ref('sts_link_trip') }} sts 
      on link.link_hkey = sts.link_hkey
    where sts.end_date is null  -- یعنی رکورد همچنان فعال است و حذف نشده است (I)
),

{% if is_incremental() %}
latest_sat as (
    select link_hkey, hash_diff
    from (
        select link_hkey, hash_diff,
               row_number() over (partition by link_hkey order by load_date desc) as rn
        from {{ this }}
    )
    where rn = 1
)
{% endif %}

select 
    src.link_hkey,
    src.fare_amount,
    src.trip_distance,
    src.hash_diff,
    src.load_date,
    src.record_source
from source_data src
{% if is_incremental() %}
left join latest_sat lst on src.link_hkey = lst.link_hkey
where lst.link_hkey is null 
   or lst.hash_diff != src.hash_diff
{% endif %}ey is null 
   or lst.hash_diff != src.hash_diff
{% endif %}