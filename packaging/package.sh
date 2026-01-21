#!/bin/bash
# PDF Splitter Packaging Script for Linux/macOS

# Change to script directory
cd "$(dirname "$0")"

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Darwin*)    PLATFORM="macOS";;
    Linux*)     PLATFORM="Linux";;
    *)          PLATFORM="Unknown";;
esac

echo "========================================"
echo "PDF Splitter Packager"
echo "========================================"
echo "Platform: $PLATFORM"
echo "Working directory: $(pwd)"
echo ""

# Check if virtual environment exists
if [ ! -d "../venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv ../venv
fi

# Activate virtual environment
echo "Activating virtual environment..."
source ../venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
pip install -e ..

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf ./dist ./build

# Run PyInstaller with platform-specific options
echo "Building executable..."

if [ "$PLATFORM" = "macOS" ]; then
    # macOS: Create .app bundle
    pyinstaller \
        --name=PDFSplitter \
        --windowed \
        --onedir \
        --paths=../src \
        --hidden-import=tkinter \
        --hidden-import=tkinter.ttk \
        --hidden-import=tkinter.simpledialog \
        --hidden-import=tkinter.filedialog \
        --hidden-import=pypdf \
        --collect-all=pypdf \
        --osx-bundle-identifier=com.pdfsplitter.app \
        --noconfirm \
        ../run.py

    BUILD_RESULT=$?

    if [ $BUILD_RESULT -eq 0 ]; then
        # Create DMG for distribution (if hdiutil is available)
        if command -v hdiutil &> /dev/null; then
            echo ""
            echo "Creating DMG installer..."
            rm -f ./dist/PDFSplitter.dmg
            hdiutil create -volname "PDF Splitter" \
                -srcfolder ./dist/PDFSplitter.app \
                -ov -format UDZO \
                ./dist/PDFSplitter.dmg 2>/dev/null

            if [ $? -eq 0 ]; then
                echo "DMG created: ./dist/PDFSplitter.dmg"
            fi
        fi
    fi

    OUTPUT_PATH="./dist/PDFSplitter.app"
else
    # Linux: Create single executable
    pyinstaller \
        --name=PDFSplitter \
        --windowed \
        --onefile \
        --paths=../src \
        --hidden-import=tkinter \
        --hidden-import=tkinter.ttk \
        --hidden-import=tkinter.simpledialog \
        --hidden-import=tkinter.filedialog \
        --hidden-import=pypdf \
        --collect-all=pypdf \
        --noconfirm \
        ../run.py

    BUILD_RESULT=$?
    OUTPUT_PATH="./dist/PDFSplitter"
fi

if [ $BUILD_RESULT -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "Build completed successfully!"
    echo "========================================"
    echo "Output location: $OUTPUT_PATH"

    # Show file/folder size
    if [ -d "$OUTPUT_PATH" ]; then
        SIZE=$(du -sh "$OUTPUT_PATH" | cut -f1)
    else
        SIZE=$(du -h "$OUTPUT_PATH" | cut -f1)
    fi
    echo "Size: $SIZE"
    echo ""
else
    echo ""
    echo "========================================"
    echo "Build failed!"
    echo "========================================"
    exit 1
fi
