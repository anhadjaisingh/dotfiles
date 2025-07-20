#!/bin/bash

# macOS Setup Script
# Run this script to configure macOS defaults for a new laptop setup
# 
# Usage: ./setup-macos.sh
# Note: Some changes require a restart or logout/login to take effect

echo "🍎 Setting up macOS defaults..."

# ==============================================================================
# Keyboard & Input Settings
# ==============================================================================

# Disable press-and-hold for keys in favor of key repeat
# This allows you to hold down a key (like 'j' in vim) and have it repeat
# instead of showing the accent character popup menu
defaults write -g ApplePressAndHoldEnabled -bool false

echo "✅ macOS setup complete!"
echo "⚠️  Some changes may require a restart to take effect."