#!/bin/sh

echo "disk/partition list:"
lsblk -f

read -p "Enter empty disk for data partition (leave empty to skip):" DATA_DISK
if [ -n $DATA_DISK ]; then

	# create partition
	(echo "n"; echo "p"; echo ""; echo ""; echo ""; echo "w") && fdisk $SWAP_DISK

	# get last partition in the list of partitions
	DATA_PARTITION=$(fdisk -l -o Device $DATA_DISK | tail -1)

	# make swap "filesystem"
	mkfs.ext4 $DATA_PARTITION

	# get UUID of partition
	DATA_UUID=$(blkid $DATA_PARTITION -s UUID -o value)

	# add entry to /etc/fstab to auto-mount data partition
	echo "UUID=$DATA_UUID $DATA_PATH ext4 defaults 0 2" >> /etc/fstab
fi