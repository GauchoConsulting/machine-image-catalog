#!/usr/bin/env bash

groupadd "cloud-user"
useradd -d "/home/cloud-user" -s "/bin/bash" -m -g "cloud-user" -G wheel "cloud-user"

mkdir "/home/cloud-user/.ssh"
chmod 700 "/home/cloud-user/.ssh"
wget -q --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O "/home/cloud-user/.ssh/authorized_keys"
chown -R cloud-user:cloud-user "/home/cloud-user/.ssh"

echo "root:vagrant" | chpasswd
echo "cloud-user:vagrant" | chpasswd

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i "s/^\(.*env_keep = \"\)/\1PATH /" /etc/sudoers

echo "cloud-user        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
