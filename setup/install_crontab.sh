#!/bin/sh

echo "Installing crontab..."

yum -q -y install cronie

systemctl enable crond