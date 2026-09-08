# 🔐 AWS Secrets Manager Integration Guide

This guide shows how to configure the Spring Boot application to automatically fetch database credentials from AWS Secrets Manager using your local AWS credentials/profile.

---

## 📋 Prerequisites

- AWS Account with Secrets Manager access
- AWS CLI installed and configured
- Application built locally
- AWS credentials configured locally

---

## 🔧 Step 1: Configure AWS Credentials Locally

### Option A: Using AWS CLI (Recommended)

```bash
aws configure
```

You'll be prompted for:
```
AWS Access Key ID: [your-access-key-id]
AWS Secret Access Key: [your-secret-access-key]
Default region name: eu-west-3
Default output format: json
```

This creates files:
- `~/.aws/credentials` (stores keys)
- `~/.aws/config` (stores region)

### Option B: Using Named Profile

```bash
aws configure --profile myprofile
```

Then in application:
```properties
aws.profile=myprofile
```

### Option C: Using Environment Variables

```bash
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_DEFAULT_REGION=eu-west-3
```

### Option D: Using IAM Role (Production)

On EC2 instance, attach IAM role with Secrets Manager permissions.

---

## 🔑 Step 2: Create Secret in AWS Secrets Manager

### Using AWS Console

1. Go to: https://console.aws.amazon.com/secretsmanager
2. Click: **Secrets** → **Store a new secret**
3. **Secret type:** Choose **Other type of secret**
4. **Key/value pairs:**

   Create JSON with your RDS credentials:
   ```json
   {
     "username": "root",
     "password": "YourStrongPassword123!",
     "host": "database-1.cjso0ws04wor.eu-west-3.rds.amazonaws.com",
     "port": 3306,
     "dbname": "logindb"
   }
   ```

5. **Secret name:** `login-app-db-secret`
6. Click: **Store secret**

### Using AWS CLI

```bash
aws secretsmanager create-secret \
  --name login-app-db-secret \
  --description "Database credentials for login app" \
  --secret-string '{
    "username": "root",
    "password": "YourStrongPassword123!",
    "host": "database-1.cjso0ws04wor.eu-west-3.rds.amazonaws.com",
    "port": 3306,
    "dbname": "logindb"
  }' \
  --region eu-west-3
```

---

## 🔄 Step 3: Grant IAM Permissions

Your AWS user/role needs permission to access Secrets Manager. Create/attach this policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:ListSecrets"
      ],
      "Resource": "arn:aws:secretsmanager:eu-west-3:ACCOUNT_ID:secret:login-app-db-secret*"
    }
  ]
}
```

Or for all secrets:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:ListSecrets"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## ⚙️ Step 4: Configure Application

### Update application.properties

The application is already configured! Just verify:

```properties
# AWS Secrets Manager Configuration
aws.secrets.name=login-app-db-secret
aws.region=eu-west-3
```

Change `login-app-db-secret` if you used a different secret name.

---

## 🚀 Step 5: Build and Run

### Build with new dependencies

```bash
cd /home/abdelhak_unix/github/DevOps-Projects/01/spring-boot-login-app

mvn clean package -DskipTests
```

### Run the application

```bash
mvn spring-boot:run
```

### Expected Output

If successful, you'll see:

```
✓ Database credentials loaded from AWS Secrets Manager
HikariPool - Starting...
Started LoginApplication in X.XXX seconds
Tomcat started on port(s): 8080
```

If Secrets Manager is not available:

```
⚠ AWS Secrets Manager not available, using local properties
HikariPool - Starting...
Started LoginApplication in X.XXX seconds
Tomcat started on port(s): 8080
```

---

## 📝 How It Works

```
Application Start
    ↓
SecretsManagerConfig @PostConstruct initializes
    ↓
AWS SDK creates SecretsManagerClient using local credentials
    ↓
Client retrieves secret: login-app-db-secret
    ↓
Secret JSON parsed:
  {
    "username": "root",
    "password": "xxxxx",
    "host": "xxx.rds.amazonaws.com",
    "port": 3306,
    "dbname": "logindb"
  }
    ↓
System properties updated with fetched values
    ↓
DataSource configured with retrieved credentials
    ↓
Database connection established
    ↓
✓ Application ready
```

---

## 🔒 Security Benefits

✅ **No passwords in code**
  - Credentials not stored in application.properties
  - Secrets stored in AWS-managed vault

✅ **Encryption**
  - Secrets encrypted at rest in Secrets Manager
  - Encrypted in transit (HTTPS)

✅ **Audit Trail**
  - All secret access logged in CloudTrail
  - See who accessed what and when

✅ **Rotation**
  - Easily rotate passwords in Secrets Manager
  - No code changes needed
  - Optional automatic rotation

✅ **Access Control**
  - IAM policies control who can read secrets
  - Per-secret access rules

---

## 🧪 Testing

### Test AWS Credentials

```bash
# List available secrets
aws secretsmanager list-secrets --region eu-west-3

# Get specific secret
aws secretsmanager get-secret-value \
  --secret-id login-app-db-secret \
  --region eu-west-3
```

### View Secret in Console

```bash
# Pretty print the secret
aws secretsmanager get-secret-value \
  --secret-id login-app-db-secret \
  --region eu-west-3 \
  | jq '.SecretString | fromjson'
```

### Check Application Logs

```bash
# When running: mvn spring-boot:run
# Look for:
✓ Database credentials loaded from AWS Secrets Manager
# or
⚠ AWS Secrets Manager not available, using local properties
```

---

## 🐛 Troubleshooting

### Problem: "Unable to load credentials from any provider in the chain"

**Solution:**
```bash
# Reconfigure AWS credentials
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
export AWS_DEFAULT_REGION=eu-west-3
```

### Problem: "User is not authorized to perform: secretsmanager:GetSecretValue"

**Solution:**
- Check IAM policy attached to user
- Verify policy allows secretsmanager:GetSecretValue
- Check secret ARN matches policy resource

### Problem: "Secret login-app-db-secret not found"

**Solution:**
```bash
# List all secrets to verify name
aws secretsmanager list-secrets --region eu-west-3

# Check exact name
aws secretsmanager list-secrets \
  --region eu-west-3 \
  --query 'SecretList[*].Name' \
  --output text
```

### Problem: Application still using local properties

**Solution:**
- Credentials not available (check logs)
- Application falls back to application.properties (expected behavior)
- Check log output: "AWS Secrets Manager not available"

---

## 🔄 Updating Secrets

### Update secret value

```bash
aws secretsmanager update-secret \
  --secret-id login-app-db-secret \
  --secret-string '{
    "username": "root",
    "password": "NewPassword123!",
    "host": "database-1.cjso0ws04wor.eu-west-3.rds.amazonaws.com",
    "port": 3306,
    "dbname": "logindb"
  }' \
  --region eu-west-3
```

Application will pick up new credentials on next restart!

### Rotate secret (RDS auto-rotation)

For automated RDS password rotation:
1. AWS Console → Secrets Manager → Secret → Rotation
2. Enable rotation
3. Configure Lambda function
4. Set rotation schedule (e.g., 30 days)

---

## 📊 Application Properties Reference

```properties
# Secret name in AWS Secrets Manager
aws.secrets.name=login-app-db-secret

# AWS region where secret is stored
aws.region=eu-west-3

# Fallback database URL (used if Secrets Manager unavailable)
spring.datasource.url=jdbc:mysql://...

# Fallback username
spring.datasource.username=root

# Fallback password
spring.datasource.password=Testing123456
```

---

## 🚀 Production Best Practices

### 1. Use EC2 IAM Role
```
Don't store AWS credentials on EC2 instance
Instead: Attach IAM role to instance
Application automatically uses role credentials
```

### 2. Use Environment Variables in Production
```bash
export AWS_REGION=eu-west-3
export AWS_SECRETS_NAME=login-app-db-secret
```

### 3. Enable Secret Rotation
```
AWS Console → Secrets Manager → Secret
Enable rotation with Lambda function
Rotate credentials every 30 days
```

### 4. Use Separate Secrets per Environment
```
Development: login-app-db-secret-dev
Staging: login-app-db-secret-staging
Production: login-app-db-secret-prod
```

### 5. Monitor Secret Access
```
CloudTrail logs all GetSecretValue calls
Set up CloudWatch alarms for suspicious access
```

---

## 📞 Quick Reference

| Task | Command |
|------|---------|
| Configure AWS credentials | `aws configure` |
| Create secret | `aws secretsmanager create-secret --name login-app-db-secret --secret-string '...'` |
| Get secret | `aws secretsmanager get-secret-value --secret-id login-app-db-secret` |
| List secrets | `aws secretsmanager list-secrets` |
| Update secret | `aws secretsmanager update-secret --secret-id login-app-db-secret --secret-string '...'` |
| Build app | `mvn clean package -DskipTests` |
| Run app | `mvn spring-boot:run` |

---

## ✅ Verification Checklist

- [ ] AWS credentials configured locally
- [ ] Secret created in AWS Secrets Manager
- [ ] IAM permissions granted for GetSecretValue
- [ ] application.properties has correct secret name
- [ ] application.properties has correct AWS region
- [ ] Application built successfully
- [ ] Application started with "Tomcat started"
- [ ] Log shows: "Database credentials loaded from AWS Secrets Manager"
- [ ] Can access http://localhost:8080
- [ ] Can register and login users
- [ ] Users stored in RDS database

---

**🎉 Your application now securely fetches database credentials from AWS Secrets Manager!**

For more info: https://docs.aws.amazon.com/secretsmanager/
