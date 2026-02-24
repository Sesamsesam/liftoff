# Liftoff - Pending Tasks

> Last updated: 2026-02-24

## 1. Test onboarding refactor (just shipped)
- [ ] Wipe `~/.gemini/` and run `install.sh` fresh - confirm no profile prompt, all extensions auto-discovered
- [ ] Test first-session bootstrap - confirm `package-manager/SKILL.md` detects brew, bun, git, gh
- [ ] Test `init-project` workflow - confirm `gh repo create --private`, no Convex by default, extension suggestions at end

## 2. Extensions Status

### Shipped (in `extensions/`)
- [x] `cloudflare-mcp` - Cloudflare deployment, R2, D1, Workers via MCP
- [x] `firecrawl` - Scrape, crawl, and convert any website to clean structured data
- [x] `autorag-pipeline` - RAG Level 1: R2 + AutoRAG + chat interface (20-min setup)
- [x] `orbit-planning` - O.R.B.I.T. deep project planning
- [x] `notebooklm-research` - NotebookLM MCP integration
- [x] `minibook-pipeline` - End-to-end minibook creation
- [x] `beads-workflow` - Cross-session context persistence

### Pending (in `updates-pending/` - coming in the next weeks)
- [ ] `extended-git` - Graphite + Greptile (written, needs testing)
- [ ] `vertex-rag-pipeline` - RAG Level 2 enterprise (outline only)
- [ ] `google-cloud` - Google Cloud Run + Vertex AI (not started, needed for vertex-rag-pipeline)
