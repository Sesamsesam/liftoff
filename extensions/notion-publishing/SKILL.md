---
name: notion-publishing
description: "Publish manuscripts, reports, or any structured content to Notion with proper formatting, image placement, and block mapping."
---

# Notion Publishing

> **Any manuscript or report to a formatted Notion page.** The agent handles block mapping, image placement, and publishing. You pick the target workspace.

This extension takes any structured markdown content (minibooks, research reports, briefings) and publishes it as a beautifully formatted Notion page with images, headings, callouts, and proper layout.

---

## Activation

- When a user finishes writing content and asks to "put it on Notion" or "publish to Notion"
- When the minibook-pipeline or other content workflows offer Notion as a publishing option
- When a user wants to move any markdown document to their Notion workspace

## Prerequisites

- Notion MCP server must be connected and authenticated
- A target workspace or parent page must be identified

---

## Image Placement Rules

These rules ensure readable, visually balanced layout (learned from "The AI Shift" scroll book):

1. **Title > Subtitle > Tagline > Prelude text first.** The hook paragraphs appear before any image. Pull readers in with words before visuals
2. **Cover image after the prelude hook.** Place `cover.png` after the first 2-3 prelude paragraphs, before the rest of the prelude content
3. **Chapter images after the chapter heading.** Place `chN.png` immediately after the `## Chapter N: Title` heading, before the first body paragraph
4. **Never two images back-to-back.** There must be at least one paragraph of text between any two images
5. **Data callouts are text-only zones.** No images within 2 blocks of a blockquote citation
6. **Tables stand alone.** No image directly above or below a table

## Notion Block Mapping

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

## Publishing Steps

1. **Identify source material** - Ask the user which manuscript or report to publish. Look for the source file (e.g., `manuscript.md`, a research report, or any structured markdown)
2. **Identify target** - Ask the user where to publish in Notion (which workspace, which parent page)
3. **Create the Notion page** under the target parent page using Notion MCP
4. **Add the title** as the page title
5. **Walk through the content** section by section:
   - Convert each Markdown element to the appropriate Notion block
   - Insert images at the placement points defined above
   - Preserve heading hierarchy
6. **Add source attribution** at the bottom as a toggleable section
7. **Share the link** - Provide the user with the Notion page URL

> [!IMPORTANT]
> **Notion MCP limitations:** If the Notion MCP server does not support image uploads directly, save images to a public URL (e.g., R2 bucket) first, then embed via URL. Inform the user if this fallback is needed.

---

## Agent Rules

### Core behaviors
- **Never publish without user approval.** Always confirm the target page and content before creating
- **Preserve structure.** The Notion page should mirror the manuscript's heading hierarchy exactly
- **Handle images gracefully.** If an image fails to upload, note it and continue with the rest - don't abort the entire publish
- **One source of truth.** The original markdown file remains the canonical version. The Notion page is a published copy
- **Idempotent publishing.** If the user asks to re-publish, update the existing page rather than creating a duplicate

### When content has no images
- Skip all image placement rules
- Still apply the block mapping for text, headings, callouts, and tables
- The flow works the same - just without the image insertion steps
