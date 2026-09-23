select * from weather_daily_raw wdr 

select extracted_data -> 'data' -> 0 -> 'tmax' 
from weather_daily_raw wdr
WITH daily_raw AS (
    SELECT
        airport_code,
        station_id,
        JSON_ARRAY_ELEMENTS(extracted_data -> 'data') AS json_data
    FROM weather_daily_raw
),

daily_flattened AS (
    SELECT
        airport_code,
        station_id,
        (json_data ->> 'date')::DATE AS date,
        (json_data ->> 'tavg')::NUMERIC AS average_tmp_c,
        (json_data ->> 'tmax')::NUMERIC AS max_tmp_c
    FROM daily_raw
)

SELECT *
FROM daily_flattened;