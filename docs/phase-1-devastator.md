# Phase 1 — Devastator Attack Demo

See what happens when AI executes untrusted code, and how OpenShift sandboxed containers limit the blast radius.

---

## What you'll see

Devastator is a fake Python package that looks like a utilities library but actually runs a multi-stage attack when installed. You'll ask the Claude agent to install it, then watch what happens inside the Kata sandbox.

---

## Run the demo

Click **Terminal** → **Run Task** → **Run Devastator Attack Demo**.

> Or from the terminal: `python3.11 client.py run "Run this bash command: git clone https://github.com/pkredhat/devastator /tmp/devastator && pip install /tmp/devastator/"`

The agent will execute the command in its Kata sandbox. Watch the output.

---

## What happens

| Stage | Attack | Sandbox result |
|---|---|---|
| 1 | Tries to steal credentials from environment variables | Subprocess env is stripped — not found ✅ |
| 1b | Scans `/proc` for credentials in other processes | **Finds real API keys from the gateway** ⚠️ |
| 2 | Encrypts all files (ransomware simulation) | Only affects this sandbox session ✅ |
| 3 | Injects backdoor code into `.py` files | Sandbox only — no real impact ✅ |
| 4 | Tries to install cron backdoor + SSH key | Blocked — read-only filesystem ✅ |
| 5 | Tries to exfiltrate data to attacker server | Blocked — network policy ✅ |

---

## Why this matters

**Without the Kata sandbox:**
- ❌ Credentials stolen and exfiltrated
- ❌ All your files encrypted
- ❌ Backdoor installed on your system
- ❌ Persistent access for the attacker
- ❌ Other users on the same machine affected

**With Kata + NetworkPolicy:**
- ⚠️ API keys visible in `/proc` (partial)
- ✅ Only sandbox files encrypted (contained)
- ✅ Crontab install blocked
- ✅ Data exfiltration blocked
- ✅ Other users completely unaffected
- ✅ Sandbox can be destroyed and rebuilt instantly

The Kata sandbox isolates the AI agent in its own lightweight VM with its own kernel. Even when the agent executes malicious code, it can't escape to affect the real system or other users.

---

## Discussion points

1. **Stage 1b is the realistic threat** — even with env stripping, `/proc` scanning finds credentials. Without network egress blocking, those keys would be stolen.

2. **Blast radius** — the encryption and backdoor only affect this one sandbox session. Your real files are untouched. Other participants are completely isolated.

3. **Defense in depth** — Kata provides the isolation boundary, NetworkPolicy blocks exfiltration, and the read-only filesystem stops persistence.

---

## Source code

Devastator is open source (for educational purposes): https://github.com/pkredhat/devastator

You can read the attack code to see exactly what it tries to do.
