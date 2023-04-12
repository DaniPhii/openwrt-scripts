#!/bin/ash
echo "Updating lists of available packages..."
opkg update -V0
echo -e "Done.\n"

excluded_packages="dropbear hostapd-common iw netifd wireless-regdb wpad-basic-wolfssl"

pkgs=$(opkg list-upgradable | awk '{print $1}')
upgradable_pkgs=""
excluded_pkgs=""
for pkg in $pkgs; do
    if ! echo "$excluded_packages" | grep -qw "$pkg"; then
        upgradable_pkgs="$upgradable_pkgs $pkg"
    else
        excluded_pkgs="$excluded_pkgs $pkg"
    fi
done

if [[ -z "$upgradable_pkgs" ]]; then
  echo -e "No packages are upgradable.\n"; exit 0 
else
  if [[ -n "$excluded_pkgs" ]]; then
    echo -e "The following packages are upgradable, but will be excluded: $excluded_pkgs\n"
  fi
  echo -e "The following packages are upgradable:\n$upgradable_pkgs"
  echo " "
  while true; do
    read -p "Do you want to upgrade them? (y/N) " choice
    case $choice in
      [Yy]* ) echo -e "\nStarting upgrade..."; echo "$upgradable_pkgs" | xargs -n 1 opkg upgrade -V1; echo -e "\nFinished."; exit 0; break;;
      * ) echo -e "\nFinished."; exit 1;;
    esac
  done
fi
