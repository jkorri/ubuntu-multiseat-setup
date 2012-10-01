#!/bin/bash
# Setup Oracle Java

. ./common.sh

JDK_DIR=jdk1.7.0_07

install_java() {
#Install java, assumes download present in ./tmp
JAVA_PACKAGE=jdk-7u7-linux-x64.tar.gz

if [ ! -f ./tmp/$JAVA_PACKAGE ]
then
  echo Please download java package to tmp folder!
  exit
fi
sudo mkdir -p /usr/lib/jvm/
sudo mv ./tmp/$JAVA_PACKAGE /usr/lib/jvm/
cd /usr/lib/jvm/
sudo tar zxvf $JAVA_PACKAGE

sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/$JDK_DIR/bin/java" 1062
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/$JDK_DIR/bin/javac" 1062
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/$JDK_DIR/bin/javaws" 1062
}

install_java

#Enable chrome/mozilla java plugin for all users
for_each_user set_symlink {} "/usr/lib/jvm/$JDK_DIR/jre/lib/amd64/libnpjp2.so" /home/{}/.mozilla/plugins/libnpjp2.so

#Fix swt library issue which causes Eclipse not to start with Oracle JVM, see http://stackoverflow.com/questions/10165693/ubuntu-eclipse-cannot-load-swt-libraries-not-opening
#for_each_user set_symlink {} '/usr/lib/jni/libswt-*' /home/{}/.swt/lib/linux/x86_64/



