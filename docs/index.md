# 🚀 Module: Securing AI using OpenShift sandboxed containers

**Technology Stack:**
  
- Red Hat OpenShift Sandboxed containers (Kata Containers)
- Claude AI coding agent
- Python

---

## 🎯 **Scenario**

This project contains an interactive chat client for the Claude AI coding agent running on the cluster.  Using Red Hat OpenShift sandboxed containers, based on the [Kata Containers](https://katacontainers.io/) open source project, we will show how to build a container runtime using lightweight virtual machines (VMs) to run a workload in its own isolated kernel.

## 🐾 **Workshop phases**

### Phase 1 — Security demos (choose one)

See what happens when AI executes malicious code, and how Kata sandboxing limits the blast radius:

- **[Devastator Attack Demo](phase-1-devastator.md)** — Multi-stage attack simulation (credential theft, ransomware, backdoor)
- **[CVE Exploit Demo](phase-1-cve-demo.md)** — Vulnerable dependency attack (PyYAML CVE-2020-14343)

Run from **Terminal → Run Task** → choose the demo.

### Phase 2 — Agent workflow

**[Try the AI coding agent](phase-2-agent-workflow.md)** — Clone repos, read code, make changes, commit, and push using natural language.

### Phase 3 — Integration

**[Build your own AI integration](phase-3-ai-integration.md)** — Use the gateway service to add AI capabilities to your own applications.

---

## 🐾 **Quick start**

```bash
pip install rich
python3.11 client.py chat
```

### Commands

| Command | Description |
|---|---|
| `python3.11 client.py chat` | Start interactive chat (auto-registers from workspace) |
| `python3.11 client.py chat <name>` | Start chat with explicit username |
| `python3.11 client.py register <name>` | Register and get a token only |
| `python3.11 client.py run "<prompt>"` | Send a single prompt and exit |
| `python3.11 client.py reset` | Clear conversation history |

### In-chat commands

| Type | Action |
|---|---|
| Your prompt + Enter twice | Submit |
| `/reset` | Clear conversation history and start fresh |
| `/quit` | Exit the chat |

### Environment variables

| Variable | Default | Description |
|---|---|---|
| `CLAUDE_GATEWAY_URL` | `http://claude-gateway.claude-sandbox.svc:8080` | Gateway endpoint |

### Example prompts

```
What does the orders service do?

Add a /health endpoint to the gateway service and commit it

Run the demo.sh script and tell me what it does

Push my changes and open a draft MR
```

### Troubleshooting

**No colors:** Run with `python3.11` not `python`. Install rich: `pip install rich`

**Token expired:** Run `python3.11 client.py register <your-name>`

**Clone failed:** You must fork `workshop-python-microservices` into your GitLab namespace first:
1. Open GitLab and navigate to **workshop / workshop-python-microservices**
2. Click **Fork**
3. Then tell the agent: `Clone my GitLab repo workshop-python-microservices`

**Connection refused:** The gateway URL may need to change — check `CLAUDE_GATEWAY_URL`
