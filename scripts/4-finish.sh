#!/bin/bash

echo "################"
echo "# Finishing up #"
echo "################"

# unmounting /mnt
echo "Unmounting /mnt..."
umount -R /mnt

# reboot - install finished
echo "Installation finished. Rebooting..."
sleep 5
reboot