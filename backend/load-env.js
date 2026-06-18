"use strict";

const fs = require("node:fs");
const path = require("node:path");

let cachedResult = null;

function parseEnvValue(rawValue = "") {
  const trimmed = String(rawValue).trim();

  if (
    (trimmed.startsWith("\"") && trimmed.endsWith("\"")) ||
    (trimmed.startsWith("'") && trimmed.endsWith("'"))
  ) {
    return trimmed
      .slice(1, -1)
      .replace(/\\n/g, "\n")
      .replace(/\\r/g, "\r");
  }

  return trimmed;
}

function loadLocalEnv(filePath = path.join(process.cwd(), ".env")) {
  if (cachedResult && cachedResult.filePath === filePath) {
    return cachedResult;
  }

  const result = {
    filePath,
    loaded: false,
  };

  if (!fs.existsSync(filePath)) {
    cachedResult = result;
    return result;
  }

  const contents = fs.readFileSync(filePath, "utf8");
  const lines = contents.split(/\r?\n/);

  for (const rawLine of lines) {
    const trimmedLine = String(rawLine || "").trim();

    if (!trimmedLine || trimmedLine.startsWith("#")) {
      continue;
    }

    const exportLine = trimmedLine.startsWith("export ")
      ? trimmedLine.slice("export ".length).trim()
      : trimmedLine;
    const separatorIndex = exportLine.indexOf("=");

    if (separatorIndex <= 0) {
      continue;
    }

    const key = exportLine.slice(0, separatorIndex).trim();

    if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(key) || key in process.env) {
      continue;
    }

    const rawValue = exportLine.slice(separatorIndex + 1);
    process.env[key] = parseEnvValue(rawValue);
  }

  result.loaded = true;
  cachedResult = result;
  return result;
}

module.exports = {
  loadLocalEnv,
};
