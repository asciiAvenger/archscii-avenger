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

# set dconf settings
# org.gnome.desktop.desktop
gsettings set org.gnome.desktop.desktop picture-options "zoom"
gsettings set org.gnome.desktop.desktop picture-uri "file:///..." # select nice default - maybe from gnome or arch wallpapers
gsettings set org.gnome.desktop.desktop picture-uri-dark "file:///..."
# org.gnome.desktop.interface
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface cursor-theme "Qogir"
gsettings set org.gnome.desktop.interface document-font-name "Cantarell 12"
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface font-name "Cantarell 12"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface icon-theme "Qogir-dark"
gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode Nerd Font Mono 12"
gsettings set org.gnome.desktop.interface text-scaling-factor 1.3
# org.gnome.desktop.screensaver
gsettings set org.gnome.desktop.screensaver picture-options "zoom"
gsettings set org.gnome.desktop.screensaver picture-uri "file:///..." # select nice default - maybe from gnome or arch wallpapers 
# org.gnome.desktop.wm.preferences
gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Cantarell 12"

# delete install files
echo "Deleting install files from user directory..."
rm -rf ~/archscii-avenger

echo "#######################"
echo "# Finished user setup #"
echo "#######################"