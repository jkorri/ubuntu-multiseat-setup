#!/bin/bash

#Install Flash
sudo apt-get install flashplugin-installer

#Setup multiseat
sudo mv -f /etc/X11/xorg.conf /etc/X11/xorg.conf.backup
sudo cp -f ./xorg.conf /etc/X11/xorg.conf

sudo mv -f /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup
sudo cp -f ./lightdm.conf /etc/lightdm/lightdm.conf
