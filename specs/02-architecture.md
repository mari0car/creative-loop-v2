# 02 — Architecture

## 1. The shape

Two gears. One thread. No fan-out.

```
┌────────────────────────────────────────────────────────────┐
│                  /creative <problem>                        │
│                                                             │
│   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐  │
│   │  SHARPEN     │ → │  SCOUT       │ → │  WRESTLE     │  │
│   │  (interrogate│   │  (3 framings,│   │  (depth on   │  │
│   │   the problem│   │   user picks │   │   one idea)  │  │
│   │   statement) │   │   by gut)    │   │              │  │
│   └──────────────┘   └──────────────┘   └──────────────┘  │
│          │                   │                   │         │
│          │ (may exit here    │ (may exit here    │         │
│          │  — sharpening     │  — user knows     │         │
│          │  often resolves   │  which one)       │         │
│          │  the question)    │                   │         │
│                                                             │
│              All three run in the main thread.              │
│              No sub-agents. No parallel calls.              │
└────────────────────────────────────────────────────────────┘
```

## 2. Why one thread

From 01-philosophy.md §1.3: cumulative reasoning matters. Each step needs to build on the previous. Fan-out-fan-in breaks this.

Concretely:

- Sharpen surfaces what the user actually means. Scout must use that surfaced framing, not the original statement.
- Scout produces three options. Wrestle must engage with one *and* remember the other two as the counter-examples it's being chosen over.
- Sub-agents can't see each other; the main thread can. Use that.

This also collapses the v1 meta-controller (which v1 itself described as "the main conversation thread anyway") — so we just own it.

## 3. Components

### 3.1 The three gears

| Gear | Input | Output | Exit condition |
|---|---|---|---|
| **Sharpen** | Raw user request + relevant project context | A refined problem statement the user confirms, or a resolved question | User confirms framing *or* says "that's actually the answer" |
| **Scout** | Refined problem statement | Three distinct framings of an approach, each 3–5 sentences, no scores | User picks one, asks for one more round, or exits |
| **Wrestle** | One chosen framing + the two rejected as context | A structured deep-dive: mechanism, steelman, attack, variants, killer-question | User has what they need, or re-enters Sharpen with new info |

Each gear is a section of the `SKILL.md` file with its own prompt stance. See `08-skill-file.md` for templates.

### 3.2 What isn't a component

We deliberately do not have:

- A generator component (absorbed into Scout; one call, not fan-out)
- An evaluator component (removed entirely; user evaluates)
- A meta-controller (the main thread IS the controller)
- A memory retriever (no auto-retrieval; see 07-memory-and-state.md)
- An experiment runner (Wrestle includes an optional "smallest falsifier" step — see 06-wrestle.md — but nothing more)
- A self-optimizer (edit `SKILL.md` by hand)

## 4. Data flow

```
user input ──► Sharpen prompt stance ──► refined problem (confirmed by user)
                                                  │
                                                  ▼
                           ┌───────────────────────┐
                           │ Scout prompt stance    │
                           │ produces 3 framings    │
                           │ (numbered, no scores)  │
                           └───────────────────────┘
                                                  │
                                                  ▼
                           user picks #N or asks for alternates
                                                  │
                                                  ▼
                           ┌───────────────────────┐
                           │ Wrestle prompt stance  │
                           │ depth on chosen one    │
                           └───────────────────────┘
                                                  │
                                                  ▼
                                   final deliverable to user
                                   (see 06-wrestle.md §3)
```

## 5. State

Session state is the conversation itself. No JSON files written during the loop. Optionally, at the end, the user can say "save this session" and we write a single markdown file (see 07-memory-and-state.md).

## 6. Escape hatches

The architecture supports early exit at every gear boundary. This is a feature.

- **Exit after Sharpen:** "Oh — the real question is X. I know what to do." Skill confirms, shuts up.
- **Exit after Scout:** "Option 2 is obvious now that I see them all." Skill confirms, does not push Wrestle.
- **Exit mid-Wrestle:** "Stop, I've got it." Skill stops.

The skill *must not* push the user through all three phases by default. It offers; the user decides.

## 7. Re-entry

A user who has already finished a session can re-enter any gear directly:

- `/creative <problem>` — full flow, starts at Sharpen
- `/creative sharpen <problem>` — Sharpen only
- `/creative scout <refined problem>` — Scout only
- `/creative wrestle <idea>` — Wrestle only (useful when user has their own idea)

These are not separate "quick modes" like v1 — they're just entry points to the same three gears.

## 8. Integration with Claude Code

- Installed as a skill at `~/.claude/skills/creative/SKILL.md`.
- Invoked by the user typing `/creative ...` or by the main Claude session invoking the Skill tool when appropriate (the skill's description will make this legible to the orchestrator).
- Uses only: `Read` (for project files / CLAUDE.md context), `Bash` (rarely — only for the optional "smallest falsifier" in Wrestle), conversation output.
- Does **not** use: `Agent` / sub-agents. This is enforced in the skill text.

## 9. What a session looks like

Typical full run: 3–10 conversation turns, 5–15 minutes of wall time.

- Sharpen: 2–4 turns (user confirms, maybe refines once).
- Scout: 1 turn (three options shown, user picks).
- Wrestle: 2–5 turns (user probes, asks variants, gets to bottom).

Compare to v1's claimed 12+ sub-agent calls per session — roughly 0.
