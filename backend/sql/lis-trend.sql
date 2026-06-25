WITH lrs_rollup AS (
  SELECT
    lt_filter.lt_no AS lrs_lt_no,
    lt_filter.lt_lrq_no AS lrs_lrq_no,
    MAX(CASE WHEN lrs.lrs_iscritical IN ('1', 'Y', 'y') THEN 1 ELSE 0 END) AS is_critical,
    MAX(CASE WHEN lrs.lrs_isapprove  IN ('1', 'Y', 'y') THEN 1 ELSE 0 END) AS is_approve,
    MAX(lrs.lrs_analysedatetime) AS analysedatetime,
    MAX(lrs.lrs_resultdatetime) AS resultdatetime,
    MAX(lrs.lrs_reportdatetime) AS reportdatetime,
    MAX(lrs.lrs_approvedatetime) AS approvedatetime
  FROM labrequest lrq_filter
  JOIN labtest lt_filter ON lrq_filter.lrq_no = lt_filter.lt_lrq_no
  JOIN labresult lrs ON lt_filter.lt_no = lrs.lrs_lt_no
  WHERE lrq_filter.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
    AND COALESCE(lrs.lrs_isdelete, '') NOT IN ('1', 'Y', 'y')
    AND COALESCE(lrq_filter.lrq_isdelete, '') NOT IN ('1', 'Y', 'y')
    AND COALESCE(lt_filter.lt_isdelete, '') NOT IN ('1', 'Y', 'y')
  GROUP BY lt_filter.lt_no, lt_filter.lt_lrq_no
),
snapshot AS (
  SELECT MAX(event_time) AS latestAt
  FROM (
    SELECT MAX(lrq_snapshot.lrq_requestdatetime) AS event_time
    FROM labrequest lrq_snapshot
    WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      AND COALESCE(lrq_snapshot.lrq_isdelete, '') NOT IN ('1', 'Y', 'y')
    UNION ALL
    SELECT MAX(lt_snapshot.lt_analysedatetime) AS event_time
    FROM labrequest lrq_snapshot
    JOIN labtest lt_snapshot ON lrq_snapshot.lrq_no = lt_snapshot.lt_lrq_no
    WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      AND COALESCE(lrq_snapshot.lrq_isdelete, '') NOT IN ('1', 'Y', 'y')
      AND COALESCE(lt_snapshot.lt_isdelete, '') NOT IN ('1', 'Y', 'y')
    UNION ALL
    SELECT MAX(lt_snapshot.lt_resultdatetime) AS event_time
    FROM labrequest lrq_snapshot
    JOIN labtest lt_snapshot ON lrq_snapshot.lrq_no = lt_snapshot.lt_lrq_no
    WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      AND COALESCE(lrq_snapshot.lrq_isdelete, '') NOT IN ('1', 'Y', 'y')
      AND COALESCE(lt_snapshot.lt_isdelete, '') NOT IN ('1', 'Y', 'y')
    UNION ALL
    SELECT MAX(lt_snapshot.lt_reportdatetime) AS event_time
    FROM labrequest lrq_snapshot
    JOIN labtest lt_snapshot ON lrq_snapshot.lrq_no = lt_snapshot.lt_lrq_no
    WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      AND COALESCE(lrq_snapshot.lrq_isdelete, '') NOT IN ('1', 'Y', 'y')
      AND COALESCE(lt_snapshot.lt_isdelete, '') NOT IN ('1', 'Y', 'y')
    UNION ALL
    SELECT MAX(lt_snapshot.lt_approvedatetime) AS event_time
    FROM labrequest lrq_snapshot
    JOIN labtest lt_snapshot ON lrq_snapshot.lrq_no = lt_snapshot.lt_lrq_no
    WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      AND COALESCE(lrq_snapshot.lrq_isdelete, '') NOT IN ('1', 'Y', 'y')
      AND COALESCE(lt_snapshot.lt_isdelete, '') NOT IN ('1', 'Y', 'y')
  ) snapshot_events
),
case_rows AS (
  SELECT
    lrq.lrq_requestdatetime AS request_time,
    COALESCE(
      lt.lt_approvedatetime,
      lrs.approvedatetime,
      lt.lt_reportdatetime,
      lrs.reportdatetime,
      lt.lt_resultdatetime,
      lrs.resultdatetime,
      lt.lt_analysedatetime,
      lrs.analysedatetime,
      CASE
        WHEN DATE(lrq.lrq_requestdatetime) = CURRENT_DATE THEN NOW()
        ELSE COALESCE(snapshot.latestAt, lrq.lrq_requestdatetime)
      END
    ) AS end_time,
    COALESCE(lt.lt_approvedatetime, lrs.approvedatetime) AS approved_time,
    CASE
      WHEN lrq.lrq_iscritical IN ('1', 'Y', 'y') OR lrs.is_critical = 1 OR lrq.lrq_urgent = '2' THEN COALESCE(NULLIF(t.t_asaptime, 0) * CASE WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('H', '1', '2') THEN 60 WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('D', '3') THEN 1440 ELSE 1 END, NULLIF(t.t_stattime, 0) * CASE WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('H', '1', '2') THEN 60 WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('D', '3') THEN 1440 ELSE 1 END, NULLIF(t.t_routinetime, 0) * CASE WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('H', '1', '2') THEN 60 WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('D', '3') THEN 1440 ELSE 1 END, 15)
      WHEN lrq.lrq_urgent IN ('1', 'Y', 'y') OR t.t_urgent IN ('1', 'Y', 'y') THEN COALESCE(NULLIF(t.t_stattime, 0) * CASE WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('H', '1', '2') THEN 60 WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('D', '3') THEN 1440 ELSE 1 END, NULLIF(t.t_routinetime, 0) * CASE WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('H', '1', '2') THEN 60 WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('D', '3') THEN 1440 ELSE 1 END, 30)
      ELSE COALESCE(NULLIF(t.t_routinetime, 0) * CASE WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('H', '1', '2') THEN 60 WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('D', '3') THEN 1440 ELSE 1 END, NULLIF(t.t_stattime, 0) * CASE WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('H', '1', '2') THEN 60 WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('D', '3') THEN 1440 ELSE 1 END, 90)
    END AS due_minutes
  FROM labrequest lrq
  JOIN labtest lt ON lrq.lrq_no = lt.lt_lrq_no
  LEFT JOIN lrs_rollup lrs ON lt.lt_no = lrs.lrs_lt_no
  LEFT JOIN test t ON lt.lt_t_no = t.t_no
  CROSS JOIN snapshot
  WHERE lrq.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
    AND COALESCE(lrq.lrq_isdelete, '') NOT IN ('1', 'Y', 'y')
    AND COALESCE(lt.lt_isdelete, '') NOT IN ('1', 'Y', 'y')
)
SELECT
  hours.hour AS hour,
  COALESCE(received.received, 0) AS received,
  COALESCE(approved.approved, 0) AS approved,
  ROUND(COALESCE(turnaround.avg_tat, 0), 0) AS avg,
  ROUND(COALESCE(turnaround.on_time_rate, 0), 1) AS onTime
FROM (
  SELECT '00:00' AS hour UNION ALL
  SELECT '01:00' UNION ALL
  SELECT '02:00' UNION ALL
  SELECT '03:00' UNION ALL
  SELECT '04:00' UNION ALL
  SELECT '05:00' UNION ALL
  SELECT '06:00' UNION ALL
  SELECT '07:00' UNION ALL
  SELECT '08:00' UNION ALL
  SELECT '09:00' UNION ALL
  SELECT '10:00' UNION ALL
  SELECT '11:00' UNION ALL
  SELECT '12:00' UNION ALL
  SELECT '13:00' UNION ALL
  SELECT '14:00' UNION ALL
  SELECT '15:00' UNION ALL
  SELECT '16:00' UNION ALL
  SELECT '17:00' UNION ALL
  SELECT '18:00' UNION ALL
  SELECT '19:00' UNION ALL
  SELECT '20:00' UNION ALL
  SELECT '21:00' UNION ALL
  SELECT '22:00' UNION ALL
  SELECT '23:00'
) hours
LEFT JOIN (
  SELECT
    DATE_FORMAT(request_time, '%H:00') AS hour,
    COUNT(*) AS received
  FROM case_rows
  GROUP BY DATE_FORMAT(request_time, '%H:00')
) received ON received.hour = hours.hour
LEFT JOIN (
  SELECT
    DATE_FORMAT(approved_time, '%H:00') AS hour,
    COUNT(*) AS approved
  FROM case_rows
  WHERE approved_time BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
  GROUP BY DATE_FORMAT(approved_time, '%H:00')
) approved ON approved.hour = hours.hour
LEFT JOIN (
  SELECT
    DATE_FORMAT(request_time, '%H:00') AS hour,
    AVG(TIMESTAMPDIFF(MINUTE, request_time, end_time)) AS avg_tat,
    AVG(
      CASE
        WHEN TIMESTAMPDIFF(MINUTE, request_time, end_time) <= due_minutes THEN 100
        ELSE 0
      END
    ) AS on_time_rate
  FROM case_rows
  GROUP BY DATE_FORMAT(request_time, '%H:00')
) turnaround ON turnaround.hour = hours.hour
ORDER BY hours.hour ASC;
