#!/bin/bash

# Execute something for each user
for_each_user() {
  for USERNAME in `cat /etc/passwd | grep -E "x:[0-9]{4}:" | cut -d":" -f1`; do
    eval ${@//\{\}/$USERNAME}
  done
}
