#!/bin/bash

echo "=========================================="
echo "  AI Voice IVR Setup Verification"
echo "=========================================="
echo ""

# Check Go
echo -n "✓ Go: "
if command -v go &> /dev/null; then
    go version
else
    echo "❌ NOT INSTALLED"
fi

# Check Docker
echo -n "✓ Docker: "
if command -v docker &> /dev/null; then
    docker --version
else
    echo "❌ NOT INSTALLED"
fi

# Check Docker Compose
echo -n "✓ Docker Compose: "
if docker compose version &> /dev/null; then
    docker compose version
else
    echo "❌ NOT INSTALLED"
fi

# Check Git
echo -n "✓ Git: "
if command -v git &> /dev/null; then
    git --version
else
    echo "❌ NOT INSTALLED"
fi

# Check Make
echo -n "✓ Make: "
if command -v make &> /dev/null; then
    make --version | head -n1
else
    echo "❌ NOT INSTALLED"
fi

# Check curl
echo -n "✓ curl: "
if command -v curl &> /dev/null; then
    curl --version | head -n1
else
    echo "❌ NOT INSTALLED"
fi

echo ""
echo "=========================================="
echo "  System Resources"
echo "=========================================="
echo ""
echo "Memory:"
free -h | grep Mem | awk '{print "  Total: " $2 ", Available: " $7}'
echo ""
echo "Disk Space:"
df -h / | tail -n1 | awk '{print "  Total: " $2 ", Used: " $3 ", Available: " $4}'

echo ""
echo "=========================================="
echo "  Installation Complete! ✅"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Log out and log back in (or run: newgrp docker)"
echo "2. Create project structure"
echo "3. Set up Docker Compose"
echo ""
