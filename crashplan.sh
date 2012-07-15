#!/bin/bash

# Install CrashPlan backup
mkdir -p ./tmp/crashplan
CRASHPLAN_URL=http://download.crashplan.com/installs/linux/install/CrashPlan/CrashPlan_3.2.1_Linux.tgz
CRASHPLAN_PACKAGE=`basename $CRASHPLAN_URL`
if [ ! -f ./tmp/crashplan/$CRASHPLAN_PACKAGE ]
then
  wget $CRASHPLAN_URL -O ./tmp/crashplan/$CRASHPLAN_PACKAGE
fi

cd ./tmp/crashplan
tar -xzf $CRASHPLAN_PACKAGE
cd CrashPlan-install
sudo ./install.sh
