#!/bin/bash

# Server Performance Stats Script
# Author: Your Name
# Description: Analyzes basic server performance statistics

# Colors for better output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to print colored output
print_stat() {
    echo -e "${GREEN}$1:${NC} $2"
}

# Function to print warning/critical stats
print_warning() {
    echo -e "${YELLOW}$1:${NC} $2"
}

print_critical() {
    echo -e "${RED}$1:${NC} $2"
}

# Main header
echo -e "${PURPLE}========================================${NC}"
echo -e "${PURPLE}       SERVER PERFORMANCE STATS        ${NC}"
echo -e "${PURPLE}========================================${NC}"
echo -e "${CYAN}Generated on: $(date)${NC}"
echo -e "${CYAN}Hostname: $(hostname)${NC}"

# 1. SYSTEM INFORMATION (Stretch Goal)
print_header "SYSTEM INFORMATION"
print_stat "OS Version" "$(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
print_stat "Kernel Version" "$(uname -r)"
print_stat "Architecture" "$(uname -m)"
print_stat "Uptime" "$(uptime -p 2>/dev/null || uptime | awk '{print $3,$4}' | sed 's/,//')"

# 2. CPU USAGE
print_header "CPU USAGE"
# Get CPU usage (average over 1 second)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
if [ -z "$cpu_usage" ]; then
    # Alternative method for different systems
    cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage}' | cut -d'.' -f1)
fi

# Color code based on usage
if (( $(echo "$cpu_usage > 80" | bc -l 2>/dev/null || [ ${cpu_usage%.*} -gt 80 ] 2>/dev/null) )); then
    print_critical "Total CPU Usage" "${cpu_usage}%"
elif (( $(echo "$cpu_usage > 60" | bc -l 2>/dev/null || [ ${cpu_usage%.*} -gt 60 ] 2>/dev/null) )); then
    print_warning "Total CPU Usage" "${cpu_usage}%"
else
    print_stat "Total CPU Usage" "${cpu_usage}%"
fi

# Load Average
load_avg=$(uptime | awk -F'load average:' '{print $2}')
print_stat "Load Average" "$load_avg"

# 3. MEMORY USAGE
print_header "MEMORY USAGE"
# Get memory info from /proc/meminfo
mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_free=$(grep MemFree /proc/meminfo | awk '{print $2}')

# Calculate memory usage
mem_used=$((mem_total - mem_available))
mem_used_percent=$((mem_used * 100 / mem_total))
mem_free_percent=$((mem_available * 100 / mem_total))

# Convert to human readable format (MB/GB)
mem_total_mb=$((mem_total / 1024))
mem_used_mb=$((mem_used / 1024))
mem_available_mb=$((mem_available / 1024))

# Color code based on usage
if [ $mem_used_percent -gt 80 ]; then
    print_critical "Memory Used" "${mem_used_mb}MB (${mem_used_percent}%)"
elif [ $mem_used_percent -gt 60 ]; then
    print_warning "Memory Used" "${mem_used_mb}MB (${mem_used_percent}%)"
else
    print_stat "Memory Used" "${mem_used_mb}MB (${mem_used_percent}%)"
fi

print_stat "Memory Available" "${mem_available_mb}MB (${mem_free_percent}%)"
print_stat "Total Memory" "${mem_total_mb}MB"

# 4. DISK USAGE
print_header "DISK USAGE"
echo -e "${GREEN}Filesystem Usage:${NC}"
df -h | grep -E '^/dev/' | while read filesystem size used avail percent mount; do
    usage_num=$(echo $percent | sed 's/%//')
    if [ $usage_num -gt 80 ]; then
        echo -e "${RED}$filesystem${NC} | Size: $size | Used: $used (${percent}) | Available: $avail | Mount: $mount"
    elif [ $usage_num -gt 60 ]; then
        echo -e "${YELLOW}$filesystem${NC} | Size: $size | Used: $used (${percent}) | Available: $avail | Mount: $mount"
    else
        echo -e "${GREEN}$filesystem${NC} | Size: $size | Used: $used (${percent}) | Available: $avail | Mount: $mount"
    fi
done

# 5. TOP 5 PROCESSES BY CPU USAGE
print_header "TOP 5 PROCESSES BY CPU USAGE"
echo -e "${GREEN}PID\tUSER\t%CPU\t%MEM\tCOMMAND${NC}"
ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "%-8s %-10s %-6s %-6s %s\n", $2, $1, $3, $4, $11}'

# 6. TOP 5 PROCESSES BY MEMORY USAGE
print_header "TOP 5 PROCESSES BY MEMORY USAGE"
echo -e "${GREEN}PID\tUSER\t%CPU\t%MEM\tCOMMAND${NC}"
ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "%-8s %-10s %-6s %-6s %s\n", $2, $1, $3, $4, $11}'

# 7. ADDITIONAL STATS (Stretch Goals)
print_header "ADDITIONAL STATISTICS"

# Logged in users
logged_users=$(who | wc -l)
print_stat "Currently Logged Users" "$logged_users"
if [ $logged_users -gt 0 ]; then
    echo -e "${GREEN}Active Sessions:${NC}"
    who | awk '{print "  " $1 " - " $2 " (" $3 " " $4 ")"}'
fi

# Network connections
active_connections=$(netstat -tn 2>/dev/null | grep ESTABLISHED | wc -l)
print_stat "Active Network Connections" "$active_connections"

# Failed login attempts (last 10)
print_stat "Recent Failed Login Attempts" "$(lastb -n 10 2>/dev/null | wc -l)"

# System processes
total_processes=$(ps aux | wc -l)
running_processes=$(ps aux | awk '$8 ~ /^R/ {count++} END {print count+0}')
print_stat "Total Processes" "$total_processes"
print_stat "Running Processes" "$running_processes"

# Last reboot
last_reboot=$(who -b 2>/dev/null | awk '{print $3, $4}' || last reboot -1 | head -1 | awk '{print $5, $6, $7, $8}')
print_stat "Last System Reboot" "$last_reboot"

echo -e "\n${PURPLE}========================================${NC}"
echo -e "${PURPLE}           END OF REPORT               ${NC}"
echo -e "${PURPLE}========================================${NC}"
