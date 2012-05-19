#!/bin/bash

# Execute something for each user
for_each_user() {
  for USERNAME in `cat /etc/passwd | grep -E "x:[0-9]{4}:" | cut -d":" -f1`; do
    eval ${@//\{\}/$USERNAME}
  done
}

# Point symlink to a target if does not exist already
set_symlink() {
USERNAME=$1
LINK_TARGET=$2
LINK_NAME=$3

if [ -f $LINK_NAME ] && [ `ls -l $LINK_NAME | cut -d">" -f2` = $LINK_TARGET ];
then
  echo Link target for $LINK_NAME already set to $LINK_TARGET for user $USERNAME
  return
fi

sudo -u $1 mkdir -p `dirname $LINK_NAME`
sudo -u $1 ln -s $LINK_TARGET $LINK_NAME
echo Set $LINK_NAME link target to $LINK_TARGET for user $USERNAME
}