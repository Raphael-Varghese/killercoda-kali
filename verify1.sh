#!/bin/bash
set -e

# Verify Kali repository exists
if [ ! -f /etc/apt/sources.list.d/kali.list ]; then
    echo "FAIL: Kali repository file is missing."
    exit 1
fi

# Verify APT pinning exists
if [ ! -f /etc/apt/preferences.d/kali.pref ]; then
    echo "FAIL: Kali APT pinning file is missing."
    exit 1
fi

# Verify GPG keyring exists
if [ ! -f /usr/share/keyrings/kali-archive-keyring.gpg ]; then
    echo "FAIL: Kali GPG keyring is missing."
    exit 1
fi

# Verify apt can see Kali packages
if ! grep -q "http.kali.org" /etc/apt/sources.list.d/kali.list; then
    echo "FAIL: Kali repository URL not found."
    exit 1
fi

echo "PASS: Kali repository, GPG key, and APT pinning are correctly configured."
