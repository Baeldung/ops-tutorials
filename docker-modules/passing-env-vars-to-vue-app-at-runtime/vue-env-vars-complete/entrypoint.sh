#!/bin/sh

# Path to the runtime config.js file
CONFIG_FILE=/usr/share/nginx/html/config.js

# Replace placeholders in config.js with environment variables
echo "Generating runtime configuration in $CONFIG_FILE"
cat <<EOF > $CONFIG_FILE
window.config = {
    VUE_APP_API_URL: "${VUE_APP_API_URL:-undefined}"
};
EOF

# Start Nginx
nginx -g "daemon off;"
