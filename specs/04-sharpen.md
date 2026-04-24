# 04 — Sharpen (Gear 1)

The single highest-leverage part of the system. v1 skipped this entirely.

---

## 1. Purpose

Convert a vague or pre-framed user request into a sharp question the user actually wants answered. Often, sharpening alone resolves the problem — the user discovers they were solving the wrong thing.

## 2. The core move

**One pointed question at a time.** Not a brief, not a bulleted "constraints + success criteria" template. A question.

Good questions probe one of:

- **Hidden ambiguity** — "'Better pagination' — faster, or easier for callers?"
- **Hidden assumption** — "You said 'we need to cache this' — what makes you think reads dominate?"
- **Hidden constraint** — "Is this for the public API or internal use? That changes everything."
- **Hidden alternative** — "Before choosing between A and B — is there a version where neither is needed?"
- **Hidden motivation** — "What happens if you don't solve this at all this quarter?"
- **Hidden solution** — "You've named *pagination* as the thing to improve. Strip that word — what's the user-visible symptom you're trying to fix?"

Each question asks the user to commit to a specific framing or reveal that their original framing was imprecise.

**Forcing rule for hidden-solution probes.** When the user's `/creative` input contains a concrete noun naming an existing system, component, or approach (pagination, cache, middleware, pipeline, auth system), at least one probe must test whether that noun is the actual problem or a solution baked into the framing. This is the highest-leverage probe the skill has — it's the move that converts "how can we design a better umbrella" into "how might we keep people dry as they move through the city."

## 3. Exit conditions

Sharpen exits when one of these is true:

1. **User confirms a refined statement.** The skill proposes a one-sentence reframing; the user says yes (or says yes with a small edit).
2. **User self-resolves.** The user says "oh — I know what to do," and the skill confirms and stops.
3. **Max rounds hit.** After 3 rounds of pushback without convergence, the skill proposes the best reframing it has and asks the user to accept or reject. No fourth round; we don't grind.

## 4. Anti-patterns

### 4.1 The JSON brief

v1's Phase 1 produced a JSON blob with `problem_statement`, `constraints`, `success_criteria`, `domain`, `tags`, `exploration_budget`, `context_summary`, `known_attempts`. Don't.

The JSON brief is a form, not a conversation. It gives the illusion of rigor without sharpening anything. A refined open question is one sentence. No taxonomy fields.

### 4.2 The consultant question

"What are your constraints?" "What does success look like?" "What's your budget?"

These are answered by the user writing a list. Lists dull thinking. A good Sharpen question forces a binary or a specific answer.

**Wrong:** "What are your constraints?"
**Right:** "If I told you the answer involves a breaking API change, does that kill it, or is it on the table?"

### 4.3 Premature summarization

After the user answers one question, don't immediately summarize. Ask the next one.

## 5. When the user says "just generate ideas"

This is common. The user is impatient; Sharpen feels like friction.

**Do not comply.** Say something like:

> "I hear you. One question first — otherwise I'll generate ideas for the wrong problem. [specific question]."

If the user insists again after this, comply but flag the risk in the Scout output.

Reason: 80% of the time the user who skips Sharpen picks a Scout option, goes to implement it, then realizes two hours later the problem was different. This is the failure mode Sharpen exists to prevent.

## 6. Prompt stance (for SKILL.md implementation)

The Sharpen section of `SKILL.md` should put the model into this stance. See `08-skill-file.md` for the exact text. The stance encodes:

- You are a senior engineer who has seen this problem before.
- You suspect the user is asking the wrong question. Probe.
- Ask one question per turn. Make it binary or specific.
- After at most 3 rounds, offer a reframed statement in ≤1 sentence and ask for confirmation.
- If the user's own words reveal the answer mid-conversation, say so and stop.

## 7. Examples

### 7.1 Ambiguity

**User:** `/creative How should we improve our pagination?`

**Skill:** "Before I answer: is 'improve' about slow queries, confusing cursor behavior for callers, or something else? Those have totally different answers."

**User:** "Cursor behavior — callers get confused when we add new items mid-scroll."

**Skill:** "Got it. So the problem is really: how do we keep cursors stable under concurrent writes? Want me to explore options, or is the answer obvious now that it's named?"

### 7.2 Self-resolution

**User:** `/creative We need to decide between GraphQL and REST for the new service`

**Skill:** "Who's calling this service, and how many of them?"

**User:** "Just our own frontend, probably 3 screens."

**Skill:** "Then GraphQL buys you very little over REST here — the tooling benefits mostly pay off with many clients or many teams. Unless there's a specific query pattern you're worried about, REST is likely the answer and the question was just 'am I overthinking this?'"

**User:** "Yeah, I was overthinking it. Thanks."

→ Skill stops. No Scout. No Wrestle.

### 7.3 Hidden constraint

**User:** `/creative How should we restructure the auth system?`

**Skill:** "What's the forcing function? Is this for scale, a security finding, a vendor migration, or just 'it's a mess'?"

**User:** "Security audit flagged token rotation."

**Skill:** "Then the open question is: **How might we add token rotation to the existing auth system with minimum disruption?** — not 'how do we restructure auth.' Agreed?"

**User:** "Yes, that's it."

→ Proceed to Scout with the narrowed problem.

## 8. What goes into Scout from Sharpen

The output of Sharpen is **one open question** — the confirmed refined question, always phrased as a question ("How might we …?", "What would it take to …?", "When should we …?"). Never a declarative statement.

That question is the input to Scout. Nothing else. No constraints list, no success criteria, no tags. The next gear reads fresh off a clear open question.

**Why an open question, not a statement.** A declarative framing closes the search (flashlight); an open question creates the cognitive vacuum Scout's three lenses need to fill (floodlight). If the cleanest framing you can produce is declarative ("protect the API from burst traffic"), convert it ("how might we protect the API from burst traffic without rejecting legitimate users during known spikes?") — the clause that turns the goal into a question usually names the real tension anyway.

The open question must name at least one tension the user endorsed during pushback rounds, not merely restate the original goal. "How might we improve pagination?" is not a sharpened question; it's a ceremonial rewrite. "How might we keep cursors stable under concurrent writes without breaking existing callers?" is.

Anything the user mentioned in Sharpen that's still relevant stays in the conversation context — the main thread doesn't lose it.

## 9. Measuring Sharpen quality

Good Sharpen sessions show one of these signatures:

- The user's final confirmed statement is materially different from their initial `/creative` input.
- The session ends in Sharpen (user self-resolves).
- The user says something like "that's actually my problem" or "I was asking the wrong thing."

Bad Sharpen sessions show:

- The refined statement ≈ the input.
- The skill accepted the framing without probing.
- The user got impatient and demanded Scout.

If a future version of the skill shows the bad signatures, the fix is to make the Sharpen pushback stronger, not to reduce it.
