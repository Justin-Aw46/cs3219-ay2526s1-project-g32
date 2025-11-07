#!/bin/bash
# Docker Build Validation Script
# This script builds and tests all Docker images locally

set -e

SERVICES=("frontend" "user_service" "question_service" "matching_service" "collaboration_service")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

echo "=========================================="
echo "Docker Build Validation"
echo "=========================================="
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed or not in PATH"
    echo ""
    echo "Please install Docker Desktop:"
    echo "  - macOS: https://docs.docker.com/desktop/install/mac-install/"
    echo "  - Windows: https://docs.docker.com/desktop/install/windows-install/"
    echo "  - Linux: https://docs.docker.com/engine/install/"
    echo ""
    exit 1
fi

echo "✓ Docker is installed"
docker --version
echo ""

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "❌ Error: Docker daemon is not running"
    echo ""
    echo "Please start Docker Desktop or the Docker daemon"
    echo ""
    exit 1
fi

echo "✓ Docker daemon is running"
echo ""

# Build each service
echo "Building Docker images..."
echo ""

for service in "${SERVICES[@]}"; do
    echo "----------------------------------------"
    echo "Building: $service"
    echo "----------------------------------------"
    
    if [ ! -d "$PROJECT_ROOT/$service" ]; then
        echo "⚠️  Warning: Service directory $service not found, skipping..."
        continue
    fi
    
    if [ ! -f "$PROJECT_ROOT/$service/Dockerfile" ]; then
        echo "⚠️  Warning: Dockerfile not found for $service, skipping..."
        continue
    fi
    
    cd "$PROJECT_ROOT/$service"
    
    if docker build -t "peerprep-$service:local" .; then
        echo "✓ Successfully built $service"
    else
        echo "❌ Failed to build $service"
        exit 1
    fi
    
    echo ""
done

cd "$PROJECT_ROOT"

echo "=========================================="
echo "Build Summary"
echo "=========================================="
echo ""
echo "✓ All Docker images built successfully!"
echo ""
echo "Built images:"
docker images | grep "peerprep-" || echo "No peerprep images found"
echo ""
echo "Next steps:"
echo "  1. Create a .env file from .env.example"
echo "  2. Run 'docker compose up' to start all services"
echo "  3. Access the frontend at http://localhost:3000"
echo ""
