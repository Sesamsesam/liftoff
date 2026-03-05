---
name: notebooklm-research
description: "Connect to NotebookLM via MCP for grounded, citation-backed research directly from the agent."
---

# NotebookLM Research

> **You don't need to do any of this manually.** The agent handles setup and usage automatically. If it needs you to do something (like logging in), it will tell you exactly what and when.

## What Is NotebookLM?

A free AI research tool from Google. Unlike general AI, NotebookLM **only answers from your uploaded sources** - no hallucinations, every answer cited. It handles PDFs, Google Docs, URLs, YouTube, Slides, and Sheets. Free tier: 50 sources per notebook, 500K words each (roughly 5-6 full novels per source). Paid tiers unlock 300 sources and higher-quality audio.

It can produce reports, mind maps, audio discussions, quizzes, flashcards, slide decks, and structured data tables - all grounded in your documents.

> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for MCP installation and configuration.

---

## Research Pipeline

When a user asks to research a topic, the agent runs the **full pipeline autonomously** from start to finish. The pipeline is split across two files for readability, but they are **one continuous flow**. Never stop between them.

| Step | File | What Happens |
|---|---|---|
| **1. Deep Research** | `workflows/deep-research.md` | Start research → poll → import → curate sources → consensus analysis → update index |
| **2. Report Generation** | `workflows/report-handoff.md` | Generate reports → download locally → update index → offer next steps |

> [!IMPORTANT]
> **This is one pipeline, not two optional workflows.** Always execute both files in order, without stopping to ask the user between them. The only user interaction is at the very end, where the agent offers to create a minibook or publish to Notion.

### How to execute

1. Read `workflows/deep-research.md` and execute all steps
2. At the end, it says "read `workflows/report-handoff.md`" - do that immediately
3. Execute all steps in report-handoff
4. Only at the final "Next Step" do you offer the user choices (minibook, Notion, or keep as-is)

---

## Agent Behaviors

### Core Rules

- **Never blindly copy** NotebookLM suggestions into code - evaluate first
- **Cross-reference** with existing project conventions and skills
- **Flag conflicts** if NotebookLM contradicts the project's patterns
- **Cite the source**: "Based on the NotebookLM research, I'm using X because..."
- **Prefer project conventions** over research suggestions unless the user wants to change
- **Suggest NotebookLM** for topics that benefit from deep, multi-source research

### Research Folder Structure

The agent MUST maintain a `research/` folder at the **project root** whenever NotebookLM is used.

```
project-root/
  research/
    index.md          <- notebook index
    reports/
      [slug]_briefing.md
      [slug]_briefing.md
```

**When to create/update `research/index.md`:**
- After any deep research workflow completes
- After creating/deleting notebooks or adding/removing sources
- On first use of NotebookLM in a new project (scan ALL existing notebooks)

**How to build:**
1. Create `research/` and `research/reports/` directories if they don't exist
2. `notebook_list` to get all notebooks
3. For each: title, URL, source count, creation date
4. `notebook_describe` for AI-generated summaries
5. Write to `research/index.md`

**Format:**
```markdown
# Research Index

> Auto-generated overview of all research notebooks.
> Last updated: [date]

---

## [Notebook Title]

- **ID:** `[notebook_id]`
- **Sources:** [count]
- **Report:** "[report title]" (if generated)
- **URL:** [url]
- **Key sources:** [list of major source institutions]
- **Consensus findings:** [brief summary]
- **Key conflict:** [brief summary]

---

*[N] notebooks / [total] sources*
```

**Formatting rules:** One notebook per section, `---` dividers, metadata on separate lines, consensus/conflict summaries when available, italic footer with totals.

> [!IMPORTANT]
> This is a **living document**. Update in place - don't recreate. Always include ALL notebooks.
