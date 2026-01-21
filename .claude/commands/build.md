---
description: Build the application (run tests, clean, build, verify). Usage: /build
---

# Build Application

Execute the full build sequence for the application. Follow these steps in order:

## Step 1: Run All Tests
Run the complete test suite to ensure the codebase is stable before building.

```
../venv/Scripts/python -m pytest tests/ -v
```

## Step 2: Clean Previous Build
Run the clean script to remove any previous build artifacts.

```
powershell -File ./packaging/clean.ps1
```

## Step 3: Build the Application
Run the package script to create the executable.

```
powershell -File ./packaging/package.ps1
```

## Step 4: Verify the Build
Start the built application to verify it launches correctly.

```
./packaging/dist/*.exe
```

## Step 5: Create Distribution Zip
Create a zip archive with the executable and dependencies for distribution.

```powershell
$distDir = "packaging/dist"
$zipName = "CommandeIndependantes-build.zip"
$filesToZip = @(
    "$distDir/CommandeIndependantes.exe",
    ".env.example",
    "README.md"
)
$existingFiles = $filesToZip | Where-Object { Test-Path $_ }
Compress-Archive -Path $existingFiles -DestinationPath "$distDir/$zipName" -Force
Write-Host "Created: $distDir/$zipName"
Get-Item "$distDir/$zipName" | Select-Object Name, @{N='Size (MB)';E={[math]::Round($_.Length/1MB,2)}}
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
