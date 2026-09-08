#!/bin/bash

# Database Setup Script
# Run this with: sudo bash SETUP_DATABASE.sh

echo "================================"
echo "Spring Boot Login App - DB Setup"
echo "================================"
echo ""

# Create database and user
sudo mysql -u root << 'EOF'
-- Create database
CREATE DATABASE IF NOT EXISTS logindb;

-- Create application user (no password, local only)
DROP USER IF EXISTS 'appuser'@'localhost';
CREATE USER 'appuser'@'localhost' IDENTIFIED WITH auth_socket;

-- Grant permissions
GRANT ALL PRIVILEGES ON logindb.* TO 'appuser'@'localhost';
FLUSH PRIVILEGES;

-- Verify
SELECT 'Database and user created!' as status;
SHOW DATABASES;
EOF

echo ""
echo "✓ Database setup complete!"
echo ""
echo "Next steps:"
echo "1. Update application.properties with:"
echo "   spring.datasource.username=appuser"
echo "   spring.datasource.password="
echo ""
echo "2. Build: mvn clean package -DskipTests"
echo "3. Run: mvn spring-boot:run"
echo ""
