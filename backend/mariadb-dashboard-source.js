"use strict";

const fs = require("node:fs/promises");
const path = require("node:path");

const { CONTRACT_VERSION } = require("./mock-dashboard-source");

const PRIORITY_DEFINITIONS = [
  { caseValue: "Routine", filterValue: "standard", label: "Standard" },
  { caseValue: "Urgent", filterValue: "urgent", label: "Urgent" },
  { caseValue: "Critical", filterValue: "veryurgent", label: "Very urgent / Critical" },
];

const WORKFLOW_STAGES = [
  "Request",
  "Analyzing",
  "Result sent",
  "Report",
  "Approve",
];

const TAT_CATEGORY_DEFINITIONS = [
  { label: "ASAP", target: 15, value: "ASAP" },
  { label: "STAT", target: 30, value: "STAT" },
  { label: "Routine", target: 90, value: "ROUTINE" },
];

const TREND_BUCKETS = [
  "00:00",
  "02:00",
  "04:00",
  "06:00",
  "08:00",
  "10:00",
  "12:00",
  "14:00",
  "16:00",
  "18:00",
  "20:00",
  "22:00",
];

const REQUIRED_CONNECTION_KEYS = [
  "MARIADB_HOST",
  "MARIADB_DATABASE",
  "MARIADB_USER",
];

let mariadbModulePromise = null;
let poolPromise = null;
let casesSqlPromise = null;
let trendSqlPromise = null;

function createConfigError(message, code = "MARIADB_CONFIG_ERROR", details = null) {
  const error = new Error(message);
  error.code = code;
  error.statusCode = 500;
  error.details = details;
  return error;
}

function cleanText(value, fallback = "") {
  if (value === null || value === undefined) {
    return fallback;
  }

  const text = String(value).trim();
  return text || fallback;
}

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

function formatDateInputValue(value = new Date()) {
  const date = value instanceof Date ? value : new Date(value);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function resolveSelectedDate(value) {
  const candidate = cleanText(value);
  return /^\d{4}-\d{2}-\d{2}$/.test(candidate)
    ? candidate
    : formatDateInputValue();
}

function toNumber(value, fallback = 0) {
  const number = Number(value);
  return Number.isFinite(number) ? number : fallback;
}

function normalizePriority(value) {
  const text = cleanText(value, "Routine").toLowerCase();

  if (
    text.includes("critical") ||
    text.includes("stat") ||
    text.includes("very urgent") ||
    text.includes("veryurgent")
  ) {
    return "Critical";
  }

  if (text.includes("urgent")) {
    return "Urgent";
  }

  return "Routine";
}

function getTatCategoryDefinition(value = "ROUTINE") {
  return (
    TAT_CATEGORY_DEFINITIONS.find((item) => item.value === value) ||
    TAT_CATEGORY_DEFINITIONS[TAT_CATEGORY_DEFINITIONS.length - 1]
  );
}

function normalizeTatCategory(value, priority = "Routine") {
  const text = cleanText(value).toLowerCase();

  if (text.includes("asap") || priority === "Critical") {
    return "ASAP";
  }

  if (text.includes("stat") || priority === "Urgent") {
    return "STAT";
  }

  return "ROUTINE";
}

function normalizeAccount(value) {
  return cleanText(value, "PWL");
}

function deriveGroupName(record = {}) {
  const normalized = [
    record.groupName,
    record.group_name,
    record.department,
    record.section,
    record.section_name,
    record.owner,
    record.owner_name,
    record.test,
    record.test_name,
  ]
    .filter(Boolean)
    .join(" ")
    .toLowerCase();

  if (
    normalized.includes("hema") ||
    normalized.includes("cbc") ||
    normalized.includes("blood film")
  ) {
    return "HEM";
  }

  if (
    normalized.includes("micro") ||
    normalized.includes("culture") ||
    normalized.includes("incubat")
  ) {
    return "MIC";
  }

  if (
    normalized.includes("chem") ||
    normalized.includes("troponin") ||
    normalized.includes("hba1c") ||
    normalized.includes("serum")
  ) {
    return "ICH";
  }

  if (normalized.includes("immun")) {
    return "IMM";
  }

  if (normalized.includes("molec") || normalized.includes("viral")) {
    return "MOL";
  }

  return cleanText(record.department || record.section || record.section_name, "GEN");
}

function getSectionLabel(record = {}) {
  return cleanText(record.sectionLabel || record.groupName || record.department, "Unassigned");
}

function getProcessStage(stage, status = "") {
  const normalized = `${cleanText(stage)} ${cleanText(status)}`.toLowerCase();

  if (
    normalized.includes("approve") ||
    normalized.includes("release") ||
    normalized.includes("complete") ||
    normalized.includes("final")
  ) {
    return "Approve";
  }

  if (normalized.includes("result")) {
    return "Result sent";
  }

  if (
    normalized.includes("report") ||
    normalized.includes("verify") ||
    normalized.includes("review") ||
    normalized.includes("await")
  ) {
    return "Report";
  }

  if (
    normalized.includes("analy") ||
    normalized.includes("process") ||
    normalized.includes("run") ||
    normalized.includes("scan") ||
    normalized.includes("incubat")
  ) {
    return "Analyzing";
  }

  return "Request";
}

function normalizeStage(value) {
  const text = cleanText(value, "Pending");
  const normalized = text.toLowerCase();

  if (
    normalized.includes("approve") ||
    normalized.includes("release") ||
    normalized.includes("complete") ||
    normalized.includes("final")
  ) {
    return "Approved";
  }

  if (
    normalized.includes("verify") ||
    normalized.includes("report") ||
    normalized.includes("review") ||
    normalized.includes("await")
  ) {
    return "SD Verify";
  }

  if (
    normalized.includes("analy") ||
    normalized.includes("process") ||
    normalized.includes("run") ||
    normalized.includes("scan") ||
    normalized.includes("incubat")
  ) {
    return "Analyzing";
  }

  if (
    normalized.includes("receive") ||
    normalized.includes("collect") ||
    normalized.includes("specimen")
  ) {
    return "Received";
  }

  if (
    normalized.includes("check") ||
    normalized.includes("register") ||
    normalized.includes("order") ||
    normalized.includes("queue") ||
    normalized.includes("pending")
  ) {
    return "Pending";
  }

  return text;
}

function normalizeStatus(value, stage) {
  const text = cleanText(value);
  const normalized = text.toLowerCase();

  if (
    normalized.includes("complete") ||
    normalized.includes("approved") ||
    normalized.includes("release") ||
    normalized.includes("final")
  ) {
    return "Completed";
  }

  if (!text && stage === "Approved") {
    return "Completed";
  }

  return text || "Queued";
}

function formatTimeLabel(value) {
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    const hours = String(value.getHours()).padStart(2, "0");
    const minutes = String(value.getMinutes()).padStart(2, "0");
    return `${hours}:${minutes}`;
  }

  const text = cleanText(value);
  const timeMatch = text.match(/(\d{2}):(\d{2})/);

  if (timeMatch) {
    return `${timeMatch[1]}:${timeMatch[2]}`;
  }

  const date = new Date(text);

  if (!Number.isNaN(date.getTime())) {
    const hours = String(date.getHours()).padStart(2, "0");
    const minutes = String(date.getMinutes()).padStart(2, "0");
    return `${hours}:${minutes}`;
  }

  return text || "--:--";
}

function getHourValue(value) {
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    return value.getHours();
  }

  const text = cleanText(value);
  const timeMatch = text.match(/(\d{2}):(\d{2})/);

  if (timeMatch) {
    return clamp(Number(timeMatch[1]), 0, 23);
  }

  const date = new Date(text);
  return Number.isNaN(date.getTime()) ? null : date.getHours();
}

function getMedian(values) {
  if (!values.length) {
    return 0;
  }

  const sorted = [...values].sort((a, b) => a - b);
  const middle = Math.floor(sorted.length / 2);
  return sorted.length % 2
    ? sorted[middle]
    : Math.round((sorted[middle - 1] + sorted[middle]) / 2);
}

function isCompleted(item) {
  return item.status === "Completed";
}

function isBreach(item) {
  return !isCompleted(item) && item.elapsed > item.due;
}

function isDueSoon(item) {
  if (isCompleted(item) || item.due <= 0) {
    return false;
  }

  const ratio = item.elapsed / item.due;
  return ratio >= 0.82 && ratio <= 1;
}

function getStats(items) {
  const active = items.filter((item) => !isCompleted(item));
  const completed = items.filter(isCompleted);
  const breaches = active.filter(isBreach);
  const dueSoon = active.filter(isDueSoon);
  const critical = active.filter((item) => item.priority === "Critical");
  const onTimeCount =
    active.filter((item) => item.elapsed <= item.due).length + completed.length;
  const onTimeRate = items.length
    ? Math.round((onTimeCount / items.length) * 1000) / 10
    : 0;

  return {
    active,
    breaches,
    completed,
    critical,
    dueSoon,
    medianTat: getMedian(items.map((item) => item.elapsed)),
    onTimeRate,
  };
}

function getTopDepartment(items) {
  const totals = items.reduce((accumulator, item) => {
    const sectionLabel = getSectionLabel(item);
    accumulator[sectionLabel] ||= {
      count: 0,
      name: sectionLabel,
      risk: 0,
    };
    accumulator[sectionLabel].count += 1;

    if (isBreach(item) || isDueSoon(item) || item.priority === "Critical") {
      accumulator[sectionLabel].risk += 1;
    }

    return accumulator;
  }, {});

  return (
    Object.values(totals).sort(
      (left, right) => right.risk - left.risk || right.count - left.count,
    )[0] || { count: 0, name: "No dept", risk: 0 }
  );
}

function getLocalForecast(items, stats) {
  const department = getTopDepartment(items).name;
  const pressure =
    stats.dueSoon.length * 3 +
    stats.breaches.length * 5 +
    stats.critical.length * 2;
  const tests = Math.max(0, Math.round(items.length * 1.18 + pressure));
  const peak =
    stats.breaches.length >= 2
      ? "09:00"
      : stats.dueSoon.length
        ? "10:00"
        : "11:00";

  return {
    department,
    peak,
    tests,
  };
}

function getWorkflowStage(item) {
  return item.processStage || getProcessStage(item.stage, item.status);
}

function buildSectionBreakdownRowsFromCases(items) {
  const totals = items.reduce((accumulator, item) => {
    const sectionLabel = getSectionLabel(item);
    accumulator[sectionLabel] ||= {
      name: sectionLabel,
      risk: 0,
      total: 0,
    };
    accumulator[sectionLabel].risk +=
      isBreach(item) || isDueSoon(item) || item.priority === "Critical"
        ? 1
        : 0;
    accumulator[sectionLabel].total += 1;
    return accumulator;
  }, {});

  return Object.values(totals).sort(
    (left, right) =>
      right.risk - left.risk ||
      right.total - left.total ||
      left.name.localeCompare(right.name),
  );
}

function getPriorityDefinitionByCaseValue(value) {
  return (
    PRIORITY_DEFINITIONS.find((item) => item.caseValue === value) ||
    PRIORITY_DEFINITIONS[0]
  );
}

function getWorkflowStageIndex(stage) {
  const index = WORKFLOW_STAGES.indexOf(stage);
  return index === -1 ? 0 : index;
}

function sortCasesForMonitor(items = []) {
  return [...items].sort(
    (left, right) =>
      Number(isBreach(right)) - Number(isBreach(left)) ||
      Number(isDueSoon(right)) - Number(isDueSoon(left)) ||
      getWorkflowStageIndex(left.processStage) - getWorkflowStageIndex(right.processStage) ||
      (right.elapsed - right.due) - (left.elapsed - left.due) ||
      left.id.localeCompare(right.id),
  );
}

function buildAlertRow(item) {
  const overBy = Math.max(0, item.elapsed - item.due);
  const withinBy = Math.max(0, item.due - item.elapsed);

  return {
    account: item.account,
    actual: item.elapsed,
    groupName: item.groupName,
    id: item.id,
    overBy,
    patient: item.patient,
    priority: item.priority,
    processStage: item.processStage,
    requestNo: item.id,
    riskLevel: item.priority === "Critical"
      ? "high"
      : isBreach(item)
        ? "breach"
        : "watch",
    section: item.sectionLabel,
    status: item.status,
    target: item.due,
    tatCategory: item.tatCategory,
    test: item.test,
    withinBy,
  };
}

function buildNearTatGroups(items = []) {
  const grouped = sortCasesForMonitor(
    items.filter((item) => !isCompleted(item) && (isBreach(item) || isDueSoon(item))),
  ).reduce((accumulator, item) => {
    const sectionLabel = getSectionLabel(item);
    accumulator[sectionLabel] ||= {
      name: sectionLabel,
      over: 0,
      total: 0,
      warning: 0,
      rows: [],
    };
    accumulator[sectionLabel].rows.push(buildAlertRow(item));
    accumulator[sectionLabel].total += 1;

    if (isBreach(item)) {
      accumulator[sectionLabel].over += 1;
    } else {
      accumulator[sectionLabel].warning += 1;
    }

    return accumulator;
  }, {});

  return Object.values(grouped).sort(
    (left, right) =>
      right.over - left.over ||
      right.warning - left.warning ||
      right.total - left.total ||
      left.name.localeCompare(right.name),
  );
}

function buildServiceLevelRows(items = []) {
  return TAT_CATEGORY_DEFINITIONS.map((definition) => {
    const rows = items.filter((item) => item.tatCategory === definition.value);
    const activeRows = rows.filter((item) => !isCompleted(item));
    const onTrack = activeRows.filter(
      (item) => !isBreach(item) && !isDueSoon(item),
    ).length;

    return {
      count: rows.length,
      label: definition.label,
      onTrack,
      target: definition.target,
      warning: activeRows.filter(isDueSoon).length,
    };
  });
}

function filterCases({
  caseSource = [],
  account = "PWL",
  priority = "all",
  search = "",
  section = "all",
} = {}) {
  const normalizedSearch = cleanText(search).toLowerCase();

  return caseSource.filter((item) => {
    const priorityDefinition = getPriorityDefinitionByCaseValue(item.priority);
    const matchesAccount = account === "all" || item.account === account;
    const matchesSection = section === "all" || getSectionLabel(item) === section;
    const matchesPriority =
      priority === "all" || priorityDefinition.filterValue === priority;
    const matchesSearch =
      !normalizedSearch ||
      [
        item.id,
        item.account,
        item.patient,
        item.department,
        item.groupName,
        item.test,
        item.doctor,
        item.owner,
        item.machine,
        item.sample,
      ]
        .join(" ")
        .toLowerCase()
        .includes(normalizedSearch);

    return matchesAccount && matchesSection && matchesPriority && matchesSearch;
  });
}

function mapCaseRow(row, index) {
  const rawStage =
    row.stage ||
    row.workflowStage ||
    row.workflow_stage ||
    row.resultStage ||
    row.result_stage ||
    row.status ||
    row.resultStatus ||
    row.result_status;
  const rawStatus = row.status || row.resultStatus || row.result_status;
  const stage = normalizeStage(rawStage);
  const status = normalizeStatus(
    rawStatus,
    stage,
  );
  const priority = normalizePriority(
    row.priority || row.priorityLabel || row.priority_label || row.priorityCode || row.priority_code,
  );
  const tatCategory = normalizeTatCategory(
    row.pctag ||
      row.pctagName ||
      row.pctag_name ||
      row.tatCategory ||
      row.tat_category ||
      row.serviceLevel ||
      row.service_level,
    priority,
  );
  const explicitDue = toNumber(
    row.due ||
      row.target ||
      row.targetTat ||
      row.target_tat ||
      row.targetMinutes ||
      row.target_minutes,
    0,
  );
  const groupName = cleanText(
    row.groupName ||
      row.group_name ||
      row.workgroup ||
      row.work_group ||
      row.sectionGroup ||
      row.section_group,
    deriveGroupName(row),
  );
  const department = cleanText(
    row.department || row.section || row.sectionName || row.section_name,
    "Unknown section",
  );
  const sectionLabel = getSectionLabel({
    department,
    groupName,
    sectionLabel: row.sectionLabel || row.section_label,
  });

  return {
    account: normalizeAccount(
      row.account || row.customer || row.accountCustomer || row.account_customer,
    ),
    department,
    doctor: cleanText(
      row.doctor || row.doctorName || row.doctor_name,
      "Unknown doctor",
    ),
    due: Math.max(
      0,
      explicitDue || getTatCategoryDefinition(tatCategory).target,
    ),
    elapsed: Math.max(
      0,
      toNumber(row.elapsed || row.elapsedMinutes || row.elapsed_minutes, 0),
    ),
    groupName,
    id: cleanText(
      row.id || row.requestNo || row.request_no || row.accessionNo || row.accession_no,
      `ROW-${index + 1}`,
    ),
    machine: cleanText(
      row.machine || row.analyzer || row.analyser || row.instrument,
      "Manual",
    ),
    orderedAt: formatTimeLabel(
      row.orderedAt ||
        row.ordered_at ||
        row.requestedAt ||
        row.requested_at ||
        row.orderTime ||
        row.order_time,
    ),
    owner: cleanText(
      row.owner || row.ownerName || row.owner_name || row.bench,
      "Unassigned",
    ),
    patient: cleanText(
      row.patient || row.patientName || row.patient_name,
      "Unknown patient",
    ),
    priority,
    processStage: getProcessStage(rawStage, rawStatus),
    sample: cleanText(
      row.sample || row.sampleType || row.sample_type,
      "Sample",
    ),
    sectionLabel,
    stage,
    status,
    tatCategory,
    test: cleanText(
      row.test || row.testName || row.test_name,
      "Unnamed test",
    ),
  };
}

function buildFallbackTrend(items) {
  const grouped = new Map(TREND_BUCKETS.map((bucket) => [bucket, []]));

  for (const item of items) {
    const hour = getHourValue(item.orderedAt);

    if (hour === null) {
      continue;
    }

    const bucketHour = String(Math.floor(hour / 2) * 2).padStart(2, "0");
    const bucket = `${bucketHour}:00`;
    grouped.get(bucket).push(item);
  }

  return TREND_BUCKETS.map((bucket) => {
    const rows = grouped.get(bucket) || [];

    if (!rows.length) {
      return {
        avg: 0,
        hour: bucket,
        onTime: 0,
      };
    }

    const avg = Math.round(
      rows.reduce((sum, item) => sum + item.elapsed, 0) / rows.length,
    );
    const onTimeCount = rows.filter(
      (item) => isCompleted(item) || item.elapsed <= item.due,
    ).length;

    return {
      avg,
      hour: bucket,
      onTime: Math.round((onTimeCount / rows.length) * 1000) / 10,
    };
  });
}

function mapTrendHour(value) {
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    return `${String(value.getHours()).padStart(2, "0")}:${String(
      value.getMinutes(),
    ).padStart(2, "0")}`;
  }

  const text = cleanText(value, "00:00");
  const timeMatch = text.match(/(\d{2}):(\d{2})/);

  if (timeMatch) {
    return `${timeMatch[1]}:${timeMatch[2]}`;
  }

  const hour = clamp(toNumber(text, 0), 0, 23);
  return `${String(hour).padStart(2, "0")}:00`;
}

function mapTrendRows(rows) {
  return rows.map((row) => ({
    avg: Math.max(0, Math.round(toNumber(row.avg || row.average || row.avgTat || row.avg_tat, 0))),
    hour: mapTrendHour(row.hour || row.bucket || row.timeSlot || row.time_slot),
    onTime: clamp(
      Math.round(
        toNumber(
          row.onTime || row.on_time || row.onTimeRate || row.on_time_rate,
          0,
        ) * 10,
      ) / 10,
      0,
      100,
    ),
  }));
}

function getSqlSource(inlineKey, fileKey) {
  const inlineValue = cleanText(process.env[inlineKey]);

  if (inlineValue) {
    return `env:${inlineKey}`;
  }

  const fileValue = cleanText(process.env[fileKey]);
  return fileValue ? `file:${fileValue}` : null;
}

function getMariadbConfig() {
  const connectionLimit = toNumber(process.env.MARIADB_CONNECTION_LIMIT, 5);
  const port = toNumber(process.env.MARIADB_PORT, 3306);
  const connectTimeout = toNumber(process.env.MARIADB_CONNECT_TIMEOUT_MS, 10000);

  return {
    charset: cleanText(process.env.MARIADB_CHARSET, "utf8mb4"),
    connectTimeout: connectTimeout > 0 ? connectTimeout : 10000,
    connectionLimit: connectionLimit > 0 ? connectionLimit : 5,
    database: cleanText(process.env.MARIADB_DATABASE),
    host: cleanText(process.env.MARIADB_HOST),
    password: process.env.MARIADB_PASSWORD || "",
    port: port > 0 ? port : 3306,
    timezone: cleanText(process.env.MARIADB_TIMEZONE),
    user: cleanText(process.env.MARIADB_USER),
  };
}

function getMariadbConfigStatus() {
  const config = getMariadbConfig();
  const missingConnection = REQUIRED_CONNECTION_KEYS.filter(
    (key) => !cleanText(process.env[key]),
  );
  const caseQuerySource = getSqlSource(
    "MARIADB_CASES_SQL",
    "MARIADB_CASES_SQL_FILE",
  );
  const trendQuerySource = getSqlSource(
    "MARIADB_TREND_SQL",
    "MARIADB_TREND_SQL_FILE",
  );

  return {
    caseQueryConfigured: Boolean(caseQuerySource),
    caseQuerySource,
    connectionConfigured: missingConnection.length === 0,
    database: config.database || null,
    host: config.host || null,
    missingConnection,
    port: config.port,
    trendQueryConfigured: Boolean(trendQuerySource),
    trendQuerySource,
  };
}

async function getMariadbModule() {
  if (!mariadbModulePromise) {
    mariadbModulePromise = Promise.resolve()
      .then(() => require("mariadb"))
      .catch((error) => {
        throw createConfigError(
          "MariaDB driver is missing. Run `npm install` before starting the dashboard server.",
          "MARIADB_DRIVER_MISSING",
          error.message,
        );
      });
  }

  return mariadbModulePromise;
}

async function getMariadbPool() {
  const status = getMariadbConfigStatus();

  if (!status.connectionConfigured) {
    throw createConfigError(
      `MariaDB mode is missing connection settings: ${status.missingConnection.join(", ")}.`,
      "MARIADB_CONNECTION_CONFIG_MISSING",
    );
  }

  if (!poolPromise) {
    poolPromise = getMariadbModule().then((mariadb) =>
      mariadb.createPool(getMariadbConfig()),
    );
  }

  return poolPromise;
}

function resolveSqlFilePath(filePath) {
  return path.isAbsolute(filePath)
    ? filePath
    : path.resolve(process.cwd(), filePath);
}

async function loadSqlDefinition({
  fileKey,
  inlineKey,
  label,
  required = false,
}) {
  const inlineSql = cleanText(process.env[inlineKey]);

  if (inlineSql) {
    return {
      source: `env:${inlineKey}`,
      sql: inlineSql,
    };
  }

  const fileValue = cleanText(process.env[fileKey]);

  if (fileValue) {
    const filePath = resolveSqlFilePath(fileValue);

    try {
      const sql = cleanText(await fs.readFile(filePath, "utf8"));

      if (!sql) {
        throw createConfigError(
          `MariaDB ${label} SQL file is empty: ${filePath}.`,
          "MARIADB_SQL_FILE_EMPTY",
        );
      }

      return {
        source: `file:${fileValue}`,
        sql,
      };
    } catch (error) {
      if (error.code === "MARIADB_SQL_FILE_EMPTY") {
        throw error;
      }

      throw createConfigError(
        `Unable to read MariaDB ${label} SQL file: ${filePath}.`,
        "MARIADB_SQL_FILE_ERROR",
        error.message,
      );
    }
  }

  if (required) {
    throw createConfigError(
      `MariaDB mode requires ${inlineKey} or ${fileKey}.`,
      "MARIADB_QUERY_MISSING",
    );
  }

  return null;
}

async function getCasesSqlDefinition() {
  if (!casesSqlPromise) {
    casesSqlPromise = loadSqlDefinition({
      fileKey: "MARIADB_CASES_SQL_FILE",
      inlineKey: "MARIADB_CASES_SQL",
      label: "cases",
      required: true,
    });
  }

  return casesSqlPromise;
}

async function getTrendSqlDefinition() {
  if (!trendSqlPromise) {
    trendSqlPromise = loadSqlDefinition({
      fileKey: "MARIADB_TREND_SQL_FILE",
      inlineKey: "MARIADB_TREND_SQL",
      label: "trend",
      required: false,
    });
  }

  return trendSqlPromise;
}

function applyDashboardSqlTokens(sql, selectedDate) {
  const tokenMap = {
    selectedDate: `'${selectedDate}'`,
    selectedDateEnd: `'${selectedDate} 23:59:59'`,
    selectedDateStart: `'${selectedDate} 00:00:00'`,
  };

  return sql.replace(
    /\{\{\s*(selectedDate|selectedDateStart|selectedDateEnd)\s*\}\}/g,
    (fullMatch, tokenName) => tokenMap[tokenName] || fullMatch,
  );
}

function getSqlParameters(sql, selectedDate) {
  const parameterCount = (sql.match(/\?/g) || []).length;

  if (parameterCount === 0) {
    return [];
  }

  if (parameterCount === 1) {
    return [selectedDate];
  }

  throw createConfigError(
    "MariaDB SQL currently supports either dashboard date tokens (`{{selectedDate}}`, `{{selectedDateStart}}`, `{{selectedDateEnd}}`) or a single `?` placeholder for the selected date.",
    "MARIADB_QUERY_PARAMETER_UNSUPPORTED",
  );
}

async function runDashboardQuery(sqlDefinition, selectedDate) {
  const pool = await getMariadbPool();
  const sql = applyDashboardSqlTokens(sqlDefinition.sql, selectedDate);
  const parameters = getSqlParameters(sql, selectedDate);
  const rows = await pool.query(sql, parameters);
  return Array.isArray(rows) ? rows : [];
}

function buildDashboardPayload({
  allCases,
  query,
  selectedDate,
  trendRows,
}) {
  const selectedAccount = cleanText(query.account, "PWL");
  const visibleCases = filterCases({
    account: selectedAccount,
    caseSource: allCases,
    priority: query.priority || "all",
    search: query.search || "",
    section: query.section || "all",
  });
  const sectionFilterCases = filterCases({
    account: selectedAccount,
    caseSource: allCases,
    priority: query.priority || "all",
    search: query.search || "",
    section: "all",
  });
  const priorityFilterCases = filterCases({
    account: selectedAccount,
    caseSource: allCases,
    priority: "all",
    search: query.search || "",
    section: query.section || "all",
  });
  const accountFilterCases = filterCases({
    account: "all",
    caseSource: allCases,
    priority: query.priority || "all",
    search: query.search || "",
    section: query.section || "all",
  });
  const stats = getStats(visibleCases);
  const forecast = getLocalForecast(visibleCases, stats);
  const onTrackCount = stats.active.filter(
    (item) => !isBreach(item) && !isDueSoon(item),
  ).length;
  const sectionTotals = sectionFilterCases.reduce((accumulator, item) => {
    const sectionLabel = getSectionLabel(item);
    accumulator[sectionLabel] ||= {
      count: 0,
      label: sectionLabel,
      risk: 0,
      value: sectionLabel,
    };
    accumulator[sectionLabel].count += 1;

    if (isBreach(item) || isDueSoon(item) || item.priority === "Critical") {
      accumulator[sectionLabel].risk += 1;
    }

    return accumulator;
  }, {});
  const accountTotals = accountFilterCases.reduce((accumulator, item) => {
    accumulator[item.account] ||= {
      count: 0,
      label: item.account,
      value: item.account,
    };
    accumulator[item.account].count += 1;
    return accumulator;
  }, {});
  const workflow = WORKFLOW_STAGES.map((stage) => {
    const stageRows = visibleCases.filter(
      (item) => getWorkflowStage(item) === stage,
    );

    return {
      count: stageRows.length,
      label: stage,
      percent: visibleCases.length
        ? Math.round((stageRows.length / visibleCases.length) * 100)
        : 0,
    };
  }).filter((item) => item.count > 0);
  const priorities = PRIORITY_DEFINITIONS.map((definition) => ({
    count: visibleCases.filter((item) => item.priority === definition.caseValue)
      .length,
    name: definition.label,
  }));
  const serviceLevels = buildServiceLevelRows(visibleCases);
  const analyzers = Array.from(
    visibleCases.reduce((accumulator, item) => {
      accumulator[item.machine] ||= {
        alerts: 0,
        name: item.machine,
        pending: 0,
        results: 0,
      };
      accumulator[item.machine].results += 1;
      accumulator[item.machine].pending += isCompleted(item) ? 0 : 1;
      accumulator[item.machine].alerts += isBreach(item) ? 1 : 0;
      return accumulator;
    }, {}),
  )
    .map((entry) => entry[1])
    .sort(
      (left, right) =>
        right.results - left.results ||
        right.pending - left.pending ||
        right.alerts - left.alerts ||
        left.name.localeCompare(right.name),
    );
  const alerts = sortCasesForMonitor(visibleCases)
    .filter((item) => !isCompleted(item) && (isBreach(item) || isDueSoon(item)))
    .map((item) => buildAlertRow(item))
    .sort(
      (left, right) =>
        right.overBy - left.overBy ||
        left.requestNo.localeCompare(right.requestNo),
    );
  const averageTat = visibleCases.length
    ? Math.round(
        visibleCases.reduce((sum, item) => sum + item.elapsed, 0) /
          visibleCases.length,
      )
    : 0;
  const sectionBreakdown = buildSectionBreakdownRowsFromCases(visibleCases);
  const nearTatGroups = buildNearTatGroups(visibleCases);
  const cases = sortCasesForMonitor(visibleCases).map((item) => ({
    ...item,
    isNearTat: isDueSoon(item),
    isOverTat: isBreach(item),
  }));

  return {
    alerts,
    analyzers,
    cases,
    date: selectedDate,
    filters: {
      accounts: [
        {
          count: allCases.length,
          label: "All customers",
          value: "all",
        },
        ...Object.values(accountTotals).sort(
          (left, right) =>
            right.count - left.count || left.label.localeCompare(right.label),
        ),
      ],
      date: {
        latest: selectedDate,
        max: selectedDate,
        min: selectedDate,
        selected: selectedDate,
      },
      priorities: PRIORITY_DEFINITIONS.map((definition) => ({
        count: priorityFilterCases.filter(
          (item) => item.priority === definition.caseValue,
        ).length,
        label: definition.label,
        value: definition.filterValue,
      })),
      sections: Object.values(sectionTotals).sort(
        (left, right) =>
          right.risk - left.risk ||
          right.count - left.count ||
          left.label.localeCompare(right.label),
      ),
    },
    fullSectionBreakdown: sectionBreakdown,
    lastUpdatedAt: new Date().toISOString(),
    meta: {
      backend: "phase3-mariadb",
      contractVersion: CONTRACT_VERSION,
      generatedAt: new Date().toISOString(),
      mode: "mariadb",
    },
    ok: true,
    priorities,
    nearTatGroups,
    serviceLevels,
    sectionBreakdown,
    source: "api",
    summary: {
      avgLabTat: averageTat,
      forecastTests: forecast.tests,
      focusAccount: selectedAccount === "all" ? "All customers" : selectedAccount,
      onTimeRate: stats.onTimeRate,
      onTrackCount,
      overTarget: stats.breaches.length,
      pendingCount: stats.active.length,
      peakHour: forecast.peak,
      requests: new Set(visibleCases.map((item) => item.id)).size,
      samples: visibleCases.length,
      tests: visibleCases.length,
      urgent: visibleCases.filter((item) => item.priority === "Urgent").length,
      veryUrgent: visibleCases.filter((item) => item.priority === "Critical").length,
      warningCount: stats.dueSoon.length,
      workflowTests: stats.active.length,
    },
    trend: trendRows.length ? trendRows : buildFallbackTrend(allCases),
    workflow,
  };
}

async function getMariadbDashboardPayload(query = {}) {
  const selectedDate = resolveSelectedDate(query.date);
  const casesSqlDefinition = await getCasesSqlDefinition();
  const caseRows = await runDashboardQuery(casesSqlDefinition, selectedDate);
  const allCases = caseRows.map((row, index) => mapCaseRow(row, index));
  const trendSqlDefinition = await getTrendSqlDefinition();
  const trendRows = trendSqlDefinition
    ? mapTrendRows(await runDashboardQuery(trendSqlDefinition, selectedDate))
    : [];

  return buildDashboardPayload({
    allCases,
    query,
    selectedDate,
    trendRows,
  });
}

async function getMariadbHealth() {
  const status = getMariadbConfigStatus();

  if (!status.connectionConfigured) {
    return {
      ...status,
      connectionReady: false,
      mode: "mariadb",
      ready: false,
    };
  }

  try {
    const pool = await getMariadbPool();
    await pool.query("SELECT 1 AS ok");

    return {
      ...status,
      connectionReady: true,
      mode: "mariadb",
      ready: status.caseQueryConfigured,
    };
  } catch (error) {
    return {
      ...status,
      connectionReady: false,
      error: {
        code: error.code || "MARIADB_CONNECT_ERROR",
        message: error.message,
      },
      mode: "mariadb",
      ready: false,
    };
  }
}

module.exports = {
  getMariadbDashboardPayload,
  getMariadbHealth,
};
