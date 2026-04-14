#!/bin/bash

# Project: VA Tech Network Audit
# Purpose: Identify point of failure in the network stack (L1-L7)

echo "--- STARTING NETWORK AUDIT ---"

# 1. Checking Physical Link (Layer 1/2)
INTERFACE=$(ip route | grep default | awk '{print $5}')
echo "[LINK] Checking interface: $INTERFACE"
LINK_STATE=$(cat /sys/class/net/$INTERFACE/operstate)
echo "Status: $LINK_STATE"

# 2. Checking Local Gateway (Layer 3)
GATEWAY=$(ip route | grep default | awk '{print $3}')
echo "[GATEWAY] Pinging default gateway: $GATEWAY"
ping -c 2 $GATEWAY > /dev/null
if [ $? -eq 0 ]; then
    echo "Result: Local Gateway Reachable."
else
    echo "Result: Gateway Unreachable. Check cabling or switch config."
fi

# 3. Checking External Connectivity (Layer 4)
echo "[INTERNET] Pinging Google Public DNS (8.8.8.8)..."
ping -c 2 8.8.8.8 > /dev/null
if [ $? -eq 0 ]; then
    echo "Result: Internet Access Available."
else
    echo "Result: No External Access. Possible routing issue."
fi

# 4. Checking DNS Resolution (Layer 7)
echo "[DNS] Resolving google.com..."
nslookup google.com > /dev/null
if [ $? -eq 0 ]; then
    echo "Result: DNS Working."
else
    echo "Result: DNS Failure. Check /etc/resolv.conf."
fi
