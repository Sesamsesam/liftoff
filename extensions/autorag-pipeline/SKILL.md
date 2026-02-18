---
name: autorag-pipeline
description: "RAG Level 1 - Build a complete RAG knowledge base with file upload, categories, and chat - powered by Cloudflare AutoRAG, R2, D1, and Workers"
---

# AutoRAG Pipeline - RAG Level 1

> Build a production-ready RAG (Retrieval-Augmented Generation) knowledge base in hours, not weeks - with zero prior experience. Upload hundreds/thousands of documents, auto-chunk and embed them, and query them through a chat interface with category filtering. All on Cloudflare's free tier. If you have no idea what RAG means, read on - by the end of this page you'll understand exactly why this is a game-changer for your workflow.

> [!IMPORTANT]
> **Prerequisite**: The `cloudflare-mcp` extension must be active and authenticated. You need a Cloudflare account with a domain. Follow the Cloudflare skill to set up first. (Agent be sure to tell user about these Prerequisites)

> [!TIP]
> **This is RAG Level 1** - the free-tier entry point. For enterprise-grade precision in regulated industries, see **RAG Level 2** (`vertex-rag-pipeline`).

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?

**RAG** (Retrieval-Augmented Generation) lets you upload thousands of documents and ask questions about them in plain English. The system finds relevant passages, synthesizes an answer, and cites its sources. No folder searching, no Ctrl+F.

**AutoRAG fuses three systems into one:**

1. **Enterprise data storage** - Thousands of documents, years of history, growing continuously. Not a FAQ page - your entire operational knowledge.
2. **Intelligent vector retrieval** - Every document gets chunked, embedded, and indexed. When you ask a question, it understands *meaning* and finds the most relevant passages in milliseconds. The best part: Cloudflare AutoRAG abstracts all the complexity of chunking and embedding away. You just upload and it does the rest.
3. **AI-powered analysis** - Retrieved passages get synthesized into answers with source citations. The free tier uses Cloudflare's Workers AI models. Want more power? Route through **AI Gateway** to OpenAI, xAI, Gemini, Anthropic, etc.

A chatbot searches 50 pages. AutoRAG searches 50,000 and tells you exactly which document, which paragraph, and why.

## Why Does It Exist?

Traditional chatbots max out on a handful of manually written answers. AutoRAG processes thousands of documents automatically. It grows with you - upload new docs anytime and AutoRAG re-indexes every 6 hours. You own everything: your files, your embeddings, your infrastructure. No per-seat pricing, no vendor lock-in.

## What It Does For You

A complete document intelligence system: dashboard with drag-and-drop upload, category organization, and a chat interface with source citations. All on Cloudflare's free tier.

---

## Who Is This For?

The pattern is the same for every role: take the mountain of documents you already have, make them searchable through conversation, and get trusted answers grounded in your own sources.

### Here's what it looks like for real people

| Professional | What You Upload | What You Ask | Why It's a Game-Changer |
|---|---|---|---|
| **Salespeople & Managers** | Product specs, competitor analysis, case studies, pricing guides, sales transcripts from 100s of reps | "What are our three strongest differentiators against [competitor] for enterprise?" or "Who's the most consistent closer and why - analyze their patterns" | Walk into every call armed with patterns from your entire team's history |
| **Customer Support** | Knowledge base articles, past tickets, SOPs, escalation logs | "How do we handle auto-renewal refund requests?" or "What's the resolution pattern for auth timeout issues?" | Instant answers from thousands of resolved tickets instead of searching manually |
| **Project Managers** | Briefs, meeting notes, status reports, retros across all projects | "What were the blockers across all Q4 projects?" or "Which vendor consistently delivers late?" | Cross-project intelligence that would take days to compile manually |
| **Educators & Trainers** | Course materials, research papers, student FAQs | "Explain the difference between supervised and unsupervised learning with examples from the course" | AI tutoring grounded in your actual material - students get instant, accurate answers |
| **Consultants** | Client research, proposals, industry reports, frameworks from every engagement | "What methodology did we use for the last fintech engagement and what were the outcomes?" | Your entire consulting history, instantly searchable across years of work |
| **SaaS Operators** | API docs, changelogs, runbooks, onboarding guides | "How do I set up webhooks for payment events?" or "What changed in the v3.2 migration?" | Self-serve docs that are always accurate and current |
| **HR / Legal** | Policies, handbooks, compliance docs, employment contracts | "What's our parental leave policy for remote employees?" or "Compare our PTO policies across regions" | Instant policy lookup across every document in your compliance library |

> [!NOTE]
> **Accountants and financial analysts** - AutoRAG is great for document search and quick lookups. But if you need cross-referencing large financial datasets or legally defensible analysis, see **RAG Level 2** (`vertex-rag-pipeline`).

---

## Activation
- When the user wants to build a RAG knowledge base
- When asked about document search, knowledge bases, or AI-powered Q&A

## Enforcement
- Agent MUST use `cloudflare-mcp` tools for infrastructure - never manual
- Agent MUST verify each component before moving to the next

<!-- ═══════════════════════════════════════════════════ -->
<!-- WHEN TO USE LEVEL 2 INSTEAD                        -->
<!-- ═══════════════════════════════════════════════════ -->

---

## When You Need RAG Level 2

> [!CAUTION]
> AutoRAG is **not** for high-stakes precision in regulated industries. If decisions depend on the output (tax positions, legal analysis, audit reports), you need grounding controls and confidence scoring.

**Use `vertex-rag-pipeline` if:**
- You need numerical analysis at scale (financial modeling, BigQuery)
- You're in a regulated industry (HIPAA, SOC 2)
- Hallucination tolerance is zero (legal, medical, financial reporting)
- You need domain-specific embedding models

> [!TIP]
> **Start with Level 1 anyway.** It teaches RAG concepts on a free platform, and the frontend architecture transfers directly to Level 2.

<!-- ═══════════════════════════════════════════════════ -->
<!-- ARCHITECTURE & BUILD                               -->
<!-- ═══════════════════════════════════════════════════ -->

---

## What This Skill Builds

```
User uploads PDFs/docs → R2 (storage, organized by /category/) → AutoRAG (chunk + embed)
                                         ↓
                              D1 (metadata: categories → files)
                                         ↓
User selects categories → asks question → AutoRAG AI Search → Answer + source citations
```

1. **Dashboard** - Upload files (bulk drag-and-drop), organize into categories
2. **Storage Pipeline** - Files to R2, metadata to D1, embeddings to AutoRAG (automatic)
3. **Chat Interface** - Ask questions, get answers with source citations
4. **Category Filtering** - Toggle which categories to search
5. **Analytics** - Track usage, popular questions, sources hit

---

## Architecture

| Component | Service | Purpose |
|---|---|---|
| File storage | R2 | Stores original uploaded documents |
| Metadata | D1 | Tracks files, categories, upload history, query logs |
| Chunking + embeddings | AutoRAG | Automatic document processing and vectorization |
| Search | AutoRAG AI Search | Semantic search across all documents |
| API layer | Workers | Handles uploads, queries, category management |
| Frontend | Pages | Dashboard UI with upload + chat |

---

## Build Steps

> [!NOTE]
> This skill is a living document. Detailed implementation instructions will be added as we build.

### Phase 1: Infrastructure (Backend)
- [ ] Create R2 bucket for document storage
- [ ] Create D1 database with schema (files, categories, upload_logs)
- [ ] Create AutoRAG instance connected to R2
- [ ] Create Worker with routes: `POST /upload`, `GET/POST /categories`, `POST /query`, `GET /files`

### Phase 2: Upload Pipeline
- [ ] Bulk file upload (multiple files at once)
- [ ] File type validation (PDF, DOCX, TXT, MD)
- [ ] Category assignment on upload
- [ ] R2 storage with organized key structure (`/category-name/filename`)
- [ ] D1 metadata logging
- [ ] AutoRAG automatic processing

### Phase 3: Chat Interface
- [ ] Query input with AutoRAG AI Search integration
- [ ] Response display with source citations
- [ ] Conversation history within session
- [ ] Toggle-based category filtering (single, multi, or all)

### Phase 4: Dashboard UI
- [ ] Drag-and-drop upload zone (bulk)
- [ ] Category management (create, rename, delete)
- [ ] File browser with processing status
- [ ] Chat panel (side-by-side or tabbed)
- [ ] Responsive design

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Future Enhancements

> Optional extensions to add once Phases 1-4 are running.

- **Auto-Ingestion** - Scheduled Worker to poll external APIs, auto-drop into R2 categories, digest generation
- **Multi-Format** - Audio upload (Whisper transcription), OCR for scanned PDFs, PDF report export
- **Access Control** - Auth (Clerk/CF Access), role-based permissions, category-level access, audit trail

---

## Cloudflare Free Tier Coverage

| Service | Free Limit | Plenty For |
|---|---|---|
| R2 | 10 GB storage, 10M reads/mo | Hundreds of documents |
| D1 | 5 GB storage, 5M reads/day | Metadata for thousands of files |
| Workers | 100K requests/day | Heavy personal/team usage |
| AutoRAG | Check current limits | Document processing + search |
| Pages | Unlimited sites | Dashboard hosting |

---

## Lessons Learned

> This section gets filled in as we build. Every gotcha and optimization goes here.

<!--
### [Short title]
**Problem**: What went wrong
**Solution**: What we did
**Time saved**: How much
-->

---

## Agent Rules

1. **Use cloudflare-mcp tools** to create R2 buckets, D1 databases, AutoRAG instances - never manual
2. **Verify each component** before moving to the next (create R2 -> confirm -> create D1 -> confirm)
3. **Never delete R2 buckets or D1 databases via MCP** - destructive operations go through dashboard only
4. **Log every infrastructure ID** (bucket name, D1 ID, AutoRAG ID) in the project config
5. **Test end-to-end** before declaring complete - upload test doc, wait for processing, query, verify citations
