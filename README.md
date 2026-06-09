# UMU App

A utility for creating native Linux application launchers for Windows programs using **UMU Launcher**, **Wine**, and **GE-Proton**.

UMU App generates:

- A UMU-compatible `.toml` configuration
- A desktop launcher (`.desktop`)
- An application icon (automatically extracted or user-provided)

The goal is to make Windows applications launched through UMU behave like native Linux applications that appear in your desktop environment's application menu.

## Features

- GUI mode powered by **YAD**
- Command-line mode for automation and scripting
- Automatically generates UMU `.toml` configuration files
- Creates desktop launchers in `~/.local/share/applications`
- Extracts icons from `.exe` files (`ICO → PNG`)
- Supports custom icons
- Automatically detects the newest installed **GE-Proton**
- Downloads GE-Proton automatically if none is available
- Automatically creates Wine prefixes when needed
- Supports launch arguments and environment wrappers such as:
  - MangoHud
  - GameMode
  - vkBasalt
  - Custom environment variables
- Supports UMU store identifiers:
  - steam
  - gog
  - egs
  - battlenet
  - ea
  - humble
  - itchio
  - ubisoft
  - zoomplatform

## Requirements

### Required

- `umu-run` (provided by UMU Launcher)

### Optional

- `yad` – graphical interface
- `icoutils` – icon extraction from Windows executables
- `imagemagick` – icon conversion and cleanup
- `libnotify` / `notify-send` – desktop notifications

## Installation

### Clone the repository

```bash
git clone https://github.com/quinsaiz/umu-app.git && \
cd umu-app
```

### Make the installer executable

```bash
chmod +x install.sh
```

### Install

```bash
./install.sh
```

The installer:

- Copies `umu-app` to `/usr/bin/umu-app`
- Registers a file-manager launcher for Windows executables
- Installs the UMU App desktop entry
- Optionally installs missing dependencies

---

### Install optional dependencies only

```bash
./install.sh --deps
```

---

### Uninstall

```bash
./install.sh --uninstall
```

Removed files:

- /usr/bin/umu-app
- ~/.local/share/applications/umu-app.desktop
- ~/.local/share/applications/umu-launch.desktop

## Usage

### GUI Mode

Launch the graphical interface:

```bash
umu-app --gui
```

Open GUI mode with a preselected executable:

```bash
umu-app /path/to/application.exe --gui
```

Pre-fill GUI fields:

```bash
umu-app ~/Games/Skyrim/SkyrimSE.exe --gui \
  --name="Skyrim Special Edition" \
  --prefix=~/Games/Skyrim/prefix \
  --proton=~/custom-proton
```

### GUI Options

The graphical interface allows you to configure:

- Windows executable (`.exe`, `.msi`, `.bat`, `.cmd`)
- Application name
- Custom icon
- Wine prefix
- Proton version
- Store identifier
- Game ID
- Launch arguments
- Additional execution arguments

## Command-Line Usage

### Basic

```bash
umu-app /path/to/application.exe
```

### Available Options

| Short | Long              | Description                                |
|-------|-------------------|--------------------------------------------|
|       | `--gui`           | Launch graphical interface                 |
| `-u`  | `--update-proton` | Download the latest GE-Proton and exit     |
| `-n`  | `--name`          | Application name                           |
| `-i`  | `--icon`          | Custom icon path                           |
| `-w`  | `--prefix`        | Wine prefix path                           |
| `-p`  | `--proton`        | Proton directory or Proton name            |
| `-g`  | `--gameid`        | UMU Game ID                                |
| `-s`  | `--store`         | Store identifier                           |
| `-a`  | `--launch_args`   | Arguments passed to the Windows executable |
| `-e`  | `--exec`          | Additional commands before `umu-run`       |
| `-h`  | `--help`          | Show help message                          |

### Example

```bash
umu-app ~/Games/Skyrim/SkyrimSE.exe \
  --name="Skyrim Special Edition" \
  --icon=~/Pictures/skyrim.png \
  --prefix=~/Games/Skyrim/prefix \
  --proton=GE-Proton10-26 \
  --store=egs \
  --gameid=umu-489830 \
  --launch_args="--fullscreen,--novid" \
  --exec="mangohud gamemode ENABLE_VKBASALT=1"
```

## Generated Files

After creating an application entry, UMU App generates three files.

### 1. UMU Configuration

Location:

```text
<application_directory>/<application_name>.toml
```

Example:

```toml
[umu]
prefix = "/home/user/Prefix"
proton = "/home/user/.local/share/Steam/compatibilitytools.d/GE-Proton10-26"
exe = "/home/user/Games/game.exe"
store = "steam"
game_id = "12345"
launch_args = ["--fullscreen", "--novid"]
```

### 2. Desktop Entry

Location:

```text
~/.local/share/applications/<application_name>.desktop
```

Example:

```ini
[Desktop Entry]
Name=Game Name
Exec=env mangohud gamemode umu-run --config "/path/to/config.toml"
Type=Application
Terminal=false
Categories=Games;Wine;
Icon=/home/user/.local/share/icons/umu-app/game.png
```

### 3. Application Icon

Location:

```text
~/.local/share/icons/umu-app/<application_name>.png
```

## Proton Detection

UMU App searches for GE-Proton installations in:

```text
~/.local/share/Steam/compatibilitytools.d/
```

When multiple versions are available, the newest version is selected automatically.

If no GE-Proton installation is found, UMU App attempts to download one using:

```bash
umu-run true
```

You can always override automatic detection with:

```bash
--proton=/path/to/proton
```

## Desktop Integration

The installer creates two desktop entries.

## License

MIT License. See the `LICENSE` file for details.
