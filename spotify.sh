#!/bin/bash

. ./common.sh

# add spotify repo
configure /etc/apt/sources.list 'deb http:\/\/repository.spotify.com stable non-free' 'deb http:\/\/repository.spotify.com stable non-free'

# install client
sudo apt-get update
sudo apt-get install spotify-client
