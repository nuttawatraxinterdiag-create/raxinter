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
    DATE_FORMAT(lrq.lrq_requestdatetime, '%H:00') AS hour,
    COUNT(*) AS received
  FROM labrequest lrq
  WHERE lrq.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
  GROUP BY DATE_FORMAT(lrq.lrq_requestdatetime, '%H:00')
) received ON received.hour = hours.hour
LEFT JOIN (
  SELECT
    DATE_FORMAT(lrs.lrs_approvedatetime, '%H:00') AS hour,
    COUNT(*) AS approved
  FROM labrequest lrq
  JOIN labresult lrs ON lrq.lrq_no = lrs.lrs_lrq_no
  WHERE lrs.lrs_approvedatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
  GROUP BY DATE_FORMAT(lrs.lrs_approvedatetime, '%H:00')
) approved ON approved.hour = hours.hour
LEFT JOIN (
  SELECT
    DATE_FORMAT(lrq.lrq_requestdatetime, '%H:00') AS hour,
    AVG(
      TIMESTAMPDIFF(
        MINUTE,
        lrq.lrq_requestdatetime,
        COALESCE(
          lrs.lrs_approvedatetime,
          lrs.lrs_reportdatetime,
          lrs.lrs_resultdatetime,
          lrs.lrs_analysedatetime,
          CASE
            WHEN DATE(lrq.lrq_requestdatetime) = CURRENT_DATE THEN NOW()
            ELSE COALESCE(snapshot.latestAt, lrq.lrq_requestdatetime)
          END
        )
      )
    ) AS avg_tat,
    AVG(
      CASE
        WHEN TIMESTAMPDIFF(
          MINUTE,
          lrq.lrq_requestdatetime,
          COALESCE(
            lrs.lrs_approvedatetime,
            lrs.lrs_reportdatetime,
            lrs.lrs_resultdatetime,
            lrs.lrs_analysedatetime,
            CASE
              WHEN DATE(lrq.lrq_requestdatetime) = CURRENT_DATE THEN NOW()
              ELSE COALESCE(snapshot.latestAt, lrq.lrq_requestdatetime)
            END
          )
        ) <= CASE
          WHEN lrq.lrq_iscritical IN ('1', 'Y') OR lrs.lrs_iscritical IN ('1', 'Y') THEN COALESCE(NULLIF(t.t_asaptime, 0), NULLIF(t.t_stattime, 0), NULLIF(t.t_routinetime, 0), 1) * 60
          WHEN lrq.lrq_urgent IN ('1', 'Y') OR t.t_urgent IN ('1', 'Y') THEN COALESCE(NULLIF(t.t_stattime, 0), NULLIF(t.t_routinetime, 0), 2) * 60
          ELSE COALESCE(NULLIF(t.t_routinetime, 0), NULLIF(t.t_stattime, 0), 4) * 60
        END
        THEN 100
        ELSE 0
      END
    ) AS on_time_rate
  FROM labrequest lrq
  JOIN labresult lrs ON lrq.lrq_no = lrs.lrs_lrq_no
  CROSS JOIN (
    SELECT MAX(event_time) AS latestAt
    FROM (
      SELECT MAX(lrq_snapshot.lrq_requestdatetime) AS event_time
      FROM labrequest lrq_snapshot
      WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      UNION ALL
      SELECT MAX(lrs_snapshot.lrs_analysedatetime) AS event_time
      FROM labrequest lrq_snapshot
      JOIN labresult lrs_snapshot ON lrq_snapshot.lrq_no = lrs_snapshot.lrs_lrq_no
      WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      UNION ALL
      SELECT MAX(lrs_snapshot.lrs_resultdatetime) AS event_time
      FROM labrequest lrq_snapshot
      JOIN labresult lrs_snapshot ON lrq_snapshot.lrq_no = lrs_snapshot.lrs_lrq_no
      WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      UNION ALL
      SELECT MAX(lrs_snapshot.lrs_reportdatetime) AS event_time
      FROM labrequest lrq_snapshot
      JOIN labresult lrs_snapshot ON lrq_snapshot.lrq_no = lrs_snapshot.lrs_lrq_no
      WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
      UNION ALL
      SELECT MAX(lrs_snapshot.lrs_approvedatetime) AS event_time
      FROM labrequest lrq_snapshot
      JOIN labresult lrs_snapshot ON lrq_snapshot.lrq_no = lrs_snapshot.lrs_lrq_no
      WHERE lrq_snapshot.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
    ) snapshot_events
  ) snapshot
  LEFT JOIN labtest lt ON lrs.lrs_lt_no = lt.lt_no
  LEFT JOIN test t ON lt.lt_t_no = t.t_no
  WHERE lrq.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
  GROUP BY DATE_FORMAT(lrq.lrq_requestdatetime, '%H:00')
) turnaround ON turnaround.hour = hours.hour
ORDER BY hours.hour ASC;
