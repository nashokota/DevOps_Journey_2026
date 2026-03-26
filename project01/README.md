The goal for this project is to create a robust Nginx Service Monitor. This script won't just check if Nginx is running; it will attempt to fix it if it’s down and log the entire event for a "production" audit trail.

🛠️ Project : The Nginx Auto-Healer

1. The Logic Flow
Before you write a single line of code, visualize the "if-then" logic. In DevOps, we want scripts that are idempotent (they don't cause problems if run multiple times) and verbose (they tell us exactly what happened).

2. Implementation Steps
Create a file named monitor_nginx.sh and follow this structure:

Define Variables: Store the service name (nginx), the log file path (/var/log/nginx_monitor.log), and the timestamp format.

The Check: Use systemctl is-active --quiet $SERVICE. This command is perfect for scripts because it doesn't output text—it only sets an Exit Code ($?).

The Conditional ($?): * If $? is 0, the service is fine. Log "Nginx is running" and exit.

If $? is NOT 0, the service is down.

The Recovery: Attempt systemctl restart $SERVICE.

Verification: Check the status one more time after the restart to see if it worked. Log the final success or failure.

3. Production-Grade Refinement
To make this "DevOps-ready," apply these three layers:

Permissions Check: Add a block at the top to ensure the script is running with sudo or as root. If not, exit with a helpful error message.

Shebang & Set Flags: Start with #!/bin/bash. Add set -e if you want the script to fail fast on errors, or handle them manually for more control.

The Linter (ShellCheck): Run your script through ShellCheck. It will likely catch issues like missing quotes around variables (e.g., "$SERVICE" vs $SERVICE), which prevents word splitting.

🚀 Challenge: Add a "Slack/Discord" Mockup
Once the basic script works, try adding a function that sends a "notification." Since we aren't setting up webhooks yet, just have the script output a specific "ALERT" block to the console in a different color (using ANSI escape codes) whenever a restart is triggered.