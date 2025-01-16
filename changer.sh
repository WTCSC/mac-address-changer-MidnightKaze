#!/bin/bash

: '
Approach:
> Build everything bit by bit
> Integrate the error + logging messages to save the pain
> Start with the easy stuff
> Throw it all together
> Do extra credit archiving if ur not dead yet
'

# Check that user gave a real MAC address
mac_validation() {
    local mac=$1
        
        if [[ ! $mac =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
            echo "Please input a valid MAC address. Double check that the address is correct or try reformatting to this format: xx:xx:xx:xx:xx:xx"
            return 1
        fi

    exit 0
}

# Check that user gave a real interface option
interface_validation() {
    local interface=$1

        if ! ip link show "$interface" &>/dev/null; then
            echo "Please input a valid network interface. Double check your input and try again."
            return 1
        fi

    exit 0
}

# Putting it all together :D
interface="$1"
new_mac="$2"

# Argument validation (making sure something was actually provided to begin with)
if [ -z "$interface" ] || [ -z "$new_mac"]; then
    echo "Please provide an interface and or a MAC address."
    echo "Proper usage would look like this: sudo ./changer.sh [interface] [new MAC address]"
    exit 1
fi

: '
Father recommends like downing the interface and then changing the MAC and then upping it again (inquire mr flower abt that)
Seems to be best practice on the internet but lets confirm
For the actual changing of the MAC investigate ip link set or just ip link in general (like we used for the iv above)
'