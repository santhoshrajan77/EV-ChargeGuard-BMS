# Installation Guide - EV-ChargeGuard-BMS

## For Linux (VirtualBox)

### Prerequisites
- Ubuntu 20.04 LTS or later (recommended)
- 2GB RAM minimum
- 500MB free disk space
- Internet connection

### Step 1: Update System Packages
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### Step 2: Install Core Dependencies

#### Python & Development Tools
```bash
sudo apt-get install -y \
    python3.9 \
    python3-pip \
    python3-venv \
    build-essential \
    gcc \
    g++ \
    cmake \
    git \
    curl \
    wget
```

#### Optional: CAN Bus Support (for real charger integration)
```bash
sudo apt-get install -y can-utils linux-headers-$(uname -r)
```

#### Optional: MQTT Broker (for remote monitoring)
```bash
sudo apt-get install -y mosquitto mosquitto-clients
sudo systemctl start mosquitto
sudo systemctl enable mosquitto
```

#### Optional: Database
```bash
sudo apt-get install -y sqlite3 libsqlite3-dev postgresql postgresql-contrib
```

### Step 3: Clone Repository
```bash
cd /opt  # or your preferred directory
git clone https://github.com/santhoshrajan77/EV-ChargeGuard-BMS.git
cd EV-ChargeGuard-BMS
```

### Step 4: Setup Python Virtual Environment
```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip setuptools wheel
```

### Step 5: Install Python Dependencies
```bash
pip install -r requirements.txt
```

### Step 6: Verify Installation
```bash
# Test imports
python3 -c "import src; print('✓ Installation successful!')"

# Run quick test
python3 -m pytest tests/test_battery_monitor.py -v
```

### Step 7: (Optional) Build C/C++ Modules
For improved real-time performance:

```bash
# Install additional C/C++ dependencies
sudo apt-get install -y libc6-dev libpthread-stubs0-dev

# Build
mkdir build
cd build
cmake ..
make -j$(nproc)
cd ..
```

## Verification Checklist

- [ ] Python 3.9+ installed: `python3 --version`
- [ ] Virtual environment activated: `which python` shows `.../venv/bin/python`
- [ ] Dependencies installed: `pip list | grep -E 'paho|yaml|pytest'`
- [ ] Repository cloned: `ls -la EV-ChargeGuard-BMS/`
- [ ] System tests pass: `pytest tests/ -v`

## Troubleshooting

### "Permission denied" errors
```bash
# Add user to system groups
sudo usermod -a -G can $USER
sudo usermod -a -G dialout $USER
newgrp can
```

### "Module not found" errors
```bash
# Ensure venv is activated
source venv/bin/activate

# Reinstall dependencies
pip install --force-reinstall -r requirements.txt
```

### CAN interface not found
```bash
# Check CAN interface
ip link show | grep can

# Create virtual CAN interface for testing
sudo ip link add type vcan
sudo ip link set vcan0 up
```

### MQTT connection failed
```bash
# Check mosquitto status
sudo systemctl status mosquitto

# Restart if needed
sudo systemctl restart mosquitto

# Test MQTT
mosquitto_pub -h localhost -t test -m "hello"
mosquitto_sub -h localhost -t test
```

## First Run

```bash
# Activate environment
source venv/bin/activate

# Run main system
python3 src/main.py

# In another terminal, run simulator
python3 simulation/simulator.py --mode interactive
```

## Docker Installation (Alternative)

If you prefer containerized environment:

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Build & run
cd docker
docker-compose up --build
```

## Next Steps

1. Read `README.md` for feature overview
2. Check `docs/USAGE.md` for usage examples
3. Run `examples/` scripts to understand system
4. Review `config/default.yaml` for configuration
5. See `docs/ARCHITECTURE.md` for deep dive
