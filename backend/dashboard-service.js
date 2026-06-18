"use strict";

const {
  CONTRACT_VERSION,
  MOCK_SCENARIOS,
  buildMockDashboardPayload,
} = require("./mock-dashboard-source");
const {
  getMariadbHealth,
  getMariadbDashboardPayload,
} = require("./mariadb-dashboard-source");

const SUPPORTED_DATA_MODES = ["mock", "mariadb"];

function resolveDataMode() {
  const preferredMode = String(process.env.DASHBOARD_DATA_MODE || "mock")
    .trim()
    .toLowerCase();
  return SUPPORTED_DATA_MODES.includes(preferredMode) ? preferredMode : "mock";
}

async function getDashboardPayload(query = {}) {
  const dataMode = resolveDataMode();

  if (dataMode === "mariadb") {
    return getMariadbDashboardPayload(query);
  }

  return buildMockDashboardPayload(query);
}

async function getDashboardHealth() {
  const dataMode = resolveDataMode();

  if (dataMode === "mariadb") {
    return getMariadbHealth();
  }

  return {
    mode: "mock",
    ready: true,
  };
}

module.exports = {
  CONTRACT_VERSION,
  MOCK_SCENARIOS,
  SUPPORTED_DATA_MODES,
  getDashboardHealth,
  getDashboardPayload,
  resolveDataMode,
};
