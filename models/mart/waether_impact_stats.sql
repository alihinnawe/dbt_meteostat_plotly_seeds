WITH weather_impact AS (
    SELECT
        faa,
        flight_date,

        total_planned,
        total_flights,
        total_cancelled,
        total_diverted,
        avg_wind_speed_kmh,

        -- KPI 
        ROUND(
            total_cancelled / total_planned * 100,
            2
        ) AS cancellation_rate,

        ROUND(
            total_diverted / total_planned * 100,
            2
        ) AS diversion_rate,

        -- Wind categories
        CASE
            WHEN avg_wind_speed_kmh < 20 THEN 'Low wind'
            WHEN avg_wind_speed_kmh < 40 THEN 'Moderate wind'
            WHEN avg_wind_speed_kmh < 60 THEN 'Strong wind'
            ELSE 'Very strong wind'
        END AS wind_category

    FROM {{ref('mart_selected_faa_stats_weather')}}

SELECT
    wind_category,

    COUNT(*) AS airport_days,

    SUM(total_planned) AS total_planned_flights,
    SUM(total_cancelled) AS total_cancelled_flights,
    SUM(total_diverted) AS total_diverted_flights,
    ROUND(
        (SUM(total_cancelled)
        / SUM(total_planned)) * 100,
        2
    ) AS cancellation_rate,
    ROUND(
        (SUM(total_diverted)
        / SUM(total_planned)) * 100,
        2
    ) AS diversion_rate,
    ROUND(AVG(avg_wind_speed_kmh), 2) AS avg_wind_speed_kmh
FROM weather_impact
 
GROUP BY wind_category


