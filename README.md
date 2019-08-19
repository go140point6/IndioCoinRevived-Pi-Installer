# IndioCoin Revivied Daemon Installer Script for Raspberry Pi

Tested on Raspberry Pi 3b+ running Raspbian Stretch (2019-04-08)
https://downloads.raspberrypi.org/raspbian/images/raspbian-2019-04-09/

Note: Tested on a Pi 4 running Rasbian Buster (2019-07-10) and compile errors due to SSLv3 issue.

<img src="https://raw.githubusercontent.com/go140point6/IndioCoinRevived-Pi-Installer/master/github-pinew.jpg">

The following script will automate the install of the Indio Coin Revived daemon.

Clone this repository with ```git clone https://github.com/go140point6/IndioCoinRevived-Pi-Installer.git```

## IndioCoinRevived-Pi-Daemon-Installer
Use this script to setup the Indio Coin Revived daemon. 

Change into the cloned directory ```cd IndioCoinRevived-Pi-Installer```

Run the setup script as root using ```sudo ./IndioCoinRevived-Pi-Installer.sh```

Once the installer is complete, run the daemon with ```~/indio-1.10/bin/indiod -daemon```

Be sure to add rcpuser and rpcpassword information to ~/.indio/indio.conf as well as the currently known good nodes:

```
rpcuser={something long and random here}
rpcpassword={something longer and randomer here}
addnode=3.215.162.101:22559
addnode=174.138.42.183:22559
addnode=24.202.30.104:22560
addnode=159.89.80.19:22559
addnode=144.202.18.18:22559
```

To do:
- create more interactive script with some additional options
- build a completely static build without the need for compiling BDB, openssl, etc.
- see if I can get it working on Buster (Pi 4)
