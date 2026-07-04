with raw_trips as (
    select * from {{ source('nyc_taxi_source', 'tlc_yellow_trips_2019') }}
)

select
    vendor_id,
    rate_code_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count,
    trip_distance,
    fare_amount,
    tip_amount,
    total_amount -- 🛑 دقت کن که بعد از این آخرین ستون، اصلاً نباید ویرگول (,) بگذاری

from raw_trips
