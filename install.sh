#!/bin/bash
set -euo pipefail

SCRIPT_SRC="$(realpath ./umu-app)"
SCRIPT_DEST="/usr/bin/umu-app"
DESKTOP_LAUNCH="$HOME/.local/share/applications/umu-launch.desktop"
DESKTOP_APP="$HOME/.local/share/applications/umu-app.desktop"

# === Colors ===
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"

info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${RESET} $1"; }
error() { echo -e "${RED}[ERROR]${RESET} $1"; }

# === Functions ===
install_deps() {
	local missing=()

	command -v umu-run >/dev/null 2>&1 || missing+=("umu-launcher")
	command -v yad >/dev/null 2>&1 || missing+=("yad")
	command -v magick >/dev/null 2>&1 || missing+=("imagemagick")
	command -v wrestool >/dev/null 2>&1 || missing+=("icoutils")

	if [[ ${#missing[@]} -eq 0 ]]; then
		success "All optional dependencies already installed."
		return 0
	fi

	warning "Missing optional dependencies: ${missing[*]}"

	if [[ "${1:-}" != "--yes" ]]; then
		read -rp "Install them now? [Y/n] " response
		[[ "${response,,}" == "n" ]] && return 0
	fi

	if command -v pacman >/dev/null 2>&1; then
		sudo pacman -S --needed --noconfirm "${missing[@]}"
	elif command -v apt-get >/dev/null 2>&1; then
		sudo apt-get install -y "${missing[@]}"
	elif command -v dnf >/dev/null 2>&1; then
		sudo dnf install -y "${missing[@]}"
	elif command -v zypper >/dev/null 2>&1; then
		sudo zypper install -y "${missing[@]}"
	else
		error "No supported package manager found (pacman/apt/dnf/zypper)"
		return 1
	fi

	success "Installed: ${missing[*]}"

	if command -v notify-send >/dev/null 2>&1; then
		notify-send -i "applications-games" -a "UMU App" "Dependencies installed" "${missing[*]}"
	fi
}

# === Uninstall ===
if [[ "${1:-}" == "-u" || "${1:-}" == "--uninstall" ]]; then
	info "Uninstalling umu-app..."

	if [[ -f "$SCRIPT_DEST" ]]; then
		sudo rm "$SCRIPT_DEST"
		success "Removed: $SCRIPT_DEST"
	else
		warning "Not found: $SCRIPT_DEST"
	fi

	if [[ -f "$DESKTOP_LAUNCH" ]]; then
		rm "$DESKTOP_LAUNCH"
		success "Removed: $DESKTOP_LAUNCH"
	else
		warning "Not found: $DESKTOP_LAUNCH"
	fi

	if [[ -f "$DESKTOP_APP" ]]; then
		rm "$DESKTOP_APP"
		success "Removed: $DESKTOP_APP"
	else
		warning "Not found: $DESKTOP_APP"
	fi

	update-desktop-database ~/.local/share/applications/ >/dev/null 2>&1 || true

	success "Uninstall complete."
	exit 0
fi

# === Install dependencies ===
if [[ "${1:-}" == "-d" || "${1:-}" == "--deps" ]]; then
	install_deps --yes
	exit 0
fi

# === Install ===
install_deps

info "Installing umu-app..."
sudo cp "$SCRIPT_SRC" "$SCRIPT_DEST"
sudo chmod +x "$SCRIPT_DEST"

# === .desktop ===
{
	printf '%s\n' \
		"[Desktop Entry]" \
		"NoDisplay=true" \
		"Name=Launch Windows app" \
		"Comment=Launch Windows applications via Wine/Proton" \
		"Exec=umu-app run %f" \
		"Type=Application" \
		"Terminal=false" \
		"Icon=wine" \
		"MimeType=application/x-ms-dos-executable;application/x-msi;application/x-wine-extension-msp;" \
		"Categories=Games;Emulator;Wine;" \
		"StartupNotify=true"
} >"$DESKTOP_LAUNCH"

{
	printf '%s\n' \
		"[Desktop Entry]" \
		"Name=Create Desktop Entry" \
		"Comment=Create a desktop entry for a Windows application" \
		"Exec=env umu-app %f --gui" \
		"Type=Application" \
		"Terminal=false" \
		"Icon=applications-games" \
		"MimeType=application/x-ms-dos-executable;application/x-msi;application/x-wine-extension-msp;" \
		"Categories=Games;Emulator;Wine;" \
		"StartupNotify=true"
} >"$DESKTOP_APP"

update-desktop-database ~/.local/share/applications/ >/dev/null 2>&1 || true

# === Result ===
success "Installation complete:"
info "  Script     : $SCRIPT_DEST"
info "  Launcher   : $DESKTOP_LAUNCH"
info "  Application: $DESKTOP_APP"

if command -v notify-send >/dev/null 2>&1; then
	notify-send -i "applications-games" -a "UMU App" "Installation complete" "Use 'Create Desktop Entry' to create desktop entries for Windows apps."
fi
