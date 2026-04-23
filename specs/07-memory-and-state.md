# 07 — Memory and State

What we persist, what we deliberately don't, and why.

---

## 1. The short answer

**Session state** lives in the conversation. Written to disk only if the user asks.

**Learned state** — "patterns," "persona effectiveness," "prompt evolution" — does not exist. We do not maintain any per-project memory that feeds back into future sessions.

This is a deliberate departure from v1.

## 2. Why no per-project memory

v1 maintained three stores that fed back into generation:

- `successful.json` — patterns from ideas the user implemented
- `failed.json` — approaches invalidated in experimentation
- `persona_effectiveness.json` — which personas produced shortlisted ideas by domain

All three are removed. Reasons:

### 2.1 They bias toward the already-known

For a creative skill, re-injecting past framings into new generations is exactly backward. A new problem deserves fresh eyes. Past "successful patterns" look relevant — they match on tags and domain — but the match is superficial. The new problem's depth is different from the old problem's depth. Auto-injection dulls that.

### 2.2 They reward-hack against themselves

`persona_effectiveness.json` promotes personas whose ideas make the shortlist. But the shortlist is chosen (implicitly) by safety and legibility. So the feedback loop optimizes for safe, legible ideas — the opposite of creativity.

### 2.3 They encourage staleness

Real project context changes faster than the memory store's update cycle. Six-month-old "patterns" describe a codebase that no longer exists.

### 2.4 The user has better memory than the system

The user remembers what worked on this project. They bring that memory into the conversation naturally. The system's "memory" is a weaker copy that competes with the real one and usually loses.

## 3. What we *do* keep

Exactly two things, both user-initiated.

### 3.1 The optional session transcript

If the user says **"save this session"** during or after a `/creative` run, the skill writes a single markdown file:

```
./creative-sessions/YYYY-MM-DD-HHMM-<slug>.md
```

The file contains the conversation transcript, lightly formatted, with headings for each gear (Sharpen / Scout / Wrestle). Nothing else. No JSON sidecar, no scores, no tags.

The skill does not auto-save. Saving is a conscious act the user opts into.

The `creative-sessions/` folder is at the project root (configurable). Recommended `.gitignore` entry:

```
creative-sessions/
```

Unless the user wants to commit sessions as design documentation, in which case they simply don't gitignore it.

### 3.2 User-authored lessons

If, during wrestling, the user says something like "save this as a lesson" or "remember this" or "add a note," the skill offers to append a line to a project-local file:

```
./creative-notes.md
```

This is a flat, append-only markdown file. The user owns it. The skill does not read it back in future sessions unless the user explicitly tells it to. Example:

```markdown
# Creative notes

- 2026-04-22: sliding-window counters don't help with cron fires unless window > burst duration
- 2026-05-03: token-bucket with per-tenant credits is fine for N<1000 tenants; above that, sharding dominates
```

The file is readable by the user. That's its entire purpose. It is not a memory store for the skill.

## 4. What we explicitly refuse to persist

These are the disallowed artifacts. A future session must not add them back without updating `01-philosophy.md` and this doc first.

| Artifact | Reason it's refused |
|---|---|
| `successful.json` / `failed.json` | Biases new problems toward past framings (§2.1) |
| `persona_effectiveness.json` | Reward-hacks safe/legible ideas (§2.2) |
| `prompt_evolution.json` | We don't self-optimize prompts — see §5 |
| Per-session JSON artifacts (brief, candidates, evaluations, selected, refined) | No numeric scoring; nothing to persist as JSON |
| Per-project `.creative-loop/` folder | No per-project state means no folder needed |
| Auto-loaded memory at session start | Starting fresh is a feature |

## 5. Why no prompt self-optimization

v1's `/creative optimize` analyzed session outcomes and rewrote persona prompts. We remove this entirely.

- **No held-out benchmark.** Any "did this help?" signal is measured on the same data that drove the change. Circular.
- **No ground truth.** "Low adoption" could mean the prompts are bad, or the problems were hard, or the user is busy, or anything.
- **Prompt drift masquerading as improvement.** Small edits compound in ways that aren't always good and aren't measured.
- **A version-controlled `SKILL.md` is the right model.** Edits are reviewed by humans and tracked in git. That's how we improve.

If a future session sees the skill misbehaving, the fix is: edit `SKILL.md` directly, commit, push. Not add a self-rewriting system.

## 6. Why no auto-loaded context from prior sessions

Even without a formal "pattern store," we could auto-load the most recent saved sessions into the conversation. We don't, because:

- The user often starts a new `/creative` call about an unrelated problem. Injecting prior sessions adds noise.
- If prior context matters, the user will mention it ("last time we looked at pagination, we chose cursor-based — I want to revisit"). That mention is the signal. Auto-loading would dilute it.

If the user says "look at last week's session on this," the skill reads the saved markdown file as it would any other file. Explicit request, explicit read.

## 7. Configuration

There is no `config.json`. No per-project tunables.

If you need to change the skill's behavior, edit `SKILL.md`. That is the configuration surface.

The two things that are path-configurable (session save folder, notes file path) are defined as constants in `SKILL.md` — you override by editing the skill.

This is deliberate: per-project config files proliferate, drift, and usually encode decisions that should have been baked into the skill. If every project is configuring the same thing to the same value, that value should be the skill default. If projects genuinely differ, they can maintain local forks of `SKILL.md`.

## 8. Portability

A session markdown file is portable. You can check it into git, share it, quote from it, search it. That's the full portability story.

No cross-machine sync. No pattern export. No creative profiles. No "seed a new project with prior learnings."

If that's ever needed, it's a `cp creative-sessions/ some-other-project/creative-sessions/` away. File-system level portability is sufficient.

## 9. What the user gets

The user gets:

- **A fresh conversation** every `/creative` invocation. No stale injected context.
- **The option to save** the one session they found valuable.
- **A plain-text notes file** they own and can read.
- **A version-controlled skill** they can diff and modify.

They do not get:

- Auto-learned improvements that they have to trust without evidence.
- A system that remembers their past work in ways they can't inspect.
- Per-project state that falls out of sync with the project.

## 10. For future sessions considering adding a memory feature

If you're tempted to add persistent learning, first read `01-philosophy.md §5` (the rejections table) and the rationale above.

If you still want to, write a doc here first that answers:

1. What signal are you learning from? Is it ground truth, or just proxy?
2. How do you measure whether the learning helped, on held-out data?
3. How does the user inspect and correct what's been learned?
4. How do you prevent the feedback loop from drifting toward safe, legible outputs?
5. What do you do when the user's project changes underneath the learned patterns?

If you can answer all five, you have a real memory feature. If you can't, you have v1's memory feature, which we removed.
