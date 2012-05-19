#!/bin/bash
# Setup Oracle Java

. ./common.sh

install_java() {
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
}

#Enable chrome/mozilla java plugin for all users
fix_java_plugin() {

LINK_NAME=/home/$1/.mozilla/plugins/libnpjp2.so
LINK_TARGET=/usr/lib/jvm/jdk1.7.0_04/jre/lib/amd64/libnpjp2.so

if [ -f $LINK_NAME ] && [ `ls -l $LINK_NAME | cut -d">" -f2` = $LINK_TARGET ];
then
  echo Link target already set for $1
  return
fi

sudo -u $1 mkdir -p `dirname $LINK_NAME`
sudo -u $1 ln -s $LINK_TARGET $LINK_NAME
echo Set link target for user $1

}
for_each_user fix_java_plugin {}



