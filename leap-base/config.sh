#!/bin/bash

test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Create ssh machine keys
#--------------------------------------
/usr/sbin/sshd-gen-keys-start

(cd /usr/share/locale && find -name "*.mo" | xargs rm)
