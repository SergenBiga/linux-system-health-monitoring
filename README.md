# linux-system-health-monitoring
Linux System Health Monitoring &amp; Self-Healing (Bash, Prometheus, Grafana)

# Linux System Health Monitoring & Self-Healing

A lightweight, production-oriented Linux system monitoring and self-healing solution built with **Bash**, **systemd**, **cron**, **Prometheus**, and **Grafana**.

This project focuses on real-world operational scenarios rather than simple metric collection, simulating how system health, alerting, and recovery are handled in production environments.

---

## Features

### System Resource Monitoring
- CPU usage monitoring (core-aware, percentage-based)
- Disk usage monitoring with configurable thresholds
- Memory utilization monitoring
- Load average and IO wait detection
- Network connectivity and latency checks (ICMP)

### Service Health Monitoring
- systemd-based health checks for critical services:
  - SSH
  - NGINX
  - Docker
- Service state evaluation using `node_systemd_unit_state`

### Alerting & Validation
- Threshold-based warning and critical alerts
- Alert lifecycle validation (`pending`, `firing`, `resolved`)
- Controlled fault injection using CPU stress tests
- Alert correlation with structured system logs

### Self-Healing (Controlled)
- Optional self-healing for selected services (NGINX, Docker)
- Single restart attempt per failure
- Post-restart verification
- Explicit logging of recovery (`RECOVERED`) or failure (`FAILED`)

### Configuration-Driven Design
- All thresholds and behavioral parameters are externalized
- Environment-specific tuning without modifying scripts
- Safe defaults when configuration is missing

---

## Project Structure

```text
linux-system-health-monitoring/
├── install.sh
├── README.md
├── scripts/
│   ├── system_health.sh
│   ├── check_cpu.sh
│   ├── check_disk.sh
│   ├── check_memory.sh
│   ├── check_load_iowait.sh
│   ├── check_network.sh
│   └── check_services_csv.sh
├── config/
│   └── thresholds.conf
└── logs/
    └── .gitkeep
