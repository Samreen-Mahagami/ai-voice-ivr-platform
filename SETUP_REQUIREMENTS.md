# AI Voice IVR Platform - Setup Requirements

## System Requirements

### Operating System
- **Linux** (Ubuntu 20.04+, Debian 11+, or similar)
- Minimum 8GB RAM
- 20GB free disk space
- Internet connection for downloading dependencies

---

## Required Software Installation

### 1. Go Programming Language (v1.22+)

**Purpose:** Primary development language for Bot Orchestrator and Integration Service

**Installation:**
```bash
# Download and install Go 1.22+
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
go version
```

**Expected Output:** `go version go1.22.0 linux/amd64`

---

### 2. Docker Engine

**Purpose:** Container runtime for all services (FreeSWITCH, Whisper, Ollama, Piper)

**Installation:**
```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (to run without sudo)
sudo usermod -aG docker $USER

# Apply group changes (or logout/login)
newgrp docker

# Verify installation
docker --version
docker compose version
```

**Expected Output:** 
```
Docker version 24.0.x
Docker Compose version v2.x.x
```

**Test Docker:**
```bash
docker run hello-world
```

---

### 3. Git Version Control

**Purpose:** Source code management and version control

**Installation:**
```bash
# Install Git
sudo apt-get update
sudo apt-get install -y git

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify installation
git --version
```

**Expected Output:** `git version 2.x.x`

---

### 4. Make Build Tool

**Purpose:** Build automation and task running

**Installation:**
```bash
# Install build-essential (includes make)
sudo apt-get update
sudo apt-get install -y build-essential

# Verify installation
make --version
```

**Expected Output:** `GNU Make 4.x`

---

### 5. curl & wget

**Purpose:** API testing and file downloads

**Installation:**
```bash
# Usually pre-installed, but just in case
sudo apt-get update
sudo apt-get install -y curl wget

# Verify installation
curl --version
wget --version
```

---

### 6. VS Code (Recommended IDE)

**Purpose:** Code editor with Go support

**Installation:**
```bash
# Download and install VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt-get update
sudo apt-get install -y code

# Launch VS Code
code --version
```

**VS Code Extensions to Install:**
- Go (ms-vscode.go)
- Docker (ms-azuretools.vscode-docker)
- YAML (redhat.vscode-yaml)

**Install Extensions:**
```bash
code --install-extension ms-vscode.go
code --install-extension ms-azuretools.vscode-docker
code --install-extension redhat.vscode-yaml
```

---

### 7. SIP Softphone

**Purpose:** Make test calls to the IVR system

**Option A: Linphone (Recommended for Linux)**
```bash
sudo apt-get update
sudo apt-get install -y linphone

# Launch
linphone
```

**Option B: Zoiper**
- Download from: https://www.zoiper.com/en/voip-softphone/download/current
- Install the .deb package

**Option C: MicroSIP (Windows only)**
- Not available for Linux

---

## Docker Images (Will be pulled automatically)

These will be downloaded when you run `docker-compose up`:

### 1. FreeSWITCH
```bash
# Image: drachtio/freeswitch or signalwire/freeswitch
# Size: ~500MB
```

### 2. Whisper ASR
```bash
# Image: onerahmet/openai-whisper-asr-webservice
# Size: ~2GB (includes model)
```

### 3. Ollama + Llama3
```bash
# Image: ollama/ollama
# Size: ~4GB (base + model)
```

### 4. Piper TTS
```bash
# Image: rhasspy/piper
# Size: ~500MB
```

**Total Docker Images:** ~7GB disk space

---

## System Verification Checklist

After installation, verify everything:

```bash
# Create verification script
cat > verify_setup.sh << 'EOF'
#!/bin/bash

echo "=== AI Voice IVR Setup Verification ==="
echo ""

# Check Go
echo -n "Go: "
if command -v go &> /dev/null; then
    go version
else
    echo "❌ NOT INSTALLED"
fi

# Check Docker
echo -n "Docker: "
if command -v docker &> /dev/null; then
    docker --version
else
    echo "❌ NOT INSTALLED"
fi

# Check Docker Compose
echo -n "Docker Compose: "
if docker compose version &> /dev/null; then
    docker compose version
else
    echo "❌ NOT INSTALLED"
fi

# Check Git
echo -n "Git: "
if command -v git &> /dev/null; then
    git --version
else
    echo "❌ NOT INSTALLED"
fi

# Check Make
echo -n "Make: "
if command -v make &> /dev/null; then
    make --version | head -n1
else
    echo "❌ NOT INSTALLED"
fi

# Check curl
echo -n "curl: "
if command -v curl &> /dev/null; then
    curl --version | head -n1
else
    echo "❌ NOT INSTALLED"
fi

# Check VS Code
echo -n "VS Code: "
if command -v code &> /dev/null; then
    code --version | head -n1
else
    echo "⚠️  NOT INSTALLED (Optional)"
fi

# Check Linphone
echo -n "Linphone: "
if command -v linphone &> /dev/null; then
    echo "✅ INSTALLED"
else
    echo "⚠️  NOT INSTALLED (Need a SIP softphone)"
fi

echo ""
echo "=== Docker Test ==="
docker run --rm hello-world 2>&1 | grep "Hello from Docker" && echo "✅ Docker working" || echo "❌ Docker not working"

echo ""
echo "=== Disk Space ==="
df -h / | tail -n1 | awk '{print "Available: " $4}'

echo ""
echo "=== Memory ==="
free -h | grep Mem | awk '{print "Total: " $2 ", Available: " $7}'

EOF

chmod +x verify_setup.sh
./verify_setup.sh
```

---

## Network Requirements

### Ports to be Used

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| FreeSWITCH SIP | 5060 | TCP/UDP | SIP signaling |
| FreeSWITCH ESL | 8021 | TCP | Event Socket Layer |
| FreeSWITCH RTP | 16384-16484 | UDP | Audio streaming |
| Bot Orchestrator HTTP | 8090 | TCP | REST API |
| Bot Orchestrator WS | 8091 | TCP | WebSocket audio |
| Integration Service | 8080 | TCP | Backend API |
| Whisper ASR | 9000 | TCP | ASR service |
| Piper TTS | 5000 | TCP | TTS service |
| Ollama | 11434 | TCP | LLM service |

**Firewall:** Ensure these ports are not blocked by firewall

```bash
# Check if ports are available
sudo netstat -tuln | grep -E '5060|8021|8090|8091|8080|9000|5000|11434'
```

---

## Optional Tools

### 1. Postman or Insomnia
**Purpose:** API testing
- Download from: https://www.postman.com/ or https://insomnia.rest/

### 2. Wireshark
**Purpose:** Network packet analysis (for debugging SIP/RTP)
```bash
sudo apt-get install -y wireshark
```

### 3. jq
**Purpose:** JSON parsing in terminal
```bash
sudo apt-get install -y jq
```

---

## Estimated Installation Time

- **Go:** 5 minutes
- **Docker:** 10 minutes
- **Git, Make, curl:** 5 minutes
- **VS Code:** 5 minutes
- **Softphone:** 5 minutes
- **Docker Images (first pull):** 30-60 minutes (depending on internet speed)

**Total:** ~1-1.5 hours

---

## Troubleshooting

### Docker Permission Denied
```bash
# If you get "permission denied" when running docker
sudo usermod -aG docker $USER
newgrp docker
# Or logout and login again
```

### Go Command Not Found
```bash
# Make sure PATH is set
echo $PATH | grep go
# If not, add to ~/.bashrc and source it
source ~/.bashrc
```

### Port Already in Use
```bash
# Find what's using a port
sudo lsof -i :5060
# Kill the process if needed
sudo kill -9 <PID>
```

---

## Next Steps

After completing this setup:

1. ✅ Verify all installations using the verification script
2. ✅ Create project directory structure
3. ✅ Set up Docker Compose configuration
4. ✅ Configure FreeSWITCH
5. ✅ Start building the Bot Orchestrator

---

## Support Resources

- **Go Documentation:** https://go.dev/doc/
- **Docker Documentation:** https://docs.docker.com/
- **FreeSWITCH Documentation:** https://freeswitch.org/confluence/
- **Project Document:** Refer to main internship project document

---

**Document Version:** 1.0  
**Last Updated:** December 2024  
**For:** ARM EDUCATIONS AI Voice IVR Platform
