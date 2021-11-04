#!/bin/bash

# this will prepare the installation while still in the live-environment

echo "###############################"
echo "# Starting basic installation #"
echo "###############################"

echo "Preparing to install your operating system..."

# enable ntp
timedatectl set-ntp true

# enable parallel pacman downloads
sed -i 's/^#Parallel/Parallel/' /etc/pacman.conf

# gettings users country iso
echo "Please enter your country ISO (for example 'de')"
read -p "ISO:" iso

# set mirrors
echo "Setting your mirrors..."
echo "Installing reflector..."
pacman -S --noconfirm reflector
echo "Running reflector..."
reflector --country $iso --latest 15 --sort rate --protocol https --save /etc/pacman.d/mirrorlist

# format disk
echo "These are your disks:"
fdisk -l
echo "Please enter which one to format (for example /dev/sda)"
read -p "Your Disk:" disk
echo "This will format $disk. All previously contained data will be lost."
read -p "Are you sure and want to continue? (y/N):" confirmation
wordlist="y Y yes Yes YES"
if ! echo $wordlist | grep -w $confirmation > /dev/null; then
    echo "Aborting the installation..."
    exit 1
fi
echo "Formatting $disk..."
# lol...
# TODO: find a better way to handle this with parted
# creates 2 partitions (1: efi, 2: filesystem)
echo -e "g\nn\n\n\n+512M\nt\n\n1\nn\n\n\n\nw" | fdisk $disk

# create filesystems
echo "Creating your filesystems..."
mkfs.vfat -F32 ${disk}1
mkfs.ext4 ${disk}2

# mount filesystems
echo "Mounting filesystems..."
mkdir /mnt
mount ${disk}2 /mnt
mkdir /mnt/boot
mount ${disk}1 /mnt/boot

# pacstrap
echo "Installing basic packages..."
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware vim sudo git --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab

echo "###############################"
echo "# Basic installation finished #"
echo "###############################"