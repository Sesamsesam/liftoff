---
name: minibook-pipeline
description: "End-to-end minibook creation: write a manuscript from research, generate chapter imagery, and publish to Notion with proper layout."
---

# Minibook Pipeline

> **Research to published book in three steps.** The agent handles writing, image generation, and Notion publishing. You approve the outline, review the prose, and pick the visual style.

This extension turns grounded research (typically from NotebookLM) into a polished, illustrated minibook published on a Notion page. It codifies the workflow used to produce "The AI Shift" - an 8-chapter, 45,000-character book synthesized from four research briefings.

---

## Getting Started

When a user asks to create a minibook, the agent must run through these prerequisite checks **before** starting any writing. Do not skip these steps.

### Check 1: Is NotebookLM connected?

Look for the `notebooklm-research` extension in `~/.gemini/extensions/extensions.json`.

- **If active (`true`):** Proceed to Check 2.
- **If dormant (`false`):** Tell the user:
  > "To create a minibook, we first need research to write from. The best way is through NotebookLM. Let me help you activate and set up the `notebooklm-research` extension first."
  
  Then activate it (`set to true` in extensions.json) and walk them through the NotebookLM setup per that extension's SKILL.md.
- **If missing entirely:** Tell the user the `notebooklm-research` extension needs to be installed. Guide them through running the Liftoff installer, or manually copying the extension to `~/.gemini/extensions/notebooklm-research/`.

> [!NOTE]
> NotebookLM is the recommended research source, but not the only one. If the user already has research materials (PDFs, articles, notes, reports) they want to use instead, skip straight to Check 3.

### Check 2: Does research exist for this topic?

Ask the user: **"What topic do you want to write about? Do you already have research on this, or should we start from scratch?"**

- **If research exists:** Ask where it lives (NotebookLM notebook, local files, etc.) and proceed to Check 3.
- **If no research yet:** Guide the user through the research phase first:
  1. Create a NotebookLM notebook for the topic
  2. Add relevant sources (URLs, PDFs, YouTube videos, pasted text)
  3. Generate research artifacts: a Briefing Doc, Study Guide, or custom report
  4. Download those artifacts locally

  > "Before we can write a minibook, we need solid research to build on. Let's start by creating a NotebookLM notebook for your topic and gathering sources. Once we have research reports generated, we will use those as the foundation for your book."

  Do not proceed to writing until the user has at least 2-3 research artifacts downloaded.

### Check 3: Are source materials available locally?

Check for files in `research/Minibook/<book-slug>/sources/` or wherever the user indicates.

- **If sources exist locally:** Summarize what is available and proceed to Workflow 1 (Write).
- **If sources are in NotebookLM but not downloaded:** Download the research artifacts using `mcp_notebooklm_download_artifact` and save them into the `sources/` folder.
- **If sources are elsewhere** (Google Drive, web URLs, etc.): Help the user gather them into the `sources/` folder for traceability.

> [!IMPORTANT]
> **The golden rule: no research, no book.** Never start writing a minibook without grounded source material. If the user pushes to skip research, explain that the quality of the book depends entirely on the quality of the research feeding it.

---

## Project Structure

Every minibook follows a consistent folder layout inside the active project:

```
<project-root>/
  research/
    Minibook/
      <book-slug>/
        manuscript.md          # The finished prose (source of truth)
        outline.md             # Chapter outline (approved before writing)
        images/
          cover.png            # Cover / hero image
          ch1.png              # One image per chapter
          ch2.png
          ...
        sources/               # Research inputs (briefings, PDFs, notes)
          briefing-1.md
          briefing-2.md
          ...
```

**Rules:**
- `<book-slug>` is lowercase, hyphenated (e.g., `the-ai-shift`, `quantum-careers`)
- The `manuscript.md` is the single source of truth for all prose
- Images are always named `cover.png`, `ch1.png`, `ch2.png`, etc.
- Source materials go in `sources/` for traceability
- The agent creates this structure automatically when starting a new minibook

---

## Workflow 1: Write

Takes grounded research and produces a structured minibook manuscript.

### Step 1 - Gather Sources

Collect all research materials into `sources/`:
- NotebookLM briefing reports (download via `mcp_notebooklm_download_artifact`)
- PDFs, articles, notes, or any other reference material
- The agent should summarize the source inventory before proceeding

### Step 2 - Create Outline

Before writing any prose, produce `outline.md` with:
- **Title, subtitle, and tagline** (one line each)
- **Chapter list** with:
  - Chapter number and title
  - 2-3 sentence summary of what the chapter covers
  - Key data points or quotes to include
  - The core metaphor or framing device
- **Target audience** statement
- **Estimated length** (word count)

> [!IMPORTANT]
> **Stop and get user approval on the outline before writing.** Never proceed to prose without explicit approval.

### Step 3 - Write the Manuscript

Produce `manuscript.md` following these structural rules:

**Document structure:**
```
# [Title]

### [Subtitle]

*[Tagline]*

---

## Prelude: [Hook Title]

[Hook paragraphs - the most compelling entry point]

---

## Chapter 1: [Title]

[Body prose]

---

## Chapter 2: [Title]
...

---

## Conclusion: [Title]

[Closing prose]

---

*[Source attribution paragraph]*
```

**Writing principles:**
- **Plain language.** No jargon unless immediately explained. Write as if the reader is smart but unfamiliar with the field
- **Second-person address.** "You" not "one" or "the reader"
- **Data-backed claims.** Every significant claim gets a blockquote citation:
  ```
  > **[Key statistic or finding in bold.]**
  > *Source: [Organization], "[Report Title]," [Year].*
  ```
- **Personal commentary.** Clearly marked with first-person ("I believe", "from my experience"). Adds authenticity but never replaces evidence
- **Chapter anatomy:** Hook paragraph > Data callout (blockquote) > Analysis > Practical implications > Transition to next chapter
- **Tables** for comparative data (job growth projections, framework comparisons)
- **No em dashes.** Use commas, semicolons, or restructure the sentence
- **Consistent voice.** Direct, conversational, occasionally urgent. Never academic

**Quality gates:**
- Every chapter must have at least one data-backed blockquote citation
- No unsourced statistics
- Transitions between chapters must be explicit ("And that brings us to...")
- The prelude must hook within the first two sentences
- The conclusion must include actionable next steps

### Step 4 - User Review

Present the manuscript for review. Expect iterative edits. The user may:
- Rewrite passages in their own voice
- Add personal commentary
- Adjust data framing
- Change chapter ordering

After edits, `manuscript.md` remains the source of truth.

---

## Workflow 2: Illustrate

Generates a cohesive set of chapter images using the `generate_image` tool.

### Step 1 - Define Visual Style

Before generating any images, agree on the visual direction with the user:

- **Style reference** (e.g., "neon waves on dark backgrounds", "watercolor illustrations", "minimalist flat icons")
- **Color palette** (tie to the book's theme)
- **Consistency markers** (recurring visual elements across all images)

> [!TIP]
> The "AI Shift" used: neon gradient waves, dark clean backgrounds, colorful conceptual icons. This works well for technology-themed books. Adjust per topic.

### Step 2 - Generate Images

Create N+1 images (cover + one per chapter):

| Image | Naming | Prompt Strategy |
|---|---|---|
| Cover | `cover.png` | Captures the book's overarching theme/metaphor |
| Chapter 1 | `ch1.png` | References the chapter's core metaphor (e.g., electricity grid for infrastructure) |
| Chapter 2 | `ch2.png` | References the chapter's core concept (e.g., elite club for "5% Club") |
| ... | `chN.png` | Each image ties to its chapter's central idea |

**Rules:**
- Generate all images in a single batch for visual consistency
- Save to `research/Minibook/<book-slug>/images/`
- Each prompt should reference the agreed style markers
- Ask user to review the full set before proceeding to publish

### Step 3 - User Review

Show all generated images. The user may request regeneration of specific chapters. Iterate until approved.

---

## Workflow 3: Publish to Notion

Takes the finished manuscript + images and creates a formatted Notion page.

### Prerequisites

- Notion MCP server must be connected and authenticated
- A target workspace or parent page must be identified

### Image Placement Rules

These rules ensure readable, visually balanced layout (learned from "The AI Shift" scroll book):

1. **Title > Subtitle > Tagline > Prelude text first.** The hook paragraphs appear before any image. Pull readers in with words before visuals
2. **Cover image after the prelude hook.** Place `cover.png` after the first 2-3 prelude paragraphs, before the rest of the prelude content
3. **Chapter images after the chapter heading.** Place `chN.png` immediately after the `## Chapter N: Title` heading, before the first body paragraph
4. **Never two images back-to-back.** There must be at least one paragraph of text between any two images
5. **Data callouts are text-only zones.** No images within 2 blocks of a blockquote citation
6. **Tables stand alone.** No image directly above or below a table

### Notion Block Mapping

Map Markdown elements to Notion blocks:

| Markdown | Notion Block |
|---|---|
| `# Title` | Page title |
| `### Subtitle` | Heading 3 |
| `*Tagline*` | Italic paragraph |
| `---` | Divider |
| `## Chapter N: Title` | Heading 2 |
| `> **Bold text**` | Callout block (or quote block) |
| `> *Source:...*` | Quote block (italic) |
| Body paragraphs | Paragraph blocks |
| Tables | Table blocks |
| Images | Image blocks (uploaded) |

### Publishing Steps

1. **Create the Notion page** under the target parent page using Notion MCP
2. **Add the title** as the page title
3. **Walk through the manuscript** section by section:
   - Convert each Markdown element to the appropriate Notion block
   - Insert images at the placement points defined above
   - Preserve heading hierarchy
4. **Add source attribution** at the bottom as a toggleable section

> [!IMPORTANT]
> **Notion MCP limitations:** If the Notion MCP server does not support image uploads directly, save images to a public URL (e.g., R2 bucket) first, then embed via URL. Inform the user if this fallback is needed.

---

## Agent Rules

### When to suggest this extension
- User has completed research and mentions wanting to "write it up" or "make a book/report/guide"
- User has a collection of briefings or reports and wants to synthesize them
- User asks about creating long-form content from research

### Core behaviors
- **Never write prose without an approved outline.** The outline is the contract
- **Ground all claims in sources.** Flag any assertion that lacks a citation
- **Maintain consistent voice.** If the user edits passages, match their tone in subsequent writing
- **Ask before generating images.** Confirm style direction before spending generation tokens
- **Respect the image placement rules.** Never deviate from the layout principles in Workflow 3
- **Create the folder structure first.** Before any writing begins, set up the project directories
- **One source of truth.** `manuscript.md` is always the canonical version. If edits happen elsewhere (Notion, a web component), sync back to `manuscript.md`

### Quality checklist (run before publishing)
- [ ] Every chapter has at least one cited data point
- [ ] No orphaned images (every image is placed in the manuscript)
- [ ] Folder structure matches the convention
- [ ] Outline was approved before writing began
- [ ] User reviewed the complete manuscript
- [ ] User approved the image set
- [ ] Source attribution is present at the end
