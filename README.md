# Dogecoin Private Daemon Installer Script for Raspberry PI

The following script will automate the install of the Dogecoin Private Daemon.

Clone this repository with ```git clone https://github.com/PrivateDOGP/DOGP-PI-Daemon-Installer-Script.git```.

## Raspberry PI Memory Issues
Compiling this code may result in your PI running out of memory.

Increase the swap to avoid this.

```sudo nano /etc/dphys-swapfile```

The default value in Raspbian is:

```CONF_SWAPSIZE=100```

Change this to:

```CONF_SWAPSIZE=1024```

Save these changes, and restart the service.

```sudo /etc/init.d/dphys-swapfile stop```

```sudo /etc/init.d/dphys-swapfile start```

Now you should be able to continue.

## DOGP-PI-Daemon-Installer-Script
Use this script to setup the Dogecoin Private daemon. 

Change into the cloned directory ```cd DOGP-PI-Daemon-Installer-Script```

Run the setup script as root using ```sudo ./Dogecoin-Private-PI-Daemon-Installer.sh```

Once the installer is complete, run the daemon with ```/usr/local/bin/dogecoinprivated --daemon```