# 01 — Philosophy

This doc is load-bearing. Every later decision derives from the stance here. If you disagree with the stance, change this doc first — don't just tweak the downstream components.

---

## 1. The thesis we reject

v1 opened with: *"Human creativity is a loop… irreducibly sequential: humans can't think in parallel. AI agents have the opposite problem. They don't get stuck — they go straight to an answer. This project puts the loop back in… fans out to multiple parallel agents, each embodying a different thinking persona."*

That thesis is wrong in three ways:

### 1.1 Parallelism is not the missing ingredient

The most documented pattern in real creative work is **incubation** — putting a problem down, sleeping on it, returning to it with fresh context. Breakthroughs come from *one mind re-entering the problem*, not from N minds working independently in lockstep. Fan-out-fan-in of sub-agents mimics *peer review*, not creativity. Peer review is arguably the least creative process humans have ever invented.

### 1.2 Personas are costumes, not cognition

A persona prompt doesn't give an LLM a new way of thinking — it gives the same underlying distribution a different stylistic wrapper. "Devil's Advocate" produces more dramatic-sounding output; "Minimalist" produces tersesounding output. They sample from the same mind. Stylistic divergence without cognitive divergence looks like variety but isn't.

### 1.3 The best parts of creativity are serial and cumulative

Real creative work is one idea *triggering* another, then *wrestling with* it, then *re-framing* it when it fails. Parallel isolation of generators specifically destroys this chain. The "combination round" v1 tacks on at the end can't recover cumulative depth — each isolated thinker has already committed to a framing.

---

## 2. Our replacement thesis

**Creativity has two moves that matter: sharpening the question, and wrestling with one concrete idea. Generation and scoring are scaffolding for those two moves.**

- *Sharpening the question* is where most creative leverage lives. Half the time, a sharp question dissolves the apparent need for exploration entirely.
- *Wrestling with one idea* is where depth comes from. Depth beats breadth almost every time in practice.

The skill's job is to scaffold these two moves for the user. Not to replace them. Not to generate a shortlist and declare victory.

---

## 3. What this means operationally

### 3.1 LLMs do some things well and some things badly

**Well:**
- Direct analogy retrieval ("this is structurally identical to X in domain Y")
- Socratic interrogation of a problem statement
- Steelmanning and attacking a single proposal
- Rephrasing ambiguous requirements precisely

**Badly:**
- Calibrated scalar judgment (0.0–1.0 scores)
- Genuine stylistic diversity across parallel calls
- Knowing when an idea is "novel" vs merely unfamiliar to the evaluator
- Knowing when to stop generating

v2 leans into the first list and refuses the second.

### 3.2 The user is the creative agent

The skill is scaffolding for the user's thinking. Not a replacement for it. Not a judge. Not a gatekeeper approver.

This reframe changes the UX from a multiple-choice quiz ("pick one of 3 scored proposals") into a conversation ("you said X — what's underneath that? here are three reframings, which rings true?").

### 3.3 Depth over breadth

Three scouting ideas > fifteen. One wrestled idea > three refined ones. Breadth is easy to fake; depth isn't.

---

## 4. Design principles (in priority order)

1. **Sharpen before generating.** Never launch idea generation before the problem statement has survived at least one round of Socratic pushback.
2. **One thread, not N.** No sub-agent fan-out. Every step runs in the main conversation, because ideas need to build on each other.
3. **Gut over score.** Users pick by articulated reason, not composite score. Remove all numeric scoring UI.
4. **Depth over breadth.** Three scouts, one wrestle. Never twelve.
5. **Refuse false rigor.** No 0.0–1.0 axes, no weighted composites, no calibration claims. An LLM cannot produce calibrated scalars over vague criteria; pretending it can is worse than not scoring.
6. **Trust the user's memory.** No per-project pattern-learning. Past successful/failed ideas are *not* re-injected into new generations — that biases toward the already-known and undermines the whole point.
7. **Hand-edited skill.** `SKILL.md` is version-controlled like code. No self-optimizing prompt rewriting. Human edits only.
8. **Stop early.** The skill should end the loop the moment the user has what they need — often after the Sharpen phase alone.
9. **Honesty about what's testable.** Most creative decisions (architecture, naming, API shape) cannot be validated by a 50-line experiment. Don't pretend. Mark them as untestable and stop.
10. **Small is a feature.** Target `SKILL.md` under ~250 lines. Every line should pull its weight.

---

## 5. The rejections, explicitly

If a future session is tempted to add any of these back, re-read this section first. Each was in v1 and is deliberately removed.

| Removed | Why |
|---|---|
| Sub-agent fan-out for generation | Destroys cumulative reasoning across ideas; creates stylistic-only diversity |
| Parallel evaluators | Two LLM raters' median is just the noisier rater; doesn't add rigor |
| Numeric 0.0–1.0 scoring on 5 axes | LLMs can't produce calibrated scalars over vague axes; the composite is theater |
| Weighted composite score | Weights are arbitrary; inflates trust in a noisy number |
| 10 persona rotation system | Costume-swapping, not thinking diversity |
| `persona_effectiveness.json` feedback loop | Reward-hacks toward evaluator-friendly (safe) ideas |
| `successful.json` / `failed.json` auto-injection | Biases new problems toward past framings; anti-creative |
| Self-optimizing prompt rewrites | Prompt drift dressed as improvement; no held-out benchmark |
| "Experiment runner" for non-code decisions | 80% of target decisions aren't testable by scripts |
| Quality thresholds + iteration budgets | User knows when to stop; don't hardcode it |
| Cost/time estimators | Low-information, patronizing; user sees token usage already |
| `/creative init` project scaffold | No per-project state needed; see 07-memory-and-state.md |
| `/creative sync` + cross-machine merge | No per-project state means nothing to sync |

---

## 6. What we keep from v1

- The high-level sequence of *expand then commit* is right, just implemented differently.
- The instinct to surface a "wild card" option is right; we do it inside Scout.
- The instinct to gate on human confirmation at key points is right; we keep the gates, not the scoring that precedes them.
- The single-file `SKILL.md` install model is right; we keep it, much smaller.

---

## 7. How to tell if v2 is working

Three signals, in priority order:

1. **Users say "that reframing — that's actually my problem"** at the end of Sharpen. If this never happens, Sharpen is broken.
2. **Users ship something they wouldn't have shipped otherwise.** Adoption of one concrete idea, not praise for the process.
3. **Users invoke `/creative` again unprompted.** If they don't, it's not earning its place.

Three anti-signals:

1. **Users default to `/creative quick`** — means the full flow isn't worth it.
2. **Users skip the Sharpen gate** ("just generate ideas") — means Sharpen feels like friction, not leverage.
3. **Users pick the "safe middle" option** consistently — means Scout isn't producing real alternatives.

---

## 8. What this skill is and isn't

**Is:** A thinking partner for open design questions, for 5–15 minutes at a time, inside a coding session.

**Isn't:** A decision-making system. An evaluator. An autonomous agent. A research tool. A long-running exploration harness.

The scope is small on purpose. A small thing done well, used often, beats a large thing done impressively, used once.
