clear

source config.cfg

echo "Welcome to UT4MasterServer setup helper!"
echo ""
echo ""

# prepare partitions
source setup/prepare_swap_partition.sh
source setup/prepare_data_partition.sh
mkdir /app

# install all software
source setup/install_docker.sh
source setup/install_apache.sh
source setup/install_certbot.sh
source setup/install_crontab.sh

# reboot
clear
echo "System is going to reboot!"
echo "After reboot, please run $(pwd)/first/post_reboot.sh script."
sleep 1
read -p "Press enter to continue ..."
reboot
