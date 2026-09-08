# Spring Boot Login Application

A complete user authentication and registration system built with Spring Boot, Spring Security, and MySQL.

## Features

✅ User Registration with validation
✅ Secure Login with password encryption (BCrypt)
✅ Session management
✅ Dashboard with user information
✅ Responsive UI with modern design
✅ MySQL database integration

## Project Structure

```
spring-boot-login-app/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/com/devops/
│   │   │   ├── LoginApplication.java        # Main Spring Boot App
│   │   │   ├── controller/
│   │   │   │   ├── AuthController.java      # Login/Register/Logout
│   │   │   │   └── HomeController.java      # Home & Dashboard
│   │   │   ├── service/
│   │   │   │   └── UserService.java         # Business Logic
│   │   │   ├── repository/
│   │   │   │   └── UserRepository.java      # Database Access
│   │   │   ├── entity/
│   │   │   │   └── User.java                # User Entity/Model
│   │   │   └── config/
│   │   │       └── SecurityConfig.java      # Security Configuration
│   │   ├── resources/
│   │   │   └── application.properties       # App Configuration
│   │   └── webapp/WEB-INF/jsp/
│   │       ├── index.jsp                    # Home Page
│   │       ├── login.jsp                    # Login Page
│   │       ├── register.jsp                 # Registration Page
│   │       └── dashboard.jsp                # User Dashboard
```

## Prerequisites

- Java 11 or higher
- Maven 3.6+
- MySQL 5.7 or higher

## Installation

### 1. Clone/Download the Project

```bash
cd /home/abdelhak_unix/github/DevOps-Projects/01/spring-boot-login-app
```

### 2. Create MySQL Database

```bash
mysql -u root -p

CREATE DATABASE logindb;
USE logindb;
```

### 3. Update Database Credentials (if needed)

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/logindb
spring.datasource.username=root
spring.datasource.password=root
```

### 4. Build the Application

```bash
mvn clean package
```

### 5. Run the Application

```bash
# Option A: Run directly with Maven
mvn spring-boot:run

# Option B: Run the JAR file
java -jar target/login-app-1.0.0.jar
```

### 6. Access the Application

Open your browser and navigate to:
```
http://localhost:8080
```

## User Flow

1. **Home Page** (`/`) - Shows Welcome with Login/Register buttons
2. **Register** (`/auth/register`) - Create a new account
3. **Login** (`/auth/login`) - Authenticate with credentials
4. **Dashboard** (`/dashboard`) - View user profile and info
5. **Logout** (`/auth/logout`) - Terminate session

## Technology Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | JSP, HTML5, CSS3 |
| **Backend** | Spring Boot 2.7.18 |
| **Security** | Spring Security, BCrypt |
| **Database** | MySQL, JPA/Hibernate |
| **Build** | Maven |
| **Java Version** | 11+ |

## Key Classes

### `User.java` (Entity)
JPA entity representing the user table with fields:
- id, username, password, firstName, lastName, email, createdAt

### `UserService.java` (Service)
Business logic for:
- User registration with validation
- Login authentication
- Password encoding with BCrypt

### `AuthController.java` (Controller)
Handles:
- `/auth/login` - Login page and processing
- `/auth/register` - Registration page and processing
- `/auth/logout` - Session termination

### `UserRepository.java` (Repository)
Database operations extending JpaRepository

## Database Schema

```sql
CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Security Features

✅ Passwords encrypted with BCrypt
✅ Session-based authentication
✅ Duplicate username/email validation
✅ CSRF protection via Spring Security
✅ SQL injection prevention (using JPA)

## Troubleshooting

### Port 8080 already in use
```bash
# Change port in application.properties
server.port=8081
```

### Database connection failed
- Verify MySQL is running
- Check credentials in application.properties
- Ensure database exists

### JAR file not found after build
```bash
# Run clean build
mvn clean package

# Check target directory
ls -la target/
```

## Build & Deploy Commands

```bash
# Clean build
mvn clean package

# Skip tests during build
mvn clean package -DskipTests

# Run locally
java -jar target/login-app-1.0.0.jar

# Run with Maven
mvn spring-boot:run
```

## Next Steps

- Add email verification
- Implement "Forgot Password" feature
- Add role-based access control (RBAC)
- Deploy to cloud (AWS, Azure, Heroku)
- Add REST API endpoints
- Implement JWT authentication

---

**Created:** 2026-09-08
**Version:** 1.0.0
