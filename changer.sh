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
        
        if
        # Actual check goes here. Only checks if it doesn't meet it
        echo "Please input a valid MAC address. Double check that the address is correct or try reformatting to this format: xx:xx:xx:xx:xx:xx"
        exit 1
        fi

    exit 0
}

# Check that user gave a real interface option
interface_validation() {
    local interface=$1

        if
        # Actual check goes here. Only checks if it doesn't meet it
        echo "Please input a valid network interface. Double check your input and try again."
        exit 1
        fi

    exit 0
}

# Actually changes the address
change_mac() {

}

# Putting it all together :D