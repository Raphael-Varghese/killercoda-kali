# Step 3: Your First Ethical Hacking Exercise

In this step, you will perform a safe, hands-on reconnaissance exercise using Nmap and SearchSploit directly on your Ubuntu host. All scanning is done against your own local environment, which is completely safe and legal.

## 1. Run a Basic Port Scan

Scan the localhost to identify open services:

```bash
nmap -sV -A -T4 127.0.0.1
