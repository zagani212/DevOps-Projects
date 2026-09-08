#!/bin/bash

# Spring Boot Login Application Setup Script
# This script sets up the application and database

set -e

echo "================================"
echo "Spring Boot Login App Setup"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${YELLOW}[1/5] Checking prerequisites...${NC}"

if ! command -v java &> /dev/null; then
    echo -e "${RED}✗ Java not found. Please install Java 11 or higher${NC}"
    exit 1
fi
JAVA_VERSION=$(java -version 2>&1 | grep -oP 'version "\K.*?(?=")')
echo -e "${GREEN}✓ Java $JAVA_VERSION${NC}"

if ! command -v mvn &> /dev/null; then
    echo -e "${RED}✗ Maven not found. Please install Maven 3.6 or higher${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Maven installed${NC}"

if ! command -v mysql &> /dev/null; then
    echo -e "${RED}✗ MySQL not found. Please install MySQL 5.7 or higher${NC}"
    exit 1
fi
echo -e "${GREEN}✓ MySQL installed${NC}"
echo ""

# Create database
echo -e "${YELLOW}[2/5] Setting up MySQL database...${NC}"
sudo mysql -u root -p << 'EOF'
DROP DATABASE IF EXISTS logindb;
CREATE DATABASE logindb;
USE logindb;
SELECT 'Database created successfully!' as status;
EOF
echo -e "${GREEN}✓ Database 'logindb' created${NC}"
echo ""

# Update database credentials (optional)
echo -e "${YELLOW}[3/5] Configuring database credentials...${NC}"
echo -e "${YELLOW}Using default: username=root, password=root${NC}"
echo -e "${YELLOW}To change, edit: src/main/resources/application.properties${NC}"
echo ""

# Build application
echo -e "${YELLOW}[4/5] Building application (this may take a few minutes)...${NC}"
mvn clean package -DskipTests
echo -e "${GREEN}✓ Build completed successfully${NC}"
echo ""

# Summary
echo -e "${YELLOW}[5/5] Setup Summary${NC}"
echo -e "${GREEN}✓ Java version: $JAVA_VERSION${NC}"
echo -e "${GREEN}✓ Maven build: Successful${NC}"
echo -e "${GREEN}✓ Database: logindb created${NC}"
echo ""

echo "================================"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo "================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Start the application:"
echo -e "   ${GREEN}mvn spring-boot:run${NC}"
echo ""
echo "2. Open browser:"
echo -e "   ${GREEN}http://localhost:8080${NC}"
echo ""
echo "3. Test features:"
echo "   - Register a new user"
echo "   - Login with credentials"
echo "   - View dashboard"
echo "   - Logout"
echo ""
echo "For more information, see QUICK_START.md"
echo ""
