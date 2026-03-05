---
description: "Generate reports from research, download locally, and hand off to minibook or Notion publishing."
---

# Report Generation & Handoff

> **Phase 2 - User Input Required.** These steps need user decisions before proceeding.

---

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

### Step 9: Download Reports Locally

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
