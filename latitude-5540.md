# Laptop_Setup
## Type
Dell Latitude 5540 with 2 ssds

## How to dual boot

## Windows

## Ubuntu
### fingerprint service (broken)
Dell does not support it and this workaround gets me stuck in login screen, so that i have to reboot.
Make sure your system is up to date:
```
sudo apt update
sudo apt upgrade
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo fwupdmgr update
```
Install fprintd and necessary packages:
`sudo apt install fprintd git python3-pip`

Install driver itself:
1.  go here and get the newest libssl1.1-udeb_1.1.1f-1ubuntu package https://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/ with wget <link>
2.  check this link and get the newest <package>.deb driver: http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-broadcom/ 
3.  you can install both now with `sudo apt install <package>.deb`
4.  enable fingerprint service: `sudo pam-auth-update`
5. reboot and find the new login-via-fingerprint option in User-Settings
