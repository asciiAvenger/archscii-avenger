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

echo "#######################"
echo "# Finished user setup #"
echo "#######################"