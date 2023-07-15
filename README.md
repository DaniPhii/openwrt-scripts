# OpenWrt Scripts
Scripts I've made for myself to manage OpenWrt installations.

## Summary
Here you have a brief description of my scripts:
* **`upgrade-pkgs.sh`** updates lists of available packages, checks if the user is connected via SSH and gets their MAC and IP addresses to control which upgradable packages should not be upgraded at the moment (for example, Network Interface Daemon `netifd` gets restarted when it gets upgraded, which causes a broken pipe when connected via SSH), and then it upgrades the rest one by one to prevent any issues if one of the packages cannot be downloaded due to an Internet connection flap. The code is commented in case anybody needs to modify any bits of the script to suit their needs specifically.
