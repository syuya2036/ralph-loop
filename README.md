# Ralph Loop: Universal AI Coding Agent Loop

[日本語README](./README.ja.md)

This repository implements the "Ralph" autonomous coding loop pattern, designed to be agnostic of the specific AI agent being used. Whether you use Claude, Codex, Gemini, or local models via Ollama/Qwen, Ralph Loop orchestrates the process.

> **What is Ralph?**
> Ralph is a bash loop that:
> 1. Pipes a context prompt and task list (`prd.json`) into your AI agent.
> 2. The agent picks a story, implements it, runs tests, commits, and updates its progress.
> 3. The loop repeats until all stories are marked complete.

## 🚀 Setup

The core machinery is located in ``.

1. **Define your backlog**: Edit `prd.json` with your user stories.
2. **Configure your environment**: Ensure your project has test commands (e.g., `npm test`, `cargo test`) ready for the agent to use.
3. **Make executable**: `chmod +x ./ralph-loop/ralph.sh`

## 🏃 Usage

Run the `./ralph-loop/ralph.sh` script and pass your agent's CLI command as the first argument. You can optionally specify the maximum number of iterations as the second argument (default is 10). The script assumes your agent accepts the prompt via **Standard Input (stdin)**.

```bash
./ralph-loop/ralph.sh "<YOUR_AGENT_COMMAND>" [MAX_ITERATIONS]
```

### Examples

#### Claude Code (Anthropic)
```bash
# Run up to 20 iterations
./ralph-loop/ralph.sh "claude --dangerously-skip-permissions" 20
```

#### Codex CLI
OpenAI's autonomous agent CLI.
```bash
# --full-auto bypasses confirmation prompts (required for headless loop)
./ralph-loop/ralph.sh "codex exec --full-auto" 20
```

#### Gemini CLI
Google's GenAI agent CLI.
```bash
# --yolo enables autonomous action execution
./ralph-loop/ralph.sh "gemini --yolo" 20
```

#### Qwen Code
Alibaba's Qwen agent CLI.
*Requires configuring "YOLO Mode" for autonomous execution.*
```bash
# 1. Update .qwen/settings.json to allow fully autonomous mode:
#    { "permissions": { "defaultMode": "yolo" } }
# 2. Run Ralph (assuming qwen accepts stdin)
./ralph-loop/ralph.sh "qwen" 20
```

## 📁 File Structure

- `ralph-loop/ralph.sh`: The main loop script.
- `prd.json`: Your product requirements/backlog.
- `progress.txt`: Persistent memory and learnings log.
- `prompt.md`: The system prompt fed to the agent on every iteration.

## 🧠 Memory & Context

Ralph persists memory through:
1. **Git History**: Commits made by the agent.
2. **`progress.txt`**: A log of what was done and "learnings" (patterns/gotchas) discovered.
3. **`prd.json`**: Tracking which stories are passed/failed.

## customizing for specific agents

If your agent requires the prompt as an argument instead of stdin, you can modify `ralph-loop/ralph.sh` or create a small wrapper script.

**Wrapper Example (agent-wrapper.sh):**
```bash
#!/bin/bash
# Read stdin to a variable
PROMPT=$(cat)
# explicit-agent --prompt "$PROMPT"
```
Then run: `./ralph-loop/ralph.sh "./agent-wrapper.sh"`
