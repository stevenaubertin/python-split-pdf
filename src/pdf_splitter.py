"""PDF splitting functionality."""

from pathlib import Path
from pypdf import PdfReader, PdfWriter


def split_pdf(input_path: str, output_dir: str = "output", pages_per_file: int = 1) -> list[str]:
    """
    Split a PDF file into multiple files.

    Args:
        input_path: Path to the input PDF file
        output_dir: Directory to save the split pages (default: "output")
        pages_per_file: Number of pages per output file (default: 1)

    Returns:
        List of paths to the generated PDF files
    """
    input_file = Path(input_path)
    if not input_file.exists():
        raise FileNotFoundError(f"File not found: {input_path}")

    if not input_file.suffix.lower() == ".pdf":
        raise ValueError(f"File must be a PDF: {input_path}")

    # Create output directory
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    # Read the PDF
    reader = PdfReader(input_file)
    total_pages = len(reader.pages)

    num_files = (total_pages + pages_per_file - 1) // pages_per_file
    print(f"Splitting {input_file.name} ({total_pages} pages) into {num_files} files...")

    output_files = []
    base_name = input_file.stem

    # Split into groups of pages
    for file_num in range(num_files):
        writer = PdfWriter()
        start_page = file_num * pages_per_file
        end_page = min(start_page + pages_per_file, total_pages)

        for page_num in range(start_page, end_page):
            writer.add_page(reader.pages[page_num])

        # Create output filename
        if pages_per_file == 1:
            output_filename = output_path / f"{base_name}_page_{start_page + 1:03d}.pdf"
        else:
            output_filename = output_path / f"{base_name}_pages_{start_page + 1:03d}-{end_page:03d}.pdf"

        with open(output_filename, "wb") as output_file:
            writer.write(output_file)

        output_files.append(str(output_filename))
        print(f"  Created: {output_filename.name}")

    print(f"\nSuccessfully created {num_files} files in {output_dir}/")
    return output_files


def split_pdf_by_range(input_path: str, start: int, end: int, output_path: str) -> str:
    """
    Extract a range of pages from a PDF file.
    
    Args:
        input_path: Path to the input PDF file
        start: Starting page number (1-indexed)
        end: Ending page number (1-indexed, inclusive)
        output_path: Path for the output PDF file
    
    Returns:
        Path to the generated PDF file
    """
    input_file = Path(input_path)
    if not input_file.exists():
        raise FileNotFoundError(f"File not found: {input_path}")
    
    reader = PdfReader(input_file)
    total_pages = len(reader.pages)
    
    if start < 1 or end > total_pages or start > end:
        raise ValueError(
            f"Invalid range: {start}-{end}. PDF has {total_pages} pages."
        )
    
    writer = PdfWriter()
    
    # Add pages in range (convert to 0-indexed)
    for page_num in range(start - 1, end):
        writer.add_page(reader.pages[page_num])
    
    # Write output
    output_file = Path(output_path)
    output_file.parent.mkdir(parents=True, exist_ok=True)
    
    with open(output_file, "wb") as f:
        writer.write(f)
    
    print(f"Extracted pages {start}-{end} to {output_path}")
    return str(output_file)
