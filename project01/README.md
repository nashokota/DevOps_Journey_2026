# Nginx Service Monitor and Auto-Healer

This project provides a production-style Bash monitor for Nginx on Linux hosts that use systemd. The script checks service health, attempts recovery when Nginx is down, and writes an audit-friendly log trail.

## Project Objective

Build a robust and idempotent Nginx monitoring script that:

1. Checks whether Nginx is active.
2. Restarts Nginx automatically if it is down.
3. Verifies whether restart was successful.
4. Logs every important event for operations auditing.
5. Emits a visible alert block when an auto-restart is triggered.

## File Structure

1. [project01/monitor_nginx.sh](project01/monitor_nginx.sh): Main monitoring and auto-healing script.
2. [project01/README.md](project01/README.md): Project documentation.

## How It Works

The script flow is:

1. Validate the script is run as root or via sudo.
2. Check Nginx status with systemctl is-active --quiet.
3. If active:
1. Print healthy message.
2. Write success log entry.
3. Exit with status code 0.
4. If inactive:
1. Log downtime event.
2. Print a colored alert block.
3. Attempt systemctl restart nginx.
4. Re-check service state.
5. Log final success or critical failure.

## Features

1. Idempotent behavior: Safe to run repeatedly.
2. Timestamped logging for traceability.
3. Clear console output with ANSI colors.
4. Root permission enforcement.
5. Recovery verification after restart attempt.

## Configuration

Inside [project01/monitor_nginx.sh](project01/monitor_nginx.sh), key variables are:

1. SERVICE="nginx"
2. LOG_FILE="/var/log/nginx_monitor.log"
3. TIME_FORMAT="+%Y-%m-%d %H:%M:%S"

## Requirements

1. Linux with systemd.
2. Nginx installed and managed by systemctl.
3. Sudo or root access.

## Usage

From [project01](project01):

1. Make executable:

	chmod +x monitor_nginx.sh

2. Run with sudo:

	sudo ./monitor_nginx.sh

## Log Location

The script writes audit logs to:

1. /var/log/nginx_monitor.log

View recent logs:

1. sudo tail -n 50 /var/log/nginx_monitor.log

Watch logs live:

1. sudo tail -f /var/log/nginx_monitor.log

## Expected Outputs

Healthy case:

1. Console: Nginx is running fine.
2. Log: Nginx is running.

Recovery case:

1. Console: Nginx is DOWN. Attempting restart...
2. Console: ALERT block is printed.
3. Log: Nginx was down. Attempting restart.
4. Log: Nginx restarted successfully. or CRITICAL failure entry.

## Common Troubleshooting

1. Message: Unit nginx.service not found
1. Cause: Nginx is not installed on this host.
2. Fix:
1. sudo apt update
2. sudo apt install -y nginx
3. sudo systemctl enable --now nginx

2. No visible logs in terminal
1. Reason: log_message writes to file, not directly to console.
2. Check file with sudo tail commands above.

3. Permission denied for log file
1. Run the script with sudo.

## Optional Production Improvement Ideas

1. Add service existence pre-check before restart attempts.
2. Add lock file to prevent overlapping executions.
3. Add automatic log rotation policy.
4. Replace mock alert with real webhook integration.
5. Run by systemd timer or cron every minute.

## Author

1. nashokota
2. preom.cc.bd@gmail.com
