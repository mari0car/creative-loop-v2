# 09 — File Layout

The full surface area of the system. Tiny on purpose.

---

## 1. The repo

```
creative-loop-v2/                        ← new repo after moving specs
├── README.md                            ← user-facing intro, install + usage
├── LICENSE                              ← MIT or whatever the v1 repo used
├── SKILL.md                             ← the skill; install.sh copies this
├── install.sh                           ← ~10 lines, see 08-skill-file.md §4
├── .gitignore                           ← ignore creative-sessions/ by default
├── specs/                               ← move specs-v2/ here on new repo init
│   ├── README.md
│   ├── 01-philosophy.md
│   ├── 02-architecture.md
│   ├── 03-interaction-model.md
│   ├── 04-sharpen.md
│   ├── 05-scout.md
│   ├── 06-wrestle.md
│   ├── 07-memory-and-state.md
│   ├── 08-skill-file.md
│   ├── 09-file-layout.md
│   ├── 10-build-plan.md
│   ├── 11-test-cases.md
│   └── 12-non-goals.md
└── examples/                            ← golden-path transcripts
    ├── rate-limiting-full.md
    ├── pagination-self-resolves.md
    └── module-naming-quick.md
```

That's the entire repo.

**Not in the repo:**
- No `.creative-loop/` folder (the v1 scaffold)
- No `personas/` folder
- No `prompts/` folder
- No `patterns/` folder
- No `config.json`
- No `.creative-loop/sessions/` folder

If any of those appear, something has slipped — re-read `01-philosophy.md §5`.

## 2. What the installer writes

After `bash install.sh`, the user's machine has exactly one file added:

```
~/.claude/skills/creative/SKILL.md
```

Nothing else. No personas directory, no default config, no skills sidecar. One file.

## 3. What a project using the skill looks like

A project that uses `/creative` has, by default, nothing added to it. The skill doesn't require init, doesn't create folders, doesn't leave scaffolding.

If the user invokes `/creative save` or `/creative note`, then — and only then — these files appear:

```
<project-root>/
├── creative-sessions/            ← appears on first /creative save
│   └── 2026-04-22-1430-rate-limiting.md
├── creative-notes.md             ← appears on first /creative note
└── (rest of the project)
```

Both are plain markdown the user can read and edit. See `07-memory-and-state.md §3`.

## 4. The README.md (user-facing)

Short. Something like:

```markdown
# Creative — a sparring partner for open design questions

Not a brainstorming machine. Not a ranked-idea generator. A small skill that
sharpens the question, shows you three genuinely different angles, and then
goes deep on the one you pick.

## Install

    bash install.sh

This copies SKILL.md into ~/.claude/skills/creative/. Claude Code picks it up
automatically — type /creative in any session.

## Use

    /creative <your open design question>

That's the whole thing. Three gears (Sharpen → Scout → Wrestle) run in the
main conversation. No sub-agents, no scores, no scaffolding files in your
project unless you ask.

If the question resolves after Sharpen, the skill stops there. If you know
your direction after Scout, it stops there. Depth over breadth.

## Other entry points

    /creative sharpen <problem>     — sharpen only
    /creative scout <refined>       — skip sharpen, go to three angles
    /creative wrestle <idea>        — go deep on an idea you already have
    /creative save                  — save this session to creative-sessions/
    /creative note <text>           — append to creative-notes.md

## Philosophy

See specs/01-philosophy.md for why this is a single-thread, no-scoring,
no-memory system. The short version: v1 industrialized the shallow parts of
creativity (generation, scoring) and skipped the deep parts (re-framing,
wrestling). v2 inverts that.
```

## 5. Git hygiene

### 5.1 Default `.gitignore`

```
creative-sessions/
```

Rationale: session transcripts are often exploratory and personal. The user opts into commit by deleting this line.

Not ignored: `creative-notes.md`. Those are typically project documentation.

### 5.2 What NOT to gitignore

Do not gitignore `SKILL.md` or `specs/`. These are the repo's product.

## 6. Moving the specs to a new repo

Instructions for the user (or the next session):

```bash
# assuming you're in the current creative-loop directory
mkdir ../creative-loop-v2
cp -r specs-v2 ../creative-loop-v2/specs
cp LICENSE ../creative-loop-v2/    # if keeping the license
cd ../creative-loop-v2
git init
# then build SKILL.md per specs/08-skill-file.md and install.sh per specs/08-skill-file.md §4
```

After this, the new repo has `specs/` (renamed from `specs-v2/`), and the next session can work from there with no v1 dependency.

## 7. No component files

v1 had `personas/builtin/*.md`, `prompts/*.md`, etc. — separate files for each component. v2 has none of that.

All persona-like stance instructions live inside `SKILL.md`. All phase instructions live inside `SKILL.md`. One file, under 250 lines. If a section grows large enough to tempt extraction, that's the signal to cut it, not to split it.

## 8. Summary of the full footprint

| File | Lines | Purpose |
|---|---|---|
| `SKILL.md` | ~215 | The skill itself |
| `install.sh` | ~10 | Copies SKILL.md to ~/.claude/skills/creative/ |
| `README.md` | ~40 | User-facing intro |
| `specs/*.md` | varies | Design docs (this folder) |
| `examples/*.md` | varies | Golden-path transcripts |

The skill is ~225 lines of actual shipped code/config. The specs are the rationale for those 225 lines. The examples are how you know it works.
