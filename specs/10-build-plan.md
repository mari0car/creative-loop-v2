# 10 — Build Plan

A self-contained plan for the next session to actually build the skill from these specs.

This doc assumes you (the next session) have these specs but no other context. Work top to bottom.

---

## 1. Prerequisite checks

Before starting, verify:

- [ ] You have read `01-philosophy.md` in full. The rejections there are load-bearing.
- [ ] You have read `08-skill-file.md`. That's your primary build artifact.
- [ ] You are working in a fresh repo (`creative-loop-v2` or equivalent) with `specs/` populated.
- [ ] The user has confirmed they want v2 built from these specs. If the user is asking for changes to v1, stop and clarify.

If any of these fail, ask the user before proceeding.

## 2. Build phases

Three phases. Each ends with a working, usable artifact. Do not start Phase 2 before Phase 1 is validated; do not start Phase 3 before Phase 2 is validated.

### Phase 1 — Skill and installer (MVP)

**Goal:** `/creative <problem>` works end-to-end in at least one test case.

**Steps:**

1. Create `SKILL.md` at the repo root using the template in `08-skill-file.md §2`.
2. Adjust prose as needed but preserve the structural sections (Frontmatter, Posture, Sharpen, Scout, Wrestle, Save/notes, Hard rules).
3. Verify line count is under 250. If over, cut rather than split.
4. Create `install.sh` per `08-skill-file.md §4`. Make it executable.
5. Create a minimal `README.md` per `09-file-layout.md §4`.
6. Create `.gitignore` with `creative-sessions/` entry.
7. Run `bash install.sh` and confirm `~/.claude/skills/creative/SKILL.md` exists and matches.
8. **Validate:** Open a fresh Claude Code session in an unrelated project and invoke `/creative How should I name the module that converts internal events to webhook payloads?`. The skill should:
   - Ask at least one Sharpen question.
   - Propose a refined statement for confirmation.
   - Produce three framings in Scout format.
   - Enter Wrestle with Mechanism on whichever option the tester picks.

**Phase 1 deliverable:** a working skill file, installer, and README. Test case passes.

### Phase 2 — Golden-path examples

**Goal:** demonstrate and stress-test the skill across its three canonical interaction shapes.

**Steps:**

1. Read `11-test-cases.md` for the three golden paths.
2. Run each golden-path scenario in a live Claude Code session.
3. Transcribe (lightly edit for clarity — preserve skill output verbatim) into `examples/`:
   - `examples/rate-limiting-full.md` (full 3-gear flow)
   - `examples/pagination-self-resolves.md` (Sharpen exits; no Scout or Wrestle)
   - `examples/module-naming-quick.md` (quick path — Scout only via direct entry)
4. If any run reveals a skill bug (tone drift, rule violation, structural deviation), go back to Phase 1 and fix `SKILL.md` before capturing the transcript.

**Phase 2 deliverable:** three example transcripts that actually happened. Each matches the expected shape from `11-test-cases.md`.

### Phase 3 — Polish and publish

**Goal:** the repo is shareable.

**Steps:**

1. Add `LICENSE` (MIT is the default unless the user says otherwise).
2. Review `README.md` — can a stranger install and use the skill in under 2 minutes?
3. Verify the no-forbidden-files invariant: no `.creative-loop/`, no `personas/`, no `prompts/`, no `patterns/`, no `config.json` anywhere in the repo except in specs docs that describe v1 for contrast.
4. Run a diff pass against `01-philosophy.md §5` rejections — confirm none of them are present as code.
5. Check `SKILL.md` against the Hard Rules list in `08-skill-file.md §2` — every rule is present verbatim or a close paraphrase.
6. Commit and tag `v2.0.0`.

**Phase 3 deliverable:** clean, documented, working repo ready to share.

## 3. Build anti-patterns

Things to avoid during the build — watch for these tempting detours.

### 3.1 The scope creep

"While I'm building the skill, let me also add…" No. Ship the 215-line skill first. Additions come later, after the skill has survived real use.

### 3.2 The structured-brief temptation

You will find yourself wanting to make Sharpen's output a JSON blob with fields. Don't. Re-read `04-sharpen.md §4.1`.

### 3.3 The "let me add scoring back, just a little"

You will find yourself wanting to add at least a "confidence" or "recommended" indicator to Scout's three framings. Don't. Re-read `01-philosophy.md §5` and `05-scout.md §4`.

### 3.4 The personas revival

You will find yourself wanting to pull in one or two "lenses" as files. Don't — they're embedded in the Scout section prose. Re-read `09-file-layout.md §7`.

### 3.5 The fake test

You will be tempted to run Phase 2 examples by prompting the skill yourself and writing down what it would have said. Don't. Actually run them as a user would. The value is in catching tone drift, which you won't catch via imagination.

## 4. When to stop and ask the user

Stop and ask if:

- A spec doc contradicts another spec doc. Ask which wins.
- You find a scenario the specs don't cover (e.g., user does X — what should the skill do?). Ask what the intended behavior is; don't guess.
- Your `SKILL.md` is over 300 lines and you can't see how to cut. Show the user the current state and ask what to cut.
- Any example run reveals a design flaw. Don't paper over it — surface it.

## 5. Build estimate

Realistic sizing for the next session, with a reasonable model:

| Phase | Turns | Wall time |
|---|---|---|
| Phase 1 — skill + installer + README | ~15 | 20 min |
| Phase 2 — three example runs | ~30 | 40 min |
| Phase 3 — polish | ~10 | 15 min |

Total: ~75 minutes across ~55 turns. Budget accordingly.

## 6. Success criteria for "done"

The skill is done (for v2.0.0) when all of these are true:

- [ ] `SKILL.md` exists, under 250 lines, follows `08-skill-file.md §2` structure.
- [ ] `install.sh` works on a clean machine.
- [ ] `bash install.sh && /creative <problem>` works in a fresh session.
- [ ] Three example transcripts exist in `examples/`, each from an actual run.
- [ ] No forbidden artifacts (`01-philosophy.md §5`) exist anywhere in the repo.
- [ ] `README.md` gets a new user from zero to first invocation in under 2 minutes.
- [ ] A test user confirms at least one of `11-test-cases.md`'s success signals (from `01-philosophy.md §7`) on one real problem.

If any fail, the skill isn't done. Iterate on `SKILL.md` — not on the specs, unless the spec is wrong.

## 7. What not to build in v2.0.0

Deferred to a future version (or never — needs philosophy discussion first):

- Auto-activation heuristics (main Claude session decides when to invoke `/creative`). Requires a clear signal function; not trivial.
- Cross-session linking ("last week we looked at this, now extend it"). Possible but would require reading saved sessions; see `07-memory-and-state.md §6`.
- A hybrid-with-local-config mode where a project can inject tone constraints. Probably worth revisiting, but adds surface area.
- A "team sparring" mode where multiple users share sessions. Out of scope.

Do not build these in v2.0.0 even if they seem easy. They'll be easier to judge after v2.0.0 has seen real use.

## 8. Iteration strategy post-v2.0.0

After the skill ships and gets used:

- Collect failure-mode reports (user said the skill did X instead of Y).
- Group them by category: tone drift, rule violation, gear-flow bug, missing move, unhelpful pushback.
- For each category, decide: can `SKILL.md` prose fix it, or does a spec doc need updating first?
- Changes that affect behavior require a `SKILL.md` edit + a commit with a clear message.
- Changes that reflect a shift in philosophy require editing a spec doc first, then `SKILL.md`.

Never edit `SKILL.md` to fix a symptom without understanding the cause. The rejections in `01-philosophy.md §5` exist because v1 repeatedly added symptom-fixes that compounded into the system we're replacing.
