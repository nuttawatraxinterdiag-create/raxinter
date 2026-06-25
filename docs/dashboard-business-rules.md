# Dashboard Business Rules

This dashboard reads live LIS data from MariaDB when `DASHBOARD_DATA_MODE=mariadb`.

## Priority Cards

The top cards always show the lab sections `ICH`, `HEM`, and `MIC`, matching the reference dashboard.

- Very urgent means `ASAP`.
- Urgent means `STAT`.
- Normal means `ROUTINE`.

If Very urgent or Urgent shows `0`, it usually means the selected date has no active rows matching those rules. The section bars also show `0%` because there are no ICH, HEM, or MIC rows inside that priority group.

## Priority Mapping

The backend currently maps LIS rows like this:

- `ASAP`: request or result is critical, or `lrq_urgent = 2`.
- `STAT`: request is urgent, or the test is marked urgent.
- `ROUTINE`: anything that is not ASAP or STAT.

## TAT Zones

- OK: active request is still below warning time.
- Warning: active request has used at least 82% of its target TAT but is not over yet.
- Over TAT: active request has passed its target TAT.
- Completed rows are excluded from active warning and over-TAT panels.

## Section Filters

The detailed requirement appears to need high-level filters like Chemistry, Hematology, Immunology, Bacteria, Blood Bank, IPD, and OPD. The database has lab section values, but IPD and OPD are patient/request source concepts, so those filters may need grouped business rules rather than a direct one-column match.
