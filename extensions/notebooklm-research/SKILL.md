---
name: notebooklm-research
description: "Use NotebookLM as a research assistant. Feed its outputs to the agent for grounded implementation."
category: workflow
---

# NotebookLM Research

> **🤖 You don't need to do any of this manually.** This guide explains how this tool works so you can learn and understand it. But the agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

## What Is This?

An optional extension that defines how to use **Google NotebookLM** as a research companion alongside the Antigravity agent. NotebookLM excels at reading and synthesizing large amounts of information - entire books, research papers, documentation, even YouTube videos - into structured insights you can act on.

This extension defines the handoff protocol: **NotebookLM researches, you share the output, the agent implements.**

## Why Does It Exist?

AI coding agents are great at writing code, but they have limits when it comes to deeply researching complex topics from multiple long-form sources simultaneously. Think about it:

- The agent can't watch a 2-hour conference talk and extract the key architecture decisions
- The agent can't read 5 research papers side-by-side and compare their approaches
- The agent can't process an entire technical book and pull out what's relevant to your project

**NotebookLM fills this gap.** You feed it your sources, ask it questions, and it produces structured summaries grounded in those sources - with inline citations so you can verify everything. Then you hand that output to the agent, and it turns research into real code.

---

## What Is NotebookLM?

NotebookLM is a free AI tool from Google specifically designed for research. Unlike ChatGPT or other general-purpose AI, NotebookLM:

- **Only uses your sources** - it doesn't make things up from general knowledge
- **Cites everything** - every answer links back to the exact passage in your document
- **Handles massive inputs** - up to 50 sources per notebook, 500,000 words each
- **Produces diverse outputs** - summaries, study guides, FAQs, timelines, mind maps, and even audio discussions

### What You Can Upload

| Source Type | Examples |
|---|---|
| **Documents** | PDFs, Google Docs, Word files, text files, Markdown |
| **Web** | URLs to articles, blog posts, documentation |
| **Media** | YouTube video URLs, audio files |
| **Presentations** | Google Slides |
| **Data** | Google Sheets, images |

### What It Can Create

| Output | What It Is |
|---|---|
| **Summaries** | Condensed overviews of complex documents |
| **Study guides** | Key concepts, glossary, short-answer questions |
| **FAQs** | Common questions answered from your sources |
| **Timelines** | Chronological breakdowns of events or progressions |
| **Mind maps** | Visual maps of how concepts relate |
| **Audio overviews** | Two-voice podcast-style discussions about your content |
| **Structured tables** | Raw information organized into exportable tables |

---

## Activation

- Enable in `~/.gemini/settings/extensions.json`: `"notebooklm-research": true`
- Triggered when you share NotebookLM output or say "I researched this in NotebookLM"
- Also activates when you ask questions that benefit from deep, multi-source research

---

## The Research-to-Production Pipeline

### Step 1: Research (You + NotebookLM)

Go to [notebooklm.google.com](https://notebooklm.google.com) and create a new notebook. Upload the sources relevant to your project. Then ask questions.

**Example research questions:**

| Scenario | What to Ask NotebookLM |
|---|---|
| Building auth | "What are the best practices for implementing auth in Convex?" |
| Choosing a tool | "Compare these 3 payment providers for a SaaS app" |
| Learning patterns | "Summarize the key patterns from this architecture book" |
| API integration | "What are the rate limits and gotchas for this API?" |
| Tech decision | "What are the trade-offs between SSR and CSR for my use case?" |

**Pro tip:** Be specific with your questions. Instead of "tell me about auth," ask "what are the security best practices for session-based auth in a serverless environment?"

### Step 2: Extract (You)

Copy NotebookLM's structured output - bullet points, comparisons, tables, or recommendations. The more structured the output, the better the agent can use it.

**Good outputs to copy:**
- Comparison tables between options
- Ordered lists of best practices
- Step-by-step implementation guides
- Lists of gotchas and edge cases
- Architecture recommendations

### Step 3: Hand Off (You to Agent)

Paste the output into your conversation with the agent, along with context:

```
Here's what I found in NotebookLM about [topic].
Use this to inform our implementation of [feature].
```

Or be more specific:

```
NotebookLM compared 3 payment providers. Based on this research,
I want to go with Stripe. Here are the integration patterns it found:
[paste research]
```

### Step 4: Ground and Verify (Agent)

The agent reads your research critically. It does NOT blindly apply everything. Instead, it:

1. **Reads** the research output carefully
2. **Cross-references** with existing skills, project patterns, and conventions
3. **Identifies** what's relevant to the current implementation
4. **Flags contradictions** if the research recommends something that conflicts with your project
5. **Implements** with the research as informed context, not as gospel

### Step 5: Implement (Agent)

Normal F.O.R.G.E. cycle proceeds, with the research serving as grounding context for design decisions. The agent cites the research when making choices: "Based on your NotebookLM research, I'm using approach X because..."

---

## Advanced NotebookLM Workflows

### The Deep Research Feature

NotebookLM has a built-in "Deep Research" mode that acts like a dedicated research assistant. It can:

- Create an automated research plan from a question
- Browse and synthesize information from multiple online sources
- Produce detailed reports with citations
- Recommend related articles and resources

This is useful when you need background research before even knowing what sources to upload.

### Audio Overviews for Learning

NotebookLM can generate podcast-style audio discussions about your sources. This is perfect for:

- Learning about a new technology while away from your desk
- Getting a high-level understanding before diving into the details
- Reviewing complex architecture decisions in a conversational format

### Custom Expert Personas

You can set up custom AI personas in NotebookLM with specific instructions. For example:

- "You are a senior security engineer reviewing this architecture"
- "You are a database performance expert analyzing these query patterns"
- "You are a UX researcher evaluating these design decisions"

This produces more targeted and useful analysis than generic queries.

---

## Common Use Cases with Antigravity

| Scenario | NotebookLM Does | Agent Does |
|---|---|---|
| **Learn a new API** | Read the docs, extract key patterns and gotchas | Implement the integration following those patterns |
| **Choose between options** | Compare 3-5 alternatives with pros/cons | Implement the chosen option correctly |
| **Understand a codebase** | Analyze architecture docs and READMEs | Apply the patterns to your project |
| **Security review** | Research best practices for your stack | Implement security following those practices |
| **Design system** | Research UI/UX patterns from design articles | Build components following the design principles |

---

## Rules for the Agent

- **Never blindly copy** NotebookLM suggestions into code - evaluate first
- **Cross-reference** with existing project conventions and skills
- **Flag conflicts** if NotebookLM recommends something contradicting the project's patterns
- **Cite the source** when making decisions informed by the research: "Based on the NotebookLM research, I'm using X because..."
- **Ask clarifying questions** if the research output is ambiguous or contradictory
- **Prefer the project's existing conventions** over research suggestions when they conflict, unless the user explicitly wants to change course
- **Suggest NotebookLM** when the user asks about topics that would benefit from deep, multi-source research that's beyond what the agent can do in a conversation
