#!/usr/bin/env bash

if [ "$PACKER_BUILDER_TYPE" == "qemu" ]; then
  fstrim -v /boot ;
  fstrim -v / ;
  fstrim -v /home ;
  fstrim -v /tmp ;
  fstrim -v /var ;
  fstrim -v /var/log ;
  fstrim -v /var/log/audit ;
else
  dd if=/dev/zero of=/boot/EMPTY bs=1M || echo "dd exit code $? is suppressed";
  rm -f /boot/EMPTY;
  
  dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed";
  rm -f /EMPTY;
  
  dd if=/dev/zero of=/home/EMPTY bs=1M || echo "dd exit code $? is suppressed";
  rm -f /home/EMPTY;
  
  dd if=/dev/zero of=/tmp/EMPTY bs=1M || echo "dd exit code $? is suppressed";
  rm -f /tmp/EMPTY;
  
  dd if=/dev/zero of=/var/EMPTY bs=1M || echo "dd exit code $? is suppressed";
  rm -f /var/EMPTY;
  
  dd if=/dev/zero of=/var/log/EMPTY bs=1M || echo "dd exit code $? is suppressed";
  rm -f /var/log/EMPTY;
  
  dd if=/dev/zero of=/var/log/audit/EMPTY bs=1M || echo "dd exit code $? is suppressed";
  rm -f /var/log/audit/EMPTY;
fi

sleep 10
sync;
sync;
sync;