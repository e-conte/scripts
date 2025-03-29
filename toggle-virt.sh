#!/bin/bash
#need: 
#       libnotify library
#       dunst daemon for notifications

# Check if libvirtd is active
if systemctl is-active --quiet libvirtd; then
    # Stop libvirtd and mask sockets
    sudo systemctl stop libvirtd
    sudo systemctl mask libvirtd.socket libvirtd-ro.socket libvirtd-admin.socket
    notify-send -i network-off "libvirtd Stopped" "libvirtd service and sockets have been disabled."
else
    # Unmask sockets and start libvirtd
    sudo systemctl unmask libvirtd.socket libvirtd-ro.socket libvirtd-admin.socket
    sudo systemctl start libvirtd
    notify-send -i network-idle "libvirtd Started" "libvirtd service is now active."
fi

# Display final status in terminal
echo -n "Current libvirtd status: "
systemctl is-active libvirtd
