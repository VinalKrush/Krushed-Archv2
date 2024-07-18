#!/bin/bash

#clear

# Start up!
D_Start_Installer() {
    dialog --title "Starting Krushed Installer..." --pause "Please Wait..." 10 40 10
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
    sudo touch $InstallerPath/.tmp/.info.json
    sudo cp -rf $InstallerPath/src/R/erc/pacman.conf /etc/
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
    D_Sysname=$(dialog --inputbox "Please Enter A System Name:" 0 0 3>&1 1>&2 2>&3 3>&-)
    clear
    D_User=$(dialog --inputbox "Please Enter A User Name:" 0 0 3>&1 1>&2 2>&3 3>&-)
    clear
    D_UPasswd=$(dialog --inputbox "Please Enter A Password For ${D_User}:" 0 0 3>&1 1>&2 2>&3 3>&-)
    clear
    D_RPasswd=$(dialog --inputbox "Please Enter A Password For Root (Leave empty to disable root. Not recommended):" 0 0 3>&1 1>&2 2>&3 3>&-)
    
}

Base_Setup
clear