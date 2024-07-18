#!/bin/bash

IPath=${PWD}
InstallPath=/.krush/
echo "Installing Dependencies"
sudo pacman -Sy --noconfirm --needed jq dialog fastfetch autoconf 

cd $IPath
git clone https://aur.archlinux.org/shc-git.git
cd shc-git
makepkg -si
cd $IPath
sudo rm -rf $IPath/shc-git/

sudo mkdir /.krush/
sudo cp -rf $IPath/src/ $InstallPath

cd $InstallPath
shc -f $InstallPath/src/kinstall.sh
mv $InstallPath/src/kinstall.sh /usr/bin/kinstall
chmod +x /usr/bin/kinstall
exit