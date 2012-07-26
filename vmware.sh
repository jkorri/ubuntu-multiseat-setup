#!/bin/bash

. ./common.sh

#VMWare download cannot be done manually, so assumes that vm installation package in ./tmp
VMWARE_VERSION=4.0.4
VMWARE_INSTALL_PKG=VMware-Player-${VMWARE_VERSION}-744019.x86_64.txt
sudo chmod u+x ./tmp/$VMWARE_INSTALL_PKG

sudo ./tmp/$VMWARE_INSTALL_PKG

#For 12.01, needs a patch
VMWARE_PATCH_PKG=vmware802fixlinux320.tar.gz

if [ ! -f ./tmp/$VMWARE_PATCH_PKG ]
then
  wget http://weltall.heliohost.org/wordpress/wp-content/uploads/2012/01/$VMWARE_PATCH_PKG -O ./tmp/$VMWARE_PATCH_PKG
fi
cd ./tmp
tar -zxf ./$VMWARE_PATCH_PKG
configure ./patch-modules_3.2.0.sh "plreqver=4.0.2" "plreqver=${VMWARE_VERSION}"

# Remove touch file indicating patching already done
sudo rm -f /usr/lib/vmware/modules/source/.patched
sudo ./patch-modules_3.2.0.sh
cd ..

# Setup vm folder
VMWARE_USER=vm

grep -q -E ^$VMWARE_USER: /etc/passwd
if [ ! $? -eq 0 ];
then
  echo creating user $VMWARE_USER
  sudo adduser --system --group --quiet $VMWARE_USER
fi

sudo mkdir -p /data/vmware
sudo chown vm:vm /data/vmware
# s flag is crucial so that this functions as a shared folder
sudo chmod ug+rwxs /data/vmware

for_each_user sudo usermod -a -G $VMWARE_USER {}
for_each_user set_symlink {} /data/vmware /home/{}/vmware
