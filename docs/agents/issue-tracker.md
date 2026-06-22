# Issue Tracker

## Where issues live

This repo uses **GitHub Issues** as its issue tracker.

Skills that read from or write to the issue tracker (`triage`, `qa`, `to-issues`, etc.) use the `gh` CLI to interact with GitHub Issues.

## PRs as a request surface

**Enabled.** External pull requests (from non-collaborators) are treated as issues for triage purposes. The `/triage` skill will label and process them through the same state machine as regular issues.

Collaborator PRs (in-flight work from team members) are left alone.

## Commands

- Create an issue: `gh issue create --title "..." --body "..."`
- List issues: `gh issue list`
- View an issue: `gh issue view <number>`
- Add labels: `gh issue edit <number> --add-label "label-name"`
- Close an issue: `gh issue close <number>`
