#!/bin/bash

archive_file="archive.txt"

archiving_mac() {
    local interface=$1
    local og_mac=$2
    local new_mac=$3
    local time=$(date '+%Y-%m-%d %H:%M:%S')

    # Will create the archive file defined above if one does not already exist.
    if [[ ! -f "$archive_file" ]]; then
        echo -e "Welcome to the MAC Archives!" >> "$archive_file"
    fi

    echo -e "\n[$time]" >> "$archive_file"
    echo "Interface: $interface" >> "$archive_file"
    echo "Your old MAC address: $og_mac" >> "$archive_file"
    echo "Your MAC address was changed to: $new_mac" >> "$archive_file"
}

# Check that user gave a real MAC address
mac_validation() {
    local mac=$1
        
        # Uses regular expressions to match 6 pairs of hexadecimals within the acceptable range that are seperated with colons.
        if [[ ! $mac =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
            echo "Please input a valid MAC address. Double check that the address is correct or try reformatting to this format: xx:xx:xx:xx:xx:xx"
            return 1
        fi

    return 0
}

# Check that user gave a real interface option
interface_validation() {
    local interface=$1

        # Essentially checks that the interface is up and running using ip link show.
        if ! ip link show "$interface" &>/dev/null; then
            echo "Please input a valid network interface. Double check your input and try again."
            echo "If you need help finding a valid interface try using ip link show."
            return 1
        fi

    return 0
}

# Putting it all together :D
interface="$1"
new_mac="$2"

# Uses grep to pull out the original MAC address following the same regular expression search from the validation check.
# head -n 1 will only match the first enoucter of a match, which will avoid the archive becoming cluttered with the brd addresses.
old_mac=$(ip link show "$interface" | grep -o -E '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}' | head -n 1)

# Interface validation
if ! interface_validation "$interface"; then
    exit 1
fi

# MAC validation
if ! mac_validation "$new_mac"; then
    exit 1
fi

# Runs an archive entry before carrying out the change.
archiving_mac "$interface" "$old_mac" "$new_mac"

# Bringing the interface down + an error messeage if it fails
if ! ip link set "$interface" down; then
    echo "Failed to bring the interface down."
    exit 1
fi

# Changing the MAC address + an error messeage if it fails
if ! ip link set "$interface" address "$new_mac"; then
    echo "Failed to change the MAC address."
    
    # If it happens to fail, it will be nice and try to bring the interface back up.
    ip link set "$interface" up
    exit 1
fi

# Bringing the interface up + an error messeage if it fails
if ! ip link set "$interface" up; then
    echo "Failed to bring the interface back up."
    exit 1
fi

# Returns some validation for the user to tell them that the change process is completed.
echo "Changed your MAC address ✧( ˶^ ᗜ ^˶ )"
echo "Run ip link show to see the changes made (there might be a little bit of delay or lag)."
echo "Your old IP address was archived in archive.txt. Run cat archive.txt to view it."

exit 0