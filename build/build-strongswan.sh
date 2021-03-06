#!/bin/bash
# Build Strongswan on Ubuntu 16.04

STRONGSWAN_LATEST_URL=https://download.strongswan.org/strongswan.tar.bz2
STRONGSWAN_LATEST_SIG=https://download.strongswan.org/strongswan.tar.bz2.sig

function checkRet {
  "$@"
  ret=$?
  if [[ $ret != 0 ]]; then
    echo "Error - Unable to execute '$@' - Return code $ret"
    exit $ret
  fi
}

if [ `id -u` == 0 ]; then
  echo "Don't run script as root, I'll sudo a command if I need to."
  exit 1
fi

# Ensure apt-get is up-to-date
checkRet sudo apt-get -y update

# Install build tools and libgmp etc.
checkRet sudo apt-get -y install 	build-essential \
			libgmp-dev \
			libcap2 \
			libcap-dev \
			libssl-dev

# Change to temporary directory
cd /tmp

# Ensure no existing Strongswan installations exist
rm -r strongswan*

# Download the latest version of Strongswan
checkRet wget $STRONGSWAN_LATEST_URL

# Download latest signature
checkRet wget $STRONGSWAN_LATEST_SIG

# Get Andreas' public key to check signature
checkRet gpg --keyserver keyserver.ubuntu.com --recv-key DF42C170B34DBA77

# Verify Strongswan tarball using gnupg
checkRet gpg --verify strongswan.tar.bz2.sig strongswan.tar.bz2

# Extract Strongswan
checkRet tar xf strongswan.tar.bz2

# Change to Strongswan directory
cd strongswan-*

# Configure Strongswan
checkRet ./configure \
            --prefix=/usr \
            --sysconfdir=/etc \
            --libexecdir=/usr/lib \
            --with-ipsecdir=/usr/lib/strongswan \
            --enable-acert \
            --enable-aesni \
            --enable-dhcp \
            --enable-gcm \
            --enable-md4 \
            --disable-ikev1 \
            --disable-md5 \
            --disable-pgp \
            --disable-rc2 \
            --disable-resolve \
            --disable-scepclient \
            --disable-xauth-generic \
            --disable-xcbc \
            --with-capabilities=libcap

# Make and install Strongswan
checkRet make -j3
checkRet sudo make install

# Check Strongswan runs
checkRet sudo ipsec --version

# Building Strongswan complete
exit 0
