# 🦙 shlama

*Your terminal llama. Natural language → safe Linux commands. Powered by Ollama.*

> **🪟 Looking for Windows?** Check out [shlama for Windows](https://github.com/xt67/shlama-windows)

shlama is a tiny CLI companion that turns natural language into shell commands using a local LLM (Ollama).  
You ask for something, it suggests a command, and **you approve before execution**.

No cloud. No API keys. Just your shell and a llama.

---

## ✨ Demo

```bash
$ shlama "list all files including hidden"
🦙 Thinking...

Suggested command:
ls -la

Run command? (y/N): y

Executing...
─────────────────────────────────────
total 24
drwxr-xr-x  3 user user 4096 Dec  4 10:00 .
drwxr-xr-x 15 user user 4096 Dec  4 09:00 ..
-rw-r--r--  1 user user  220 Dec  4 10:00 .bashrc
drwxr-xr-x  2 user user 4096 Dec  4 10:00 Documents
─────────────────────────────────────
✓ Done
```

---

## 🚀 Installation

### APT Install (Ubuntu/Debian/Zorin/Mint)

```bash
curl -fsSL https://raw.githubusercontent.com/xt67/shlama/main/setup-repo.sh | sudo bash
```

Then you can use apt to manage shlama:
```bash
sudo apt install shlama    # Install
sudo apt remove shlama     # Uninstall
```

### One-Line Install (All Linux Distros)

```bash
curl -fsSL https://raw.githubusercontent.com/xt67/shlama/main/install.sh | bash
```

This automatically installs:
- ✅ shlama
- ✅ Ollama (if not installed)
- ✅ Required dependencies (jq, curl)
- ✅ Downloads the default LLM model

That's it! Start using it:
```bash
shlama "list all files"
```

### Uninstall

```bash
# If installed via apt:
sudo apt remove shlama

# If installed via install.sh:
curl -fsSL https://raw.githubusercontent.com/xt67/shlama/main/uninstall.sh | bash
```

---

<details>
<summary><strong>📦 Manual Installation</strong></summary>

### Prerequisites

1. **Ollama** - Install from [ollama.ai](https://ollama.ai)
2. **jq** - JSON processor
3. **curl** - HTTP client

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt install jq curl

# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull a model
ollama pull llama3.2
```

### Install shlama

```bash
# Clone the repository
git clone https://github.com/xt67/shlama.git
cd shlama

# Make it executable
chmod +x shlama

# Option 1: Run directly
./shlama "your request"

# Option 2: Add to PATH (recommended)
sudo cp shlama /usr/local/bin/
shlama "your request"
```

</details>

---

## 📖 Usage

```bash
shlama "<natural language request>"
```

### Examples

```bash
# File operations
shlama "list all files including hidden"
shlama "find all python files in current directory"
shlama "count lines in all txt files"

# System info
shlama "show disk usage"
shlama "show memory usage"
shlama "list running processes"

# Package management
shlama "install neofetch"
shlama "update all packages"

# Network
shlama "show my ip address"
shlama "check if google is reachable"

# Git
shlama "show git status"
shlama "create a new branch called feature"
```

---

## ⚙️ Configuration

Configure shlama using environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `SHLAMA_MODEL` | `llama3.2` | Ollama model to use |
| `OLLAMA_HOST` | `http://localhost:11434` | Ollama API endpoint |

### Examples

```bash
# Use a different model
SHLAMA_MODEL=mistral shlama "list files"

# Use remote Ollama instance
OLLAMA_HOST=http://192.168.1.100:11434 shlama "list files"

# Set permanently in .bashrc
echo 'export SHLAMA_MODEL=llama3.2' >> ~/.bashrc
```

---

## 🛡️ Safety

shlama is designed with safety in mind:

- ✅ **Confirmation required** - Every command needs your approval before execution
- ✅ **No auto-execute** - You always see the command first
- ✅ **Local only** - No data leaves your machine
- ✅ **Safe prompting** - The LLM is instructed to avoid destructive commands

> ⚠️ **Always review the suggested command before running it.** While shlama tries to generate safe commands, you are responsible for what runs on your system.

---

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests

---

## 💖 Support

If you find shlama useful, consider supporting its development:

<a href="https://www.buymeacoffee.com/xt67" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="50" ></a>

[![Sponsor on GitHub](https://img.shields.io/badge/Sponsor-%E2%9D%A4-pink?logo=github)](https://github.com/sponsors/xt67)

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🔗 Related

- **[shlama for Windows](https://github.com/xt67/shlama-windows)** - Windows/PowerShell version
- [Ollama](https://ollama.ai) - Local LLM runtime

---

## 🙏 Acknowledgments

- [Ollama](https://ollama.ai) - For making local LLMs accessible
- The open-source LLM community

---

<p align="center">
  Made with 🦙 by the terminal
</p>
