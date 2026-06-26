#!/bin/sh
set -e

DCL_PROXY_BLOCK='  location /api/dcl/ {
    proxy_pass https://on.dcl.csa-iot.org/dcl/;
    proxy_http_version 1.1;
    proxy_ssl_server_name on;
    proxy_set_header Host on.dcl.csa-iot.org;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }'

TEMPLATE=/etc/nginx/templates/default.conf.template
OUTPUT=/etc/nginx/conf.d/default.conf

if [ "$DISABLE_DCL_PROXY" = "true" ]; then
  sed 's|__DCL_PROXY_BLOCK__||' "$TEMPLATE" > "$OUTPUT"
  printf 'window.DCL_BASE_URL = "%s";\n' 'https://on.dcl.csa-iot.org/dcl' > /usr/share/nginx/html/config.js
else
  # Use printf to avoid issues with special characters in the block
  awk -v block="$DCL_PROXY_BLOCK" '{gsub(/__DCL_PROXY_BLOCK__/, block); print}' "$TEMPLATE" > "$OUTPUT"
  printf 'window.DCL_BASE_URL = "%s";\n' '/api/dcl' > /usr/share/nginx/html/config.js
fi

exec nginx -g 'daemon off;'
