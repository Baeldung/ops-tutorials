const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();

let config = {
    SERVICE_NAME: process.env.SERVICE_NAME || "default-service",
    ENVIRONMENT: process.env.ENVIRONMENT || "development",
    LOG_LEVEL: process.env.LOG_LEVEL || "info",
    PORT: process.env.PORT || 3000,
};

if (process.env.CONFIG_PATH) {
    try {
        const configPath = path.resolve(process.env.CONFIG_PATH);
        const fileContent = fs.readFileSync(configPath, "utf-8");
        const fileConfig = JSON.parse(fileContent);
        config = { ...config, ...fileConfig };
        console.log(`[INFO] Loaded config from ${configPath}`);
    } catch (err) {
        console.error(
            `[ERROR] Failed to load config from ${process.env.CONFIG_PATH}:`,
            err.message
        );
    }
}

console.log(
    `[INFO] Starting ${config.SERVICE_NAME} in ${config.ENVIRONMENT} mode (log level: ${config.LOG_LEVEL})`
);

app.get("/", (req, res) => {
    res.send(`
    <h1>Service: ${config.SERVICE_NAME}</h1>
    <p>Environment: ${config.ENVIRONMENT}</p>
    <p>Log level: ${config.LOG_LEVEL}</p>
    <p>Running on port ${config.PORT}</p>
  `);
});

app.listen(config.PORT, () => {
    console.log(`✅ ${config.SERVICE_NAME} is running on port ${config.PORT}`);
});
