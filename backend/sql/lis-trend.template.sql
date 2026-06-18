-- Copy this file to something like backend/sql/lis-trend.sql
-- and replace the table and column names with your real LIS schema.
--
-- Required output aliases for the trend chart:
-- hour, onTime, avg
--
-- Available date tokens:
-- {{selectedDate}}
-- {{selectedDateStart}}
-- {{selectedDateEnd}}

SELECT
  DATE_FORMAT(r.ordered_at, '%H:00') AS hour,
  ROUND(
    AVG(
      CASE
        WHEN TIMESTAMPDIFF(MINUTE, r.ordered_at, COALESCE(r.completed_at, NOW())) <= COALESCE(r.tat_target_minutes, 60)
          THEN 100
        ELSE 0
      END
    ),
    1
  ) AS onTime,
  ROUND(
    AVG(TIMESTAMPDIFF(MINUTE, r.ordered_at, COALESCE(r.completed_at, NOW()))),
    0
  ) AS avg
FROM lis_requests r
WHERE r.ordered_at BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
GROUP BY DATE_FORMAT(r.ordered_at, '%H:00')
ORDER BY hour ASC;
