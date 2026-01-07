#!/bin/bash
set -e

# Configuration
MAX_ITERATIONS=${MAX_ITERATIONS:-10}
AGENT_CMD="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")" # Assumption: scripts/ralph -> scripts -> root

if [ -z "$AGENT_CMD" ]; then
  echo "Usage: ./ralph.sh \"<agent command>\" [max_iterations]"
  echo "Example: ./ralph.sh \"claude --dangerously-skip-permissions\""
  echo "Example: ./ralph.sh \"openai-cli run\""
  echo "Environment variables:"
  echo "  MAX_ITERATIONS (default: 10)"
  exit 1
fi

if [ -n "$2" ]; then
  MAX_ITERATIONS=$2
fi

echo "🚀 Starting Ralph with agent: '$AGENT_CMD'"
echo "📂 Working directory: $(pwd)"
echo "🔄 Max iterations: $MAX_ITERATIONS"

for i in $(seq 1 $MAX_ITERATIONS); do
  echo "═══ Iteration $i/$MAX_ITERATIONS ═══"

  # Read the prompt
  PROMPT_CONTENT=$(cat "$SCRIPT_DIR/prompt.md")

  # Run the agent command, piping the prompt to it
  # We use eval to handle arguments in quotes correctly if simpler splitting fails,
  # but for safety against injection if AGENT_CMD is trusted, simply execution is better.
  # However, complex commands like 'claude -p "system instructions"' might need care.
  # For this simple tool, we assume AGENT_CMD is a straightforward executable string.

  # Note: Some agents might not accept stdin as the prompt automatically.
  # This script assumes the agent accepts the prompt via stdin or we might need to adjust.
  # For example, `claude` (Anthropic's cli) often takes prompt as arg or stdin.
  # We will try piping.

  echo "🤖 Agent running..."

  # Capture output to check for completion signal, but also tee to stderr to show progress
  OUTPUT=$(echo "$PROMPT_CONTENT" | $AGENT_CMD 2>&1 | tee /dev/stderr) || true

  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo "✅ Done! All stories completed."
    exit 0
  fi

  echo "⏳ Iteration $i finished. Sleeping for 2 seconds..."
  sleep 2
done

echo "⚠️ Max iterations reached without completion signal."
exit 1
