{{ config(
 materialized = 'table',
 target_schema = 'FACT'
) }}

WITH fct_reviews AS (
 SELECT * FROM {{ ref('fct_reviews') }}
),

full_moon_dates AS (
 SELECT * FROM {{ ref('seed_full_moon_dates') }}
)
SELECT
 r.*,
 CASE --saber si la noche anterior hubo luna llena o no
 WHEN fm.full_moon_date IS NULL THEN 'not full moon'
 ELSE 'full moon'
 END AS is_full_moon
FROM
 fct_reviews
 r
 LEFT JOIN full_moon_dates
 fm  --coincidir con cada día anterior de fullmoon date
 ON (TO_DATE(r.review_date) = DATEADD(DAY, 1, fm.full_moon_date))