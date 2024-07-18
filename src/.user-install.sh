InstallerPath=/.krush
D_SysCpuPlat= jq .SysCpuPlat $InstallerPath/.tmp/.info.json
D_SysName= jq .SysName $InstallerPath/.tmp/.info.json
D_User= jq .User $InstallerPath/.tmp/.info.json
D_UPasswd= jq .UPasswd $InstallerPath/.tmp/.info.json
D_RPasswd= jq .RPasswd $InstallerPath/.tmp/.info.json
D_SysDrive= jq .SysDrive $InstallerPath/.tmp/.info.json
D_Kern= jq .Kern $InstallerPath/.tmp/.info.json
D_Disp= jq .Disp $InstallerPath/.tmp/.info.json
D_Krush= jq .Krush $InstallerPath/.tmp/.info.json
clear

## Installing YAY
cd
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si --noconfirm
cd
sudo rm -rf yay
clear

yay -Syu --needed --noconfirm pipewire lib32-pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack lib32-pipewire-jack fastfetch firefox git zsh vim ldns noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-hack-nerd wget curl xclip unzip unrar gparted gnome-disk-utility gvfs gvfs-afc bpytop os-prober grub-customizer less qpwgraph fuse3 fuse2 alsa-utils btrfs-progs exfat-utils ntfs-3g mkinitcpio-randommac mkinitcpio-archlogo mkinitcpio-numlock mkinitcpio-firmware numlockx

# Krushed Packages
# ark konsole steam lutris flatpak dpkg jre-openjdk jre8-openjdk jre11-openjdk jre17-openjdk jre21-openjdk gnome-calculator fzf ufw lib32-vkd3d lightdm web-greeter plasma vesktop libreoffice-fresh dolphin kvantum ocs-url qemu libvirt edk2-ovmf virt-manager ebtables dnsmasq

sudo systemctl enable bluetooth.service

if [[ $D_Disp == '1' ]]
then
	sudo systemctl enable nvidia-resume.service
fi

cd
if [[ $D_Krush == '1' ]]
then
    /.krush/src/.krushed-install.sh
    exit
else
    exit
fi
exit