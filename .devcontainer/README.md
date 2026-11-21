# Dev Container for LaTeX Project

This directory contains the configuration for a Docker-based development container with a complete LaTeX environment.

## What's Included

- **Ubuntu 22.04** base system
- **TeX Live** (full scheme) with all packages
- **latexmk** for automated compilation
- **BibTeX** for bibliography management
- **VS Code extensions:**
  - LaTeX Workshop (for LaTeX editing and compilation)
  - LTeX (grammar/spell checking)
  - Code Spell Checker

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed
- [VS Code](https://code.visualstudio.com/) installed
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code

## Working directory (important)

The devcontainer **`context`** is the **repository root** (parent of `.devcontainer/`). After reopening in the container, the integrated terminal’s cwd should be that root—the folder containing **`Letter.tex`** and **`Makefile`**.

## Make targets

From the repo root: **`make`** (or **`make letter`**) runs **`./Letter-make.sh`**; **`make clean`** removes LaTeX's auxiliary files; **`make test`** checks the LaTeX installation.

## Getting Started

1. **Open in Container:**
   - Open this project in VS Code
   - Press `F1` or `Cmd+Shift+P` (Mac) / `Ctrl+Shift+P` (Windows/Linux)
   - Type "Dev Containers: Reopen in Container"
   - Wait for the container to build (first time takes ~15-30 minutes due to TeX Live installation)

2. **Compile the letter** (from repo root):
   ```bash
   make letter
   # or: latexmk Letter.tex
   ```

3. **Clean build files** (from repo root):
   ```bash
   make clean
   # or: latexmk -c Letter.tex
   ```

4. **Verify LaTeX tools:**
   ```bash
   make test
   ```

## Features

- **Persistent TeX Live:** Uses a Docker volume to cache TeX Live, so subsequent rebuilds are faster
- **Non-root user:** Runs as `vscode` user for better security
- **Full LaTeX support:** All packages needed for this project are pre-installed
- **Git integration:** Git is pre-configured in the container

## Notes

- The first build will take a while (15-30 minutes) because it downloads and installs the full TeX Live distribution
- Subsequent container starts will be much faster thanks to Docker layer caching and volume mounting
- All your local files are mounted into the container, so changes are reflected immediately
- The container includes texmf-local with proper permissions for custom packages

## Troubleshooting

### Build takes too long
The full TeX Live scheme is large (~7GB). Consider switching to `scheme-medium` in the Dockerfile if you don't need all packages.

### Permission issues
The container runs as the `vscode` user (UID 1000). If you encounter permission issues, ensure your local files have appropriate permissions.

### Missing packages
If you need additional LaTeX packages:
```bash
sudo tlmgr install <package-name>
```

## Customization

Edit `.devcontainer/devcontainer.json` to:
- Add more VS Code extensions
- Change editor settings
- Modify environment variables

Edit `.devcontainer/Dockerfile` to:
- Install additional system packages
- Change the TeX Live scheme
- Add custom initialization scripts

