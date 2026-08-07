with source as (
    -- خواندن مستقیم از جدول برنز که در دیتابریکس داریم
    select * from {{ source('default', 'TaxiData_Bronze') }}
),

cleaned as (
    select
        -- ساخت کلید هش (Hash Key) برای ساختار Data Vault
        md5(cast(VendorID as string)) as trip_hkey,
        VendorID as vendor_id,
        tpep_pickup_datetime as pickup_datetime,
        year,
        month,
        day
    from source
)

select * from cleaned