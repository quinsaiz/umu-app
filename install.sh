#!/bin/bash
set -euo pipefail

SCRIPT_SRC="$(realpath ./umu-app)"
SCRIPT_DEST="/usr/bin/umu-app"
DESKTOP_LAUNCH="$HOME/.local/share/applications/umu-launch.desktop"
DESKTOP_APP="$HOME/.local/share/applications/umu-app.desktop"

# === Uninstall ===
if [[ "${1:-}" == "-u" || "${1:-}" == "--uninstall" ]]; then
    echo "Uninstalling umu-app..."

    if [[ -f "$SCRIPT_DEST" ]]; then
        sudo rm "$SCRIPT_DEST"
        echo "Removed: $SCRIPT_DEST"
    else
        echo "Not found: $SCRIPT_DEST"
    fi

    if [[ -f "$DESKTOP_LAUNCH"  ]]; then
        rm "$DESKTOP_LAUNCH"
        echo "Removed: $DESKTOP_LAUNCH"
    else
        echo "Not found: $DESKTOP_LAUNCH"
    fi
    
    if [[ -f "$DESKTOP_APP"  ]]; then
        rm "$DESKTOP_APP"
        echo "Removed: $DESKTOP_APP"
    else
        echo "Not found: $DESKTOP_APP"
    fi

    update-desktop-database ~/.local/share/applications/ >/dev/null 2>&1 || true

    echo "Uninstall complete."
    exit 0
fi

# === Install ===
sudo cp "$SCRIPT_SRC" "$SCRIPT_DEST"
sudo chmod +x "$SCRIPT_DEST"

# === .desktop ===
{
    printf '%s\n' \
    "[Desktop Entry]" \
    "NoDisplay=true" \
    "Name=Launch Windows app" \
    "Comment=Launch Windows applications via Wine/Proton" \
    "Exec=env WINEPREFIX=${HOME}/Prefix PROTONPATH=GE-Proton umu-run %f" \
    "Type=Application" \
    "Terminal=false" \
    "Icon=wine" \
    "MimeType=application/x-ms-dos-executable;application/x-msi;application/x-wine-extension-msp;" \
    "Categories=Games;Emulator;Wine;" \
    "StartupNotify=true"
} > "$DESKTOP_LAUNCH"

{
    printf '%s\n' \
    "[Desktop Entry]" \
    "NoDisplay=true" \
    "Name=Create a desktop entry" \
    "Comment=Create a desktop entry for a Windows application" \
    "Exec=env umu-app %f" \
    "Type=Application" \
    "Terminal=false" \
    "Icon=wine" \
    "MimeType=application/x-ms-dos-executable;application/x-msi;application/x-wine-extension-msp;" \
    "Categories=Games;Emulator;Wine;" \
    "StartupNotify=true"
} > "$DESKTOP_APP"

update-desktop-database ~/.local/share/applications/ >/dev/null 2>&1 || true

# === Result ===
echo "Installation complete:"
echo "  Script     : $SCRIPT_DEST"
echo "  Launcher   : $DESKTOP_LAUNCH"
echo "  Application: $DESKTOP_APP"