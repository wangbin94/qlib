#!/bin/bash

# Download Qlib Data using Docker

set -e

echo "📥 Downloading Qlib Data..."

# Run data downloader service
docker-compose --profile data up data-downloader

echo ""
echo "✅ Data download completed!"
echo ""
echo "📊 Data is now available in the 'qlib-data' Docker volume"
echo "🏃 You can now run experiments in the development environment"
echo ""