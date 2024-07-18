#!/bin/bash

IPath=${PWD}
InstallPath=/.krush/
echo "Installing Dependencies"
sudo pacman -Sy --noconfirm --needed jq dialog fastfetch

cd $IPath
git clone https://github.com/neurobin/shc.git
cd shc
./autogen.sh
./configure
make -s
sudo make -s install
cd $IPath
sudo rm -rf $IPath/shc/

sudo mkdir /.krush/
sudo cp -rf $IPath/src/ $InstallPath

cd $InstallPath
shc -f $InstallPath/src/kinstall.sh
mv $InstallPath/src/kinstall.sh /usr/bin/kinstall
chmod +x /usr/bin/kinstall
exit