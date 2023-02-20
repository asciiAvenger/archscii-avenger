#!/bin/bash

cat << 'EOF'
#################################################################################
#      _             _              _ _    _                                    #
#     / \   _ __ ___| |__  ___  ___(_|_)  / \__   _____ _ __   __ _  ___ _ __   #
#    / _ \ | '__/ __| '_ \/ __|/ __| | | / _ \ \ / / _ \ '_ \ / _` |/ _ \ '__|  #
#   / ___ \| | | (__| | | \__ \ (__| | |/ ___ \ V /  __/ | | | (_| |  __/ |     #
#  /_/   \_\_|  \___|_| |_|___/\___|_|_/_/   \_\_/ \___|_| |_|\__, |\___|_|     #
#                                                             |___/             #
#################################################################################
EOF

source $(dirname $0)/settings.txt

bash scripts/0-live.sh
arch-chroot /mnt bash /root/archscii-avenger/scripts/1-install.sh
arch-chroot /mnt su $username -c "bash ~/archscii-avenger/scripts/2-user.sh"
# bash scripts/3-finish.sh