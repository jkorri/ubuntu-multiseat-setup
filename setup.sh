#!/bin/bash

#Install Flash
sudo apt-get install flashplugin-installer

#Install Chrome
mkdir -p ./tmp
CHROME_PACKAGE=google-chrome-stable_current_amd64.deb
if [ ! -f ./tmp/$CHROME_PACKAGE ]
then
  wget https://dl.google.com/linux/direct/$CHROME_PACKAGE -O ./tmp/$CHROME_PACKAGE
fi
sudo dpkg -i ./tmp/$CHROME_PACKAGE

#Setup multiseat
sudo mv -f /etc/X11/xorg.conf /etc/X11/xorg.conf.backup
sudo cp -f ./xorg.conf /etc/X11/xorg.conf

sudo mv -f /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup
sudo cp -f ./lightdm.conf /etc/lightdm/lightdm.conf
