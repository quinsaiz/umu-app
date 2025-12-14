# UMU Application Generator

Utility for generating UMU `.toml` configs and `.desktop` launchers for Windows applications using **UMU Launcher**.

Automatically extracts icons, prepares Wine prefixes, detects the newest GE-Proton version, and creates native-style launch entries.

`install.sh` automatically installs `UMU Launch.desktop` to run any MS-DOS program in the file manager and `UMU Application.desktop` GUI version `umu-app`.

## Features
- **GUI Mode** — graphical interface for easy configuration (using YAD).
- Auto-generate **TOML** config.
- Create **.desktop** launchers in `~/.local/share/applications`.
- Extract icons from MS-DOS program (ICO → PNG) or use custom icons.
- Auto-detect latest **GE-Proton** from multiple locations:
  - `~/.local/share/Steam/compatibilitytools.d/`
  - `/usr/share/steam/compatibilitytools.d/` (Arch Linux AUR packages)
- Auto-create Wine prefix if missing.
- Supports:
  - Custom name.
  - Custom icon.
  - Custom WINEPREFIX.
  - Custom Proton (system paths or custom directories).
  - UMU `game_id` (only if use UMU-Proton).
  - Store tag (steam/gog/egs/battlenet/ea/humble/itchio/ubisoft/zoomplatform).
  - Launch arguments for the game executable.
  - Additional launch commands (mangohud, gamemode, etc.).

## Requirements
- **umu-run** — included in [umu-launcher](https://github.com/Open-Wine-Components/umu-launcher).
- **(optional) yad** — for GUI mode.
- **(optional) icoutils** — for extracting icons from executables.
- **(optional) ImageMagick** — for resizing/cleaning PNGs.

## Installation

### Clone the repository
```bash
git clone https://github.com/quinsaiz/umu-app.git
cd umu-app
```
### Give permission to execute the file
```bash
chmod +x ./install.sh
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
    - `/usr/bin/umu-app`
* **Desktop Launchers:**
    - `~/.local/share/applications/umu-app.desktop`
    - `~/.local/share/applications/umu-launch.desktop`

## Usage

### GUI Mode (Recommended)
Launch the graphical interface for easy configuration:

```bash
umu-app --gui
```

Or with a pre-selected executable:

```bash
umu-app /path/to/game.exe --gui
```

You can also pass parameters that will be pre-filled in the GUI:

```bash
umu-app ~/Games/Skyrim/SkyrimSE.exe --gui \
  --name="Skyrim Special Edition" \
  --prefix=~/Games/Skyrim/prefix \
  --proton=~/custom-proton
```

The GUI allows you to:
- Select game executable (`.exe`, `.msi`, `.bat`, `.cmd`)
- Set application name
- Choose custom icon
- Select Wine prefix directory
- Choose Proton version from dropdown (or specify custom path)
- Select game store (for UMU-Proton compatibility)
- Set Game ID (optional)
- Add launch arguments
- Add additional commands (mangohud, gamemode, etc.)

### Command Line Mode

#### Basic
```bash
umu-app /path/to/game.exe
```

#### With custom options

| Short | Long | Description | Example |
| :---: | :--- | :--- | :--- |
| `--gui` | | Launch graphical interface | `--gui` |
| `-n` | `--name` | App name | `--name="Skyrim Special Edition"` |
| `-i` | `--icon` | Path to a custom icon | `--icon=/home/user/icons/game.png` |
| `-w` | `--prefix` | Wine prefix (default: `~/Prefix`) | `--prefix=/home/user/Prefix` |
| `-p` | `--proton` | Proton path or name (default: latest GE-Proton) | `--proton=GE-Proton10-26` or `--proton=~/custom-proton` |
| `-g` | `--gameid` | UMU game\_id (optional) | `--gameid=12345` |
| `-s` | `--store` | Game store | `--store=steam` |
| `-a` | `--launch_args` | Game launch arguments, separated by comma | `--launch_args="--fullscreen,--novid"` |
| `-e` | `--exec` | Additional commands before `umu-run` | `--exec="mangohud gamemode"` |
| `-h` | `--help` | Show help message | `--help` |

#### Example
```bash
umu-app ~/Games/Skyrim/SkyrimSE.exe \
  --name="Skyrim V SE" \
  --icon=~/Pictures/skyrim.png \
  --prefix=~/Games/Skyrim/prefix \
  --proton=GE-Proton10-26 \
  --store=steam \
  --launch_args="--fullscreen,--novid" \
  --exec="mangohud gamemode"
```

### Output:
```text
Created:
  Config : /home/user/Games/Skyrim/Skyrim V SE.toml
  Desktop: /home/user/.local/share/applications/Skyrim V SE.desktop
  Icon   : /home/user/.local/share/icons/umu-app/Skyrim V SE.png
```

## Proton Detection

The script automatically detects Proton installations from:
1. `~/.local/share/Steam/compatibilitytools.d/` (manual GE-Proton installations)
2. `/usr/share/steam/compatibilitytools.d/` (Arch Linux AUR: `proton-ge-custom-bin`)

In GUI mode, available Proton versions are displayed in a dropdown list (newest first).
You can also specify a custom Proton directory by typing the path or using the folder selector.

If no Proton is found and none is specified, the script will automatically download the latest GE-Proton.

## File Structure

After running the script, the following files are created:

1. **TOML Config** — `<game_directory>/<app_name>.toml`
   ```toml
   [umu]
   prefix = "/home/user/Prefix"
   proton = "/home/user/.local/share/Steam/compatibilitytools.d/GE-Proton10-26"
   exe = "/home/user/Games/game.exe"
   store = "steam"
   game_id = "12345"
   launch_args = ["--fullscreen", "--novid"]
   ```

2. **Desktop Launcher** — `~/.local/share/applications/<app_name>.desktop`
   ```ini
   [Desktop Entry]
   Name=Game Name
   Exec=env mangohud gamemode umu-run --config "/path/to/config.toml"
   Type=Application
   Categories=Games;Wine;
   Terminal=false
   Icon=/home/user/.local/share/icons/umu-app/game.png
   ```

3. **Icon** — `~/.local/share/icons/umu-app/<app_name>.png`

## Tips

- **Use GUI mode** for easier configuration: `umu-app --gui`
- **Custom Proton**: You can use Proton from any directory, including Wine-GE builds
- **Launch arguments**: Use comma-separated values: `--launch_args="arg1,arg2,arg3"`
- **Multiple commands**: Chain commands in `--exec`: `--exec="mangohud gamemode DXVK_HUD=1"`
- **Tilde expansion**: Both `~/path` and `/home/user/path` work correctly

## Troubleshooting

**GUI doesn't launch:**
- Install YAD: `sudo pacman -S yad` (Arch) or `sudo apt install yad` (Debian/Ubuntu)

**Icon not extracted:**
- Install icoutils: `sudo pacman -S icoutils` (Arch) or `sudo apt install icoutils` (Debian/Ubuntu)

**Icon quality is poor:**
- Install ImageMagick: `sudo pacman -S imagemagick` (Arch) or `sudo apt install imagemagick` (Debian/Ubuntu)

**Proton not detected:**
- Ensure Proton is installed in `~/.local/share/Steam/compatibilitytools.d/` or `/usr/share/steam/compatibilitytools.d/`
- Or specify a custom path with `--proton`

## License

MIT License — see [LICENSE](LICENSE) file for details.