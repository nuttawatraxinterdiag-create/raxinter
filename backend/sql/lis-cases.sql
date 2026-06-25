WITH lrs_rollup AS (
  SELECT
    lt_filter.lt_no AS lrs_lt_no,
    lt_filter.lt_lrq_no AS lrs_lrq_no,
    MAX(CASE WHEN lrs.lrs_iscritical IN ('1', 'Y', 'y') THEN 1 ELSE 0 END) AS is_critical,
    MAX(CASE WHEN lrs.lrs_isanalyse  IN ('1', 'Y', 'y') THEN 1 ELSE 0 END) AS is_analyse,
    MAX(CASE WHEN lrs.lrs_isresult   IN ('1', 'Y', 'y') THEN 1 ELSE 0 END) AS is_result,
    MAX(CASE WHEN lrs.lrs_isreport   IN ('1', 'Y', 'y') THEN 1 ELSE 0 END) AS is_report,
    MAX(CASE WHEN lrs.lrs_isapprove  IN ('1', 'Y', 'y') THEN 1 ELSE 0 END) AS is_approve,
    MAX(CAST(COALESCE(NULLIF(lrs.lrs_status, ''), '0') AS UNSIGNED)) AS status_rank,
    MAX(lrs.lrs_analysedatetime) AS analysedatetime,
    MAX(lrs.lrs_resultdatetime) AS resultdatetime,
    MAX(lrs.lrs_reportdatetime) AS reportdatetime,
    MAX(lrs.lrs_approvedatetime) AS approvedatetime,
    MAX(NULLIF(lrs.lrs_itm_no, '')) AS itm_no
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
    lrq.lrq_requestno,
    lrq.lrq_ln,
    lrq.lrq_requestdatetime,
    lrq.lrq_iscritical,
    lrq.lrq_urgent,
    lrq.lrq_isstatusanalyse,
    lrq.lrq_isstatusresult,
    lrq.lrq_isstatusreport,
    lrq.lrq_isstatusapprove,
    lrq.lrq_ctm_no,
    lrq.lrq_pt_no,
    lt.lt_no,
    lt.lt_analysedatetime,
    lt.lt_resultdatetime,
    lt.lt_reportdatetime,
    lt.lt_approvedatetime,
    t.t_name,
    t.t_urgent,
    t.t_routinetime,
    t.t_stattime,
    t.t_asaptime,
    t.t_unittime,
    t.t_instrument,
    s.st_name,
    p.pt_name,
    p.pt_firstname,
    p.pt_lastname,
    p.pt_hn,
    c.ctm_name,
    lrs.is_critical,
    lrs.is_analyse,
    lrs.is_result,
    lrs.is_report,
    lrs.is_approve,
    lrs.status_rank,
    lrs.analysedatetime AS lrs_analysedatetime,
    lrs.resultdatetime AS lrs_resultdatetime,
    lrs.reportdatetime AS lrs_reportdatetime,
    lrs.approvedatetime AS lrs_approvedatetime,
    lrs.itm_no,
    CASE
      WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('H', '1', '2') THEN 60
      WHEN UPPER(COALESCE(t.t_unittime, '')) IN ('D', '3') THEN 1440
      ELSE 1
    END AS tat_unit_multiplier
  FROM labrequest lrq
  JOIN labtest lt ON lrq.lrq_no = lt.lt_lrq_no
  LEFT JOIN lrs_rollup lrs ON lt.lt_no = lrs.lrs_lt_no
  LEFT JOIN test t ON lt.lt_t_no = t.t_no
  LEFT JOIN section s ON COALESCE(NULLIF(lt.lt_st_no, ''), NULLIF(t.t_st_no, '')) = s.st_no
  LEFT JOIN patient p ON lrq.lrq_pt_no = p.pt_no
  LEFT JOIN customer c ON lrq.lrq_ctm_no = c.ctm_no
  WHERE lrq.lrq_requestdatetime BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
    AND COALESCE(lrq.lrq_isdelete, '') NOT IN ('1', 'Y', 'y')
    AND COALESCE(lt.lt_isdelete, '') NOT IN ('1', 'Y', 'y')
)
SELECT
  CONCAT(case_rows.lrq_requestno, '-', case_rows.lt_no) AS id,
  case_rows.lrq_requestno AS requestNo,
  case_rows.lrq_ln AS sampleNo,
  case_rows.lrq_requestdatetime AS orderedAt,
  CASE
    WHEN case_rows.lrq_iscritical IN ('1', 'Y', 'y') OR case_rows.is_critical = 1 OR case_rows.lrq_urgent = '2' THEN 'Critical'
    WHEN case_rows.lrq_urgent IN ('1', 'Y', 'y') OR case_rows.t_urgent IN ('1', 'Y', 'y') THEN 'Urgent'
    ELSE 'Routine'
  END AS priority,
  CASE
    WHEN case_rows.lt_approvedatetime IS NOT NULL OR case_rows.lrs_approvedatetime IS NOT NULL OR case_rows.is_approve = 1 OR case_rows.status_rank >= 5 OR case_rows.lrq_isstatusapprove IN ('1', 'Y', 'y') THEN 'Approve'
    WHEN case_rows.lt_reportdatetime IS NOT NULL OR case_rows.lrs_reportdatetime IS NOT NULL OR case_rows.is_report = 1 OR case_rows.status_rank = 4 OR case_rows.lrq_isstatusreport IN ('1', 'Y', 'y') THEN 'Report'
    WHEN case_rows.lt_resultdatetime IS NOT NULL OR case_rows.lrs_resultdatetime IS NOT NULL OR case_rows.is_result = 1 OR case_rows.status_rank = 3 OR case_rows.lrq_isstatusresult IN ('1', 'Y', 'y') THEN 'Result'
    WHEN case_rows.lt_analysedatetime IS NOT NULL OR case_rows.lrs_analysedatetime IS NOT NULL OR case_rows.is_analyse = 1 OR case_rows.status_rank = 2 OR case_rows.lrq_isstatusanalyse IN ('1', 'Y', 'y') THEN 'Analyzing'
    ELSE 'Request'
  END AS status,
  'pctag: labrequest + labtest + labresult rollup' AS sourceTable,
  CASE
    WHEN case_rows.lt_approvedatetime IS NOT NULL OR case_rows.lrs_approvedatetime IS NOT NULL OR case_rows.is_approve = 1 OR case_rows.status_rank >= 5 OR case_rows.lrq_isstatusapprove IN ('1', 'Y', 'y') THEN 'Approve'
    WHEN case_rows.lt_reportdatetime IS NOT NULL OR case_rows.lrs_reportdatetime IS NOT NULL OR case_rows.is_report = 1 OR case_rows.status_rank = 4 OR case_rows.lrq_isstatusreport IN ('1', 'Y', 'y') THEN 'Report'
    WHEN case_rows.lt_resultdatetime IS NOT NULL OR case_rows.lrs_resultdatetime IS NOT NULL OR case_rows.is_result = 1 OR case_rows.status_rank = 3 OR case_rows.lrq_isstatusresult IN ('1', 'Y', 'y') THEN 'Result sent'
    WHEN case_rows.lt_analysedatetime IS NOT NULL OR case_rows.lrs_analysedatetime IS NOT NULL OR case_rows.is_analyse = 1 OR case_rows.status_rank = 2 OR case_rows.lrq_isstatusanalyse IN ('1', 'Y', 'y') THEN 'Analyzing'
    ELSE 'Request'
  END AS stage,
  COALESCE(NULLIF(case_rows.t_name, ''), case_rows.lt_no) AS test,
  COALESCE(NULLIF(case_rows.itm_no, ''), NULLIF(case_rows.t_instrument, ''), 'Manual') AS machine,
  TIMESTAMPDIFF(
    MINUTE,
    case_rows.lrq_requestdatetime,
    COALESCE(
      case_rows.lt_approvedatetime,
      case_rows.lrs_approvedatetime,
      case_rows.lt_reportdatetime,
      case_rows.lrs_reportdatetime,
      case_rows.lt_resultdatetime,
      case_rows.lrs_resultdatetime,
      case_rows.lt_analysedatetime,
      case_rows.lrs_analysedatetime,
      CASE
        WHEN DATE(case_rows.lrq_requestdatetime) = CURRENT_DATE THEN NOW()
        ELSE COALESCE(snapshot.latestAt, case_rows.lrq_requestdatetime)
      END
    )
  ) AS elapsed,
  CASE
    WHEN case_rows.lrq_iscritical IN ('1', 'Y', 'y') OR case_rows.is_critical = 1 OR case_rows.lrq_urgent = '2' THEN 'ASAP'
    WHEN case_rows.lrq_urgent IN ('1', 'Y', 'y') OR case_rows.t_urgent IN ('1', 'Y', 'y') THEN 'STAT'
    ELSE 'ROUTINE'
  END AS pctag,
  CASE
    WHEN case_rows.lrq_iscritical IN ('1', 'Y', 'y') OR case_rows.is_critical = 1 OR case_rows.lrq_urgent = '2' THEN COALESCE(NULLIF(case_rows.t_asaptime, 0) * case_rows.tat_unit_multiplier, NULLIF(case_rows.t_stattime, 0) * case_rows.tat_unit_multiplier, NULLIF(case_rows.t_routinetime, 0) * case_rows.tat_unit_multiplier, 15)
    WHEN case_rows.lrq_urgent IN ('1', 'Y', 'y') OR case_rows.t_urgent IN ('1', 'Y', 'y') THEN COALESCE(NULLIF(case_rows.t_stattime, 0) * case_rows.tat_unit_multiplier, NULLIF(case_rows.t_routinetime, 0) * case_rows.tat_unit_multiplier, 30)
    ELSE COALESCE(NULLIF(case_rows.t_routinetime, 0) * case_rows.tat_unit_multiplier, NULLIF(case_rows.t_stattime, 0) * case_rows.tat_unit_multiplier, 90)
  END AS due,
  COALESCE(NULLIF(case_rows.ctm_name, ''), case_rows.lrq_ctm_no, 'Unknown customer') AS account,
  COALESCE(
    NULLIF(case_rows.pt_name, ''),
    NULLIF(TRIM(CONCAT(COALESCE(case_rows.pt_firstname, ''), ' ', COALESCE(case_rows.pt_lastname, ''))), ''),
    case_rows.lrq_pt_no
  ) AS patient,
  COALESCE(NULLIF(case_rows.pt_hn, ''), case_rows.lrq_pt_no) AS hn,
  CASE
    WHEN case_rows.st_name = 'Hematology' THEN 'HEM'
    WHEN case_rows.st_name IN ('Chemistry', 'Immunology') THEN 'ICH'
    WHEN case_rows.st_name IN ('Microscopy', 'Bacteria') THEN 'MIC'
    WHEN case_rows.st_name = 'Molecular Diagnostic' THEN 'MOL'
    WHEN case_rows.st_name = 'Flow cytometry' THEN 'FLOW'
    WHEN case_rows.st_name = 'Thalassemia' THEN 'THAL'
    ELSE COALESCE(NULLIF(case_rows.st_name, ''), 'GEN')
  END AS groupName,
  COALESCE(NULLIF(case_rows.st_name, ''), 'Unassigned') AS department,
  'Lab sample' AS sample,
  'Unknown doctor' AS doctor,
  COALESCE(NULLIF(case_rows.ctm_name, ''), 'Unassigned') AS owner
FROM case_rows
CROSS JOIN snapshot
ORDER BY case_rows.lrq_requestdatetime DESC, case_rows.lrq_requestno DESC, case_rows.lt_no ASC;
