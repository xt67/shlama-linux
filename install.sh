#!/bin/bash

# 🦙 shlama installer
# One command to install shlama and all dependencies

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_color() {
    echo -e "${1}${2}${NC}"
}

print_banner() {
    echo ""
    print_color "$CYAN" "  ┌─────────────────────────────────────┐"
    print_color "$CYAN" "  │         🦙 shlama installer         │"
    print_color "$CYAN" "  │   Natural language → shell commands │"
    print_color "$CYAN" "  └─────────────────────────────────────┘"
    echo ""
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_color "$RED" "Error: Do not run this script as root/sudo"
        print_color "$YELLOW" "Run it as: curl -fsSL https://raw.githubusercontent.com/xt67/shlama-linux/main/install.sh | bash"
        exit 1
    fi
}

detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$ID
        OS_LIKE=$ID_LIKE
    else
        print_color "$RED" "Error: Cannot detect OS"
        exit 1
    fi
}

install_package() {
    local package=$1
    print_color "$BLUE" "→ Installing $package..."
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq "$package"
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y -q "$package"
    elif command -v yum &> /dev/null; then
        sudo yum install -y -q "$package"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm "$package"
    elif command -v zypper &> /dev/null; then
        sudo zypper install -y "$package"
    else
        print_color "$RED" "Error: No supported package manager found"
        exit 1
    fi
}

install_dependencies() {
    print_color "$YELLOW" "📦 Checking dependencies..."
    
    # Check and install curl
    if ! command -v curl &> /dev/null; then
        install_package curl
    else
        print_color "$GREEN" "✓ curl already installed"
    fi
    
    # Check and install jq
    if ! command -v jq &> /dev/null; then
        install_package jq
    else
        print_color "$GREEN" "✓ jq already installed"
    fi
}

install_ollama() {
    print_color "$YELLOW" "🦙 Checking Ollama..."
    
    if command -v ollama &> /dev/null; then
        print_color "$GREEN" "✓ Ollama already installed"
    else
        print_color "$BLUE" "→ Installing Ollama..."
        curl -fsSL https://ollama.ai/install.sh | sh
        print_color "$GREEN" "✓ Ollama installed"
    fi
}

start_ollama() {
    print_color "$YELLOW" "🚀 Starting Ollama service..."
    
    # Check if ollama is already running
    if curl -s http://localhost:11434/api/tags &> /dev/null; then
        print_color "$GREEN" "✓ Ollama is already running"
        return 0
    fi
    
    # Try to start ollama service
    if systemctl is-active --quiet ollama 2>/dev/null; then
        print_color "$GREEN" "✓ Ollama service is running"
    else
        # Start ollama in background
        print_color "$BLUE" "→ Starting Ollama..."
        nohup ollama serve > /dev/null 2>&1 &
        sleep 3
        
        if curl -s http://localhost:11434/api/tags &> /dev/null; then
            print_color "$GREEN" "✓ Ollama started"
        else
            print_color "$YELLOW" "⚠ Could not start Ollama automatically"
            print_color "$YELLOW" "  Run 'ollama serve' in another terminal"
        fi
    fi
}

pull_model() {
    local config_file="$HOME/.config/shlama/config"
    
    # Check if already configured (not first install)
    if [[ -f "$config_file" ]]; then
        local saved_model=$(cat "$config_file" 2>/dev/null)
        print_color "$GREEN" "✓ Model already configured: $saved_model"
        print_color "$BLUE" "  To change model later, run: shlama --model"
        
        # Check if model is downloaded
        if ollama list 2>/dev/null | grep -q "$saved_model"; then
            print_color "$GREEN" "✓ Model $saved_model is available"
        else
            print_color "$YELLOW" "⚠ Model $saved_model not downloaded"
            read -p "Download now? (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                ollama pull "$saved_model"
            fi
        fi
        return 0
    fi
    
    # First time install - show model selection
    echo ""
    print_color "$CYAN" "🤖 Choose an AI model:"
    echo ""
    echo "  1) llama3.2     - Fast & light (~2GB) [Recommended]"
    echo "  2) llama3.2:1b  - Fastest, minimal (~1.3GB)"
    echo "  3) llama3       - Balanced (~4.7GB)"  
    echo "  4) mistral      - Good quality (~4.1GB)"
    echo "  5) Skip         - I'll download a model later"
    echo ""
    
    local model="llama3.2"
    read -p "Select model [1-5] (default: 1): " -r choice
    
    case "$choice" in
        1|"") model="llama3.2" ;;
        2) model="llama3.2:1b" ;;
        3) model="llama3" ;;
        4) model="mistral" ;;
        5) 
            print_color "$YELLOW" "⚠ Skipping model download"
            print_color "$YELLOW" "  Run 'shlama --model' later to select a model"
            return 0
            ;;
        *) model="llama3.2" ;;
    esac
    
    # Override with environment variable if set
    model="${SHLAMA_MODEL:-$model}"
    
    # Save model to config
    mkdir -p "$(dirname "$config_file")"
    echo "$model" > "$config_file"
    
    print_color "$YELLOW" "📥 Pulling model ($model)..."
    
    # Check if model already exists
    if ollama list 2>/dev/null | grep -q "$model"; then
        print_color "$GREEN" "✓ Model $model already downloaded"
    else
        print_color "$BLUE" "→ Downloading $model (this may take a few minutes)..."
        ollama pull "$model"
        print_color "$GREEN" "✓ Model $model downloaded"
    fi
    
    print_color "$GREEN" "✓ Model saved. To change later, run: shlama --model"
}

install_shlama() {
    print_color "$YELLOW" "📥 Installing shlama..."
    
    local install_dir="/usr/local/bin"
    local tmp_file=$(mktemp)
    
    # Download shlama
    curl -fsSL "https://raw.githubusercontent.com/xt67/shlama-linux/main/shlama" -o "$tmp_file"
    
    # Make executable and move to bin
    chmod +x "$tmp_file"
    sudo mv "$tmp_file" "$install_dir/shlama"
    
    print_color "$GREEN" "✓ shlama installed to $install_dir/shlama"
}

verify_installation() {
    print_color "$YELLOW" "🔍 Verifying installation..."
    
    if command -v shlama &> /dev/null; then
        print_color "$GREEN" "✓ shlama is in PATH"
    else
        print_color "$RED" "✗ shlama not found in PATH"
        return 1
    fi
    
    # Test help command
    if shlama --help &> /dev/null; then
        print_color "$GREEN" "✓ shlama runs correctly"
    else
        print_color "$RED" "✗ shlama failed to run"
        return 1
    fi
}

print_success() {
    echo ""
    print_color "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$GREEN" "  ✅ Installation complete!"
    print_color "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    print_color "$CYAN" "  Try it out:"
    print_color "$NC" "    shlama \"list all files\""
    print_color "$NC" "    shlama \"show disk usage\""
    print_color "$NC" "    shlama \"install htop\""
    echo ""
    print_color "$YELLOW" "  Make sure Ollama is running:"
    print_color "$NC" "    ollama serve"
    echo ""
    print_color "$CYAN" "  Documentation: https://github.com/xt67/shlama-linux"
    echo ""
}

# Main installation flow
main() {
    print_banner
    check_root
    detect_os
    
    print_color "$BLUE" "Detected OS: $OS"
    echo ""
    
    install_dependencies
    install_ollama
    start_ollama
    pull_model
    install_shlama
    verify_installation
    print_success
}

main "$@"
