#!bin/bash
echo "It is tainted" > index.html
nohup busybox httpd -f -p "8080" &
