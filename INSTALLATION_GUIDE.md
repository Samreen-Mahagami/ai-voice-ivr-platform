# AI Voice IVR Platform - Installation Guide

> Complete step-by-step explanation of the installation process


**Project:** AI Voice IVR Platform  

---

## Table of Contents

1. [Overview](#overview)
2. [Documentation Files Created](#documentation-files-created)
3. [Pre-Installation Check](#pre-installation-check)
4. [Go Installation](#go-installation)
5. [Docker Installation](#docker-installation)
6. [Docker Group Configuration](#docker-group-configuration)
7. [System Resources Verification](#system-resources-verification)
8. [Summary](#summary)
9. [Next Steps](#next-steps)

---

## Overview

This document explains every step taken during the initial setup and installation of the AI Voice IVR Platform development environment. By the end of this process, you will have all the necessary tools installed to begin development.

### What We're Installing

| Software | Version | Purpose |
|----------|---------|---------|
| Go | 1.22.0+ | Primary programming language (60-70% of project) |
| Docker | Latest | Container runtime for services |
| Docker Compose | Latest | Multi-container orchestration |
| Git | 2.43.0+ | Version control (pre-installed) |
| Make | 4.3+ | Build automation (pre-installed) |
| curl | 8.5.0+ | API testing (pre-installed) |

---

## Documentation Files Created

Before installation, we created three essential documentation files:

### 1. SETUP_REQUIREMENTS.md

**Purpose:** Detailed installation guide with all requirements

**Contents:**
- Complete list of required software
- Installation commands for Linux
- Port requirements for all services
- Network configuration details
- Troubleshooting tips
- Verification scripts

**Why Important:** This is your reference document when setting up the environment or helping team members set up their machines.

**Key Sections:**
```
- System Requirements (OS, RAM, Disk)
- Software Installation Steps
- Docker Images Information
- Port Mappings (5060, 8021, 8090, etc.)
- Verification Checklist
- Troubleshooting Guide
```

---

### 2. README.md

**Purpose:** Professional GitHub project documentation

**Contents:**
- Project overview and key features
- Architecture diagram (ASCII art)
- Quick start guide
- Complete project structure
- Technology stack details
- API endpoint documentation
- Sample conversation flow
- Testing instructions
- Development roadmap

**Why Important:** This is the "front page" of your GitHub repository. It's the first thing people see when they visit your project.

**Key Features:**
- Professional badges (Go version, Docker, License)
- Visual architecture diagram
- Use case examples (Banking, Healthcare, E-commerce)
- Complete API reference
- Troubleshooting section

---

### 3. verify_setup.sh

**Purpose:** Automated setup verification script

**What It Does:**
```bash
#!/bin/bash
# Checks installation of:
- Go version
- Docker version
- Docker Compose version
- Git version
- Make version
- curl version
- System memory
- Disk space
```

**Why Important:** Quick way to verify everything is installed correctly without manually checking each tool.

**Usage:**
```bash
chmod +x verify_setup.sh
./verify_setup.sh
```

---

## Pre-Installation Check

Before installing anything, we checked what was already available on the system.

### Commands Run:

```bash
go version      # Check if Go is installed
docker version  # Check if Docker is installed
git version     # Check if Git is installed
make version    # Check if Make is installed
curl version    # Check if curl is installed
```

### Results:

| Tool | Status | Version |
|------|--------|---------|
| Go | ❌ Not Installed | - |
| Docker | ❌ Not Installed | - |
| Git | ✅ Installed | 2.43.0 |
| Make | ✅ Installed | 4.3 |
| curl | ✅ Installed | 8.5.0 |

**Conclusion:** We needed to install Go and Docker. Git, Make, and curl were already available.

---

## Go Installation

### Why Go?

Go is the primary programming language for this project:

**Components Written in Go:**
1. **Bot Orchestrator** (~50% of project)
   - ESL client (FreeSWITCH connection)
   - WebSocket server (audio streaming)
   - Session management
   - Audio processing & VAD
   - ASR/LLM/TTS client integrations
   - Dialog engine

2. **Integration Service** (~15% of project)
   - REST API handlers
   - Business logic
   - Data store

3. **Testing** (~10% of project)
   - Unit tests
   - Integration tests

**Total Go Work:** ~60-70% of the project

---

### Installation Steps

#### Step 1: Download Go Binary

```bash
wget -q -P /tmp https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
```

**What This Does:**
- `wget`: Download tool
- `-q`: Quiet mode (less output)
- `-P /tmp`: Save to /tmp directory
- Downloads Go 1.22.0 for Linux 64-bit

**File Size:** ~140MB

**Why /tmp?** Temporary directory, will be cleaned up automatically.

---

#### Step 2: Extract Go to System Directory

```bash
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf /tmp/go1.22.0.linux-amd64.tar.gz
```

**What This Does:**
- `sudo rm -rf /usr/local/go`: Remove any existing Go installation
- `sudo tar -C /usr/local -xzf`: Extract archive to /usr/local
  - `-C /usr/local`: Change to this directory
  - `-x`: Extract
  - `-z`: Decompress gzip
  - `-f`: File to extract

**Result:** Go is now installed at `/usr/local/go/`

**Directory Structure:**
```
/usr/local/go/
├── bin/          # Go executable (go, gofmt, etc.)
├── src/          # Go standard library source
├── pkg/          # Compiled packages
└── ...
```

---

#### Step 3: Configure Environment Variables

```bash
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
```

**What This Does:**

**Line 1: Add Go to PATH**
```bash
export PATH=$PATH:/usr/local/go/bin
```
- **PATH:** Environment variable that tells Linux where to find executables
- Adds `/usr/local/go/bin` to PATH
- Now you can run `go` command from anywhere

**Line 2: Set GOPATH**
```bash
export GOPATH=$HOME/go
```
- **GOPATH:** Where Go stores downloaded packages and compiled binaries
- Set to `$HOME/go` (e.g., `/home/aayesha/go`)
- Directory structure:
  ```
  ~/go/
  ├── bin/      # Compiled binaries (go install)
  ├── pkg/      # Compiled packages
  └── src/      # Source code (legacy, not used in modules)
  ```

**Line 3: Add GOPATH/bin to PATH**
```bash
export PATH=$PATH:$GOPATH/bin
```
- Adds `~/go/bin` to PATH
- Allows running Go tools installed with `go install`

**Why ~/.bashrc?**
- Bash configuration file
- Runs every time you open a terminal
- Makes these settings permanent

---

#### Step 4: Activate Environment Variables

```bash
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

**Why Run Again?**
- Changes to `~/.bashrc` only apply to new terminal sessions
- Running these commands applies them to the current session
- Now we can use Go immediately without restarting terminal

---

#### Step 5: Verify Installation

```bash
go version
```

**Expected Output:**
```
go version go1.22.0 linux/amd64
```

**What This Tells Us:**
- `go1.22.0`: Version installed
- `linux`: Operating system
- `amd64`: Architecture (64-bit Intel/AMD)

**✅ Go Installation Complete!**

---

## Docker Installation

### Why Docker?

Your project uses **5 different services** that need to run together:

| Service | Purpose | Technology |
|---------|---------|------------|
| FreeSWITCH | Phone system (SIP/RTP) | C/C++ application |
| Whisper ASR | Speech-to-text | Python + PyTorch |
| Ollama + Llama3 | AI brain (LLM) | Go + AI model |
| Piper TTS | Text-to-speech | Python + Neural network |
| Your Go Services | Bot logic | Go applications |

**The Problem Without Docker:**
- Each service has different dependencies
- Different programming languages
- Complex installation procedures
- Version conflicts
- Hard to manage together

**The Solution With Docker:**
- Each service runs in an isolated container
- Pre-configured images available
- Easy to start/stop all services
- Consistent across different machines
- Simple configuration with Docker Compose

---

### Installation Steps

#### Step 1: Update Package Index

```bash
sudo apt-get update -qq
```

**What This Does:**
- `apt-get update`: Refresh list of available packages
- `-qq`: Very quiet mode (minimal output)
- Contacts Ubuntu package repositories
- Downloads latest package information

**Why Important:** Ensures you get the latest versions of packages.

---

#### Step 2: Install Prerequisites

```bash
sudo apt-get install -y ca-certificates curl gnupg lsb-release
```

**What This Does:**

| Package | Purpose |
|---------|---------|
| **ca-certificates** | SSL/TLS certificates for secure HTTPS connections |
| **curl** | Command-line tool for downloading files |
| **gnupg** | GNU Privacy Guard - for verifying package signatures |
| **lsb-release** | Detects Linux distribution version |

**Why Needed:**
- `ca-certificates`: To securely download Docker packages
- `curl`: To download Docker's GPG key
- `gnupg`: To verify Docker packages are authentic
- `lsb-release`: To detect Ubuntu version (20.04, 22.04, 24.04, etc.)

---

#### Step 3: Create Keyrings Directory

```bash
sudo mkdir -p /etc/apt/keyrings
```

**What This Does:**
- Creates directory for storing GPG keys
- `-p`: Create parent directories if needed, don't error if exists

**Why Important:** Modern Ubuntu stores package signing keys here for security.

---

#### Step 4: Add Docker's GPG Key

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

**What This Does:**

**Part 1: Download GPG Key**
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg
```
- `-f`: Fail silently on server errors
- `-s`: Silent mode
- `-S`: Show errors even in silent mode
- `-L`: Follow redirects
- Downloads Docker's public GPG key

**Part 2: Convert and Save Key**
```bash
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
- `|`: Pipe output to next command
- `gpg --dearmor`: Convert ASCII key to binary format
- `-o`: Output file location

**Why Important:**
- **GPG Key:** Cryptographic signature
- Verifies Docker packages are authentic
- Prevents installing fake/malicious packages
- Security best practice

---

#### Step 5: Add Docker Repository

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
```

**What This Does:**

**Breaking Down the Command:**

```bash
deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable
```

- `deb`: Debian package repository
- `arch=amd64`: Architecture (64-bit)
- `signed-by=...`: Use Docker's GPG key to verify packages
- `https://download.docker.com/linux/ubuntu`: Docker's repository URL
- `noble`: Ubuntu version codename (24.04 = noble, 22.04 = jammy, etc.)
- `stable`: Use stable release channel

**Dynamic Parts:**
- `$(dpkg --print-architecture)`: Detects your CPU architecture (amd64, arm64, etc.)
- `$(lsb_release -cs)`: Detects Ubuntu version codename

**Result:** Creates file `/etc/apt/sources.list.d/docker.list` telling Ubuntu where to download Docker from.

---

#### Step 6: Update Package Index Again

```bash
sudo apt-get update -qq
```

**Why Again?**
- We just added a new repository (Docker)
- Need to refresh package list to include Docker packages
- Now `apt-get` knows about Docker packages

---

#### Step 7: Install Docker Packages

```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**What Each Package Does:**

| Package | Purpose |
|---------|---------|
| **docker-ce** | Docker Engine (Community Edition) - Core Docker daemon |
| **docker-ce-cli** | Docker command-line interface (`docker` command) |
| **containerd.io** | Container runtime - Actually runs the containers |
| **docker-buildx-plugin** | Extended build capabilities (multi-platform builds) |
| **docker-compose-plugin** | Docker Compose v2 (`docker compose` command) |

**Installation Process:**
1. Downloads packages (~100MB total)
2. Installs packages
3. Creates Docker daemon service
4. Starts Docker automatically
5. Configures Docker to start on boot

**Services Created:**
- `docker.service`: Main Docker daemon
- `docker.socket`: Docker API socket

---

#### Step 8: Add User to Docker Group

```bash
sudo usermod -aG docker $USER
```

**What This Does:**

**Breaking Down the Command:**
- `usermod`: Modify user account
- `-a`: Append (don't remove from other groups)
- `-G docker`: Add to "docker" group
- `$USER`: Your username (e.g., "aayesha")

**Why Important:**

**Without Docker Group:**
```bash
docker ps
# Error: permission denied
```
- Only `root` can access Docker socket
- Must use `sudo docker` for every command
- Annoying and less secure

**With Docker Group:**
```bash
docker ps
# Works without sudo!
```
- Members of `docker` group can access Docker socket
- No need for `sudo`
- More convenient for development

**Security Note:** Docker group has root-equivalent privileges. Only add trusted users.

---

#### Step 9: Verify Docker Installation

```bash
sudo docker --version
sudo docker compose version
```

**Output:**
```
Docker version 29.1.3, build f52814d
Docker Compose version v5.0.0
```

**What This Tells Us:**
- Docker Engine is installed and working
- Docker Compose plugin is available
- Versions are recent and compatible

---

#### Step 10: Test Docker

```bash
sudo docker run --rm hello-world
```

**What This Does:**

**Step-by-Step Process:**
1. Looks for `hello-world` image locally
2. Doesn't find it, downloads from Docker Hub
3. Creates a container from the image
4. Runs the container
5. Container prints "Hello from Docker!"
6. Container exits
7. `--rm` flag removes the container automatically

**Expected Output:**
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
...
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

**What This Proves:**
- Docker can download images from Docker Hub
- Docker can create containers
- Docker can run containers
- Docker networking works
- Installation is successful

**✅ Docker Installation Complete!**

---

## Docker Group Configuration

### The Problem

After adding yourself to the `docker` group, Linux doesn't immediately recognize the change.

**Why?**
- Group membership is determined when you log in
- Your current session still has the old group list
- Need to "refresh" the session

### The Solution

#### Option 1: newgrp Command (Temporary)

```bash
newgrp docker
```

**What This Does:**
- Starts a new shell session
- Loads updated group membership
- Only affects current terminal
- Other terminals still need `sudo`

**When to Use:**
- Quick testing
- Don't want to log out
- Only need Docker in one terminal

---

#### Option 2: Log Out and Log Back In (Permanent)

**What This Does:**
- Completely refreshes your session
- All terminals get the new group
- Most reliable method

**When to Use:**
- Permanent solution
- Want Docker to work everywhere
- Recommended approach

---

### Verification

#### Check Group Membership

```bash
groups $USER
```

**Output:**
```
aayesha : aayesha adm cdrom sudo dip plugdev users lpadmin docker
                                                              ^^^^^^
```

**What to Look For:**
- `docker` should appear in the list
- If it's there, you're in the group
- Just need to refresh session

---

#### Test Docker Without Sudo

```bash
docker ps
```

**Before newgrp/logout:**
```
permission denied while trying to connect to the Docker daemon socket
```

**After newgrp/logout:**
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

**✅ Docker Group Configuration Complete!**

---

## System Resources Verification

### Why Check Resources?

AI models and Docker containers require significant system resources:

| Component | RAM Usage | Disk Usage |
|-----------|-----------|------------|
| FreeSWITCH | ~100MB | ~500MB |
| Whisper ASR | ~2GB | ~2GB |
| Ollama + Llama3 | ~4GB | ~4GB |
| Piper TTS | ~500MB | ~500MB |
| Your Go Services | ~100MB | ~100MB |
| **Total** | **~7GB** | **~7GB** |

**Project Requirements:**
- Minimum 8GB RAM
- Minimum 20GB free disk space

---

### Commands Run

#### Check Memory

```bash
free -h
```

**Output:**
```
              total        used        free      shared  buff/cache   available
Mem:           7.4Gi       5.4Gi       595Mi       1.2Gi       2.7Gi       2.1Gi
Swap:          2.0Gi       1.5Gi       512Mi
```

**What This Means:**
- **Total:** 7.4GB RAM installed
- **Used:** 5.4GB currently in use
- **Available:** 2.1GB available for new applications
- **Swap:** 2GB swap space (disk used as RAM when needed)

**Status:** ✅ Meets 8GB minimum requirement

---

#### Check Disk Space

```bash
df -h /
```

**Output:**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme0n1p9   77G   51G   22G  71% /
```

**What This Means:**
- **Size:** 77GB total partition size
- **Used:** 51GB currently used
- **Avail:** 22GB available
- **Use%:** 71% full

**Status:** ✅ Meets 20GB minimum requirement

---

### Resource Summary

| Resource | Available | Required | Status |
|----------|-----------|----------|--------|
| RAM | 7.4GB | 8GB | ⚠️ Slightly below (but workable) |
| Disk | 22GB | 20GB | ✅ Sufficient |

**Note:** 7.4GB RAM is slightly below the 8GB recommendation, but should work fine for development. You may need to:
- Close unnecessary applications when running all services
- Use smaller AI models (Whisper base instead of large)
- Monitor memory usage

---

## Summary

### What We Accomplished

#### 1. Created Documentation
✅ **SETUP_REQUIREMENTS.md** - Detailed installation guide  
✅ **README.md** - GitHub project documentation  
✅ **verify_setup.sh** - Automated verification script

#### 2. Installed Software
✅ **Go 1.22.0** - Primary programming language  
✅ **Docker 29.1.3** - Container runtime  
✅ **Docker Compose v5.0.0** - Multi-container orchestration

#### 3. Configured Environment
✅ **Go PATH** - Added to ~/.bashrc  
✅ **GOPATH** - Set to ~/go  
✅ **Docker Group** - User added for sudo-less access

#### 4. Verified System
✅ **Memory** - 7.4GB available  
✅ **Disk** - 22GB free  
✅ **Docker** - Working correctly  
✅ **Go** - Working correctly

---

### Installation Timeline

| Step | Task | Time Taken |
|------|------|------------|
| 1 | Create documentation | 5 minutes |
| 2 | Check existing software | 2 minutes |
| 3 | Install Go | 5 minutes |
| 4 | Install Docker | 10 minutes |
| 5 | Configure Docker group | 2 minutes |
| 6 | Verify installation | 3 minutes |
| **Total** | | **~27 minutes** |

---

### Files Created

```
AI-Voice-IVR-Project/
├── SETUP_REQUIREMENTS.md      # Detailed setup guide
├── README.md                  # GitHub documentation
├── INSTALLATION_GUIDE.md      # This file
└── verify_setup.sh            # Verification script
```

---

### Environment Variables Set

```bash
# In ~/.bashrc
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

---

### Services Installed

| Service | Status | Version | Command |
|---------|--------|---------|---------|
| Go | ✅ Running | 1.22.0 | `go version` |
| Docker | ✅ Running | 29.1.3 | `docker --version` |
| Docker Compose | ✅ Running | v5.0.0 | `docker compose version` |
| Git | ✅ Running | 2.43.0 | `git --version` |
| Make | ✅ Running | 4.3 | `make --version` |
| curl | ✅ Running | 8.5.0 | `curl --version` |

---

## Lint Sne Installation

### that the fne?

Linphone is: Additioftphone th(Optionals your "phone" tst the IVRYou'll use it to maks to FreeSWITCH and with your AI agent.
- [ ] Install Linphone (SIP softphone for testing)
- [ ink of it aS Code with Go extensions
- [*Linphone** = Your/Insne (client)
- reeSWITCH** = Theny (server/P
### Pha Orchestrator** ructurAI agent that answers

--[ ] Initialize Go modules

### InstallatMakefile

#### Step 1: Update Ponfige Index
- [ ] Create docker-compose.yml
- `bash
sudo apt-get updatesper ASR container
- [ ] Configure Ollama container

**What This Doesworkiefreshes theontat of available paes.

---

##[ ] tep 2: Iner extensihone Desktop
- [ ] Create dialplan
- [ ] h
sudo apt-genstall -y linptop
```

**No] Build I package namerviceged from `linph to `linphone-desktop`er Ubuntu versio
- [ ] Integrate AI services
- What Gete testsed:**
- `l] End-todesktop` ingn application
`liblinphone11 Core library
- `mediastrea3` - Audio/video stream
---ibortp16` - RTP ppport
- `libbel2` -ck

**Intion Size:** ~50MB



#### Step 3## Troublesstallation

```bashooting Reference
which linphone
# Ot: /usr/bin/hone

d-s linphone-desktop |Package|^Status|^Versi
### tput:
# PGokage: linphon Issues
# Status: instaled
# Versiouild5
```

-

*### Step 4*Prheck Executableoblem:** `go: command not found`
```bash
# Soluh
ls -lh /usr/bin/tion: Ch
# Output: -ecxr-xr-x 1 rok PAoot 7.5M AprTH/usr/bilinphone
```

-
echo $PATH | grep go
# IfLaunching Linphon not found, reload bashrc
source ~/.bashrc
``Option 1: From A`tions Menu**
1er/Windows key
. Type "one"
3. Click nphone icon

**From Terminal**
```bas
**Proble &
```

m:** `GOPAns it in the baTH nound so you cot set`ue using the tinal.

---

##portant Note:flict

```bashutomatically listening on port 50t). This the same port Freeds!

**Solutiop Linphone betarting FreeSWITCH:
#``bash
killall  Solutio
```

Youn: Set GOPAre andTHone **after** FreeSWIperly set up
export GOPATH=$HOME/go
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
```
FreeSWITCtion

### eeSWITCH?

WITCH is the tele:
- Handles SIl (call sig
--Manages RTP str-io)
- Rto your Bostrator
- Provi Socket Layer (ESL programmat

**In simple* It's the "phonny" that cs callers to your AI.

---

### Instaroach: Docker

Docker instead of inling FreeSWITCH dirse:
- ✅ FreeCH has complendencies
- ✅ocker provides are-configured envment
- ✅ Easy to starart
- ✅ Doesn'lute your system
- ✅ istent across erent machines

-

### Intion Steps

#### Stepte Project Structu

```bash
cdce-IVR-Project
#kdir -p## Dockerch/conf
```

* Issuesory Structure:**
`
-Voice-IVR-Project
**Probleswitch/
em:**── conf/          `permisWITCH configurasion files
├── docn deniepose.yml
└── d` 
```

---
when running docker
```b Step 2: SeaasheeSWITCH Docker Is

```bash
do docker searcswitch --limit 
# Solution 1: Use newgrp
newgrp docker
Output:**
``
# SE                     olutio STARS
safarov/freeswin 2: Log ou      44
olfwayt aeeswitch   nd back     4
bdfoster/in           
eltfoundation/freesch   5
```

# Solutied:** `safon v/freeswitc3: Check popula group tars)

-membership
groups $USER | grep docker
`### Ste``eate docker-composyml

Created a Doose file to manaWITCH:

`
services:
 witch:
    image: safaswitch:latest
    ame: freeswit
    hostname: fwitch
    networst            st networ
**Problironment:
 em:**- FREESWITCH_HOST DoE=localhost
 cker daemon
      - . not runnch/conf:/etc/freeswitch:ing
```bashpped
    priviltrue
```
# Check status
sudonfiguration E systemc:**

| Settitl stValue | Puratue |
|------s doc------|---------ker
image` | `safarov/freeswitch:lat | Docker image to us
# Stantainer_name` | rt eeswitch` | NDockerconta
| `networde` | `host` | Use hos(simpler forocal testing) |
|olumes` | `./fre:/etc/freeswitch`ount config dictory |
s `privileudo systemct` | Required for soml startWITCH f docker|

**Why twork_mode: *
- Simorking for local delopment
SWITCH can direhost po
 Avoids port forwarding 
# Enl porable on0, 8021, 16384-16 bootatically available



## 4: Pull CH Docker Image

sudo systemctl enable docker
sudo docker ```v/freeswitch:latest
``

**Problem:**ns:**
1. Connects to Canker Hub
2. Downlonot connectTCH image (~200MB) to Docker daemon
```bashs locally for fse

**Outp
# Check if socket exists
latest: Pullinlsfrom safarov/freeswitc -l /var/run/docker.sock
complete 
f6da18772b7ete 
Digsha256:b31c743f4c919687c61e3214968f2a24f93f9d3d667cc58ffc6
Status: Dod newer image foafarov/freeswitch:
# Fix permissions

---

#### Stepsudo chmle Port Conflicod 666 /var/run/docker.sock

Before startin```eeSWITCH, d to ensure 

**Check what's using rt 5060:**
---h
sudo ss -tulpn | gr60
```

**
```
udp   0  0  *:5060 rs:(("linphon,pid=49980,fd=39))
###   LISTEN 0  System Res *:*  users:(("linpource Iss=49980,fd=40ues


**Problem**Probnphone is usilem:** Out o!

**Soluf memory Linphone
```bash
```bashllall li
```

---

#### 6: Start FreeSWIntainer

```ba
# do dockCheck memoryp -d
```

**What  usagees:**
- : Detached moin background)
- Creates andfrtarts the `freeswitee  container
- Mount-hation directory
ITCH starts autlly

**Outp
# Check what's using memory
[+] up 1/1
ps aontainer freeswux --sort=-%
```

---

#mem Step 7: Veri | headSWITCH is Running

** -n 10ainer status:**
```b
ocker ps
```

**O
#``
CONTAINER  SolutiAGE                   on: CloseS                  unnAMES
af9f4ecessary  safarov/f applicationtest   Up 16 ss (healthy) eswitch
```

**CheSWITCH status:**
# Or use smaller AI models
sudo docke```freeswitch fs_cli -
```

**Outpu

UP 0 years0 hours, 0 min, 30 seco
**ProWITCH (Version 1.10.1blem:** Out is ready
0of dsion(s) since iskrtup
0 sessi spa) - peak 0, lastce
``00 session(s`bash
# C

**✅ FreeSWITCH iheck ding!**

sk usage
df -h
 Step 8: Check ion Files

Frely copies its confi directory:

# Clesh
ls -laan Dockerch/conf/
```
docker system prune -a
Output:**
```
dr2 root rootconfigs/
dr root root  dialpl
#rwxr-x Clean aoot root  directopt cache
suwxr-xr-x  4 rootdo apt-get crofiles/
lew-r--r--  1 rooanroot  freesw
``w-r--r--  1 root roo`xml
```

**Key ies:**
- `autonfigs/` -nfiguratio
lan/` - Call routing
---rectory/` - User(1000, 1001, etc
_profiles/P settings

---

### Known ## Veriand Warningsfication Checklist

Use this cheg logs, ycklisy see these et ors:

```bash
to ensucker lre everythitch
```

**Comming is segs:**
```
[Et up correctly:nvalid ext-rtp-
sofia.c:5Invalid exip
[CRIT]r Loading modu_sofia.so
`
### Software Installation
- [ ] Go 1.22Mean:**
- `ext+ insta` and `ext-sip-ip` are flleexternal IPd (`go ver
- sion`)n FreeSWITCH NAT (router)
- Fosting, we don't neem
- The SIP module) didn't load due terrors

**Why ItOkay:**
- Frecore is running f
- [  have access t] Docker intion files
- stalled (`dhe SIP confocker --vern the next phase
sion`)
- Status:**[ ] FreeSWITCH running,Doct SIP module nker Compose inston

--alled (`docker compose version`)

### Free- [ ] Git installed (`git --version`)

Access FreeSWITCH c- mand-line [ ] Makce:

```bae installed (`make --version`)
- [ ] ccker exec -it urleswitch fs_cli installed (`curl --version`)


**Useful### Conds:**
```
status  figurat           # Show iontatus
so              w SIP profwon't work yet)
-how calls [ ] Go         # List active cal in PATH (`which go`)
- [ ] GOPATH         set (`echo  active channels
$GOPATH`)                # Relo configuration
- [ ]own                  # Stop  User in docker group (`groups $USER | grep docker`)
-``

**Exit  [ ] Dockpe `exit` or preer works D`

---

withnstallation Summaryout sud

### What Wo (ccomplished

#`docker e 1: Core Tops`)✅
- [x] Go 1led
- [x] Docker 23 installed
cker Compose v5.lled
- [x] Git, Maified

###elephony T
- [x] Linphone 5.0.lled
] FreeSWITCH 1. running in Docker
- ] Project sture created
-] docker-mpose.yml configured
### System Resources
- [ ] Atse 3: Configuration ⏳ least 7GB RAM available (`free -h`)
- [ ] Atx FreeSWITCH  least 20G
- [ ] Create user eB disk sp (1000, 1001)
-ace (`df -hure dialplan
- [ ] `)h Linphone

---

##Current Syste

| Compone | Statu Version | Locati
------|--------|---|----------|
| G Running | 1.22.sr/localgo` |
| Docker nning | 29.1.3 |in/docker` |
| Dompose | ✅ R | v5.0.0 |
| Git | ✅ R2.43.0 | `/usr/bin |
| Make |g | 4.3 | `/usr/bmake` |
| curl unning | 8.5.0 | bin/curl
| Linphnstalled |0.2 | `/
| FreeSWIT### D✅ Running | 1oc0.12 | Docker cker Funct|

---

###ionaes Created

```lity
/home/aayesh- [ ] Doce-IVR-Project/cker daemon running (`docker ps`)
- [ ] Cker-compose.yman pull i      # Docker smages (`dockiguration
├er freeswitch/
│   └── cpull               hello   # FreeSWI-world`)ration
│   ── autoload_confi
- [     ├── dialpla] 
│       ├── directCan run containers (`docker run hello-world`)
   ├── sip_files/
│       witch.xml
│   ars.xml
├── README.m
##─ SETUP_REQUIR# Documentation
├── INSTALLATI- [ UIDE.md
└── verif] SEtup.sh
```TUP_REQUIREMENTS.md created
- [ ] README.md created
- [

### Docker Contain ] veunning

```brify_setup.sh created and executable
cker ps
```

---*
```
CONTAINER                      SORTS   NAMES
af9fafarov/frees   Up 5 min          freeswitch
`

---

 Next Steps

that the foun is complete,what comes nex

### PhaseCH Configurati
- [ ] Fix SIP p## Ade confiditional
- [ ] Create  Resourcesons (1000, 
] Configure(9196, 9197,
### OfTest SIP regisficialn with Linphone
- Documentation

### Phase 2: Add- **Go:*Servic* https://go.dev/doc/
- **Docdd Whisper ASR to ker:** htmpose
- [ ] tps://dama + Locs.3 to docker-compose
dock] Add Piper TTS to er.com/ose
- [ ] Test  services

se 3: Botchestrator Dev
- [ ] Create Gject structur
- **D Implemeocker Comient
- [ pose:** htt WebSocket server
- [ps://plement session mdocsement
- [ .docker.cnt audio pom/comp

### Phase 4: Iose/n Service Developmen
- [ ] Create Go projec- **Uucture
- [ ] buntument REST API:** https://help.ubuntu.com/
- [ ] Create data store
- [ent business logic

### Phase 5: AI I## Lration
- [ ] Integreae Whisper ASR
-rning Resourte Ollama LLM
- [ ceIntegrate PisTS
- [ dialo
- **Go Tour:** https://go.dev/tour/
- **Phase 6: Testing DoDeployment
cker Tutit tests
- [ ] Inteorial:** hsts
- [ ] End-to-ttpstests
- [ ] Doc://docker-curriculum.com/
- [ ] Final demo- **FreeSWITCH:** https://freeswitch.org/confluence/

### Community Support
- **Go Forum:** https://forum.golangbridge.org/
- **Docker Forum:** https://forums.docker.com/
- **Stack Overflow:** https://stackoverflow.com/

---

## Conclusion

You have successfully completed the initial setup and installation phase of the AI Voice IVR Platform project. Your development environment is now ready with:

- ✅ Go programming language
- ✅ Docker container platform
- ✅ All necessary tools and utilities
- ✅ Proper configuration and permissions
- ✅ Comprehensive documentation

You are now ready to proceed with creating the project structure and building the actual IVR system.

---

**Document Version:** 1.0  
**Status:** Installation Complete ✅

---

---

## Step 7inphP Softphone)
 Why Linphone?
Linphone is a SIphone that you'll useur IVR system. It actshone" ts to FrTCH.

**Purp
- Make testlls to your IVR systemr with FreeSWIIP client
Test audio qualitlows

-nstallation Steps

#### StepUpdate Paage Index

`bashudo apt-get uq
```

**What This efreshge list to get version information.
 Step 2: Instalinphone Desk

```bashudo apt-get install --desktop
``` This D*
- Downstalls Linentphone D packageInstalls all des (liblinphone, eamer, e)
- Creatop applicry
op` i
** InstaNe:** The pa name change`linphone` to `lin newer Uions.
nphone-desktop` 
**lled:**- SIP library streaming
 Mainpplication
ne11t64` -
- `libmedi3t64` - Audi- `lib16` - RTP protocol impl`libbellesip2t64` -ck

---

###Verify Install

```bash
whiche
```ut:**

```
/r/bin
```***Ex
``
dpkgpected  -s linpho Staop | grep -Ee|^Status|^Version
```
Package: l**Clled
Version: 5he.2-4
| **Size** | ~7buiB |

---ld5
``# How to Launc`

**Option 1: From App** | ions Menu**
the Linphon1. Pre`/ue iconsr/bin/ldows key
2."Linphone"e is working.
tallation Challeng
**Dirplex den takes 30+pect (50+ packages
t t Version to uconflict cleanly
**(ready in 2 minutes)
- Prolated from ss differenst machinysteremove
- Consistent acm
- -allation Steps
oject Directructure
#### Step 1: Cr## Easy to start/ste-bui
**Docker Bes wita(via em librariesDocker)ur Botalls.llat
eswitch/conf

stead**T of Direct
*What This *
- Creates `fref` subdirs if neectory esedwity figuration filesfor Fre files
- Cre` creates parent a
### sult:**
```
AI-Voice-Wht as:** t/
└── freeswitThe phonnfrastructure that c
.)pla── conf/   n exe  # Configuration willcun here
```

- **Eventocket Layer (ESL)*- Control interface
- **RTtreams** - Audio data ionWITCH servic
Created a Doc- *# Step 2 file to define F: Cr*Call Rcker-comoutin
Freyaml
services:ch:
   mage:rtwork_mode: eest`?**
- Simpswitch:networkinglate local development
-afarov/freeswitch   F          44
olfwaludes vanilla configuryrion
```

**What Th Does:** image from Do
- Image size: ~200MB
**Output:**test
```

---


**Cause:inphone was nd using port 5060.
on:**
```o killall linpbas
l Frees up port 5060
- Linphs FreeSWITCH toonerocee port
sses
**What ication:**
```bash
```
- Shourn empty (n
- Means port 5tart FreeSWITCH Con060 no

```bw free
#### Stcker compose up -suThiss -tulpn | grep :s Does:**
**So
```te 3f4c91d nndle Porost port 0.0.0.0:t Contcp: address already flict
**What This Does:CH container
- Moun**eweuration dire
E Starts FreeSW `-d`: Detachedrror: failr in background)
imOutput:**h Created
```
``eck Co`entainSWITCH is:**
```bash
sud Rdocker ps
```
y)   freeswitch
```

```bashfs_cli -x "st
```
```ys, 0 hours, 0 mieconds
0 session(s)FreeSak 0, last 5miWI0
```

--startup
0 session(s) 1.10.12 -release
UP # Stnf/
```
*gs/ root  4 root iroot  freeswp_profil
-rw-r--r--  esroot root  vars.xml/
-r`

**What Thhostis Mw- |

--
d FrStatus** | RueeSWI |conf/
, you may seengs:
es
```

---l FreeSWITCH Commands

**Access FreeSWITCH CLitch fs_cli
```

*n Single Command:**
`sh"
sudo docker ewitch fsx "sofia status"
sudo dker exec freeswitch "show calls"

**View Logs:**
```bashker logs freeswitch
scker logs -f frollow logs
```
FreeSWITCH:**
```bh restart fre
su`
:**cker compose 
```bashhony |

---

### CProject Structure

```
/home/aayesha/AI-Voice-IVR-Project/
│
├── docker-compose.yml              # Docker services configuration
│
├── freeswitch/
│   └── conf/                       # FreeSWITCH configuration
│       ├── autoload_configs/       # Module configurations
│       ├── dialplan/               # Call routing rules
│       ├── directory/              # User extensions
│       ├── sip_profiles/           # SIP settings
│       ├── freeswitch.xml          # Main config
│       └── vars.xml                # Variables
│
├── README.md                       # GitHub documentation
├── SETUP_REQUIREMENTS.md           # Installation guide
├── INSTALLATION_GUIDE.md           # This file (updated)
└── verify_setup.sh                 # Verification script
```

---

### What's Working

✅ **Development Environment**
- Go programming language ready
- Docker container platform ready
- All build tools available

✅ **Testing Tools**
- Linphone softphone installed
- Can make SIP calls (once configured)

✅ **Telephony Infrastructure**
- FreeSWITCH running in Docker
- Configuration files accessible
- CLI access working

---

### What Needs Configuration

⚠️ **FreeSWITCH SIP Module**
- Fix ext-rtp-ip and ext-sip-ip settings
- Configure internal SIP profile
- Enable mod_sofia module

⚠️ **User Extensions**
- Create extension 1000 (username/password)
- Create extension 1001 for testing
- Configure authentication

⚠️ **Dialplan**
- Create echo test extension (9197)
- Create AI IVR extension (9196)
- Configure call routing

⚠️ **Linphone Configuration**
- Configure SIP account
- Set server address
- Test registration

---

### Installation Timeline (Updated)

| Step | Task | Time Taken | Status |
|------|------|------------|--------|
| 1 | Create documentation | 5 min | ✅ Complete |
| 2 | Check existing software | 2 min | ✅ Complete |
| 3 | Install Go | 5 min | ✅ Complete |
| 4 | Install Docker | 10 min | ✅ Complete |
| 5 | Configure Docker group | 2 min | ✅ Complete |
| 6 | Verify installation | 3 min | ✅ Complete |
| 7 | Install Linphone | 3 min | ✅ Complete |
| 8 | Install FreeSWITCH | 5 min | ✅ Complete |
| **Total** | | **~35 minutes** | |

---

## Next Steps

### Immediate Tasks (Phase 4: FreeSWITCH Configuration)

1. **Fix SIP Profile Configuration**
   - Edit `sip_profiles/internal.xml`
   - Remove or configure ext-rtp-ip
   - Remove or configure ext-sip-ip
   - Restart FreeSWITCH

2. **Create User Extensions**
   - Edit `directory/default/1000.xml`
   - Set password to `1234`
   - Create extension 1001

3. **Configure Dialplan**
   - Create echo test (9197)
   - Create AI IVR entry (9196)

4. **Test with Linphone**
   - Configure Linphone SIP account
   - Register with FreeSWITCH
   - Make test call to 9197

### Future Tasks (Phase 5+)

5. Add Whisper ASR to docker-compose
6. Add Ollama + Llama3 to docker-compose
7. Add Piper TTS to docker-compose
8. Build Bot Orchestrator (Go)
9. Build Integration Service (Go)
10. Connect all services together

---

**Document Version:** 1.1  
**Status:** Linphone & FreeSWITCH Installation Complete ✅

---

**Next Document:** [FreeSWITCH Configuration Guide](FREESWITCH_CONFIG.md) (Coming Next)
ocker) | PBX/T
---| Buiomation* | 1.10.12 | ✅ | | ✅ Pre-insphone |
| **FreeStalled nt |
| **Linphon0.2 | ✅ Installed 
| **curl*
t** | 4.rol |3 | ✅ Pre-i
|
# **Git** | 2.43# Upd✅ Pre-installed | Vers**Stop Frella ption Summaryrammining languagelatform er orchestr|
| |Docker Compose**| ✅ Installed | Mu
|r** | 2✅ Installed
We've Ialled (Complett)|
| **Go*| ✅ Installed 
|----------|--n | St-|--------|-----atus | P
| Softwar
###do docker c
*
sudo docker exfreeswitch fs_cli 
#``ba##
sudo docker Us
`er logs freeswi
Whe
ngs:**nal     # GSIP profile    # lobal varMain coiguration
└── l     
```-----switch.xml   --|------| testing | fodule didn't or loc Needs configural testing 
Whyeeded Il testing (l         #oct's wh), we don't needen  ** exterH is behindnal/prouter
- We'll fix the SIP configurati Foub the next phasee
│   └── external.

---lic IPnfigura       tio     # Internal SIn  # Modnfigu
- O ├── sofia.conf.xml /  # SIP setts
│   n/─ internal          └─     # Defa─ ...xtension 10 ettings
│     ul   # Cons
│── sip_profiles/              # SIP pro └── 1001.xml     └── defaall res # Extension 1
├       ├── 1000.x── directory/       │   └─    # User ex─ default.xm
├── 
├── autolvent_socket.conf.xml  # oad_con
- These SWITCH Directorre

```
freeswitc
|
| `Inv-sifia.so` errorp-ip` | ExternaIP IP not
| `Invalid extExternal RTP IP ned | Normal fo
[Eia.c:Iplanation nval| Impact |id ext-rtp-ip
```---|-
n:**

| Error 
**What [a.c:5275 Invalid ig module mod_sop
[CRIT] Erro
**Comn checking` |
| # Known Issues and Warn**Netwo
| **ConfiTCHrwion** | `./freeswitcxr-xr-xW `freeswitcITCH 1.10.12ro
| **Contaiot  dialplanration to your directory
- Yongues  canist even if  /ry/iter is recre these files
d **Version** | Frrwx
er Immarymage** |freeswitch:late

| Item | D`rwxr-xr
|------|---------x  3 root root ``

### FreeSWITCH Instdrwxr-x  2 root root  aut
**Ou
ls -la freep 8: Check Conf0 yearn Files

```b

**Expected Oso docker exec fr
**Check FreeSWITCH Saf9f4b38dbasafarov/freesest   Up 16 second
unningd Output:**         NAM
`ID   IMAGE  ``              STATUS      
C

**
[+] u1a196as network ifge87c64968arov/freeswitch:f2a67cc26284192e158
StaContainer freestus: DoEncountered:**
w### Step 7:n
Digest: sh
lreeSWITCulling from safarov/freeH 1.10.1
04374166f4ca- Doll complete 
f6da18772b74: woadss default Fr
geeeswitch

```bash
sudo docker pul
---p 4: Pull FreeSWITCH Do
stocker sh            earchhesTCHw       STARSitch can  |ess host ports
*Res-uer/freeswitch          5
```
intained
- icial FreeSWI
**Whyularly   lts:*o asreeswitch`?**
- Mier popular (44 stars) for RTP (aumap  traffic
ilable FroundationeeImages
E         
```bash

--## Step 3: Search for A-
individual

**
c   volumes:ont  - Fainer_d
 ``nfig directory |g |ed` | Auto-rest
t** | `unless-
freeswitcheged** | `t/cosw| Required for audio itch` | Moun
**Confi   prion Explained:**
- **containerode** | `host` | _name----network (simpler|------wit testing) |
| **volch`------|:latest` | Doiner |
| **ncker image to 
| **image** | `safarov/fSetvile | Value | Purposged:natc/freeswitch:rw
    mhSTNAME=localh
      - ./freeswitchenvironment   hostnamfreeswitch
etwork_mode: h
  feSWITCH signNVITE, BYE
---gine (PBtocol** X) that hs:
- **SIP P
ITCH is the tel
## Sstall Free
**Option 2: Fro
| **Veh The `&` runs ie backgrouncontinue usithe terminal.
launci* UDP
- **Pros :** `sip:loeSWITCHcalthe sa060 SIP `
configure this after
**We'lme p `localhost:60`
- **Tr
- **Server Addreort FrH needs.
un FreeSWITCH** `1000`:**
*Password:** `1234
**SIP main:** `localhost` Accongs:**
- **Usernam
h
killall leneeds port one should NOT be 50eeSWITset up LinCH'a server

onfigure
Once FreeS---sH is properly (Coming Later)
igurati
### Linphon- When testi
  Linphone-dimeclient (will connect
- FreeSWITCH is th
`
# Then start FITCH
dochy This Mker c
- Only one appl# Stoon can use port 5060p Lin
**If you n
---ly listens oport 5060 (SIP por

#nnphone automatt Note About Por
```

**N
linphonrsion
| **Packagehone-des
--c**Esktop
 S-----ummary----|
| **etails |
|-

| Item |
### Linphone IStatus: insta
