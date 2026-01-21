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
  - `testing` - Test-related changes
  - `ui` - GUI/tkinter related

### 2. Assess Complexity

Evaluate if this issue requires planning:
- **Simple**: Single file change, bug fix, small enhancement
- **Medium**: Multiple files, new feature, moderate refactoring
- **Complex**: Architectural changes, major feature

### 3. Create the Issue

Use `gh issue create` to create the issue:

```bash
gh issue create --title "<title>" --body "<body>" --label "<labels>"
```

### 4. Ask User About Next Steps

After creating the issue, ask the user:

1. **Start working now?**
   - If yes, add the `in-progress` label
   - Create a branch following the naming convention

2. **Create a new branch?**
   - `feature/<issue-number>-<short-description>` for enhancements
   - `fix/<issue-number>-<short-description>` for bugs
   - `docs/<issue-number>-<short-description>` for documentation
   - Use: `git checkout -b <branch-name>`

3. **Enter plan mode?** (for medium/complex issues)
   - If the issue is non-trivial, suggest entering plan mode to design the implementation approach

## AI Instructions

- Parse the user's description to extract a clear title and detailed body
- Infer appropriate labels from keywords in the description
- If the description is vague, ask clarifying questions
- Report the issue URL back to the user after creation
- When the user decides to start working, add the `in-progress` label before creating branches

## Example Interactions

**Simple bug:**
```
/new-issue The file dialog crashes when selecting a non-PDF file
```
Creates issue with `bug` and `ui` labels.

**New feature:**
```
/new-issue Add support for merging PDFs
```
Creates issue with `enhancement` label, suggests plan mode due to complexity.

## Success Criteria

- Issue created with appropriate title, body, and labels
- User informed of issue number and URL
- Next steps offered (start work, create branch, plan mode)
