#!/bin/sh

# TODO: verify that some partition is mounted at /app

su

source app/config.cfg

# copy scripts to main directory
cp -r app/* /app/

source setup/create_production_files.sh