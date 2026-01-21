# PDF Splitter

A simple Python application to split PDF files into smaller files with a graphical file picker.

## Features

- Split PDFs into individual pages or groups of pages
- Graphical file picker dialog (no need to type file paths)
- Configurable pages per output file
- Cross-platform support (Windows, macOS, Linux)
- Standalone executable packaging

## Prerequisites

- Python 3.10 or higher

## Installation

```bash
pip install -r requirements.txt
```

Or install as a package:

```bash
pip install -e .
```

## Usage

### GUI Mode (Recommended)

Simply run without arguments to open the file picker:

```bash
python run.py
```

1. A file dialog opens to select a PDF
2. Enter the number of pages per output file (default: 1 for individual pages)
3. Split files are saved to the `output/` directory

### Command Line Mode

```bash
python run.py <pdf_file> [pages_per_file]
```

Examples:

```bash
# Split into individual pages
python run.py document.pdf

# Split into groups of 5 pages
python run.py document.pdf 5
```

## Building Standalone Executable

To create a standalone `.exe` (Windows) or app bundle (macOS):

```bash
cd packaging
.\package.ps1      # Windows
./package.sh       # Linux/macOS
```

The executable will be in `packaging/dist/`.

## Development

Install development dependencies:

```bash
pip install -r requirements-dev.txt
```

Set up pre-commit hooks:

```bash
pre-commit install
```

Run tests:

```bash
pytest
```

Run linting:

```bash
pre-commit run --all-files
```

## Project Structure

```
pdf-splitter/
├── src/
│   ├── __init__.py
│   └── pdf_splitter.py      # Core splitting logic
├── tests/
│   └── test_pdf_splitter.py
├── packaging/               # PyInstaller packaging scripts
│   ├── package.ps1          # Windows build script
│   ├── package.sh           # Linux/macOS build script
│   └── README.md
├── output/                  # Default output directory
├── pyproject.toml           # Project metadata
├── requirements.txt
├── requirements-dev.txt
├── run.py                   # Entry point with GUI
└── README.md
```

## License

MIT
