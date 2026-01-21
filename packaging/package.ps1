# PDF Splitter Packaging Script
# This script packages the application into a standalone executable using PyInstaller

# Ensure we're running from the packaging directory (where this script lives)
Push-Location $PSScriptRoot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PDF Splitter Packager" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Working directory: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# Check if virtual environment exists
if (-Not (Test-Path "../venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv ../venv
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Green
& "../venv/Scripts/Activate.ps1"

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Green
pip install --upgrade pip
pip install -r requirements.txt
pip install -e ..

# Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
if (Test-Path "./dist") { Remove-Item -Recurse -Force "./dist" }
if (Test-Path "./build") { Remove-Item -Recurse -Force "./build" }

# Run PyInstaller with all necessary files
Write-Host "Building executable..." -ForegroundColor Green

# Build the PyInstaller command
$pyinstallerArgs = @(
    "--name=PDFSplitter",
    "--windowed",
    "--onefile",
    "--paths=../src",
    "--hidden-import=tkinter",
    "--hidden-import=tkinter.ttk",
    "--hidden-import=tkinter.simpledialog",
    "--hidden-import=tkinter.filedialog",
    "--hidden-import=pypdf",
    "--collect-all=pypdf",
    "--noconfirm"
)

# Add the main script as the last argument
$pyinstallerArgs += "../run.py"

# Run PyInstaller
& pyinstaller $pyinstallerArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Executable location: ./dist/PDFSplitter.exe" -ForegroundColor Cyan

    # Show file size
    $exeSize = (Get-Item "./dist/PDFSplitter.exe").Length / 1MB
    Write-Host "Executable size: $([math]::Round($exeSize, 2)) MB" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Build failed!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Pop-Location
    exit 1
}

# Restore original working directory
Pop-Location
