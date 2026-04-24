# 13 — Proposals: Tightening SKILL.md's alignment with `the-creative-engine.md`

Status: **adopted for proposals 1–4 on 2026-04-24.** Proposal 5 deferred as originally marked. Changes applied to `SKILL.md` and specs 02/03/04/05/08/11.

---

## Why this doc exists

`the-creative-engine.md` makes four claims about where creativity comes from:

1. Open questions trigger divergent thinking; closed questions shut it down.
2. Design fixation comes from looking at the *object*, not the *requirement*.
3. Reframing ("move the goalposts to a more interesting field") beats iterating on the stated problem.
4. Open questions are invitations; closed questions are gatekeepers.

`SKILL.md` implements these well in spirit — Sharpen-before-Scout, no scoring, direct pushback, three genuinely different angles. Three specific places under-realize the thesis. Each has a concrete fix below.

If a reviewer disagrees with a proposal, record the rejection reason in this file rather than silently ignoring it. That way future sessions don't re-propose the same thing.

---

## Proposal 1 — Sharpen must exit with an **open question**, not a problem statement

### The gap

SKILL.md's Sharpen exit template reads:

> "Here's what I think you're actually asking: *[one-sentence reframed problem]*. Is that it, or am I off?"

The word "problem" skews the model toward declarative framings. The existing examples split:

- Declarative: *"Protect the API from burst traffic without rejecting legitimate users during known spikes."*
- Question: *"How do we keep cursors stable under concurrent writes?"*
- Question: *"How do we add token rotation to the existing auth system with minimum disruption?"*

The creative-engine's core claim is that the *form* of the framing matters — an open question creates a cognitive vacuum the brain fills with new connections; a declarative framing closes the search. If we believe that claim, Sharpen's artifact should always be an open question, not sometimes.

### The fix

Change the template (in both `SKILL.md` and `specs/04-sharpen.md`):

> "Here's the open question I think you're actually asking: **How might we [X]?** Is that it, or am I off?"

And add a rule to the Sharpen gear text:

> The reframed output is always an open question. Starts with "How", "What", "When should we", or similar. Never a declarative statement. If the best framing you can produce is declarative ("protect the API from burst traffic"), convert it ("how might we protect the API from burst traffic without rejecting legitimate users?") — the extra clause that converts a goal into a question usually names the real tension anyway.

### Why it's worth the cost

- Forces the model to *name the tension* rather than restate the goal. A declarative goal hides trade-offs; an open question exposes them.
- Scout's three lenses diverge more reliably when given a floodlight. Givetree given a flashlight ("protect the API"), lenses crowd toward rate-limiter variations. Given a floodlight ("how might we protect the API while not punishing legitimate bursts"), at least one lens drifts toward caller-behavior modeling or traffic shaping.
- Cost: ~3 lines of prompt change. No new gear.

### What to watch

Don't let "How might we" become ceremonial. The model can say "How might we protect the API?" and still produce a flashlight. The guard is: the open question must name *at least one tension* the user has endorsed (from Sharpen's pushback rounds), not just restate the goal.

---

## Proposal 2 — Add a "Requirement reframe" lens to Scout (the umbrella → awning move)

### The gap

Scout's four lenses are Conventional strong, Analogical import, Constraint inversion, Minimalist cut. All four orbit the stated object. None forces the move the creative-engine names as its central example:

> "How can we design a better umbrella?" → "How might we keep people dry as they move through the city?"

That move is: strip the object-noun from the question; solve the underlying need. Constraint inversion is adjacent ("remove the hardest constraint") but different — constraint inversion keeps the object and removes a limit. Requirement reframe *replaces the object*.

### The fix

Option A — **Replace Minimalist cut with Requirement reframe.** Minimalist cut is often near-indistinguishable from Conventional strong in practice (the smallest version of the boring answer *is* the boring answer).

Option B — **Add Requirement reframe as a fifth lens in the pool, still pick three.** More flexible; slightly more prompt complexity.

Recommended: Option B, phrased like this:

> **Requirement reframe** — strip the object from the problem statement. What's the underlying human or system need, stated without naming the current approach? What solutions become thinkable once the noun is gone?

Add a forcing rule: *if the user's sharpened question names a specific solution-noun (pagination, cache, middleware, pipeline), one of the three framings must be a Requirement reframe.*

### Why it's worth the cost

- The umbrella → awning leap is the strongest single example in the creative-engine. A skill that claims to operationalize the engine should reliably produce this move.
- Today, the skill produces it accidentally when Constraint inversion happens to strip the object — but that's not reliable.
- Cost: one paragraph in Scout's lens pool, one forcing rule.

### What to watch

Requirement reframe can degenerate into wordplay ("don't call it pagination, call it result windowing"). Guard in the prompt: *the reframe must change what solutions are thinkable, not just rename the existing one.*

---

## Proposal 3 — Add a "hidden solution" probe to Sharpen

### The gap

Sharpen's five probe categories are:

- hidden ambiguity
- hidden assumption
- hidden constraint
- hidden alternative
- hidden motivation

None catches the most common failure: the user's question already contains a solution smuggled in as a noun. "How should we improve our pagination?" assumes pagination. "How should we restructure auth?" assumes restructuring. "Which cache should we use?" assumes caching.

The creative-engine's point #3 (Reframing) is specifically about surfacing this. Without an explicit probe, the model sometimes notices and sometimes doesn't.

### The fix

Add a sixth category to Sharpen's move list:

> - **hidden solution** — "You've named *pagination* as the thing to improve. Strip that word — what's the user-visible symptom you're trying to fix?"

Pair it with an operational rule:

> When the user's `/creative` input contains a concrete noun that names an existing system, component, or approach, at least one Sharpen probe should test whether that noun is the actual problem or a solution baked into the framing.

### Why it's worth the cost

- This is the #1 source of bad Sharpen exits in the current prompt. Without the probe, the user confirms a "refined problem" that still inherits the solution-noun, and Scout produces variations on it.
- Cost: one bullet in the move list, one operational rule. The existing example 7.1 (pagination) accidentally demonstrates exactly this move — codifying it just makes it deliberate.

### What to watch

This probe is the most likely to feel presumptuous ("who are you to tell me pagination isn't the problem?"). Phrase it as a question, not an assertion. The Sharpen posture already allows this — the sixth category inherits that tone.

---

## Proposal 4 (minor) — Scout should echo the sharpened question above the three framings

### The gap

Scout's output template jumps straight to "Three angles. Pick the one that pulls at you." The sharpened question from Sharpen lives only in conversation context. If the user scrolls up, they can find it; if they don't, each framing floats free of the question it's answering.

### The fix

Prepend the sharpened question to Scout's output:

```
Refined question: How might we [X]?

Three angles. Pick the one that pulls at you — or tell me none of them and I'll cut again.

**1. [Name]** ...
```

### Why it's worth the cost

- Keeps the user anchored to the question, not the options. Matches the creative-engine's flashlight/floodlight framing: the illuminated *room* is the question; the options are things visible in that room.
- Makes "none of these" cleaner — the user can compare the three against the *stated* question rather than a remembered one.
- Cost: one line added to Scout output. No behavioral change.

### What to watch

Don't let this become a header ceremony. One line, verbatim, no formatting flourishes.

---

## Proposal 5 (speculative) — A "reframe check" before Wrestle closes

### The gap

Wrestle's moves are Mechanism, Steelman, Attack, Variants, Killer question, Smallest falsifier. None asks the creative-engine's closing injunction:

> "The next time you find yourself stuck, don't ask 'Is this good?' Ask 'What else could this be?'"

Variants is adjacent but narrow — variants are small mutations fixing specific attack items. "What else could this be?" is a bigger move: re-question the framing itself, now with everything the wrestle has revealed.

### The fix

Add an optional seventh move, offered exactly once near the end of Wrestle, before the killer question:

> **Reframe check:** one turn. "Given what mechanism, attack, and variants revealed — would you still pose the question the same way? If not, here's the version of the question I'd ask now: [X]." If the user agrees the new question is sharper, offer return to Scout with it. Otherwise proceed to killer question.

### Why it's worth the cost

- Creates a loop-back for the case where wrestling revealed the question was wrong — without disguising it as a variant.
- The creative-engine frames this as the hallmark of advanced creative work: not solving better, but questioning better.
- Cost: one paragraph in Wrestle. Offered at most once, and skippable.

### Why it's marked speculative

- Risks confusing users who want to wrap up. The existing "actually, I need to rethink this" escape hatch already covers the explicit case.
- May be redundant with Sharpen's "re-enter at any time" re-entry rule.
- Recommend deferring until we see real sessions where Wrestle reveals the question was wrong and the current skill handles it clumsily.

---

## Summary: recommended order to adopt

1. **Proposal 1** (open-question exit) — highest leverage, lowest cost, clearest alignment with the creative-engine thesis.
2. **Proposal 3** (hidden-solution probe) — closes the most common Sharpen failure.
3. **Proposal 2** (Requirement reframe lens) — directly implements the umbrella → awning move.
4. **Proposal 4** (Scout echoes the question) — trivial follow-on to Proposal 1.
5. **Proposal 5** (Wrestle reframe check) — defer; revisit once real sessions show the need.

Adopting 1+3+4 is a small coordinated change (maybe 15 lines of prompt diff across SKILL.md) and would meaningfully tighten the skill's fidelity to its stated philosophy. Proposal 2 is a separate larger change worth deciding on its own merits.
