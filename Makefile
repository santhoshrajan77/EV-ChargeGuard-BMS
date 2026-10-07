.PHONY: help install setup test run clean lint format install-dev docker-build docker-run

help:
	@echo "EV-ChargeGuard-BMS - Build & Development Commands"
	@echo ""
	@echo "Setup:"
	@echo "  make install       - Install dependencies"
	@echo "  make setup         - Complete system setup (Python + C modules)"
	@echo "  make install-dev   - Install dev dependencies (testing, linting)"
	@echo ""
	@echo "Development:"
	@echo "  make run           - Run main system"
	@echo "  make simulate      - Run interactive simulator"
	@echo "  make test          - Run unit tests"
	@echo "  make lint          - Run code quality checks"
	@echo "  make format        - Auto-format code"
	@echo ""
	@echo "Build:"
	@echo "  make build         - Build C/C++ modules (if CMake available)"
	@echo "  make clean         - Remove build artifacts"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build  - Build Docker image"
	@echo "  make docker-run    - Run in Docker container"

install:
	@echo "Installing Python dependencies..."
	pip install -r requirements.txt

setup: install
	@echo "Setting up virtual environment..."
	python3 -m venv venv
	. venv/bin/activate && pip install -r requirements.txt
	@echo "Setup complete! Run 'source venv/bin/activate' to activate venv."

install-dev: install
	@echo "Installing development dependencies..."
	pip install pytest pytest-cov pytest-asyncio black flake8 pylint mypy

run:
	@echo "Starting EV-ChargeGuard-BMS..."
	python3 src/main.py

simulate:
	@echo "Starting interactive simulator..."
	python3 simulation/simulator.py --mode interactive

test:
	@echo "Running unit tests..."
	python3 -m pytest tests/ -v --cov=src --cov-report=html
	@echo "Coverage report generated in htmlcov/index.html"

lint:
	@echo "Running code quality checks..."
	flake8 src/ --max-line-length=120 --ignore=E501,W503
	pylint src/ --disable=C0114,C0115,C0116
	mypy src/ --ignore-missing-imports

format:
	@echo "Auto-formatting code with Black..."
	black src/ tests/ simulation/ examples/ --line-length=120

clean:
	@echo "Cleaning build artifacts..."
	rm -rf build/ dist/ *.egg-info
	rm -rf .pytest_cache .coverage htmlcov/
	rm -rf __pycache__ **/__pycache__
	find . -type d -name '.mypy_cache' -exec rm -rf {} +

.PHONY: all
all: clean install test lint
	docker-build:
	@echo "Building Docker image..."
	cd docker && docker build -t ev-chargeguard-bms:latest .

docker-run: docker-build
	@echo "Running in Docker container..."
	docker run -it --rm ev-chargeguard-bms:latest
