#!/bin/bash
# shlama quick installer via .deb package
# Usage: curl -fsSL https://raw.githubusercontent.com/xt67/shlama-linux/main/setup-repo.sh | sudo bash
#
# Note: This installs via .deb but does NOT install Ollama or download models.
# For a complete installation, use install.sh instead:
#   curl -fsSL https://raw.githubusercontent.com/xt67/shlama-linux/main/install.sh | bash

set -e

DEB_URL="https://github.com/xt67/shlama-linux/releases/download/v1.1.0/shlama_1.1.0_all.deb"

echo ""
echo "============================================"
echo "       shlama installer (deb package)      "
echo "   Natural language -> shell commands      "
echo "============================================"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] This script must be run with sudo"
    echo "  Run: curl -fsSL https://raw.githubusercontent.com/xt67/shlama-linux/main/setup-repo.sh | sudo bash"
    exit 1
fi

echo "[*] Installing dependencies..."
apt-get update -qq
apt-get install -y -qq curl jq

echo "[*] Downloading shlama..."
cd /tmp
curl -fsSL -o shlama.deb "$DEB_URL"

echo "[*] Installing shlama..."
dpkg -i shlama.deb || apt-get install -f -y
rm -f shlama.deb

echo ""
echo "[OK] shlama installed successfully!"
echo ""
echo "============================================"
echo "  IMPORTANT: You still need Ollama!        "
echo "============================================"
echo ""
echo "If Ollama is not installed, run:"
echo "  curl -fsSL https://ollama.ai/install.sh | sh"
echo ""
echo "Then download a model:"
echo "  ollama pull llama3.2"
echo ""
echo "Or use the full installer that does everything:"
echo "  curl -fsSL https://raw.githubusercontent.com/xt67/shlama-linux/main/install.sh | bash"
echo ""
echo "Usage: shlama \"your command in natural language\""
echo "Change model: shlama --model"
echo ""
