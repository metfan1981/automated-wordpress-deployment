#!/bin/bash

cd /home/test
wget https://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz
rm latest.tar.gz
mv wordpress public_html

cd /home/test/public_html
chown -R test:www-data .
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
