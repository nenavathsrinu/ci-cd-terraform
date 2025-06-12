#!/bin/bash
# install_ansible_amazon_linux.sh
# Purpose: Install Python 3.9 and Ansible globally on Amazon Linux 2
# Run this as root or with sudo

set -e

# 1. Install build tools and dependencies
echo "Installing build dependencies..."
yum groupinstall -y "Development Tools"
yum install -y gcc openssl-devel bzip2-devel libffi-devel wget make zlib-devel

# 2. Download and build Python 3.9
cd /usr/src
echo "Downloading Python 3.9.18..."
wget https://www.python.org/ftp/python/3.9.18/Python-3.9.18.tgz
tar xzf Python-3.9.18.tgz
cd Python-3.9.18

./configure --enable-optimizations
make altinstall

# 3. Install pip and upgrade it using Python 3.9
/usr/local/bin/python3.9 -m ensurepip
/usr/local/bin/python3.9 -m pip install --upgrade pip

# 4. Install Ansible globally using pip3.9
/usr/local/bin/pip3.9 install ansible

# 5. Optional: Make python3 point to python3.9
alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.9 2

# 6. Verify Installation
echo "\nInstallation Complete:"
/usr/local/bin/ansible --version

