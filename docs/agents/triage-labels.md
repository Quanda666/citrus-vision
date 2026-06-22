# Triage Labels

## Label vocabulary

The five canonical triage states and their corresponding GitHub label strings:

| Role | GitHub Label | Meaning |
|------|--------------|---------|
| Needs triage | `needs-triage` | Maintainer needs to evaluate this issue |
| Needs info | `needs-info` | Waiting on the reporter to provide more information |
| Ready for agent | `ready-for-agent` | Fully specified; an AFK agent can pick this up with no human context |
| Ready for human | `ready-for-human` | Needs human implementation |
| Won't fix | `wontfix` | Will not be actioned |

## Usage

When the `triage` skill processes an issue, it applies these labels to move the issue through its state machine.

If your repo uses different label names, edit the mappings above so skills apply the correct labels instead of creating duplicates.
