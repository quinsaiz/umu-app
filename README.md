# UMU Application Generator

Utility for generating UMU `.toml` configs and `.desktop` launchers for Windows applications using **UMU Launcher**.

Automatically extracts icons, prepares Wine prefixes, detects the newest GE-Proton version, and creates native-style launch entries.

`install.sh` automatically installs `UMU Launch.desktop` to run any MS-DOS program in the file manager.

## Features
- Auto-generate **TOML** config.
- Create **.desktop** launchers in `~/.local/share/applications`.
- Extract icons from `.exe` (ICO → PNG) or use custom icons.
- Auto-detect latest **GE-Proton**.
- Auto-create Wine prefix if missing.
- Supports:
  - Custom name.
  - Custom icon.
  - Custom WINEPREFIX.
  - Custom Proton.
  - UMU `game_id` (only if use UMU-Proton).
  - Store tag.
  - Launch args via `"a|b"`.

## Requirements
- umu-run — included in [umu-launcher](https://github.com/Open-Wine-Components/umu-launcher).
- (optional) **wrestool**, **icotool** — for extracting icons.
- (optional) **ImageMagick** — for resizing/clean PNGs.

## Installation

### Clone the repository
```bash
git clone https://github.com/quinsaiz/umu-app.git
cd umu-app
```
### Give permission to execute the file
```bash
chmod +x ./install
```
### Install
```bash
./install.sh
```

### Uninstall
```bash
./install.sh --uninstall
```

This removes:
- /usr/local/bin/umu-app
- ~/.local/share/applications/umu-launch.desktop

## Usage

### Basic
```bash
umu-app /path/to/game.exe
```

### With custom options
```bash
umu-app /path/to/game.exe \
  --name "My Game" \
  --icon ~/Pictures/game.png \
  --wineprefix ~/Games/Prefix \
  --proton ~/.local/share/Steam/compatibilitytools.d/GE-Proton9 \
  --gameid 12345 \
  --store egs \
  --launch_args "a|b"
```

### What gets created?
Config: /path/to/game/game.toml

Launcher: ~/.local/share/applications/GameName.desktop

Icon: ~/.local/share/icons/umu-app/game.png

### Example
```bash
umu-app ~/Games/Skyrim/SkyrimSE.exe --name Skyrim
```

### Output:
```text
Created:
  Config : /home/user/Games/Skyrim/SkyrimSE.toml
  Desktop: /home/user/.local/share/applications/Skyrim.desktop
  Icon   : /home/user/.local/share/icons/umu-app/SkyrimSE.png
```