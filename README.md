# EV-ChargeGuard-BMS: Real-Time Intelligent EV Charging & Battery Safety System

## Overview

A comprehensive real-time system for managing multiple EV charging requests with dynamic battery fault detection, thermal hazard monitoring, and safe operation under grid power constraints.

## Features

- ✅ **Real-time Battery Monitoring**: Voltage, current, temperature, and cell-level fault detection
- ✅ **Dynamic Charging Queue Management**: Priority-based scheduling with starvation prevention
- ✅ **Thermal Safety**: Overheating detection and thermal runaway prevention
- ✅ **Grid Power Management**: Adaptive load allocation under power constraints
- ✅ **Charger Failure Detection**: Automatic fault recovery and fallback mechanisms
- ✅ **Emergency Shutdown**: Immediate interruption on critical conditions
- ✅ **Multi-EV Coordination**: Fair resource allocation and emergency prioritization

## System Requirements

### OS & Environment
- **Linux** (Ubuntu 20.04+, Debian 11+, or compatible)
- **VirtualBox** (tested and compatible)
- **RAM**: 2GB minimum, 4GB recommended
- **Storage**: 500MB for system + dependencies

### Core Dependencies

#### System Packages
```bash
sudo apt-get update
sudo apt-get install -y \
    python3.9 python3-pip python3-venv \
    build-essential gcc g++ cmake \
    git curl wget \
    libssl-dev libffi-dev python3-dev \
    can-utils \
    mosquitto mosquitto-clients \
    sqlite3 libsqlite3-dev
```

#### Python Dependencies
```bash
pip3 install -r requirements.txt
```

See `requirements.txt` for full list.

#### C/C++ (Optional but Recommended)
For real-time performance and integration with Linux kernel modules:
```bash
sudo apt-get install -y \
    linux-headers-$(uname -r) \
    clang clang-tools \
    gdb valgrind
```

## Quick Start

### 1. Clone & Setup
```bash
git clone https://github.com/santhoshrajan77/EV-ChargeGuard-BMS.git
cd EV-ChargeGuard-BMS
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. Run the System
```bash
python3 main.py
```

### 3. Run Unit Tests
```bash
python3 -m pytest tests/ -v
```

### 4. Run Simulation
```bash
python3 simulation/simulator.py --mode interactive
```

## Project Structure

```
EV-ChargeGuard-BMS/
├── README.md                          # This file
├── requirements.txt                   # Python dependencies
├── Makefile                           # Build automation
├── CMakeLists.txt                     # C/C++ build config
│
├── src/
│   ├── __init__.py
│   ├── main.py                        # Entry point
│   ├── core/
│   │   ├── battery_monitor.py         # Battery health & fault detection
│   │   ├── charger_manager.py         # Charger control & health
│   │   ├── scheduler.py               # EV queue & priority scheduling
│   │   ├── power_allocator.py         # Grid power management
│   │   └── safety_controller.py       # Emergency shutdown & safety rules
│   ├── models/
│   │   ├── ev_request.py              # EV request dataclass
│   │   ├── charger.py                 # Charger state & health
│   │   └── battery_health.py          # Battery metrics dataclass
│   ├── interfaces/
│   │   ├── can_interface.py           # CAN bus communication (optional)
│   │   ├── mqtt_interface.py          # MQTT pub/sub for remote monitoring
│   │   └── simulator_interface.py     # Simulation interface
│   └── utils/
│       ├── logger.py                  # Logging configuration
│       ├── config.py                  # System configuration
│       └── constants.py               # Constants & thresholds
│
├── c_modules/
│   ├── Makefile
│   ├── bms_kernel.c                   # Optional: Real-time C kernel module
│   ├── charger_driver.c               # Optional: Charger hardware driver
│   └── fault_detector.c               # Optional: Fast C-level fault detection
│
├── simulation/
│   ├── simulator.py                   # Main simulator
│   ├── ev_simulator.py                # EV behavior model
│   ├── grid_simulator.py              # Grid power model
│   ├── charger_simulator.py           # Charger fault injection
│   └── battery_model.py               # Realistic battery model
│
├── tests/
│   ├── __init__.py
│   ├── test_battery_monitor.py        # Battery logic tests
│   ├── test_scheduler.py              # Scheduler tests
│   ├── test_power_allocator.py        # Power allocation tests
│   ├── test_safety_controller.py      # Safety logic tests
│   └── test_integration.py            # End-to-end integration tests
│
├── config/
│   ├── default.yaml                   # Default system configuration
│   ├── thresholds.yaml                # Safety thresholds
│   └── simulation.yaml                # Simulation parameters
│
├── docs/
│   ├── ARCHITECTURE.md                # System architecture & design
│   ├── API.md                         # API reference
│   ├── INSTALL.md                     # Detailed installation guide
│   ├── USAGE.md                       # Usage examples & workflows
│   ├── SAFETY_REQUIREMENTS.md         # ISO 26262 & safety standards
│   └── FAULTS.md                      # Fault modes & handling
│
├── docker/
│   ├── Dockerfile                     # Docker image for system
│   └── docker-compose.yml             # Multi-container setup
│
├── examples/
│   ├── simple_charging_scenario.py    # Basic example
│   ├── multi_ev_simulation.py         # Multi-vehicle example
│   ├── fault_injection_test.py        # Test fault handling
│   └── thermal_stress_test.py         # Temperature stress scenario
│
└── .github/
    └── workflows/
        └── ci.yml                     # CI/CD pipeline
```

## Core Modules

### Battery Monitor (`src/core/battery_monitor.py`)
Monitors real-time battery health and detects faults:
- Over/under-voltage detection
- Thermal runaway prevention
- Cell imbalance monitoring
- State of Charge (SOC) & State of Health (SOH) estimation

### Charger Manager (`src/core/charger_manager.py`)
Manages charger lifecycle:
- Charger status & health tracking
- Failure detection & recovery
- Power output control

### Scheduler (`src/core/scheduler.py`)
Intelligent EV queue management:
- Priority-based assignment (Critical > High > Normal > Low)
- Fairness scoring to prevent starvation
- Waiting-time bonuses for aged requests

### Power Allocator (`src/core/power_allocator.py`)
Dynamic power distribution:
- Grid capacity enforcement
- Safety margin reservation
- Multi-charger coordination

### Safety Controller (`src/core/safety_controller.py`)
Emergency shutdown logic:
- Critical condition detection
- Failsafe state maintenance
- Comprehensive fault logging

## Fault Detection & Handling

### Battery Faults
| Fault | Threshold | Action |
|-------|-----------|--------|
| Over-voltage | > 420V | PAUSE |
| Under-voltage | < 250V | PAUSE |
| Over-temperature | > 60°C | PAUSE + COOL |
| Cell imbalance | ΔV > 0.25V | REBALANCE |
| Short circuit | I > 250A | IMMEDIATE STOP |

### Charger Faults
- No current flow despite power command
- Communication loss (CAN/MQTT timeout)
- Health score degradation
- Hardware malfunction signals

## Installation & Setup

### Option 1: Direct Installation (Recommended for VirtualBox)

```bash
# 1. Update system
sudo apt-get update && sudo apt-get upgrade -y

# 2. Install system dependencies
sudo apt-get install -y python3.9 python3-pip python3-venv build-essential

# 3. Clone repository
git clone https://github.com/santhoshrajan77/EV-ChargeGuard-BMS.git
cd EV-ChargeGuard-BMS

# 4. Create virtual environment
python3 -m venv venv
source venv/bin/activate

# 5. Install Python dependencies
pip install -r requirements.txt

# 6. Run system
python3 src/main.py
```

### Option 2: Docker (Isolated Environment)

```bash
cd docker
docker-compose up --build
```

### Option 3: Manual C/C++ Build (For Performance)

```bash
# Build C modules for real-time performance
cd c_modules
make clean && make all
cd ..

# Build main project
mkdir build && cd build
cmake ..
make
```

## Configuration

Edit `config/default.yaml` to customize:
- Grid power limits
- Charger specifications
- Battery safety thresholds
- Scheduling parameters

## Simulation & Testing

### Interactive Simulation
```bash
python3 simulation/simulator.py --mode interactive
```

### Scenario-based Testing
```bash
python3 examples/multi_ev_simulation.py
python3 examples/fault_injection_test.py
python3 examples/thermal_stress_test.py
```

### Unit Tests
```bash
python3 -m pytest tests/ -v --cov=src
```

## Performance Metrics

- **Fault Detection Latency**: < 100ms
- **Scheduling Decision Time**: < 50ms
- **Power Reallocation**: < 1 second
- **Queue Throughput**: 100+ EVs per hour
- **Starvation Prevention**: Max 30-minute wait guarantee

## Safety Standards Compliance

- ISO 26262 (Functional Safety)
- IEC 62660 (Battery Safety)
- SAE J1739 (Diagnostic Fault Definitions)
- IEEE 1547 (Grid Interconnection)

## API Endpoints (REST)

```bash
GET  /api/status              # System status
GET  /api/chargers            # Charger status
GET  /api/queue               # EV queue status
POST /api/ev/request          # Submit charging request
DELETE /api/ev/{ev_id}        # Cancel charging
GET  /api/battery/{ev_id}     # Battery telemetry
POST /api/emergency-stop      # Trigger emergency shutdown
```

## MQTT Topics

```
ev-charge/chargers/{charger_id}/status
ev-charge/chargers/{charger_id}/power
ev-charge/battery/{ev_id}/health
ev-charge/battery/{ev_id}/fault
ev-charge/grid/usage
ev-charge/system/alarm
```

## Troubleshooting

### Issue: "ModuleNotFoundError: No module named 'src'"
```bash
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
```

### Issue: Permission denied on CAN interface
```bash
sudo usermod -a -G can $USER
newgrp can
```

### Issue: MQTT connection failed
```bash
# Start Mosquitto broker
sudo systemctl start mosquitto
sudo systemctl enable mosquitto
```

## Development Workflow

1. Create feature branch: `git checkout -b feature/my-feature`
2. Make changes and commit: `git commit -am "description"`
3. Run tests: `pytest tests/`
4. Push and create PR: `git push origin feature/my-feature`
5. Merge after review

## Contributing

Contributions welcome! See `CONTRIBUTING.md` for guidelines.

## License

MIT License - See `LICENSE` file for details.

## Support & Documentation

- **Issues**: Report bugs on GitHub Issues
- **Discussions**: Join discussions for feature ideas
- **Documentation**: See `docs/` directory
- **Examples**: Check `examples/` for usage patterns

## Authors

- Santhosh Rajan (santhoshrajan77)

## Acknowledgments

Based on QNX eHACK 2026 Problem Statements for Battery Management Systems and EV Charging Load Management.
