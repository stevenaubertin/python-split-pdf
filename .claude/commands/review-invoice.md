---
description: Review parsed invoice data vs PDF content. Usage: /review-invoice <path> (accepts single PDF or directory)
---

You are tasked with reviewing parsed invoices to validate extraction accuracy.

## Task: Review Invoice(s) at {{arg "path"}}

## Workflow

### 1. Determine Input Type

First, check if the provided path is a **file** or a **directory**:

- **If single PDF file**: Process that one file and show detailed review
- **If directory**: Process all `.pdf` files in the directory and show summary + individual reviews

### 2. For Single PDF File

Run the parser on the provided PDF:

```python
import sys
sys.path.insert(0, 'src')
from backend.parsers.extractor_manager import ExtractorManager

manager = ExtractorManager()
result, debug_info = manager.extract_invoice_data_with_debug(r'{{arg "path"}}')
```

The `debug_info` object (ExtractionDebugInfo) contains:
- `pdf_path`: Full path to the PDF
- `raw_text`: Complete extracted text
- `raw_text_preview`: First 500 characters of text
- `selected_parser`: Name of the parser used
- `selection_method`: How parser was selected ('folder', 'content', 'forced')
- `selection_reason`: Why this parser was chosen
- `parser_candidates`: List of parsers that were considered
- `ocr_used`: Whether OCR was used for extraction
- `ocr_available`: Whether OCR service is available
- `extraction_method`: "pdfplumber" or "ocr"
- `ocr_likely_needed`: True if text extraction was sparse

Then display the detailed comparison tables (see Section 4).

### 3. For Directory (Batch Mode)

Use **TodoWrite** to track batch processing progress.

Process all PDFs in the directory:

```python
import sys
from pathlib import Path
sys.path.insert(0, 'src')
from backend.parsers.extractor_manager import ExtractorManager

manager = ExtractorManager()
pdf_dir = Path(r'{{arg "path"}}')
pdf_files = sorted(pdf_dir.glob('*.pdf'))

results = []
for pdf_path in pdf_files:
    try:
        result, debug_info = manager.extract_invoice_data_with_debug(str(pdf_path))
        results.append({
            'file': pdf_path.name,
            'path': str(pdf_path),
            'success': True,
            'result': result,
            'debug': debug_info
        })
    except Exception as e:
        results.append({
            'file': pdf_path.name,
            'path': str(pdf_path),
            'success': False,
            'error': str(e)
        })
```

#### 3.1 Display Batch Summary Table

Show a summary table of all processed files:

| # | File | Parser | Method | Invoice # | Date | Products | Receiver | Status |
|---|------|--------|--------|-----------|------|----------|----------|--------|
| 1 | invoice1.pdf | Dieu du Ciel | pdfplumber | 12345 | 2024-01-15 | 3 | Minotaure | OK |
| 2 | invoice2.pdf | Generic | ocr | - | - | 0 | - | Missing fields |

**Status indicators:**
- **OK**: All key fields extracted
- **Missing fields**: Some important fields are empty
- **No products**: Products array is empty
- **OCR needed**: Parser detected image-based PDF
- **ERROR**: Parsing failed

#### 3.2 Display Summary Statistics

```
## Batch Summary

- **Total PDFs**: 17
- **Successful**: 16 (94.1%)
- **Failed**: 1 (5.9%)
- **Parser used**: Verger Petit et Fils
- **OCR used**: 3 files (17.6%)

### Field Extraction Rate
| Field | Filled | Empty | Rate |
|-------|--------|-------|------|
| numero_facture | 15 | 2 | 88% |
| date_facture | 16 | 1 | 94% |
| adresse_livraison.nom | 14 | 3 | 82% |
| adresse_livraison.rue | 16 | 1 | 94% |
| adresse_livraison.ville | 12 | 5 | 71% |
| produits (has items) | 16 | 1 | 94% |
```

#### 3.3 Then Review Each File

After the summary, go through each file one by one showing the detailed review (Section 4).
Ask the user after each review: "Continue to next invoice? (y/n/skip to #)"

### 4. Detailed Review Display (Per Invoice)

#### Extraction Info

| Field | Value |
|-------|-------|
| **PDF Path** | `[full path]` |
| **Selected Parser** | [selected_parser] |
| **Selection Method** | [selection_method] |
| **Selection Reason** | [selection_reason] |
| **Extraction Method** | [extraction_method] |
| **OCR Used** | [ocr_used] |
| **OCR Available** | [ocr_available] |

#### Document Information

| Field | Parsed Value |
|-------|--------------|
| **Invoice #** | [numero_facture] |
| **Date** | [date_facture] |

#### Supplier Address (adresse_fournisseur)

| Field | Parsed Value |
|-------|--------------|
| **Nom** | [nom] |
| **Rue** | [rue] |
| **Ville** | [ville] |
| **Code Postal** | [code_postal] |
| **Pays** | [pays] |

#### Receiver Address (adresse_livraison)

| Field | Parsed Value |
|-------|--------------|
| **Nom** | [nom] |
| **Rue** | [rue] |
| **Ville** | [ville] |
| **Code Postal** | [code_postal] |
| **Pays** | [pays] |

#### Products (produits)

| # | Code | Nom | Format | Lot | Quantite |
|---|------|-----|--------|-----|----------|
| 1 | [code] | [nom] | [format] | [lot] | [quantite] |

### 5. Show Parser Candidates

If multiple parsers were considered, show the candidates:

| Parser | Can Parse | Confidence | Reason |
|--------|-----------|------------|--------|
| Dieu du Ciel | Yes | 0.95 | Matched supplier name in header |
| Generic | Yes | 0.50 | Fallback parser |

### 6. Show Raw Text Preview

Display the first 500 characters from `debug_info.raw_text_preview` so the user can compare against parsed values.

For deeper investigation, show up to 2000 characters from `debug_info.raw_text`.

### 7. Compare with Markitdown MCP

Use the markitdown MCP tool to get an alternative text extraction and compare against parser results.

**For single file or detailed review:**

1. Call the markitdown MCP tool to convert the PDF to markdown:
   ```
   mcp__markitdown__convert_to_markdown with uri: "file:///path/to/invoice.pdf"
   ```

2. Display a comparison table showing key fields:

| Field | Parser Value | Found in Markitdown? |
|-------|--------------|---------------------|
| Invoice # | 12345 | Yes |
| Date | 2024-01-15 | Yes |
| Receiver Name | Minotaure | Yes |
| Product Count | 3 | Yes (3 items found) |

3. Check if extracted values appear in the markitdown output:
   - Search for `numero_facture` value in markitdown text
   - Search for `date_facture` value
   - Search for `adresse_livraison.nom` value
   - Search for product names

4. Highlight discrepancies:
   - **Missing in markitdown**: Value extracted by parser but not found in markitdown (may indicate OCR issue in markitdown)
   - **Different format**: Same data but formatted differently (date formats, spacing)
   - **Parser missed**: Data visible in markitdown but not extracted by parser (indicates parser bug)

**Example comparison output:**

```
### Markitdown Comparison

| Field | Parser | In Markitdown | Status |
|-------|--------|---------------|--------|
| Invoice # | SO-90309 | Yes | OK |
| Date | 2024-01-15 | Yes (15 janvier 2024) | Format differs |
| Receiver | DEPANNEUR GIGUERE 2016 inc | Yes | OK |
| Product: Péché Mortel | Found | Yes | OK |

**Markitdown Text Preview (first 1000 chars):**
[markitdown output here]
```

**For batch mode:** Skip markitdown comparison in the summary table (too slow for many files). Only run markitdown comparison during detailed individual reviews.

### 8. Identify Issues

After displaying the tables:
1. Highlight any **empty or missing fields** that should have values
2. Note any **suspicious values** that may indicate parsing errors
3. Suggest **specific regex patterns** that might need adjustment
4. Flag if **OCR might help** (when ocr_likely_needed is True but ocr_used is False)

## AI Instructions

- **Check if path is file or directory** before processing
- **Always read the PDF** using the parser before displaying results
- Use **ExtractorManager.extract_invoice_data_with_debug()** to get both parsed data and debug info
- Display the **full absolute path** of each PDF for easy reference
- Format tables in **markdown** for clear comparison
- Show **extraction method** (pdfplumber vs OCR) for each invoice
- Show **parser selection info** to help debug parser mismatches
- Show **raw text preview** to help identify extraction issues
- If parsing fails, show the error and raw text to help diagnose
- Use **TodoWrite** for batch mode to track progress
- For batch mode:
  - Show summary table first (including extraction method column)
  - Calculate and display field extraction statistics
  - Report OCR usage statistics
  - Then offer to review each invoice individually
  - Track which invoices have issues for focused review
- **Markitdown comparison** (for detailed reviews only):
  - Use `mcp__markitdown__convert_to_markdown` tool with `file:///` URI
  - Convert Windows paths to URI format: `C:\path\to\file.pdf` → `file:///C:/path/to/file.pdf`
  - Search markitdown output for parser-extracted values
  - Report which fields match, differ, or are missing
  - Skip markitdown in batch summary (too slow), only use in individual detailed reviews

## Example Output Format (Single File)

```
## Invoice Review: invoice_123.pdf

### Extraction Info
| Field | Value |
|-------|-------|
| **PDF Path** | `C:\Users\x0r\repo\...\invoice_123.pdf` |
| **Parser** | Dieu du Ciel |
| **Selection** | content - Matched "Dieu du Ciel" in header |
| **Method** | pdfplumber |
| **OCR Used** | No |

### Document Info
| Field | Parsed Value |
|-------|--------------|
| Invoice # | 12345 |
| Date | 2024-01-15 |

### Supplier Address
...

### Receiver Address
...

### Products (3 found)
...

### Parser Candidates
| Parser | Can Parse | Confidence |
|--------|-----------|------------|
| Dieu du Ciel | Yes | 0.95 |

### Raw Text Preview (first 500 chars)
[raw text here]

### Markitdown Comparison
| Field | Parser | In Markitdown | Status |
|-------|--------|---------------|--------|
| Invoice # | 12345 | Yes | OK |
| Date | 2024-01-15 | Yes | OK |
| Receiver | Minotaure | Yes | OK |

### Issues Detected
- Receiver city is empty
- Date format may be incorrect
```

## Example Output Format (Directory)

```
## Batch Invoice Review: C:\path\to\invoices\

**Total PDFs found:** 17

### Summary Table
| # | File | Parser | Method | Invoice # | Products | Status |
|---|------|--------|--------|-----------|----------|--------|
| 1 | SO-90309.pdf | Dieu du Ciel | pdfplumber | SO-90309 | 2 | OK |
| 2 | SO-90310.pdf | Generic | ocr | SO-90310 | 0 | Missing fields |
...

### Statistics
- Success rate: 94.1% (16/17)
- Average products per invoice: 2.3
- OCR used: 3 files (17.6%)

### Field Extraction Rates
| Field | Rate |
|-------|------|
| Invoice # | 100% |
| Date | 88% |
...

---
## Detailed Reviews

### Invoice 1: SO-90309.pdf
[detailed tables...]

Continue to next? (y/n/skip to #)
```

## Success Criteria

- Correctly detect file vs directory input
- For directories: summary table with all PDFs (including extraction method)
- For directories: field extraction and OCR usage statistics
- Full PDF path displayed for reference
- Parser selection info displayed (method, reason, candidates)
- Extraction method shown (pdfplumber vs OCR)
- All address fields shown in tables
- Products listed with all fields
- Raw text available for comparison
- Issues clearly highlighted with OCR recommendations when applicable
- **Markitdown comparison** shown for detailed reviews (single file or individual batch review)
- Discrepancies between parser and markitdown clearly highlighted
