---
description: "Autonomous research flow: start research, poll, import, curate, build consensus, and update the research index."
---

# Deep Research Workflow

> **Phase 1 - Autonomous.** Steps 1-7 run continuously without stopping. Do not ask permission between steps.

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

> [!IMPORTANT]
> **Do not stop here to ask the user what to do next.** Continue immediately to Step 5 (curation). The completion summary is informational only.

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

Update `research/index.md` with the consensus and conflict findings before proceeding.

---

## Next Step

> [!IMPORTANT]
> **Do not stop here.** After completing Steps 1-7, immediately proceed to the report generation phase. Read `workflows/report-handoff.md` in this extension folder and continue.
