#!/bin/bash
#############################################
# PulsedoClient                             #
# Version 1.0.5                             #
#                                           #
# This script is part of Pulsedo.           #
# Cledson Cavalcanti (c) 2019               #
# cledsonitgames@gmail.com                  #
# https://ledsotips.wordpress.com/          #
#############################################

PulsedoVer=1.0.5
PulsedoCfgFolder=$HOME/.config/PulsedoClient

function PulsedoHelp() {
    echo "USE: $0 [<command> | <-r |--remove-def-ip> | <-h | --help>]"
    echo ""
    echo "OPTIONS DESCRIPTION"
    echo "            <command> - a command or program name to be runned with Pulsedo. That is, with the environment variable PULSE_SERVER set."
    echo "  -r, --remove-def-ip - remove the IP address you had accepted to save as default, so the script will prompt you for IP again."
    echo "           -h, --help - show this help text."
    echo "Warning: any options without dashes, except <command>, are ALL deprecated!"
    echo ""
    echo "PulsedoClient version $PulsedoVer"
    echo "by Lesdo Upper (also known as: Ledso, Cledson, Tales)"
    echo "Contact cledsonitgames@gmail.com for questions."
}

ls $PulsedoCfgFolder/defip 2> /dev/null 1> /dev/null
ls_return=$?
use_new_opening_method=1
run_command=0

case $1 in
    stream)
        use_new_opening_method=0
        echo "WARNING: 'stream' is deprecated since ver. 1.0.5!"
        echo "You should insert the shell command instead."

        echo "Insert command/program name below for running with PulsedoClient:"
        read sh_cmd
        run_command=1
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

    help|-h|--help)
        PulsedoHelp
        ;;

    *)
        # Nothing seems like a help ask
        if [ "$1" == "" ]; then
            PulsedoHelp
        else
            run_command=1
        fi
        ;;
esac

if [ $run_command -eq 0 ]; then
    exit 0
fi

if [ $ls_return -ne 0 ]; then
    echo "Type the IP address of PulsedoServer (the same device's IP where PulsedoServer is running): [e.g.: 192.168.0.132]"
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

if [ $use_new_opening_method -eq 1 ]; then
    sh_cmd=$@
fi

env PULSE_SERVER=$dev_ip $sh_cmd &
echo "You need to quit this program before shutting the PulsedoServer down."
