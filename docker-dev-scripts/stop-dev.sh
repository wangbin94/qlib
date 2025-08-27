#!/bin/bash

# Stop Qlib Development Environment

set -e

echo "🛑 Stopping Qlib Development Environment..."

# Stop all services
docker-compose down

echo ""
echo "✅ Development environment stopped!"
echo ""
echo "📋 Useful commands:"
echo "   • Remove volumes: docker-compose down -v"
echo "   • Clean up images: docker system prune"
echo "   • Restart: ./docker-dev-scripts/start-dev.sh"
echo ""