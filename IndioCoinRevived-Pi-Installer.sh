#!/bin/bash
# cloned from https://github.com/PrivateDOGP/DOGP-PI-Daemon-Installer-Script

# Make sure user is root.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run using sudo."
   exit 1
fi

# Entrypoint
cd ..

# Work-in-Progress
#echo "Reduce GPU memory since we are CLI based?"
#select yn in "Yes" "No"; do
#   case $yn in
#      Yes ) sed -i '/gpu_mem/d' /boot/config.txt; echo "gpu_mem=16" >> /boot/config.txt;;
#      No ) ;;
#   esac
#done

# Work-in-Progress
#echo "Update Pi swap from default 100 to 2048?"
#select yn in "Yes" "No"; do
#   case $yn in
#      Yes ) sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile; /etc/init.d/dphys-swapfile stop; /etc/init.d/dphys-swapfile start;;
#      No ) ;;
#   esac
#done

echo
echo "Installing dependencies for the Indio Coin Revived daemon."
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

# Install Berkeley DB (Indio Coin Revived Core requires BDB 5.1)
mkdir -p /tmp/build/db5 && cd /tmp/build/db5
BDB_PREFIX=$(pwd)

wget http://download.oracle.com/berkeley-db/db-5.1.29.NC.tar.gz

tar -xzf db-5.1.29.NC.tar.gz

cd db-5.1.29.NC/build_unix/
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/tmp/build/db5/
make && make install

sleep 15

# Clone the Indio Coin Revived Core repository and compile

# Work-in-Progress
#echo "What version of Indio Coin Revived are you building?"
#echo "Hint: for example, 1.10)"
#read version

#mkdir -p ~/indio-$version && cd ~/indio-$version
mkdir -p ~/indio-1.10 && cd ~/indio-1.10
INDIOR_ROOT=$(pwd)
git clone https://github.com/shadow-42/Indio.git /tmp/indio
cd /tmp/indio
./autogen.sh
./configure --prefix=$INDIOR_ROOT --enable-static --disable-tests --without-gui --with-unsupported-ssl LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"
sleep 15

echo
echo "Ready to build, please be patient and do not unplug your device at any time.  This could take some time to complete on a Pi..."
echo

make

echo
echo "Build complete. Installing now..."
echo

make install
chown -R $(logname): ~/$INDIO_ROOT

# Work-in-Progress
#echo "Do you want to clean up your build files?"
#select yn in "Yes" "No"; do
#   case $yn in
#      Yes ) rm -r /tmp/build;;
#      No ) ;;
#   esac
#done

# Work-in-Progress
#echo "Do you want an archive that you can move to another Pi?"
#select yn in "Yes" "No"; do
#   case $yn in
#      Yes ) tar zcvf ~/indio-$version.tar.gz ~/indio-$version
#      No ) ;;
#   esac
#done

echo
echo -e "\e[1m\e[92mSetup complete! Now run ~/$INDIOR_ROOT/bin/indiod -daemon or grab the archive\e[0m"
echo
