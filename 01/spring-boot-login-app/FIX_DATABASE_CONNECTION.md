# 🔧 Fix Database Connection Issue

The application failed to connect to MySQL with error:
```
Access denied for user 'root'@'localhost'
```

This is a common issue on WSL/Linux. Follow the steps below to fix it.

## ✅ Solution Options

### Option 1: Using Socket Authentication (Recommended for WSL)

WSL often uses socket authentication for the root user. Try connecting this way:

```bash
# Connect to MySQL with socket
mysql -u root

# If that works, create the database
CREATE DATABASE logindb;
EXIT;
```

Then update the application configuration:

**File:** `src/main/resources/application.properties`

Change this section:
```properties
# Old (if using password)
spring.datasource.url=jdbc:mysql://localhost:3306/logindb
spring.datasource.username=root
spring.datasource.password=root
```

To this:
```properties
# New (for socket auth on WSL)
spring.datasource.url=jdbc:mysql:///logindb?allowPublicKeyRetrieval=true&useSSL=false
spring.datasource.username=root
spring.datasource.password=
```

### Option 2: Set MySQL Root Password

If you want to set a password for MySQL root user:

```bash
# Access MySQL without password (socket auth)
mysql -u root

# Set password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_password';
FLUSH PRIVILEGES;
EXIT;

# Create database
mysql -u root -p
# Enter password when prompted
CREATE DATABASE logindb;
EXIT;
```

Then update `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/logindb
spring.datasource.username=root
spring.datasource.password=your_password
```

### Option 3: Create a New User

For better security, create a dedicated application user:

```bash
# Connect to MySQL (socket auth)
mysql -u root

# Create new user and database
CREATE DATABASE logindb;
CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'apppassword';
GRANT ALL PRIVILEGES ON logindb.* TO 'appuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Then update `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/logindb
spring.datasource.username=appuser
spring.datasource.password=apppassword
```

---

## 🚀 Quick Start After Fixing

Once you've set up the database:

```bash
# 1. Build the application
mvn clean package -DskipTests

# 2. Run the application
mvn spring-boot:run

# 3. Open browser
http://localhost:8080
```

---

## ✅ Verification Checklist

After setting up, verify:

```bash
# 1. Can you connect to MySQL?
mysql -u root
(or mysql -u root -p if using password)

# 2. Does the database exist?
SHOW DATABASES;
# Should show: logindb

# 3. Can you see the users table?
USE logindb;
SHOW TABLES;
# After running the app, should show: users

# 4. Can you see created users?
SELECT * FROM users;
```

---

## 🐛 Still Having Issues?

### Check if MySQL is running:
```bash
sudo service mysql status
# or
sudo systemctl status mysql
```

### Start MySQL if not running:
```bash
sudo service mysql start
# or
sudo systemctl start mysql
```

### Check MySQL version:
```bash
mysql --version
```

### View MySQL error log:
```bash
sudo tail -f /var/log/mysql/error.log
```

### Reset MySQL (if needed):
```bash
# This will reset MySQL - use with caution!
sudo mysql_install_db --user=mysql
sudo service mysql restart
mysql -u root
# Now create the database as shown above
```

---

## 📝 Updated Configuration

The `application.properties` has been updated with:

```properties
# Multi-platform compatible
spring.datasource.url=jdbc:mysql://localhost:3306/logindb?serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false

# Try these in order:
# 1. Socket auth (no password needed on WSL)
spring.datasource.password=

# 2. Or if using password:
# spring.datasource.password=your_password
```

---

## 🎯 Choose Your Path

**Path A: Quick (Socket Auth)**
```bash
mysql -u root
CREATE DATABASE logindb;
EXIT;
# Then run: mvn spring-boot:run
```

**Path B: Secure (New User)**
```bash
mysql -u root
CREATE DATABASE logindb;
CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL ON logindb.* TO 'appuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
# Update application.properties with appuser credentials
# Then run: mvn spring-boot:run
```

---

**After completing one of the above paths, the application should start successfully!**

Need help? Check the error log or MySQL documentation for your specific system.
