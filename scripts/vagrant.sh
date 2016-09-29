#!/usr/bin/env bash

groupadd "vagrant"
useradd -d "/home/vagrant" -s "/bin/bash" -m -g "vagrant" -G wheel "vagrant"

mkdir "/home/vagrant/.ssh"
chmod 700 "/home/vagrant/.ssh"
wget -q --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O "/home/vagrant/.ssh/authorized_keys"
chown -R vagrant:vagrant "/home/vagrant/.ssh"

echo "root:vagrant" | chpasswd
echo "vagrant:vagrant" | chpasswd

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i "s/^\(.*env_keep = \"\)/\1PATH /" /etc/sudoers

echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant