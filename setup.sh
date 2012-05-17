#!/bin/bash

get_details() {
if [[ "$GIT_USER_NAME" == "" || "$EMAIL" == "" ]];
then
  read -p "GIT Username: " GIT_USER_NAME
  read -p "Email address: " EMAIL
fi
}

#Install nvidia driver
sudo apt-get install nvidia-current

#Install Flash
sudo apt-get install flashplugin-installer

#Install git
sudo apt-get install git
get_details
git config --global user.name "$GIT_USER_NAME"
git config --global user.email $EMAIL

#Install Chrome
mkdir -p ./tmp
CHROME_PACKAGE=google-chrome-stable_current_amd64.deb
if [ ! -f ./tmp/$CHROME_PACKAGE ]
then
  wget https://dl.google.com/linux/direct/$CHROME_PACKAGE -O ./tmp/$CHROME_PACKAGE
fi
sudo dpkg -i ./tmp/$CHROME_PACKAGE
sudo apt-get -f install
sudo dpkg -i ./tmp/$CHROME_PACKAGE

#Setup multiseat
XORG_CONF=/etc/X11/xorg.conf
if [ -f $XORG_CONF ]
then
  sudo mv -f $XORG_CONF $XORG_CONF.backup
fi
sudo cp -f ./xorg.conf /etc/X11/xorg.conf

sudo mv -f /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup
sudo cp -f ./lightdm.conf /etc/lightdm/lightdm.conf
