SELECT
  lrq.lrq_requestno AS id,
  lrq.lrq_requestno AS requestNo,
  lrq.lrq_ln AS sampleNo,
  lrq.lrq_requestdatetime AS orderedAt,
  CASE
    WHEN lrq.lrq_iscritical IN ('1', 'Y') OR lrs.lrs_iscritical IN ('1', 'Y') THEN 'Critical'
    WHEN lrq.lrq_urgent IN ('1', 'Y') OR t.t_urgent IN ('1', 'Y') THEN 'Urgent'
    ELSE 'Routine'
  END AS priority,
  CASE
    WHEN lrs.lrs_status IN ('5', '6', '7') OR lrs.lrs_isapprove = 'Y' THEN 'Completed'
    WHEN lrs.lrs_status = '4' OR lrs.lrs_isreport = 'Y' THEN 'Report'
    WHEN lrs.lrs_status = '3' OR lrs.lrs_isresult = 'Y' THEN 'Result'
    WHEN lrs.lrs_status = '2' OR lrs.lrs_isanalyse = 'Y' THEN 'Analyzing'
    ELSE 'Request'
  END AS status,
  'pctag: labrequest + labresult' AS sourceTable,
  CASE
    WHEN lrs.lrs_isapprove = 'Y' THEN 'Approve'
    WHEN lrs.lrs_isreport = 'Y' THEN 'Report'
    WHEN lrs.lrs_isresult = 'Y' THEN 'Result sent'
    WHEN lrs.lrs_isanalyse = 'Y' THEN 'Analyzing'
    ELSE 'Request'
  END AS stage,
  COALESCE(NULLIF(t.t_name, ''), lrs.lrs_lt_no) AS test,
  COALESCE(NULLIF(lrs.lrs_itm_no, ''), NULLIF(t.t_instrument, ''), 'Manual') AS machine,
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
  ) AS elapsed,
  CASE
    WHEN lrq.lrq_iscritical IN ('1', 'Y') OR lrs.lrs_iscritical IN ('1', 'Y') THEN 'ASAP'
    WHEN lrq.lrq_urgent IN ('1', 'Y') OR t.t_urgent IN ('1', 'Y') THEN 'STAT'
    ELSE 'ROUTINE'
  END AS pctag,
  CASE
    WHEN lrq.lrq_iscritical IN ('1', 'Y') OR lrs.lrs_iscritical IN ('1', 'Y') THEN COALESCE(NULLIF(t.t_asaptime, 0), NULLIF(t.t_stattime, 0), NULLIF(t.t_routinetime, 0), 1) * 60
    WHEN lrq.lrq_urgent IN ('1', 'Y') OR t.t_urgent IN ('1', 'Y') THEN COALESCE(NULLIF(t.t_stattime, 0), NULLIF(t.t_routinetime, 0), 2) * 60
    ELSE COALESCE(NULLIF(t.t_routinetime, 0), NULLIF(t.t_stattime, 0), 4) * 60
  END AS due,
  COALESCE(NULLIF(c.ctm_name, ''), lrq.lrq_ctm_no, 'Unknown customer') AS account,
  COALESCE(
    NULLIF(p.pt_name, ''),
    NULLIF(TRIM(CONCAT(COALESCE(p.pt_firstname, ''), ' ', COALESCE(p.pt_lastname, ''))), ''),
    lrq.lrq_pt_no
  ) AS patient,
  COALESCE(NULLIF(p.pt_hn, ''), lrq.lrq_pt_no) AS hn,
  CASE
    WHEN s.st_name = 'Hematology' THEN 'HEM'
    WHEN s.st_name IN ('Chemistry', 'Immunology') THEN 'ICH'
    WHEN s.st_name IN ('Microscopy', 'Bacteria') THEN 'MIC'
    WHEN s.st_name = 'Molecular Diagnostic' THEN 'MOL'
    WHEN s.st_name = 'Flow cytometry' THEN 'FLOW'
    WHEN s.st_name = 'Thalassemia' THEN 'THAL'
    ELSE COALESCE(NULLIF(s.st_name, ''), 'GEN')
  END AS groupName,
  COALESCE(NULLIF(s.st_name, ''), 'Unassigned') AS department,
  'Lab sample' AS sample,
  'Unknown doctor' AS doctor,
  COALESCE(NULLIF(c.ctm_name, ''), 'Unassigned') AS owner
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
LEFT JOIN section s ON t.t_st_no = s.st_no
LEFT JOIN patient p ON lrq.lrq_pt_no = p.pt_no
LEFT JOIN customer c ON lrq.lrq_ctm_no = c.ctm_no
WHERE lrq.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
ORDER BY lrq.lrq_requestdatetime DESC, lrq.lrq_requestno DESC;
