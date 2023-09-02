clear

echo "Welcome to UT4MasterServer setup helper!"
echo ""
echo ""

# install all software
setup/install_docker.sh
setup/install_apache.sh
setup/install_certbot.sh
setup/install_crontab.sh
setup/install_ut4ms.sh

# prepare partitions
setup/prepare_swap_partition.sh
was_swap_partition_created=$?
setup/prepare_data_partition.sh
was_data_partition_created=$?

if [ $was_swap_partition_created -eq "1" ] -o [ $was_data_partition_created -eq "1" ]; then
	# reboot
	clear

	findmnt --verify --verbose

	echo "In order to make sure all new partitions get mounted as expected the system is going to reboot!"
	echo "After reboot, please run \`ut4ms update\` command."
	sleep 1
	read -p "Press enter to continue ..."
	reboot
fi