#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum install -y python3-pip
pip3 install django gunicorn dj-database-url

mkdir -p /home/ec2-user/app
cd /home/ec2-user/app
django-admin startproject myapp .

# Allow all hosts so the NLB health check passes immediately
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = ['*']/" myapp/settings.py

# Start Gunicorn in the background
gunicorn --bind 0.0.0.0:8000 myapp.wsgi:application --daemon