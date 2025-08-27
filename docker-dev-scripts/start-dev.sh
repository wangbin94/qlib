#!/bin/bash

# Start Qlib Development Environment
# This script provides an easy way to start the development environment

set -e

echo "🚀 Starting Qlib Development Environment..."

# Check if .env file exists, create from example if not
if [ ! -f .env ]; then
    echo "📋 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✏️  Please edit .env file to customize your environment"
fi

# Check if data directory exists
if [ ! -d ~/.qlib/qlib_data ]; then
    echo "💾 Qlib data directory not found at ~/.qlib/qlib_data"
    read -p "Would you like to download sample data? (y/n): " download_data
    if [ "$download_data" = "y" ] || [ "$download_data" = "Y" ]; then
        echo "📥 Downloading Qlib data..."
        docker-compose --profile data up data-downloader
    else
        echo "⚠️  Note: You may need to download data manually or experiments may fail"
        echo "   You can run: ./docker-dev-scripts/download-data.sh later"
    fi
else
    echo "✅ Found existing Qlib data at ~/.qlib/qlib_data"
fi

# Start the main development environment
echo "🛠️  Starting development containers..."
docker-compose up -d qlib-dev

echo ""
echo "✅ Development environment is ready!"
echo ""
echo "🔗 Available Services:"
echo "   • Jupyter Lab: http://localhost:8888"
echo "   • MLflow UI: http://localhost:5000"
echo ""
echo "💻 Connect to development container:"
echo "   docker exec -it qlib-dev /bin/bash"
echo ""
echo "📋 Useful commands:"
echo "   • View logs: docker-compose logs -f qlib-dev"
echo "   • Stop: docker-compose down"
echo "   • Restart: docker-compose restart qlib-dev"
echo ""
echo "📚 Quick start:"
echo "   cd examples"
echo "   qrun benchmarks/LightGBM/workflow_config_lightgbm_Alpha158.yaml"
echo ""