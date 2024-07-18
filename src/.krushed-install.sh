InstallerPath=/.krush/
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

cd
yay -Syu --needed --noconfirm ark konsole steam lutris flatpak dpkg jre-openjdk jre8-openjdk jre11-openjdk jre17-openjdk jre21-openjdk gnome-calculator fzf ufw lib32-vkd3d lightdm web-greeter plasma vesktop libreoffice-fresh dolphin kvantum ocs-url qemu libvirt edk2-ovmf virt-manager ebtables dnsmasq
clear
yay -Rns --noconfirm sddm sddm-kcm

sudo cp -rf /.krush/src/lightdm /etc

echo "INSTALLING ZSH"
echo "DO NOT SET ZSH AS DEFAULT TERMINAL"
echo "WHEN YOU ENTER ZSH, TYPE EXIT"
echo "PRESS ENTER IF YOU UNDERSTAND"
read
sleep 2
clear

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
clear
sudo cp -rf /.krush/src/R/home/user/.zshrc /home/${D_User}/

sudo systemctl enable libvirtd.service virtlogd.socket lightdm.service
sudo systemctl restart libvirtd
sudo systemctl enable libvirtd
sudo virsh net-autostart default
sudo virsh net-start default
exit