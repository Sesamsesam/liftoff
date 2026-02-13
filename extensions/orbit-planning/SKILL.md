---
name: orbit-planning
description: "O.R.B.I.T. - strategic project planning before you build. Objective, Requirements, Blueprint, Implementation Roadmap, Track."
category: workflow
---

# O.R.B.I.T. - Strategic Project Planning

> **🤖 You don't need to do any of this manually.** This guide explains how this tool works so you can learn and understand it. But the agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

> **O**bjective - **R**equirements - **B**lueprint - **I**mplementation Roadmap - **T**rack
>
> *"Set the trajectory before you launch."*

## What Is This?

O.R.B.I.T. is a guided planning process that helps you define your project *before* any code is written. The agent walks you through 5 phases - asking questions, pushing for detail, and building a professional project blueprint. You don't need to know what a PRD is or how to write user stories. The agent translates everything into plain language and does the heavy lifting.

## Why Does It Exist?

F.O.R.G.E. handles *how* to build things right. But it assumes you already know *what* you're building. Without strategic planning, even a perfectly executed F.O.R.G.E. cycle can build the wrong thing - or build it in the wrong order. O.R.B.I.T. fills that gap. It's the difference between a vibe coder who says "build me an app" and a professional who says "here's exactly what we're building, why, and in what order."

## What It Does For You

You answer questions. The agent builds your blueprint. By the end, you have a clear vision, prioritized features, technical architecture, and a phased roadmap with work orders - the exact things that professional product teams spend weeks creating. Then F.O.R.G.E. takes over and executes.

---

## Activation

- Enable in `~/.gemini/settings/extensions.json`: `"orbit-planning": true`
- Trigger with: "Let's plan a project," "Start ORBIT," or "Help me plan this app"
- The agent recognizes planning-intent language and suggests ORBIT when appropriate

---

## The 5 Phases

### Phase 1: O - Objective

> *"What are we building, and why does it matter?"*

Ask open-ended questions and push for depth. If the user gives a one-liner, push back:

*"That's a starting point, but I need the full picture. Who would use this? What's frustrating about what's already out there? What would make yours worth switching to?"*

**Questions to ask:**
- "What problem does this solve?"
- "Who is this for? Describe them like a person, not a demographic."
- "Why does this need to exist? What happens if it doesn't?"
- "Is there something out there that already does this? What's different about yours?"
- "What does success look like 3 months from now?"

**Keep asking until the vision is crystal clear.** Most beginners stop too early - that's where the agent adds value by probing deeper.

**Produces:** Vision Statement (2-3 sentences) + Problem Definition

---

### Phase 2: R - Requirements

> *"What must it do? What would be nice to have?"*

Help the user think in terms of user actions, not technical features:

- "Walk me through what a user does from the moment they open the app."
- "What are the 3 things it absolutely MUST do on day one?"
- "What would make users say 'wow, this is amazing' - but could wait for v2?"
- "Are there hard constraints? Budget, timeline, platform?"

**Introduce priorities naturally:**
*"Let's sort these into three buckets: P1 is must-have for launch, P2 is important but can wait, P3 is dream features."*

For each feature, ask: "Can you describe what this looks like from the user's perspective?"

**Produces:** Feature Set with P1/P2/P3 priorities + User Stories (plain language)

---

### Phase 3: B - Blueprint

> *"How will we build it? What tools and architecture?"*

#### Default Stack Presentation

Open with:
> *"Let's talk about how to build this. Our default stack is React + Vite for the frontend, Convex for the backend, Clerk for auth, and Cloudflare Pages for hosting. This is a battle-tested combo that handles most apps beautifully. Do you have specific tech preferences, or should we roll with this?"*

If the user accepts defaults, confirm and move on.

If the user mentions Vercel, Supabase, Firebase, or similar consumer-tier tools, respond honestly:
> *"Those are popular choices and they work. But the author of this setup, Sami, has explicitly included these alternatives because they give you a bigger bang for your buck - less money, more power, and they're what serious indie builders and big tech engineers actually use. The learning curve is almost the same. I'd recommend sticking with Convex + Cloudflare unless you have a specific reason to go elsewhere. But if you insist, we can absolutely use [their choice]."*

#### Use-Case Tech Decisions

Probe for specific needs that require specific tools:

| If the user mentions... | Recommend |
|---|---|
| Users uploading video/large files | Cloudflare R2 for storage + a compression pipeline |
| AI features, semantic search, embeddings | Cloudflare Vectorize or Google Vertex AI |
| RAG (retrieval-augmented generation) | Cloudflare AutoRAG or custom pipeline |
| Real-time collaboration | Convex subscriptions (built-in) |
| Payments | Stripe |
| Email/notifications | Resend or Cloudflare Email Workers |
| Mobile app | React Native or Expo |
| Static/content site | Astro (see `stack-pro-max` defaults) |
| Background jobs / scheduled tasks | Convex cron jobs or Cloudflare Workers |

**Ask these questions to surface needs:**
- "Does this need user accounts and login?"
- "Will users upload files, images, or video?"
- "Does it need real-time updates (like a chat or live dashboard)?"
- "Do you need AI/search features?"
- "Any third-party services to connect? (payments, email, maps, analytics)"
- "Is this web-only, or do you need a mobile app?"

**If the user chooses a different stack:**
- Note it in the Blueprint
- Create a project-level override - do NOT modify global skills
- Explain any trade-offs honestly

**Produces:** Technical Blueprint with stack choices, architecture overview, integration notes

---

### Phase 4: I - Implementation Roadmap

> *"What do we build first, second, third?"*

Break P1 features into a concrete, ordered build plan:

- Group related features into logical phases
- Each phase has: features included, estimated complexity (simple/medium/complex), and what's testable at the end
- Phase 1 MUST produce something usable - even if minimal

**Propose the roadmap and ask for feedback:**
> *"Here's how I'd sequence this. Phase 1 gets you a working app with [core features]. Phase 2 adds [improvements]. Phase 3 brings in [advanced stuff]. Does this order make sense?"*

Each phase is broken into **work orders** - specific tasks the agent will execute via F.O.R.G.E.

**Produces:** Phased Roadmap with work orders per phase

---

### Phase 5: T - Track

> *"Keep the plan alive as the project evolves."*

The O.R.B.I.T. document is a **living plan**, not a one-time output.

#### The `orbit.md` File

Lives at `docs/orbit.md` in the project root. This is the single source of truth for what you're building and why.

#### Agent Rules (Always Active)

1. **Before starting any new task**: Check `orbit.md`. Is this task in the roadmap? Has the direction shifted?
2. **When the user changes direction in chat** (e.g., "actually, let's scrap that feature and do X instead"):
   - Acknowledge the change
   - Update `orbit.md` immediately (move features, re-prioritize, adjust roadmap)
   - Then proceed with F.O.R.G.E. to execute the new direction
3. **After completing a work order**: Check it off in `orbit.md`
4. **When new ideas come up**: Add them to P2/P3 in `orbit.md` automatically
5. **Never silently ignore the plan.** If reality diverges from the plan, the plan gets updated first.

This is baked into O.R.B.I.T. itself - the agent follows these rules as part of the Track phase skill instructions. You should never have to say "go update the plan" manually.

---

## With Beads vs Without Beads

O.R.B.I.T. works with or without Beads, but the experience is different:

### Without Beads

- O.R.B.I.T. works perfectly **within a session**. The Track rules ensure `orbit.md` stays current as you work.
- **Across sessions**, the new agent rediscovers `orbit.md` by reading it from the project root. It knows what the plan says, but loses the nuanced context of *why* decisions changed.
- You may occasionally need to remind the agent of recent pivots or explain context that was discussed verbally in a previous session but didn't make it into `orbit.md`.
- You're essentially doing some of the memory work yourself - probing the agent, pointing it back to the plan, reminding it of changes.

### With Beads Active

- Beads persists session context automatically. When a new session starts with `bd ready`, the agent already knows: "We changed Feature X to Y last session because the user realized Z."
- The *why* behind decisions carries over, not just the *what*.
- Cross-session continuity is seamless - each new session picks up with full awareness.
- You spend zero time re-explaining or reminding. The agent just knows.

> **Bottom line:** Beads is not required, but it eliminates the friction of re-orienting a new agent session. Without it, `orbit.md` is your safety net. With it, `orbit.md` + Beads context together give you a near-perfect continuous experience.

---

## Relationship to F.O.R.G.E.

```
O.R.B.I.T. (strategic)    ->    F.O.R.G.E. (tactical)
"What to build and why"    ->    "How to build it right"

Phase I work orders        ->    become F.O.R.G.E. tasks
orbit.md                   ->    referenced during Foundation phase
```

- O.R.B.I.T. runs **once** at project start (and is revisited via Track)
- F.O.R.G.E. runs **for every task** within the project
- During F.O.R.G.E.'s Foundation phase, the agent checks `orbit.md` for context

---

## The `orbit.md` Template

When O.R.B.I.T. completes, the agent creates this file at `docs/orbit.md`:

```markdown
# Project: [Name]
> Generated by O.R.B.I.T. | Last updated: [date]

## Objective
[Vision statement + problem definition from Phase 1]

## Requirements

### P1 - Must Have (Launch)
- [ ] Feature A - [user story]
- [ ] Feature B - [user story]

### P2 - Important (Post-Launch)
- [ ] Feature C - [user story]

### P3 - Dream Features
- [ ] Feature D - [user story]

## Blueprint
- **Frontend**: [stack choice]
- **Backend**: [stack choice]
- **Auth**: [stack choice]
- **Hosting**: [stack choice]
- **Storage**: [if applicable]
- **AI/Search**: [if applicable]
- **Integrations**: [third-party services]

### Architecture Overview
[High-level description of how components connect]

## Roadmap

### Phase 1: [Name] - [status]
- [ ] Work order 1 - [description]
- [ ] Work order 2 - [description]
- [ ] Work order 3 - [description]

### Phase 2: [Name] - [status: not started]
- [ ] Work order 4 - [description]

### Phase 3: [Name] - [status: not started]
- [ ] Work order 5 - [description]

## Change Log
- [date] Initial O.R.B.I.T. plan created
```
