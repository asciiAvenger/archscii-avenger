#!/bin/bash

echo "##############################"
echo "# Starting main installation #"
echo "##############################"

# source settings.txt
source /root/archscii-avenger/settings.txt

# setting timezone
echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime

# generate /etc/adjtime
echo "Setting hardware clock..."
hwclock --systohc

# locale, language, keymap
echo "Setting locale, language and keymap..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=$keymap" > /etc/vconsole.conf

# configure networking
echo "Setting up networking..."
echo $hostname > /etc/hostname
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager.service

# install microcode (amd for now)
# TODO: refactor
pacman -S --noconfirm amd-ucode

# setup permissions
echo "Setting up some permissions..."
echo "Please set your root password"
passwd

# enable passwordless sudo for the wheel group
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# enable parallel pacman downloads again and enable multilib and run pacman Sy
sed -i 's/^#Parallel/Parallel/' /etc/pacman.conf
sed -i '/#\[multilib\]/,/#Include/''s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

# install bootloader
echo "Installing bootloader..."
pacman -S --noconfirm grub efibootmgr ntfs-3g os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCHSCII
grub-mkconfig -o /boot/grub/grub.cfg

# install packages
echo "Installing packages..."
cat /root/archscii-avenger/packages.txt | pacman -S --noconfirm -

# enable sddm
systemctl enable sddm

# create first user
echo "Creating your first user $username..."
useradd -m -G wheel -s /bin/zsh $username
echo "Please set your users password"
passwd $username

echo "##############################"
echo "# Finished main installation #"
echo "##############################"