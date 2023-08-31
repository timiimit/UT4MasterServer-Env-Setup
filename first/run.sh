#!/bin/sh

# give root user a password
sudo passwd root
su

# update all packages
yum update -y

# install git
yum install -y git

# clone this repo
git clone https://github.com/timiimit/UT4MasterServer-Env.git
cd UT4MasterServer-Env

mv ../config.cfg ./

# after getting whole repo, continue with other tasks
source first/post_download.sh
