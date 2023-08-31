**BEWARE: code hasn't been tested yet!!!**

# UT4MasterServer-Env
Helpful information and scripts for the environment of UT4MasterServer. Code is specifically written for empty *Amazon Linux 2023* kernel.

# Hardware requirements/expectations
- 1x disk for swap partition (any size)
- 1x disk for data storage partition (8GB or more)
- 12GB or more primary root partition
- 2GB or more RAM

# Fix local terminal SSH issues
upload your terminal information to the host.
to do this:
- locally create 'terminfo' file with 'infocmp > terminfo' command
- upload the file to target host
- run 'tic terminfo' on the host in the same directory as the file resides

# Setup from scratch
Run `source <(curl -s https://raw.githubusercontent.com/timiimit/UT4MasterServer-Env/first/run.sh)`