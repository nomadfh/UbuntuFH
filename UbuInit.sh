#/bin/bash

# Install Debian based applications from official repositories
sudo apt install flatpak virtualbox vim steam

# set up the Flathub repository
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install snap packages
snap install libreoffice spotify standard-notes shortwave vlc qbittorrent-arnatious

# Remove redundant packages
sudo apt remove libreoffice*




