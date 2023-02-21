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

# source settings.txt
source $(dirname $0)/../settings.txt

# loadkeys
loadkeys $keymap

# set mirrors
echo "Setting your mirrors..."
echo "Installing reflector..."
pacman -S --noconfirm reflector
echo "Running reflector..."
reflector --country $iso --latest 10 --sort rate --protocol https --save /etc/pacman.d/mirrorlist

# format disk
echo "Preparing disks..."
echo "This will format $disk. All previously contained data will be lost."
read -p "Are you sure and want to continue? (y/N):" confirmation
wordlist="y Y yes Yes YES"
if ! echo $wordlist | grep -w $confirmation > /dev/null; then
    echo "Aborting the installation and rebooting..."
    sleep 3
    reboot
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
pacstrap /mnt base base-devel linux linux-headers linux-firmware sudo git zsh --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab

# copy over this repository to the new installation
echo "Copying install files to the new installation..."
cp -r $(dirname $0)/.. /mnt/root/archscii-avenger

echo "###############################"
echo "# Basic installation finished #"
echo "###############################"