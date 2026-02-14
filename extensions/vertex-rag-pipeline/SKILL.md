---
name: vertex-rag-pipeline
description: "RAG Level 2 - Enterprise-grade RAG with Google Vertex AI, Cloud Run, and BigQuery for regulated industries requiring precision, grounding controls, and numerical analysis"
---

# Vertex RAG Pipeline - RAG Level 2

> This will literally allow you to build something that someone in your industry would pay a million dollars for, seriously. This is the enterprise-grade RAG system - Google Vertex AI + Cloud Run + BigQuery - for industries where precision isn't a nice-to-have, it's a legal and hyper professional requirement. Auditing, financial analysis, legal due diligence, healthcare compliance, business analysis and consulting. Upload 50,000+ documents, connect massive numerical datasets via BigQuery, and get answers with grounding controls and confidence scoring. If your business can't afford any hallucinations or your domain does not have room for creativity buffers but adheres to strict rules, maybe you work in government or with big international business, this is the system you want and need. Get ready to get your mind blown.

> [!IMPORTANT]
> **Start with RAG Level 1 first.** If you haven't built `autorag-pipeline` (Level 1), do that first. It teaches you RAG concepts on a free, forgiving platform, and the frontend architecture (dashboard, chat, categories) transfers directly to Level 2. You're just swapping the backend brain.

> [!NOTE]
> **This skill is currently an outline.** The architectural blueprint and build phases are documented below. Detailed implementation instructions will be added when we build this system (estimated: one month after Level 1 is complete).

---

## Why Level 2 Exists

RAG Level 1 (Cloudflare AutoRAG) is incredible for document search, knowledge bases, and general Q&A and it's great for businesses and use cases where there's room for either creativity or broad knowledge and assumptions where numbers, and very strict rules are not a requirement - rules and parameters where if you get it wrong there's not major professional consequences. That's not to say that Level 1 is not a serious tool for serious businesses, it's just that Level 2 is for businesses that need to be absolutely sure about their numbers and rules and typically businesses who work in regulated industries:

### Level 1 - Cloudflare AutoRAG

> Great for document search, Q&A, knowledge bases, and consulting tools. Free tier.

| Capability | What You Get |
|---|---|
| Chunking strategy | Fully abstracted - zero configuration needed |
| Embedding models | Cloudflare Workers AI models included free (with monthly limits). Bring your own via AI Gateway - OpenAI, xAI, Anthropic, Gemini, etc. (pay per use) |
| Grounding controls | None - you trust the pipeline |
| Hallucination mitigation | Basic RAG retrieval |
| Numerical analysis | Text retrieval only |
| Compliance | Basic (Cloudflare free tier) |
| Scale | Excellent for documents |
| Cost | Free tier with built-in models. External providers via AI Gateway at their standard API rates |

---

### ↓ Level Up ↓

---

### Level 2 - Google Vertex AI + Cloud Run + BigQuery

> For regulated industries, numerical precision, and zero-tolerance hallucination. Enterprise-grade.

| Capability | What You Get |
|---|---|
| Chunking strategy | Configurable - size, overlap, boundaries, semantic splitting |
| Embedding models | Choose from dozens, including domain-specific (legal, medical, financial) |
| Grounding controls | Confidence scores, grounding thresholds, source attribution scoring |
| Hallucination mitigation | Configurable safety thresholds, answer rejection when confidence is low |
| Numerical analysis | Native BigQuery - SQL over millions of rows of structured data |
| Compliance | SOC 2, HIPAA, ISO 27001, audit logging, data residency controls |
| Scale | Documents AND massive structured datasets |
| Cost | Pay-as-you-go (predictable and optimizable) |

---

**Summary:** 
Level 1 is a text retrieval system that's easy to deploy, very fast to build and incredibly useful for many use cases. 

Level 2 is a precision analysis platform that can handle both unstructured documents AND structured numerical data with enterprise compliance.

---

## Who This Is For

Level 2 is built for professionals where accuracy has legal, financial, or safety consequences:

### Auditing Firms

The hero use case. An auditing firm managing multiple corporate accounts with deep, cross-referential analysis needs:

**What you upload:**
- 50,000+ employee payroll records across multiple corporations
- Tax filings, regulatory submissions, board minutes
- Legal contracts, vendor agreements, merger documents
- Financial statements spanning years
- Compliance documentation across multiple jurisdictions

**What you ask:**
- "Analyze Corporation A's tax situation with their new merger and acquisition. Weigh it against the 2026 Hong Kong corporation tax codes for commodities traders with subsidiaries in Singapore. Flag any compliance gaps and identify tax benefits to capture."
- "Cross-reference all vendor agreements for Company B against their expenditure reports. Are there any contracts where we're paying above the agreed rates?"
- "Give me a variance analysis of Company C's payroll across Q2-Q4. Flag any anomalies above 2 standard deviations with the specific employee records."

**Why Level 2:** These queries mix document retrieval (contracts, filings) with numerical analysis (payroll data, variance calculations). BigQuery handles the numbers. Vertex AI handles the text. Grounding controls ensure the AI doesn't hallucinate a tax code that could cost your client millions and every retrieval has exact citations.

### Financial Analysis

- Investment research across thousands of SEC filings, earnings calls, and market reports
- Revenue forecasting combining unstructured analyst notes with structured financial data
- Risk assessment requiring confidence scores and source attribution

### Legal Due Diligence

- M&A document review across tens of thousands of contracts
- Cross-jurisdictional regulatory compliance checking
- Contract conflict detection requiring high precision recall

### Healthcare & Pharmaceutical

- Clinical trial documentation with HIPAA compliance requirements
- Drug interaction databases requiring zero-tolerance hallucination
- Regulatory submission preparation (FDA, EMA) demanding audit trails

### Government & Defense

- Classified document management with strict access controls
- Policy analysis across massive regulatory corpora
- Inter-agency document cross-referencing

---

## Architecture Overview

```
All uploads → Cloud Run API (orchestrator)
                    ↓                          ↓
         Cloud Storage (documents)    BigQuery (structured data)
                    ↓                          ↓
         Vertex AI Embeddings          Available for analysis
                    ↓                          ↓
         Vector Search Index         ←→ Cloud Run API ←→ Vertex AI (grounding + generation)
                                           ↓
                                   Frontend (same as Level 1)
                                           ↓
                            Answer + confidence score + source citations
```

| Component | Google Cloud Service | Purpose |
|---|---|---|
| Document storage | Cloud Storage | Stores original uploaded documents |
| Structured data | BigQuery | Numerical analysis engine - Cloud Run sends data here for calculations, retrieves results, and feeds them back to Vertex AI for contextualized answers |
| Embeddings | Vertex AI Embeddings API | Configurable embedding models (including domain-specific) |
| Vector database | Vertex AI Vector Search | High-performance similarity search with filtering |
| Generation | Vertex AI (Gemini) | Answer generation with grounding controls and confidence scoring |
| API layer | Cloud Run | **The orchestrator** - receives all uploads, routes documents to Cloud Storage/Vertex AI, routes structured data to BigQuery, coordinates multi-step queries across both systems |
| Metadata & taxonomy | Cloud SQL or Firestore | Tracks files, categories, permissions, audit logs |
| Frontend | Cloud Run or Cloudflare Pages | Dashboard UI (reuse Level 1 frontend architecture) |
| Authentication | Firebase Auth or Clerk | Enterprise SSO, role-based access control |
| Monitoring | Cloud Logging + Monitoring | Full audit trail, usage analytics, error tracking |

---

## Key Differentiators Over Level 1

### Grounding Controls
- Set minimum confidence thresholds - the system refuses to answer if it's not confident enough
- Source attribution scoring - every claim is linked to its source with a relevance score
- Hallucination detection - cross-reference generated answers against retrieved passages

### BigQuery Integration
- Upload all data through Cloud Run - it routes documents to Vertex AI and structured data (CSV, spreadsheets, database exports) to BigQuery automatically
- Ask questions that combine document retrieval AND numerical analysis - Cloud Run orchestrates the full flow: retrieves relevant documents from Vertex AI, sends numerical queries to BigQuery, combines the results, and returns a grounded answer
- Example: "What's the average salary variance for Company A employees in the engineering department compared to industry benchmarks?" - Cloud Run sends the salary data query to BigQuery, pulls the policy documents from Vertex AI, and Gemini synthesizes both into one answer with citations

### Domain-Specific Embedding Models
- Choose embedding models trained on legal, financial, medical, or technical corpora
- Better semantic understanding for industry jargon and specialized terminology
- Fine-tune embeddings on your own data for maximum accuracy

### Enterprise Compliance
- SOC 2 Type II, HIPAA, ISO 27001 certifications
- Data residency controls (choose which region your data lives in)
- Full audit logging - who queried what, when, what sources were used
- Data encryption at rest and in transit

---

## Build Phases (Outline)

### Phase 1: Infrastructure
- [ ] Set up Google Cloud project with billing
- [ ] Create Cloud Storage bucket for document storage
- [ ] Set up BigQuery dataset for structured data
- [ ] Configure Vertex AI API access
- [ ] Create Cloud Run service for API layer
- [ ] Set up authentication (Firebase Auth or Clerk)

### Phase 2: Document Pipeline
- [ ] Document upload to Cloud Storage with category organization
- [ ] Configurable chunking (size, overlap, semantic boundaries)
- [ ] Vertex AI embedding generation (with model selection)
- [ ] Vector Search index creation and management
- [ ] Metadata storage (Cloud SQL or Firestore)

### Phase 3: BigQuery Integration
- [ ] Cloud Run routing logic - detect whether upload is a document (→ Cloud Storage/Vertex AI) or structured data (→ BigQuery)
- [ ] Schema detection and BigQuery table creation for structured uploads
- [ ] Natural language to SQL translation via Vertex AI
- [ ] Orchestrated queries - Cloud Run coordinates Vertex AI retrieval + BigQuery analysis + Gemini synthesis in a single request

### Phase 4: Query Engine with Grounding
- [ ] Vertex AI retrieval with configurable parameters
- [ ] Grounding controls (confidence thresholds, source attribution)
- [ ] Answer generation with Gemini (grounded in retrieved content)
- [ ] Confidence scoring and answer rejection when below threshold
- [ ] Source citation with relevance scores

### Phase 5: Dashboard & Chat UI
- [ ] Reuse Level 1 frontend architecture (upload, categories, chat)
- [ ] Add confidence score display to answers
- [ ] Add BigQuery query results visualization (tables, charts)
- [ ] Add source relevance indicators
- [ ] Admin panel for model configuration and grounding thresholds

### Phase 6: Enterprise Features
- [ ] Role-based access control with granular permissions
- [ ] Full audit trail (queries, access, modifications)
- [ ] Data residency configuration
- [ ] Export and compliance reporting
- [ ] SSO integration

---

## Cost Considerations

Unlike Level 1's free tier, Level 2 has real costs. But they're optimizable:

| Service | Pricing Model | Optimization |
|---|---|---|
| Cloud Storage | Per GB stored + egress | Lifecycle policies, nearline for old docs |
| BigQuery | Per TB queried | Partitioning, clustering, caching |
| Vertex AI Embeddings | Per 1K characters | Batch processing, cache embeddings |
| Vertex AI Generation | Per 1K tokens | Prompt optimization, response caching |
| Cloud Run | Per vCPU-second | Auto-scaling, min instances = 0 |
| Vector Search | Per node-hour | Right-size index, use batch queries |

**Estimated monthly cost for a mid-size deployment:** $50-200/month depending on query volume and data size. Significantly less than any commercial RAG platform charging per-seat.

---

## Lessons Learned

> This section gets filled in as we build. Every gotcha, workaround, and optimization goes here.

---

## Agent Rules

When building a Vertex RAG pipeline, the agent MUST:

1. **Verify Google Cloud authentication** before any infrastructure operations
2. **Never store credentials in code** - use environment variables or Secret Manager
3. **Test grounding controls** with adversarial queries - try to make the system hallucinate and verify it refuses when confidence is low
4. **Log all BigQuery costs** - monitor query costs and optimize before they scale
5. **Test the full pipeline end-to-end** - upload a document, upload structured data, query combining both, verify answer cites correct sources with confidence scores
6. **Preserve Level 1 frontend patterns** - the dashboard and chat UI should feel familiar to anyone who's used Level 1
