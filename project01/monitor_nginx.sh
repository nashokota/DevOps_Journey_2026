#!/bin/bash

set -u
set -o pipefail

SERVICE="nginx"
LOG_FILE="/var/log/nginx_monitor.log"
TIME_FORMAT="+%Y-%m-%d %H:%M:%S"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

current_time() {
  date "$TIME_FORMAT"
}

log_message() {
  local message="$1"
  local timestamp
  timestamp="$(current_time)"
  printf '[%s] %s\n' "$timestamp" "$message" >> "$LOG_FILE"
}

send_alert() {
  local timestamp
  timestamp="$(current_time)"

  printf '%b\n' "$RED"
  printf '========================================\n'
  printf 'ALERT: NGINX SERVICE RESTART TRIGGERED\n'
  printf 'Time: %s\n' "$timestamp"
  printf '========================================\n'
  printf '%b\n' "$NC"
}

if [[ "$EUID" -ne 0 ]]; then
  printf '%b\n' "${RED}[ERROR] Please run as root or with sudo${NC}"
  exit 1
fi

if systemctl is-active --quiet "$SERVICE"; then
  printf '%b\n' "${GREEN}Nginx is running fine.${NC}"
  log_message "Nginx is running."
  exit 0
fi

printf '%b\n' "${YELLOW}Nginx is DOWN. Attempting restart...${NC}"
log_message "Nginx was down. Attempting restart."
send_alert

if systemctl restart "$SERVICE"; then
  sleep 2
else
  printf '%b\n' "${RED}CRITICAL: Restart command failed for Nginx.${NC}"
  log_message "CRITICAL: Restart command failed for Nginx."
  exit 1
fi

if systemctl is-active --quiet "$SERVICE"; then
  printf '%b\n' "${GREEN}Nginx successfully restarted.${NC}"
  log_message "Nginx restarted successfully."
  exit 0
fi

printf '%b\n' "${RED}CRITICAL: Nginx failed to restart!${NC}"
log_message "CRITICAL: Nginx failed to restart!"
exit 1
