#!/usr/bin/env bash

# TODO Fix https://access.redhat.com/solutions/2333821

find /root -type f -delete
yum reinstall rootfiles -y

cat <<< '
127.0.0.1 localhost.localdomain localhost
127.0.0.1 localhost4.localdomain4 localhost4
::1 localhost.localdomain localhost
::1 localhost6.localdomain6 localhost6
' > /etc/hosts

yum -y remove bison
yum -y remove flex
yum -y remove gcc
yum -y remove gcc-c++
yum -y remove kernel-devel
yum -y remove kernel-headers
yum -y remove cloog-ppl
yum -y remove cpp
yum -y clean all

rm -rf /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm /lib/udev/rules.d/75-persistent-net-generator.rules
rm -rf /dev/.udev/

for ndev in $(ls -1 /etc/sysconfig/network-scripts/ifcfg-*); do
  if [ "$(basename "${ndev}")" != "ifcfg-lo" ]; then
    sed -i '/^HWADDR/d' "$ndev";
    sed -i '/^UUID/d' "$ndev";
  fi
done

rm -rf /etc/ssh/*_host_*

rm -rf /var/run/console/*
rm -rf /var/run/faillock/*
rm -rf /var/run/sepermit/*

if [ -d /var/log/account ]; then
  rm -f /var/log/account/pacct*
  touch /var/log/account/pacct
fi

rm -rf /var/spool/abrt/*

if [ -d /etc/machine-id ]; then
  rm -f /etc/machine-id
  touch /etc/machine-id
fi
if [ -d /var/lib/dbus/machine-id ]; then
  rm -f /var/lib/dbus/machine-id
  touch /var/lib/dbus/machine-id
fi

rm -rf /var/spool/mail/*
rm -rf /var/mail/*

find /var/log -type f -exec truncate -s 0 {} \;
find /tmp -type f -delete
find /var/tmp -type f -delete
find /var/cache/yum -type f -delete

rm -f /var/lib/dhclient/*
> /etc/resolv.conf

rm -f /var/lib/yum/uuid

rm -f /var/lib/rpm/__db*
rpm --rebuilddb

rm -rf /var/lib/cloud/sem/* /var/lib/cloud/instance /var/lib/cloud/instances/*
