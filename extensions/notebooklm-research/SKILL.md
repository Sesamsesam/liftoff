---
name: notebooklm-research
description: "Connect to NotebookLM via MCP for grounded, citation-backed research directly from the agent."
---

# NotebookLM Research

> **You don't need to do any of this manually.** The agent handles setup and usage automatically. If it needs you to do something (like logging in), it will tell you exactly what and when.

## What Is NotebookLM?

A free AI research tool from Google. Unlike general AI, NotebookLM **only answers from your uploaded sources** - no hallucinations, every answer cited. It handles PDFs, Google Docs, URLs, YouTube, Slides, and Sheets. Free tier: 50 sources per notebook, 500K words each (roughly 5-6 full novels per source). Paid tiers unlock 300 sources and higher-quality audio.

It can produce reports, mind maps, audio discussions, quizzes, flashcards, slide decks, and structured data tables - all grounded in your documents.

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- AGENT SETUP - The user can ignore everything below -->
<!-- until the "Automated Workflow" section.            -->
<!-- ═══════════════════════════════════════════════════ -->

## MCP Setup (Agent-Only)

> [!NOTE]
> **Users can skip this section.** The agent reads these instructions to auto-install and configure everything. You only need to act when the agent explicitly asks you.

### Prerequisites

- **uv** (Python package manager) - auto-installed if missing
- **Google Chrome** - required for one-time browser authentication
- **A Google account** with access to [notebooklm.google.com](https://notebooklm.google.com)

### Installation

```bash
uv tool install notebooklm-mcp-cli    # Install CLI + MCP
nlm login                              # One-time auth (opens Chrome)
nlm doctor                             # Verify connection
```

- Credentials: `~/.notebooklm-mcp-cli/profiles/default`
- If auto mode fails: `nlm login --manual --file cookies.txt`
- **Never share or commit the credentials directory**

### MCP Config

Add to `~/.gemini/antigravity/mcp_config.json`:

```json
"notebooklm": {
  "command": "uvx",
  "args": ["--from", "notebooklm-mcp-cli", "notebooklm-mcp"]
}
```

This gives the agent 29 native MCP tools. **Always prefer MCP tools over CLI commands.**

> [!IMPORTANT]
> **Context window warning:** 29 tools is a lot. Disable this MCP when not actively using NotebookLM.

### Auto-Setup Behavior

When this extension is activated and setup hasn't been completed:

1. Check `which uv` - install if missing
2. Check `which nlm` - install via `uv tool install notebooklm-mcp-cli` if missing
3. Check MCP config for `"notebooklm"` entry - add if missing
4. Check auth via `nlm login --check` - guide user through `nlm login` if needed
5. Verify with `nlm doctor`
6. Inform user to reload IDE so MCP tools become available

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- AUTOMATED WORKFLOW - This is the core skill.       -->
<!-- ═══════════════════════════════════════════════════ -->

## Automated Workflow

**Every time you do deep research, this loop runs automatically:**

1. **Start** - Launch research across notebooks
2. **Poll** - Wait for completion
3. **Import** - Auto-import all discovered sources
4. **Summarize** - Show completion stats
5. **Curate + Report** *(offered, not automatic)* - Filter to top-quality sources, generate consensus-driven reports
6. **Brain Update** - Refresh `notebooklm-brain.md`

*(Without this skill, you'd manually import sources, clean up failures, and request reports every single time. Now it's automatic.)*

---

### Step 1: Start Research

```
research_start(notebook_id, query, source="web", mode="deep"|"fast")
```

- **Deep** (~5 min, ~40-80 sources): comprehensive research
- **Fast** (~30s, ~10 sources): quick lookups

For multiple notebooks, launch all `research_start` calls in parallel.

### Step 2: Poll Until Complete

```
research_status(notebook_id, query="<original query>", poll_interval=30, max_wait=300)
```

- Always use `query` for matching (task IDs change during deep research)
- If `max_wait` expires while still `in_progress`, poll again
- Poll multiple notebooks in parallel

### Step 3: Auto-Import Sources

```
research_import(notebook_id, task_id)
```

- Call **immediately** when status returns `completed`
- Import all sources by default (omit `source_indices`)
- Import each notebook as it completes - don't wait for all

> [!IMPORTANT]
> **Always auto-import.** Never leave research in "completed but not imported" state.

### Step 4: Completion Summary

Dynamically pull data from `notebook_list` and present:

```
## Research Complete

| Notebook | Sources | Link |
|---|---|---|
| [Title] | [count] | [url] |
| **Total** | **[sum]** | |

### Actions Taken
1. Created [N] notebooks with targeted research prompts
2. Launched deep research across all notebooks
3. Polled until all research completed
4. Auto-imported all discovered sources

All [N] notebooks are ready to query.
```

Always use live data - never hard-code numbers.

### Step 5: Source Curation + Report Generation (On-Demand)

After the summary, **offer** this step:

> "Want me to curate sources and generate a comprehensive report for each notebook?"

If agreed, run sub-steps **for each notebook independently** in sequence.

#### 5a. Source Curation

Use `notebook_query` to have NotebookLM classify its own sources (it has already parsed every word of every source).

**Curation query:**

```
Classify every source in this notebook. For each source, provide:
1. Source title
2. Publication year (or best estimate)
3. Source credibility tier:
   - TIER_1: Primary research institutions, academic papers, government reports, major consultancies, or any organization that conducted original research with documented methodology
   - TIER_2: Established journalism outlets with editorial oversight, official company filings, earnings reports, or industry body publications
   - TIER_3: Blogs, forums, social media, opinion pieces, listicles, content aggregators, or sources with no clear institutional backing
4. Data quality: ORIGINAL (contains its own data, surveys, experiments, or first-hand analysis) or DERIVATIVE (summarizes, repackages, or comments on other sources)

Be strict. If unsure about credibility, default to TIER_3. Format as a numbered list.
```

**Keep/Remove rules:**
- **Keep:** TIER_1 + ORIGINAL from the current year
- **Keep:** TIER_2 + ORIGINAL from the current year
- **Keep:** TIER_1 + DERIVATIVE only if the original source is NOT already present
- **Remove:** All TIER_3 sources
- **Remove:** Anything older than 12 months
- **Remove:** DERIVATIVE sources when a higher-tier ORIGINAL covering the same findings exists

**Present keep/remove lists to the user for confirmation before deleting.** Delete confirmed sources with `source_delete(source_id, confirm=True)`.

#### 5b. Consensus Analysis

Query each notebook to map agreement vs. conflict:

```
Analyze the remaining sources for consensus and conflict:
1. What key findings do MULTIPLE sources agree on? List each and note how many sources support it.
2. Are there claims where sources directly contradict each other? List each conflict with the disagreeing sources.
3. Any outlier predictions supported by only a single source?

Focus on substantive claims, not stylistic differences.
```

This consensus map guides report structure:
- **Consensus findings** become the main body
- **Conflicts** are isolated into an appendix
- **Single-source outliers** are noted as "worth monitoring"

#### 5c. Report Generation

Ask **one focusing question** before generating:

> "I'm about to generate a report for each notebook ([list titles]). Any specific angle, or should I go broad?"

**Generate per notebook using `studio_create`:**

```python
# Run for EACH notebook individually
studio_create(
    notebook_id="[current notebook ID]",
    artifact_type="report",
    report_format="Create Your Own",
    custom_prompt="""Create a comprehensive, consensus-driven report. Follow this structure:

    (1) EXECUTIVE OVERVIEW - Landscape summary based on majority source agreement.

    (2) CONSENSUS FINDINGS - Main body. Only findings supported by 2+ sources. Organize thematically, not by source. Cite all supporting sources inline. Must read as one coherent narrative.

    (3) SUPPORTING DATA - Key statistics and projections reinforcing consensus. Cite origins.

    (4) FORWARD-LOOKING OUTLOOK - Converging predictions. Note confidence (strong consensus vs. emerging trend).

    (5) CONTESTED AREAS (appendix) - Separated from main narrative. Each conflict: what each side claims, which sources support each position.

    (6) OUTLIER SIGNALS (appendix) - Single-source claims lacking corroboration. Present as "worth monitoring."

    Main body (1-4) must be unified with no contradictions. All disagreements in 5-6 only.""",
    confirm=True
)
```

Each notebook's report becomes the **foundation** for downstream studio artifacts (audio, quizzes, slides, etc.).

After all reports are generated, update `notebooklm-brain.md`.

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- AGENT BEHAVIORS - Rules the agent always follows   -->
<!-- when this extension is active.                     -->
<!-- ═══════════════════════════════════════════════════ -->

## Agent Behaviors

### Core Rules

- **Never blindly copy** NotebookLM suggestions into code - evaluate first
- **Cross-reference** with existing project conventions and skills
- **Flag conflicts** if NotebookLM contradicts the project's patterns
- **Cite the source**: "Based on the NotebookLM research, I'm using X because..."
- **Prefer project conventions** over research suggestions unless the user wants to change
- **Suggest NotebookLM** for topics that benefit from deep, multi-source research

### NotebookLM Brain Overview

The agent MUST maintain a `notebooklm-brain.md` file at the **project root** whenever NotebookLM is used.

**When to create/update:**
- After any deep research workflow completes
- After creating/deleting notebooks or adding/removing sources
- On first use of NotebookLM in a new project (scan ALL existing notebooks)

**How to build:**
1. `notebook_list` to get all notebooks
2. For each: title, URL, source count, creation date
3. `notebook_describe` for AI-generated summaries
4. Write to project root as `notebooklm-brain.md`

**Format:**
```markdown
# NotebookLM Brain

> Auto-generated overview of all NotebookLM notebooks.
> Last updated: [date]

---

## [Notebook Title]

[notebook_describe summary paragraph]

- **Sources:** [count]
- **Created:** [date]
- **Open:** [url]

---

*[N] notebooks / [total] sources*
```

**Formatting rules:** One notebook per section, `---` dividers, summary as flowing paragraph, metadata on separate lines, no dense tables, italic footer with totals.

> [!IMPORTANT]
> This is a **living document**. Update in place - don't recreate. Always include ALL notebooks.
