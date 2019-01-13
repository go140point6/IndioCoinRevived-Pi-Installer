#!/bin/bash

# Entrypoint
cd ..
apt-get update

# Install Dependancies
apt-get -qq install zip curl \
        build-essential \
        libtool \
        autotools-dev \
        autoconf automake pkg-config \
        libssl-dev \
        libevent-dev \
        bsdmainutils \
        git cmake \
        libboost-all-dev \
        libdb5.3-dev libdb5.3++-dev \
        libminiupnpc-dev libzmq3-dev \
        libssl1.0-dev libgmp3-dev

# Clone the Dogecoin Private Core repository and compile
git clone https://github.com/PrivateDOGP/DOGP-Project.git
cd DOGP-Project
./autogen.sh
./configure --disable-tests --without-gui --with-incompatible-bdb --with-unsupported-ssl
make -j$(nproc)
echo "Build complete. Installing now!"
make install

chown -R $(logname): ../DOGP-Project

echo
echo -e "\e[1m\e[92mSetup complete! Now run /usr/local/bin/dogecoinprivated --daemon\e[0m"
echo