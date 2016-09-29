#!/usr/bin/env bash

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

sleep 10
sync;
sync;
sync;
