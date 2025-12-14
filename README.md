# AI Voice IVR Platform

> Production-ready AI-powered Interactive Voice Response (IVR) system with natural language conversation capabilities

[![Go Version](https://img.shields.io/badge/Go-1.22+-00ADD8?style=flat&logo=go)](https://go.dev/)
[![Docker](https://img.shields.io/badge/Docker-Required-2496ED?style=flat&logo=docker)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 Overview

An end-to-end AI Voice IVR system that enables natural language conversations over telephone calls. The system leverages modern AI technologies including Automatic Speech Recognition (ASR), Large Language Models (LLMs), and Text-to-Speech (TTS) to create seamless conversational experiences.

### Key Features

- 🎙️ **Natural Language Understanding** - Speak naturally, no rigid menu trees
- 🤖 **AI-Powered Responses** - Intelligent conversation using LLMs
- 🔊 **Human-like Voice** - Natural-sounding speech synthesis
- 📞 **SIP/VoIP Integration** - Standard telephony protocols
- ⚡ **Real-time Processing** - Low-latency audio streaming
- 🔌 **Backend Integration** - Connect to existing business systems

### Use Cases

- **Banking:** Balance inquiries, transaction history, card blocking
- **Healthcare:** Appointment scheduling, prescription refills, lab results
- **Telecommunications:** Bill payments, plan changes, service requests
- **E-commerce:** Order tracking, returns, product information

## 🏗️ Architecture

```
┌──────────────┐
│  Softphone   │ ◄──── SIP/RTP ────► ┌──────────────┐
│  (MicroSIP)  │                      │ FreeSWITCH   │
└──────────────┘                      │  PBX Server  │
                                      └──────┬───────┘
                                             │
                                      ESL + WebSocket
                                             │
                                      ┌──────▼───────┐
                                      │     Bot      │
                                      │ Orchestrator │
                                      │     (Go)     │
                                      └──────┬───────┘
                                             │
                    ┌────────────────────────┼────────────────────────┐
                    │                        │                        │
             ┌──────▼──────┐         ┌──────▼──────┐         ┌──────▼──────┐
             │   Whisper   │         │   Ollama    │         │    Piper    │
             │     ASR     │         │     LLM     │         │     TTS     │
             │(Speech→Text)│         │  (Llama3)   │         │(Text→Speech)│
             └─────────────┘         └─────────────┘         └─────────────┘
                                             │
                                      ┌──────▼───────┐
                                      │ Integration  │
                                      │   Service    │
                                      │     (Go)     │
                                      └──────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Linux (Ubuntu 20.04+ or Debian 11+)
- 8GB RAM minimum
- 20GB free disk space
- Internet connection

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/ai-voice-ivr.git
cd ai-voice-ivr
```

2. **Install dependencies**
```bash
# Follow the detailed setup guide
cat SETUP_REQUIREMENTS.md
```

3. **Start all services**
```bash
docker compose up -d
```

4. **Verify services are running**
```bash
docker compose ps
```

5. **Configure your softphone**
- SIP Server: `localhost:5060`
- Username: `1000`
- Password: `1234`

6. **Make a test call**
- Dial extension `9196` to reach the AI IVR

## 📁 Project Structure

```
ai-voice-ivr/
├── docker-compose.yml          # Service orchestration
├── .env                        # Environment variables
├── Makefile                    # Build automation
├── README.md                   # This file
├── SETUP_REQUIREMENTS.md       # Detailed setup guide
│
├── freeswitch/                 # FreeSWITCH configuration
│   └── conf/
│       ├── vars.xml
│       ├── sip_profiles/
│       ├── directory/
│       └── dialplan/
│
├── bot-orchestrator/           # Main Go service
│   ├── cmd/
│   │   └── server/
│   │       └── main.go
│   ├── internal/
│   │   ├── config/            # Configuration management
│   │   ├── esl/               # FreeSWITCH ESL client
│   │   ├── session/           # Call session management
│   │   ├── audio/             # Audio processing & VAD
│   │   ├── asr/               # Whisper ASR client
│   │   ├── llm/               # Ollama LLM client
│   │   ├── tts/               # Piper TTS client
│   │   └── dialog/            # Dialog engine
│   ├── go.mod
│   ├── go.sum
│   ├── Dockerfile
│   └── README.md
│
└── integration-service/        # Backend API service
    ├── cmd/
    │   └── server/
    │       └── main.go
    ├── internal/
    │   ├── config/
    │   ├── store/             # In-memory data store
    │   ├── domain/            # Business logic
    │   └── server/            # HTTP handlers
    ├── go.mod
    ├── go.sum
    ├── Dockerfile
    └── README.md
```

## 🛠️ Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Telephony** | FreeSWITCH | PBX, SIP/RTP handling |
| **Orchestration** | Go 1.22+ | Bot logic, service coordination |
| **ASR** | OpenAI Whisper | Speech-to-text |
| **LLM** | Ollama + Llama3 | Intent classification, responses |
| **TTS** | Piper | Text-to-speech synthesis |
| **Backend** | Go | Integration APIs |
| **Containerization** | Docker Compose | Service deployment |

### Go Libraries

- `gorilla/websocket` - WebSocket client/server
- `rs/zerolog` - Structured logging
- `go-audio/wav` - WAV file handling
- `stretchr/testify` - Testing assertions

## 🔌 API Endpoints

### Bot Orchestrator (Port 8090)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/calls/start` | POST | Call initiated notification |
| `/calls/{uuid}/next-action` | GET | Get next action for call |
| `/calls/{uuid}/end` | POST | Call ended notification |
| `/tts/generate` | GET | Generate TTS audio |

### Integration Service (Port 8080)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/api/customers/{id}` | GET | Get customer details |
| `/api/accounts/{id}/balance` | GET | Get account balance |
| `/api/tickets` | POST | Create support ticket |

### WebSocket

| Endpoint | Description |
|----------|-------------|
| `ws://localhost:8091/audio/{uuid}` | Audio stream from FreeSWITCH |

## 📞 Sample Conversation

```
[Call connects]

BOT: Welcome to AI Banking Assistant. How may I help you today?

USER: What is my account balance?

BOT: Let me check your account balance.
     Your current balance is 25,000 rupees. Your last transaction was
     a debit of 1,200 rupees for an online purchase yesterday.

USER: Can you create a support ticket for me?

BOT: Of course. What issue would you like to report?

USER: I was charged twice for a transaction.

BOT: I understand you were charged twice for a transaction. I've created
     ticket number TKT-2025-001234 for this issue. Our team will contact
     you within 24 hours. Is there anything else I can help with?

USER: No, thank you.

BOT: Thank you for calling AI Banking Assistant. Have a great day!

[Call ends]
```

## 🧪 Testing

### Run Unit Tests
```bash
cd bot-orchestrator
go test ./... -v -cover
```

### Run Integration Tests
```bash
go test ./... -tags=integration -v
```

### Generate Coverage Report
```bash
go test ./... -coverprofile=coverage.out
go tool cover -html=coverage.out
```

### Test Call Flow
1. Register softphone with extension 1000
2. Dial 9196
3. Speak naturally with the AI agent
4. Verify responses are appropriate

## 📊 Service Ports

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

## 🐛 Troubleshooting

### Softphone won't register
```bash
# Check FreeSWITCH logs
docker compose logs freeswitch

# Verify SIP profile is running
docker compose exec freeswitch fs_cli -x "sofia status"
```

### No audio in calls
```bash
# Check RTP ports are open
sudo netstat -tuln | grep -E '16384|16484'

# Verify codec configuration
docker compose exec freeswitch fs_cli -x "show codec"
```

### Whisper is slow
- Use smaller model (base or small instead of large)
- Ensure GPU support if available
- Check container resource limits

### LLM timeout
```bash
# Pre-load the model
docker compose exec ollama ollama pull llama3

# Increase timeout in bot-orchestrator config
```

## 📚 Documentation

- [Setup Requirements](SETUP_REQUIREMENTS.md) - Detailed installation guide
- [Bot Orchestrator](bot-orchestrator/README.md) - Service documentation
- [Integration Service](integration-service/README.md) - API documentation
- [FreeSWITCH Configuration](freeswitch/README.md) - Telephony setup

## 🎯 Development Roadmap

### Phase 1: Foundation ✅
- [x] Environment setup
- [x] Docker Compose configuration
- [x] FreeSWITCH basic setup

### Phase 2: Telephony ✅
- [x] SIP registration
- [x] Call handling
- [x] Audio bridging

### Phase 3: Bot Core 🚧
- [ ] ESL client
- [ ] Session management
- [ ] WebSocket server

### Phase 4: Audio Pipeline 🚧
- [ ] Audio streaming
- [ ] VAD implementation
- [ ] Whisper integration

### Phase 5: AI Integration 📋
- [ ] Ollama LLM client
- [ ] Dialog engine
- [ ] Piper TTS integration

### Phase 6: Backend 📋
- [ ] Integration service
- [ ] Mock data APIs
- [ ] End-to-end testing

### Development Guidelines

1. Follow Go best practices and idioms
2. Write unit tests for all new code (>70% coverage)
3. Use structured logging (zerolog)
4. Document all public APIs
5. Keep functions small and focused

### Code Style

```bash
# Format code
go fmt ./...

# Run linter
golangci-lint run

# Run tests
go test ./... -v
```


## 🔗 Resources

- [Go Documentation](https://go.dev/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [FreeSWITCH Documentation](https://freeswitch.org/confluence/)
- [Whisper Documentation](https://github.com/openai/whisper)
- [Ollama Documentation](https://ollama.ai/)
- [Piper TTS Documentation](https://github.com/rhasspy/piper)

---
