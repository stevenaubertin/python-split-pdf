---
description: Build Application
---

# Build Application

Execute the full build sequence for PDF Splitter. Follow these steps in order:

## Step 1: Run All Tests

Run the complete test suite to ensure the codebase is stable before building.

```bash
pytest tests/ -v
```

## Step 2: Clean Previous Build

Run the clean script to remove any previous build artifacts.

```powershell
powershell -File ./packaging/clean.ps1
```

## Step 3: Build the Application

Run the package script to create the executable.

```powershell
powershell -File ./packaging/package.ps1
```

## Step 4: Verify the Build

Check the built executable exists and show its size.

```powershell
Get-Item "./packaging/dist/PDFSplitter.exe" | Select-Object Name, @{N='Size (MB)';E={[math]::Round($_.Length/1MB,2)}}
```

## Failure Handling

**IMPORTANT**: If any step fails, immediately STOP the process and:

1. Report the failure clearly, including the error message and which step failed
2. Ask the user what they want to do next
3. Provide these suggestions:
   - **Retry**: Attempt the failed step again
   - **Skip**: Continue to the next step (warn that this may cause issues)
   - **Investigate**: Help debug the issue by examining logs or code
   - **Abort**: Stop the build process entirely

Do not proceed to the next step until the current step succeeds or the user explicitly chooses to skip.
