# Packaging PDF Splitter

This directory contains scripts to package the PDF Splitter application into standalone executables.

## Prerequisites

- Python 3.10 or higher
- All dependencies from `pyproject.toml` (project root)

## Packaging on Windows

Run the PowerShell script:

```powershell
cd packaging
.\package.ps1
```

The executable will be created at: `packaging/dist/PDFSplitter.exe`

## Packaging on Linux

Run the bash script:

```bash
cd packaging
chmod +x package.sh
./package.sh
```

The executable will be created at: `packaging/dist/PDFSplitter`

## Packaging on macOS

Run the bash script:

```bash
cd packaging
chmod +x package.sh
./package.sh
```

The script automatically detects macOS and creates:
- **App bundle**: `packaging/dist/PDFSplitter.app`
- **DMG installer**: `packaging/dist/PDFSplitter.dmg` (if hdiutil is available)

## What Gets Packaged

### Source Files
- `run.py` - Main entry point with file dialogs
- `src/pdf_splitter.py` - PDF splitting logic

### Python Packages
- pypdf - PDF file manipulation
- tkinter - GUI framework (built-in)

## Build Output

After successful build:

```
packaging/
├── dist/
│   └── PDFSplitter.exe (or PDFSplitter on Linux, PDFSplitter.app on macOS)
├── build/
│   └── [temporary build files]
└── PDFSplitter.spec
    └── [PyInstaller spec file]
```

## Using the Spec File

For more control over the build, use the spec file directly:

```bash
cd packaging
source ../venv/bin/activate  # or ../venv/Scripts/Activate.ps1 on Windows
pyinstaller PDFSplitter.spec
```

## Customization

To customize the build, edit the PyInstaller parameters in `package.ps1` or `package.sh`:

- `--name`: Change the executable name
- `--windowed`: Remove console window (already set)
- `--onefile`: Create single executable (already set)
- `--icon`: Add custom application icon
- `--add-data`: Include additional data files

## Troubleshooting

### Missing Dependencies
If the build fails with missing dependencies:

```bash
pip install -r requirements.txt
```

### Import Errors
If the executable fails to run with import errors, add the missing module to `--hidden-import`:

```powershell
--hidden-import=module_name
```

### tkinter Issues on Linux
On some Linux distributions, tkinter may need to be installed separately:

```bash
# Ubuntu/Debian
sudo apt-get install python3-tk

# Fedora
sudo dnf install python3-tkinter
```

## Clean Build

To remove all build artifacts, run:

```powershell
.\clean.ps1
```

Or manually:

**Windows:**
```powershell
Remove-Item -Recurse -Force dist, build, *.spec
```

**Linux/macOS:**
```bash
rm -rf dist build *.spec
```

## Distribution

The final executable in `dist/` is standalone and can be distributed without requiring Python installation.

**Note:** The executable is platform-specific. Build on the target platform or build for multiple platforms separately.
