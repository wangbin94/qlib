# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Qlib is an open-source, AI-oriented quantitative investment platform that aims to realize the potential, empower research, and create value using AI technologies in quantitative investment. It provides a complete ML pipeline including data processing, model training, backtesting, and covers the entire chain of quantitative investment: alpha seeking, risk modeling, portfolio optimization, and order execution.

## Development Setup and Common Commands

### Prerequisites and Installation
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
```bash
# Run complete quant research workflow using qrun
cd examples
qrun benchmarks/LightGBM/workflow_config_lightgbm_Alpha158.yaml

# Run workflow in debug mode
python -m pdb qlib/workflow/cli.py examples/benchmarks/LightGBM/workflow_config_lightgbm_Alpha158.yaml
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

The `examples/benchmarks/` directory contains implementations of various quantitative models:
- **Tree-based**: LightGBM, XGBoost, CatBoost
- **Neural Networks**: LSTM, GRU, Transformer variants, TabNet
- **Specialized**: HIST, TRA, ADARNN, DoubleEnsemble

Each benchmark includes:
- `workflow_config_*.yaml`: Complete pipeline configuration
- `requirements.txt`: Model-specific dependencies
- `README.md`: Model description and usage

## Data Organization

**Local Data Structure**:
```
~/.qlib/qlib_data/cn_data/   # Chinese market data
~/.qlib/qlib_data/us_data/   # US market data (if available)
```

**Feature Datasets**:
- **Alpha158**: 158 technical indicators for daily frequency
- **Alpha360**: 360 features including cross-sectional and time-series factors

**Segments**:
- `train`: Training period (typically 2008-2014)
- `valid`: Validation period (typically 2014-2016)
- `test`: Test period (typically 2017-2020)

## Special Configuration Notes

**Multi-frequency Support**: Qlib supports mixing different data frequencies (1min, 5min, daily) within the same workflow using frequency-aware handlers.

**Experiment Tracking**: MLflow integration for experiment management. Results stored in `mlruns/` directories.

**Cython Extensions**: Performance-critical operations in `qlib/data/_libs/` are implemented in Cython and require compilation via `make prerequisite`.

**Memory Management**: Built-in caching system with configurable cache levels for optimal memory usage during large-scale experiments.