# 🚀 AWS RDS - Quick Start (5 Minutes)

## 1️⃣ Create RDS Instance (AWS Console)

Go to: https://console.aws.amazon.com/rds

Click: **Create database**

Fill in:
- **Engine:** MySQL 8.0
- **Instance Class:** db.t3.micro (Free tier)
- **DB Instance ID:** login-app-db
- **Master Username:** admin
- **Master Password:** Your Strong Password (save it!)
- **Initial Database Name:** logindb
- **Publicly Accessible:** Yes
- **Create new Security Group:** login-app-sg

Click: **Create database**

⏳ Wait 5-10 minutes for "Available" status

---

## 2️⃣ Get RDS Endpoint

1. Go to: **RDS → Databases → login-app-db**
2. Find: **Endpoint** (looks like: `login-app-db.xxxx.us-east-1.rds.amazonaws.com`)
3. Copy it (you'll need it next)

---

## 3️⃣ Allow Access to RDS

1. Go to: **RDS → Databases → login-app-db**
2. Find: **Security Groups**
3. Click on the security group (e.g., `login-app-sg`)
4. Click: **Edit Inbound Rules**
5. Add Rule:
   - Type: MySQL/Aurora
   - Port: 3306
   - Source: 0.0.0.0/0 (or your IP)
6. Click: **Save**

---

## 4️⃣ Update Application Config

Edit: `src/main/resources/application.properties`

Replace this section:
```properties
# AWS RDS MySQL Database Configuration
spring.datasource.url=jdbc:mysql://YOUR_RDS_ENDPOINT:3306/logindb?serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=true&serverSslMode=REQUIRED
spring.datasource.username=admin
spring.datasource.password=your_rds_password
```

With your actual values:
```properties
# AWS RDS MySQL Database Configuration
spring.datasource.url=jdbc:mysql://login-app-db.c9akciq32.us-east-1.rds.amazonaws.com:3306/logindb?serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=true&serverSslMode=REQUIRED
spring.datasource.username=admin
spring.datasource.password=MyS3cur3P@ssw0rd!
```

---

## 5️⃣ Build & Run Application

```bash
cd /home/abdelhak_unix/github/DevOps-Projects/01/spring-boot-login-app

mvn clean package -DskipTests

mvn spring-boot:run
```

---

## 6️⃣ Test in Browser

```
http://localhost:8080
```

Test:
1. Register a new user
2. Login with credentials
3. View dashboard
4. Logout

---

## ✅ Verify RDS Connection

```bash
# Connect to RDS directly
mysql -h login-app-db.c9akciq32.us-east-1.rds.amazonaws.com \
       -u admin \
       -p logindb

# Enter password when prompted

# Check tables
SHOW TABLES;

# Check users
SELECT * FROM users;

# Exit
EXIT;
```

---

## 🎯 Done!

Your application now uses AWS RDS MySQL! 🎉

**Connection String Used:**
```
jdbc:mysql://login-app-db.c9akciq32.us-east-1.rds.amazonaws.com:3306/logindb
```

**Username:** admin
**Password:** Your RDS password
**Database:** logindb

---

## 📋 Troubleshooting Checklist

- [ ] RDS instance shows "Available" in AWS console
- [ ] Security group has inbound rule for port 3306
- [ ] Application.properties has correct RDS endpoint
- [ ] Application.properties has correct password
- [ ] Can connect with: `mysql -h ENDPOINT -u admin -p`
- [ ] Application starts without connection errors
- [ ] Can register and login successfully

---

## 💡 Pro Tips

### Use Environment Variables (Recommended)
```bash
# Set before running
export DB_URL=jdbc:mysql://your-endpoint:3306/logindb
export DB_USER=admin
export DB_PASS=your_password

# Then use in application.properties
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASS}
```

### Check Application Logs
```
Look for: "Tomcat started on port(s): 8080"
This means connection successful!
```

### Monitor RDS Usage
```
AWS Console → RDS → Databases → login-app-db → Monitoring
View CPU, connections, storage usage
```

---

**For full details, see: `AWS_RDS_SETUP.md`**
