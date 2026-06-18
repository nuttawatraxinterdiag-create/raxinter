"use strict";

const http = require("node:http");
const fs = require("node:fs/promises");
const path = require("node:path");
const { URL } = require("node:url");
const { loadLocalEnv } = require("./backend/load-env");

loadLocalEnv();

const {
  CONTRACT_VERSION,
  MOCK_SCENARIOS,
  getDashboardHealth,
  getDashboardPayload,
  resolveDataMode,
} = require("./backend/dashboard-service");

const HOST = process.env.HOST || "127.0.0.1";
const PORT = Number(process.env.PORT || 3000);
const ROOT_DIR = __dirname;

const STATIC_FILES = {
  "/": { file: "index.html", contentType: "text/html; charset=utf-8" },
  "/index.html": { file: "index.html", contentType: "text/html; charset=utf-8" },
  "/app.js": { file: "app.js", contentType: "application/javascript; charset=utf-8" },
  "/styles.css": { file: "styles.css", contentType: "text/css; charset=utf-8" },
};

function writeJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store",
  });
  response.end(JSON.stringify(payload));
}

async function readRequestJson(request) {
  const chunks = [];

  for await (const chunk of request) {
    chunks.push(chunk);
  }

  if (!chunks.length) {
    return {};
  }

  const rawBody = Buffer.concat(chunks).toString("utf8");
  return JSON.parse(rawBody);
}

async function handleDashboardRequest(requestUrl, response) {
  const payload = await getDashboardPayload({
    account: requestUrl.searchParams.get("account") || "PWL",
    date: requestUrl.searchParams.get("date") || "",
    mock: requestUrl.searchParams.get("mock") || "",
    priority: requestUrl.searchParams.get("priority") || "all",
    search: requestUrl.searchParams.get("search") || "",
    section: requestUrl.searchParams.get("section") || "all",
  });
  writeJson(response, 200, payload);
}

async function handleOllamaRequest(request, response) {
  const requestBody = await readRequestJson(request);
  const ollamaUrl = process.env.OLLAMA_URL || "http://127.0.0.1:11434/api/generate";

  const ollamaResponse = await fetch(ollamaUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(requestBody),
  });

  const text = await ollamaResponse.text();

  if (!ollamaResponse.ok) {
    const error = new Error(`Ollama returned HTTP ${ollamaResponse.status}`);
    error.statusCode = 502;
    error.details = text;
    throw error;
  }

  response.writeHead(200, {
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store",
  });
  response.end(text);
}

async function handleStaticRequest(requestPath, response) {
  const fileInfo = STATIC_FILES[requestPath];

  if (!fileInfo) {
    writeJson(response, 404, {
      ok: false,
      message: "Not found",
    });
    return;
  }

  const filePath = path.join(ROOT_DIR, fileInfo.file);
  const contents = await fs.readFile(filePath);
  response.writeHead(200, {
    "Content-Type": fileInfo.contentType,
    "Cache-Control": "no-store",
  });
  response.end(contents);
}

const server = http.createServer(async (request, response) => {
  try {
    const requestUrl = new URL(request.url || "/", `http://${request.headers.host || `${HOST}:${PORT}`}`);

    if (request.method === "GET" && requestUrl.pathname === "/api/health") {
      const health = await getDashboardHealth();

      writeJson(response, 200, {
        ok: true,
        backend: "phase3-scaffold",
        contractVersion: CONTRACT_VERSION,
        dataMode: resolveDataMode(),
        dataSource: health,
        mockScenarios: MOCK_SCENARIOS,
      });
      return;
    }

    if (request.method === "GET" && requestUrl.pathname === "/api/dashboard") {
      await handleDashboardRequest(requestUrl, response);
      return;
    }

    if (request.method === "POST" && requestUrl.pathname === "/api/ollama/generate") {
      await handleOllamaRequest(request, response);
      return;
    }

    if (request.method === "GET") {
      await handleStaticRequest(requestUrl.pathname, response);
      return;
    }

    writeJson(response, 405, {
      ok: false,
      message: "Method not allowed",
    });
  } catch (error) {
    const statusCode = Number(error.statusCode || 500);
    writeJson(response, statusCode, {
      ok: false,
      code: error.code || "SERVER_ERROR",
      message: error.message || "Unexpected server error",
      details: error.details || null,
    });
  }
});

server.listen(PORT, HOST, () => {
  console.log(`Rax dashboard server listening on http://${HOST}:${PORT}`);
  console.log(`Dashboard data mode: ${resolveDataMode()}`);
});
