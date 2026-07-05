# Git + GPG Configuration Justfile
# Setup script for configuring Git with GPG signing on a new machine

set dotenv-load
set shell := ["bash", "-cu"]

# User configuration
GIT_NAME := "waldirborbajr"
GIT_EMAIL := "wborbajr@gmail.com"

# Default recipe - show help
default:
    @just --list

# Check if GPG is installed
@check-gpg:
    #!/usr/bin/env bash
    echo "Checking GPG installation..."
    if command -v gpg &> /dev/null; then
        echo "✓ GPG is installed"
        gpg --version | head -1
    else
        echo "✗ GPG not found. Install it first:"
        echo "  macOS:  brew install gnupg"
        echo "  Linux:  sudo apt install gnupg -y"
        echo "          sudo dnf install gnupg -y"
        echo "  Windows: download from https://gnupg.org"
        exit 1
    fi

# List all GPG keys
@list-keys:
    echo "Your GPG keys:"
    gpg --list-secret-keys --keyid-format=long || echo "No keys found"

# Generate a new GPG key
@generate-key:
    echo "Generating new GPG key..."
    echo "Follow the prompts to create your key (RSA 4096-bit recommended)"
    gpg --full-generate-key
    echo ""
    echo "✓ Key generated! Run 'just list-keys' to see it"

# Configure Git with GPG key (interactive)
@configure-git:
    #!/usr/bin/env bash
    set -e
    echo "Configuring Git with GPG signing..."

    # List keys
    echo ""
    echo "Available GPG keys:"
    gpg --list-secret-keys --keyid-format=long | grep -E "^\s+[A-F0-9]{16}" | awk '{print $NF}' || true

    echo ""
    echo "Enter your GPG key ID (last 16 chars, e.g., ABC123DEF456GHIJ):"
    read -r KEY_ID

    if [ -z "$KEY_ID" ]; then
        echo "No key ID provided. Exiting."
        exit 1
    fi

    # Validate key exists
    if ! gpg --list-secret-keys --keyid-format=long | grep -q "$KEY_ID"; then
        echo "✗ Key not found: $KEY_ID"
        exit 1
    fi

    # Configure with predefined user info
    git config --global user.name "{{ GIT_NAME }}"
    git config --global user.email "{{ GIT_EMAIL }}"
    git config --global user.signingkey "$KEY_ID"
    git config --global commit.gpgsign true
    git config --global gpg.program gpg

    echo ""
    echo "✓ Git user.name: {{ GIT_NAME }}"
    echo "✓ Git user.email: {{ GIT_EMAIL }}"
    echo "✓ Git configured with GPG key: $KEY_ID"
    echo "✓ Automatic commit signing enabled"

# Configure Git with GPG key (non-interactive, pass KEY_ID)
@configure-git-silent KEY_ID NAME="" EMAIL="":
    #!/usr/bin/env bash
    set -e

    # Validate key exists
    if ! gpg --list-secret-keys --keyid-format=long | grep -q "{{ KEY_ID }}"; then
        echo "✗ Key not found: {{ KEY_ID }}"
        exit 1
    fi

    git config --global user.signingkey "{{ KEY_ID }}"
    git config --global commit.gpgsign true
    git config --global gpg.program gpg

    if [ -n "{{ NAME }}" ]; then
        git config --global user.name "{{ NAME }}"
    fi

    if [ -n "{{ EMAIL }}" ]; then
        git config --global user.email "{{ EMAIL }}"
    fi

    echo "✓ Git configured with GPG key: {{ KEY_ID }}"

# Test GPG signing with a dry-run
@test-signing:
    #!/usr/bin/env bash
    echo "Testing GPG signing..."
    echo ""

    # Check if signing is configured
    SIGNING_KEY=$(git config --global user.signingkey)
    if [ -z "$SIGNING_KEY" ]; then
        echo "✗ No signing key configured. Run 'just configure-git' first."
        exit 1
    fi

    echo "Using key: $SIGNING_KEY"

    # Try to sign a test message
    TEST_MSG="test"
    if echo "$TEST_MSG" | gpg --sign --armor --default-key "$SIGNING_KEY" > /dev/null 2>&1; then
        echo "✓ GPG signing works!"
    else
        echo "✗ GPG signing failed. Check your passphrase/key."
        exit 1
    fi

    # Show current config
    echo ""
    echo "Current Git config:"
    git config --global --list | grep -E "user\.|gpg\.|commit\.gpg" || true

# Display current Git + GPG configuration
@show-config:
    echo "Current Git + GPG configuration:"
    echo ""
    @git config --global --list | grep -E "user\.|gpg\.|commit\.gpg" || echo "No GPG config found"

# Install GPG (platform-specific)
@install-gpg:
    #!/usr/bin/env bash
    if command -v gpg &> /dev/null; then
        echo "GPG already installed"
        exit 0
    fi

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Installing GPG on macOS..."
        brew install gnupg
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/fedora-release ]; then
            echo "Installing GPG on Fedora..."
            sudo dnf install -y gnupg
        elif [ -f /etc/debian_version ]; then
            echo "Installing GPG on Debian/Ubuntu..."
            sudo apt update && sudo apt install -y gnupg
        else
            echo "Installing GPG on Linux..."
            sudo apt update && sudo apt install -y gnupg
        fi
    else
        echo "Unsupported OS. Install GPG manually from https://gnupg.org"
        exit 1
    fi

# Complete setup: install, generate key, and configure Git
@full-setup:
    #!/usr/bin/env bash
    set -e

    echo "🚀 Starting complete Git + GPG setup for {{ GIT_NAME }}..."
    echo ""

    # Install GPG if needed
    just install-gpg
    just check-gpg

    echo ""

    # Check for existing keys
    KEY_COUNT=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep -c "sec " || echo 0)

    if [ "$KEY_COUNT" -eq 0 ]; then
        echo "No GPG keys found. Generating one now..."
        just generate-key
    else
        echo "Found $KEY_COUNT existing key(s):"
        just list-keys
    fi

    echo ""
    just configure-git
    echo ""
    just test-signing

    echo ""
    echo "✅ Setup complete!"
    echo ""
    echo "📋 Configuration Summary:"
    echo "   Name:  {{ GIT_NAME }}"
    echo "   Email: {{ GIT_EMAIL }}"
    echo ""
    echo "Next steps:"
    echo "1. Add your public key to GitHub/GitLab: just export-public-key"
    echo "2. Verify signing works: just verify-commits"

# Disable automatic commit signing (for this repo only)
@disable-signing-local:
    git config commit.gpgsign false
    echo "✓ Disabled signing for this repository"

# Re-enable automatic commit signing (for this repo)
@enable-signing-local:
    git config commit.gpgsign true
    echo "✓ Enabled signing for this repository"

# Export public key (useful for adding to GitHub/GitLab)
@export-public-key:
    #!/usr/bin/env bash
    SIGNING_KEY=$(git config --global user.signingkey)

    if [ -z "$SIGNING_KEY" ]; then
        echo "No signing key configured"
        exit 1
    fi

    echo "Public key for $SIGNING_KEY:"
    echo ""
    gpg --armor --export "$SIGNING_KEY"

# Sign a specific commit (if not automatically signed)
@sign-commit COMMIT="HEAD":
    git commit --amend --no-edit -S {{ COMMIT }}
    echo "✓ Signed commit: {{ COMMIT }}"

# Verify recent commits
@verify-commits COUNT="5":
    #!/usr/bin/env bash
    echo "Verifying last {{ COUNT }} commits..."
    git log --show-signature -{{ COUNT }}

# Clean up: reset Git + GPG config
@reset-config:
    #!/usr/bin/env bash
    echo "⚠️  This will reset your Git GPG configuration"
    echo "Continue? (type 'yes' to confirm)"
    read -r CONFIRM

    if [ "$CONFIRM" != "yes" ]; then
        echo "Cancelled"
        exit 0
    fi

    git config --global --unset user.signingkey || true
    git config --global --unset commit.gpgsign || true
    git config --global --unset gpg.program || true

    echo "✓ Configuration reset"
