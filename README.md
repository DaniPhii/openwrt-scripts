# OpenWrt Scripts
Scripts I've made for myself to manage OpenWrt installations.

## Summary
Here you have a brief description of my scripts:
* **`upgrade-pkgs.sh`** updates lists of available packages, checks which installed packages are upgradable and it upgrades them one by one. It also checks if `netifd` and some other packages are upgradable to exclude them and avoid any upgrade issues when I'm connected via SSH (for example, Network Interface Daemon gets restarted when it gets upgraded, which causes a broken pipe.)
