with max_pickup_time as (
    select max(tpep_pickup_datetime) - interval '17 hours' as max_time from trip_data
),
top_3_pickup as (
    select 
        td.pulocationid
      , td.dolocationid
      , mpt.max_time
      , max(tpep_pickup_datetime) as max_pu_time
      , min(tpep_pickup_datetime) as min_pu_time
      , max(tpep_dropoff_datetime) as max_do_time
      , min(tpep_dropoff_datetime) as min_do_time
      , count(*) num_trips
    from 
        trip_data td
        join max_pickup_time as mpt
          on 1 = 1
    where td.tpep_pickup_datetime > mpt.max_time
    group by 
        td.pulocationid
      , td.dolocationid
      , mpt.max_time
)
select
    trips.pulocationid
  , pzone.zone as pu_zone
  , trips.dolocationid
  , dzone.zone as dz_zone
  , num_trips
  , max_pu_time
  , min_pu_time
from top_3_pickup trips
    join taxi_zone pzone
        on trips.pulocationid = pzone.location_id
    join taxi_zone dzone
        on trips.dolocationid = dzone.location_id
order by 5 desc
;