#!/bin/bash
set -euo pipefail

SCRIPT_SRC="$(realpath ./umu-app)"
SCRIPT_DEST="/usr/local/bin/umu-app"
DESKTOP="$HOME/.local/share/applications/umu-launch.desktop"

# === Uninstall ===
if [[ "${1:-}" == "-u" || "${1:-}" == "--uninstall" ]]; then
    echo "Uninstalling umu-app..."

    if [[ -f "$SCRIPT_DEST" ]]; then
        sudo rm "$SCRIPT_DEST"
        echo "Removed: $SCRIPT_DEST"
    else
        echo "Not found: $SCRIPT_DEST"
    fi

    if [[ -f "$DESKTOP" ]]; then
        rm "$DESKTOP"
        echo "Removed: $DESKTOP"
    else
        echo "Not found: $DESKTOP"
    fi

    update-desktop-database ~/.local/share/applications/ >/dev/null 2>&1 || true

    echo "Uninstall complete."
    exit 0
fi

# === Install ===
sudo cp "$SCRIPT_SRC" "$SCRIPT_DEST"
sudo chmod +x "$SCRIPT_DEST"
echo "umu-app installed → $SCRIPT_DEST"

# === .desktop ===
{
    printf '%s\n' \
    "[Desktop Entry]" \
    "Name=UMU Launch" \
    "Comment=Launch Windows applications via Wine/Proton" \
    "Exec=env WINEPREFIX=${HOME}/Prefix PROTONPATH=GE-Proton umu-run %f" \
    "Type=Application" \
    "Terminal=false" \
    "Icon=wine" \
    "MimeType=application/x-ms-dos-executable;application/x-msi;application/x-wine-extension-msp;" \
    "Categories=Games;Emulator;Wine;" \
    "StartupNotify=true"
} > "$DESKTOP"

update-desktop-database ~/.local/share/applications/ >/dev/null 2>&1 || true

# === Result ===
echo "Application → $DESKTOP"
