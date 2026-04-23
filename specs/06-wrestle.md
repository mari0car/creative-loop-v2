# 06 — Wrestle (Gear 3)

Depth on one idea. Where creative work actually happens.

---

## 1. Purpose

Take the single framing the user chose in Scout and engage with it deeply — so the user either commits to implementing it, rejects it with a reason, or returns to Sharpen with new information.

Wrestle is multi-turn. It is not a report the skill produces; it is a conversation the user steers through structured moves.

## 2. The five moves

Wrestle is a set of moves the skill offers. Each move is a single-turn operation. The user picks which moves to run, in what order, and when to stop.

| Move | What it does | When useful |
|---|---|---|
| **Mechanism** | Spell out how the idea actually works, concretely — components, data shapes, sequence. | Always the first move. The user can't wrestle with a vague idea. |
| **Steelman** | State the strongest possible case for the idea, taking it seriously. | When the user is tempted to dismiss it prematurely. |
| **Attack** | Find the specific failure modes — not generic risks, actual ways it breaks. | Usually second; after mechanism is clear. |
| **Variants** | Produce 2–3 narrow variations that adjust the weakest parts. | After an attack reveals a specific weakness. |
| **Killer question** | State the single question whose answer would decide whether to build this. | Near the end. The deliverable. |

Note: there is no "implementation sketch" or "effort estimate" move. Those are the work of the main Claude session after `/creative` ends.

## 3. Flow

```
Scout picks #N
       │
       ▼
Mechanism   ← always runs first, no opt-out
       │
       ▼
Skill: "Mechanism's clear. Attack, variants, or steelman?"
       │
       ▼
[user picks a move] ────► skill runs it ────► skill asks next
       │
       ▼
(loop — user keeps picking moves)
       │
       ▼
Killer question   ← skill offers when the wrestle seems to have converged
       │
       ▼
End
```

## 4. The moves in detail

### 4.1 Mechanism (always runs first)

Describe how the chosen idea actually works, in 1–2 short paragraphs. Specific enough that:

- Names of components or functions that would need to exist.
- The sequence of what happens at runtime or at request-time.
- What data is added, modified, or read.

**Not** a code block. Prose. Code would invite the user to evaluate the syntax instead of the idea.

If the idea is genuinely a naming/architecture/process choice with no mechanism, say so in one sentence and proceed to the next offer.

### 4.2 Steelman

One paragraph. State the strongest case for the idea — not a list of pros, but the single best argument written as if you believed it.

Ends with an explicit handoff: "That's the strongest case. Want me to attack it?"

### 4.3 Attack

Bullet list is OK here. 3–6 specific failure modes. Each:

- Names a concrete condition under which it fails.
- Names the consequence.
- Does *not* propose a mitigation (that's what variants are for).

**Wrong:** "Could be slow under load."
**Right:** "When a single caller holds 10+ connections, the per-caller counter becomes the shared hot path — P99 latency climbs into the 200ms range under modest concurrency."

### 4.4 Variants

2–3 short variations that each address a specific weakness from the attack. Each variant names:

- Which attack item it addresses.
- What changes vs. the original mechanism.
- What new weakness, if any, the variant introduces.

Variants are not "combinations" — they're small mutations of the chosen idea. If the user wants to mix in another Scout option, that's a fresh Wrestle entry (and usually means going back to Scout).

### 4.5 Killer question

The deliverable. One sentence. The form is:

> "The one thing that would decide this is: [specific testable question]. If [answer A], build it. If [answer B], don't."

The killer question names an empirical or contextual question the *user* can answer, usually by looking at real data, asking a stakeholder, or trying a small experiment.

**Wrong:** "Does this fit your team?" (unanswerable)
**Right:** "Is the 95th-percentile burst longer than the token bucket refill window? Pull a day of access logs and look. If yes, bucket won't save you; use the sliding window."

## 5. The optional sixth move: smallest falsifier

For ideas that *can* be tested with a tiny experiment, offer:

> "Want me to sketch the smallest experiment that would falsify this? (Usually ~20 lines of code or a single data query.)"

Only offer when:

- The killer question is empirically answerable.
- The experiment is genuinely small (runs in seconds, fits in one file).
- The user hasn't already said they'll check it themselves.

If the user says yes, the skill writes the experiment inline (in the chat, not to a file) and explains what outcomes mean what. It does **not** run it automatically. The user runs it if they want.

**Do not** pretend this step "validates" the idea. It tests one specific claim. The deliverable is the experiment script plus an outcome-interpretation key — nothing else.

## 6. What Wrestle remembers

The Wrestle gear carries the two *rejected* Scout options in its context. When relevant, it can reference them:

- During attack: "This fails in the same way option #1 would have — neither handles concurrent-writer stability."
- During variants: "Pulling in the reputation idea from option #3 is one way to address this — but note you're reintroducing the state machine you were trying to avoid."

The rejected options are not re-offered. They're background, not menu items.

## 7. Ending Wrestle

Wrestle ends when one of:

- The user gets their answer. The skill delivers a tight summary (§8).
- The user says "actually, I need to rethink this" — skill offers return to Sharpen.
- The user loses interest. Skill notices and stops offering moves.

The skill does not keep asking "what's next?" indefinitely. After three consecutive moves where the user's engagement shortens (one-word replies, no follow-up questions), the skill offers to close:

> "Feels like you've got what you need. Want a two-sentence recap, or should I get out of your way?"

## 8. The closing summary

When Wrestle ends with the user having an answer, the skill delivers a short summary. Under 200 words. Contains:

- The chosen direction in one sentence.
- The killer question and what to do based on its answer.
- One thing to watch out for (the most important attack item that variants didn't eliminate).

Then nothing. No "what would you like to do next?" No menu. Silence.

Example:

> "Go with the sliding window counter, sized to 1-minute × your P99 burst rate. The killer question is whether your cron-fires are within that window — pull last week's access log and check; if they exceed it, re-visit token bucket before you ship. Watch for the hot-caller hot-path: if 5% of callers hold more than 20% of traffic, the per-caller lock becomes your P99 bottleneck and you'll want to shard by caller hash."

## 9. Anti-patterns

- **The report generator:** delivering mechanism + steelman + attack + variants + killer question in one long turn. Wrong. Each move is separate and user-gated.
- **The unrequested variant:** the skill offering variants before the user asked. Wrong. The user steers.
- **The autonomous experimenter:** running the smallest-falsifier experiment without explicit user consent. Wrong. Always offer, never execute.
- **The endless wrestler:** not noticing when the user has what they need and continuing to offer moves. Wrong. Watch for short replies and offer to close.
- **The pivoter:** when attack reveals weaknesses, proposing a fundamentally different idea. Wrong. That's not wrestling; it's a new Scout. Name it as such and offer to re-enter Scout.
- **The false validator:** calling the smallest-falsifier experiment "validation" or "proof." Wrong. It's one data point against one claim.

## 10. Depth over breadth — a reminder

Wrestle is the gear that earns the whole skill its keep. If Wrestle is shallow, the user has no reason to use `/creative` over just asking the main Claude session. Signs of shallow wrestle:

- Mechanism is hand-wavy.
- Attacks are generic ("complex to implement", "could have bugs").
- Variants are the same shape with different words.
- Killer question is unanswerable or obvious.

If the future session notices these, the prompt stance in `08-skill-file.md` is too weak. Strengthen it.
