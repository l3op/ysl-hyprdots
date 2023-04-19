#!/bin/bash
#|---/ /+------------------+---/ /|#
#|--/ /-| Global functions |--/ /-|#
#|-/ /--| Prasanth Rangan  |-/ /--|#
#|/ /---+------------------+/ /---|#

set -e

CloneDir=`dirname $(dirname $(realpath $0))`

service_ctl()
{
    local ServChk=$1

    if [[ $(systemctl list-units --all -t service --full --no-legend "${ServChk}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${ServChk}.service" ]]
    then
        echo "$ServChk service is already enabled, enjoy..."
    else
        echo "$ServChk service is not running, enabling..."
        sudo systemctl enable ${ServChk}.service
        sudo systemctl start ${ServChk}.service
        echo "$ServChk service enabled, and running..."
    fi
}

pkg_installed()
{
    local PkgIn=$1

    if pacman -Qi $PkgIn > /dev/null
    then
        #echo "${PkgIn} is already installed..."
        return 0
    else
        #echo "${PkgIn} is not installed..."
        return 1
    fi
}

pkg_available()
{
    local PkgIn=$1

    if pacman -Si $PkgIn > /dev/null
    then
        #echo "${PkgIn} available in arch repo..."
        return 0
    else
        #echo "${PkgIn} not available in arch repo..."
        return 1
    fi
}

aur_available()
{
    local PkgIn=$1

    if pkg_installed yay
    then
        if yay -Si $PkgIn > /dev/null
        then
            #echo "${PkgIn} available in aur repo..."
            return 0
        else
            #echo "${PkgIn} not available in aur repo..."
            return 1
        fi
    else
        #echo "yay is not installed..."
        return 1
    fi
}

