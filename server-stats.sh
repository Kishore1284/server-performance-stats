#!/bin/bash
# server-stats.sh
# Basic Server Performance Analysis Script

echo "=========================================="
echo "      SERVER PERFORMANCE STATISTICS"
echo "=========================================="

# OS and uptime info (stretch goal)
echo -e "\n[System Information]"
echo "Hostname      : $(hostname)"
echo "OS Version    : $(grep '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d \")"
echo "Kernel Version: $(uname -r)"
echo "Uptime        : $(uptime -p)"
echo "Load Average  : $(uptime | awk -F'load average:' '{ print $2 }')"

# CPU Usage
echo -e "\n[CPU Usage]"
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
cpu_usage=$(echo "100 - $cpu_idle" | bc)
echo "Total CPU Usage: $cpu_usage%"

# Memory Usage
echo -e "\n[Memory Usage]"
free -h | awk 'NR==1 || NR==2 {print}'
mem_total=$(free | awk '/Mem:/ {print $2}')
mem_used=$(free | awk '/Mem:/ {print $3}')
mem_perc=$(echo "scale=2; $mem_used*100/$mem_total" | bc)
echo "Memory Usage: $mem_perc% used"

# Disk Usage
echo -e "\n[Disk Usage]"
df -h --total | grep total | awk '{printf "Total: %s | Used: %s | Avail: %s | Usage: %s\n", $2, $3, $4, $5}'

# Top 5 Processes by CPU
echo -e "\n[Top 5 Processes by CPU Usage]"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 Processes by Memory
echo -e "\n[Top 5 Processes by Memory Usage]"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# Optional Stretch: Logged in users
echo -e "\n[Logged-in Users]"
who

# Optional Stretch: Failed login attempts (if /var/log/auth.log exists)
if [ -f /var/log/auth.log ]; then
    echo -e "\n[Recent Failed Login Attempts]"
    grep "Failed password" /var/log/auth.log | tail -n 5
fi

echo "=========================================="
echo "        END OF SERVER PERFORMANCE STATS"
echo "=========================================="
