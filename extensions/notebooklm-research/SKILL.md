---
name: notebooklm-research
description: "Use NotebookLM as a research assistant. Feed its outputs to the agent for grounded implementation."
category: workflow
---

# NotebookLM Research

> **🤖 You don't need to do any of this manually.** This guide explains how this tool works so you can learn and understand it. But the agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

## What Is This?
An optional extension that defines how to use Google NotebookLM as a research companion to the Antigravity agent. NotebookLM excels at synthesizing large documents (papers, docs, videos) into structured insights. This extension defines the handoff protocol: NotebookLM researches → you share the output → the agent implements.

## Why Does It Exist?
AI coding agents are great at writing code but limited in their ability to deeply research complex topics from multiple long-form sources simultaneously. NotebookLM fills this gap - it reads entire books, papers, and documentation sets and produces structured summaries that the agent can act on.

---

## Activation
- Enable in `~/.gemini/settings/extensions.json`: `"notebooklm-research": true`
- Triggered when the user shares NotebookLM output or says "I researched this in NotebookLM"

---

## The Research-to-Production Pipeline

### Step 1: Research (NotebookLM)
The user adds sources to NotebookLM and asks questions. Example:
- "What are the best practices for implementing auth in Convex?"
- "Compare these 3 payment providers for a SaaS app"
- "Summarize the key patterns from this architecture book"

### Step 2: Extract (User)
The user copies NotebookLM's structured output - bullet points, comparisons, or recommendations.

### Step 3: Ground (Agent)
The user pastes the output to the agent with context:
```
Here's what I found in NotebookLM about [topic]. 
Use this to inform our implementation of [feature].
```

The agent then:
1. Reads the research output critically (not blindly applying it)
2. Cross-references with existing skills and project patterns
3. Identifies what's relevant to the current implementation
4. Flags any contradictions with the project's established conventions
5. Implements with the research as informed context - not as gospel

### Step 4: Implement (Agent)
Normal F.O.R.G.E. cycle with the research as grounding context.

---

## Rules for the Agent

- **Never blindly copy** NotebookLM suggestions into code - evaluate first
- **Cross-reference** with existing project conventions and skills
- **Flag conflicts** if NotebookLM recommends something contradicting the project's patterns
- **Cite the source** when making decisions informed by the research: "Based on the NotebookLM research, I'm using X because..."
