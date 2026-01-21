---
description: Push, create PR linked to issue, monitor checks, and merge. Usage: /push-pr [issue-number]
---

# Push and Monitor PR

Execute the full push-to-merge workflow with automated check monitoring.

**Issue Reference:** {{arg "issue"}}

## Workflow

### Step 1: Validate Current State

Check the current git state before proceeding:

```pwsh
git status
git branch --show-current
```

- Ensure there are commits to push
- Identify the current branch name
- Extract issue number from branch name if not provided (e.g., `feature/123-description` → issue #123)

**IMPORTANT**: If on `master` or `main`, STOP and ask the user to create a feature branch first.

### Step 2: Push to Remote

Push the current branch to origin:

```pwsh
git push -u origin HEAD
```

If the push fails, report the error and ask the user how to proceed.

### Step 3: Create Pull Request

Create a PR linking to the issue:

```pwsh
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

```pwsh
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
   ```pwsh
   gh pr merge --squash --delete-branch
   ```
3. Pull the latest changes:
   ```pwsh
   git checkout master && git pull
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
   - If user selects an issue, ask: **"Do you want to start working on this issue now?"**
     - **If YES** → Go to Step 7 (Start Work)
     - **If NO** → Issue stays in backlog, stay on master

2. **Create a new issue?**
   - Use `/new-issue` command to create the issue first
   - After issue is created, `/new-issue` will ask if user wants to start work
   - The issue must exist BEFORE any work begins

3. **Done for now?**
   - Stay on master, ready for next session

### Step 7: Start Work on Issue (Only When User Confirms)

**CRITICAL**: This step only runs when the user explicitly decides to start working.

**Order of operations is mandatory:**

1. **FIRST - Mark issue as "In Progress":**
   ```pwsh
   gh issue edit <issue-number> --add-label "in-progress"
   ```
   This MUST happen before creating a branch or any other work.

2. **THEN - Create feature branch:**
   ```pwsh
   git checkout -b feature/<issue-number>-<short-description>
   ```
   Branch naming convention:
   - `feature/<issue>-<desc>` for enhancements
   - `fix/<issue>-<desc>` for bug fixes
   - `docs/<issue>-<desc>` for documentation

3. **Report to user:**
   - Confirm issue is now "in progress"
   - Confirm branch created
   - Ready to begin implementation

**If user does NOT want to start work**, the issue remains in the backlog (no label change, no branch created).

## AI Instructions

- Parse the issue number from the branch name if not provided as argument
- Branch naming convention: `feature/<issue>-<desc>`, `fix/<issue>-<desc>`, etc.
- Use `TodoWrite` to track each step of the workflow
- If `gh pr checks --watch` times out, use polling with `gh pr checks` every 30 seconds
- Always report the PR URL after creation
- When merging, prefer squash merge to keep history clean
- After merge, ensure local master is up to date before creating new branches
- **CRITICAL - Issue-First Workflow:**
  1. An issue MUST exist before any work begins (either selected from backlog or created via `/new-issue`)
  2. Only mark an issue "in-progress" when the user explicitly decides to start working
  3. The "in-progress" label MUST be added BEFORE creating any branch
  4. If user doesn't want to start work, the issue stays in backlog unchanged

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
Auto-detects issue number from branch name (e.g., `feature/234-endpoint-health-check` → #234).
