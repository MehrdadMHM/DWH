{{
    config(
        materialized='incremental',
        unique_key=['link_hkey', 'load_date'],
        incremental_strategy='merge'
    )
}}

with incoming_data as (
    -- رکوردهایی که همین الان در سورس/استیج وجود دارند
    select distinct
        link.link_hkey,
        current_timestamp() as load_date,
        'nyctaxi_trips' as record_source
    from {{ ref('stg_taxi_rides') }} stg
    join {{ ref('link_trip_connection') }} link 
      on stg.trip_hkey = link.vendor_hk
)

{% if is_incremental() %}
-- سناریوی اول: رکوردهایی که در دیتای جدید نیستند اما در STS با end_date خالی وجود دارند (یعنی حذف شده‌اند / D)
-- در اینجا ما باید رکوردهای قبلی را آپدیت کنیم و end_date برایشان بگذاریم
select
    t.link_hkey,
    t.load_date,
    current_timestamp() as end_date, -- ثبت تاریخ پایان به عنوان زمان حذف
    t.record_source
from {{ this }} t
where t.end_date is null
  and t.link_hkey not in (select link_hkey from incoming_data)

union all
{% endif %}

-- سناریوی دوم: رکوردهای جدید یا فعال که باید ثبت شوند (I)
select
    link_hkey,
    load_date,
    cast(null as timestamp) as end_date,
    record_source
from incoming_data