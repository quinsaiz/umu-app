# UMU Application Generator

Utility for generating UMU `.toml` configs and `.desktop` launchers for Windows applications using **UMU Launcher**.

Automatically extracts icons, prepares Wine prefixes, detects the newest GE-Proton version, and creates native-style launch entries.

`install.sh` automatically installs `UMU Launch.desktop` to run any MS-DOS program in the file manager.

## Features
- Auto-generate **TOML** config.
- Create **.desktop** launchers in `~/.local/share/applications`.
- Extract icons from MS-DOS program (ICO → PNG) or use custom icons.
- Auto-detect latest **GE-Proton**.
- Auto-create Wine prefix if missing.
- Supports:
  - Custom name.
  - Custom icon.
  - Custom WINEPREFIX.
  - Custom Proton.
  - UMU `game_id` (only if use UMU-Proton).
  - Store tag.
  - Create via argsuments.

## Requirements
- umu-run — included in [umu-launcher](https://github.com/Open-Wine-Components/umu-launcher).
- (optional) **icoutils** — for extracting icons.
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

---

### Uninstall
```bash
./install.sh --uninstall
```

The uninstallation process removes the following files:

* **Main Executable:**
    - /usr/bin/umu-app
* **Desktop Launchers:**
    - ~/.local/share/applications/umu-app.desktop
    - ~/.local/share/applications/umu-launch.desktop

## Usage

### Basic
```bash
umu-app /path/to/game.exe
```

### With custom options

| Short | Long | Description | Example |
| :---: | :--- | :--- | :--- |
| `-n` | `--name` | App name | `--name="Skyrim Special Edition"` |
| `-i` | `--icon` | Path to a custom icon | `--icon=/home/user/icons/game.png` |
| `-w` | `--prefix` | Wine prefix (default: ~/Prefix). | `--prefix=/home/user/Prefix` |
| `-p` | `--proton` | Proton/path (default: latest GE-Proton). | `--proton=~/.local/share/Steam/compatibilitytools.d/GE-Proton-9.0` |
| `-g` | `--gameid` | UMU game\_id (optional). | `--gameid=12345` |
| `-s` | `--store` | Game store (gog/egs). | `--store=egs` |
| `-a` | `--launch_args "a\|b"` | Game launch arguments, separated by "\|" | `--launch_args="-fullscreen\|-novid"` |
| `-e` | `--exec ARGUMENTS` | Additional commands/arguments before `umu-run` in `Exec=`. | `--exec="mangohud gamemode"` |

### Example
```bash
umu-app ~/Games/Skyrim/SkyrimSE.exe --name="Skyrim V SE"
```

### Output:
```text
Created:
  Config : /home/user/Games/Skyrim/Skyrim V SE.toml
  Desktop: /home/user/.local/share/applications/Skyrim V SE.desktop
  Icon   : /home/user/.local/share/icons/umu-app/Skyrim V SE.png
```