# Ralph Loop: Universal AI Coding Agent Loop

This repository implements the "Ralph" autonomous coding loop pattern, designed to be agnostic of the specific AI agent being used. Whether you use Claude, Codex, Gemini, or local models via Ollama/Qwen, Ralph Loop orchestrates the process.

> **What is Ralph?**
> Ralph is a bash loop that:
> 1. Pipes a context prompt and task list (`prd.json`) into your AI agent.
> 2. The agent picks a story, implements it, runs tests, commits, and updates its progress.
> 3. The loop repeats until all stories are marked complete.

## 🚀 Setup

The core machinery is located in `scripts/ralph/`.

1. **Define your backlog**: Edit `scripts/ralph/prd.json` with your user stories.
2. **Configure your environment**: Ensure your project has test commands (e.g., `npm test`, `cargo test`) ready for the agent to use.
3. **Make executable**: `chmod +x scripts/ralph/ralph.sh`

## 🏃 Usage

Run the `ralph.sh` script and pass your agent's CLI command as the first argument. The script assumes your agent accepts the prompt via **Standard Input (stdin)**.

```bash
./scripts/ralph/ralph.sh "<YOUR_AGENT_COMMAND>"
```

### Examples

#### Claude Code (Anthropic)
```bash
./scripts/ralph/ralph.sh "claude --dangerously-skip-permissions"
```

#### Codex CLI
OpenAI's autonomous agent CLI.
```bash
# --full-auto bypasses confirmation prompts (required for headless loop)
./scripts/ralph/ralph.sh "codex exec --full-auto"
```

#### Gemini CLI
Google's GenAI agent CLI.
```bash
# --yolo enables autonomous action execution
./scripts/ralph/ralph.sh "gemini --yolo"
```

#### Qwen Code
Alibaba's Qwen agent CLI.
*Requires configuring "YOLO Mode" for autonomous execution.*
```bash
# 1. Update .qwen/settings.json to allow fully autonomous mode:
#    { "permissions": { "defaultMode": "yolo" } }
# 2. Run Ralph (assuming qwen accepts stdin)
./scripts/ralph/ralph.sh "qwen"
```

## 📁 File Structure

- `scripts/ralph/ralph.sh`: The main loop script.
- `scripts/ralph/prd.json`: Your product requirements/backlog.
- `scripts/ralph/progress.txt`: Persistent memory and learnings log.
- `scripts/ralph/prompt.md`: The system prompt fed to the agent on every iteration.

## 🧠 Memory & Context

Ralph persists memory through:
1. **Git History**: Commits made by the agent.
2. **`progress.txt`**: A log of what was done and "learnings" (patterns/gotchas) discovered.
3. **`prd.json`**: Tracking which stories are passed/failed.

## customizing for specific agents

If your agent requires the prompt as an argument instead of stdin, you can modify `scripts/ralph/ralph.sh` or create a small wrapper script.

**Wrapper Example (agent-wrapper.sh):**
```bash
#!/bin/bash
# Read stdin to a variable
PROMPT=$(cat)
# explicit-agent --prompt "$PROMPT"
```
Then run: `./scripts/ralph/ralph.sh "./agent-wrapper.sh"`
