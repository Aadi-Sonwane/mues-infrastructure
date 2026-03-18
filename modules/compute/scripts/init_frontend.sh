#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum install -y nginx

# Create the skeleton file directly on the server
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head><title>Mues Tech - Live</title></head>
<body><h1>Frontend is Online</h1><p>Served by Nginx on AWS</p></body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx