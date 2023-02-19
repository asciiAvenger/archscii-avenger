#!/bin/bash

echo "##############"
echo "# User setup #"
echo "##############"

# install yay
echo "Installing yay..."
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si
rm -rf /tmp/yay

# install packages
echo "Installing packages..."
cat /root/archscii-avenger/packages.txt | yay -S --noconfirm -

# enable gdm
sudo systemctl enable gdm.service

echo "#######################"
echo "# Finished user setup #"
echo "#######################"