---
description: Push and Monitor PR
---

# Push and Monitor PR

Execute the full push-to-merge workflow with automated check monitoring.

**Issue Reference:** {{arg "issue"}}

## Workflow

### Step 1: Validate Current State

Check the current git state before proceeding:

```bash
git status
git branch --show-current
```

- Ensure there are commits to push
- Identify the current branch name
- Extract issue number from branch name if not provided (e.g., `feature/123-description` → issue #123)

**IMPORTANT**: If on `main`, STOP and ask the user to create a feature branch first.

### Step 2: Push to Remote

Push the current branch to origin:

```bash
git push -u origin HEAD
```

If the push fails, report the error and ask the user how to proceed.

### Step 3: Create Pull Request

Create a PR linking to the issue:

```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<brief description of changes>

## Linked Issue
Closes #<issue-number>

## Test Plan
- [ ] Tests pass locally
- [ ] Build succeeds

---
Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

**Title format**: Use the conventional commit format matching the issue type:
- `feat: <description>` for features
- `fix: <description>` for bug fixes
- `docs: <description>` for documentation
- `refactor: <description>` for refactoring

If a PR already exists for this branch, skip creation and use the existing PR.

### Step 4: Monitor PR Checks

Poll the PR status until all checks complete:

```bash
gh pr checks --watch
```

Report the status to the user:
- **Pending**: "Checks are running..."
- **Success**: "All checks passed!"
- **Failure**: Report which checks failed and ask user how to proceed

### Step 5: Handle Check Results

**If checks PASS:**
1. Ask user for confirmation to merge
2. Merge the PR using squash merge:
   ```bash
   gh pr merge --squash --delete-branch
   ```
3. Pull the latest changes:
   ```bash
   git checkout main && git pull
   ```

**If checks FAIL:**
1. Report which checks failed
2. Offer options:
   - **Investigate**: Help debug the failing checks
   - **Fix and retry**: Make fixes and re-push
   - **Close PR**: Close without merging
   - **Wait**: Leave PR open for manual intervention

### Step 6: Next Steps (After Merge)

After successful merge, ask the user what they want to do next:

1. **Work on an existing issue?**
   - List open issues: `gh issue list --state open --limit 5`

2. **Create a new issue?**
   - Use `/new-issue` command

3. **Done for now?**
   - Stay on main, ready for next session

## AI Instructions

- Parse the issue number from the branch name if not provided as argument
- Branch naming convention: `feature/<issue>-<desc>`, `fix/<issue>-<desc>`, etc.
- Always report the PR URL after creation
- When merging, prefer squash merge to keep history clean
- After merge, ensure local main is up to date before creating new branches

## Error Handling

- **Push rejected**: Suggest `git pull --rebase` first
- **PR creation fails**: Check if PR already exists with `gh pr list`
- **Checks timeout**: Offer to continue monitoring or proceed manually
- **Merge conflicts**: Report and offer to help resolve

## Example Usage

```
/push-pr 234
```
Pushes current branch, creates PR referencing issue #234, monitors checks, merges on success.

```
/push-pr
```
Auto-detects issue number from branch name (e.g., `feature/234-add-merge-feature` → #234).
