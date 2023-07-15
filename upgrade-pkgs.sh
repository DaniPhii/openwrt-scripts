#!/bin/ash

# Update package lists silently
echo "Updating lists of available packages..."
opkg update -V0
echo -e "Done.\n"

# Obtain the IP address of the remote client connected via SSH
remote_ip=$(netstat -tnpa | grep 'ESTABLISHED.*dropbear' | awk '{print $5}' | cut -d':' -f1)

# Obtain the MAC address of the remote client based on the IP address
remote_mac=$(grep -i "$remote_ip" /proc/net/arp | awk '{print $4}')

# Define the packages that should be excluded from the upgrade
excluded_packages="dropbear hostapd-common netifd wireless-regdb wpad-basic-wolfssl"

# Obtain the list of upgradable packages
pkgs=$(opkg list-upgradable | awk '{print $1}')

# Initialize variables for upgradable and excluded packages
upgradable_pkgs=""
excluded_pkgs=""

# Check if the remote client's MAC address or IP address matches the specified values
if [ "$remote_mac" == "AA:BB:CC:DD:EE:FF" ] || [ "$remote_ip" == "123.123.123.123" ]; then
  # Iterate through each package in the list of upgradable packages
  for pkg in $pkgs; do
    # Check if the package should be excluded
    if ! echo "$excluded_packages" | grep -qw "$pkg"; then
      upgradable_pkgs="$pkg $upgradable_pkgs"
    else
      excluded_pkgs="$pkg $excluded_pkgs"
    fi
  done

  # Sort the excluded packages alphabetically
  excluded_pkgs=$(echo $excluded_pkgs | tr ' ' '\n' | sort)
else
  # Set all upgradable packages to be included
  upgradable_pkgs="$pkgs"
fi

# Sort the upgradable packages alphabetically
upgradable_pkgs=$(echo $upgradable_pkgs | tr ' ' '\n' | sort)

# Check if there are excluded packages and inform the user
if [[ -n "$excluded_pkgs" ]]; then
  echo -e "The following packages are upgradable, but will be excluded:\n"$excluded_pkgs"\n"
fi

# Check if there are no upgradable packages and exit with no errors
if [[ -z "$upgradable_pkgs" ]]; then
  echo -e "No packages are upgradable at the moment.\n"
  exit 0
else
  # Display the list of upgradable packages
  echo -e "The following packages will be upgraded:\n"$upgradable_pkgs"\n"

  # Prompt the user for confirmation to upgrade the packages
  while true; do
    read -p "Do you want to upgrade them? (y/N) " choice
    case $choice in
      [Yy]* ) echo -e "\nStarting upgrade..."
              # Upgrade the packages one by one to prevent the full upgrade from failing
              # in case the Internet connection flaps for a moment while downloading one
              # of the packages
              echo "$upgradable_pkgs" | xargs -n 1 opkg upgrade -V1
              echo -e "\nFinished."
              exit 0
              break;;
      * ) echo -e "\nFinished."
          exit 1
          ;;
    esac
  done
fi


