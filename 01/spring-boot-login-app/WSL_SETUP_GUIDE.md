# 🔧 WSL MySQL Setup Guide

Since you can connect with `sudo mysql -u root`, follow these exact steps:

## ✅ Step 1: Create Database

Open your terminal and run:

```bash
sudo mysql -u root
```

Then paste this SQL (all at once):

```sql
DROP DATABASE IF EXISTS logindb;
CREATE DATABASE logindb;
USE logindb;
SELECT 'Database created successfully!' as status;
EXIT;
```

**Expected output:**
```
Database created successfully!
```

---

## ✅ Step 2: Build the Application

```bash
cd /home/abdelhak_unix/github/DevOps-Projects/01/spring-boot-login-app

mvn clean package -DskipTests
```

**Expected output ends with:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: X.XXX s
```

---

## ✅ Step 3: Run the Application

```bash
mvn spring-boot:run
```

**Expected output (wait for this line):**
```
Tomcat started on port(s): 8080 (http)
Started LoginApplication in X.XXX seconds
```

---

## ✅ Step 4: Test the Application

Open your browser and go to:
```
http://localhost:8080
```

You should see the home page with "Login" and "Register" buttons.

---

## 🎮 Test the Features

### Register a User:
1. Click "Register"
2. Fill in:
   - First Name: `John`
   - Last Name: `Doe`
   - Email: `john@example.com`
   - Username: `johndoe`
   - Password: `password123`
3. Click Register
4. You should be redirected to login page

### Login:
1. Enter Username: `johndoe`
2. Enter Password: `password123`
3. Click Login
4. You should see your dashboard

### Logout:
Click the Logout button

---

## 📁 Alternative: Use Helper Scripts

If you prefer, use the provided helper scripts:

### Option 1: Run everything automatically
```bash
chmod +x RUN_APP.sh
./RUN_APP.sh
```

This will:
- Create the database
- Build the application
- Run the application

### Option 2: Setup database only
```bash
chmod +x SETUP_DATABASE.sh
sudo bash SETUP_DATABASE.sh
```

Then manually run:
```bash
mvn spring-boot:run
```

---

## 🐛 Troubleshooting

### Problem: "Can't connect to MySQL server"

**Solution:** Make sure database was created with sudo:
```bash
sudo mysql -u root -e "SHOW DATABASES;" | grep logindb
```

If `logindb` appears, the database exists. Run the app again.

### Problem: Port 8080 already in use

**Solution:** Kill the process:
```bash
sudo lsof -i :8080
# Find the PID and kill it
kill -9 <PID>
```

Or change the port in `src/main/resources/application.properties`:
```properties
server.port=8081
```

Then rebuild:
```bash
mvn clean package -DskipTests
mvn spring-boot:run
```

### Problem: "Access denied for user 'root'"

**Solution:** Make sure you're using `sudo`:
```bash
# Wrong
mysql -u root

# Correct
sudo mysql -u root
```

---

## ✅ Verification Steps

### Check database exists:
```bash
sudo mysql -u root -e "SHOW DATABASES;" | grep logindb
```

Should show: `logindb`

### Check tables exist (after running app):
```bash
sudo mysql -u root logindb -e "SHOW TABLES;"
```

Should show: `users`

### Check created users:
```bash
sudo mysql -u root logindb -e "SELECT * FROM users;"
```

Should show registered users

---

## 📊 Complete Command Reference

| Task | Command |
|------|---------|
| Create database | `sudo mysql -u root` then paste SQL |
| Build app | `mvn clean package -DskipTests` |
| Run app | `mvn spring-boot:run` |
| Access app | `http://localhost:8080` |
| Check database | `sudo mysql -u root logindb -e "SHOW TABLES;"` |
| View users | `sudo mysql -u root logindb -e "SELECT * FROM users;"` |

---

## 🎯 Quick Summary

**Every time you want to run the app:**

```bash
# Terminal 1: Create database (first time only)
sudo mysql -u root
# Paste the SQL commands above
EXIT;

# Terminal 2: Build and run
cd /home/abdelhak_unix/github/DevOps-Projects/01/spring-boot-login-app
mvn clean package -DskipTests
mvn spring-boot:run

# Browser: Open
http://localhost:8080
```

---

**That's it! You should have a working Spring Boot login app!**
