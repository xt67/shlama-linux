#!/bin/bash

# 🦙 shlama uninstaller

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}🦙 Uninstalling shlama...${NC}"
echo ""

# Remove shlama binary
if [[ -f /usr/local/bin/shlama ]]; then
    sudo rm /usr/local/bin/shlama
    echo -e "${GREEN}✓ Removed /usr/local/bin/shlama${NC}"
else
    echo -e "${YELLOW}⚠ shlama not found in /usr/local/bin${NC}"
fi

echo ""
echo -e "${GREEN}✅ shlama has been uninstalled${NC}"
echo ""
echo -e "${YELLOW}Note: Ollama and its models were NOT removed.${NC}"
echo -e "To remove Ollama: sudo rm /usr/local/bin/ollama"
echo -e "To remove models: rm -rf ~/.ollama"
echo ""
