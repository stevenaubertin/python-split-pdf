# GitHub Interaction Skill

When asked to interact with GitHub (issues, pull requests, repositories, releases, etc.), always use the GitHub CLI (`gh`) instead of the web interface or API calls.

## Prerequisites

The `gh` CLI must be installed and authenticated:
```bash
gh auth status
```

## Common Commands

### Issues
```bash
gh issue list
gh issue create --title "Title" --body "Description"
gh issue view <number>
gh issue close <number>
```

### Pull Requests
```bash
gh pr list
gh pr create --title "Title" --body "Description"
gh pr view <number>
gh pr checkout <number>
gh pr merge <number>
gh pr review <number> --approve
```

### Repository
```bash
gh repo view
gh repo clone <owner/repo>
gh repo fork
```

### Releases
```bash
gh release list
gh release create <tag> --title "Title" --notes "Notes"
gh release download <tag>
```

### Workflow/Actions
```bash
gh run list
gh run view <run-id>
gh run watch <run-id>
```

## Guidelines

1. Always check `gh auth status` before running commands if authentication issues occur
2. Use `--help` flag for command documentation: `gh pr create --help`
3. For viewing PR/issue details, use `gh pr view` or `gh issue view`
4. When creating PRs, use heredoc for multi-line body content
