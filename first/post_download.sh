clear

echo "Welcome to UT4MasterServer setup helper!"
echo ""
echo ""

source setup/prepare_swap_partition.sh
source setup/prepare_data_partition.sh
source setup/install_docker.sh
source setup/install_apache.sh
source setup/install_certbot.sh