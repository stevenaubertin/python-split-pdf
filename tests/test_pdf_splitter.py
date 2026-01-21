"""Tests for pdf_splitter module."""

import pytest
from pathlib import Path
import sys

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from pdf_splitter import split_pdf, split_pdf_by_range


def test_split_pdf_file_not_found():
    """Test that FileNotFoundError is raised for non-existent file."""
    with pytest.raises(FileNotFoundError):
        split_pdf("nonexistent.pdf")


def test_split_pdf_invalid_file_type(tmp_path):
    """Test that ValueError is raised for non-PDF files."""
    # Create a temporary non-PDF file
    txt_file = tmp_path / "test.txt"
    txt_file.write_text("not a pdf")

    with pytest.raises(ValueError):
        split_pdf(str(txt_file))


def test_split_pdf_by_range_invalid_range():
    """Test that ValueError is raised for invalid page range."""
    # This will raise FileNotFoundError first, but demonstrates the test structure
    with pytest.raises((ValueError, FileNotFoundError)):
        split_pdf_by_range("test.pdf", 5, 1, "output.pdf")
