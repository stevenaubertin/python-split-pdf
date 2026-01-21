---
description: Create a new release with AI-generated changelog. Usage: /release <version> (e.g., /release 3.3 or /release v3.3.0)
---

You are tasked with creating a new release for this project.

**For detailed documentation, troubleshooting, and best practices, see `releases/RELEASE_GUIDE.md`**

## Task: Create Release {{arg "version"}}

## Workflow

### 1. Update Version in Code

First, ensure `src\__version__.py` is updated to the release version:

Execute: `python scripts\bump_version.py {{arg "version"}}`

This updates `__version__` to match the release tag. If the version is already set correctly, this step confirms it.

### 2. Run Release Script

Execute: `powershell -File releases\create_release.ps1 -Version {{arg "version"}} -SkipPipeline -Force`

Flags:
- `-SkipPipeline`: Fast build (skip second validation pipeline run)
- `-Force`: Skip prompts for uncommitted changes

The script will:
1. Run pre-flight checks (git status, version conflicts)
2. **Validate version consistency** between git tag and `src\__version__.py`
3. **Run test suite** (automated_pipeline.py) - stops if tests fail
4. Build the executable
5. Generate `CHANGELOG_CONTEXT.md`
6. **Create zip archive** (`CommandeIndependantes-v<version>.zip`) for distribution
7. Optionally run validation pipeline again (unless -SkipPipeline)

### 2. Generate AI Changelog

Read `releases\<version>\CHANGELOG_CONTEXT.md` and analyze:
- Git commits and changed files
- Diff statistics
- Project context

Generate comprehensive changelog covering:
- **What's New**: Features and improvements
- **Bug Fixes**: Issues resolved
- **Breaking Changes**: Incompatible changes (if any)
- **Technical Details**: Implementation notes
- **Known Issues**: Current limitations
- **Next Steps**: Planned improvements

### 3. Update Release Files

1. **Create** `releases\<version>\CHANGE_LOG.md` with detailed changelog
2. **Update** `releases\<version>\RELEASE_NOTES.md` - replace `*[AI GENERATED CONTENT PLACEHOLDER]*` with changelog summary

### 4. Commit and Push

1. **Stage changes**: `git add src/__version__.py releases/<version>/`
2. **Commit**: Create a commit with message:
   ```
   release: v<version>

   Features:
   - [list key features from changelog]

   Bug Fixes:
   - [list key fixes from changelog]

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   ```
3. **Push**: `git push origin master`

### 5. Create Git Tag

1. **Create annotated tag**: `git tag -a v<version> -m "Release v<version> - <brief description>"`
2. **Push tag**: `git push origin v<version>`

### 6. Create GitHub Release

1. **Create release with zip archive**:
   ```bash
   gh release create v<version> "releases/v<version>/CommandeIndependantes-v<version>.zip" \
     --title "v<version> - <brief description>" \
     --notes "<release notes content>"
   ```

   Release notes should include:
   - What's New (features)
   - Bug Fixes
   - Installation instructions (download zip, extract, run exe)
   - Stats (files changed, zip size)

### 7. Report Summary

Provide:
- Release location and GitHub release URL
- Generated files list
- Commit hash and tag created
- Confirmation that artifact was uploaded

## AI Instructions

- Use **TodoWrite** to track multi-step progress
- Be **thorough** when analyzing git commits
- Use **professional language** in changelogs
- Include **commit hashes** where relevant
- If script fails, help diagnose the issue

## Reference

For complete process details: `releases/RELEASE_GUIDE.md`

## Success Criteria

- ✅ All tests passed
- ✅ `releases\<version>\` folder created
- ✅ Executable built successfully
- ✅ Zip archive created (`CommandeIndependantes-v<version>.zip`)
- ✅ `CHANGE_LOG.md` created with AI analysis
- ✅ `RELEASE_NOTES.md` updated with summary
- ✅ Changes committed and pushed to remote
- ✅ Git tag `v<version>` created and pushed
- ✅ GitHub release created with zip artifact uploaded
- ✅ GitHub release notes populated
