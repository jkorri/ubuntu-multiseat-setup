#!/bin/bash

. ./common.sh

MEDIA_USER=media

# Create mount for data disk
sudo mkdir -p /data
configure /etc/fstab '^.*UUID=a93f0b02-8693-4974-aab9-427a3079c6d8.*$' 'UUID=a93f0b02-8693-4974-aab9-427a3079c6d8 \/data           ext4    defaults        0       2'

# Setup media folder
grep -q -E ^$MEDIA_USER: /etc/passwd
if [ ! $? -eq 0 ];
then
  echo creating user $MEDIA_USER
  sudo adduser --system --group --quiet $MEDIA_USER
fi
sudo mkdir -p /data/media
sudo chown media:media /data/media
# s flag is crucial so that this functions as a shared folder
sudo chmod ug+rwxs /data/media

for_each_user sudo usermod -a -G $MEDIA_USER {}
for_each_user set_symlink {} /data/media /home/{}/media

# Setup parallel home folder
sudo mkdir -p /data/home
for_each_user sudo mkdir -p /data/home/{}
for_each_user sudo chown {}:{} /data/home/{}

for_each_user sudo -u {} mkdir -p /data/home/{}/Downloads
for_each_user set_symlink {} /data/home/{}/Downloads /home/{}/Downloads

for_each_user sudo -u {} mkdir -p /data/home/{}/Documents
for_each_user set_symlink {} /data/home/{}/Documents /home/{}/Documents
