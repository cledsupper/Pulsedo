#!/data/data/com.termux/files/usr/bin/bash
#############################################
# PulsedoServer                             #
# Version 1.0.5                             #
#                                           #
# This script is part of Pulsedo.           #
# Cledson Cavalcanti (c) 2019               #
# cledsonitgames@gmail.com                  #
# https://ledsotips.wordpress.com/          #
#############################################

PulsedoVer=1.0.5
PulsedoCfgFolder=$HOME/.config/PulsedoServer

function PulsedoHelp() {
    echo "USE: $0 [--start | --stop | -k, kill-server | -r, --remove-def-ip | -h, --help]"
    echo ""
    echo "OPTIONS DESCRIPTION"
    echo "              --start - loads the PulsedoAudio's native-protocol-tcp module for playing sounds from your LAN devices."
    echo "               --stop - unloads the PulsedoAudio's native-protocol-tcp module for not playing sounds from your LAN devices."
    echo "    -k, --kill-server - kindly it kills the PulseAudio server"
    echo "  -r, --remove-def-ip - remove the IP address you had accepted to save as default, so the script will prompt you for IP again."
    echo "           -h, --help - show this help text."
    echo "Warning: any options without dashes are ALL deprecated!"
    echo ""
    echo "PulsedoClient version $PulsedoVer"
    echo "by Lesdo Upper (also known as: Ledso, Cledson, Tales)"
    echo "Contact cledsonitgames@gmail.com for questions."
}

case $1 in
    --start)
        ls $PulsedoCfgFolder/defip 2> /dev/null 1> /dev/null
        if [ $? -ne 0 ]; then
            echo "Please type your computer's IP address connected to the same (W)LAN as this device: [e.g.: 192.168.0.123]"
            echo "OR you can type a masked IP address if you want to receive connections of any computer on your local network, e.g.: 192.168.0.0/24"
            read dev_ip

            echo "Do you want to set this IP as the default one? When doing this, this script will not prompt you anymore."
            echo "You can delete the default IP typing '$0 remove-def-ip' on shell. [Y/n]"
            read uoption

        if [ "$uoption" == "Y" -o "$uoption" == "y" ]; then
            mkdir -p $PulsedoCfgFolder
            echo "$dev_ip" > $PulsedoCfgFolder/defip
            echo "$dev_ip set as default!"
        fi

        else
            dev_ip=`cat $PulsedoCfgFolder/defip`
        fi

        pulseaudio --check
        if [ $? -eq 1 ]; then
            pulseaudio --start --exit-idle-time=-1
            error_code=$?
            if [ $error_code -ne 0 ]; then
                echo "Please make sure PulseAudio is well installed and configured."
                echo "You can try killing PulseAudio with \"pulseaudio --kill\" to make sure everything is fine."
                exit $error_code
            fi
        fi
        pacmd load-module module-native-protocol-tcp auth-ip-acl=$dev_ip auth-anonymous=1
        ;;

    --stop)
        pacmd unload-module module-native-protocol-tcp
        echo "You must kill PulseAudio Server if using this on Termux!"
        echo "You can do this running the command '$0 kill-server'" ;;

    -k|--kill-server)
        pulseaudio --kill
        ;;

    -r|--remove-def-ip)
        rm $PulsedoCfgFolder/defip 2> /dev/null
        ls $PulsedoCfgFolder/defip 1> /dev/null 2> /dev/null
        if [ $? -ne 0 ]; then
            echo "Default IP removed!"
        else
            echo "Error when trying to remove saved IP. Please check 'defip' for file write permissions at $PulsedoCfgFolder and try again."
        fi
        ;;

    *)
        PulsedoHelp
        ;;
esac
