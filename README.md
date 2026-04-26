# Creative Loop 2 — a sparring partner for open design questions

Not a brainstorming machine. Not a ranked-idea generator. A small skill that sharpens the question, shows you three genuinely different angles, and then goes deep on the one you pick.

## Install

    bash install.sh

This copies `SKILL.md` into `~/.claude/skills/creative/`. Claude Code picks it up automatically — type `/creative` in any session.

## Use

    /creative <your open design question>

That's the whole thing. Three gears (Sharpen → Scout → Wrestle) run in the main conversation. No sub-agents, no scores, no scaffolding files in your project unless you ask.

If the question resolves after Sharpen, the skill stops there. If you know your direction after Scout, it stops there. Depth over breadth.

## Other entry points

    /creative sharpen <problem>     — sharpen only
    /creative scout <refined>       — skip sharpen, go to three angles
    /creative wrestle <idea>        — go deep on an idea you already have
    /creative save                  — save this session to creative-sessions/
    /creative note <text>           — append to creative-notes.md

## Philosophy

See `specs/01-philosophy.md` for why this is a single-thread, no-scoring, no-memory system. The short version: v1 industrialized the shallow parts of creativity (generation, scoring) and skipped the deep parts (re-framing, wrestling). v2 inverts that.

## How to use with other tools

You can use the skill outside of Claude Code in other tools and even with mobile apps like ChatGPS, Gemini, Meta AI, ...

Generic AI prompt:

    Execute this skill: https://raw.githubusercontent.com/mari0car/creative-loop-2/refs/heads/main/SKILL.md

If that did not work, try these steps:

1. Copy SKILL.md content to your clipboard
2. Open your AI app
3. Enter first prompt:
```
Execute this skill:
<paste SKILL.md content>
```
4. Now you can use:
```
/creative <your open design question>
```
