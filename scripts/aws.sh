#!/usr/bin/env bash
# shellcheck disable=SC2026

yum install -y cloud-init

cat <<< '
users:
 - default

disable_root: 1
ssh_pwauth:   0

locale_configfile: /etc/sysconfig/i18n
mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']
resize_rootfs_tmp: /dev
ssh_deletekeys:   0
ssh_genkeytypes:  ~
syslog_fix_perms: ~
manage_etc_hosts: 1

cloud_init_modules:
 - set_hostname
 - update_hostname
 - bootcmd
 - write-files
 - resizefs
 - update_etc_hosts
 - rsyslog
 - users-groups
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance

cloud_config_modules:
 - mounts
 - locale
 - set-passwords
 - timezone
 - yum-add-repo
 - package-update-upgrade-install
 - puppet
 - chef
 - salt-minion
 - mcollective
 - disable-ec2-metadata
 - runcmd

cloud_final_modules:
 - rightscale_userdata
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - phone-home
 - final-message
 - ssh

system_info:
  distro: rhel
  default_user:
    name: cloud-user
    lock_passwd: true
    gecos: Cloud user
    groups: [wheel, adm]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
  paths:
    cloud_dir: /var/lib/cloud
    templates_dir: /etc/cloud/templates
  ssh_svcname: sshd

datasource:
  Ec2:
    timeout: 10
    max_wait: 30

bootcmd:
- service rsyslog restart
- chmod +x /etc/cloud/resize.sh
- /etc/cloud/resize.sh
' > /etc/cloud/cloud.cfg
