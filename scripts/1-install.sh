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

# configure hostname
echo "Setting up hostname..."
echo $hostname > /etc/hostname

# install microcode
echo "Installing microcode..."
cpuVendor=$(lscpu | grep -i 'vendor id' | awk '{print $3}')
if [$cpuVendor == "AuthenticAMD"]; then
    pacman -S --noconfirm amd-ucode
elif [$cpuVendor == "GenuineIntel"]; then
    pacman -S --noconfirm intel-ucode
fi

# setup permissions
echo "Setting up some permissions..."
echo "Please set your root password"
passwd

# enable passwordless sudo for the wheel group
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

# install bootloader
echo "Installing bootloader..."
pacman -S --noconfirm grub efibootmgr ntfs-3g os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCHSCII
grub-mkconfig -o /boot/grub/grub.cfg

# create first user
echo "Creating your first user $username..."
useradd -m -G wheel $username
echo "Please set your users password"
passwd $username

# copy install files to newly created user
echo "Copying install files to the new user..."
cp -r /root/archscii-avenger /home/$username/
chown -R $username:$username /home/$username/archscii-avenger

# delete install files from /root
echo "Deleting install files from /root..."
rm -rf /root/archscii-avenger

echo "##############################"
echo "# Finished main installation #"
echo "##############################"