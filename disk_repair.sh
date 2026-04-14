#!/bin/bash

# Project: VA Tech Storage Repair
# Purpose: Detect and remount Read-Only (RO) file systems

TARGET="/mnt/google_test_disk"

echo "--- STORAGE REPAIR UTILITY ---"

# 1. Checking if the mount point exists
if [ ! -d "$TARGET" ]; then
    echo "Error: $TARGET not found. Please ensure the drive is plugged in."
    exit 1
fi

# 2. Checking for Read-Only status
IS_RO=$(mount | grep "$TARGET" | grep "(ro")

if [ -n "$IS_RO" ]; then
    echo "ALERT: Disk is in READ-ONLY mode. Attempting repair..."

    # Trying to remount as Read-Write
    sudo mount -o remount,rw "$TARGET"

    if [ $? -eq 0 ]; then
        echo "SUCCESS: Disk has been remounted as Read-Write."
    else
        echo "FAILED: Manual intervention required. Check 'dmesg' for hardware faults."
    fi
else
    echo "Status: Disk is already in Read-Write mode or not mounted."
fi
