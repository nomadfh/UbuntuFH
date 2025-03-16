#/bin/bash

# Install Debian based applications from official repositories
sudo apt install flatpak virtualbox vim steam pcscd

# set up the Flathub repository
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install snap packages
snap install libreoffice spotify standard-notes shortwave vlc qbittorrent-arnatious

# connect PCSCD to snap Firefox to enable smart card use
sudo snap connect firefox:pcscd

# Remove redundant packages
sudo apt remove libreoffice*

# copy default pipewire configuration to system for custom configurations
sudo cp -r /usr/share/pipewire /etc &&
echo copied pipewire config to etc directory &&

# Create custom pipewire configuration file in pipewire.conf.d directory
sudo tee /etc/pipewire/pipewire.conf.d/pipewire_modifications.conf > /dev/null << EOF

# Configuration properties for Pipewire
context.properties = {
    default.clock.quantum       = 2048
    default.clock.min-quantum   = 2048
}
EOF

# Disable dualsense touchpad using tee
sudo tee /etc/X11/xorg.conf.d/30-dualsense-touchpad.conf > /dev/null <<EOF
Section "InputClass"
    Identifier "Sony Interactive Entertainment Wireless Controller Touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Ignore" "true"
EndSection
EOF





