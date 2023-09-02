#!/bin/sh

echo "Installing crontab..."
dnf -q -y install cronie

systemctl enable crond