# Quick Start Guide

## Setup in 5 Steps

### Step 1: Prerequisites Check
```bash
java -version          # Java 11 or higher required
mvn -version          # Maven 3.6 or higher
mysql --version       # MySQL 5.7 or higher
```

### Step 2: Create MySQL Database
```bash
mysql -u root -p

CREATE DATABASE logindb;
EXIT;
```

### Step 3: Build the Application
```bash
cd /home/abdelhak_unix/github/DevOps-Projects/01/spring-boot-login-app
mvn clean package -DskipTests
```

**Output:** `target/login-app-1.0.0.jar`

### Step 4: Run the Application
```bash
# Option A: Using Maven
mvn spring-boot:run

# Option B: Using Java
java -jar target/login-app-1.0.0.jar
```

### Step 5: Access the Application
Open browser: `http://localhost:8080`

---

## Test the Application

### Test User Registration
1. Click **Register**
2. Fill in the form:
   - First Name: `John`
   - Last Name: `Doe`
   - Email: `john@example.com`
   - Username: `johndoe`
   - Password: `password123`
3. Click **Register** → Redirected to login page

### Test User Login
1. Click **Login**
2. Enter credentials:
   - Username: `johndoe`
   - Password: `password123`
3. Click **Login** → Redirected to dashboard

### Test Dashboard
- View your profile information
- See "Member Since" timestamp
- Click **Logout** to exit

---

## Database Details

**Database Name:** `logindb`

**Users Table:**
```sql
mysql> USE logindb;
mysql> DESC users;
+------------+------------------+------+-----+---------+----------------+
| Field      | Type             | Null | Key | Default | Extra          |
+------------+------------------+------+-----+---------+----------------+
| id         | bigint           | NO   | PRI | NULL    | auto_increment |
| created_at | timestamp        | YES  |     | NULL    |                |
| email      | varchar(255)     | NO   | UNI | NULL    |                |
| first_name | varchar(255)     | NO   |     | NULL    |                |
| last_name  | varchar(255)     | NO   |     | NULL    |                |
| password   | varchar(255)     | NO   |     | NULL    |                |
| username   | varchar(255)     | NO   | UNI | NULL    |                |
+------------+------------------+------+-----+---------+----------------+
```

View registered users:
```bash
mysql -u root -p logindb -e "SELECT id, username, email, first_name, last_name FROM users;"
```

---

## Common Issues & Solutions

### Issue: Port 8080 Already in Use
**Solution:** Change port in `application.properties`
```properties
server.port=8081
```

### Issue: MySQL Connection Failed
**Solution:** Verify MySQL credentials in `application.properties`
```bash
mysql -u root -p -e "SHOW DATABASES;" | grep logindb
```

### Issue: JAR Not Found After Build
**Solution:** Clean rebuild
```bash
mvn clean package -DskipTests
ls -lh target/*.jar
```

### Issue: Tables Not Created
**Solution:** Check `application.properties` - JPA auto-creates tables:
```properties
spring.jpa.hibernate.ddl-auto=update
```

---

## Useful Commands

| Command | Purpose |
|---------|---------|
| `mvn clean` | Remove target directory |
| `mvn compile` | Compile source code only |
| `mvn test` | Run unit tests |
| `mvn package` | Build JAR file |
| `mvn spring-boot:run` | Run directly without JAR |
| `java -jar target/*.jar` | Run the compiled JAR |

---

## Next: Deploy to Remote Server

After testing locally, deploy to your AWS instance:

```bash
# Copy to remote server
scp -i ~/.ssh/id_rsa target/login-app-1.0.0.jar ubuntu@15.237.193.81:~/

# SSH and run
ssh -i ~/.ssh/id_rsa ubuntu@15.237.193.81
java -jar login-app-1.0.0.jar &
```

Access at: `http://15.237.193.81:8080`

---

**Happy Coding! 🚀**
