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

sys-install() {
    cd
    loadkeys us
    pacman -Syu --noconfirm
    clear
    hwclocl --systohc

    sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8' /etc/locale.gen
    locale-gen
    echo "LANG=en=US.UTF-8" >> /etc/locale.conf
    echo "${D_SysName}" > /etc/hostname
    touch /etc/vconsole.conf
    echo "KEYMAP=us" > /etc/vconsole.conf
    clear

    cat <<EOF > /etc/hosts
    127.0.0.1	localhost
    ::1		localhost
    127.0.1.1	${D_SysName}.localdomain	${D_SysName}
EOF
    clear

    mkinitcpio -P
    clear
    echo root:$D_RPasswd | chpasswd
    useradd -m -G wheel,storage,power,audo $D_User
    echo $D_User:$D_UPasswd | chpasswd
    ln -s /usr/bin/vim /usr/bin/vi
    systemctl enable NetworkManager.service sshd.service
    cd /home/${D_User}
    chown -R $D_User:$D_User /home/$D_User
    clear
    cd

    #Grub
    # AMD
    if [[ $D_SysCpuPlat == '1' ]]
    then
	    sudo sed -i 's/^GRUB_CMDLINE_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_DEFAULT="initrd=\amd-ucode amd_pstate=active quiet loglevel=1 nowatchdog usbcore.autosuspend=-1 audit=0 pcie_aspm=off video=efifb:auto mitigations=off nvidia-drm.modeset=1"/' /etc/default/grub
    # INTEL
    elif [[ $D_SysCpuPlat == '2' ]]
    then
	    sudo sed -i 's/^GRUB_CMDLINE_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_DEFAULT="initrd=\intel-ucode intel_pstate=active quiet loglevel=1 nowatchdog usbcore.autosuspend=-1 audit=0 pcie_aspm=off video=efifb:auto mitigations=off nvidia-drm.modeset=1"/' /etc/default/grub
    fi

    sudo sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/'

    sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=${D_SysName}-Grub-Manager

    sudo grub-mkconfig -o /boot/grub/grub.cfg

    su $D_User -c /.krush/src/.user-install.sh
}

sys-install
exit