# 11 — Test Cases

Golden paths the skill must handle. Use these during Phase 2 of the build (see `10-build-plan.md §2`).

These are not unit tests — they're full interaction scenarios. The test passes when the skill produces output with the right *shape* and *tone*, not when it produces a specific string.

---

## 1. Why test cases exist

Three reasons:

1. **Build validation.** You can't tell if the skill works without running it. Specs describe intent; transcripts show behavior.
2. **Regression prevention.** When `SKILL.md` is edited, re-run these cases. If tone or flow regresses, catch it.
3. **Documentation.** The examples serve as the README's proof: this is what using the skill feels like.

## 2. The three golden paths

These cover the three structurally distinct interaction shapes.

### Case A — Full 3-gear flow (Sharpen → Scout → Wrestle)

The standard path. User brings a half-formed design question, gets sharpened, sees three angles, picks one, goes deep.

**Trigger:** `/creative How should we handle rate limiting on the public API?`

**Expected shape:**

1. Skill asks a Sharpen question (e.g., "what's the forcing function — DoS protection, fairness across tenants, or something else?").
2. User provides specifics (e.g., "bursty traffic from cron-fires").
3. Skill proposes a refined open question ("How might we ...?"); user confirms.
4. Skill produces three framings in the exact Scout format.
5. User picks one (e.g., "#2, token bucket").
6. Skill delivers Mechanism, ends with the "attack/steelman/variants?" question.
7. User picks "attack."
8. Skill delivers 3–6 concrete failure modes.
9. User asks for variants on one specific attack item.
10. Skill delivers 2–3 variants.
11. User asks for the killer question.
12. Skill delivers one-sentence killer question.
13. User says "got it, thanks."
14. Skill delivers closing summary under 200 words. Stops.

**Pass criteria:**
- Sharpen actually pushed back (didn't accept first framing).
- Scout has three genuinely different angles (not three flavors of the same thing).
- Mechanism is concrete (names components, sequence).
- Attack items are specific (name conditions, not "could be slow").
- Killer question is testable.
- Closing summary doesn't have a "what next?" menu.

**Artifact:** `examples/rate-limiting-full.md`

### Case B — Sharpen self-resolves (exit early)

The user's question dissolves during Sharpen. The skill recognizes this and stops rather than pushing to Scout.

**Trigger:** `/creative Should we use GraphQL or REST for the new internal admin service?`

**Expected shape:**

1. Skill asks a Sharpen question (e.g., "who's calling this and how many of them?").
2. User answers narrowly (e.g., "just our own frontend, probably 3 screens").
3. Skill recognizes the answer makes the question moot and says so — naming the reason, not just declaring the answer.
4. User confirms ("yeah, I was overthinking it").
5. Skill stops. Does not offer Scout. No "but if you want to explore anyway…" fallback.

**Pass criteria:**
- Skill doesn't blindly produce three framings.
- Skill's recognition is explicit — it tells the user *why* the question dissolved.
- Skill ends without ceremony.

**Artifact:** `examples/pagination-self-resolves.md`

(Note: the example filename mentions pagination rather than GraphQL/REST. Feel free to swap the scenario to whichever self-resolves most cleanly in your test run, as long as the *shape* matches.)

### Case C — Direct-entry Scout (skip Sharpen)

The user already knows their question and uses the `/creative scout` entry.

**Trigger:** `/creative scout Name the module that converts internal event types into webhook payloads`

**Expected shape:**

1. Skill produces three framings immediately — no Sharpen round.
2. Framings follow the exact template.
3. User picks one ("#1, webhook-emitter").
4. Skill enters Wrestle with Mechanism.
5. User is satisfied after Mechanism ("that's exactly what I needed, thanks").
6. Skill stops without forcing additional moves.

**Pass criteria:**
- Skill does not ask any Sharpen questions when the direct-entry is used.
- Scout output is in the exact template with no added scores or rankings.
- Skill gracefully stops mid-Wrestle when the user has what they need.

**Artifact:** `examples/module-naming-quick.md`

## 3. Negative test cases (things that must NOT happen)

Run these scenarios. The skill must NOT exhibit the listed behavior.

### 3.1 The user demands to skip Sharpen

**Trigger:** `/creative I know what I want, just give me options for caching layer designs`

**Must NOT do:**
- Immediately generate three framings without any Sharpen.
- Ask three Sharpen questions stacked.

**Must do:**
- Push back once with a single pointed question.
- Comply on second demand, but flag the risk in Scout output (e.g., "proceeding without sharpening — if these all feel wrong, the question probably needs reframing").

### 3.2 The user says "they're all good" in Scout

**Trigger:** during a Scout turn, user replies "all three look good, hard to pick."

**Must NOT do:**
- Proceed with any of the three silently.
- Ask the user to rank them.
- Offer to proceed with all three.

**Must do:**
- Push back once: "Pick the one you'd reach for first on Monday. I want your gut."

### 3.3 The user asks for a numeric score

**Trigger:** during Scout, user asks "what do you think #2 scores out of 10?"

**Must NOT do:**
- Provide a number.
- Provide a "rough estimate" number with a hedge.

**Must do:**
- Answer the underlying question in one sentence, without scoring. Example: "More than #1 in callers you don't control; less than #3 once you have real data."

### 3.4 The user asks the skill to "optimize itself"

**Trigger:** `/creative optimize` or similar.

**Must NOT do:**
- Propose prompt edits.
- Read past sessions and suggest improvements.
- Acknowledge "optimize" as a valid subcommand.

**Must do:**
- Tell the user the skill doesn't self-optimize; it's version-controlled. Suggest they edit `SKILL.md` directly.

### 3.5 The user says "init" or "sync"

**Trigger:** `/creative init` or `/creative sync`.

**Must NOT do:**
- Create a `.creative-loop/` folder.
- Try to merge anything.

**Must do:**
- Tell the user v2 doesn't need init or sync. `/creative <problem>` just works.

## 4. Tone regression checks

These are vibe checks, not pass/fail tests. But if the skill exhibits them, it's drifting toward v1's failure mode and `SKILL.md` prose needs tightening.

- **Consultant voice.** "That's a great question — let's think about it together…"
- **Progress narrator.** "I'll now move to the Scout phase…"
- **Hedging stack.** "It depends, but one could argue…"
- **Three-question pile-up.** "Are you thinking about X? And if so, is Y a concern? Also, what about Z?"
- **Apologetic pushback.** "I'm sorry, but I'm not sure that's quite the right question…"
- **Emoji creep.** Any emoji at all.

If any appear, edit `SKILL.md`'s Posture section to be more emphatic about the rule that was violated.

## 5. How to actually run these

For each case:

1. Open a fresh Claude Code session in a project where the skill makes sense (v1's repo works fine for A and B).
2. Use the exact trigger text.
3. Do not correct the skill mid-session — capture what it actually does, good or bad.
4. After the session, read the transcript and check it against Pass criteria.
5. If it passed: clean up (fix typos, trim Claude's thinking-out-loud if any), save to `examples/`.
6. If it failed: note the failure mode, edit `SKILL.md`, re-run. Do not save a failing transcript as an example.

## 6. What "good enough" looks like

v2.0.0 ships when:

- Case A, B, C each run cleanly at least once.
- Negative cases 3.1, 3.2, 3.4, 3.5 are verified (3.3 is implicit in the other tests).
- No tone regressions in any of the saved transcripts.

If a case flakes (passes sometimes, fails other times), the skill's instructions are too loose somewhere. Tighten them. Don't rely on "usually works."

## 7. Extending the test suite

Future tests worth adding once v2.0.0 is in use:

- **Recovery from a bad Scout round.** User says "none of these," skill cuts again with different lenses, second round works.
- **Hybrid option at Scout gate.** User says "mix of #1 and #3," Wrestle handles it cleanly.
- **Mid-Wrestle pivot.** User realizes during Wrestle they're wrestling with the wrong idea; skill offers clean return to Sharpen.
- **Save-then-resume.** User `/creative save`s a session, later returns and asks the skill to read it and continue.

These are not required for v2.0.0 but should be added as the skill is iterated.
