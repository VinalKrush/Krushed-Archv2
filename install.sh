#!/bin/bash

IPath=${PWD}
InstallPath=/.krush
echo "Installing Dependencies"
sudo pacman -Sy --noconfirm --needed jq dialog fastfetch
cd $IPath

sudo mkdir /.krush/
sudo cp -rf $IPath/src/ $InstallPath

cd $InstallPath
chmod +x $InstallPath/src/kinstall.sh
$InstallPath/src/kinstall.sh
exit