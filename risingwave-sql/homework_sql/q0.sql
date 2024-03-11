with max_date as (
    select max(tpep_dropoff_datetime) max_do from trip_data
)
select taxi_zone.zone
from taxi_zone
  join trip_data
    on taxi_zone.location_id = trip_data.DOLocationID
where trip_data.tpep_dropoff_datetime = (select max_do from max_date);
/*
      zone      
----------------
 Midtown Center
(1 row)
*/