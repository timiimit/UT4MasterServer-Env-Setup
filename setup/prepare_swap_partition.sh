#!/bin/sh

echo "disk/partition list:"
lsblk

read -p "Enter empty disk for swap partition (leave empty to skip):" SWAP_DISK
if [ -n $SWAP_DISK ]; then

	# create partition and change its type to swap (82)
	(echo "n"; echo "p"; echo ""; echo ""; echo ""; echo "t"; echo "82"; echo "w") && fdisk $SWAP_DISK

	# get last partition in the list of partitions
	SWAP_PARTITION=$(fdisk -l -o Device $SWAP_DISK | tail -1)

	# make swap filesystem
	mkswap $SWAP_PARTITION

	# get UUID of partition
	SWAP_UUID=$(blkid $SWAP_PARTITION -s UUID -o value)

	# add entry to /etc/fstab to auto-mount swap partition
	echo "UUID=$SWAP_UUID swap swap defaults 0 0" >> /etc/fstab

	return "1"
fi

return "0"