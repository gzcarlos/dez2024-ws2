CREATE MATERIALIZED VIEW trips_zone_stats2 AS
with trips_stats as (
    select 
        pulocationid
      , dolocationid
      , avg(tpep_dropoff_datetime - tpep_pickup_datetime) as avg
      , max(tpep_dropoff_datetime) as max_dropoff
      , min(tpep_dropoff_datetime) as min_dropoff
      , max(tpep_pickup_datetime) as max_pickup
      , min(tpep_pickup_datetime) as min_pickup
      , count(1) as num_trips
    from
        trip_data
    group by 
          pulocationid
        , dolocationid
)
select
      ts.pulocationid
    , pzone.zone as pickup_zone
    , ts.dolocationid
    , dzone.zone as dropoff_zone
    , ts.avg as average_trip_time
    , ts.num_trips as num_trips
from
    trips_stats as ts
    join taxi_zone as pzone
      on ts.pulocationid = pzone.location_id
    join taxi_zone as dzone
      on ts.dolocationid = dzone.location_id
;

--- conclusion query
select pulocationid, pickup_zone, dolocationid, dropoff_zone, average_trip_time, num_trips
from trips_zone_stats2
order by 5 desc;