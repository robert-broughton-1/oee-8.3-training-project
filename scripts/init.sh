#!/bin/bash

# Repository initialization script
# This script is idempotent - safe to run multiple times

set -e

echo "Initializing repository..."

# Get the script directory and repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Create secrets directory if it doesn't exist
SECRETS_DIR="$REPO_ROOT/secrets"
if [ ! -d "$SECRETS_DIR" ]; then
    echo "Creating secrets directory..."
    mkdir -p "$SECRETS_DIR"
else
    echo "Secrets directory already exists"
fi

# Create GATEWAY_ADMIN_PASSWORD file if it doesn't exist
PASSWORD_FILE="$SECRETS_DIR/GATEWAY_ADMIN_PASSWORD"
if [ ! -f "$PASSWORD_FILE" ]; then
    echo "Creating GATEWAY_ADMIN_PASSWORD file..."
    echo "password" > "$PASSWORD_FILE"
    echo "Created $PASSWORD_FILE with temporary password"
else
    echo "GATEWAY_ADMIN_PASSWORD file already exists"
fi

# Initialize and update git submodules
echo "Initializing git submodules..."
cd "$REPO_ROOT"

# Check if submodules are already initialized
if git submodule status | grep -q "^-"; then
    echo "Submodules not initialized, initializing now..."
    git submodule update --init --recursive
else
    echo "Submodules already initialized, updating..."
    git submodule update --recursive
fi

echo "Repository initialization complete!"
echo ""
echo "Summary:"
echo "- Secrets directory: $SECRETS_DIR"
echo "- Gateway admin password: $PASSWORD_FILE"
echo "- Submodules initialized and updated"
echo ""
echo "Note: Remember to change the default password in $PASSWORD_FILE for production use!"