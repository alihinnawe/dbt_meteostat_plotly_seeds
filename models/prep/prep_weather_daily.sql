WITH daily_data AS (
    SELECT *
    FROM {{ ref('staging_weather_daily') }}
),

add_features AS (
    SELECT
        *,
        DATE_PART('day', date) AS date_day,
        DATE_PART('month', date) AS date_month,
        DATE_PART('year', date) AS date_year,
        DATE_PART('week', date) AS cw,
        TO_CHAR(date, 'FMmonth') AS month_name,
        TO_CHAR(date, 'FMday') AS weekday
    FROM daily_data
),

add_more_features AS (
    SELECT
        *,
        CASE
            WHEN month_name IN ('december', 'january', 'february') THEN 'winter'
            WHEN month_name IN ('march', 'april', 'may') THEN 'spring'
            WHEN month_name IN ('june', 'july', 'august') THEN 'summer'
            WHEN month_name IN ('september', 'october', 'november') THEN 'autumn'
        END AS season
    FROM add_features
)

SELECT *
FROM add_more_features
ORDER BY date