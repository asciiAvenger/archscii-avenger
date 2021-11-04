#!/bin/bash

echo "##############################"
echo "# Starting main installation #"
echo "##############################"

# setting timezone
echo "Please enter your timezone (for example Europe/Berlin)"
read -p "Timezone:" timezone
echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime

# generate /etc/adjtime
echo "Setting hardware clock..."
hwclock --systohc

# locale, language, keymap
echo "Please enter your keymap (for example de-latin1)"
read -p "Keymap:" keymap
echo "Setting locale, language and keymap..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=$keymap" > /etc/vconsole.conf

# configure networking
echo "Please enter a hostname"
read -p "Hostname:" hostname
echo "Setting up networking..."
echo $hostname > /etc/hostname
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager.service

# install microcode (amd for now)
# TODO: refactor
pacman -S --noconfirm amd-ucode