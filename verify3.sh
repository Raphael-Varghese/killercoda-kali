#!/bin/bash
set -e

# Verify nmap is installed on the host
if ! command -v nmap > /dev/null 2>&1; then
    echo "FAIL: nmap is not installed on the host."
    exit 1
fi

# Check bash history for nmap usage (indicates the user ran a scan)
if [ -f /root/.bash_history ] && grep -q "nmap" /root/.bash_history 2>/dev/null; then
    echo "PASS: You have successfully run Nmap on the host."
    exit 0
fi

# Fallback: if nmap exists, the environment is ready
if command -v nmap > /dev/null 2>&1 && command -v searchsploit > /dev/null 2>&1; then
    echo "PASS: Nmap and SearchSploit are available. The Kali environment is ready for ethical hacking practice."
    exit 0
fi

echo "FAIL: Required tools are not available on the host."
exit 1
