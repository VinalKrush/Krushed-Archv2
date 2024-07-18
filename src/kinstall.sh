#!/bin/bash

#clear

# Start up!
D_Start_Installer() {
                 --pause "Please Wait..." 10 40 10
        D_Welcome() {
            dialog --infobox "Welcome!" 10 40
            # pingSlave=$(fping -c5 -t300 8.8.8.8 2>/dev/null 1>/dev/null)
            # What is reason for introducing pingSlave var :)?
            # if [ "$?" = 0 ]
            # then
            #    result="Ping succeed for 8.8.8.8"
            #    dialog \
            #    --backtitle "test1" \
            #    --title "test2" \
            #    --no-collapse \
            #    --msgbox "$result" 50 50 
            # fi
        }        
    clear   
    InstallerPath=/.krush/
    cd $InstallerPath
    sudo mkdir -p $InstallerPath/.tmp/
    sudo touch $InstallerPath/.tmp/.info.json
    sudo cp -rf $InstallerPath/src/R/erc/pacman.conf /etc/
    sudo cp -rf $InstallerPath/src/mirrors/us/mirrorlist /etc/pacman.d/
    loadkeys us
    timedatectl
    sudo pacman -Sy --noconfirm
    echo "Krushed Installer Started"
    clear
    D_Welcome
    sleep 2
    dialog --clear
    clear

}
D_Start_Installer
clear


# Base System Setup
Base_Setup() {
    D_SysCpuPlat=$(dialog --title "CPU Platform" --menu "Type:" 10 40 0 1 "AMD" 2 "INTEL" 3>&1 1>&2 2>&3 3>&-)
    clear
    D_SysName=$(dialog --inputbox "Please Enter A System Name:" 0 0 3>&1 1>&2 2>&3 3>&-)
    clear
    D_User=$(dialog --inputbox "Please Enter A User Name:" 0 0 3>&1 1>&2 2>&3 3>&-)
    clear
    D_UPasswd=$(dialog --insecure --passwordbox "Please Enter A Password For ${D_User}:" 0 0 3>&1 1>&2 2>&3 3>&-)
    clear
    D_RPasswd=$(dialog --insecure --passwordbox "Please Enter A Password For Root (Leave empty to disable root. Not recommended):" 0 0 3>&1 1>&2 2>&3 3>&-)
    clear



    #### DRIVE SETUP



    ## Tempoary Until I Find Out How To Get LSBLK To Show In Dialog
    # DRIVES= "sudo fdisk =l"
    # dialog --title "Please Take This Time To Review Your Drives" --msgbox ${DRIVES} 20 50
    # D_SysDrive=$(dialog --inputbox "Please Enter A Password For Root (Leave empty to disable root. Not recommended):" 0 0 3>&1 1>&2 2>&3 3>&-)

    lsblk
    echo "_______________________________________________________________________________________________"
    echo "Please Take A Moment To Review Your Drives"
    echo "Press ENTER To Continue"
    echo "_______________________________________________________________________________________________"
    read
    clear

    lsblk
    echo "_______________________________________________________________________________________________"
    echo "Try To Keep Your Partitions In This Order:"
    echo "sda1      -       EFI"
    echo "sda2      -       SWAP"
    echo "sda3      -       ROOT"
    echo "sda4      -       HOME"
    echo ""
    echo "Type The Drive you Would Like To Install Linux On (Example: /dev/sda, /dev/vda, or /dev/nvme0n1)"
    echo "_______________________________________________________________________________________________"
    read D_SysDrive
    clear

    lsblk
    echo "_______________________________________________________________________________________________"
    echo ""
    echo ""
    echo ""
    echo "Type The Drive Again To Confirm (Example: /dev/sda, /dev/vda, or /dev/nvme0n1)"
    echo ""
    echo ""
    echo ""
    echo "_______________________________________________________________________________________________"
    read
    clear
    wipefs -a ${D_SysDrive}
    clear
    cfdisk ${D_SysDrive}
    clear

    lsblk
    echo "_______________________________________________________________________________________________"
    echo "Try To Keep Your Partitions In This Order:"
    echo "# - EFI"
    echo "# - SWAP"
    echo "# - ROOT"
    echo "# - HOME"
    echo ""
    echo "PLEASE DEFINE YOUR BOOT PARTITION (Example: /dev/sda1 & /dev/nvme0n1p1)"
    echo "_______________________________________________________________________________________________"
    echo "If you mess up, the only way to undo for now is to restart the installation by pressing CTRL + C"
    read D_SysBoot
    clear

    lsblk
    echo "_______________________________________________________________________________________________"
    echo "Try To Keep Your Partitions In This Order:"
    echo "${D_SysBoot} - EFI"
    echo "${D_SysSwap} - SWAP"
    echo "# - ROOT"
    echo "# - HOME"
    echo ""
    echo "PLEASE DEFINE YOUR SWAP PARTITION (Example: /dev/sda1 & /dev/nvme0n1p1)"
    echo "_______________________________________________________________________________________________"
    echo "If you mess up, the only way to undo for now is to restart the installation by pressing CTRL + C"
    read D_SysSwap
    clear

    lsblk
    echo "_______________________________________________________________________________________________"
    echo "Try To Keep Your Partitions In This Order:"
    echo "${D_SysBoot} - EFI"
    echo "${D_SysSwap} - SWAP"
    echo "# - ROOT"
    echo "# - HOME"
    echo ""
    echo "PLEASE DEFINE YOUR ROOT PARTITION (Example: /dev/sda1 & /dev/nvme0n1p1)"
    echo "_______________________________________________________________________________________________"
    echo "If you mess up, the only way to undo for now is to restart the installation by pressing CTRL + C"
    read D_SysRoot
    clear

    lsblk
    echo "_______________________________________________________________________________________________"
    echo "Try To Keep Your Partitions In This Order:"
    echo "${D_SysBoot} - EFI"
    echo "${D_SysSwap} - SWAP"
    echo "${D_SysRoot} - ROOT"
    echo "# - HOME"
    echo ""
    echo "PLEASE DEFINE YOUR HOME PARTITION (Example: /dev/sda1 & /dev/nvme0n1p1)"
    echo "_______________________________________________________________________________________________"
    echo "If you mess up, the only way to undo for now is to restart the installation by pressing CTRL + C"
    read D_SysHome
    clear

    echo "_______________________________________________________________________________________________"
    echo "Try To Keep Your Partitions In This Order:"
    echo "${D_SysBoot} - EFI"
    echo "${D_SysSwap} - SWAP"
    echo "${D_SysRoot} - ROOT"
    echo "${D_SysHome} - HOME"
    echo ""
    echo "Press ENTER To Confirm This Partition Setup"
    echo "_______________________________________________________________________________________________"
    echo "If you mess up, the only way to undo for now is to restart the installation by pressing CTRL + C"
    read
    clear

    mkfs.vfat -n BOOT -F 32 "${D_SysBoot}"

    mkswap -L Swap "${D_SysSwap}"
    swapon "${D_SysSwap}"
    swapon -a

    mkfs.ext4 -L "${D_SysName}"-Root "${D_SysRoot}"

    mkfs.ext4 -L "${D_SysName}"-Home "${D_SysHome}"

    mount --mkdir "${D_SysRoot}" /mnt
    mount --mkdir "${D_SysBoot}" /mnt/boot/efi
    mount --mkdir "${D_SysHome}" /mnt/home



    #### KERNEL SELECTION



    D_Kern=$(dialog --title "Please Select A Kernel:" --menu "Kernel:" 10 40 0 1 "Linux" 2 "Linux Zen" 3 "Linux Hardened" 4 "Linux LTS" 3>&1 1>&2 2>&3 3>&-)
    clear



    #### DISPLAY DRIVER SELECTION



    D_Disp=$(dialog --title "Please Select Display Driver:" --menu "Display Driver:" 10 40 0 1 "NVIDIA" 2 "INTEL" 3 "AMD" 4 "NONE" 3>&1 1>&2 2>&3 3>&-)
    clear



    #### INSTALL TYPE


    
    D_Krush=$(dialog --title "What Type Of Install Do You Want To Do:" --menu "Type:" 10 40 0 1 "Krushed Install" 2 "Minimal Install" 3>&1 1>&2 2>&3 3>&-)
    clear



    #### Making JSON



    install_json=$(cat <<EOF
        {
            "SysCpuPlat": "${D_SysCpuPlat}",
            "SysName": "${D_SysName}",
            "User": "${D_User}",
            "UPasswd": "${D_UPasswd}",
            "RPasswd": "${D_RPasswd}",
            "SysDrive": "${D_SysDrive}",
            "Kern": "${D_Kern}",
            "Disp": "${D_Disp}",
            "Krush": "${D_Krush}
        }
EOF    
    )
    echo $install_json >> $InstallerPath/.tmp/.info.json
    clear

    sleep 5

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



    #### INSTALLING LINUX



    pacstrap -K /mnt base base-devel jq
    mkdir -p /mnt/.krush/
    cp -rf $InstallerPath/src/ /mnt/.krush/
    cp -rf $InstallerPath/.tmp/ /mnt/.krush/
    chmod +x /mnt/.krush/src/.krushed-install.sh
    chmod +x /mnt/.krush/src/.user-install.sh
    chmod +x /mnt/.krush/src/.sys-install.sh
    clear



    #### INSTALLING KERNEL

        

    if [[ $D_Kern == '1' ]]; then
        pacstrap -K /mnt linux linux-firmware linux-headers
    elif [[ $D_Kern == '2' ]]; then
        pacstrap -K /mnt linux-zen linux-firmware linux-headers
    elif [[ $D_Kern == '3' ]]; then
        pacstrap -K /mnt linux-hardened linux-firmware linux-headers
    else
        pacstrap -K /mnt linux-lts linux-firmware linux-headers
    fi
    clear



    #### INSTALLING DISPLAY DRIVERS



    if [[ $D_Disp == '1' ]]; then
        pacstrap -K /mnt nvidia-dkms nvidia-utils lib32-nvidia-utils
    elif [[ $D_Disp == '2' ]]; then
        pacstrap -K /mnt mesa lib32-mesa vulkan-intel lib32-vulkan-intel
    elif [[ $D_Disp == '3' ]]; then
        pacstrap -K /mnt mesa lib32-mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau
    else 
	    echo "No Display Driver Selected (CPU Rendering May Cause Extreme Lag!)"
	    echo "Skipping..."
	    sleep 3
    fi
    clear



    #### OTHER NEEDS



    pacstrap -K /mnt grub os-prober efibootmgr vim git xorg xorg-server openssh wayland dhclient networkmanager
    if [[ $D_SysCpuPlat == '1' ]]; then
	    pacstrap -K /mnt amd-ucode
    else
	    pacstrap -K /mnt intel-ucode
    fi
    sleep 3
    clear



    #### SETTING UP SYSTEM



    genfstab -U /mnt >> /mnt/etc/fstab
    clear

    cp -rf $InstallerPath/src/mirrors/us/mirrorlist /mnt/etc/pacman.d/
    clear

    arch-chroot /mnt bash /mnt/.krush/src/.sys-install.sh
    clear



    #### AFTER INSTALL



    ffetch= fastfetch
    echo "${fastfetch}"
    dialog --title "INSTALL FINISHED" --msgbox "The Krushed Installer Has Finished Installing Arch Linux\!" 10 90
    clear

    dialog --title "INSTALL FINISHED" --yesno "Would You Like To Boot Into Your Linux New Install?" 10 90 && sudo reboot now || arch-chroot /mnt bash "su ${D_User}"
    clear
}
Base_Setup
clear           