/* ══════════════════════════════════════════════════════════
   CONFIG
══════════════════════════════════════════════════════════ */
const AUTO_REFRESH_MS            = 30000;
const VIEW_ROTATION_MS           = 12000;
const VIEW_IDLE_RESUME_MS        = 5000;
const AUTO_REFRESH_ENABLED       = false;
const VIEW_ROTATION_ENABLED      = false;
const WARNING_RATIO              = 0.82;
const DASHBOARD_PAGE_STORAGE_KEY = "pwl-lis-active-page";
const WORKLOAD_CHART_FALLBACK_HEIGHT = 300;

const LIS_STATUS_ORDER = [
  "Request",
  "Analyzing",
  "Result",
  "Report",
  "Approve",
];

const LIS_STATUS_PRIORITY = {
  Request: 1,
  Analyzing: 2,
  Result: 3,
  Report: 4,
  Approve: 5,
};

const PCTAG_DEFINITIONS = [
  { value: "ASAP",    label: "ASAP",    target: 15 },
  { value: "STAT",    label: "STAT",    target: 30 },
  { value: "ROUTINE", label: "Routine", target: 90 },
];

const PRIORITY_CARD_SECTIONS = ["ICH", "HEM", "MIC"];

const STATUS_CLASS = {
  Request:        "status-request",
  Received:       "status-request",
  Pending:        "status-request",
  Analyzing:      "status-analyzing",
  Processing:     "status-analyzing",
  Result:         "status-result-sent",
  "Result sent":  "status-result-sent",
  Resulted:       "status-result-sent",
  Report:         "status-report",
  Review:         "status-report",
  "Awaiting report": "status-report",
  Approve:        "status-approve",
  Approved:       "status-approve",
  Completed:      "status-approve",
};

/* Map status → CSS class for ss-bar-fill */
const STATUS_FILL_CLASS = {
  Request:        "ss-fill-request",
  Analyzing:      "ss-fill-analyzing",
  Result:         "ss-fill-result-sent",
  "Result sent":  "ss-fill-result-sent",
  Report:         "ss-fill-report",
  Approve:        "ss-fill-approve",
  Completed:      "ss-fill-approve",
};

/* ══════════════════════════════════════════════════════════
   SAMPLE DATA  (mock — replaced by live API)
══════════════════════════════════════════════════════════ */

/* ══════════════════════════════════════════════════════════
   STATE
══════════════════════════════════════════════════════════ */
let autoRefreshIntervalId  = null;
let tickIntervalId         = null;
let searchTimeoutId        = null;
let viewRotationIntervalId = null;
let viewIdleResumeTimeoutId = null;
let chartResizeObserver    = null;
let lastChartHostWidth     = 0;
let nextAutoRefreshAt      = 0;
let nextViewRotationAt     = 0;
let isViewRotationPaused   = false;
let isPointerInsideDashboard = false;

const state = {
  account:         "all",
  allRows:         [],
  date:            "",
  dashboardLoading: false,
  lastUpdatedAt:   null,
  latestError:     "",
  latestSource:    "idle",
  latestTrendKey:  "",
  latestTrend:     [],
  priority:        "all",
  search:          "",
  section:         "all",
  viewMode:        getInitialViewMode(),
};

/* ══════════════════════════════════════════════════════════
   ELEMENT CACHE
══════════════════════════════════════════════════════════ */
const elements = {
  accountFilter:      document.querySelector("#accountFilter"),
  actionBoardTotal:   document.querySelector("#actionBoardTotal"),
  billboardControls:  [...document.querySelectorAll("[data-billboard-target]")],
  completedTotal:     document.querySelector("#completedTotal"),
  dashboardScreen:    document.querySelector(".dashboard-screen"),
  dateFilter:         document.querySelector("#dateFilter"),
  lastUpdated:        document.querySelector("#lastUpdated"),
  liveBadge:          document.querySelector("#liveBadge"),
  liveClock:          document.querySelector("#liveClock"),
  overList:           document.querySelector("#overList"),
  overSummaryTotal:   document.querySelector("#overSummaryTotal"),
  overTotal:          document.querySelector("#overTotal"),
  pendingTotal:       document.querySelector("#pendingTotal"),
  priorityFilter:     document.querySelector("#priorityFilter"),
  priorityCards:      [...document.querySelectorAll("[data-priority-filter]")],
  refreshBtn:         document.querySelector("#refreshBtn"),
  searchInput:        document.querySelector("#searchInput"),
  sectionTabs:        document.querySelector("#sectionTabs"),
  warningList:        document.querySelector("#warningList"),
  warningSummaryTotal: document.querySelector("#warningSummaryTotal"),
  warningTotal:       document.querySelector("#warningTotal"),

  /* Dashboard 1 priority cards */
  priorityCriticalCount: document.querySelector("#priorityCriticalCount"),
  priorityCriticalSub:   document.querySelector("#priorityCriticalSub"),
  priorityCriticalBars:  document.querySelector("#priorityCriticalBars"),
  priorityUrgentCount:   document.querySelector("#priorityUrgentCount"),
  priorityUrgentSub:     document.querySelector("#priorityUrgentSub"),
  priorityUrgentBars:    document.querySelector("#priorityUrgentBars"),
  priorityRoutineCount:  document.querySelector("#priorityRoutineCount"),
  priorityRoutineSub:    document.querySelector("#priorityRoutineSub"),
  priorityRoutineBars:   document.querySelector("#priorityRoutineBars"),
  tatStats:           document.querySelector("#tatStats"),
  statusTotalLabel:   document.querySelector("#statusTotalLabel"),
  statusSummaryList:  document.querySelector("#statusSummaryList"),
  chartTooltip:       document.querySelector("#chartTooltip"),
  workloadChart:      document.querySelector("#workloadChart"),

  /* Alert panels */
  urgentAsapBadge:    document.querySelector("#urgentAsapBadge"),
  urgentStatBadge:    document.querySelector("#urgentStatBadge"),
  urgentSectionRow:   document.querySelector("#urgentSectionRow"),
  urgentChips:        document.querySelector("#urgentChips"),
  criticalBadge:      document.querySelector("#criticalBadge"),
  criticalSectionRow: document.querySelector("#criticalSectionRow"),
  criticalChips:      document.querySelector("#criticalChips"),
  warnTimeBadge:      document.querySelector("#warnTimeBadge"),
  warnTimeSectionRow: document.querySelector("#warnTimeSectionRow"),
  warnTimeChips:      document.querySelector("#warnTimeChips"),
  overWarrantyBadge:  document.querySelector("#overWarrantyBadge"),
  overWarrantyChips:  document.querySelector("#overWarrantyChips"),
};

/* ══════════════════════════════════════════════════════════
   DATA HELPERS
══════════════════════════════════════════════════════════ */
function arrayRowToObject(row) {
  return {
    account:    row[0],
    sampleNo:   row[1],
    requestNo:  row[2],
    hn:         row[3],
    patient:    row[4],
    section:    row[5],
    test:       row[6],
    pctag:      row[7],
    lisStatus:  row[8],
    processStage: row[9],
    elapsedTat: row[10],
    targetTat:  row[11],
    machine:    row[12],
  };
}

function normalizeRow(row = {}, index = 0) {
  const pctag     = normalizePctag(row.pctag || row.tatCategory || row.priority);
  const targetTat = positiveNumber(row.targetTat ?? row.target ?? row.due ?? row.tatTarget, getPctagDefinition(pctag).target);
  const elapsedTat = positiveNumber(row.elapsedTat ?? row.elapsed ?? row.actual ?? row.actualTat, 0);
  const processStage = normalizeProcessStage(row.processStage || row.stage || row.status);
  const lisStatus = normalizeLisStatus(row.lisStatus || row.status || processStage);

  return {
    account:      String(row.account || row.customer || row.accountCustomer || "PWL"),
    orderedAt:    row.orderedAt || row.ordered_at || "",
    sampleNo:     String(row.sampleNo || row.sample_no || row.specimenNo || row.id || `SAMPLE-${index + 1}`),
    requestNo:    String(row.requestNo || row.request_no || row.ln || row.labNo || row.id || `LN-${index + 1}`),
    hn:           String(row.hn || row.HN || row.patientNo || `HN-${100000 + index}`),
    patient:      String(row.patient || row.patientName || row.name || "Unknown"),
    section:      String(row.section || row.groupName || row.department || "Unassigned").trim() || "Unassigned",
    test:         String(row.test || row.testName || row.itemName || "Unknown test"),
    pctag,
    lisStatus,
    processStage,
    elapsedTat,
    targetTat,
    machine:      String(row.machine || row.analyzer || row.instrument || "Manual"),
  };
}

function positiveNumber(value, fallback = 0) {
  const n = Number(value);
  return Number.isFinite(n) && n >= 0 ? n : fallback;
}

function normalizePctag(value) {
  const text = String(value || "").trim().toUpperCase();
  if (text.includes("ASAP") || text.includes("CRITICAL") || text.includes("VERY")) return "ASAP";
  if (text.includes("STAT") || text.includes("URGENT")) return "STAT";
  return "ROUTINE";
}

function normalizeProcessStage(value) {
  const text = String(value || "").trim().toLowerCase();
  if (text.includes("complete") || text.includes("approve") || text.includes("release")) return "Approve";
  if (text.includes("report") || text.includes("verify") || text.includes("review") || text.includes("await")) return "Report";
  if (text.includes("result")) return "Result sent";
  if (text.includes("analy") || text.includes("process") || text.includes("incubat") || text.includes("scan")) return "Analyzing";
  return "Request";
}

function normalizeLisStatus(value) {
  const text = String(value || "").trim().toLowerCase();
  if (text.includes("complete") || text.includes("release") || text.includes("approve")) return "Approve";
  if (text.includes("report") || text.includes("verify") || text.includes("review") || text.includes("await")) return "Report";
  if (text.includes("result")) return "Result";
  if (text.includes("analy") || text.includes("process") || text.includes("incubat") || text.includes("scan")) return "Analyzing";
  return "Request";
}

function getPctagDefinition(value) {
  return PCTAG_DEFINITIONS.find((item) => item.value === value) || PCTAG_DEFINITIONS[2];
}

function isCompleted(row) {
  return row.lisStatus === "Approve" || row.lisStatus === "Completed" || row.processStage === "Approve";
}

function isOverTat(row) {
  return !isCompleted(row) && row.elapsedTat > row.targetTat;
}

function isWarningTat(row) {
  if (isCompleted(row) || row.targetTat <= 0) return false;
  const ratio = row.elapsedTat / row.targetTat;
  return ratio >= WARNING_RATIO && ratio <= 1;
}

function getTatStatus(row) {
  if (isCompleted(row))    return "completed";
  if (isOverTat(row))      return "over";
  if (isWarningTat(row))   return "warning";
  return "inside";
}

function getStatusClass(rowOrStatus) {
  const status = typeof rowOrStatus === "string" ? rowOrStatus : rowOrStatus?.lisStatus;
  return STATUS_CLASS[status] || "status-request";
}

function getStatusBorderClass(rowOrStatus) {
  return `border-${getStatusClass(rowOrStatus)}`;
}

function getDominantLisStatus(rows) {
  const status = rows.reduce((best, row) => {
    const current = row.lisStatus;
    if (!best) return current;
    const currentPriority = LIS_STATUS_PRIORITY[current] || 0;
    const bestPriority    = LIS_STATUS_PRIORITY[best] || 0;
    if (currentPriority !== bestPriority) return currentPriority > bestPriority ? current : best;
    const currentElapsed = Number(row.elapsedTat || 0);
    const bestElapsed    = Number(rows.find((item) => item.lisStatus === best)?.elapsedTat || 0);
    return currentElapsed > bestElapsed ? current : best;
  }, "");

  return { label: status, className: getStatusClass(status), borderClass: getStatusBorderClass(status) };
}

function getDominantSectionStatus(rows) {
  if (rows.some(isOverTat))    return { label: "Over TAT", className: "status-over-tat",  borderClass: "border-status-over-tat" };
  if (rows.some(isWarningTat)) return { label: "Warning",  className: "status-warning",   borderClass: "border-status-warning" };

  return getDominantLisStatus(rows);
}

function matchesSearch(row) {
  const searchText = state.search.trim().toLowerCase();
  return !searchText || [
    row.sampleNo, row.requestNo, row.hn, row.patient,
    row.section, row.test, row.pctag, row.lisStatus,
    row.processStage, row.machine, row.account,
  ].join(" ").toLowerCase().includes(searchText);
}

function matchesBaseFilters(row) {
  const accountMatch = state.account === "all" || row.account === state.account;
  const sectionMatch = state.section === "all" || row.section === state.section;
  return accountMatch && sectionMatch && matchesSearch(row);
}

function matchesPriorityFocus(row) {
  return state.priority === "all" || row.pctag === state.priority;
}

function getSummaryRows() {
  return state.allRows.filter(matchesBaseFilters);
}

function getDetailRows(summaryRows = getSummaryRows()) {
  return summaryRows.filter(matchesPriorityFocus);
}

function getRowsForSectionTabs() {
  return state.allRows.filter((row) => {
    const accountMatch = state.account === "all" || row.account === state.account;
    return accountMatch && matchesSearch(row);
  });
}

function getStats(rows) {
  const total     = rows.length;
  const warning   = rows.filter(isWarningTat).length;
  const over      = rows.filter(isOverTat).length;
  const completed = rows.filter(isCompleted).length;
  const ok        = total - warning - over - completed;
  return {
    active: rows.filter((row) => !isCompleted(row)).length,
    completed,
    completedRate: total ? Math.round((completed / total) * 1000) / 10 : 0,
    ok: Math.max(0, ok),
    over,
    total,
    warning,
  };
}

function groupRows(rows, keyFn) {
  return rows.reduce((groups, row) => {
    const key = keyFn(row);
    if (!groups[key]) groups[key] = [];
    groups[key].push(row);
    return groups;
  }, {});
}

function getSectionSummary(rows) {
  return Object.entries(groupRows(rows, (row) => row.section))
    .map(([section, group]) => ({
      section,
      rows: group,
      dominant: getDominantSectionStatus(group),
      ...getStats(group),
    }))
    .sort((a, b) => (
      b.over - a.over || b.warning - a.warning || b.total - a.total || a.section.localeCompare(b.section)
    ));
}

function sortByRisk(rows) {
  return [...rows].sort((a, b) => {
    const aStatus = getTatStatus(a);
    const bStatus = getTatStatus(b);
    const aRank = aStatus === "over" ? 4 : aStatus === "warning" ? 3 : a.pctag === "ASAP" ? 2 : isCompleted(a) ? 0 : 1;
    const bRank = bStatus === "over" ? 4 : bStatus === "warning" ? 3 : b.pctag === "ASAP" ? 2 : isCompleted(b) ? 0 : 1;
    return bRank - aRank || (b.elapsedTat - b.targetTat) - (a.elapsedTat - a.targetTat) || a.requestNo.localeCompare(b.requestNo);
  });
}

function getRequestBoardEntries(rows) {
  return Object.values(groupRows(rows, (row) => `${row.requestNo}::${row.hn}`))
    .map((group) => {
      const sortedRows   = sortByRisk(group);
      const activeRows   = sortedRows.filter((row) => !isCompleted(row));
      const primaryRow   = activeRows[0] || sortedRows[0] || group[0];
      const allCompleted = group.every(isCompleted);
      const hasOver      = group.some(isOverTat);
      const hasWarning   = !hasOver && group.some((row) => !isCompleted(row) && (isWarningTat(row) || row.pctag === "ASAP"));
      const tatState     = hasOver ? "over" : hasWarning ? "warning" : allCompleted ? "completed" : "pending";
      const currentStatus = allCompleted
        ? { label: "Approve", className: "status-approve", borderClass: "border-status-approve" }
        : getDominantLisStatus(group);

      const sections = Object.entries(groupRows(group, (row) => row.section))
        .map(([section, sectionRows]) => ({
          count: sectionRows.length,
          section,
          status: getDominantLisStatus(sectionRows),
        }))
        .sort((a, b) => a.section.localeCompare(b.section));

      return {
        allCompleted,
        currentStatus,
        elapsedTat: primaryRow.elapsedTat,
        hn: primaryRow.hn,
        overBy: Math.max(0, ...group.map((row) => row.elapsedTat - row.targetTat)),
        patient: primaryRow.patient,
        pctag: primaryRow.pctag,
        processStage: primaryRow.processStage,
        requestNo: primaryRow.requestNo,
        rows: group,
        sampleCount: group.length,
        sections,
        targetLeft: activeRows.length ? Math.min(...activeRows.map((row) => Math.max(0, row.targetTat - row.elapsedTat))) : 0,
        targetTat: primaryRow.targetTat,
        tatState,
      };
    })
    .sort((a, b) => {
      const stateRank = { over: 3, warning: 2, pending: 1, completed: 0 };
      return stateRank[b.tatState] - stateRank[a.tatState]
        || b.overBy - a.overBy
        || a.targetLeft - b.targetLeft
        || a.requestNo.localeCompare(b.requestNo);
    });
}

/* ══════════════════════════════════════════════════════════
   RENDER — FILTERS & SECTION TABS
══════════════════════════════════════════════════════════ */
function render() {
  const summaryRows = getSummaryRows();
  const detailRows  = getDetailRows(summaryRows);

  renderFilters();
  renderSectionTabs();
  renderDashboard1(summaryRows, detailRows);
  renderActionBoards(detailRows);
  updateLastUpdatedLabel(state.lastUpdatedAt || new Date());
}

function renderFilters() {
  const accountGroups = Object.entries(groupRows(state.allRows, (row) => row.account))
    .map(([account, rows]) => ({ account, count: rows.length }))
    .sort((a, b) => (
      a.account === "PWL" ? -1 : b.account === "PWL" ? 1 : a.account.localeCompare(b.account)
    ));

  elements.accountFilter.innerHTML = [
    `<option value="all">All customers (${formatNumber(state.allRows.length)})</option>`,
    ...accountGroups.map((item) => `<option value="${h(item.account)}">${h(item.account)} (${formatNumber(item.count)})</option>`),
  ].join("");

  if (!["all", ...accountGroups.map((item) => item.account)].includes(state.account)) {
    state.account = accountGroups.some((item) => item.account === "PWL")
      ? "PWL"
      : accountGroups[0]?.account || "all";
  }

  elements.accountFilter.value = state.account;
  if (elements.priorityFilter) elements.priorityFilter.value = state.priority;
  elements.searchInput.value = state.search;
  elements.dateFilter.value = state.date;
}

function renderSectionTabs() {
  const rows     = getRowsForSectionTabs();
  const sections = getSectionSummary(rows);

  elements.sectionTabs.innerHTML = [
    sectionTabTemplate({ active: state.section === "all", count: rows.length, label: "All", section: "all", statusClass: "status-request" }),
    ...sections.map((section) => sectionTabTemplate({
      active: state.section === section.section,
      count:  section.total,
      label:  section.section,
      section: section.section,
      statusClass: section.dominant.className,
    })),
  ].join("");
}

function sectionTabTemplate({ active, count, label, section, statusClass }) {
  return `
    <button class="section-tab ${active ? "active" : ""}" type="button" data-section="${h(section)}">
      <span class="status-dot ${h(statusClass)}"></span>
      ${h(label)}
      <span class="section-count">${formatNumber(count)}</span>
    </button>
  `;
}

/* ══════════════════════════════════════════════════════════
   RENDER — DASHBOARD 1  (all 4 rules)
══════════════════════════════════════════════════════════ */
function renderDashboard1(summaryRows, detailRows) {
  renderPriorityCards(summaryRows);
  const detailStats = getStats(detailRows);
  renderTatStats(detailRows);
  renderStatusSummary(detailRows, detailStats);
  renderWorkloadChart(detailRows);
  renderAlertPanels(detailRows, detailStats);
}

/* ── ZONE A: Zone cards ────────────────────────────────── */
function renderZoneCards(rows, stats) {
  const total = stats.total;

  /* Big numbers */
  elements.zoneOkCount.textContent      = formatNumber(stats.ok);
  elements.zoneWarningCount.textContent = formatNumber(stats.warning);
  elements.zoneOverCount.textContent    = formatNumber(stats.over);

  /* Per-section breakdowns as progress bars (IPD/OPD style from Photo 2) */
  const sections = getSectionSummary(rows);

  function zoneBars(zoneFn, el) {
    if (!sections.length) { el.innerHTML = ""; return; }
    el.innerHTML = sections.slice(0, 4).map((sec) => {
      const count   = sec.rows.filter(zoneFn).length;
      const pct     = total ? Math.round((count / total) * 100) : 0;
      const fillPct = sec.total ? Math.round((count / sec.total) * 100) : 0;
      return `
        <div class="zone-bar-row">
          <span class="bar-label">${h(sec.section)}</span>
          <div class="zone-bar-track"><div class="zone-bar-fill" style="width:${fillPct}%"></div></div>
          <span class="bar-pct">${pct}%</span>
        </div>
      `;
    }).join("");
  }

  zoneBars((r) => !isOverTat(r) && !isWarningTat(r) && !isCompleted(r), elements.zoneOkBars);
  zoneBars(isWarningTat, elements.zoneWarningBars);
  zoneBars(isOverTat,    elements.zoneOverBars);
}

function renderPriorityCards(rows) {
  const visibleSections = PRIORITY_CARD_SECTIONS;

  const cards = [
    {
      pctag: "ASAP",
      emptyLabel: "No very urgent records for this date",
      countEl: elements.priorityCriticalCount,
      subEl: elements.priorityCriticalSub,
      barsEl: elements.priorityCriticalBars,
    },
    {
      pctag: "STAT",
      emptyLabel: "No urgent records for this date",
      countEl: elements.priorityUrgentCount,
      subEl: elements.priorityUrgentSub,
      barsEl: elements.priorityUrgentBars,
    },
    {
      pctag: "ROUTINE",
      emptyLabel: "No normal active records for this date",
      countEl: elements.priorityRoutineCount,
      subEl: elements.priorityRoutineSub,
      barsEl: elements.priorityRoutineBars,
    },
  ];

  cards.forEach(({ pctag, emptyLabel, countEl, subEl, barsEl }) => {
    const priorityRows = rows.filter((row) => row.pctag === pctag && !isCompleted(row));
    const withinRows = priorityRows.filter((row) => !isOverTat(row));
    const withinPct = priorityRows.length
      ? Math.round((withinRows.length / priorityRows.length) * 100)
      : 0;

    if (countEl) countEl.textContent = formatNumber(priorityRows.length);
    if (subEl) {
      subEl.textContent = priorityRows.length
        ? `Within target ${withinPct}%`
        : emptyLabel;
    }
    if (!barsEl) return;

    barsEl.innerHTML = visibleSections.length
      ? visibleSections.map((section) => {
          const sectionRows = priorityRows.filter((row) => row.section === section);
          const sectionWithin = sectionRows.filter((row) => !isOverTat(row)).length;
          const sectionPct = sectionRows.length
            ? Math.round((sectionWithin / sectionRows.length) * 100)
            : 0;
          return `
            <div class="zone-bar-row${sectionRows.length ? "" : " is-empty"}" title="${sectionRows.length ? "" : h(`No ${section} records in this priority group`)}">
              <span class="bar-label">${h(section)}</span>
              <div class="zone-bar-track"><div class="zone-bar-fill" style="width:${sectionPct}%"></div></div>
              <span class="bar-pct">${sectionPct}%</span>
            </div>
          `;
        }).join("")
      : `<div class="empty-state">No section data</div>`;
  });

  elements.priorityCards.forEach((card) => {
    const isActive = card.dataset.priorityFilter === state.priority;
    card.classList.toggle("active", isActive);
    card.setAttribute("aria-pressed", isActive ? "true" : "false");
  });
}

/* ── TAT stats ─────────────────────────────────────────── */
function renderTatStats(rows) {
  const active = rows.filter((r) => !isCompleted(r));
  const tatValues = active.map((r) => r.elapsedTat).filter((v) => v > 0);

  function formatTatDuration(minutes) {
    if (!minutes || !Number.isFinite(minutes)) return "--";

    const totalSeconds = Math.max(0, Math.round(minutes * 60));
    const hours = Math.floor(totalSeconds / 3600);
    const mins = Math.floor((totalSeconds % 3600) / 60);
    const secs = totalSeconds % 60;

    if (hours > 0) {
      return secs > 0
        ? `${hours}h ${mins}m ${secs}s`
        : `${hours}h ${mins}m`;
    }

    if (mins > 0) {
      return secs > 0
        ? `${mins}m ${secs}s`
        : `${mins}m`;
    }

    return `${secs}s`;
  }

  if (!tatValues.length) {
    elements.tatStats.innerHTML = `
      <div class="tat-row"><span>TAT Mean</span><strong>--</strong></div>
      <div class="tat-row"><span>TAT Min</span><strong>--</strong></div>
      <div class="tat-row"><span>TAT Max</span><strong>--</strong></div>
      <div class="tat-row"><span>TAT Median</span><strong>--</strong></div>
    `;
    return;
  }

  const sorted = [...tatValues].sort((a, b) => a - b);
  const mean   = tatValues.reduce((a, b) => a + b, 0) / tatValues.length;
  const min    = sorted[0];
  const max    = sorted[sorted.length - 1];
  const mid    = Math.floor(sorted.length / 2);
  const median = sorted.length % 2 === 0
    ? (sorted[mid - 1] + sorted[mid]) / 2
    : sorted[mid];

  elements.tatStats.innerHTML = `
    <div class="tat-row"><span>TAT Mean</span><strong>${formatTatDuration(mean)}</strong></div>
    <div class="tat-row"><span>TAT Min</span><strong>${formatTatDuration(min)}</strong></div>
    <div class="tat-row"><span>TAT Max</span><strong>${formatTatDuration(max)}</strong></div>
    <div class="tat-row"><span>TAT Median</span><strong>${formatTatDuration(median)}</strong></div>
  `;
}

/* ── Status summary list ───────────────────────────────── */
function renderStatusSummary(rows, stats) {
  const total = stats.total;
  elements.statusTotalLabel.textContent = `Total ${formatNumber(total)}`;

  elements.statusSummaryList.innerHTML = LIS_STATUS_ORDER.map((status) => {
    const count      = rows.filter((r) => r.lisStatus === status).length;
    const pct        = total ? Math.round((count / total) * 100) : 0;
    const fillClass  = STATUS_FILL_CLASS[status] || "ss-fill-request";

    return `
      <div class="status-summary-row">
        <div class="ss-row-head">
          <span class="ss-label">${h(status)}</span>
          <span class="ss-count">${formatNumber(count)}</span>
        </div>
        <div class="ss-track">
          <div class="ss-fill ${h(fillClass)}" style="width:${pct}%"></div>
        </div>
      </div>
    `;
  }).join("");
}

/* ── Workload chart (canvas SVG-style) ─────────────────── */
function normalizeTrendRows(rows = []) {
  return rows.map((row) => {
    const hourMatch = String(row?.hour || "").match(/(\d{1,2})/);
    const hour = hourMatch ? Math.max(0, Math.min(23, Number(hourMatch[1]))) : null;

    return {
      approved: positiveNumber(row?.approved, 0),
      avg: positiveNumber(row?.avg, 0),
      hour,
      onTime: positiveNumber(row?.onTime, 0),
      received: positiveNumber(row?.received, 0),
    };
  }).filter((row) => row.hour !== null);
}

function getHourBucket(value) {
  if (value instanceof Date && !Number.isNaN(value.getTime())) return value.getHours();

  const text = String(value || "").trim();
  const match = text.match(/(\d{1,2}):(\d{2})/);
  if (match) return Math.max(0, Math.min(23, Number(match[1])));

  const parsed = new Date(text);
  return Number.isNaN(parsed.getTime()) ? null : parsed.getHours();
}

function getHourlyChartSeries(rows) {
  const emptySeries = chartHourBuckets.map(() => 0);
  const canUseTrend = state.latestTrendKey === getDashboardQueryKey();
  const fromTrend = state.latestTrend.reduce((series, point) => {
    if (!Number.isInteger(point.hour)) return series;
    if (point.received > 0) series.received[point.hour] = point.received;
    if (point.approved > 0) series.approved[point.hour] = point.approved;
    return series;
  }, { received: [...emptySeries], approved: [...emptySeries] });

  const hasTrendCounts = fromTrend.received.some(Boolean) || fromTrend.approved.some(Boolean);
  if (canUseTrend && hasTrendCounts) return fromTrend;

  return rows.reduce((series, row) => {
    const hour = getHourBucket(row.orderedAt);
    if (hour === null) return series;
    series.received[hour] += 1;
    if (isCompleted(row)) series.approved[hour] += 1;
    return series;
  }, { received: [...emptySeries], approved: [...emptySeries] });
}

let chartAnimFrame = null;
const chartHourBuckets = Array.from({ length: 24 }, (_, i) => i);

function renderWorkloadChart(rows) {
  const canvas = elements.workloadChart;
  if (!canvas) return;
  hideChartTooltip();

  /* Use requestAnimationFrame so canvas dims are settled */
  if (chartAnimFrame) cancelAnimationFrame(chartAnimFrame);
  chartAnimFrame = requestAnimationFrame(function () {
    drawChart(canvas, rows);
    bindWorkloadChartHover(canvas, rows);
  });
}

function refreshWorkloadChartLayout() {
  renderWorkloadChart(getDetailRows(getSummaryRows()));
}

function bindWorkloadChartResize() {
  const chartHost = elements.workloadChart?.parentElement;
  if (!chartHost || typeof ResizeObserver === "undefined") return;

  if (chartResizeObserver) chartResizeObserver.disconnect();

  chartResizeObserver = new ResizeObserver((entries) => {
    const entry = entries[0];
    const width = Math.round(entry?.contentRect?.width || 0);
    if (!width || width === lastChartHostWidth) return;
    lastChartHostWidth = width;
    refreshWorkloadChartLayout();
  });

  lastChartHostWidth = Math.round(chartHost.getBoundingClientRect().width || 0);
  chartResizeObserver.observe(chartHost);
}

function drawChart(canvas, rows) {
  const rect   = canvas.getBoundingClientRect();
  const W      = Math.max(320, Math.round(rect.width || canvas.parentElement?.clientWidth || 600));
  const cssH   = Number.parseFloat(window.getComputedStyle(canvas).height);
  const H      = Math.round((Number.isFinite(cssH) && cssH > 0 ? cssH : rect.height) || WORKLOAD_CHART_FALLBACK_HEIGHT);
  const seriesData = getHourlyChartSeries(rows);
  const received = seriesData.received;
  const approved = seriesData.approved;

  const maxVal = Math.max(1, ...received, ...approved);
  const padL = 36, padR = 14, padT = 14, padB = 28;
  const cW = W - padL - padR;
  const cH = H - padT - padB;
  const activeIndex = Number.isInteger(canvas.__chartActiveIndex) ? canvas.__chartActiveIndex : null;
  const currentHour = new Date().getHours();

  function xPos(i) { return padL + (i / (chartHourBuckets.length - 1)) * cW; }
  function yPos(v) { return padT + cH - (v / maxVal) * cH; }

  function smoothLinePath(data) {
    let path = `M ${xPos(0).toFixed(2)} ${yPos(data[0]).toFixed(2)}`;
    for (let i = 1; i < data.length; i++) {
      const xc = (xPos(i - 1) + xPos(i)) / 2;
      path += ` C ${xc.toFixed(2)} ${yPos(data[i - 1]).toFixed(2)}, ${xc.toFixed(2)} ${yPos(data[i]).toFixed(2)}, ${xPos(i).toFixed(2)} ${yPos(data[i]).toFixed(2)}`;
    }
    return path;
  }

  function smoothAreaPath(data) {
    const baseline = (padT + cH).toFixed(2);
    return `${smoothLinePath(data)} L ${xPos(data.length - 1).toFixed(2)} ${baseline} L ${xPos(0).toFixed(2)} ${baseline} Z`;
  }

  const gridLevels = [0.25, 0.5, 0.75, 1];
  const gridLines = gridLevels.map((f) => {
    const y = (padT + cH * (1 - f)).toFixed(2);
    const labelVal = Math.round(maxVal * f);
    return `
      <line x1="${padL}" y1="${y}" x2="${(W - padR).toFixed(2)}" y2="${y}" stroke="rgba(255,255,255,0.06)" stroke-width="1" />
      <text x="${(padL - 5).toFixed(2)}" y="${(Number(y) + 3.5).toFixed(2)}" fill="rgba(107,135,166,0.75)" font-family="Cascadia Mono, SFMono-Regular, Consolas, monospace" font-size="9" text-anchor="end">${labelVal}</text>
    `;
  }).join("");

  const hourLabels = [0, 4, 8, 12, 16, 20, 23].map((h) => `
    <text x="${xPos(h).toFixed(2)}" y="${(H - padB + 13).toFixed(2)}" fill="rgba(107,135,166,0.9)" font-family="Cascadia Mono, SFMono-Regular, Consolas, monospace" font-size="9" text-anchor="middle">${h}</text>
  `).join("");

  /* Current-hour "now" marker */
  const nowX = xPos(currentHour).toFixed(2);
  const nowMarker = `
    <line x1="${nowX}" y1="${padT}" x2="${nowX}" y2="${(padT + cH).toFixed(2)}" stroke="rgba(0,229,255,0.28)" stroke-width="1.5" stroke-dasharray="3 3"></line>
    <text x="${nowX}" y="${(padT - 3).toFixed(2)}" fill="rgba(0,229,255,0.7)" font-family="Cascadia Mono, SFMono-Regular, Consolas, monospace" font-size="8" text-anchor="middle">NOW</text>
  `;

  const hoverMarkup = activeIndex !== null ? `
    <line x1="${xPos(activeIndex).toFixed(2)}" y1="${padT}" x2="${xPos(activeIndex).toFixed(2)}" y2="${(padT + cH).toFixed(2)}" stroke="rgba(240,247,255,0.16)" stroke-width="1" stroke-dasharray="4 3"></line>
    <circle cx="${xPos(activeIndex).toFixed(2)}" cy="${yPos(received[activeIndex]).toFixed(2)}" r="4" fill="#0b0f1a" stroke="rgba(255,61,61,1)" stroke-width="2"></circle>
    <circle cx="${xPos(activeIndex).toFixed(2)}" cy="${yPos(approved[activeIndex]).toFixed(2)}" r="4" fill="#0b0f1a" stroke="rgba(79,195,247,1)" stroke-width="2"></circle>
  ` : "";

  const uid = canvas.id || "wc";

  canvas.setAttribute("viewBox", `0 0 ${W} ${H}`);
  canvas.setAttribute("preserveAspectRatio", "none");
  canvas.__chartSeries = {
    received,
    approved,
    width: W,
    height: H,
    padL,
    padR,
    padT,
    padB,
    chartWidth: cW,
  };
  canvas.innerHTML = `
    <defs>
      <linearGradient id="${uid}-grad-recv" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="rgba(255,61,61,0.30)"/>
        <stop offset="100%" stop-color="rgba(255,61,61,0.01)"/>
      </linearGradient>
      <linearGradient id="${uid}-grad-appr" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="rgba(79,195,247,0.24)"/>
        <stop offset="100%" stop-color="rgba(79,195,247,0.01)"/>
      </linearGradient>
    </defs>
    <g aria-hidden="true">
      ${gridLines}
      ${nowMarker}
      <path d="${smoothAreaPath(received)}" fill="url(#${uid}-grad-recv)"></path>
      <path d="${smoothAreaPath(approved)}" fill="url(#${uid}-grad-appr)"></path>
      <path d="${smoothLinePath(received)}" fill="none" stroke="rgba(255,61,61,0.92)" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"></path>
      <path d="${smoothLinePath(approved)}" fill="none" stroke="rgba(79,195,247,0.92)" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"></path>
      ${hoverMarkup}
      ${hourLabels}
    </g>
  `;
}

function bindWorkloadChartHover(canvas, rows) {
  if (!canvas || canvas.__chartHoverBound) return;
  canvas.__chartHoverBound = true;

  canvas.addEventListener("mousemove", (event) => {
    const rect = canvas.getBoundingClientRect();
    const series = canvas.__chartSeries;
    if (!series || !rect.width) return;

    const rawX = event.clientX - rect.left;
    const relativeX = Math.min(series.chartWidth, Math.max(0, rawX - series.padL));
    const activeIndex = Math.round((relativeX / Math.max(1, series.chartWidth)) * (chartHourBuckets.length - 1));

    if (canvas.__chartActiveIndex !== activeIndex) {
      canvas.__chartActiveIndex = activeIndex;
      drawChart(canvas, getDetailRows(getSummaryRows()));
    }

    updateChartTooltip(event, canvas, activeIndex);
  });

  canvas.addEventListener("mouseleave", () => {
    canvas.__chartActiveIndex = null;
    hideChartTooltip();
    drawChart(canvas, getDetailRows(getSummaryRows()));
  });
}

function updateChartTooltip(event, canvas, activeIndex) {
  const tooltip = elements.chartTooltip;
  const panel = canvas.parentElement;
  const series = canvas.__chartSeries;
  if (!tooltip || !panel || !series) return;

  const hour = String(chartHourBuckets[activeIndex]).padStart(2, "0");
  const receivedValue = series.received[activeIndex] || 0;
  const approvedValue = series.approved[activeIndex] || 0;

  tooltip.hidden = false;
  tooltip.innerHTML = `
    <div class="chart-tooltip-time">${h(hour)}:00</div>
    <div class="chart-tooltip-row">
      <span class="chart-tooltip-dot received"></span>
      <span>Received</span>
      <span class="chart-tooltip-value">${formatNumber(receivedValue)}</span>
    </div>
    <div class="chart-tooltip-row">
      <span class="chart-tooltip-dot approved"></span>
      <span>Approved</span>
      <span class="chart-tooltip-value">${formatNumber(approvedValue)}</span>
    </div>
  `;

  const panelRect = panel.getBoundingClientRect();
  const desiredLeft = event.clientX - panelRect.left + 14;
  const desiredTop = event.clientY - panelRect.top - 18;
  const maxLeft = Math.max(10, panel.clientWidth - tooltip.offsetWidth - 10);
  const maxTop = Math.max(10, panel.clientHeight - tooltip.offsetHeight - 10);

  tooltip.style.left = `${Math.min(maxLeft, Math.max(10, desiredLeft))}px`;
  tooltip.style.top = `${Math.min(maxTop, Math.max(52, desiredTop))}px`;
}

function hideChartTooltip() {
  if (!elements.chartTooltip) return;
  elements.chartTooltip.hidden = true;
}

/* ── Alert panels (Bottom zone — Photo 1 style) ─────────── */
function renderAlertPanels(rows, stats) {
  /* Urgent: ASAP not completed */
  const asapRows    = rows.filter((r) => r.pctag === "ASAP" && !isCompleted(r));
  const statRows    = rows.filter((r) => r.pctag === "STAT" && !isCompleted(r));
  /* Critical Warning: over TAT */
  const critRows    = rows.filter(isOverTat);
  /* Warning Time: in warning zone (82-100% of target) */
  const warnRows    = rows.filter(isWarningTat);
  /* Over TAT same as critical for the right panel */
  const overRows    = rows.filter(isOverTat);

  elements.urgentAsapBadge.textContent   = formatNumber(asapRows.length);
  elements.urgentStatBadge.textContent   = formatNumber(statRows.length);
  elements.criticalBadge.textContent     = formatNumber(critRows.length);
  elements.warnTimeBadge.textContent     = formatNumber(warnRows.length);
  elements.overWarrantyBadge.textContent = formatNumber(overRows.length);

  const sections = getAlertSections(rows, [...asapRows, ...statRows, ...critRows, ...warnRows]);
  renderAlertSectionLabels(elements.urgentSectionRow, sections);
  renderAlertSectionLabels(elements.criticalSectionRow, sections);
  renderAlertSectionLabels(elements.warnTimeSectionRow, sections);

  const urgentRows = sortByRisk([...asapRows, ...statRows]);
  renderAlertColumnBoard(urgentRows, elements.urgentChips, sections, { showPctag: true });
  renderAlertColumnBoard(critRows, elements.criticalChips, sections);
  renderAlertColumnBoard(warnRows, elements.warnTimeChips, sections);
  renderOverTatBoard(overRows, elements.overWarrantyChips);
}

function getAlertSections(allRows, preferredRows = [], max = 3) {
  const preferredOrder = ["ICH", "HEM", "MIC", "CHEM", "IMM", "MOL", "SER"];
  const sourceRows = preferredRows.length ? preferredRows : allRows;
  const rankedSections = Object.entries(groupRows(sourceRows, (row) => row.section))
    .map(([section, group]) => ({
      section,
      count: group.length,
      preferredIndex: preferredOrder.indexOf(String(section).toUpperCase()),
    }))
    .sort((a, b) => (
      (a.preferredIndex === -1 ? 999 : a.preferredIndex) - (b.preferredIndex === -1 ? 999 : b.preferredIndex)
      || b.count - a.count
      || a.section.localeCompare(b.section)
    ))
    .map((item) => item.section)
    .slice(0, max);

  return rankedSections.length
    ? rankedSections
    : [...new Set(allRows.map((row) => row.section))].slice(0, max);
}

function renderAlertSectionLabels(el, sections) {
  el.innerHTML = sections.map((section) => `<span class="alert-section-label">${h(section)}</span>`).join("");
}

function renderAlertColumnBoard(targetRows, el, sections, options = {}) {
  const { showPctag = false, maxPerSection = 6 } = options;
  const sorted = sortByRisk(targetRows);
  if (!sorted.length) {
    el.innerHTML = `<div class="empty-state" style="min-height:60px;font-size:0.68rem">None</div>`;
    return;
  }

  el.innerHTML = `
    <div class="alert-sample-grid">
      ${sections.map((section) => {
        const sectionRows = sorted.filter((row) => row.section === section).slice(0, maxPerSection);
        return `
          <div class="alert-section-col">
            <div class="alert-section-list">
              ${sectionRows.length
                ? sectionRows.map((row) => alertEntry(row, { showPctag })).join("")
                : `<div class="alert-entry alert-entry-empty"><span class="alert-entry-text">-</span></div>`}
            </div>
          </div>
        `;
      }).join("")}
    </div>
  `;
}

function renderOverTatBoard(rows, el) {
  const sorted = sortByRisk(rows);
  if (!sorted.length) {
    el.innerHTML = `<div class="empty-state" style="min-height:60px;font-size:0.68rem">None</div>`;
    return;
  }

  const primary = sorted[0];
  const secondary = sorted.slice(1, 5);
  const overBy = Math.max(0, primary.elapsedTat - primary.targetTat);

  el.innerHTML = `
    <div class="over-focus ${h(getStatusClass(primary))}">
      <div class="over-focus-label">Highest delay</div>
      <div class="over-focus-sample">${h(primary.sampleNo)}</div>
      <div class="over-focus-meta">${h(primary.section)} · ${h(primary.pctag)} · ${minutesLabel(overBy)} over</div>
    </div>
    ${secondary.length ? `
      <div class="over-mini-list">
        ${secondary.map((row) => `
          <div class="over-mini-item ${h(getStatusClass(row))}">
            <span>${h(row.sampleNo)}</span>
            <strong>${h(row.section)}</strong>
          </div>
        `).join("")}
      </div>
    ` : ""}
  `;
}

function alertEntry(row, options = {}) {
  const { showPctag = false } = options;
  const statusClass = getStatusClass(row);
  const tatStatus = getTatStatus(row);
  const riskClass = tatStatus === "over" ? "over" : tatStatus === "warning" ? "warning" : "";
  const marker = tatStatus === "over" ? "!" : tatStatus === "warning" ? "~" : "";
  const title = `${row.sampleNo} | ${row.requestNo} | ${row.hn} | ${row.section} | ${row.test} | ${row.lisStatus} | ${row.pctag} | ${minutesLabel(row.elapsedTat)} / ${minutesLabel(row.targetTat)}`;

  return `
    <div class="alert-entry ${h(statusClass)} ${h(riskClass)}" title="${h(title)}">
      <span class="alert-entry-dot"></span>
      <span class="alert-entry-text">${h(row.sampleNo)}</span>
      ${showPctag ? `<span class="alert-entry-tag">${h(row.pctag)}</span>` : ""}
      ${marker ? `<span class="alert-entry-mark">${marker}</span>` : ""}
    </div>
  `;
}

/* ══════════════════════════════════════════════════════════
   RENDER — DASHBOARD 2  (unchanged logic)
══════════════════════════════════════════════════════════ */
function renderActionBoards(rows) {
  const requestEntries   = getRequestBoardEntries(rows);
  const pendingEntries   = requestEntries.filter((entry) => !entry.allCompleted);
  const completedEntries = requestEntries.filter((entry) => entry.allCompleted);
  const overEntries      = pendingEntries.filter((entry) => entry.tatState === "over");
  const warningEntries   = pendingEntries.filter((entry) => entry.tatState === "warning");

  elements.actionBoardTotal.textContent    = `${formatNumber(warningEntries.length + overEntries.length)} action groups`;
  elements.pendingTotal.textContent        = formatNumber(pendingEntries.length);
  elements.overSummaryTotal.textContent    = formatNumber(overEntries.length);
  elements.warningSummaryTotal.textContent = formatNumber(warningEntries.length);
  elements.completedTotal.textContent      = formatNumber(completedEntries.length);
  elements.warningTotal.textContent        = `${formatNumber(warningEntries.length)} groups`;
  elements.overTotal.textContent           = `${formatNumber(overEntries.length)} groups`;

  elements.warningList.innerHTML = warningEntries.length
    ? warningEntries.map((entry) => actionRowTemplate(entry, "warning")).join("")
    : `<div class="empty-state">No Warning Request / HN groups in the current view.</div>`;

  elements.overList.innerHTML = overEntries.length
    ? overEntries.map((entry) => actionRowTemplate(entry, "over")).join("")
    : `<div class="empty-state">No Over TAT Request / HN groups in the current view.</div>`;
}

function actionRowTemplate(entry, type) {
  const timing = minutesLabel(entry.elapsedTat);
  const sectionChips = entry.sections.map((section) => `
    <span class="section-chip ${h(section.status.className)}" title="${h(`${section.section} · ${section.status.label} · ${formatNumber(section.count)} sample(s)`)}">
      <span class="section-chip-label">${h(section.section)}</span>
      <span class="section-chip-count">${formatNumber(section.count)}</span>
    </span>
  `).join("");

  return `
    <article class="action-row ${type === "over" ? "over" : entry.allCompleted ? "completed" : ""}">
      <div class="action-main">
        <strong title="${h(entry.requestNo)}">${h(entry.requestNo)}</strong>
        <small>HN ${h(entry.hn)}</small>
      </div>
      <div class="action-detail" title="${h(entry.patient)}">
        <strong>${h(entry.patient)}</strong>
      </div>
      <div class="action-count">
        <strong>${formatNumber(entry.sampleCount)}</strong>
      </div>
      <div class="action-sections">
        ${sectionChips}
      </div>
      <div class="action-status">
        <span class="status-pill ${h(entry.currentStatus.className)}" title="${h(entry.currentStatus.label)}">
          <span class="status-pill-label">${h(entry.currentStatus.label)}</span>
        </span>
      </div>
      <div class="action-tat">
        <strong>${h(timing)}</strong>
      </div>
    </article>
  `;
}

function renderSectionStatusStrip(rows) {
  if (!elements.sectionStatusStrip || !elements.sectionStatusTotal) return;
  const sections = Object.entries(groupRows(rows, (row) => row.section))
    .map(([section, group]) => ({
      section,
      status: getDominantLisStatus(group),
      ...getStats(group),
    }))
    .sort((a, b) => (
      b.over - a.over || b.warning - a.warning || b.total - a.total || a.section.localeCompare(b.section)
    ));
  elements.sectionStatusTotal.textContent = `${formatNumber(sections.length)} sections`;

  if (!sections.length) {
    elements.sectionStatusStrip.innerHTML = `<div class="empty-state">No section status to display.</div>`;
    return;
  }

  elements.sectionStatusStrip.innerHTML = sections.map((section) => `
    <article class="section-status-card ${h(section.status.borderClass)}">
      <strong>${h(section.section)}</strong>
      <small>
        ${formatNumber(section.total)} total ·
        ${formatNumber(section.warning)} warning ·
        ${formatNumber(section.over)} over ·
        ${formatNumber(section.completed)} done
      </small>
      <span class="status-pill ${h(section.status.className)}">${h(section.status.label)}</span>
    </article>
  `).join("");
}

/* ══════════════════════════════════════════════════════════
   LIVE DATA
══════════════════════════════════════════════════════════ */
async function loadDashboard(options = {}) {
  if (state.dashboardLoading) return;

  const params = new URLSearchParams();
  if (state.account  && state.account  !== "all") params.set("account",  state.account);
  if (state.section  && state.section  !== "all") params.set("section",  state.section);
  if (state.priority && state.priority !== "all") params.set("priority", state.priority);
  if (state.search.trim())                         params.set("search",   state.search.trim());
  if (state.date)                                  params.set("date",     state.date);

  try {
    setDashboardLoading(true);
    const url      = `/api/dashboard${params.toString() ? `?${params.toString()}` : ""}`;
    const response = await fetch(url, { headers: { Accept: "application/json" } });
    if (!response.ok) {
      throw new Error(await readDashboardError(response));
    }
    const data = await response.json();
    const rows = extractRowsFromDashboardResponse(data).map(normalizeRow);
    state.allRows      = rows;
    state.date         = data?.filters?.date?.selected || data?.date?.selected || state.date;
    state.lastUpdatedAt = data?.lastUpdatedAt || data?.meta?.generatedAt || new Date().toISOString();
    state.latestError  = "";
    state.latestSource = "api";
    state.latestTrendKey = getDashboardQueryKey();
    state.latestTrend  = extractTrendFromDashboardResponse(data);
    render();
  } catch (error) {
    console.error("Live dashboard load failed:", error);
    state.allRows      = [];
    state.lastUpdatedAt = new Date().toISOString();
    state.latestError  = summarizeDashboardError(error);
    state.latestSource = "offline";
    state.latestTrendKey = "";
    state.latestTrend  = [];
    render();
  } finally {
    setDashboardLoading(false);
    if (options.source !== "auto") startAutoRefreshLoop();
  }
}

function extractRowsFromDashboardResponse(data) {
  if (Array.isArray(data))           return data;
  if (Array.isArray(data?.rows))     return data.rows;
  if (Array.isArray(data?.cases))    return data.cases;
  if (Array.isArray(data?.samples))  return data.samples;
  if (Array.isArray(data?.requests)) return data.requests;
  if (Array.isArray(data?.data))     return data.data;
  return [];
}

function extractTrendFromDashboardResponse(data) {
  return normalizeTrendRows(Array.isArray(data?.trend) ? data.trend : []);
}

async function readDashboardError(response) {
  try {
    const payload = await response.json();

    if (payload?.code === "ER_GET_CONNECTION_TIMEOUT") {
      return "MariaDB unreachable";
    }

    if (payload?.message) {
      return String(payload.message).trim();
    }
  } catch {}

  return `HTTP ${response.status}`;
}

function summarizeDashboardError(error) {
  const message = String(error?.message || "").trim();

  if (!message) {
    return "Dashboard error";
  }

  if (
    message.includes("ER_GET_CONNECTION_TIMEOUT") ||
    message.includes("MariaDB unreachable")
  ) {
    return "MariaDB unreachable";
  }

  if (message.includes("Failed to fetch")) {
    return "Dashboard API unreachable";
  }

  return message;
}

function getDashboardQueryKey() {
  return JSON.stringify({
    account: state.account || "all",
    date: state.date || "",
    priority: state.priority || "all",
    search: state.search.trim(),
    section: state.section || "all",
  });
}

function setDashboardLoading(isLoading) {
  state.dashboardLoading = isLoading;
  elements.refreshBtn.disabled = isLoading;
  elements.refreshBtn.classList.toggle("loading", isLoading);
  updateLiveBadge();
}

/* ══════════════════════════════════════════════════════════
   CLOCK / BADGE / TIMER
══════════════════════════════════════════════════════════ */
function updateLastUpdatedLabel(value) {
  const date   = value instanceof Date ? value : new Date(value);
  const source = state.latestError
    ? `DB ERROR: ${state.latestError}`
    : state.latestSource === "api"
      ? "LIVE"
      : "NO LIVE DATA";
  elements.lastUpdated.textContent = `Updated: ${formatClockValue(date)} | ${source}`;
}

function updateClock() {
  elements.liveClock.textContent = formatClockValue();
}

function updateLiveBadge() {
  if (state.dashboardLoading) {
    elements.liveBadge.textContent = "Refreshing…";
    return;
  }
  const nextDataSeconds = nextAutoRefreshAt
    ? Math.max(0, Math.ceil((nextAutoRefreshAt - Date.now()) / 1000))
    : Math.round(AUTO_REFRESH_MS / 1000);
  const dataText = state.latestError
    ? (AUTO_REFRESH_ENABLED ? `DB retry ${nextDataSeconds}s` : "DB offline")
    : AUTO_REFRESH_ENABLED
      ? `Data ${nextDataSeconds}s`
      : "Data paused";

  let viewText = "";
  if (state.viewMode === "auto") {
    if (!VIEW_ROTATION_ENABLED || isViewRotationPaused) {
      viewText = "View paused";
    } else {
      const viewSeconds = nextViewRotationAt
        ? Math.max(0, Math.ceil((nextViewRotationAt - Date.now()) / 1000))
        : Math.round(VIEW_ROTATION_MS / 1000);
      viewText = `View ${viewSeconds}s`;
    }
  } else if (state.viewMode === "sample") {
    viewText = "Sample only";
  } else if (state.viewMode === "request") {
    viewText = "Request only";
  }

  elements.liveBadge.textContent = `${dataText} | ${viewText}`;
}

function updateTick() {
  updateClock();
  updateLiveBadge();
}

function startAutoRefreshLoop() {
  if (!AUTO_REFRESH_ENABLED) {
    nextAutoRefreshAt = 0;
    if (autoRefreshIntervalId) clearInterval(autoRefreshIntervalId);
    autoRefreshIntervalId = null;
    updateLiveBadge();
    return;
  }
  nextAutoRefreshAt = Date.now() + AUTO_REFRESH_MS;
  updateLiveBadge();
  if (autoRefreshIntervalId) clearInterval(autoRefreshIntervalId);
  autoRefreshIntervalId = setInterval(() => {
    nextAutoRefreshAt = Date.now() + AUTO_REFRESH_MS;
    loadDashboard({ source: "auto" });
  }, AUTO_REFRESH_MS);
}

/* ══════════════════════════════════════════════════════════
   VIEW ROTATION
══════════════════════════════════════════════════════════ */
function showDashboardPage(page) {
  const pageNumber = page === 2 ? 2 : 1;
  document.body.dataset.dashboardPage = String(pageNumber);
  elements.billboardControls.forEach((button) => {
    const active = Number(button.dataset.billboardTarget) === pageNumber;
    button.classList.toggle("active", active);
    button.setAttribute("aria-pressed", String(active));
  });
  try { window.localStorage.setItem(DASHBOARD_PAGE_STORAGE_KEY, String(pageNumber)); } catch {}
}

function rotateDashboardPage() {
  if (state.viewMode !== "auto" || isViewRotationPaused) return;
  const current = Number(document.body.dataset.dashboardPage || 1);
  showDashboardPage(current === 1 ? 2 : 1);
  nextViewRotationAt = Date.now() + VIEW_ROTATION_MS;
  updateLiveBadge();
}

function startViewRotationLoop() {
  stopViewRotationLoop();
  if (!VIEW_ROTATION_ENABLED) {
    isViewRotationPaused = true;
    nextViewRotationAt = 0;
    updateLiveBadge();
    return;
  }
  if (state.viewMode !== "auto" || isViewRotationPaused) { nextViewRotationAt = 0; updateLiveBadge(); return; }
  nextViewRotationAt = Date.now() + VIEW_ROTATION_MS;
  updateLiveBadge();
  viewRotationIntervalId = setInterval(rotateDashboardPage, VIEW_ROTATION_MS);
}

function stopViewRotationLoop() {
  if (viewRotationIntervalId) { clearInterval(viewRotationIntervalId); viewRotationIntervalId = null; }
}

function clearViewIdleResumeTimer() {
  if (viewIdleResumeTimeoutId) { clearTimeout(viewIdleResumeTimeoutId); viewIdleResumeTimeoutId = null; }
}

function pauseViewRotation() {
  if (state.viewMode !== "auto" || isViewRotationPaused) return;
  isViewRotationPaused = true;
  stopViewRotationLoop();
  nextViewRotationAt = 0;
  updateLiveBadge();
}

function resumeViewRotation() {
  if (state.viewMode !== "auto" || !isViewRotationPaused) return;
  isViewRotationPaused = false;
  startViewRotationLoop();
}

function handleDashboardPointerActivity() {
  if (state.viewMode !== "auto") return;
  isPointerInsideDashboard = true;
  pauseViewRotation();
  clearViewIdleResumeTimer();
  viewIdleResumeTimeoutId = setTimeout(() => {
    if (!isPointerInsideDashboard) return;
    isViewRotationPaused = false;
    startViewRotationLoop();
    updateLiveBadge();
  }, VIEW_IDLE_RESUME_MS);
}

function handleDashboardPointerLeave() {
  if (state.viewMode !== "auto") return;
  isPointerInsideDashboard = false;
  clearViewIdleResumeTimer();
  resumeViewRotation();
}

function resetViewRotationTimer() {
  if (state.viewMode !== "auto" || isViewRotationPaused) return;
  startViewRotationLoop();
}

/* ══════════════════════════════════════════════════════════
   EVENTS
══════════════════════════════════════════════════════════ */
function bindEvents() {
  elements.accountFilter.addEventListener("change", (event) => {
    state.account = event.target.value;
    state.section = "all";
    render();
  });

  if (elements.priorityFilter) {
    elements.priorityFilter.addEventListener("change", (event) => {
      state.priority = event.target.value;
      render();
    });
  }

  elements.searchInput.addEventListener("input", (event) => {
    state.search = event.target.value;
    clearTimeout(searchTimeoutId);
    searchTimeoutId = setTimeout(render, 160);
  });

  elements.dateFilter.addEventListener("change", (event) => {
    state.date = event.target.value;
    loadDashboard();
  });

  elements.refreshBtn.addEventListener("click", () => { loadDashboard(); });

  elements.sectionTabs.addEventListener("click", (event) => {
    const button = event.target.closest("[data-section]");
    if (!button) return;
    state.section = button.dataset.section || "all";
    render();
  });

  elements.priorityCards.forEach((card) => {
    const togglePriorityFocus = () => {
      const value = card.dataset.priorityFilter || "all";
      state.priority = state.priority === value ? "all" : value;
      render();
    };

    card.addEventListener("click", togglePriorityFocus);
    card.addEventListener("keydown", (event) => {
      if (event.key !== "Enter" && event.key !== " ") return;
      event.preventDefault();
      togglePriorityFocus();
    });
  });

  elements.billboardControls.forEach((button) => {
    button.addEventListener("click", () => {
      showDashboardPage(Number(button.dataset.billboardTarget));
      resetViewRotationTimer();
      if (Number(button.dataset.billboardTarget) === 1) refreshWorkloadChartLayout();
    });
  });

  if (elements.dashboardScreen) {
    elements.dashboardScreen.addEventListener("pointerenter", handleDashboardPointerActivity);
    elements.dashboardScreen.addEventListener("pointermove",  handleDashboardPointerActivity);
    elements.dashboardScreen.addEventListener("pointerleave", handleDashboardPointerLeave);
  }

  /* Redraw chart on resize */
  window.addEventListener("resize", () => {
    refreshWorkloadChartLayout();
  });
}

/* ══════════════════════════════════════════════════════════
   FORMAT HELPERS
══════════════════════════════════════════════════════════ */
function minutesLabel(value) {
  const minutes = Math.round(Number(value || 0));
  if (minutes < 60) return `${minutes} min`;
  const hours = Math.floor(minutes / 60);
  const rest  = minutes % 60;
  return rest ? `${hours}h ${rest}m` : `${hours}h`;
}

function formatNumber(value) {
  return new Intl.NumberFormat("en-US").format(Number(value || 0));
}

function formatPct(count, total, decimals = 0) {
  if (!total) return decimals ? "0.0%" : "0%";
  return `${((count / total) * 100).toFixed(decimals)}%`;
}

function formatDateInputValue(value = new Date()) {
  const date  = value instanceof Date ? value : new Date(value);
  const year  = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day   = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function formatClockValue(value = new Date()) {
  return new Intl.DateTimeFormat("en-US", {
    hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: false,
  }).format(value instanceof Date ? value : new Date(value));
}

function h(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function getInitialViewMode() {
  try {
    const params = new URLSearchParams(window.location.search);
    const view   = String(params.get("view") || "").trim().toLowerCase();
    if (view === "sample")  return "sample";
    if (view === "request") return "request";
    if (view === "auto")    return "auto";
  } catch {}
  return "auto";
}

function getInitialDashboardPage() {
  if (state.viewMode === "sample")  return 1;
  if (state.viewMode === "request") return 2;
  try { return window.localStorage.getItem(DASHBOARD_PAGE_STORAGE_KEY) === "2" ? 2 : 1; } catch { return 1; }
}

/* ══════════════════════════════════════════════════════════
   INIT
══════════════════════════════════════════════════════════ */
function init() {
  bindEvents();
  bindWorkloadChartResize();
  showDashboardPage(getInitialDashboardPage());
  render();
  updateTick();
  startAutoRefreshLoop();
  startViewRotationLoop();

  if (tickIntervalId) clearInterval(tickIntervalId);
  tickIntervalId = setInterval(updateTick, 1000);
  loadDashboard({ source: "init" });
}

init();
