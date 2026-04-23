# 05 — Scout (Gear 2)

Three framings. User picks by gut. No scores.

---

## 1. Purpose

Surface three distinct *angles of attack* on the sharpened problem. Not three ranked candidates — three genuinely different framings, so the user's gut reaction reveals their actual priority.

The value is in the *contrast between the three*, not in any one of them being "the best." Often the user reads all three and sees what they actually want — which may not be any of the three, but which they couldn't see without them.

## 2. What "three framings" means

Each framing is a lens, not a feature list. They should differ in:

- **What problem they emphasize** (the fast path, the rare path, the operator)
- **What they refuse to optimize for** (this is the clearest signal of a framing)
- **What they import from** (an analogy, a pattern from elsewhere)

Three framings that all optimize the same axis aren't three framings; they're one framing with small variations.

### 2.1 Sourcing the three

For each problem, pick three from these lenses. Not all four — pick the three most productive for this specific problem:

| Lens | The question it asks |
|---|---|
| **Conventional strong** | What's the best version of the most boring answer? |
| **Analogical import** | Where has this exact problem been solved elsewhere, and what does that solution look like ported here? |
| **Constraint inversion** | What if we removed the hardest constraint — what becomes possible? |
| **Minimalist cut** | What's the smallest version that could plausibly work? |

"Conventional strong" should almost always be one of the three. The user often picks it and that's fine — it means they needed to see it framed next to the alternatives to commit.

## 3. Output format

Exactly this shape. Three items. Each item has:

1. A **one-line name** (evocative, not a bullet list of features)
2. **The core** (1 sentence — what it *is*)
3. **Why it wins** (1 sentence — the strongest case for it)
4. **What it refuses** (1 sentence — what it deliberately doesn't optimize for)

No scores. No novelty claims. No risks list. No confidence. No persona attribution.

### 3.1 Template

```markdown
Three angles. Pick the one that pulls at you — or tell me none of them and I'll cut again.

**1. [Name]**
   [Core, one sentence.]
   *Wins when:* [strongest case, one sentence.]
   *Refuses:* [what it won't optimize for, one sentence.]

**2. [Name]**
   [...]

**3. [Name]**
   [...]

Which one?
```

## 4. What Scout does not do

- **No composite score.** No numbers at all.
- **No ranked order.** They're numbered for reference, not ranked. The skill may have a favorite but does not say so (see §6).
- **No "and you could combine them."** The user can propose a combination. The skill does not.
- **No fourth option.** Three is the number. If you can't find three meaningfully different framings, the problem isn't ready for Scout — go back to Sharpen.
- **No sub-agent fan-out.** One main-thread call generates all three.

## 5. Execution

The Scout section of `SKILL.md` (see `08-skill-file.md`) instructs the model to produce the three framings in a single output. The model:

1. Reads the refined problem statement from Sharpen.
2. Picks three lenses from §2.1.
3. Generates the four lines (name / core / wins / refuses) for each.
4. Delivers in the §3 template.
5. Asks the gate-B question (see `03-interaction-model.md` §3.2).

No thinking-out-loud. No "I'll first consider…" narration. Just the output.

## 6. The skill's opinion

The skill may privately have a favorite. It does not lead with it.

Only if the user explicitly asks ("which would you pick?") does the skill answer — and then in one sentence with one reason.

**Why:** naming a favorite up front destroys the gut-reaction value. The user anchors on the skill's choice instead of their own.

## 7. When the user says "none of these"

Common and fine. Respond by asking **what's missing** before generating a new set:

> "What's off about all three? Too conservative, wrong constraint, something I'm not seeing?"

One specific answer from the user changes the lens selection for round 2. Don't just regenerate with the same lenses hoping for different output — that's wasteful.

Max two Scout rounds. After the second, if the user still says "none," offer to return to Sharpen.

## 8. When the user says "they're all good"

Push back once:

> "Pick the one you'd reach for first on Monday morning. I want your gut."

If they pick, proceed. If they truly can't, it usually means Sharpen didn't narrow enough. Offer to return there.

## 9. Combinations and hybrids

If the user says "#1 and #3 together," proceed. But:

- In Wrestle, treat it as its own single idea, not a merger.
- Ask one clarifying question: "What's the #1 part and what's the #3 part?" — this forces them to specify the hybrid precisely, not hand-wave.

## 10. Examples

### 10.1 Rate limiting

Refined problem (from Sharpen): *"Protect the API from burst traffic without rejecting legitimate users during known spikes like cron fires."*

```
Three angles. Pick the one that pulls at you — or tell me none of them and I'll cut again.

**1. Sliding window counter**
   Track per-caller request counts over a moving time window; reject once the window exceeds the limit.
   *Wins when:* you want one knob, predictable behavior, no surprises in postmortems.
   *Refuses:* to distinguish burst-legitimate traffic from abuse. A cron fire looks like an attack.

**2. Token bucket with burst credit**
   Each caller accrues credit during quiet periods, spends it on bursts; rejects only when credit is exhausted.
   *Wins when:* your traffic is naturally bursty and quiet-tolerant callers shouldn't be punished for spikes.
   *Refuses:* to protect against sustained attackers who pace themselves under the refill rate.

**3. Adaptive limits by caller reputation**
   Each caller's limit floats based on recent behavior; well-behaved callers get more headroom over time.
   *Wins when:* you have a long tail of callers and the fixed limit is either too tight or too loose for everyone.
   *Refuses:* simplicity. You're now running a scoring system with state and a feedback loop.

Which one?
```

### 10.2 Naming a module

Refined problem: *"Name the module that converts internal event types into webhook payloads for external subscribers."*

```
Three angles.

**1. Domain-literal: `webhook-emitter`**
   Says exactly what it does in the webhook domain. No metaphor.
   *Wins when:* you want new engineers to open the file and find what they expect.
   *Refuses:* to generalize. If you later add non-webhook external delivery, the name misleads.

**2. Boundary-literal: `egress-translator`**
   Names its role in the architecture (things going out, being translated).
   *Wins when:* you have a catalog of `ingress-*` / `egress-*` modules and want the name to fit the family.
   *Refuses:* to be self-explanatory out of context. Requires the reader to know the convention.

**3. Metaphor: `townCrier`**
   A domain metaphor — something that announces internal events to the outside world.
   *Wins when:* your codebase already leans metaphorical and you want the name to stick in memory.
   *Refuses:* to signal protocol. Doesn't tell you it's HTTP/webhook-shaped without reading the code.

Which one?
```

## 11. The failure mode to watch for

If Scout outputs three framings that look like small variations of the same framing (e.g., all three are "some kind of sliding window"), the gear has failed. The fix:

- Force one of the three from §2.1's **Analogical import** lens.
- Force one of the three from **Constraint inversion**.

A model will drift toward safe, similar options unless the lens prompt resists it.
