# CLAUDE.md

This file provides context for AI assistants working on this project.

## Project Overview

PDF Splitter is a Python application that splits PDF files into smaller files. It features a tkinter-based GUI for file selection and configuration.

## Architecture

```
run.py                    # Entry point - handles CLI args and GUI dialogs
src/pdf_splitter.py       # Core logic - split_pdf() and split_pdf_by_range()
```

## Key Functions

- `split_pdf(input_path, output_dir, pages_per_file)` - Split PDF into multiple files
- `split_pdf_by_range(input_path, start, end, output_path)` - Extract page range
- `select_pdf_file()` - tkinter file dialog
- `get_pages_per_file()` - tkinter input dialog

## Dependencies

- **pypdf** - PDF manipulation (reading/writing)
- **tkinter** - GUI dialogs (built into Python)

## Development Commands

```bash
# Install
pip install -e .

# Test
pytest

# Lint
pre-commit run --all-files

# Build executable
cd packaging && .\package.ps1
```

## File Patterns

- Source code: `src/`, `run.py`
- Tests: `tests/`
- Output: `output/` (gitignored except .gitkeep)
- Packaging: `packaging/`

## Conventions

- Python 3.10+ required
- Type hints used in function signatures
- Pre-commit hooks enforce trailing whitespace, EOF newlines, and critical flake8 errors
- Output filenames: `{basename}_page_{num:03d}.pdf` or `{basename}_pages_{start:03d}-{end:03d}.pdf`

## Testing

Tests use pytest. Test PDFs should be created programmatically in fixtures, not committed to repo.

## Common Tasks

### Add a new splitting mode
1. Add function to `src/pdf_splitter.py`
2. Add CLI/GUI option in `run.py`
3. Add tests in `tests/test_pdf_splitter.py`

### Update packaging
Edit `packaging/package.ps1` (Windows) or `packaging/package.sh` (Linux/macOS)
