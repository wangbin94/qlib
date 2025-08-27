# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Qlib is an open-source, AI-oriented quantitative investment platform that aims to realize the potential, empower research, and create value using AI technologies in quantitative investment. It provides a complete ML pipeline including data processing, model training, backtesting, and covers the entire chain of quantitative investment: alpha seeking, risk modeling, portfolio optimization, and order execution.

## Development Setup and Common Commands

### Docker Development Environment (Recommended)

**Quick Start:**
```bash
# Start the complete development environment
./docker-dev-scripts/start-dev.sh

# Connect to development container
docker exec -it qlib-dev bash

# Access services:
# - Jupyter Lab: http://localhost:8890
# - MLflow UI: http://localhost:5002
```

**Container Management:**
```bash
# Start specific services
docker-compose up -d qlib-dev              # Main development environment
docker-compose --profile jupyter-only up   # Jupyter Lab only (port 8889)
docker-compose --profile mlflow-only up    # MLflow UI only (port 5004)

# Stop environment
./docker-dev-scripts/stop-dev.sh
# or
docker-compose down

# View logs
docker-compose logs -f qlib-dev

# Rebuild containers
docker-compose build --no-cache qlib-dev
```

**Data Management:**
```bash
# Download data if needed
./docker-dev-scripts/download-data.sh

# The container automatically mounts your existing ~/.qlib data directory
# No data re-download needed if you already have data
```

**Development Workflow Inside Container:**
```bash
# Connect to container
docker exec -it qlib-dev bash

# Navigate to workspace
cd /workspace/qlib

# Run experiments
cd examples
qrun benchmarks/LightGBM/workflow_config_lightgbm_Alpha158.yaml

# Run with your IB data
qrun highfreq/workflow_config_IB_High_Freq_5min_Alpha158.yaml

# Development commands work normally
make lint
pytest tests/
python your_custom_script.py
```

### Native Installation (Alternative)
```bash
# Install prerequisite dependencies and compile Cython extensions
make prerequisite

# Install package in editable mode with all dependencies
make install

# Install for development with all optional dependencies
make dev
```

### Build and Compilation
```bash
# Clean build artifacts and caches
make clean

# Deep clean including virtual environment
make deepclean

# Build Python wheel package
make build
```

### Code Quality and Testing
```bash
# Run all linting checks (black, pylint, flake8, mypy, nbqa)
make lint

# Run individual linting tools
make black      # Code formatting check
make pylint     # Code analysis
make flake8     # Style guide enforcement
make mypy       # Type checking

# Run tests using pytest
pytest tests/
pytest tests/backtest/  # Run specific test directory
pytest -m "not slow"    # Skip slow tests
```

### Data Management
```bash
# Download and prepare data (community source)
python scripts/get_data.py qlib_data --target_dir ~/.qlib/qlib_data/cn_data --region cn

# Check data health
python scripts/check_data_health.py check_data --qlib_dir ~/.qlib/qlib_data/cn_data

# Dump data to binary format
python scripts/dump_bin.py dump_all
```

### Running Workflows

**Standard Benchmarks:**
```bash
# Run complete quant research workflow using qrun
cd examples
qrun benchmarks/LightGBM/workflow_config_lightgbm_Alpha158.yaml

# Try different models (25+ available)
qrun benchmarks/XGBoost/workflow_config_xgboost_Alpha158.yaml
qrun benchmarks/Transformer/workflow_config_transformer_Alpha158.yaml
qrun benchmarks/DoubleEnsemble/workflow_config_doubleensemble_Alpha158.yaml

# Run workflow in debug mode
python -m pdb qlib/workflow/cli.py examples/benchmarks/LightGBM/workflow_config_lightgbm_Alpha158.yaml
```

**High-Frequency Trading (IB Data):**
```bash
# Run high-frequency strategy with your IB data
cd examples  
qrun highfreq/workflow_config_IB_High_Freq_5min_Alpha158.yaml

# Test IB data format and availability
python -m pytest tests/data_mid_layer_tests/test_ib_data_format.py -v
```

**Interactive Brokers Data Conversion:**
```bash
# Convert IB CSV data to Qlib binary format
python scripts/dump_bin_ib.py dump_all \
  --csv_path /path/to/ib/csv/files \
  --qlib_dir ~/.qlib/qlib_data/ib_data/5min \
  --freq 5min \
  --date_field_name timestamp \
  --symbol_field_name symbol
```

## Architecture Overview

### Core Components

**Data Layer (`qlib/data/`)**
- `data.py`: Main data interface and feature computation engine
- `ops.py`: Financial operators and expressions for feature engineering
- `cache.py`: Caching system for performance optimization
- `dataset/`: Dataset abstractions and handlers
- `storage/`: Storage backends for data persistence
- `_libs/`: Cython extensions for performance-critical operations

**Model Layer (`qlib/model/`)**
- `base.py`: Base model interface and training framework
- `trainer.py`: Model training orchestration
- `meta/`: Meta-learning and model adaptation frameworks
- `riskmodel/`: Risk modeling components

**Workflow Layer (`qlib/workflow/`)**
- `cli.py`: Command-line interface and workflow execution (`qrun` command)
- `exp.py`: Experiment management and tracking
- `recorder.py`: MLflow-based experiment recording

**Backtest Layer (`qlib/backtest/`)**
- `backtest.py`: Backtesting engine
- `executor.py`: Order execution simulation
- `account.py`: Portfolio and account management
- `exchange.py`: Market simulation

**Strategy Layer (`qlib/strategy/`)**
- `base.py`: Strategy base classes
- Trading strategy implementations

**Reinforcement Learning (`qlib/rl/`)**
- `simulator.py`: RL environment simulation
- `order_execution/`: Order execution RL strategies
- `trainer/`: RL training frameworks

### Key Design Patterns

**Configuration System**: Centralized configuration through `qlib/config.py` supporting both client and server modes with dynamic configuration management.

**Provider Pattern**: Data providers abstract different data sources (local files, remote servers) through a unified interface.

**Handler Pattern**: Data handlers process raw data into features using configurable processors and feature expressions.

**Workflow Pattern**: YAML-based workflow configurations define complete ML pipelines from data loading to backtesting.

## Examples and Benchmarks

### Available Models (25+ Benchmarks)

**🌳 Tree-Based Models (Top Performers):**
- **LightGBM**: 9.01% annual return, IC=0.0448
- **XGBoost**: 7.80% annual return, IC=0.0498  
- **CatBoost**: 7.65% annual return, IC=0.0481
- **DoubleEnsemble**: 11.58% annual return, IC=0.0521 (Best overall)

**🧠 Deep Learning Models:**
- **LSTM/GRU**: Recurrent networks for sequential data
- **Transformer**: Attention-based sequence modeling
- **ALSTM**: Attention-enhanced LSTM
- **TRA**: Temporal Routing Adaptor
- **HIST**: Hierarchical Information Structure (9.87% annual return)
- **TabNet**: Attention-based tabular learning

**📈 Advanced Architectures:**
- **GATs**: Graph Attention Networks  
- **TCN**: Temporal Convolutional Networks
- **ADARNN**: Adaptive RNN for regime changes
- **TCTS**: Temporal Cross-sectional Attention
- **Localformer**: Local attention for time series

**🔢 Classical Baselines:**
- **Linear**: Linear regression baseline
- **MLP**: Multi-Layer Perceptron

Each benchmark includes:
- `workflow_config_*.yaml`: Complete pipeline configuration
- `requirements.txt`: Model-specific dependencies  
- `README.md`: Model description and performance metrics

## Data Organization

**Local Data Structure**:
```
~/.qlib/qlib_data/
├── cn_data/          # Chinese A-shares data (CSI300/CSI500)
├── us_data/          # US market data
└── ib_data/          # Interactive Brokers data
    ├── 5min/         # 5-minute bars
    ├── 15min/        # 15-minute bars
    ├── 30min/        # 30-minute bars
    └── 1d/           # Daily bars
```

**Available Data:**
- **Chinese Market**: CSI300, CSI500 stocks with Alpha158/Alpha360 features
- **US Market**: Standard US equities data
- **IB Data**: 16 liquid US ETFs/stocks (AAPL, AMD, SPY, QQQ, SOXL, etc.)

**Feature Datasets**:
- **Alpha158**: 158 hand-crafted technical indicators (better for tree models)
- **Alpha360**: 360 raw price/volume features (better for deep learning)

**Time Segments**:
- `train`: Training period (typically 2008-2014 or 2019-2021 for IB data)
- `valid`: Validation period (typically 2014-2016 or 2022 for IB data)  
- `test`: Test period (typically 2017-2020 or 2023-2024 for IB data)

## Special Configuration Notes

**Multi-frequency Support**: Qlib supports mixing different data frequencies (1min, 5min, daily) within the same workflow using frequency-aware handlers.

**Experiment Tracking**: MLflow integration for experiment management. Results stored in `mlruns/` directories.

**Cython Extensions**: Performance-critical operations in `qlib/data/_libs/` are implemented in Cython and require compilation via `make prerequisite`.

**Memory Management**: Built-in caching system with configurable cache levels for optimal memory usage during large-scale experiments.