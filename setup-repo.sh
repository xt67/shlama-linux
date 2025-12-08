#!/bin/bash
# Add shlama repository and install
# Usage: curl -fsSL https://raw.githubusercontent.com/xt67/shlama-linux/main/setup-repo.sh | sudo bash

set -e

REPO_URL="https://raw.githubusercontent.com/xt67/shlama-linux/main"
DEB_URL="https://github.com/xt67/shlama-linux/releases/download/v1.1.0/shlama_1.1.0_all.deb"

echo ""
echo "🦙 Setting up shlama repository..."
echo ""

# Download and install the .deb directly
echo "📥 Downloading shlama..."
cd /tmp
curl -fsSL -o shlama.deb "$DEB_URL"

echo "📦 Installing shlama..."
apt-get update -qq
apt-get install -y -qq curl jq
dpkg -i shlama.deb || apt-get install -f -y

rm -f shlama.deb

echo ""
echo "✅ shlama installed successfully!"
echo "   Run: shlama \"your command in natural language\""
echo ""
