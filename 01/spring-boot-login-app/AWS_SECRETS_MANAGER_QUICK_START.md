# 🔐 AWS Secrets Manager - Quick Setup (5 Minutes)

## 1️⃣ Configure AWS Credentials Locally

```bash
aws configure
```

Enter:
```
AWS Access Key ID: [your-access-key]
AWS Secret Access Key: [your-secret-key]
Default region name: eu-west-3
Default output format: json
```

✓ Credentials stored in: `~/.aws/credentials`

## 2️⃣ Create Secret in AWS

```bash
aws secretsmanager create-secret \
  --name login-app-db-secret \
  --secret-string '{
    "username": "root",
    "password": "YourPassword123!",
    "host": "database-1.cjso0ws04wor.eu-west-3.rds.amazonaws.com",
    "port": 3306,
    "dbname": "logindb"
  }' \
  --region eu-west-3
```

Replace `YourPassword123!` with your actual RDS password.

## 3️⃣ Verify Secret Created

```bash
aws secretsmanager get-secret-value \
  --secret-id login-app-db-secret \
  --region eu-west-3 \
  | jq '.SecretString | fromjson'
```

Should output your secret in JSON format.

## 4️⃣ Build Application

```bash
cd /home/abdelhak_unix/github/DevOps-Projects/01/spring-boot-login-app
mvn clean package -DskipTests
```

## 5️⃣ Run Application

```bash
mvn spring-boot:run
```

### Expected Output

You should see:

```
✓ Database credentials loaded from AWS Secrets Manager
HikariPool - Starting...
Started LoginApplication in X.XXX seconds
Tomcat started on port(s): 8080
```

## 6️⃣ Test

Open: `http://localhost:8080/`

---

## 📋 Configuration

The application is pre-configured to use Secrets Manager!

**File:** `src/main/resources/application.properties`

```properties
aws.secrets.name=login-app-db-secret
aws.region=eu-west-3
```

---

## 🔑 Secret Format

Your secret in AWS should be JSON:

```json
{
  "username": "root",
  "password": "YourPassword123!",
  "host": "database-1.cjso0ws04wor.eu-west-3.rds.amazonaws.com",
  "port": 3306,
  "dbname": "logindb"
}
```

| Field | Value |
|-------|-------|
| username | RDS master username |
| password | RDS master password |
| host | RDS endpoint |
| port | RDS port (usually 3306) |
| dbname | Database name (logindb) |

---

## ✅ How It Works

```
Application Start
  ↓
SecretsManagerConfig initializes
  ↓
Reads ~/.aws/credentials
  ↓
Connects to AWS Secrets Manager
  ↓
Retrieves: login-app-db-secret
  ↓
Parses JSON and sets system properties
  ↓
DataSource uses retrieved credentials
  ↓
✓ Database connected
```

---

## 🧪 Verify Setup

### Check credentials file

```bash
cat ~/.aws/credentials
```

Should show:
```
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

### Check config file

```bash
cat ~/.aws/config
```

Should show:
```
[default]
region = eu-west-3
output = json
```

### Test secret access

```bash
aws secretsmanager list-secrets --region eu-west-3
```

Should list your `login-app-db-secret`

---

## ✨ Benefits

✅ No passwords in code
✅ Secrets encrypted in AWS
✅ Audit trail of all access
✅ Easy to rotate passwords
✅ Different secrets per environment

---

## 🚀 Next Steps

After credentials are loaded from Secrets Manager:

1. **Test the application:**
   ```
   http://localhost:8080/
   ```

2. **Register a user**

3. **Login**

4. **Verify data in RDS:**
   ```bash
   mysql -h database-1.cjso0ws04wor.eu-west-3.rds.amazonaws.com \
         -u root -p logindb \
         -e "SELECT * FROM users;"
   ```

---

## 🐛 If It Doesn't Work

### Check logs

Look for in output:
```
✓ Database credentials loaded from AWS Secrets Manager
```

If you see:
```
⚠ AWS Secrets Manager not available, using local properties
```

This means:
- AWS credentials not configured
- But application still works with fallback credentials from application.properties

### Verify AWS CLI works

```bash
aws sts get-caller-identity
```

Should show your AWS account info.

### Verify secret exists

```bash
aws secretsmanager describe-secret \
  --secret-id login-app-db-secret \
  --region eu-west-3
```

### Check IAM permissions

Your user needs `secretsmanager:GetSecretValue` permission on the secret.

---

## 📞 Quick Commands

```bash
# Configure AWS
aws configure

# Create secret
aws secretsmanager create-secret --name login-app-db-secret --secret-string '{...}' --region eu-west-3

# Get secret
aws secretsmanager get-secret-value --secret-id login-app-db-secret --region eu-west-3

# Build app
mvn clean package -DskipTests

# Run app
mvn spring-boot:run

# Test app
curl http://localhost:8080/
```

---

**🎉 You're ready! Application will now use AWS Secrets Manager for database credentials!**

For more details, see: `AWS_SECRETS_MANAGER_SETUP.md`
