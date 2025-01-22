import subprocess
import re
import sys

# Omit archiving for now.

def mac_validation(mac):
    mac_match = r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$'
    
    if not re.match(mac_match, mac):
        print ("Please input a valid MAC address. Double check that the address is correct or try reformatting to this format: xx:xx:xx:xx:xx:xx")
        return False
    
    return True

def interface_validation(interface):
    try:
        subprocess.check_output(['ip', 'link', 'show', interface], stderr=subprocess.STDOUT)
        return True
    
    except:
        subprocess.CalledProcessError
        print("Please input a valid network interface. Double check your input and try again.")
        return False
    
# Putting it all together :D
def main():

    # Interface is the argument in position 1
    interface = sys.argv[1]

    # MAC is the argument in position 2 >>> use os.sys.argv?
    mac = sys.argv[2]

    # Runs the validation checks
    if not mac_validation(mac):
        return
    
    if not interface_validation(interface):
        return
    
    if not subprocess.run(['ip', 'link', 'set', interface, 'down']):
        print("Failed to bring the interface down.")
        return
    
    if not subprocess.run(['ip', 'link', 'set', interface, 'address', mac]):
        print("Failed to change the MAC address.")
        subprocess.run(['ip', 'link', 'set', interface, 'up'])
        return