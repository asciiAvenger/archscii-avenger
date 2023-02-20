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

# enable networkmanager
sudo systemctl enable NetworkManager.service

# download dotfiles
echo "Configuring dotfiles..."
git clone https://github.com/asciiavenger/dotfiles.git /tmp/dotfiles
cp /tmp/dotfiles/.vimrc ~
cp /tmp/dotfiles/.zshrc ~
cp /tmp/dotfiles/.config/* ~/.config
rm -rf /tmp/dotfiles

# change shell to zsh
chsh -s /bin/zsh

# delete install files
echo "Deleting install files from user directory..."
rm -rf ~/archscii-avenger

echo "#######################"
echo "# Finished user setup #"
echo "#######################"