#!/bin/bash
# Log output to check for errors via SSM or Console
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting Backend Initialization..."

# 1. Update and install AWS CLI & Dependencies
yum update -y
yum install -y aws-cli python3-pip

# 2. Fetch Secret from SSM (Using variables passed from Terraform)
# These variables are injected via Terraform's templatefile function
export REGION="${region}"
export MONGO_PARAM="${mongo_url_param}"

MONGODB_URL=$(aws ssm get-parameter --name "$MONGO_PARAM" --with-decryption --region "$REGION" --query "Parameter.Value" --output text)

# 3. Securely inject into environment
echo "DATABASE_URL=$MONGODB_URL" >> /etc/environment
echo "DEPLOY_ENV=production" >> /etc/environment

# 4. Django Setup (Example)
# cd /home/ec2-user/app
# pip3 install -r requirements.txt
# gunicorn myapp.wsgi:application --bind 0.0.0.0:8000