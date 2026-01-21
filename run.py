"""Entry point for PDF splitter application."""

import sys
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent / "src"))

from pdf_splitter import split_pdf


def select_pdf_file():
    """Open a file dialog to select a PDF file."""
    import tkinter as tk
    from tkinter import filedialog

    root = tk.Tk()
    root.withdraw()  # Hide the main window

    file_path = filedialog.askopenfilename(
        title="Select PDF file to split",
        filetypes=[("PDF files", "*.pdf"), ("All files", "*.*")]
    )

    root.destroy()
    return file_path


def get_pages_per_file():
    """Open a dialog to get pages per output file."""
    import tkinter as tk
    from tkinter import simpledialog

    root = tk.Tk()
    root.withdraw()

    pages = simpledialog.askinteger(
        "Pages per file",
        "Enter number of pages per output file:\n(Leave as 1 to split into individual pages)",
        initialvalue=1,
        minvalue=1
    )

    root.destroy()
    return pages if pages else 1


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        # No argument provided - open file dialog
        pdf_file = select_pdf_file()
        if not pdf_file:
            print("No file selected.")
            sys.exit(1)
        pages_per_file = get_pages_per_file()
    else:
        pdf_file = sys.argv[1].strip('"').strip("'")
        pages_per_file = int(sys.argv[2]) if len(sys.argv) > 2 else 1

    try:
        split_pdf(pdf_file, pages_per_file=pages_per_file)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
