---
description: Create a new GitHub issue. Usage: /new-issue <title or description>
---

You are tasked with creating a new GitHub issue for this project.

## Task: Create Issue

**User Input:** {{arg "description"}}

## Workflow

### 1. Analyze the Issue

Based on the user's description, determine:
- **Title**: A concise, descriptive title
- **Body**: Detailed description of the issue
- **Labels**: Appropriate labels based on the nature of the issue:
  - `bug` - Something isn't working
  - `enhancement` - New feature or improvement
  - `documentation` - Documentation updates
  - `refactor` - Code refactoring
  - `performance` - Performance improvements
  - `testing` - Test-related changes
  - `chore` - Maintenance tasks
  - `parser` - PDF parser related
  - `api` - PivoHub API related
  - `ui` - Frontend/GUI related

### 2. Assess Complexity

Evaluate if this issue requires planning:
- **Simple**: Single file change, bug fix, small enhancement
- **Medium**: Multiple files, new feature, moderate refactoring
- **Complex**: Architectural changes, new parser, major feature

### 3. Create the Issue

Use `gh issue create` to create the issue:

```pwsh
gh issue create --title "<title>" --body "<body>" --label "<labels>"
```

### 4. Ask User About Next Steps

After creating the issue, ask the user:

1. **Start working now?**
   - If yes, **IMMEDIATELY move the issue to "In Progress" status** before any other work
   - Use GitHub CLI to update the project board status:
     ```pwsh
     gh issue edit <number> --add-label "in-progress"
     ```
   - This step is **mandatory** when starting work - never skip it

2. **Create a new branch?**
   - **Move the issue to "Ready" status** before any other work
   - If yes, create a branch following the naming convention:
   - `feature/<issue-number>-<short-description>` for enhancements
   - `fix/<issue-number>-<short-description>` for bugs
   - `docs/<issue-number>-<short-description>` for documentation
   - Use: `git checkout -b <branch-name>`

3. **Enter plan mode?** (for medium/complex issues)
   - If the issue is non-trivial, suggest entering plan mode to design the implementation approach
   - Use `EnterPlanMode` tool if user agrees
   - **IMMEDIATELY move the issue to "In Progress" status** before any other work

## AI Instructions

- Parse the user's description to extract a clear title and detailed body
- Infer appropriate labels from keywords in the description
- If the description is vague, ask clarifying questions using `AskUserQuestion`
- Use `TodoWrite` to track progress for multi-step workflows
- When creating branches, ensure the current working tree is clean first
- Report the issue URL back to the user after creation
- **CRITICAL**: When the user decides to start working on an issue, you MUST immediately move it to "In Progress" status by adding the `in-progress` label. This must happen before creating branches or any other work

## Example Interactions

**Simple bug:**
```
/new-issue The settings dialog crashes when clicking save with empty fields
```
Creates issue with `bug` and `ui` labels, offers to start immediately.

**New feature:**
```
/new-issue Add support for parsing invoices from Supplier XYZ
```
Creates issue with `enhancement` and `parser` labels, suggests plan mode due to complexity.

**Refactoring:**
```
/new-issue Refactor the caching system to use async operations
```
Creates issue with `refactor` and `performance` labels, recommends plan mode.

## Success Criteria

- Issue created with appropriate title, body, and labels
- User informed of issue number and URL
- Next steps offered (start work, create branch, plan mode)
- **If user starts work, issue MUST be marked as "in-progress" FIRST, then branch created if requested**
