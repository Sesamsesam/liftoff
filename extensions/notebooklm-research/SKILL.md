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

## Automated Workflow

**Every time you do deep research, this runs in two phases:**

### Phase 1 - Autonomous Flow (no user interaction)
Steps 1-7 run continuously without stopping. Do not ask permission between steps.

1. **Start** - Launch research across notebooks
2. **Poll** - Wait for completion
3. **Import** - Auto-import all discovered sources
4. **Summary** - Show completion stats
5. **Curate** - Auto-apply quality filter rules, remove low-quality sources
6. **Consensus** - Map agreements and conflicts across sources
7. **Brain Update** - Refresh `research/index.md`

### Phase 2 - User Input Required
8. **Report** - Ask the angle question, then generate
9. **Download** - Save reports locally
10. **Handoff** - Offer minibook creation if minibook-pipeline is active

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
research_status(notebook_id, query="<original query>", poll_interval=<see below>, max_wait=<see below>)
```

**Polling intervals by mode:**
- **Fast mode:** `poll_interval=30, max_wait=180` (every 30s, up to 3 min)
- **Deep mode:** `poll_interval=120, max_wait=900` (every 2 min, up to 15 min)

- Always use `query` for matching (task IDs change during deep research)
- If `max_wait` expires while still `in_progress`, tell the user:
  > "Research is still running - these deep dives can take a while 🔬. I'll stop checking now. Take a look in a few minutes and when you think it's done, just tell me and I'll import the results!"
- Poll multiple notebooks in parallel
- **Auth recovery:** If any MCP call fails with an auth/session error during polling, run `nlm login` yourself (do not ask the user to run it), tell them a browser is opening, wait for confirmation, then resume polling

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

### Step 5: Source Curation (Automatic)

Immediately after the completion summary, auto-curate sources. Do NOT ask the user whether to curate - always do it.

#### 5a. Classify Sources

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

**Auto-apply keep/remove rules - do not ask for confirmation.** Delete removed sources with `source_delete(source_id, confirm=True)`. Show a brief summary of what was kept and removed after the fact.

#### 5b. Delete Low-Quality Sources

After classification, immediately delete all sources marked for removal. Do not present the list for user approval - the rules above are strict enough to trust. Log what was removed in the completion summary.

### Step 6: Consensus Analysis (Automatic)

Run immediately after curation, no user interaction needed.

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

Present the consensus/conflict map to the user, then update `research/index.md`.

### Step 7: Update Research Index

Update `research/index.md` with the consensus and conflict findings before proceeding to Phase 2.

---

## Phase 2: User Input Required

### Step 8: Report Generation

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

#### 5d. Download Reports Locally

After all reports are generated, **download each report** into the project's `research/reports/` folder:

```python
# Try API download first
download_artifact(
    notebook_id="[notebook ID]",
    artifact_type="report",
    output_path="research/reports/[slug]_briefing.md"
)
```

**If `download_artifact` fails** (e.g. "not supported for async download"), use the fallback:

```python
# Fallback: extract report content via notebook_query
notebook_query(
    notebook_id="[notebook ID]",
    query="Reproduce the full text of the Briefing Doc report that was just generated, preserving all headings, citations, and formatting."
)
# Save the response text as research/reports/[slug]_briefing.md
```

**Naming convention:** lowercase slug from notebook title + `_briefing.md`:
- `fortune500_briefing.md`
- `workforce_displacement_briefing.md`
- `upskilling_briefing.md`
- `ai_frameworks_briefing.md`

> [!IMPORTANT]
> **Always download reports.** The research is not complete until report files exist in `research/reports/`.

After all reports are downloaded, update `research/index.md`.

### Step 10: Handoff

After reports are downloaded, offer the next step:

> "Your research is ready! Here's what I can do next:
>
> 1. **Write a minibook** - a polished, illustrated booklet you can share. I'll draft an outline first for your approval.
> 2. **Publish reports to Notion** - if you just want the raw reports formatted as Notion pages.
>
> Or you can just keep the research as-is and decide later."

**Branch routing:**
- If user picks **minibook**: activate the `minibook-pipeline` extension and pass the research reports to it
- If user picks **Notion**: activate the `notion-publishing` extension and pass the report files to it
- If user says **later**: end the workflow. Research is saved and ready

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
    index.md          <- notebook index (was notebooklm-brain.md)
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
