---
name: autorag-pipeline
description: "RAG Level 1 - Build a complete RAG knowledge base with file upload, categories, and chat - powered by Cloudflare AutoRAG, R2, D1, and Workers"
---

# AutoRAG Pipeline - RAG Level 1

> Build a production-ready RAG (Retrieval-Augmented Generation) knowledge base in hours, not weeks - with zero prior experience. Upload hundreds of documents, auto-chunk and embed them, and query them through a chat interface with category filtering. All on Cloudflare's free tier. If you have no idea what RAG means, read on - by the end of this page you'll understand exactly why this is a game-changer for your workflow.

> [!IMPORTANT]
> **Prerequisite**: The `cloudflare-mcp` extension must be active and authenticated before using this skill and all its necessities like having a Cloudflare account and a domain on Cloudflare. If you don't have one, I suggest you get one. It's free and easy to set up. Follow the instructions in the Cloudflare skill when you have read and understood and are ready to build.

> [!TIP]
> **This is RAG Level 1** - the accessible, powerful, free-tier entry point. Perfect for consultants, sales teams, support teams, educators, and any professional who works with documents. Buildable in two weeks, powerful enough to charge real money for. If you need enterprise-grade precision for regulated industries (auditing, financial analysis, legal due diligence), see **RAG Level 2** (`vertex-rag-pipeline`) which uses Google Vertex AI + Cloud Run + BigQuery.

---

## Why AutoRAG Is Incredible

You don't need to be technical to understand what this does. You need to be someone who works with information - and that's everyone.

**RAG** (Retrieval-Augmented Generation) means: upload your documents, and then ask questions about them in plain English. The system finds the relevant parts, reads them, and gives you an accurate answer with citations. No searching through folders. No Ctrl+F. No "I know I read this somewhere."

### How is this different from a chatbot with a knowledge base?

It's not even the same category. Traditional chatbots require *you* to write the answers - you're manually crafting FAQ responses and decision trees. Even the ones with AI knowledge-bases or an active AI brain can only hold a handful of documents and a tiny context window. They max out fast.

AutoRAG is fundamentally different and is for those who want to do things at a much larger and deeper scale. For example:
You upload a thousand documents, hundreds of hours of call transcripts, years of reports - and the AI reads all of it. It doesn't just store your data, it *learns your business*. Every document you add makes it smarter about exactly your work, your clients, your patterns. It's not a chatbot with a bigger memory. It's an intelligence layer on top of everything your organization has ever produced and continues to produce.

Here's what that looks like for real people:

**Salespeople and Managers** - Upload your product specs, competitor analysis, case studies, pricing guides, sales stats and all your sales transcripts from 100s of reps from the entire year. Before a call, ask: "What are our three strongest differentiators against [competitor] for enterprise clients?" or "Who's the most consistent closer for SaaS deals and why - give me an analysis of their patterns." Walk in armed.

**Customer Support Manager** - Upload your entire knowledge base, past tickets, and SOPs. Your team asks the chat: "How do we handle a refund request for a subscription that was auto-renewed?" Instant, consistent answers - no more training bottlenecks.

**Project Manager** - Upload project briefs, meeting notes, stakeholder requirements, and status reports across all your projects. Ask: "What were the blockers mentioned in last month's reports for Project Alpha?" or "What's the analysis from all our call scripts that seems like the most important thing to focus on for our clients?" Get a summary in seconds instead of digging through 40 documents.

**Educator / Trainer** - Upload course materials, research papers, and student FAQs. Students ask the chat: "Explain the difference between supervised and unsupervised learning with examples from the course." Instant tutoring, grounded in your actual material.

**Consultant** - Upload your client research, proposals, industry reports, and frameworks from every engagement you've ever done. Ask: "What methodology did we use for the last fintech engagement and what were the outcomes?" Your entire consulting history, instantly searchable.

**SaaS Operator** - Upload your API docs, changelogs, onboarding guides, and internal runbooks. Give your users or your team a chat interface that answers: "How do I set up webhooks for payment events?" - accurately, every time, citing your own documentation.

**HR Department** - Upload employee handbooks, company policies, benefits guides, and compliance documents. Any team member can ask: "What's our parental leave policy for remote employees in Europe?" One source of truth, always available.

**The pattern is the same**: take the mountain of documents you already have, make them searchable through conversation, and get answers you can trust because they come from your own sources.

You build this once. It runs on Cloudflare's free tier. And people skip the weeks of searching, reading, and guessing - they just ask.

**AutoRAG is three systems fused into one:**

1. **Enterprise data storage** - Thousands of documents, years of history, growing continuously. Not a FAQ page. Your entire operational knowledge.

2. **Intelligent vector retrieval** - Every document gets chunked, embedded, and indexed into a vector database. When you ask a question, it doesn't keyword-search - it *understands meaning* and finds the most semantically relevant passages across your entire library in milliseconds. The cool thing about AutoRAG is that chunking and embedding used to require serious programming expertise - it's the process of preparing how your content gets sliced up into numerical values and retrieved intelligently. High-level stuff. With Cloudflare's AutoRAG, all of that is entirely abstracted away for you. What used to be very complicated is now simple: you just upload the documents and it does the rest.

3. **AI-powered analysis** - The retrieved passages get fed to an AI model that synthesizes an answer, cites its sources, and can reason across multiple documents at once. The free tier uses Cloudflare's built-in Workers AI models (with monthly usage limits). If you want more power, you can route through **AI Gateway** to any external provider - OpenAI, xAI, Gemini, Anthropic, and more - at their standard API rates. Same system, bigger brain.

A chatbot searches 50 pages. AutoRAG searches 50,000 and tells you exactly which document, which paragraph, and why.

Here's what makes it even more powerful:

- **It grows with you.** Upload new documents anytime - AutoRAG detects changes in your storage every 6 hours and automatically re-indexes. You can also trigger an instant sync. Your knowledge base is a living system, not a static dump.

- **Documents update in place.** Replace a file with a new version, and the next sync re-processes it. Delete a file, and its chunks get removed from the index. No manual cleanup.

- **You own everything.** Your files, your embeddings, your infrastructure. No vendor holds your data hostage if you cancel a subscription.

- **No per-seat pricing.** Chatbot platforms charge per agent, per conversation, or per resolution. This runs on Cloudflare's free tier - your costs stay near zero regardless of how many people use it.

- **Fully customizable.** You control the UI, the categories, the file types, the search behavior. It's your application, not someone else's widget on your site and so it's flexible and can be tailored to your specific needs.

- **Extensible.** Once your base system is running, you can layer on auto-ingestion from external APIs, audio transcription via Whisper, PDF report generation, or even connect to BigQuery for numerical analysis. These are optional extensions you add when you're ready (see [Future Enhancements](#future-enhancements)).

---

## Who This Is Perfect For

AutoRAG Level 1 delivers with high accuracy for professionals who work with documents. Here are the industries and roles where it absolutely shines:

| Professional | What You Upload | What You Ask | Why Level 1 Is Enough |
|---|---|---|---|
| **Sales Teams** | Product specs, competitor analysis, case studies, pricing, call transcripts | "What closing strategies work best for enterprise clients?" | Pattern mining from hundreds of real conversations |
| **Customer Support** | Knowledge base, past tickets, SOPs, product docs | "How do we handle auto-renewal refund requests?" | Instant, consistent answers - zero training bottleneck |
| **Project Managers** | Briefs, meeting notes, requirements, status reports | "What were the blockers across all Q4 projects?" | Cross-project search in seconds, not hours |
| **Educators & Trainers** | Course materials, research papers, student FAQs | "Explain supervised vs unsupervised learning from the course" | AI tutoring grounded in your actual material |
| **SaaS Operators** | API docs, changelogs, runbooks, onboarding guides | "How do I set up webhooks for payment events?" | Self-serve docs that are always accurate and current |
| **Consultants** | Client research, proposals, industry reports, frameworks | "What methodology did we use for the last fintech engagement?" | Your entire consulting history, instantly searchable |
| **HR Teams** | Policies, handbooks, compliance docs, benefits guides | "What's our parental leave policy for remote employees?" | One source of truth for every employee question |
| **Marketing Teams** | Brand guidelines, campaign briefs, content libraries, analytics reports | "What messaging performed best in Q3 campaigns?" | Pattern recognition across all your content |
| **Legal Teams** | Contract templates, case files, compliance docs, regulations | "What indemnification clause do we use for SaaS clients?" | Fast document search and organization |
| **Accountants & Tax Advisors** | Tax rulings, client correspondence, regulatory updates | "What changed in the 2026 VAT rules for digital services?" | Quick document lookup and regulatory tracking |

> [!NOTE]
> **Accountants, auditors, and financial analysts** - AutoRAG Level 1 is great for document search and quick lookups. But if you need to cross-reference massive financial datasets, produce legally defensible analysis, or do BigQuery-level numerical precision work, see the next section.

---

## When You Need RAG Level 2

AutoRAG Level 1 is powerful, but it has boundaries. Some work demands enterprise-grade precision.

> [!CAUTION]
> **AutoRAG is not for high-stakes precision work in regulated industries.** If an auditor, financial analyst, or legal professional is making decisions based on the output - tax positions, merger risk analysis, contract conflicts - you need grounding controls and confidence scoring that Cloudflare AutoRAG does not offer. An accountant cannot afford a hallucinated tax code.

**You need RAG Level 2 (`vertex-rag-pipeline`) if:**

- **You're an auditor** dealing with 50,000+ employee records across multiple corporations, cross-referencing tax codes across jurisdictions, and producing legally defensible analysis. Example: "Analyze Corporation A's tax situation with their new merger, weigh it against 2026 Hong Kong corporation tax codes for commodities traders with Singapore subsidiaries, flag any compliance gaps, and identify tax benefits to capture." This requires BigQuery-level numerical precision, grounding controls, and domain-specific embedding models.

- **You need numerical analysis at scale** - financial modeling, revenue forecasting, payroll calculations across massive datasets. AutoRAG is a text retrieval system. BigQuery handles structured data natively and precisely.

- **You're in a regulated industry** - healthcare (HIPAA), defense, financial services (SOC 2). You need enterprise compliance certifications that Cloudflare's free tier doesn't provide.

- **Hallucination tolerance is zero** - legal opinions, medical guidance, financial reporting where every number must be verifiable. You need configurable grounding controls, confidence thresholds, and the ability to tune embedding models for domain-specific accuracy.

**RAG Level 2** uses Google Vertex AI + Cloud Run + BigQuery and gives you fine-grained hallucination controls, native BigQuery integration for numerical datasets, domain-specific embedding models, and enterprise compliance (SOC 2, HIPAA, audit logs).

> [!TIP]
> **Start with Level 1 anyway.** Even if you know you'll eventually need Level 2, Level 1 teaches you RAG concepts on a free, forgiving platform. The frontend architecture (dashboard, chat, categories) transfers directly to Level 2. You're just swapping the backend brain.

---

## What This Skill Builds

A complete document intelligence system. This skill will enable you to do something that otherwise would require a high level of expertise, knowledge, and implementation - and at the very least cut the difficulty of getting to an MVP by 90% (for real).

What you'll get is a fully functional, production-ready system that you can use immediately. It's not a demo, it's not a prototype, it's a real application that you can use to solve real problems. And this is what I have prepared for your Agent to help you with:

1. **Dashboard** - Upload files (bulk drag-and-drop), organize into categories
2. **Storage Pipeline** - Files go to R2, metadata to D1, embeddings to AutoRAG (automatic chunking + vectorization)
3. **Chat Interface** - Ask questions against your knowledge base, get answers with source citations
4. **Document Categorization** - Organize by company, topic, department, or any structure that fits your workflow. Toggle which categories to search - one, several, or all at once
5. **Analytics** - Track usage, popular questions, unanswered questions, and sources hit

```
User uploads PDFs/docs → R2 (storage, organized by /category/) → AutoRAG (chunk + embed)
                                         ↓
                              D1 (metadata: categories → files)
                                         ↓
User selects categories → asks question → AutoRAG AI Search → filtered results → Answer + source citations
```

---

## Architecture

| Component | Cloudflare Service | Purpose |
|---|---|---|
| File storage | R2 | Stores original uploaded documents |
| Metadata & categories | D1 | Tracks files, categories, upload history, query logs |
| Chunking + embeddings | AutoRAG | Automatic document processing and vectorization |
| Search & retrieval | AutoRAG AI Search | Semantic search across all documents |
| API layer | Workers | Handles uploads, queries, category management |
| Frontend | Pages | Dashboard UI with upload + chat |

---

## Build Steps

> [!NOTE]
> **This skill is a living document.** The steps below are the architectural blueprint. Detailed implementation instructions, gotchas, and optimizations will be added as we build and validate the pipeline hands-on.

### Phase 1: Infrastructure (Backend)

- [ ] Create R2 bucket for document storage
- [ ] Create D1 database with schema (files, categories, upload_logs)
- [ ] Create AutoRAG instance connected to R2
- [ ] Create Worker with routes for:
  - `POST /upload` - accept files, store to R2, trigger AutoRAG indexing
  - `GET /categories` - list categories
  - `POST /categories` - create category
  - `POST /query` - send question to AutoRAG AI Search, return answer + sources
  - `GET /files` - list uploaded files with metadata

### Phase 2: Upload Pipeline

- [ ] Bulk file upload (multiple files at once)
- [ ] File type validation (PDF, DOCX, TXT, MD at minimum)
- [ ] Category assignment on upload (select or create a category)
- [ ] R2 storage with organized key structure (`/category-name/filename`)
- [ ] D1 metadata logging (filename, size, category, upload timestamp)
- [ ] AutoRAG automatic processing (chunking + embedding happens on its own)

### Phase 3: Chat Interface

- [ ] Query input with send button
- [ ] AutoRAG AI Search integration
- [ ] Response display with source citations (which document, which chunk)
- [ ] Conversation history within session
- [ ] **Toggle-based category filtering** - select which categories to query against:
  - Single category
  - Mix-and-match across categories
  - Everything (full knowledge base search)

### Phase 4: Dashboard UI

- [ ] Drag-and-drop upload zone (bulk support)
- [ ] Category management (create, rename, delete empty categories)
- [ ] File browser (list all docs, filter by category, see processing status)
- [ ] Chat panel (side-by-side or tabbed with file browser)
- [ ] Responsive design (works on mobile for querying on the go)

---

## Future Enhancements

> These are optional extensions you can add once your core system (Phases 1-4) is running flawlessly. Each one builds on the foundation.

### Auto-Ingestion & Digest System
- Scheduled Worker (cron trigger) to poll external APIs for new documents
- Configurable sources (government portals, regulatory feeds, RSS, custom API endpoints)
- Auto-drop fetched documents into correct R2 category paths
- Digest generation Worker - summarizes new/changed documents
- Email, webhook, or message delivery for daily/weekly digests (to you, your team, or your clients)

### Multi-Format Processing & Export
- Audio file upload support (MP3, WAV, M4A)
- Workers AI Whisper integration for automatic transcription
- OCR pipeline for scanned PDFs (image-to-text extraction)
- Export query results as formatted PDF briefing documents
- Customizable report templates

### Access Control & Multi-User
- User authentication (Clerk, Cloudflare Access, or custom)
- Role definitions in D1 (admin, analyst, viewer)
- Category-level permissions (who can see what)
- Admin panel for managing users and assigning access
- Audit trail (who queried what, when)

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

> This section gets filled in as we build. Every gotcha, workaround, and optimization goes here so the next person doesn't hit the same walls.

<!--
Template for lessons:
### [Short title]
**Problem**: What went wrong or was unclear
**Solution**: What we did to fix it
**Time saved**: How much time this saves the next person
-->

---

## Agent Rules

When building an AutoRAG pipeline, the agent MUST:

1. **Use the cloudflare-mcp tools** to create R2 buckets, D1 databases, and check AutoRAG instances - never instruct the user to do it manually
2. **Verify each infrastructure component** before moving to the next (create R2 → confirm → create D1 → confirm → etc.)
3. **Never delete R2 buckets or D1 databases via MCP** - destructive operations go through the dashboard only
4. **Log every infrastructure ID** (R2 bucket name, D1 database ID, AutoRAG ID) in the project's config file
5. **Test the query pipeline end-to-end** before declaring the build complete - upload a test doc, wait for processing, query it, verify the answer cites the source
