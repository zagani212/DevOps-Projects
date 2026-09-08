#!/bin/bash

# Spring Boot Login App - Setup and Run Script
# This script sets up the database and runs the application

echo "╔═════════════════════════════════════════════════════════════════╗"
echo "║     Spring Boot Login Application - Setup & Run                ║"
echo "╚═════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Check prerequisites
echo -e "${YELLOW}[1/4] Checking prerequisites...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}✗ Java not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Java installed${NC}"

if ! command -v mvn &> /dev/null; then
    echo -e "${RED}✗ Maven not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Maven installed${NC}"

if ! command -v mysql &> /dev/null; then
    echo -e "${RED}✗ MySQL not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ MySQL installed${NC}"
echo ""

# Step 2: Setup database
echo -e "${YELLOW}[2/4] Setting up database...${NC}"
echo -e "${YELLOW}NOTE: You may be prompted for sudo password${NC}"
echo ""

# Try without sudo first
mysql -u root -e "SELECT 1;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ MySQL root accessible${NC}"
    mysql -u root << 'EOF'
DROP DATABASE IF EXISTS logindb;
CREATE DATABASE logindb;
USE logindb;
EOF
else
    echo -e "${YELLOW}Trying with sudo...${NC}"
    sudo mysql -u root << 'EOF'
DROP DATABASE IF EXISTS logindb;
CREATE DATABASE logindb;
USE logindb;
EOF
fi

echo -e "${GREEN}✓ Database created${NC}"
echo ""

# Step 3: Build application
echo -e "${YELLOW}[3/4] Building application...${NC}"
mvn clean package -DskipTests > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi
echo ""

# Step 4: Run application
echo -e "${YELLOW}[4/4] Starting application...${NC}"
echo ""
echo -e "${GREEN}Application will start in a moment...${NC}"
echo -e "${YELLOW}Open browser at: http://localhost:8080${NC}"
echo ""
echo "Press Ctrl+C to stop the application"
echo ""

mvn spring-boot:run
