#!/bin/bash

# Check current disk space usage for /dev/sda2
echo "Before resizing:"
df -h | grep /dev/sda2

# Extend the partition /dev/sda2
echo "Extending partition /dev/sda2..."
sudo growpart /dev/sda 2
if [ $? -ne 0 ]; then
    echo "Error: Failed to extend the partition /dev/sda2"
    exit 1
fi

# Resize the filesystem on /dev/sda2
echo "Resizing filesystem on /dev/sda2..."
sudo resize2fs /dev/sda2
if [ $? -ne 0 ]; then
    echo "Error: Failed to resize the filesystem on /dev/sda2"
    exit 1
fi

# Check updated disk space usage for /dev/sda2
echo "After resizing:"
df -h | grep /dev/sda2
