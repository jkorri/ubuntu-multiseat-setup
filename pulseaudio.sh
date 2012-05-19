#!/bin/bash
# Setup pulseaudio for multiseat
# Adapted from: http://disjunkt.com/jd/2010/en/multiseat-linux/multiseat-linux-system-wide-pulseaudio-for-routing-sounds-109/

. ./common.sh

#Start in system mode
sudo sed -i "s/^.*PULSEAUDIO_SYSTEM_START.*$/PULSEAUDIO_SYSTEM_START=1/g" /etc/default/pulseaudio

#Run as daemon
sudo sed -i "s/^.*daemonize.*$/daemonize = yes/g" /etc/pulse/daemon.conf

#No spawning of new instances by user
sudo sed -i "s/^.*autospawn.*$/autospawn = no/g" /etc/pulse/client.conf

#Do not release daemon
sudo sed -i "s/^.*load-module module-suspend-on-idle.*$/#load-module module-suspend-on-idle/g" /etc/pulse/system.pa

#Put all users to pulse-access group
for_each_user sudo usermod -a -G pulse-access {}

#Start later, otherwise it does not seem to find devices
if [ -f /etc/rc2.d/S50pulseaudio ]
then
  sudo mv /etc/rc2.d/S50pulseaudio /etc/rc2.d/S99pulseaudio
fi
