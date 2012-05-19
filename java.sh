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
for_each_user set_symlink {} /usr/lib/jvm/jdk1.7.0_04/jre/lib/amd64/libnpjp2.so /home/{}/.mozilla/plugins/libnpjp2.so



