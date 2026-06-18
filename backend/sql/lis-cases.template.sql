-- Copy this file to something like backend/sql/lis-cases.sql
-- and replace the table and column names with your real LIS schema.
--
-- Required output aliases for the dashboard:
-- id, patient, department, test, sample, priority, status, stage,
-- orderedAt, elapsed, due, machine, owner, doctor
--
-- Optional aliases for the richer PWL monitor:
-- account, groupName, pctag
--
-- Available date tokens:
-- {{selectedDate}}
-- {{selectedDateStart}}
-- {{selectedDateEnd}}

SELECT
  r.request_no AS id,
  p.patient_name AS patient,
  c.account_name AS account,
  s.section_name AS department,
  s.section_code AS groupName,
  t.test_name AS test,
  sp.sample_name AS sample,
  CASE
    WHEN r.priority_code IN ('STAT', 'CRITICAL') THEN 'Critical'
    WHEN r.priority_code IN ('URGENT') THEN 'Urgent'
    ELSE 'Routine'
  END AS priority,
  r.result_status AS status,
  CASE
    WHEN r.workflow_stage IN ('REGISTERED', 'QUEUED') THEN 'Pending'
    WHEN r.workflow_stage IN ('RECEIVED', 'COLLECTED') THEN 'Received'
    WHEN r.workflow_stage IN ('ANALYZING', 'RUNNING', 'PROCESSING') THEN 'Analyzing'
    WHEN r.workflow_stage IN ('VERIFY', 'REVIEW', 'REPORTING') THEN 'SD Verify'
    WHEN r.workflow_stage IN ('APPROVED', 'RELEASED', 'COMPLETED') THEN 'Approved'
    ELSE 'Pending'
  END AS stage,
  DATE_FORMAT(r.ordered_at, '%H:%i') AS orderedAt,
  TIMESTAMPDIFF(MINUTE, r.ordered_at, COALESCE(r.completed_at, NOW())) AS elapsed,
  COALESCE(r.tat_target_minutes, 60) AS due,
  COALESCE(r.pctag_name, r.priority_code) AS pctag,
  COALESCE(a.instrument_name, 'Manual') AS machine,
  COALESCE(u.owner_name, 'Unassigned') AS owner,
  COALESCE(d.doctor_name, 'Unknown doctor') AS doctor
FROM lis_requests r
LEFT JOIN lis_patients p ON p.id = r.patient_id
LEFT JOIN lis_customers c ON c.id = r.customer_id
LEFT JOIN lis_sections s ON s.id = r.section_id
LEFT JOIN lis_tests t ON t.id = r.test_id
LEFT JOIN lis_samples sp ON sp.id = r.sample_id
LEFT JOIN lis_instruments a ON a.id = r.instrument_id
LEFT JOIN lis_users u ON u.id = r.owner_user_id
LEFT JOIN lis_doctors d ON d.id = r.doctor_id
WHERE r.ordered_at BETWEEN {{selectedDateStart}} AND {{selectedDateEnd}}
ORDER BY r.ordered_at ASC;
