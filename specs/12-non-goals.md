# 12 — Non-goals

What this system will never do, and why. The fence.

If you're tempted to add any of these, update this doc first — argue with the reasoning — before writing code.

---

## 1. Why non-goals matter

A skill that tries to do everything does nothing well. v1 had twelve loosely connected capabilities (generation, evaluation, selection, refinement, experimentation, memory, self-optimization, sync, sub-agent orchestration, persona management, configuration, multiple quick modes). No user used all twelve. Most users used two and found the other ten in their way.

v2 commits to a small scope. The non-goals are the fence around that scope. Keep the fence in view.

---

## 2. The fence

### 2.1 Not a ranked-idea generator

The system will never produce:

- A ranked list of ideas
- A list of more than three ideas at a time
- A composite score
- A weighted combination of axes
- A "top-N" anything

Creativity isn't a ranking problem. Ranking suggests the best one is obvious if you measure right — but the interesting problems are the ones where there is no measurement that works.

### 2.2 Not an autonomous agent

The system will never:

- Execute experiments without explicit user consent
- Modify project source code
- Create pull requests or issues
- Send any message to any external service
- Run multi-hour exploration sessions unattended

The user is always steering. The skill offers moves; the user picks. Autonomous versions of this system are a different product and should not be built under the `/creative` name.

### 2.3 Not a knowledge base

The system will never:

- Accumulate a searchable pattern library
- Inject prior "successful patterns" into new generations
- Track which ideas worked across projects
- Export learned profiles between users

The user is the knowledge base. The skill is scaffolding. See `07-memory-and-state.md §2`.

### 2.4 Not a prompt-engineering playground

The system will never:

- Self-modify `SKILL.md` based on session outcomes
- Maintain a `prompt_evolution.json` log
- A/B test its own instructions
- Learn personalized prompt styles per user

If the prompts need improvement, humans edit `SKILL.md` in git. See `07-memory-and-state.md §5`.

### 2.5 Not a project-configuration system

The system will never:

- Read a per-project `config.json`
- Scaffold a `.creative-loop/` directory
- Expose tuneables for "exploration budget," "quality threshold," "max iterations"
- Gate behavior on CLAUDE.md directives beyond normal context reading

The configuration surface is editing `SKILL.md`. Per-project configs fragment decisions that should be baked in or genuinely user-level.

### 2.6 Not a multi-agent orchestrator

The system will never:

- Launch sub-agents via the `Agent` tool
- Run generators and evaluators in parallel
- Maintain inter-agent messaging
- Aggregate outputs from multiple agent calls

Sub-agents isolate context. Isolated context prevents the cumulative reasoning this skill depends on. See `02-architecture.md §2`.

### 2.7 Not a session manager

The system will never:

- Resume sessions across invocations automatically
- Maintain a session state machine across different /creative invocations
- Check for "unfinished" sessions
- Prompt the user to continue prior work

Each `/creative` invocation is fresh. If the user wants to resume, they point the skill at a saved transcript. Explicit.

### 2.8 Not a collaboration tool

The system will never:

- Share sessions between users
- Track team-level preferences
- Merge conflicting "creative profiles"
- Require user accounts or identities

This is a solo thinking tool. Team decisions happen in other surfaces (PR reviews, design docs, meetings).

### 2.9 Not a scoring or evaluation service

The system will never:

- Accept "evaluate this idea" as a command that produces scored output
- Compare two ideas quantitatively
- Output anything that looks like a grade

v1 had `/creative evaluate <idea>`. v2 does not. If the user has an idea, they use `/creative wrestle <idea>` — which is qualitative depth, not quantitative grading.

### 2.10 Not a time or cost dashboard

The system will never:

- Estimate tokens or sub-agent calls before starting
- Show a running cost meter
- Warn about "expensive" explorations
- Offer a "cheaper mode"

The skill's footprint is small enough that cost isn't a design concern. If a session runs long, that's because the user wanted depth. Surfacing cost would just nudge toward shallower use.

### 2.11 Not an auto-activator

The system will never:

- Detect "this task needs creative mode" and invoke itself
- Pattern-match on user phrasing to suggest `/creative`
- Hook into other commands

If the user wants the skill, they type `/creative`. If the main Claude session thinks creative mode would help, it can suggest invoking the skill in natural language — but the skill itself doesn't watch for triggers.

(Note: the main Claude harness may detect that `/creative` fits a user's need and surface it; that's fine. What's out of scope is the skill itself adding heuristics to auto-engage.)

### 2.12 Not a rubric producer

The system will never:

- Generate evaluation rubrics for ideas
- Produce "criteria to consider" checklists
- Output bulleted "pros and cons" tables

These are the hallmarks of the consultant voice we're replacing. See `03-interaction-model.md §8`.

---

## 3. Things that look like features but aren't

These are rejected even though users sometimes ask for them. Each rejection has a reason; if the reason no longer applies, the non-goal can be revisited.

### 3.1 "Can you give me five ideas instead of three?"

**Rejected.** Three is the structural commitment. Five dilutes the gut-reaction value (users can't hold five lenses in working memory and feel a clear preference). If three isn't enough, the problem isn't ready for Scout — go back to Sharpen.

### 3.2 "Can you rank them for me?"

**Rejected.** Ranking shifts evaluation from the user to the skill. The user's gut reaction is the signal we're optimizing for.

### 3.3 "Can you remember what I chose last time?"

**Rejected.** Injecting past choices into new generations biases toward the already-known. If the user wants to refer to a past session, they point the skill at it explicitly; the skill reads it as any other file.

### 3.4 "Can you run the Wrestle experiment for me?"

**Rejected.** Wrestle's smallest-falsifier is a sketch, not an execution. The skill writes the experiment inline; the user decides whether and when to run it. Running it would make "validated" a claim the skill could make about an idea — which it can't, honestly.

### 3.5 "Can you support a debate mode where two personas argue?"

**Rejected.** This is the costume-swapping failure mode from `01-philosophy.md §1.2`. An LLM arguing with itself from two stances produces theater, not thinking. The user argues with the skill; that's the actual creative tension.

### 3.6 "Can the skill be invoked silently as part of a larger task?"

**Rejected for v2.0.0.** Silent invocation bypasses the Sharpen gate, which is where the value lives. If this becomes needed, it requires re-thinking how Sharpen runs without a live conversation partner — non-trivial.

### 3.7 "Can you write the implementation after Wrestle?"

**Rejected.** Wrestle ends with a closing summary and silence. If the user wants implementation, they invoke the main Claude session normally — `/creative` hands off, doesn't extend.

---

## 4. When a non-goal should be revisited

The fence should be challenged when one of:

- **Real users consistently request the same excluded feature** (not just imagined demand — actual reports from logged use).
- **The reasoning in the relevant spec section has been invalidated** by something new (e.g., a genuine held-out benchmark for prompt optimization appears).
- **The skill's scope in practice has clearly shifted** and the fence no longer matches what users are using it for.

In all three cases: update the relevant spec doc first with the revised reasoning. Then update this doc to move the item from non-goals to goals. Then update `SKILL.md`.

Never the reverse — don't add code that violates a non-goal and update the spec after the fact.

## 5. The master list

For future skims, the rejected feature list in one place:

- Ranked lists / top-N
- Numeric scores / composite scores / weighted axes
- More than three Scout options
- Sub-agent fan-out / parallel generation
- Multiple evaluators
- Per-project pattern library
- `successful.json` / `failed.json` injection
- `persona_effectiveness.json` learning loop
- Self-optimizing prompts / `/creative optimize`
- Prompt evolution logging
- `/creative init` / per-project scaffolding
- `config.json` tuneables
- `/creative sync` / cross-machine merge
- Cross-session auto-resume
- Auto-loaded prior session context
- Cost/time estimators
- Auto-activation heuristics inside the skill
- Rubric or pros/cons generation
- Autonomous experiment execution
- Multi-user / team collaboration
- `/creative evaluate` as standalone scoring
- "Debate mode" between personas
- "Combine all three" as a skill-proposed fourth option
- Hand-off to implementation inside `/creative`

If the skill grows any of these, it has stopped being v2.
