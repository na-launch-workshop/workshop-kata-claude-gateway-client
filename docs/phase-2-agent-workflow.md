# Phase 2 — Working with the AI Agent

In this phase you use the Claude AI agent to explore, modify, and commit changes to code — all from the Dev Spaces terminal, without leaving your workspace.

## Before you start

**IMPORTANT:** Use the **same username** for OpenShift and GitLab. If you logged into OpenShift as `user9`, log into GitLab as `user9` too (same password for both).

**Fork this repo:**

1. Open GitLab: https://gitlab-gitlab.apps.cluster-<guid>.dyn.redhatworkshops.io
2. Navigate to **workshop / workshop-kata-claude-gateway-client**
3. Click **Fork** and fork it into your own namespace (e.g., `user9`)

## Start the agent

Click **Terminal** → **Run Task** → **2. Start Claude AI**.

> Or from the terminal: `python3.11 client.py chat`

The agent will register you automatically and drop you into an interactive prompt.

## Complete AI workflow

Follow these commands in order to see the full workflow:

### 1. Clone your fork
```
Clone the GitLab repo <your-username>/workshop-kata-claude-gateway-client
```

The agent will clone your fork into its sandbox and create a session branch.

### 2. Explore the code
```
What does client.py do?
```

### 3. Make a change
```
Add a docstring to the run() function explaining what it does
```

### 4. Review the change
```
Show me the diff of what you changed
```

### 5. Commit the change
```
Commit this change with the message "Add documentation to run function"
```

### 6. Push to a new branch
```
Push my changes to a new branch called add-docs
```

### 7. Create a merge request
```
Create a merge request for this branch
```

Claude will give you the MR URL. Open it in GitLab to review the diff and merge it.

## The workflow

```
You (chat prompt)
      ↓
Claude agent (Kata sandbox)
  → reads your code
  → makes changes
  → runs tests
  → git commit
  → git push → session branch (ai/<you>/<timestamp>)
      ↓
GitLab MR (you review the diff)
      ↓
Dev Spaces (git fetch + checkout to test locally)
```

The agent always works on its own branch — it never touches `main`. You review the MR before anything merges.

## Tips

- Be specific about what you want changed and why
- Ask the agent to run the code and show you the output before committing
- If something goes wrong, ask it to explain what it tried and why it failed
- Type `/reset` to clear the conversation and start fresh
- Press Enter twice to submit a multi-line prompt
