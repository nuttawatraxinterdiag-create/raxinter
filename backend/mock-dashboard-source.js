"use strict";

const CONTRACT_VERSION = "2026-06-15-phase3-v1";

const BASE_CASES = [
  {
    id: "LAB-1028",
    patient: "Anan W.",
    department: "Laboratory",
    test: "CBC",
    sample: "Blood",
    priority: "Urgent",
    status: "Processing",
    stage: "Analyzing",
    orderedAt: "07:42",
    elapsed: 56,
    due: 75,
    machine: "Alinity i",
    owner: "Hematology Bench",
    doctor: "Dr. Suda",
  },
  {
    id: "RAD-3114",
    patient: "Mali K.",
    department: "Radiology",
    test: "CT chest contrast",
    sample: "Imaging",
    priority: "Critical",
    status: "Awaiting report",
    stage: "SD Verify",
    orderedAt: "06:56",
    elapsed: 138,
    due: 120,
    machine: "CT Console",
    owner: "Radiologist A",
    doctor: "Dr. Preecha",
  },
  {
    id: "PAT-2081",
    patient: "Somchai T.",
    department: "Pathology",
    test: "Frozen section",
    sample: "Tissue",
    priority: "Critical",
    status: "Review",
    stage: "SD Verify",
    orderedAt: "08:13",
    elapsed: 46,
    due: 45,
    machine: "Manual",
    owner: "Pathologist B",
    doctor: "Dr. Narin",
  },
  {
    id: "CAR-0907",
    patient: "Nicha P.",
    department: "Cardiology",
    test: "ECG interpretation",
    sample: "ECG",
    priority: "Routine",
    status: "Completed",
    stage: "Approved",
    orderedAt: "07:20",
    elapsed: 31,
    due: 60,
    machine: "Online",
    owner: "Cardio Desk",
    doctor: "Dr. Viroj",
  },
  {
    id: "LAB-1035",
    patient: "Kanya S.",
    department: "Laboratory",
    test: "Troponin I",
    sample: "Serum",
    priority: "Critical",
    status: "Analyzer hold",
    stage: "Analyzing",
    orderedAt: "08:05",
    elapsed: 61,
    due: 45,
    machine: "Cobas 6000_1",
    owner: "Chemistry Bench",
    doctor: "Dr. Suda",
  },
  {
    id: "RAD-3119",
    patient: "Tanet R.",
    department: "Radiology",
    test: "Portable X-ray",
    sample: "Imaging",
    priority: "Urgent",
    status: "Scheduled",
    stage: "Received",
    orderedAt: "08:36",
    elapsed: 18,
    due: 50,
    machine: "X-ray Room",
    owner: "Imaging Queue",
    doctor: "Dr. Chai",
  },
  {
    id: "LAB-1041",
    patient: "Arisa M.",
    department: "Laboratory",
    test: "Blood culture",
    sample: "Blood",
    priority: "Routine",
    status: "Incubating",
    stage: "Analyzing",
    orderedAt: "05:50",
    elapsed: 185,
    due: 240,
    machine: "BD FACSlyric",
    owner: "Microbiology",
    doctor: "Dr. Paweena",
  },
  {
    id: "PAT-2088",
    patient: "Wichai L.",
    department: "Pathology",
    test: "Biopsy grossing",
    sample: "Tissue",
    priority: "Routine",
    status: "Queued",
    stage: "Pending",
    orderedAt: "07:35",
    elapsed: 72,
    due: 180,
    machine: "Manual",
    owner: "Histology Desk",
    doctor: "Dr. Narin",
  },
  {
    id: "CAR-0912",
    patient: "Benya C.",
    department: "Cardiology",
    test: "Holter review",
    sample: "Report",
    priority: "Urgent",
    status: "Review",
    stage: "SD Verify",
    orderedAt: "07:58",
    elapsed: 92,
    due: 90,
    machine: "Online",
    owner: "Cardiologist C",
    doctor: "Dr. Viroj",
  },
  {
    id: "RAD-3127",
    patient: "Prasert N.",
    department: "Radiology",
    test: "MRI brain",
    sample: "Imaging",
    priority: "Routine",
    status: "In scan",
    stage: "Analyzing",
    orderedAt: "08:00",
    elapsed: 78,
    due: 150,
    machine: "MRI Room 2",
    owner: "Radiology Room 2",
    doctor: "Dr. Chai",
  },
  {
    id: "LAB-1056",
    patient: "Ploy R.",
    department: "Laboratory",
    test: "HbA1c",
    sample: "Whole blood",
    priority: "Routine",
    status: "Received",
    stage: "Received",
    orderedAt: "08:28",
    elapsed: 34,
    due: 90,
    machine: "BioRad D100",
    owner: "Chemistry Bench",
    doctor: "Dr. Paweena",
  },
  {
    id: "LAB-1057",
    patient: "Narin C.",
    department: "Laboratory",
    test: "HIV Viral Load",
    sample: "Plasma",
    priority: "Urgent",
    status: "Processing",
    stage: "Analyzing",
    orderedAt: "07:08",
    elapsed: 112,
    due: 120,
    machine: "Cobas c6800",
    owner: "Molecular Bench",
    doctor: "Dr. Suda",
  },
];

const BASE_MACHINES = [
  "Manual",
  "Formula",
  "Online",
  "Default Result",
  "BioRad D100",
  "LabXpert EH-209",
  "LabXpert CaM600",
  "Cobas 6000_1",
  "Cobas 6000_2",
  "Alinity i",
  "BD FACSlyric",
  "Cobas c6800",
  "ABI 90 FLEX",
  "CT Console",
  "X-ray Room",
];

const BASE_TREND_POINTS = [
  { hour: "00:00", onTime: 86, avg: 48 },
  { hour: "02:00", onTime: 88, avg: 45 },
  { hour: "04:00", onTime: 86, avg: 47 },
  { hour: "06:00", onTime: 79, avg: 54 },
  { hour: "08:00", onTime: 64, avg: 68 },
  { hour: "10:00", onTime: 70, avg: 61 },
  { hour: "12:00", onTime: 74, avg: 58 },
  { hour: "14:00", onTime: 72, avg: 60 },
  { hour: "16:00", onTime: 75, avg: 57 },
  { hour: "18:00", onTime: 78, avg: 53 },
  { hour: "20:00", onTime: 84, avg: 49 },
  { hour: "22:00", onTime: 82, avg: 51 },
];

const PRIORITY_DEFINITIONS = [
  { caseValue: "Routine", filterValue: "standard", label: "Standard", target: 90 },
  { caseValue: "Urgent", filterValue: "urgent", label: "Urgent", target: 30 },
  { caseValue: "Critical", filterValue: "veryurgent", label: "Very urgent / Critical", target: 15 },
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

const MOCK_SCENARIOS = [
  {
    value: "normal",
    label: "Mock: Normal",
    description: "Balanced sample workload close to the original dashboard demo.",
  },
  {
    value: "empty",
    label: "Mock: Empty",
    description: "No matched LIS activity for empty-state testing.",
  },
  {
    value: "overflow",
    label: "Mock: Overflow",
    description: "High-volume day with many alerts, sections, and analyzers competing for space.",
  },
  {
    value: "bottleneck",
    label: "Mock: Bottleneck",
    description: "Concentrated urgent backlog on one lab area for escalation testing.",
  },
];

function formatDateInputValue(value = new Date()) {
  const date = value instanceof Date ? value : new Date(value);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function cleanText(value, fallback = "") {
  if (value === null || value === undefined) {
    return fallback;
  }

  const text = String(value).trim();
  return text || fallback;
}

function getMockScenarioDefinition(value = "normal") {
  return (
    MOCK_SCENARIOS.find((scenario) => scenario.value === value) ||
    MOCK_SCENARIOS[0]
  );
}

function getPriorityDefinitionByCaseValue(value) {
  return (
    PRIORITY_DEFINITIONS.find((item) => item.caseValue === value) ||
    PRIORITY_DEFINITIONS[0]
  );
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

function resolveMockGroupName(record = {}) {
  const normalized = [
    record.groupName,
    record.department,
    record.owner,
    record.test,
    record.sample,
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

  if (normalized.includes("pathology") || normalized.includes("histology")) {
    return "PAT";
  }

  if (
    normalized.includes("radiology") ||
    normalized.includes("x-ray") ||
    normalized.includes("ct ") ||
    normalized.includes("mri")
  ) {
    return "RAD";
  }

  if (
    normalized.includes("cardio") ||
    normalized.includes("ecg") ||
    normalized.includes("holter")
  ) {
    return "CAR";
  }

  return cleanText(record.department, "GEN");
}

function deriveMockAccount(record = {}) {
  const normalized = cleanText(record.department).toLowerCase();

  if (normalized.includes("radiology")) {
    return "Alliance";
  }

  if (normalized.includes("pathology")) {
    return "Corporate";
  }

  if (normalized.includes("cardiology")) {
    return "Walk-in";
  }

  return "PWL";
}

function normalizeAccount(value, fallback = "PWL") {
  return cleanText(value, fallback);
}

function getSectionLabel(record = {}) {
  return cleanText(record.sectionLabel || record.groupName || record.department, "Unassigned");
}

function getProcessStage(stage, status = "") {
  const normalized = `${cleanText(stage)} ${cleanText(status)}`.toLowerCase();

  if (
    normalized.includes("approve") ||
    normalized.includes("release") ||
    normalized.includes("complete")
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
    normalized.includes("scan") ||
    normalized.includes("incubat")
  ) {
    return "Analyzing";
  }

  return "Request";
}

function getWorkflowStageIndex(stage) {
  const index = WORKFLOW_STAGES.indexOf(stage);
  return index === -1 ? 0 : index;
}

function enrichCaseRecord(record = {}) {
  const priority = cleanText(record.priority, "Routine");
  const tatCategory = normalizeTatCategory(
    record.tatCategory || record.pctag || record.pctagName,
    priority,
  );
  const explicitDue = Number(record.due);
  const due =
    Number.isFinite(explicitDue) && explicitDue > 0
      ? explicitDue
      : getTatCategoryDefinition(tatCategory).target;
  const account = normalizeAccount(
    record.account || record.customer || record.accountCustomer,
    deriveMockAccount(record),
  );
  const groupName = cleanText(record.groupName, resolveMockGroupName(record));
  const sectionLabel = getSectionLabel({
    department: record.department,
    groupName,
    sectionLabel: record.sectionLabel,
  });

  return {
    ...record,
    account,
    due,
    groupName,
    processStage: getProcessStage(record.stage, record.status),
    sectionLabel,
    tatCategory,
  };
}

function cloneCaseRecord(base, overrides = {}) {
  return enrichCaseRecord({
    ...base,
    ...overrides,
  });
}

function createFlatTrendSeries({ avg = 0, onTime = 0 } = {}) {
  return BASE_TREND_POINTS.map((point) => ({
    avg,
    hour: point.hour,
    onTime,
  }));
}

function isBreach(item) {
  return item.status !== "Completed" && item.elapsed > item.due;
}

function isDueSoon(item) {
  if (item.due <= 0) {
    return false;
  }

  const ratio = item.elapsed / item.due;
  return item.status !== "Completed" && ratio >= 0.82 && ratio <= 1;
}

function getMedian(values) {
  if (!values.length) return 0;
  const sorted = [...values].sort((a, b) => a - b);
  const middle = Math.floor(sorted.length / 2);
  return sorted.length % 2
    ? sorted[middle]
    : Math.round((sorted[middle - 1] + sorted[middle]) / 2);
}

function getStats(items) {
  const active = items.filter((item) => item.status !== "Completed");
  const completed = items.filter((item) => item.status === "Completed");
  const breaches = active.filter(isBreach);
  const dueSoon = active.filter(isDueSoon);
  const critical = active.filter((item) => item.priority === "Critical");
  const onTimeCount =
    active.filter((item) => item.elapsed <= item.due).length + completed.length;
  const onTimeRate = items.length
    ? Math.round((onTimeCount / items.length) * 1000) / 10
    : 0;
  const medianTat = getMedian(items.map((item) => item.elapsed));

  return {
    active,
    breaches,
    completed,
    critical,
    dueSoon,
    medianTat,
    onTimeRate,
  };
}

function getTopDepartment(items) {
  const totals = items.reduce((acc, item) => {
    const sectionLabel = getSectionLabel(item);
    acc[sectionLabel] ||= {
      count: 0,
      name: sectionLabel,
      risk: 0,
    };
    acc[sectionLabel].count += 1;

    if (isBreach(item) || isDueSoon(item) || item.priority === "Critical") {
      acc[sectionLabel].risk += 1;
    }

    return acc;
  }, {});

  return (
    Object.values(totals).sort(
      (a, b) => b.risk - a.risk || b.count - a.count,
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

function getFallbackWorkflowStage(item) {
  return item.processStage || getProcessStage(item.stage, item.status);
}

function buildSectionBreakdownRowsFromCases(items) {
  const totals = items.reduce((acc, item) => {
    const sectionLabel = getSectionLabel(item);
    acc[sectionLabel] ||= { name: sectionLabel, total: 0, risk: 0 };
    acc[sectionLabel].total += 1;

    if (isBreach(item) || isDueSoon(item) || item.priority === "Critical") {
      acc[sectionLabel].risk += 1;
    }

    return acc;
  }, {});

  return Object.values(totals).sort(
    (a, b) => b.risk - a.risk || b.total - a.total || a.name.localeCompare(b.name),
  );
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
    items.filter(
      (item) => item.status !== "Completed" && (isBreach(item) || isDueSoon(item)),
    ),
  ).reduce((acc, item) => {
    const sectionLabel = getSectionLabel(item);
    acc[sectionLabel] ||= {
      name: sectionLabel,
      over: 0,
      total: 0,
      warning: 0,
      rows: [],
    };

    acc[sectionLabel].rows.push(buildAlertRow(item));
    acc[sectionLabel].total += 1;

    if (isBreach(item)) {
      acc[sectionLabel].over += 1;
    } else {
      acc[sectionLabel].warning += 1;
    }

    return acc;
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
    const activeRows = rows.filter((item) => item.status !== "Completed");
    const onTrackCount = activeRows.filter(
      (item) => !isBreach(item) && !isDueSoon(item),
    ).length;

    return {
      count: rows.length,
      label: definition.label,
      onTrack: onTrackCount,
      target: definition.target,
      warning: activeRows.filter(isDueSoon).length,
    };
  });
}

function buildOverflowScenarioFixtures() {
  const departments = [
    "Chemistry Core",
    "Hematology",
    "Microbiology",
    "Serology",
    "Immunology",
    "Molecular",
    "Blood Bank",
    "Emergency Lab",
    "Pathology",
    "Radiology",
  ];

  return {
    cases: Array.from({ length: 26 }, (_, index) => {
      const base = BASE_CASES[index % BASE_CASES.length];
      const due = Math.max(25, Number(base.due || 0) - (index % 4) * 5);
      const priority = index % 4 === 0
        ? "Critical"
        : index % 3 === 0
          ? "Urgent"
          : base.priority;
      const stage = index % 5 === 0
        ? "SD Verify"
        : index % 2 === 0
          ? "Analyzing"
          : "Received";
      const status = stage === "SD Verify"
        ? "Awaiting report"
        : stage === "Analyzing"
          ? "Processing"
          : "Received";

      return cloneCaseRecord(base, {
        department: departments[index % departments.length],
        doctor: `Dr. Ops ${String.fromCharCode(65 + (index % 6))}`,
        due,
        elapsed: due + 12 + (index % 6) * 10,
        id: `${String(departments[index % departments.length]).slice(0, 3).toUpperCase()}-${1400 + index}`,
        machine: BASE_MACHINES[index % BASE_MACHINES.length],
        orderedAt: `${String(6 + (index % 12)).padStart(2, "0")}:${String((index * 7) % 60).padStart(2, "0")}`,
        owner: `${departments[index % departments.length]} Desk`,
        patient: `Mock Overflow ${index + 1}`,
        priority,
        stage,
        status,
        test: `${base.test} ${index % 2 === 0 ? "STAT" : "Extended"}`,
      });
    }),
    machines: [...BASE_MACHINES],
    trendPoints: BASE_TREND_POINTS.map((point, index) => ({
      avg: point.avg + 16 + (index % 4) * 4,
      hour: point.hour,
      onTime: Math.max(42, point.onTime - 18 + (index % 3) * 2),
    })),
  };
}

function buildBottleneckScenarioFixtures() {
  return {
    cases: Array.from({ length: 14 }, (_, index) => {
      const base = BASE_CASES[index % 4];
      const due = index < 6 ? 30 : 45;
      const stage = index % 4 === 0 ? "SD Verify" : "Analyzing";
      return cloneCaseRecord(base, {
        department: index < 10 ? "Chemistry STAT" : "Emergency Lab",
        doctor: "Dr. Escalation",
        due,
        elapsed: due + 14 + index * 5,
        id: `BOT-${2100 + index}`,
        machine: index < 10 ? "Cobas 6000_1" : "Alinity i",
        orderedAt: `${String(7 + (index % 4)).padStart(2, "0")}:${String((index * 5) % 60).padStart(2, "0")}`,
        owner: index < 10 ? "STAT Chemistry Bench" : "Emergency Queue",
        patient: `Mock Bottleneck ${index + 1}`,
        priority: index < 8 ? "Critical" : "Urgent",
        stage,
        status: stage === "SD Verify" ? "Awaiting report" : "Processing",
        test: index < 8 ? "Troponin I" : "CBC",
      });
    }),
    machines: [...BASE_MACHINES],
    trendPoints: BASE_TREND_POINTS.map((point, index) => ({
      avg: point.avg + 22 + (index % 3) * 5,
      hour: point.hour,
      onTime: Math.max(35, point.onTime - 24 + (index % 2) * 3),
    })),
  };
}

function getMockScenarioFixtures(scenarioValue = "normal") {
  const normalizedScenario = getMockScenarioDefinition(scenarioValue).value;

  switch (normalizedScenario) {
    case "empty":
      return {
        cases: [],
        machines: [...BASE_MACHINES],
        trendPoints: createFlatTrendSeries(),
      };
    case "overflow":
      return buildOverflowScenarioFixtures();
    case "bottleneck":
      return buildBottleneckScenarioFixtures();
    case "normal":
    default:
      return {
        cases: BASE_CASES.map((item) => cloneCaseRecord(item)),
        machines: [...BASE_MACHINES],
        trendPoints: BASE_TREND_POINTS.map((point) => ({ ...point })),
      };
  }
}

function filterCases({
  caseSource = BASE_CASES,
  account = "PWL",
  priority = "all",
  search = "",
  section = "all",
} = {}) {
  const normalizedSearch = String(search || "").trim().toLowerCase();

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

function buildMockDashboardPayload(query = {}) {
  const mockScenario = getMockScenarioDefinition(query.mock);
  const fixtures = getMockScenarioFixtures(mockScenario.value);
  const selectedAccount = cleanText(query.account, "PWL");
  const selectedDate = String(query.date || "").trim() || formatDateInputValue();
  const visibleCases = filterCases({
    account: selectedAccount,
    caseSource: fixtures.cases,
    priority: query.priority || "all",
    search: query.search || "",
    section: query.section || "all",
  });
  const sectionFilterCases = filterCases({
    account: selectedAccount,
    caseSource: fixtures.cases,
    priority: query.priority || "all",
    search: query.search || "",
    section: "all",
  });
  const priorityFilterCases = filterCases({
    account: selectedAccount,
    caseSource: fixtures.cases,
    priority: "all",
    search: query.search || "",
    section: query.section || "all",
  });
  const accountFilterCases = filterCases({
    account: "all",
    caseSource: fixtures.cases,
    priority: query.priority || "all",
    search: query.search || "",
    section: query.section || "all",
  });
  const stats = getStats(visibleCases);
  const forecast = getLocalForecast(visibleCases, stats);
  const onTrackCount = stats.active.filter(
    (item) => !isBreach(item) && !isDueSoon(item),
  ).length;
  const sectionTotals = sectionFilterCases.reduce((acc, item) => {
    const sectionLabel = getSectionLabel(item);
    acc[sectionLabel] ||= {
      count: 0,
      label: sectionLabel,
      risk: 0,
      value: sectionLabel,
    };
    acc[sectionLabel].count += 1;

    if (isBreach(item) || isDueSoon(item) || item.priority === "Critical") {
      acc[sectionLabel].risk += 1;
    }

    return acc;
  }, {});
  const accountTotals = accountFilterCases.reduce((acc, item) => {
    acc[item.account] ||= {
      count: 0,
      label: item.account,
      value: item.account,
    };
    acc[item.account].count += 1;
    return acc;
  }, {});
  const workflow = WORKFLOW_STAGES.map((stage) => {
    const stageRows = visibleCases.filter(
      (item) => getFallbackWorkflowStage(item) === stage,
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
  const analyzers = fixtures.machines
    .map((machine) => {
      const rows = visibleCases.filter((item) => item.machine === machine);
      const pending = rows.filter((item) => item.status !== "Completed").length;
      const running = rows.filter((item) => item.stage === "Analyzing").length;
      const alerts = rows.filter(isBreach).length;
      return {
        alerts,
        name: machine,
        pending,
        results: rows.length ? pending + running : 0,
      };
    })
    .sort(
      (a, b) =>
        b.results - a.results ||
        b.pending - a.pending ||
        b.alerts - a.alerts ||
        a.name.localeCompare(b.name),
    );
  const alerts = sortCasesForMonitor(visibleCases)
    .filter(
      (item) =>
        item.status !== "Completed" && (isBreach(item) || isDueSoon(item)),
    )
    .map((item) => buildAlertRow(item));
  const averageTat = visibleCases.length
    ? Math.round(
        visibleCases.reduce((sum, item) => sum + Number(item.elapsed || 0), 0) /
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
    ok: true,
    source: "api",
    meta: {
      backend: "phase3-scaffold",
      contractVersion: CONTRACT_VERSION,
      generatedAt: new Date().toISOString(),
      mode: "mock",
    },
    mock: {
      description: mockScenario.description,
      label: mockScenario.label,
      scenario: mockScenario.value,
    },
    date: selectedDate,
    lastUpdatedAt: new Date().toISOString(),
    cases,
    filters: {
      accounts: [
        {
          count: fixtures.cases.length,
          label: "All customers",
          value: "all",
        },
        ...Object.values(accountTotals).sort(
          (a, b) => b.count - a.count || a.label.localeCompare(b.label),
        ),
      ],
      date: {
        latest: selectedDate,
        max: selectedDate,
        min: selectedDate,
        selected: selectedDate,
      },
      sections: Object.values(sectionTotals).sort(
        (a, b) =>
          b.risk - a.risk || b.count - a.count || a.label.localeCompare(b.label),
      ),
      priorities: PRIORITY_DEFINITIONS.map((definition) => ({
        count: priorityFilterCases.filter(
          (item) => item.priority === definition.caseValue,
        ).length,
        label: definition.label,
        value: definition.filterValue,
      })),
    },
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
    workflow,
    priorities,
    analyzers,
    alerts,
    nearTatGroups,
    serviceLevels,
    trend: fixtures.trendPoints,
    sectionBreakdown,
    fullSectionBreakdown: sectionBreakdown,
  };
}

module.exports = {
  CONTRACT_VERSION,
  MOCK_SCENARIOS,
  buildMockDashboardPayload,
};
