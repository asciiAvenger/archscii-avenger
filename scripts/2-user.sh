#!/bin/bash

echo "##############"
echo "# User setup #"
echo "##############"

# install yay
echo "Installing yay..."
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm
rm -rf /tmp/yay

# install packages
echo "Installing packages..."
packages=$(cat ~/archscii-avenger/packages.txt)
yay -S --noconfirm $packages

# enable gdm
sudo systemctl enable gdm.service

# delete install files
echo "Deleting install files from user directory..."
rm -rf ~/archscii-avenger

echo "#######################"
echo "# Finished user setup #"
echo "#######################"