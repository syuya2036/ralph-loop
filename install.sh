#!/bin/bash
set -e

# Repository configuration
REPO_OWNER="syuya2036"
REPO_NAME="ralph-loop"
BRANCH="main"
TARGET_DIR="scripts/ralph"

echo "🚀 Installing Ralph Loop..."

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "📥 Downloading from GitHub..."
# Download the archive
curl -sL "https://github.com/$REPO_OWNER/$REPO_NAME/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TEMP_DIR"

# Find the scripts directory in the extracted archive (handles variable root folder name)
EXTRACTED_ROOT=$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)

if [ ! -d "$EXTRACTED_ROOT/scripts/ralph" ]; then
  echo "❌ Error: Could not find scripts/ralph in the repository archive."
  exit 1
fi

# Ensure target parent directory exists
mkdir -p "$(dirname "$TARGET_DIR")"

# Remove existing target if it exists to clean update, or create it
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Directory $TARGET_DIR already exists. Updating..."
    # We maintain prd.json and progress.txt if they exist to not lose data
    if [ -f "$TARGET_DIR/prd.json" ]; then
        cp "$TARGET_DIR/prd.json" "$TEMP_DIR/prd.json.bak"
    fi
    if [ -f "$TARGET_DIR/progress.txt" ]; then
        cp "$TARGET_DIR/progress.txt" "$TEMP_DIR/progress.txt.bak"
    fi

    rm -rf "$TARGET_DIR"
fi

# Move the directory to the workspace
mv "$EXTRACTED_ROOT/scripts/ralph" "$TARGET_DIR"

# Restore user data if it was backed up
if [ -f "$TEMP_DIR/prd.json.bak" ]; then
    echo "♻️  Restoring existing prd.json..."
    mv "$TEMP_DIR/prd.json.bak" "$TARGET_DIR/prd.json"
fi
if [ -f "$TEMP_DIR/progress.txt.bak" ]; then
    echo "♻️  Restoring existing progress.txt..."
    mv "$TEMP_DIR/progress.txt.bak" "$TARGET_DIR/progress.txt"
fi

# Make scripts executable
chmod +x "$TARGET_DIR/ralph.sh"

echo "✅ Ralph Loop installed to ./$TARGET_DIR"
echo " "
echo "To start Ralph, run:"
echo "  ./$TARGET_DIR/ralph.sh \"<your-agent-command>\""
