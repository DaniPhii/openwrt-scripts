#!/bin/ash
echo "Updating lists of available packages..."
opkg update -V0
echo -e "Done.\n"
pkgs=`opkg list-upgradable | cut -d " " -f 1`
if [[ -z "$pkgs" ]]; then
  echo -e "No packages are upgradable.\n"
else
  if [[ -z `echo "$pkgs" | grep netifd` ]]; then
    echo -e "The following packages are upgradable:\n"
    echo $pkgs
  else
    echo -e "The following packages are upgradable, 'netifd' is put in last place to avoid any issues:\n"
    pkgs=`echo -e "$(echo "$pkgs" | grep -v netifd)\nnetifd"`
    echo $pkgs
  fi
  echo " "
  while true; do
    read -p "Do you want to upgrade them? (y/N) " choice
    case $choice in
      [Yy]* ) echo -e "\nStarting upgrade..."; echo "$pkgs" | xargs -n 1 opkg upgrade -V1; echo -e "\nFinished."; exit 0; break;;
      * ) echo -e "\nFinished."; exit 1;;  
    esac
  done
fi
