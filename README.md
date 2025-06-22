# server-performance-stats

# Server Performance Stats

A comprehensive shell script to analyze and display server performance statistics on Linux systems.

## 📋 Project Overview

This project provides a detailed analysis of server performance metrics including CPU usage, memory consumption, disk utilization, and process information. Perfect for system administrators and DevOps engineers who need quick insights into server health.

## ✨ Features

### Core Requirements
- **CPU Usage**: Real-time total CPU utilization with color-coded warnings
- **Memory Usage**: Detailed RAM usage statistics (used/available/total with percentages)  
- **Disk Usage**: File system usage for all mounted drives with capacity warnings
- **Top 5 CPU Processes**: Most CPU-intensive processes currently running
- **Top 5 Memory Processes**: Most memory-consuming processes

### Bonus Features (Stretch Goals)
- **System Information**: OS version, kernel, architecture, uptime
- **Load Average**: System load averages (1, 5, 15 minutes)
- **User Sessions**: Currently logged-in users and their sessions
- **Network Stats**: Active network connections
- **Security Info**: Recent failed login attempts
- **Process Summary**: Total and running process counts
- **System History**: Last reboot information

## 🚀 Quick Start

### Prerequisites
- Linux server (Ubuntu, CentOS, RHEL, etc.)
- Bash shell (pre-installed on most Linux systems)
- Basic system commands: `ps`, `df`, `free`, `top`, `who`, `netstat`

### Installation & Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/server-performance-stats.git
   cd server-performance-stats
   ```

2. **Make the script executable:**
   ```bash
   chmod +x server-stats.sh
   ```

3. **Run the script:**
   ```bash
   ./server-stats.sh
   ```

## 📊 Sample Output

```
========================================
       SERVER PERFORMANCE STATS        
========================================
Generated on: Sun Jun 22 10:30:45 UTC 2025
Hostname: web-server-01

================================
 SYSTEM INFORMATION
================================
OS Version: Ubuntu 20.04.3 LTS
Kernel Version: 5.4.0-74-generic
Architecture: x86_64
Uptime: up 2 days, 4 hours, 23 minutes

================================
 CPU USAGE
================================
Total CPU Usage: 15.2%
Load Average:  0.45, 0.52, 0.48

================================
 MEMORY USAGE
================================
Memory Used: 3250MB (65%)
Memory Available: 1750MB (35%)
Total Memory: 5000MB

================================
 DISK USAGE
================================
Filesystem Usage:
/dev/xvda1 | Size: 20G | Used: 12G (60%) | Available: 7.2G | Mount: /
/dev/xvda2 | Size: 100G | Used: 45G (45%) | Available: 50G | Mount: /data
```

## 🎨 Color Coding

The script uses intuitive color coding for quick status assessment:

- **🟢 Green**: Normal/Good status
- **🟡 Yellow**: Warning status (60-80% usage)  
- **🔴 Red**: Critical status (>80% usage)
- **🔵 Blue**: Headers and information
- **🟣 Purple**: Main title and decorative elements

## 🔧 Customization

### Modifying Thresholds
Edit the threshold values in the script:
```bash
# CPU Warning at 60%, Critical at 80%
if [ "$cpu_usage" -gt 80 ]; then
    print_critical "Total CPU Usage" "${cpu_usage}%"
elif [ "$cpu_usage" -gt 60 ]; then
    print_warning "Total CPU Usage" "${cpu_usage}%"
```

### Adding Custom Metrics
Add your own monitoring functions:
```bash
# Custom function example
print_header "CUSTOM METRICS"
custom_metric=$(your_command_here)
print_stat "Custom Metric" "$custom_metric"
```

## 🖥️ Tested On

- ✅ Ubuntu 18.04, 20.04, 22.04
- ✅ CentOS 7, 8
- ✅ Amazon Linux 2
- ✅ RHEL 7, 8
- ✅ Debian 9, 10, 11

## 🔒 Permissions Required

The script runs with regular user permissions. Some features may require elevated privileges:

- **Failed login attempts**: May need sudo access to `/var/log/btmp`
- **All network connections**: Works with user permissions
- **Process information**: Available to all users

## 📝 Example Use Cases

1. **Regular Health Checks**: Run during daily server maintenance
2. **Troubleshooting**: Quick diagnosis when server issues arise  
3. **Capacity Planning**: Monitor resource usage trends
4. **Automated Monitoring**: Integration with cron jobs or monitoring systems
5. **Documentation**: Generate reports for system documentation

## 🔄 Automation

### Cron Job Setup
Run automatically every hour:
```bash
# Edit crontab
crontab -e

# Add this line to run every hour and save to log
0 * * * * /path/to/server-stats.sh >> /var/log/server-stats.log 2>&1
```

### Integration with Monitoring
Pipe output to monitoring systems:
```bash
./server-stats.sh | curl -X POST -d @- http://your-monitoring-endpoint
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by system monitoring tools like htop, top, and iostat
- Built for the DevOps and system administration community
- Thanks to all contributors and users providing feedback

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/server-performance-stats/issues) section
2. Create a new issue with detailed information
3. Include your OS version and error messages

---

**Project URL**: https://github.com/yourusername/server-performance-stats

Made with ❤️ for the DevOps community
