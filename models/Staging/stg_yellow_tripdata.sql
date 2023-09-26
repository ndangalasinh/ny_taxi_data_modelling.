{{ config(materialized="view") }}

select
    -- identifiers
    {{ dbt_utils.surrogate_key(["vendorid", "pickup_datetime"]) }} as tripid,
    cast(vendorid as integer) as vendor_id,
    {{get_vendorid_description("vendorid")}} as vendor,
    cast(ratecodeid as integer) as ratecode_id,
    {{get_ratecodeid_description("ratecodeid")}} as ratecode,
    cast(pickup_location_id as integer) as pickup_location_id,
    cast(dropoff_location_id as integer) as dropoff_location_id,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    -- trip info
    store_and_fwd_flag,
    cast(passenger_count as integer) as passenger_count,
    cast(trip_distance as numeric) as trip_distance,

    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(improvement_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    cast(payment_type as integer) as payment_type,
    {{ get_payment_type_description("payment_type") }} as payment_type_description,
    cast(congestion_surcharge as numeric) as congestion_surcharge,

from {{ source("staging", "yellow_rides") }}
where vendorid is not null
-- dbt build --m <model.sql> --var 'is_test_run:false'
--{% if var("is_test_run", default=true) %} limit 100 {% endif %}