# Creative Loop V2 — Specs

A ground-up redesign of the `/creative` skill. Smaller, sharper, and built around a different theory of creativity than v1.

**One-line thesis:** Creativity is mostly *re-framing* and *wrestling with a single concrete idea*. Generation and scoring are the shallow parts. v1 industrialized the shallow parts and skipped the deep parts. v2 inverts that.

---

## What this folder is

A complete, self-contained spec set. A future Claude Code session — with no access to v1 and no memory of the conversation that produced these — should be able to build the `/creative` skill from these docs alone.

If you're that future session: read in order. Do not skip `01-philosophy.md`. The design decisions later will look arbitrary without it.

## Reading order

1. **[01-philosophy.md](01-philosophy.md)** — The stance. What we're rejecting from v1, and why. Read this first.
2. **[02-architecture.md](02-architecture.md)** — Two gears (Sharpen, Scout+Wrestle), one meta-thread, no sub-agent fan-out.
3. **[03-interaction-model.md](03-interaction-model.md)** — How the conversation actually flows. Oversight points. Tone.
4. **[04-sharpen.md](04-sharpen.md)** — The Sharpen gear. Socratic problem-refinement.
5. **[05-scout.md](05-scout.md)** — The Scout gear. Three grounded options; user picks by gut.
6. **[06-wrestle.md](06-wrestle.md)** — The Wrestle gear. Depth on the chosen idea.
7. **[07-memory-and-state.md](07-memory-and-state.md)** — What we persist and what we refuse to.
8. **[08-skill-file.md](08-skill-file.md)** — The blueprint for `SKILL.md`. Ready-to-adapt prompt templates.
9. **[09-file-layout.md](09-file-layout.md)** — Directory structure. What lives where.
10. **[10-build-plan.md](10-build-plan.md)** — Phased implementation plan for the next session.
11. **[11-test-cases.md](11-test-cases.md)** — Golden-path examples. How to evaluate success.
12. **[12-non-goals.md](12-non-goals.md)** — What this system will never do. The fence.

## TL;DR of the design

- **One command**: `/creative <problem>`. Optional flags: `/creative quick`, `/creative wrestle <idea>`.
- **One thread**: No sub-agent fan-out. Everything runs in the main conversation, sequentially.
- **Three short phases**: Sharpen (interrogate the question) → Scout (3 framings) → Wrestle (deep engagement with one).
- **No numeric scoring**: The user chooses by gut and articulated reason. No composite scores, no weighted axes.
- **No persona rotation**: A single voice that *adopts stances* as needed (analogist, critic, minimalist) — the way a skilled collaborator does.
- **No self-optimizing prompts**: `SKILL.md` is version-controlled like code. Humans edit it.
- **No per-project pattern library**: Previous ideas are not re-injected into new generations. We trust the user to remember what matters.

If any of those feel wrong to the next session, re-read `01-philosophy.md` before changing them. The rejections are load-bearing.

## What's deliberately missing

- No `specs/` folder nested inside (flat structure, 12 docs).
- No `implementation-plan.md` with phase deliverables that never get delivered. Use `10-build-plan.md` as the whole plan.
- No separate `generator.md`, `evaluator.md`, `meta-controller.md` — those components don't exist in v2, so they don't need specs.

## Target repo layout (after the skill is built)

```
creative-loop-v2/
├── SKILL.md                 ← the skill; install.sh copies this to ~/.claude/skills/creative/
├── install.sh               ← global install
├── README.md                ← user-facing intro
├── specs-v2/                ← this folder (move to v2 repo root as `specs/`)
└── examples/                ← golden-path transcripts (see 11-test-cases.md)
```

When moving to a new repo, rename `specs-v2/` → `specs/`.
