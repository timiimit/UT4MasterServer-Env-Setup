#!/bin/sh

# give root user a password
sudo passwd root

# switch to root user
su

source config.cfg

# update all packages
dnf update -y

# install git
dnf install -y git

# clone this repo
git clone "$REPO_URL_ENV_SETUP"

# NOTE: this naively assumes that repo name is exactly this
cd UT4MasterServer-Env-Setup

# after getting whole repo, continue with other tasks
source first/post_download.sh
