#!/bin/bash

# Entrypoint
cd ..
apt-get update

# Reduce GPU memory since we are CLI based
sed -i '/gpu_mem/d' /boot/config.txt
echo "gpu_mem=16" >> /boot/config.txt

# Update PI swap from 100 to 1024
sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

# Install Dependancies
apt-get -qq install -y zip curl \
        build-essential \
        libtool \
        autotools-dev \
        autoconf automake pkg-config \
        libevent-dev \
        bsdmainutils \
        git cmake \
        libboost-all-dev \
        libminiupnpc-dev libzmq3-dev \
        libssl1.0-dev libgmp3-dev

# Install Berkeley DB
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xzf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/usr

# Clone the Dogecoin Private Core repository and compile
git clone https://github.com/PrivateDOGP/DOGP-Project.git /usr/local/dogecoinprivate
cd /usr/local/dogecoinprivate
./autogen.sh
./configure --disable-tests --without-gui --with-unsupported-ssl

echo
echo "Ready to build, please be patient and do not unplug your device at any time."
echo

make --quiet -j$(nproc)

echo
echo "Build complete. Installing now..."
echo

make install

chown -R $(logname): ../DOGP-Project

echo
echo -e "\e[1m\e[92mSetup complete! Now run /usr/local/bin/dogecoinprivated --daemon\e[0m"
echo