---
name: cloudflare-mcp
description: "Connect to Cloudflare's infrastructure via MCP Portal. Create databases, manage storage, deploy workers, run AI - all through natural language."
---

# Cloudflare MCP

> **This one takes effort to set up, but the payoff is extraordinary.**

Cloudflare powers ~20% of the internet. Databases, file storage, serverless functions, AI models, vector search, RAG pipelines, DNS, analytics, security - the full production stack.

What used to require 3-5+ years of DevOps experience, you now control through natural language and you essentially need 0 experience to start. Antigravity becomes your senior infrastructure engineer - one that reads every page of documentation and builds the best architecture for your use case and can teach you along the way. You will learn by using it having a guardian angel watching over you and AI to automate/write/configure everything for you.

The connection uses an **MCP Portal** - a single URL bundling all Cloudflare tools behind one secure entry point. Once set up, everything from creating a database to deploying a Worker happens right here in conversation.

<!-- ═══════════════════════════════════════════════════ -->
<!-- BEFORE VS AFTER                                    -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Before vs After: Creating a D1 Database

**Without MCP (10-20 min manual):**
1. Open dashboard
2. Navigate to D1
3. Click Create
4. Name it
5. Copy ID
6. Open editor
7. Paste binding config
8. Write SQL
9. Paste in console
10. Run
11. Hope no typos
12. Test
13. Rewrite...

**With MCP:**
> "Create a D1 database and set up a users table." Done in one message.

<!-- ═══════════════════════════════════════════════════ -->
<!-- SETUP                                              -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Prerequisites

1. **A Cloudflare account** - [Sign up free](https://www.cloudflare.com/). The free tier is genuinely generous - D1, R2, Workers, and KV all have free tiers
2. **A domain on Cloudflare** - You need one to create an MCP Portal. If you're building apps that go live on the internet, you need a domain anyway. Example: `yourdomain.com`
3. **Identity provider in Zero Trust** - Google, GitHub, or one-time PIN, the Agent will guide you.

---

## Setup

### Step 1: Create the MCP Portal

`dash.cloudflare.com` > Zero Trust > Access controls > AI controls > **Add MCP server portal**

| Field | Value |
|---|---|
| Portal name | `Antigravity` |
| Portal ID | `antigravity` |
| Subdomain | `mcp` |
| Domain | Pick any domain from your account |

Portal URL: `https://mcp.yourdomain.com/mcp`

### Step 2: Add MCP Servers

Click **Select existing servers** and add these 8:

| Server | What It Does |
|---|---|
| **Bindings** | **The big one.** D1, R2, KV, Workers, Hyperdrive. 50+ built-in AI models (Workers AI) |
| **Builds** | Deploy/manage Workers. Build triggers, status, rollback |
| **AI Gateway** | Route between AI providers. Rate limiting, caching, cost analytics |
| **Observability** | Workers logs, error traces, performance metrics |
| **GraphQL** | Analytics API. Bandwidth, requests, threats |
| **DNS Analytics** | DNS records, query analytics, propagation |
| **AutoRAG** | RAG pipelines, searchable knowledge bases |
| **Docs** | Search official documentation (prevents hallucinated APIs) |

### Step 3: Prune Tools (Recommended)

Click **Tools authorized** for each server. Two optimizations:

**Remove destructive operations** (do deletes manually for safety):
- Bindings: turn off `kv_namespace_delete`, `r2_bucket_delete`, `d1_database_delete`, `hyperdrive_config_delete`

**Remove redundant tools:**
- GraphQL: turn off `graphql_complete_schema`, `graphql_schema_overview`, `graphql_type_details` (redundant with `graphql_schema_search`)

Result: ~52 active tools across 8 servers.

### Step 4: Create Access Policies

> [!CAUTION]
> Most common error: "No allowed servers available." Cloudflare has deny-by-default at **two levels** - portal AND each server.

**4a: Portal Policy**
Portal > Policies tab > Create: name `admin`, Action Allow, Selector Emails, Value: your Cloudflare email. This is so only you are allowed to use the MCP Portal.

**4b: Per-Server Policies**
Access controls > Applications. Each MCP server = separate app. For **each one**: click name > Policies tab > assign `admin` policy > Save.

Without 4b, the portal authenticates you but shows zero servers.

### Step 5: Add to Agent Config

Add to `~/.gemini/antigravity/mcp_config.json`:

```json
"cloudflare": {
  "command": "npx",
  "args": ["-y", "mcp-remote", "https://mcp.yourdomain.com/mcp"]
}
```

One URL. One config entry. All 8 servers, 52 tools.

### Step 6: Authorize

1. Start (or restart) Antigravity
2. Browser opens: "Connect to Antigravity"
3. Check servers, click **Authorize** for each
4. OAuth completes - connected

> [!NOTE]
> Each new session requires re-authorization via Zero Trust popup. Security feature, not a bug.

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Servers We Skipped

| Server | Why Not |
|---|---|
| Containers | Docker-style edge containers. Skip if using Convex + Pages + Workers |
| Radar | 65 tools for internet traffic research. Exceeds tool budget |
| Browser Rendering | Redundant - Antigravity has built-in browser tools |
| Logpush | Enterprise log delivery configuration |
| Audit Logs | Tracks "who changed what" - unnecessary for solo use |

---

## Troubleshooting

| Issue | Fix |
|---|---|
| "No allowed servers available" | Per-server Access policies missing (Step 4b) |
| No login page appears | Stale cookie. Visit `https://mcp.yourdomain.com/cdn-cgi/access/logout` |
| Tools not showing after changes | Restart Antigravity to refresh tool list |

---

## All Available Servers (Reference)

| Server | Direct URL |
|---|---|
| Workers Bindings | `https://bindings.mcp.cloudflare.com/mcp` |
| Workers Builds | `https://builds.mcp.cloudflare.com/mcp` |
| Observability | `https://observability.mcp.cloudflare.com/mcp` |
| Documentation | `https://docs.mcp.cloudflare.com/mcp` |
| DNS Analytics | `https://dns-analytics.mcp.cloudflare.com/mcp` |
| Containers | `https://containers.mcp.cloudflare.com/mcp` |
| Browser Rendering | `https://browser.mcp.cloudflare.com/mcp` |
| AI Gateway | `https://ai-gateway.mcp.cloudflare.com/mcp` |
| AutoRAG | `https://autorag.mcp.cloudflare.com/mcp` |
| Logpush | `https://logs.mcp.cloudflare.com/mcp` |
| Audit Logs | `https://auditlogs.mcp.cloudflare.com/mcp` |
| Radar | `https://radar.mcp.cloudflare.com/mcp` |
| GraphQL | `https://graphql.mcp.cloudflare.com/mcp` |

Source: [cloudflare/mcp-server-cloudflare](https://github.com/cloudflare/mcp-server-cloudflare)

> [!TIP]
> The direct URLs are reference only. The Portal bundles everything behind one URL.

---

## Activation
- Enable in `~/.gemini/settings/extensions.json`: `"cloudflare-mcp": true`
- Triggered by: Cloudflare setup, backend infrastructure, D1, R2, Workers, deployment

---

## Agent Rules

- **Verify auth** before operations - guide through OAuth if not completed
- **Set active account first** - call `set_active_account` on each server before using its tools
- **Start with Bindings** - most infrastructure tasks go through Workers Bindings
- **Explain operations** - tell user what was created and relevant IDs/bindings
- **Respect free tier** - warn before paid-plan operations
- **Don't over-connect** - only suggest more servers if actually needed
- **Security-first** - destructive operations done manually in dashboard, not through MCP
