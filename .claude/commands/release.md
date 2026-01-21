---
description: Create a new release. Usage: /release <version> (e.g., /release 1.0.0)
---

You are tasked with creating a new release for this project.

## Task: Create Release {{arg "version"}}

## Workflow

### 1. Run Tests

Ensure all tests pass before releasing:

```bash
pytest tests/ -v
```

### 2. Build the Application

Run the package script to create the executable:

```powershell
powershell -File ./packaging/package.ps1
```

### 3. Update Version in pyproject.toml

Update the version number in `pyproject.toml` to match the release version.

### 4. Generate Changelog

Analyze recent commits since the last tag:

```bash
gh api repos/:owner/:repo/releases/latest --jq '.tag_name' 2>/dev/null || echo "No previous release"
git log --oneline $(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)..HEAD
```

Generate changelog covering:
- **What's New**: Features and improvements
- **Bug Fixes**: Issues resolved
- **Breaking Changes**: Incompatible changes (if any)

### 5. Commit and Tag

1. Stage and commit version changes:
   ```bash
   git add pyproject.toml
   git commit -m "release: v{{arg "version"}}

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
   ```

2. Create annotated tag:
   ```bash
   git tag -a v{{arg "version"}} -m "Release v{{arg "version"}}"
   ```

3. Push changes and tag:
   ```bash
   git push origin main
   git push origin v{{arg "version"}}
   ```

### 6. Create GitHub Release

Create the release with the built executable:

```bash
gh release create v{{arg "version"}} "./packaging/dist/PDFSplitter.exe" \
  --title "v{{arg "version"}}" \
  --notes "$(cat <<'EOF'
## What's New
- [list features]

## Bug Fixes
- [list fixes]

## Installation
Download `PDFSplitter.exe` and run it directly. No installation required.
EOF
)"
```

### 7. Report Summary

Provide:
- Release URL
- Executable size
- Changelog summary

## AI Instructions

- Use `gh` CLI for all GitHub operations
- Run tests before building
- Include the executable as a release asset
- Write clear, user-friendly release notes

## Success Criteria

- All tests pass
- Executable built successfully
- Version updated in pyproject.toml
- Git tag created and pushed
- GitHub release created with executable attached
