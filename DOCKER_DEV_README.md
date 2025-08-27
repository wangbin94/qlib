# Qlib Docker Development Environment

This Docker Compose setup provides a complete development environment for Qlib with Jupyter Lab, MLflow tracking, and all necessary dependencies pre-installed.

## Quick Start

1. **Start the development environment:**
   ```bash
   ./docker-dev-scripts/start-dev.sh
   ```

2. **Access services:**
   - **Jupyter Lab**: http://localhost:8888
   - **MLflow UI**: http://localhost:5000

3. **Connect to development container:**
   ```bash
   docker exec -it qlib-dev /bin/bash
   ```

4. **Run a quick test:**
   ```bash
   cd examples
   qrun benchmarks/LightGBM/workflow_config_lightgbm_Alpha158.yaml
   ```

## Services

### Main Development Environment (`qlib-dev`)
- **Ports**: 8888 (Jupyter), 5000 (MLflow), 5001 (Flask)
- **Features**: 
  - Live code reloading (source mounted as volume)
  - Jupyter Lab with pre-configured notebooks
  - MLflow experiment tracking
  - All development dependencies installed
  - Interactive shell access

### Jupyter Only (`qlib-jupyter`)
- Dedicated Jupyter Lab service on port 8889
- Start with: `docker-compose --profile jupyter-only up`

### MLflow Only (`qlib-mlflow`)
- Standalone MLflow tracking server on port 5001
- Start with: `docker-compose --profile mlflow-only up`

### Data Downloader (`data-downloader`)
- Downloads and sets up Qlib data
- Start with: `docker-compose --profile data up data-downloader`

## Commands

### Development Scripts
```bash
# Start full development environment
./docker-dev-scripts/start-dev.sh

# Stop development environment  
./docker-dev-scripts/stop-dev.sh

# Download data only
./docker-dev-scripts/download-data.sh
```

### Docker Compose Commands
```bash
# Start main development environment
docker-compose up -d qlib-dev

# View logs
docker-compose logs -f qlib-dev

# Stop all services
docker-compose down

# Remove volumes (deletes data)
docker-compose down -v

# Rebuild containers
docker-compose build --no-cache
```

### Development Workflow
```bash
# Connect to container
docker exec -it qlib-dev /bin/bash

# Install in development mode (already done on startup)
make dev

# Run linting
make lint

# Run tests
pytest tests/

# Start experiment
cd examples
qrun benchmarks/LightGBM/workflow_config_lightgbm_Alpha158.yaml
```

## Data Management

### Data Location
- **Host**: Uses your existing `~/.qlib` directory
- **Container**: Mounted at `/root/.qlib/` (default Qlib location)
- **Data Path**: `/root/.qlib/qlib_data/cn_data` (Chinese market data)

### Data Download Options
1. **Use Existing**: If you have data in `~/.qlib`, it will be automatically mounted
2. **Download if Missing**: Run `./docker-dev-scripts/start-dev.sh` and choose to download
3. **Manual Download**: Run `./docker-dev-scripts/download-data.sh`

### Using Different Data Location
If your data is in a different location, modify `docker-compose.yml`:
```yaml
# Change ~/.qlib to your data path
volumes:
  - /path/to/your/qlib/data:/root/.qlib
```

## Configuration

### Environment Variables
Copy `.env.example` to `.env` and customize:
```bash
cp .env.example .env
# Edit .env as needed
```

### Key Variables
- `USER_ID`/`GROUP_ID`: File permission handling (Linux/macOS)
- `QLIB_DATA_PATH`: Data directory path
- `JUPYTER_TOKEN`: Jupyter access token (empty = no auth)

## Volume Mounts

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `.` | `/workspace/qlib` | Source code (live reload) |
| `~/.qlib` | `/root/.qlib` | Your existing Qlib data directory |
| `./mlruns` | `/workspace/qlib/mlruns` | MLflow experiment tracking |
| `./examples` | `/workspace/examples` | Example notebooks/configs |

## Development Tips

### Jupyter Lab
- No authentication required (development only!)
- Pre-installed with scientific Python stack
- Access examples via `/workspace/examples`

### Code Changes
- All changes to source code are immediately reflected
- No need to rebuild container for code changes
- Python packages installed in development mode

### Experiment Tracking
- MLflow UI shows all experiment runs
- Results persist in `./mlruns` directory
- Access at http://localhost:5000

### Performance
- Container runs with full CPU/memory access
- Cython extensions pre-compiled on startup
- Data cached in Docker volume for persistence

## Troubleshooting

### Port Conflicts
Change ports in `docker-compose.yml`:
```yaml
ports:
  - "8889:8888"  # Use different host port
```

### Permission Issues (Linux/macOS)
Set correct user IDs in `.env`:
```bash
USER_ID=$(id -u)
GROUP_ID=$(id -g)
```

### Data Issues
Check your data:
```bash
# Verify data exists on host
ls -la ~/.qlib/qlib_data/

# Re-download if needed
./docker-dev-scripts/download-data.sh
```

### Container Issues
Rebuild from scratch:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```