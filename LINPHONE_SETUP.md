# Linphone Setup Guide

> Configure Linphone SIP client to connect to your FreeSWITCH server

## Overview

Linphone is a free, open-source SIP softphone that you'll use to test your AI Voice IVR system. This guide will walk you through installing and configuring Linphone to connect to your FreeSWITCH server.

---

## Installation

### Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install -y linphone-desktop
```

### Verify Installation

```bash
which linphone
# Output: /usr/bin/linphone

linphone-desktop --version
# Output: linphone-desktop 5.0.2 or similar
```

---

## Configuration Steps

### Step 1: Ensure FreeSWITCH is Running

Before configuring Linphone, make sure FreeSWITCH is running:

```bash
# Check if FreeSWITCH container is running
docker ps | grep freeswitch

# If not running, start it
docker compose up -d

# Check FreeSWITCH status
docker exec -it freeswitch fs_cli -x "sofia status"
```

You should see the internal profile running on port 5060.

---

### Step 2: Get Your Local IP Address

FreeSWITCH is configured to use your local IP. Find it with:

```bash
hostname -I | awk '{print $1}'
```

Or:

```bash
ip addr show | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 | head -1
```

Example output: `192.168.1.100`

---

### Step 3: Launch Linphone

**Option 1: From Applications Menu**
1. Press Super/Windows key
2. Type "linphone"
3. Click the Linphone icon

**Option 2: From Terminal**
```bash
linphone-desktop &
```

---

### Step 4: Configure SIP Account

#### Method 1: Using the Setup Assistant (First Launch)

When you first launch Linphone, it will show a setup wizard:

1. **Welcome Screen**
   - Click "Use SIP Account"

2. **Account Configuration**
   - **Username:** `1000`
   - **SIP Domain:** `10.97.2.47` (your current local IP)
   - **Password:** `1234`
   - **Display Name:** `Test User 1000` (optional)
   - **Transport:** `UDP`
   
3. Click "Use" or "Login"

#### Method 2: Manual Configuration (Main SIP Account Settings)

If you need to configure manually or add additional accounts:

1. **Open Linphone Settings**
   - Click the **hamburger menu** (☰) in the top-left
   - Select **Settings** or **Preferences**
   - Go to **SIP Accounts** tab
   - Click **Add** or **+** to create new account

2. **Main SIP Account Configuration**

   Fill in these exact values:

   **Basic Settings:**
   ```
   SIP Address (Identity): sip:1000@10.97.2.47
   Server Address: 10.97.2.47
   Transport: UDP
   Username: 1000
   Password: 1234
   Display Name: Test User 1000
   ```

   **Detailed Field Mapping:**

   | Linphone Field | Value | Explanation |
   |----------------|-------|-------------|
   | **SIP Address** | `sip:1000@10.97.2.47` | Your full SIP identity |
   | **Server Address** | `10.97.2.47` | FreeSWITCH server IP |
   | **Server Port** | `5060` | SIP port (usually auto-filled) |
   | **Transport** | `UDP` | Protocol type |
   | **Username** | `1000` | SIP extension number |
   | **User ID** | `1000` | Authentication username |
   | **Password** | `1234` | Authentication password |
   | **Display Name** | `Test User 1000` | Caller ID name |
   | **Domain** | `10.97.2.47` | SIP domain |

   **Advanced Settings (Leave Default):**
   ```
   Outbound Proxy: (empty)
   Route: (empty)
   Expire: 3600
   Enable AVPF: No
   Enable ICE: No
   Enable STUN: No
   ```

3. **Save Configuration**
   - Click **Add** or **Save**
   - The account should appear in your accounts list

#### Method 3: Quick Configuration Format

If Linphone asks for a single SIP address, use this format:
```
sip:1000:1234@10.97.2.47
```

This includes username:password@server in one line.

---

### Step 5: Verify Registration

#### In Linphone

Look at the top of the Linphone window:
- **Green dot** or **"Connected"** = Successfully registered ✅
- **Red dot** or **"Not registered"** = Connection failed ❌

#### In FreeSWITCH

Check if the registration succeeded:

```bash
docker exec -it freeswitch fs_cli -x "sofia status profile internal reg"
```

You should see something like:

```
Registrations:
=================================================================================================
Call-ID:        abc123...
User:           1000@192.168.1.100
Contact:        "Test User" <sip:1000@192.168.1.100:5060>
Agent:          Linphone/5.0.2
Status:         Registered(UDP)(unknown) EXP(2024-12-16 10:30:00)
Host:           freeswitch
IP:             192.168.1.100
Port:           5060
Auth-User:      1000
Auth-Realm:     192.168.1.100
=================================================================================================
Total items returned: 1
```

---

## Available Test Extensions

Your FreeSWITCH has multiple users configured. You can register additional Linphone instances (or other softphones) with these accounts:

| Extension | Password | Purpose | SIP Address |
|-----------|----------|---------|-------------|
| **1000** | `1234` | Primary test user | `sip:1000@10.97.2.47` |
| **1001** | `1234` | Secondary test user | `sip:1001@10.97.2.47` |
| **1002** | `1234` | Additional user | `sip:1002@10.97.2.47` |
| **1003** | `1234` | Additional user | `sip:1003@10.97.2.47` |
| **1004** | `1234` | Additional user | `sip:1004@10.97.2.47` |

**Note:** All users use the same password `1234` as defined in `vars.xml`

---

## Testing Your Setup

### Step 1: Verify Registration Status

**In Linphone:**
- Look for a **green dot** or **"Registered"** status
- The account should show as "Connected"

**In FreeSWITCH:**
```bash
docker exec -it freeswitch fs_cli -x "sofia status profile internal reg"
```

### Step 2: Make a Test Call

Try calling these test extensions:

| Extension | What It Does |
|-----------|--------------|
| **9664** | Music on Hold test |
| **9196** | Echo test (speaks back what you say) |
| **5000** | Demo IVR menu |
| **1001** | Call another extension (if registered) |

**To make a call:**
1. In Linphone, click the **dial pad** or **call** button
2. Enter the extension number (e.g., `9664`)
3. Press **Call** or hit Enter
4. You should hear audio

---

## Troubleshooting

### Problem: "Registration Failed" or Red Status

**Check 1: FreeSWITCH is Running**
```bash
docker ps | grep freeswitch
# Should show a running container
```

**Check 2: Correct IP Address**
```bash
hostname -I | awk '{print $1}'
# Use this IP in your Linphone config
```

**Check 3: Port 5060 is Available**
```bash
sudo netstat -tuln | grep 5060
# Should show FreeSWITCH listening on port 5060
```

**Check 4: Firewall Issues**
```bash
# If using UFW firewall
sudo ufw allow 5060/udp
sudo ufw allow 5060/tcp
```

### Problem: "Authentication Failed"

- Double-check username: `1000`
- Double-check password: `1234`
- Make sure SIP address is: `sip:1000@10.97.2.47`

### Problem: Can Register but No Audio

**Check RTP Ports:**
```bash
sudo netstat -tuln | grep -E "1638[4-9]|163[9][0-4]"
# Should show RTP ports 16384-16394 open
```

**Check FreeSWITCH Logs:**
```bash
docker logs freeswitch | tail -20
```

### Problem: "Network Unreachable"

- Make sure you're using the correct local IP: `10.97.2.47`
- Try using `localhost` if running on the same machine
- Check if Docker networking is working properly

---

## Next Steps

Once Linphone is successfully registered:

1. **Test Basic Calling**
   - Call extension `9664` for music on hold
   - Call extension `9196` for echo test

2. **Set Up Second Account**
   - Register extension `1001` in another Linphone instance
   - Test calling between `1000` and `1001`

3. **Prepare for AI Integration**
   - Your setup is ready for the Bot Orchestrator
   - The AI IVR will answer calls to specific extensions
| 1000 | 1234 | Primary test user |
| 1001 | 1234 | Secondary test user |
| 1002-1019 | 1234 | Additional test users |

---

## Making Test Calls

### Call Another Extension

If you have two Linphone instances registered (e.g., 1000 and 1001):

1. In Linphone registered as 1000
2. Type `1001` in the dial pad
3. Click the green call button
4. The other Linphone (1001) should ring

### Call the AI IVR (When Implemented)

Once your AI IVR is set up:

1. Dial `9196` (or the extension configured in your dialplan)
2. You should hear the AI greeting
3. Speak naturally to interact with the AI

---

## Troubleshooting

### Issue: "Registration Failed" or Red Dot

**Possible Causes:**

1. **FreeSWITCH not running**
   ```bash
   docker compose up -d
   ```

2. **Wrong IP address**
   - Make sure you're using the correct local IP
   - Try `localhost` if running on the same machine
   - Check with: `hostname -I`

3. **Port 5060 blocked or in use**
   ```bash
   # Check if port 5060 is listening
   sudo ss -tulpn | grep 5060
   
   # Should show FreeSWITCH listening on port 5060
   ```

4. **Wrong password**
   - Default password is `1234` (from vars.xml)
   - Check vars.xml: `grep default_password freeswitch/conf/vars.xml`

5. **Firewall blocking**
   ```bash
   # Allow port 5060 (if firewall is active)
   sudo ufw allow 5060/udp
   sudo ufw allow 5060/tcp
   ```

---

### Issue: Can Register but No Audio

**Possible Causes:**

1. **RTP ports blocked**
   ```bash
   # FreeSWITCH uses ports 16384-16484 for audio (RTP)
   sudo ufw allow 16384:16484/udp
   ```

2. **NAT/Firewall issues**
   - For local testing, this shouldn't be an issue
   - Make sure both FreeSWITCH and Linphone are on the same network

3. **Codec mismatch**
   - Check available codecs in Linphone settings
   - FreeSWITCH supports: OPUS, G722, PCMU, PCMA
   - Enable at least PCMU (G.711 μ-law) and PCMA (G.711 A-law)

---

### Issue: "407 Proxy Authentication Required"

This means FreeSWITCH received your registration but the password is wrong.

**Solution:**
1. Double-check the password is `1234`
2. Make sure username is exactly `1000` (no spaces)
3. Restart Linphone and try again

---

### Issue: Linphone Won't Start

**Solution:**
```bash
# Kill any existing Linphone processes
killall linphone-desktop

# Clear Linphone config (if corrupted)
rm -rf ~/.local/share/linphone
rm -rf ~/.config/linphone

# Start fresh
linphone-desktop &
```

---

## Linphone Settings Recommendations

### Audio Settings

1. Go to **Settings** → **Audio**
2. **Playback Device:** Select your speakers/headphones
3. **Capture Device:** Select your microphone
4. **Ring Device:** Select where you want to hear ringing
5. **Echo Cancellation:** Enable (recommended)
6. **Adaptive Rate Control:** Enable

### Codec Settings

1. Go to **Settings** → **Codecs**
2. Enable these codecs (in order of preference):
   - ✅ **OPUS** (best quality, low bandwidth)
   - ✅ **G722** (wideband, good quality)
   - ✅ **PCMU** (G.711 μ-law, standard)
   - ✅ **PCMA** (G.711 A-law, standard)
3. Disable video codecs if not needed

### Network Settings

1. Go to **Settings** → **Network**
2. **NAT Traversal:** 
   - For local testing: Disable or set to "None"
   - For remote testing: Enable STUN
3. **Media Encryption:** None (for testing)
4. **IPv6:** Disable (unless you need it)

---

## Quick Reference

### SIP Account Details

```
Username:     1000
Password:     1234
Domain:       <your-local-ip> or localhost
SIP Server:   <your-local-ip>:5060
Transport:    UDP
```

### Useful Commands

```bash
# Check FreeSWITCH status
docker exec -it freeswitch fs_cli -x "sofia status"

# View registrations
docker exec -it freeswitch fs_cli -x "sofia status profile internal reg"

# View active calls
docker exec -it freeswitch fs_cli -x "show calls"

# View channels
docker exec -it freeswitch fs_cli -x "show channels"

# Restart FreeSWITCH
docker compose restart freeswitch

# View FreeSWITCH logs
docker logs -f freeswitch
```

---

## Multiple Linphone Instances

To test call scenarios, you can run multiple Linphone instances:

### Method 1: Different User Profiles

```bash
# First instance (user 1000)
linphone-desktop --config ~/.config/linphone-1000 &

# Second instance (user 1001)
linphone-desktop --config ~/.config/linphone-1001 &
```

Configure each with different extensions (1000, 1001, etc.)

### Method 2: Use Different Machines

- Install Linphone on multiple computers
- Register each with a different extension
- All should use the same FreeSWITCH server IP

---

## Next Steps

Once Linphone is successfully registered:

1. ✅ Test calling between extensions (1000 → 1001)
2. ✅ Verify audio quality
3. ✅ Check FreeSWITCH logs for any issues
4. ✅ Proceed with AI IVR development
5. ✅ Configure dialplan to route calls to your bot

---

## Additional Resources

- **Linphone Documentation:** https://www.linphone.org/documentation
- **FreeSWITCH Sofia SIP:** https://freeswitch.org/confluence/display/FREESWITCH/Sofia+SIP+Stack
- **SIP Protocol:** https://en.wikipedia.org/wiki/Session_Initiation_Protocol

---

## Summary

You now have Linphone configured to connect to your FreeSWITCH server. You can:

- Register as extension 1000 (or any 1000-1019)
- Make calls to other extensions
- Test audio quality
- Prepare for AI IVR integration

**Default Credentials:**
- Username: `1000`
- Password: `1234`
- Server: Your local IP or `localhost`
- Port: `5060`

Happy testing! 🎉
