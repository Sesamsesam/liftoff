---
name: vertex-rag-pipeline
description: "RAG Level 2 - Enterprise-grade RAG with Google Vertex AI, Cloud Run, and BigQuery for regulated industries requiring precision, grounding controls, and numerical analysis"
---

# Vertex RAG Pipeline - RAG Level 2

> This will literally allow you to build something that someone in your industry would pay a million dollars for, seriously. This is the enterprise-grade RAG system - Google Vertex AI + Cloud Run + BigQuery - for industries where precision isn't a nice-to-have, it's a legal and hyper professional requirement.

Enterprise-grade RAG - Google Vertex AI + Cloud Run + BigQuery - for industries where precision is a legal requirement. Auditing, financial analysis, legal due diligence, healthcare compliance. Upload 50,000+ documents, connect massive numerical datasets via BigQuery, and get answers with grounding controls and confidence scoring.

> [!IMPORTANT]
> **Start with RAG Level 1 first.** Build `autorag-pipeline` (Level 1) first. It teaches RAG concepts on a free platform, and the frontend architecture transfers directly to Level 2. You're just swapping the backend brain.

> [!NOTE]
> **This skill is currently an outline.** Detailed implementation instructions will be added when we build (estimated: one month after Level 1 is complete).

---

## Why Level 2 Exists (when we got auto-rag lvl 1 with cloudflare?)

RAG Level 1 (Cloudflare AutoRAG) is incredible for document search, knowledge bases, and general Q&A and it's great for businesses and use cases where there's room for either creativity or broad knowledge and assumptions where numbers, and very strict rules are not a requirement - rules and parameters where if you get it wrong there's not major professional consequences. That's not to say that Level 1 is not a serious tool for serious businesses, it's just that Level 2 with Vertex Rag is for businesses that need to be absolutely sure about their numbers and rules and typically businesses who work in regulated industries.

**Summary:** 
Level 1 is a text retrieval system that's easy to deploy, very fast to build and incredibly useful for many use cases. 

Level 2 is a precision analysis platform that can handle both unstructured documents AND structured numerical data with enterprise compliance.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?

The enterprise RAG system for regulated industries where accuracy has legal, financial, or safety consequences. Zero-tolerance hallucination. Upload 50,000+ documents, connect structured datasets via BigQuery, and get answers with grounding controls and confidence scoring.

## Why Does It Exist?

Level 1 (Cloudflare AutoRAG) is excellent for document search and Q&A - great for businesses where there's room for broad knowledge and assumptions. Level 2 is for businesses that need to be *absolutely sure* about their numbers and rules - typically regulated industries where getting it wrong has major professional consequences.

**In short:** Level 1 is a text retrieval system. Level 2 is a precision analysis platform that handles both unstructured documents AND structured numerical data with enterprise compliance.

## What It Does For You

Combines document retrieval (Vertex AI) with numerical analysis (BigQuery) in a single query. Every answer has confidence scores, source citations with relevance ratings, and configurable grounding controls that refuse to answer when confidence is low.

---

## Level 1 vs Level 2

| Capability | Level 1 (AutoRAG) | Level 2 (Vertex AI) |
|---|---|---|
| Chunking | Fully abstracted | Configurable (size, overlap, semantic) |
| Embedding models | CF Workers AI (free) or external via AI Gateway | Domain-specific (legal, medical, financial) |
| Grounding controls | None | Confidence thresholds, source attribution scoring |
| Hallucination mitigation | Basic RAG retrieval | Configurable safety, answer rejection |
| Numerical analysis | Text only | Native BigQuery |
| Compliance | Basic | SOC 2, HIPAA, ISO 27001, audit logs |
| Cost | Free tier | Pay-as-you-go ($50-200/mo typical) |

---

## Activation
- When the user needs enterprise-grade RAG with grounding controls
- When working with regulated industries or zero-tolerance hallucination requirements

<!-- ═══════════════════════════════════════════════════ -->
<!-- WHO & WHEN                                         -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Who This Is For

### The Hero Use Case: Auditing Firms

An auditing firm managing multiple corporate accounts with deep, cross-referential analysis:

**What you upload:** 50,000+ employee payroll records, tax filings, board minutes, legal contracts, financial statements spanning years, compliance docs across jurisdictions.

**What you ask:**
- "Analyze Corporation A's tax situation with their new merger. Weigh against 2026 HK corporation tax codes. Flag compliance gaps."
- "Cross-reference all vendor agreements for Company B against expenditure reports. Any contracts where we're paying above agreed rates?"
- "Variance analysis of Company C's payroll Q2-Q4. Flag anomalies above 2 standard deviations with specific employee records."

**Why Level 2:** These queries mix document retrieval (contracts, filings) with numerical analysis (payroll data, variance calculations). BigQuery handles the numbers. Vertex AI handles the text. Grounding controls ensure the AI doesn't hallucinate a tax code that could cost your client millions.

### Other Industries

| Industry | Key Need | Example Query |
|---|---|---|
| **Financial Analysis** | SEC filings + revenue forecasting | "Revenue forecast combining earnings calls with structured data" |
| **Legal** | High-precision contract review | "Cross-jurisdictional regulatory compliance across 10K contracts" |
| **Healthcare** | HIPAA compliance, zero hallucination | "Drug interaction check requiring full audit trail" |
| **Government** | Strict access controls, policy analysis | "Inter-agency document cross-referencing with data residency" |

<!-- ═══════════════════════════════════════════════════ -->
<!-- ARCHITECTURE & BUILD                               -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Architecture

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

| Component | Service | Purpose |
|---|---|---|
| Document storage | Cloud Storage | Original uploaded documents |
| Structured data | BigQuery | Numerical analysis engine |
| Embeddings | Vertex AI Embeddings API | Configurable/domain-specific models |
| Vector database | Vertex AI Vector Search | High-performance similarity search |
| Generation | Vertex AI (Gemini) | Grounded answer generation with confidence scoring |
| API layer | Cloud Run | Orchestrator - routes uploads, coordinates multi-step queries |
| Metadata | Cloud SQL or Firestore | Files, categories, permissions, audit logs |
| Frontend | Cloud Run or CF Pages | Reuse Level 1 dashboard architecture |
| Auth | Firebase Auth or Clerk | Enterprise SSO, RBAC |
| Monitoring | Cloud Logging | Full audit trail, usage analytics |

---

## Key Differentiators

### Grounding Controls
- Minimum confidence thresholds - system refuses to answer if not confident enough
- Source attribution scoring - every claim linked to source with relevance score
- Hallucination detection via cross-referencing against retrieved passages

### BigQuery Integration
- Cloud Run auto-routes documents to Vertex AI, structured data to BigQuery
- Combined queries: document retrieval + numerical analysis in one request
- Example: salary variance query pulls BigQuery data + policy docs from Vertex AI, Gemini synthesizes both

### Domain-Specific Embeddings
- Models trained on legal, financial, medical, or technical corpora
- Fine-tune on your own data for maximum accuracy

### Enterprise Compliance
- SOC 2 Type II, HIPAA, ISO 27001
- Data residency controls, full audit logging, encryption at rest and in transit

---

## Build Phases

### Phase 1: Infrastructure
- [ ] Google Cloud project with billing
- [ ] Cloud Storage bucket, BigQuery dataset
- [ ] Vertex AI API access, Cloud Run service
- [ ] Authentication (Firebase Auth or Clerk)

### Phase 2: Document Pipeline
- [ ] Upload to Cloud Storage with categories
- [ ] Configurable chunking + Vertex AI embeddings
- [ ] Vector Search index creation
- [ ] Metadata storage

### Phase 3: BigQuery Integration
- [ ] Cloud Run routing (documents vs structured data)
- [ ] Schema detection + BigQuery table creation
- [ ] Natural language to SQL via Vertex AI
- [ ] Orchestrated multi-system queries

### Phase 4: Query Engine with Grounding
- [ ] Configurable retrieval + grounding controls
- [ ] Confidence scoring and answer rejection
- [ ] Source citations with relevance scores

### Phase 5: Dashboard & Chat UI
- [ ] Reuse Level 1 frontend, add confidence display
- [ ] BigQuery results visualization
- [ ] Admin panel for model config and thresholds

### Phase 6: Enterprise Features
- [ ] RBAC, audit trail, data residency
- [ ] Export, compliance reporting, SSO

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Cost Considerations

| Service | Pricing Model | Optimization |
|---|---|---|
| Cloud Storage | Per GB + egress | Lifecycle policies, nearline for old docs |
| BigQuery | Per TB queried | Partitioning, clustering, caching |
| Vertex AI Embeddings | Per 1K characters | Batch processing, cache embeddings |
| Vertex AI Generation | Per 1K tokens | Prompt optimization, response caching |
| Cloud Run | Per vCPU-second | Auto-scaling, min instances = 0 |
| Vector Search | Per node-hour | Right-size index, batch queries |

**Typical mid-size deployment:** $50-200/month.

---

## Lessons Learned

> Filled in as we build. Every gotcha and optimization goes here.

---

## Agent Rules

1. **Verify Google Cloud auth** before any infrastructure operations
2. **Never store credentials in code** - use env vars or Secret Manager
3. **Test grounding controls** with adversarial queries - verify system refuses when confidence is low
4. **Log BigQuery costs** - monitor and optimize before they scale
5. **Test full pipeline end-to-end** - upload document + structured data, combined query, verify citations with confidence scores
6. **Preserve Level 1 frontend patterns** - dashboard and chat should feel familiar
