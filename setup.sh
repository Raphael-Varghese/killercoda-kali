#!/bin/bash
set -e

# ============================================================
# Kali Linux Ethical Hacking Lab - Host-Based Setup Script
# Modifies the Ubuntu host directly by adding Kali repos
# and installing tools natively (no Docker)
# ============================================================

LOGFILE=/tmp/kali-setup.log
echo "[$(date)] Starting host-based Kali Linux environment setup..." > $LOGFILE

# Step 1: Update package lists
echo "[$(date)] Updating package lists..." >> $LOGFILE
apt-get update -qq >> $LOGFILE 2>&1

# Step 2: Install prerequisites
echo "[$(date)] Installing prerequisites..." >> $LOGFILE
apt-get install -y -qq wget gnupg2 apt-utils >> $LOGFILE 2>&1

# Step 3: Import the Kali Linux GPG signing key (modern keyring method)
echo "[$(date)] Importing Kali GPG key..." >> $LOGFILE
wget -q -O - https://archive.kali.org/archive-key.asc | \
    gpg --dearmor | \
    tee /usr/share/keyrings/kali-archive-keyring.gpg > /dev/null 2>> $LOGFILE

# Step 4: Add Kali repository to sources.list.d
echo "[$(date)] Adding Kali repository..." >> $LOGFILE
cat > /etc/apt/sources.list.d/kali.list << 'EOF'
deb [signed-by=/usr/share/keyrings/kali-archive-keyring.gpg] https://http.kali.org/kali kali-rolling main non-free contrib
EOF

# Step 5: Set up APT pinning to prevent Kali packages from overriding Ubuntu system packages
# Pin priority 50 means Kali packages are available but won't replace Ubuntu packages by default
echo "[$(date)] Configuring APT pinning..." >> $LOGFILE
cat > /etc/apt/preferences.d/kali.pref << 'EOF'
Package: *
Pin: release a=kali-rolling
Pin-Priority: 50
EOF

# Step 6: Update package lists with Kali repo included
echo "[$(date)] Updating package lists with Kali repository..." >> $LOGFILE
apt-get update -qq >> $LOGFILE 2>&1

# Step 7: Install kali-linux-headless metapackage and key tools
echo "[$(date)] Installing Kali Linux tools on host..." >> $LOGFILE
apt-get install -y -qq -t kali-rolling \
    kali-linux-headless \
    nmap \
    nikto \
    sqlmap \
    metasploit-framework \
    exploitdb \
    dirb \
    gobuster \
    theharvester \
    dnsrecon \
    aircrack-ng \
    wifite \
    reaver \
    hydra \
    john \
    hashcat \
    wireshark-common \
    tcpdump \
    netcat-traditional \
    binwalk \
    sleuthkit \
    autopsy \
    radare2 \
    burpsuite \
    zaproxy \
    wordlists \
    seclists \
    python3-pip \
    git \
    curl \
    wget \
    vim \
    nano \
    tmux \
    man-db \
    locate \
    lsof \
    htop 2>> $LOGFILE || true

# Step 8: Update the exploit database
echo "[$(date)] Updating exploit database..." >> $LOGFILE
searchsploit --update >> $LOGFILE 2>&1 || true

# Step 9: Verify key tools
echo "[$(date)] Verifying installed tools..." >> $LOGFILE
nmap --version | head -1 >> $LOGFILE 2>&1 || true
msfconsole --version >> $LOGFILE 2>&1 || true
sqlmap --version >> $LOGFILE 2>&1 || true
searchsploit --version >> $LOGFILE 2>&1 || true

# Step 10: Create a welcome message
mkdir -p /etc/update-motd.d
cat > /etc/update-motd.d/99-kali-welcome << 'EOF'
#!/bin/bash
echo ""
echo "=========================================="
echo "  Kali Linux Ethical Hacking Lab Ready!"
echo "=========================================="
echo ""
echo "Tools available: nmap, sqlmap, metasploit,"
echo "searchsploit, hydra, john, aircrack-ng,"
echo "nikto, dirb, gobuster, and 300+ more."
echo ""
echo "Type 'kali-tools' to list all installed tools."
echo "=========================================="
EOF
chmod +x /etc/update-motd.d/99-kali-welcome

# Step 11: Create a helper script for listing tools
HELPER_SCRIPT="/usr/local/bin/kali-tools"
cat > $HELPER_SCRIPT << 'EOF'
#!/bin/bash
# List installed Kali penetration testing tools

echo "=== Kali Linux Tools Installed on This Host ==="
echo ""
dpkg -l | grep -E "(kali|nmap|nikto|sqlmap|metasploit|exploitdb|dirb|gobuster|theharvester|dnsrecon|aircrack|hydra|john|hashcat|radare|burpsuite|zaproxy|wireshark|tcpdump|binwalk|sleuthkit|autopsy|reaver|wifite)" | awk '{print $2, "-", $3}' 2>/dev/null | head -60
echo ""
echo "Total Kali/security packages: $(dpkg -l | grep -cE '(kali|nmap|nikto|sqlmap|metasploit|exploitdb|dirb|gobuster|theharvester|dnsrecon|aircrack|hydra|john|hashcat|radare|burpsuite|zaproxy|wireshark|tcpdump|binwalk|sleuthkit|autopsy|reaver|wifite)' 2>/dev/null || echo 'many')"
EOF
chmod +x $HELPER_SCRIPT

echo "[$(date)] Host-based Kali setup complete!" >> $LOGFILE
echo "========================================" >> $LOGFILE
echo "Kali repos added with APT pinning (priority 50)" >> $LOGFILE
echo "Tools installed directly on the Ubuntu host" >> $LOGFILE
echo "Type 'kali-tools' to list installed packages" >> $LOGFILE
echo "========================================" >> $LOGFILE
