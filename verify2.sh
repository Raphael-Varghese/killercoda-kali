#!/bin/bash
set -e

# Verify nmap is installed on the host
if ! command -v nmap > /dev/null 2>&1; then
    echo "FAIL: nmap is not installed on the host."
    exit 1
fi

# Verify sqlmap is installed
if ! command -v sqlmap > /dev/null 2>&1; then
    echo "FAIL: sqlmap is not installed on the host."
    exit 1
fi

# Verify msfconsole is installed
if ! command -v msfconsole > /dev/null 2>&1; then
    echo "FAIL: msfconsole (Metasploit) is not installed on the host."
    exit 1
fi

# Verify searchsploit is installed
if ! command -v searchsploit > /dev/null 2>&1; then
    echo "FAIL: searchsploit is not installed on the host."
    exit 1
fi

echo "PASS: All core penetration testing tools are installed natively on the host."
