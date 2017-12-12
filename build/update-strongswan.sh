#!/bin/sh
# Update Strongswan if new version is available

# Download the latest version of Strongswan sig
echo "Downloading latest signature"
wget -q https://download.strongswan.org/strongswan.tar.bz2.sig -O strongswan.tar.bz2.sig.new

echo "Comparing signatures"
diff strongswan.tar.bz2.sig strongswan.tar.bz2.sig.new > /dev/null

if [[ $? != 0 ]]; then
  echo "New build required!"
  ./build-strongswan.sh
else
  echo "Strongswan up-to-date"
fi

rm strongswan.tar.bz2.sig.new

echo "Completed update process"
