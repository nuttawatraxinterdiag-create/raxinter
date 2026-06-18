/* ══════════════════════════════════════════════════════════
   CONFIG
══════════════════════════════════════════════════════════ */
const AUTO_REFRESH_MS            = 30000;
const VIEW_ROTATION_MS           = 12000;
const VIEW_IDLE_RESUME_MS        = 5000;
const WARNING_RATIO              = 0.82;
const DASHBOARD_PAGE_STORAGE_KEY = "pwl-lis-active-page";
const WORKLOAD_CHART_FALLBACK_HEIGHT = 300;

const LIS_STATUS_ORDER = [
  "Request",
  "Analyzing",
  "Result sent",
  "Report",
  "Approve",
  "Completed",
];

const PCTAG_DEFINITIONS = [
  { value: "ASAP",    label: "ASAP",    target: 15 },
  { value: "STAT",    label: "STAT",    target: 30 },
  { value: "ROUTINE", label: "Routine", target: 90 },
];

const STATUS_CLASS = {
  Request:        "status-request",
  Received:       "status-request",
  Pending:        "status-request",
  Analyzing:      "status-analyzing",
  Processing:     "status-analyzing",
  "Result sent":  "status-result-sent",
  Resulted:       "status-result-sent",
  Report:         "status-report",
  Review:         "status-report",
  "Awaiting report": "status-report",
  Approve:        "status-approve",
  Approved:       "status-approve",
  Completed:      "status-completed",
};

/* Map status → CSS class for ss-bar-fill */
const STATUS_FILL_CLASS = {
  Request:        "ss-fill-request",
  Analyzing:      "ss-fill-analyzing",
  "Result sent":  "ss-fill-result-sent",
  Report:         "ss-fill-report",
  Approve:        "ss-fill-approve",
  Completed:      "ss-fill-completed",
};

/* ══════════════════════════════════════════════════════════
   SAMPLE DATA  (mock — replaced by live API)
══════════════════════════════════════════════════════════ */
const SAMPLE_ROWS = [
  ["PWL","1300312125","LN-240616-001","HN-102844","Anan W.",      "HEM","CBC",           "STAT",    "Analyzing",   "Analyzing",   27, 30, "Alinity i"],
  ["PWL","1300312126","LN-240616-002","HN-103512","Kanya S.",     "ICH","Troponin I",    "ASAP",    "Analyzing",   "Analyzing",   14, 15, "Cobas 6000_1"],
  ["PWL","1300312127","LN-240616-003","HN-104179","Arisa M.",     "MIC","Blood culture", "ROUTINE", "Analyzing",   "Analyzing",   78, 90, "BD FACSlyric"],
  ["PWL","1300312128","LN-240616-004","HN-105612","Ploy R.",      "ICH","HbA1c",         "ROUTINE", "Request",     "Request",     18, 90, "BioRad D100"],
  ["PWL","1300312129","LN-240616-005","HN-105711","Narin C.",     "MOL","HIV Viral Load","STAT",    "Result sent", "Result sent", 33, 30, "Cobas c6800"],
  ["PWL","1300312130","LN-240616-006","HN-106003","Nicha P.",     "HEM","PT / INR",      "STAT",    "Report",      "Report",      29, 30, "ACL TOP"],
  ["PWL","1300312131","LN-240616-007","HN-106185","Suda K.",      "IMM","HBsAg",         "ROUTINE", "Completed",   "Approve",     42, 90, "Alinity i"],
  ["PWL","1300312132","LN-240616-008","HN-106422","Mali K.",      "HEM","Blood film",    "ASAP",    "Report",      "Report",      13, 15, "Manual"],
  ["PWL","1300312133","LN-240616-009","HN-106511","Tanet R.",     "MIC","Gram stain",    "STAT",    "Result sent", "Result sent", 34, 30, "Manual"],
  ["PWL","1300312134","LN-240616-010","HN-106777","Wichai L.",    "ICH","Electrolyte",   "STAT",    "Completed",   "Approve",     21, 30, "Cobas 6000_2"],
  ["PWL","1300312135","LN-240616-011","HN-107002","Benya C.",     "IMM","CRP",           "STAT",    "Analyzing",   "Analyzing",   25, 30, "Alinity i"],
  ["PWL","1300312136","LN-240616-012","HN-107118","Prasert N.",   "MOL","COVID PCR",     "ROUTINE", "Request",     "Request",      9, 90, "Cobas c6800"],
  ["PWL","1300312137","LN-240616-013","HN-107322","Jira S.",      "HEM","ESR",           "ROUTINE", "Completed",   "Approve",     54, 90, "Manual"],
  ["PWL","1300312138","LN-240616-014","HN-107490","Pim A.",       "ICH","Glucose",       "ROUTINE", "Report",      "Report",      96, 90, "Cobas 6000_1"],
  ["PWL","1300312139","LN-240616-015","HN-107703","Supaporn T.",  "MIC","Urine culture", "ROUTINE", "Analyzing",   "Analyzing",   66, 90, "BD FACSlyric"],
  ["PWL","1300312140","LN-240616-016","HN-108033","Santi M.",     "SER","Dengue NS1",    "STAT",    "Result sent", "Result sent", 28, 30, "LabXpert EH-209"],
  ["PWL","1300312141","LN-240616-017","HN-108407","Rada W.",      "SER","VDRL",          "ROUTINE", "Completed",   "Approve",     49, 90, "LabXpert EH-209"],
  ["PWL","1300312142","LN-240616-018","HN-108735","Thana B.",     "MOL","HBV Viral Load","ROUTINE", "Analyzing",   "Analyzing",  102, 90, "Cobas c6800"],
  ["Alliance","2300311101","LN-240616-101","HN-201144","Alliance A.","HEM","CBC",        "STAT",    "Analyzing",   "Analyzing",   22, 30, "Alinity i"],
  ["Corporate","3300311102","LN-240616-201","HN-301144","Corporate B.","ICH","Troponin I","ASAP",   "Report",      "Report",      18, 15, "Cobas 6000_1"],
].map(arrayRowToObject).map(normalizeRow);

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
  account:         "PWL",
  allRows:         SAMPLE_ROWS,
  date:            formatDateInputValue(),
  dashboardLoading: false,
  latestSource:    "sample",
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
  dashboardScreen:    document.querySelector(".dashboard-screen"),
  dateFilter:         document.querySelector("#dateFilter"),
  lastUpdated:        document.querySelector("#lastUpdated"),
  liveBadge:          document.querySelector("#liveBadge"),
  liveClock:          document.querySelector("#liveClock"),
  overList:           document.querySelector("#overList"),
  overTotal:          document.querySelector("#overTotal"),
  priorityFilter:     document.querySelector("#priorityFilter"),
  refreshBtn:         document.querySelector("#refreshBtn"),
  searchInput:        document.querySelector("#searchInput"),
  sectionStatusStrip: document.querySelector("#sectionStatusStrip"),
  sectionStatusTotal: document.querySelector("#sectionStatusTotal"),
  sectionTabs:        document.querySelector("#sectionTabs"),
  warningList:        document.querySelector("#warningList"),
  warningTotal:       document.querySelector("#warningTotal"),

  /* Dashboard 1 new elements */
  zoneOkCount:        document.querySelector("#zoneOkCount"),
  zoneWarningCount:   document.querySelector("#zoneWarningCount"),
  zoneOverCount:      document.querySelector("#zoneOverCount"),
  zoneOkBars:         document.querySelector("#zoneOkBars"),
  zoneWarningBars:    document.querySelector("#zoneWarningBars"),
  zoneOverBars:       document.querySelector("#zoneOverBars"),
  tatStats:           document.querySelector("#tatStats"),
  statusTotalLabel:   document.querySelector("#statusTotalLabel"),
  statusSummaryList:  document.querySelector("#statusSummaryList"),
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
  if (text.includes("complete") || text.includes("release")) return "Completed";
  if (text.includes("approve")) return "Approve";
  if (text.includes("report") || text.includes("verify") || text.includes("review") || text.includes("await")) return "Report";
  if (text.includes("result")) return "Result sent";
  if (text.includes("analy") || text.includes("process") || text.includes("incubat") || text.includes("scan")) return "Analyzing";
  return "Request";
}

function getPctagDefinition(value) {
  return PCTAG_DEFINITIONS.find((item) => item.value === value) || PCTAG_DEFINITIONS[2];
}

function isCompleted(row) {
  return row.lisStatus === "Completed" || row.processStage === "Approve";
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

function getDominantSectionStatus(rows) {
  if (rows.some(isOverTat))    return { label: "Over TAT", className: "status-over-tat",  borderClass: "border-status-over-tat" };
  if (rows.some(isWarningTat)) return { label: "Warning",  className: "status-warning",   borderClass: "border-status-warning" };

  const counts = LIS_STATUS_ORDER.reduce((acc, status) => {
    acc[status] = rows.filter((row) => row.lisStatus === status).length;
    return acc;
  }, {});
  const status = [...LIS_STATUS_ORDER].sort((a, b) => counts[b] - counts[a])[0] || "Request";

  return { label: status, className: getStatusClass(status), borderClass: getStatusBorderClass(status) };
}

function getVisibleRows() {
  const searchText = state.search.trim().toLowerCase();
  return state.allRows.filter((row) => {
    const accountMatch  = state.account === "all" || row.account === state.account;
    const sectionMatch  = state.section === "all" || row.section === state.section;
    const priorityMatch = state.priority === "all" || row.pctag === state.priority;
    const searchMatch   = !searchText || [
      row.sampleNo, row.requestNo, row.hn, row.patient,
      row.section, row.test, row.pctag, row.lisStatus,
      row.processStage, row.machine, row.account,
    ].join(" ").toLowerCase().includes(searchText);
    return accountMatch && sectionMatch && priorityMatch && searchMatch;
  });
}

function getRowsForSectionTabs() {
  const searchText = state.search.trim().toLowerCase();
  return state.allRows.filter((row) => {
    const accountMatch  = state.account === "all" || row.account === state.account;
    const priorityMatch = state.priority === "all" || row.pctag === state.priority;
    const searchMatch   = !searchText || [
      row.sampleNo, row.requestNo, row.hn, row.patient,
      row.section, row.test, row.pctag, row.lisStatus,
      row.processStage, row.machine, row.account,
    ].join(" ").toLowerCase().includes(searchText);
    return accountMatch && priorityMatch && searchMatch;
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

/* ══════════════════════════════════════════════════════════
   RENDER — FILTERS & SECTION TABS
══════════════════════════════════════════════════════════ */
function render() {
  const rows  = getVisibleRows();
  const stats = getStats(rows);

  renderFilters();
  renderSectionTabs();
  renderDashboard1(rows, stats);
  renderActionBoards(rows);
  renderSectionStatusStrip(rows);
  updateLastUpdatedLabel(new Date());
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

  elements.accountFilter.value  = state.account;
  elements.priorityFilter.value = state.priority;
  elements.searchInput.value    = state.search;
  elements.dateFilter.value     = state.date;
}

function renderSectionTabs() {
  const rows     = getRowsForSectionTabs();
  const sections = getSectionSummary(rows);

  elements.sectionTabs.innerHTML = [
    sectionTabTemplate({ active: state.section === "all", count: rows.length, label: "ทั้งหมด", section: "all", statusClass: "status-request" }),
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
function renderDashboard1(rows, stats) {
  renderZoneCards(rows, stats);
  renderTatStats(rows);
  renderStatusSummary(rows, stats);
  renderWorkloadChart(rows);
  renderAlertPanels(rows, stats);
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

/* ── TAT stats ─────────────────────────────────────────── */
function renderTatStats(rows) {
  const active = rows.filter((r) => !isCompleted(r));
  const tatValues = active.map((r) => r.elapsedTat).filter((v) => v > 0);

  function hhMm(minutes) {
    if (!minutes || !Number.isFinite(minutes)) return "--:--";
    const h = Math.floor(minutes / 60);
    const m = Math.round(minutes % 60);
    return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}`;
  }

  if (!tatValues.length) {
    elements.tatStats.innerHTML = `
      <div class="tat-row"><span>TAT Mean</span><strong>--:--</strong></div>
      <div class="tat-row"><span>TAT Min</span><strong>--:--</strong></div>
      <div class="tat-row"><span>TAT Max</span><strong>--:--</strong></div>
      <div class="tat-row"><span>TAT Median</span><strong>--:--</strong></div>
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
    <div class="tat-row"><span>TAT Mean</span><strong>${hhMm(mean)}</strong></div>
    <div class="tat-row"><span>TAT Min</span><strong>${hhMm(min)}</strong></div>
    <div class="tat-row"><span>TAT Max</span><strong>${hhMm(max)}</strong></div>
    <div class="tat-row"><span>TAT Median</span><strong>${hhMm(median)}</strong></div>
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
    const statusClass = getStatusClass(status);
    const circumference = 2 * Math.PI * 16;
    const offset = circumference - (pct / 100) * circumference;

    return `
      <div class="status-summary-row">
        <div class="gauge-container">
          <svg class="status-gauge" viewBox="0 0 40 40">
            <circle class="gauge-bg" cx="20" cy="20" r="16" fill="none" stroke="var(--panel-lift)" stroke-width="4"/>
            <circle class="gauge-fill ${h(fillClass)}" cx="20" cy="20" r="16" fill="none" stroke-width="4" stroke-dasharray="${circumference}" stroke-dashoffset="${offset}" stroke-linecap="round" transform="rotate(-90 20 20)"/>
          </svg>
          <span class="gauge-pct">${pct}%</span>
        </div>
        <span class="ss-label">${h(status)}</span>
        <span class="ss-count">${formatNumber(count)}</span>
      </div>
    `;
  }).join("");
}

/* ── Workload chart (canvas SVG-style) ─────────────────── */
let chartAnimFrame = null;
const chartHourBuckets = Array.from({ length: 24 }, (_, i) => i);

function renderWorkloadChart(rows) {
  const canvas = elements.workloadChart;
  if (!canvas) return;

  /* Use requestAnimationFrame so canvas dims are settled */
  if (chartAnimFrame) cancelAnimationFrame(chartAnimFrame);
  chartAnimFrame = requestAnimationFrame(function () {
    drawChart(canvas, rows);
  });
}

function refreshWorkloadChartLayout() {
  renderWorkloadChart(getVisibleRows());
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

  /* Group rows into 24 hour buckets by elapsed (mock distribution) */
  const received = chartHourBuckets.map((h) => rows.filter((r) => Math.floor(r.elapsedTat / 4) % 24 === h).length);
  const approved = chartHourBuckets.map((h) => rows.filter((r) => isCompleted(r) && Math.floor(r.elapsedTat / 5) % 24 === h).length);

  const maxVal = Math.max(1, ...received, ...approved);
  const padL = 28, padR = 12, padT = 12, padB = 30;
  const cW = W - padL - padR;
  const cH = H - padT - padB;

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

  const gridLines = [0.25, 0.5, 0.75, 1].map((f) => {
    const y = (padT + cH * (1 - f)).toFixed(2);
    return `<line x1="${padL}" y1="${y}" x2="${(W - padR).toFixed(2)}" y2="${y}" stroke="rgba(255,255,255,0.07)" stroke-width="1" />`;
  }).join("");

  const hourLabels = [0, 4, 8, 12, 16, 20, 23].map((h) => `
    <text x="${xPos(h).toFixed(2)}" y="${(H - padB + 14).toFixed(2)}" fill="rgba(107,135,166,0.9)" font-family="Cascadia Mono, SFMono-Regular, Consolas, monospace" font-size="10" text-anchor="middle">${h}</text>
  `).join("");

  canvas.setAttribute("viewBox", `0 0 ${W} ${H}`);
  canvas.setAttribute("preserveAspectRatio", "none");
  canvas.innerHTML = `
    <g aria-hidden="true">
      ${gridLines}
      <path d="${smoothAreaPath(received)}" fill="rgba(255,61,61,0.12)"></path>
      <path d="${smoothAreaPath(approved)}" fill="rgba(79,195,247,0.10)"></path>
      <path d="${smoothLinePath(received)}" fill="none" stroke="rgba(255,61,61,0.9)" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"></path>
      <path d="${smoothLinePath(approved)}" fill="none" stroke="rgba(79,195,247,0.9)" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"></path>
      ${hourLabels}
    </g>
  `;
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

  /* Urgent section labels */
  const sections = [...new Set(rows.map((r) => r.section))].slice(0, 3);
  function sectionLabelRow(el) {
    el.innerHTML = sections.map((s) => `<span class="alert-section-label">${h(s)}</span>`).join("");
  }
  sectionLabelRow(elements.urgentSectionRow);
  sectionLabelRow(elements.criticalSectionRow);
  sectionLabelRow(elements.warnTimeSectionRow);

  /* Render chip grids grouped by section */
  function renderChipGrid(targetRows, el, maxChips = 30) {
    const sorted = sortByRisk(targetRows).slice(0, maxChips);
    if (!sorted.length) {
      el.innerHTML = `<div class="empty-state" style="min-height:60px;font-size:0.68rem">None</div>`;
      return;
    }
    el.innerHTML = sorted.map((row) => sampleChip(row)).join("");
  }

  const urgentAll = sortByRisk([...asapRows, ...statRows.filter((r) => isOverTat(r) || isWarningTat(r))]);
  renderChipGrid(urgentAll.length ? urgentAll : asapRows, elements.urgentChips);
  renderChipGrid(critRows,  elements.criticalChips);
  renderChipGrid(warnRows,  elements.warnTimeChips);

  /* Over warranty — larger row style */
  if (!overRows.length) {
    elements.overWarrantyChips.innerHTML = `<div class="empty-state" style="min-height:60px;font-size:0.68rem">None</div>`;
  } else {
    elements.overWarrantyChips.innerHTML = sortByRisk(overRows).slice(0, 10).map((row) => {
      const overBy = Math.max(0, row.elapsedTat - row.targetTat);
      return `
        <div class="over-chip-row">
          <div>
            <div class="ocr-sample">${h(row.sampleNo)}</div>
            <div class="ocr-meta">${h(row.section)} · ${h(row.pctag)}</div>
          </div>
          <span class="ocr-tag">OVER ${minutesLabel(overBy)}</span>
        </div>
      `;
    }).join("");
  }
}

/* Sample chip: text colored by LIS status, outlined by TAT risk */
function sampleChip(row) {
  const statusClass = getStatusClass(row);
  const tatStatus   = getTatStatus(row);
  const riskClass   = tatStatus === "over" ? "over" : tatStatus === "warning" ? "warning" : "";
  const marker      = tatStatus === "over" ? " !" : tatStatus === "warning" ? " ~" : "";
  const title       = `${row.sampleNo} | ${row.requestNo} | ${row.hn} | ${row.section} | ${row.test} | ${row.lisStatus} | ${row.pctag} | ${minutesLabel(row.elapsedTat)} / ${minutesLabel(row.targetTat)}`;

  return `<span class="sample-chip ${h(statusClass)} ${h(riskClass)}" title="${h(title)}">${h(row.sampleNo)}${marker}</span>`;
}

/* ══════════════════════════════════════════════════════════
   RENDER — DASHBOARD 2  (unchanged logic)
══════════════════════════════════════════════════════════ */
function renderActionBoards(rows) {
  const actionRows  = sortByRisk(rows).filter((row) => !isCompleted(row));
  const overRows    = actionRows.filter(isOverTat);
  const warningRows = actionRows.filter((row) => !isOverTat(row) && (isWarningTat(row) || row.pctag === "ASAP"));

  elements.actionBoardTotal.textContent = `${formatNumber(warningRows.length + overRows.length)} action rows`;
  elements.warningTotal.textContent     = `${formatNumber(warningRows.length)} rows`;
  elements.overTotal.textContent        = `${formatNumber(overRows.length)} rows`;

  elements.warningList.innerHTML = warningRows.length
    ? warningRows.map((row) => actionRowTemplate(row, "warning")).join("")
    : `<div class="empty-state">No Warning rows in the current view.</div>`;

  elements.overList.innerHTML = overRows.length
    ? overRows.map((row) => actionRowTemplate(row, "over")).join("")
    : `<div class="empty-state">No Over TAT rows in the current view.</div>`;
}

function actionRowTemplate(row, type) {
  const overBy = Math.max(0, row.elapsedTat - row.targetTat);
  const left   = Math.max(0, row.targetTat - row.elapsedTat);
  const timing = type === "over" ? `${minutesLabel(overBy)} over` : `${minutesLabel(left)} left`;

  return `
    <article class="action-row ${type === "over" ? "over" : ""}">
      <div class="action-main">
        <strong>${h(row.requestNo)} / ${h(row.hn)}</strong>
        <small>Sample ${h(row.sampleNo)}</small>
      </div>
      <div class="action-detail">
        <strong>${h(row.section)} · ${h(row.test)}</strong>
        <small>${h(row.pctag)} target ${minutesLabel(row.targetTat)} · Stage ${h(row.processStage)}</small>
      </div>
      <div class="action-tat">
        <strong>${h(timing)}</strong>
        <span class="status-pill ${h(getStatusClass(row))}">${h(row.lisStatus)}</span>
      </div>
    </article>
  `;
}

function renderSectionStatusStrip(rows) {
  const sections = getSectionSummary(rows);
  elements.sectionStatusTotal.textContent = `${formatNumber(sections.length)} sections`;

  if (!sections.length) {
    elements.sectionStatusStrip.innerHTML = `<div class="empty-state">No section status to display.</div>`;
    return;
  }

  elements.sectionStatusStrip.innerHTML = sections.map((section) => `
    <article class="section-status-card ${h(section.dominant.borderClass)}">
      <strong>${h(section.section)}</strong>
      <small>
        ${formatNumber(section.total)} total ·
        ${formatNumber(section.warning)} warning ·
        ${formatNumber(section.over)} over ·
        ${formatNumber(section.completed)} done
      </small>
      <span class="status-pill ${h(section.dominant.className)}">${h(section.dominant.label)}</span>
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
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    const rows = extractRowsFromDashboardResponse(data).map(normalizeRow);
    if (!rows.length) throw new Error("Dashboard API returned no rows");
    state.allRows      = rows;
    state.latestSource = "api";
    render();
  } catch (error) {
    console.warn("Using local sample fallback:", error);
    state.allRows      = SAMPLE_ROWS;
    state.latestSource = "sample";
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
  const source = state.latestSource === "api" ? "API" : "Sample";
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
  const dataSeconds = nextAutoRefreshAt
    ? Math.max(0, Math.ceil((nextAutoRefreshAt - Date.now()) / 1000))
    : 30;

  let viewText = "";
  if (state.viewMode === "auto") {
    if (isViewRotationPaused) {
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

  elements.liveBadge.textContent = `Data ${dataSeconds}s | ${viewText}`;
}

function updateTick() {
  updateClock();
  updateLiveBadge();
}

function startAutoRefreshLoop() {
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

  elements.priorityFilter.addEventListener("change", (event) => {
    state.priority = event.target.value;
    state.section  = "all";
    render();
  });

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
