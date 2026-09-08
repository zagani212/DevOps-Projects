# 🚀 AWS RDS Setup Guide

Complete guide to set up the Spring Boot Login App with AWS RDS MySQL.

## 📋 Prerequisites

- AWS Account
- AWS Management Console access
- Application built locally with `mvn clean package -DskipTests`

---

## 🔧 Step 1: Create AWS RDS MySQL Instance

### 1.1 Open AWS Management Console
- Go to: https://console.aws.amazon.com
- Navigate to: **RDS** → **Databases** → **Create database**

### 1.2 Database Creation Settings

| Setting | Value |
|---------|-------|
| **Engine** | MySQL |
| **Engine Version** | 8.0.35 (or latest 8.0.x) |
| **DB Instance Class** | db.t3.micro (Free tier eligible) |
| **Storage** | 20 GB (Free tier) |
| **DB Instance Identifier** | `login-app-db` |

### 1.3 Credentials

| Setting | Value |
|---------|-------|
| **Master Username** | `admin` |
| **Master Password** | Create a strong password (save it!) |
| **Confirm Password** | (repeat password) |

### 1.4 Connectivity

| Setting | Value |
|---------|-------|
| **VPC** | Default VPC |
| **Publicly Accessible** | **Yes** (for now - change to No in production) |
| **VPC Security Group** | Create new: `login-app-sg` |

### 1.5 Initial Database Name
| Setting | Value |
|---------|-------|
| **Initial Database Name** | `logindb` |

### 1.6 Create Database
Click **Create database** and wait (5-10 minutes for instance to be available)

---

## 📍 Step 2: Get RDS Endpoint

Once the database is created:

1. Go to **RDS** → **Databases**
2. Click on `login-app-db`
3. Find **Endpoint & Port** section
4. Copy the endpoint (looks like: `login-app-db.c9akciq32.us-east-1.rds.amazonaws.com`)

---

## 🔐 Step 3: Configure Security Group

### Allow Inbound Traffic

1. Go to **RDS** → **Databases** → `login-app-db`
2. Find **Security Groups** section
3. Click on the security group (e.g., `login-app-sg`)
4. Go to **Inbound Rules** → **Edit**
5. Add rule:
   - **Type:** MySQL/Aurora
   - **Protocol:** TCP
   - **Port Range:** 3306
   - **Source:** Choose one:
     - `0.0.0.0/0` (anyone - less secure but works for testing)
     - Your IP address (more secure)
     - Your EC2 security group (if running on EC2)
6. Click **Save rules**

---

## 🗄️ Step 4: Create Database Schema

### Option A: Using MySQL CLI Remotely

```bash
# Connect to RDS
mysql -h your-rds-endpoint.rds.amazonaws.com \
       -u admin \
       -p \
       logindb

# Enter your RDS password when prompted

# Then run:
CREATE TABLE IF NOT EXISTS users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

EXIT;
```

### Option B: Let Hibernate Create It

Skip this step and let the Spring Boot app create the table automatically (set in `application.properties`).

---

## 📝 Step 5: Update Application Configuration

Edit: `src/main/resources/application.properties`

Replace with your actual RDS details:

```properties
# AWS RDS MySQL Configuration
spring.datasource.url=jdbc:mysql://YOUR_RDS_ENDPOINT:3306/logindb?serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=true
spring.datasource.username=admin
spring.datasource.password=YOUR_RDS_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
```

**Example:**
```properties
spring.datasource.url=jdbc:mysql://login-app-db.c9akciq32.us-east-1.rds.amazonaws.com:3306/logindb?serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=true
spring.datasource.username=admin
spring.datasource.password=MyS3cur3P@ssw0rd!
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

---

## 🚀 Step 6: Build and Run Application

```bash
cd /home/abdelhak_unix/github/DevOps-Projects/01/spring-boot-login-app

# Rebuild with new config
mvn clean package -DskipTests

# Run the application
mvn spring-boot:run
```

---

## ✅ Step 7: Verify Connection

### Check application starts:
```
2026-09-08 15:30:00.000  INFO 12345 --- [           main] c.devops.LoginApplication : Started LoginApplication
2026-09-08 15:30:00.000  INFO 12345 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer : Tomcat started on port(s): 8080
```

### Test in browser:
```
http://localhost:8080
```

### Verify database connectivity:
```bash
# Check if table was created
mysql -h your-rds-endpoint.rds.amazonaws.com \
       -u admin \
       -p logindb \
       -e "SHOW TABLES;"

# Should output: users
```

---

## 🎮 Test the Application

1. **Register:** Create a new user
2. **Check RDS:** Verify user was saved
   ```bash
   mysql -h your-rds-endpoint.rds.amazonaws.com \
          -u admin \
          -p logindb \
          -e "SELECT * FROM users;"
   ```
3. **Login:** Test login functionality
4. **Dashboard:** View user profile

---

## 🌐 Deploy to AWS EC2

Once tested locally, deploy to EC2:

```bash
# 1. Build JAR
mvn clean package

# 2. Copy to EC2
scp -i your-key.pem target/login-app-1.0.0.jar ec2-user@your-ec2-ip:~/

# 3. SSH to EC2
ssh -i your-key.pem ec2-user@your-ec2-ip

# 4. Run on EC2
java -jar login-app-1.0.0.jar

# 5. Access from browser
http://your-ec2-ip:8080
```

---

## 📊 RDS Configuration Template

Create a file `rds-config.env` to store RDS details:

```bash
# AWS RDS Configuration
RDS_ENDPOINT=login-app-db.c9akciq32.us-east-1.rds.amazonaws.com
RDS_PORT=3306
RDS_DATABASE=logindb
RDS_USERNAME=admin
RDS_PASSWORD=your_secure_password

# Connection String
JDBC_URL=jdbc:mysql://${RDS_ENDPOINT}:${RDS_PORT}/${RDS_DATABASE}?serverTimezone=UTC&useSSL=true
```

---

## 🔒 Security Best Practices

### For Production:

1. **Use Strong Password**
   ```
   Minimum 8 characters
   Mix of: UPPERCASE, lowercase, numbers, symbols
   Example: MyS3cur3P@ssw0rd!
   ```

2. **Restrict Security Group**
   - Only allow from your EC2 instance or application IP
   - Not `0.0.0.0/0` in production

3. **Use Environment Variables**
   ```bash
   export DB_USERNAME=admin
   export DB_PASSWORD=secure_password
   ```
   
   Then in application:
   ```properties
   spring.datasource.username=${DB_USERNAME}
   spring.datasource.password=${DB_PASSWORD}
   ```

4. **Enable Backup**
   - RDS → Databases → login-app-db → Modify
   - Set Backup retention: 7 days
   - Enable Multi-AZ for high availability

5. **Use IAM Authentication** (Advanced)
   ```
   Instead of password, use IAM roles for authentication
   ```

---

## 🐛 Troubleshooting

### Problem: "Can't connect to RDS"

**Solution:**
1. Check security group allows inbound traffic on port 3306
2. Check RDS endpoint is correct (no `https://`)
3. Check username/password is correct
4. Check database exists:
   ```bash
   mysql -h your-rds-endpoint.rds.amazonaws.com \
          -u admin \
          -p -e "SHOW DATABASES;"
   ```

### Problem: "Access denied for user 'admin'"

**Solution:**
- Check password is correct (case-sensitive!)
- Verify username is `admin` (default)
- Reset password in RDS console if forgot it

### Problem: "Connection timed out"

**Solution:**
- RDS instance may still be starting (takes 5-10 minutes)
- Check RDS status in AWS console: should be "available"
- Check security group has inbound rule for port 3306

### Problem: "Communications link failure"

**Solution:**
- RDS endpoint in `application.properties` is incorrect
- Use full endpoint: `login-app-db.c9akciq32.us-east-1.rds.amazonaws.com`
- Do NOT include `https://` or port in hostname

---

## 📈 Monitoring

### View RDS Metrics
- **AWS Console** → **RDS** → **Databases** → `login-app-db`
- **Monitoring** tab shows:
  - CPU utilization
  - Database connections
  - Read/Write latency
  - Storage usage

### Enable CloudWatch Logs
```
RDS → Databases → login-app-db → Modify
→ Enable Enhanced Monitoring → Save
```

---

## 💾 Backup & Recovery

### Automated Backups
- Retention: 7 days (configurable)
- Automatic daily snapshots
- Point-in-time recovery available

### Manual Snapshot
```
RDS → Databases → login-app-db → Actions → Create snapshot
```

---

## 💰 Cost Estimation

| Component | Cost (Free Tier) | Cost (Production) |
|-----------|------------------|-------------------|
| **db.t3.micro** | Free (12 months) | $0.017/hour |
| **20 GB Storage** | Free (20 GB) | $1/month |
| **Data Transfer** | Free (within region) | $0.02/GB |
| **Backup Storage** | Free (equal to DB size) | $0.095/GB/month |

**Example:** db.t3.micro in us-east-1: ~$15/month

---

## 📞 Quick Reference

| Task | Command |
|------|---------|
| Test RDS connection | `mysql -h ENDPOINT -u admin -p` |
| Create database | Via AWS Console or SQL script |
| View tables | `SHOW TABLES;` |
| Check users | `SELECT * FROM users;` |
| Update config | Edit `application.properties` |
| Rebuild app | `mvn clean package -DskipTests` |
| Run app | `mvn spring-boot:run` |
| Monitor | AWS RDS Console → Monitoring tab |

---

## ✅ Verification Checklist

After setup, verify:

- [ ] RDS instance is running ("Available" status)
- [ ] Security group allows port 3306
- [ ] Can connect with MySQL CLI
- [ ] `logindb` database exists
- [ ] Application properties updated with RDS endpoint
- [ ] Application starts without connection errors
- [ ] Can register new user
- [ ] User data appears in RDS
- [ ] Can login with registered user
- [ ] Can logout

---

**🎉 You now have a production-ready MySQL RDS database connected to your Spring Boot application!**

For more help, see AWS RDS documentation: https://docs.aws.amazon.com/rds/
