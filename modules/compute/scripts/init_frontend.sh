#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting Frontend Initialization..."

# 1. Install Web Server
yum update -y
yum install -y nginx

# 2. Configure Nginx to serve the React build
# (Assuming your build is in /var/www/html)
systemctl enable nginx
systemctl start nginx

# 3. Health Check point
echo "Healthy" > /var/www/html/index.html