# Domain Docs

## Layout

This repo uses a **single-context** layout:

- One `CONTEXT.md` at the repo root
- One `docs/adr/` directory at the repo root for architectural decision records (ADRs)

## Consumer rules

Skills that read domain context (`improve-codebase-architecture`, `diagnosing-bugs`, `tdd`, etc.) will:

1. Read `CONTEXT.md` to learn the project's domain language, ubiquitous vocabulary, and key concepts
2. Read ADRs from `docs/adr/` to understand past architectural decisions and their rationale

## What goes in CONTEXT.md

- Domain terminology and ubiquitous language
- Key business rules and invariants
- High-level architecture overview
- Important constraints and assumptions
- Links to related ADRs

## What goes in docs/adr/

Architectural Decision Records — one markdown file per decision, following the ADR format:

- **Title** — the decision in a short phrase
- **Status** — proposed, accepted, deprecated, superseded
- **Context** — the forces at play
- **Decision** — what was decided
- **Consequences** — the resulting context after the decision
