#!/bin/bash

# Make sure user is root.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run using sudo."
   exit 1
fi

# Entrypoint
cd ..

# Reduce GPU memory since we are CLI based
sed -i '/gpu_mem/d' /boot/config.txt
echo "gpu_mem=16" >> /boot/config.txt

# Update PI swap from 100 to 1024
sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

echo
echo "Installing dependencies for the DOGP daemon."
echo

# Install Dependencies
apt-get -qq update

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

apt-get -qq autoremove -y

# Install Berkeley DB
mkdir -p /tmp/db4 && cd /tmp/db4

wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz

tar -xzf db-4.8.30.NC.tar.gz

cd db-4.8.30.NC/build_unix/

../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/usr

make -j$(nproc)

make install

# Clone the Dogecoin Private Core repository and compile
git clone https://github.com/PrivateDOGP/DOGP-Project.git /usr/local/dogecoinprivate

cd /usr/local/dogecoinprivate

./autogen.sh

./configure --disable-tests --without-gui --with-unsupported-ssl

echo
echo "Ready to build, please be patient and do not unplug your device at any time."
echo

make -j$(nproc)

echo
echo "Build complete. Installing now..."
echo

make install

chown -R $(logname): ../DOGP-Project

echo
echo -e "\e[1m\e[92mSetup complete! Now run /usr/local/bin/dogecoinprivated --daemon\e[0m"
echo