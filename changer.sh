#!/bin/bash

: '
Approach:
> Build everything bit by bit [basically done]
> Integrate the error + logging messages to save the pain [getting there]
> Start with the easy stuff [done]
> Throw it all together [getting there]
> Do extra credit archiving if ur not dead yet [not even started]
> Oh and write the readmeh [not even started]
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
            echo "If you need help finding a valid interface try using ip link show."
            return 1
        fi

    exit 0
}

# Putting it all together :D
interface="$1"
new_mac="$2"

# Argument validation (making sure something was actually provided to begin with)
if [ -z "$interface" ] || [ -z "$new_mac" ]; then
    echo "Please provide an interface and or a MAC address."
    echo "Proper usage would look like this: sudo ./changer.sh [interface] [new MAC address]"
    echo "If you need help finding a valid interface try using ip link show."
    exit 1
fi

# Interface validation
if ! interface_validation "$interface"; then
    exit 1
fi

# MAC validation
if ! mac_validation "$new_mac"; then
    exit 1
fi

# Bringing the interface down + an error logging combo if it fails
if ! ip link set "$interface" down; then
    echo "Failed to bring the interface down."
    exit 1
fi

# Changing the MAC address + an error logging combo if it fails
if ! ip link set "$interface" address "$new_mac"; then
    echo "Failed to change the MAC address."
    
    # If it does fail, it will be nice and try to bring the interface back up anyway
    ip link set "$interface" up
    exit 1
fi

# Bringing the interface up + an error logging combo if it fails
if ! ip link set "$interface" up; then
    echo "Failed to bring the interface back up."
    exit 1
fi

echo "Changed your MAC address :D"
# Can add a more proper validaton check here if you want lol
exit 0

: '
Father recommends like downing the interface and then changing the MAC and then upping it again
    > ip link set "$interface" down
    > ip link set "$interface" address "$new_mac"
    > ip link set "$interface" up
    > maybe need dev after set? who knows really [investigating but later]

For the actual changing of the MAC investigate ip link set or just ip link in general (like we used for the iv above) [done and typed above]
'