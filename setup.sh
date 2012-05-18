#!/bin/bash

get_details() {
if [[ "$GIT_USER_NAME" == "" || "$EMAIL" == "" ]];
then
  read -p "GIT Username: " GIT_USER_NAME
  read -p "Email address: " EMAIL
fi
}

#Install java, assumes download present in ./tmp
JAVA_PACKAGE=jdk-7u4-linux-x64.tar.gz
if [ ! -f ./tmp/$JAVA_PACKAGE ]
then
  echo Please download java package to tmp folder!
  exit
fi
sudo mkdir -p /usr/lib/jvm/
sudo mv ./tmp/$JAVA_PACKAGE /usr/lib/jvm/
cd /usr/lib/jvm/
sudo tar zxvf $JAVA_PACKAGE

sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.7.0_04/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.7.0_04/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.7.0_04/bin/javaws" 1

#Do this for all users to enable chrome/mozilla java plugin
ln -s /usr/lib/jvm/jdk1.7.0_04/jre/lib/amd64/libnpjp2.so ~/.mozilla/plugins/libnpjp2.so

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

#Packages should be updated

#Setup multiseat
XORG_CONF=/etc/X11/xorg.conf
if [ -f $XORG_CONF ]
then
  sudo mv -f $XORG_CONF $XORG_CONF.backup
fi
sudo cp -f ./xorg.conf /etc/X11/xorg.conf

sudo mv -f /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup
sudo cp -f ./lightdm.conf /etc/lightdm/lightdm.conf

#Setup pulseaudio for multiseat
#Adapted from: http://disjunkt.com/jd/2010/en/multiseat-linux/multiseat-linux-system-wide-pulseaudio-for-routing-sounds-109/

#Start in system mode
sudo sed -i "s/^.*PULSEAUDIO_SYSTEM_START.*$/PULSEAUDIO_SYSTEM_START=1/g" /etc/default/pulseaudio
#Start later, otherwise it does not seem to find devices
sudo mv /etc/rc2.d/S50pulseaudio /etc/rc2.d/S99pulseaudio

#Run as daemon
sudo sed -i "s/^.*daemonize.*$/daemonize = yes/g" /etc/pulse/daemon.conf

#No spawning of new instances by user
sudo sed -i "s/^.*autospawn.*$/autospawn = no/g" /etc/pulse/client.conf

#Do not release daemon
sudo sed -i "s/^.*load-module module-suspend-on-idle.*$/#load-module module-suspend-on-idle/g" /etc/pulse/system.pa

#Put all users to pulse-access group
cat /etc/passwd | grep -E "x:[0-9]{4}:" | cut -d":" -f1 | xargs -I {} sudo usermod -a -G pulse-access {}


#Unity UI changes, remove launcher & stickiness
