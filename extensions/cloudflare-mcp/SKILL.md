---
name: cloudflare-mcp
description: "Connect to Cloudflare's infrastructure via MCP Portal. Create databases, manage storage, deploy workers, run AI - all through natural language."
category: infrastructure
---

# Cloudflare MCP

> **This one takes a bit of effort to set up, but the payoff is extraordinary.**

Cloudflare powers roughly 20% of the entire internet. Databases, file storage, serverless functions, AI models, vector search, RAG pipelines, DNS, analytics, security - the full stack of what it takes to build and run production applications at scale.

What used to require 3-5+ years of DevOps experience to understand and operate, you can now control through natural language. Antigravity becomes your senior infrastructure engineer - one that can read every page of documentation, understand your ideas, and build the best architecture for your use case. You describe what you want. It builds it.

The connection happens through an **MCP Portal** on your Cloudflare account. This is a single URL that bundles all the Cloudflare tools your agent needs behind one secure entry point. Once set up, you never touch the Cloudflare dashboard again - unless you want to. Everything from creating a database to deploying a Worker to spinning up a RAG pipeline happens right here, in conversation.

Setting it up requires some manual steps because Cloudflare is serious about security (which is exactly what you want from the platform protecting your infrastructure). But you only do it once, and from that point forward, it's pure superpowers.

---

## Before vs After: Creating a D1 Database

### Without MCP (manual)

1. Open browser, go to dash.cloudflare.com
2. Navigate to Workers & Pages > D1
3. Click "Create database"
4. Name it, choose location, click Create
5. Copy the database ID
6. Go back to your editor
7. Open `wrangler.toml`, paste the binding config
8. Write your SQL schema manually
9. Go back to the dashboard, open the D1 console
10. Paste and run your SQL
11. Hope you didn't make a typo
12. Test, rewrite, go back, reconfigure

### With MCP (agent-assisted)

```
You: "Create a D1 database called 'my-app-db' and set up a users table
      with id, email, name, and created_at and connect it to my project"

Agent: Done. Created the database, added the binding to your wrangler.toml,
       and executed the schema. Here's the database ID: [abc123].
```

One message. Same result. No dashboard, no copy-paste, no typos.

---

## Prerequisites

1. **A Cloudflare account** - [Sign up free](https://www.cloudflare.com/). The free tier is genuinely generous - D1, R2, Workers, and KV all have free tiers
2. **A domain on Cloudflare** - You need one to create an MCP Portal. If you're building apps that go live on the internet, you need a domain anyway. Example: `yourdomain.com`
3. **An identity provider in Zero Trust** - Google, GitHub, or one-time PIN. This is how you log in to your portal

---

## Setup

### Step 1: Create the MCP Portal

Go to `dash.cloudflare.com` > Zero Trust (sidebar) > Access controls > AI controls > **Add MCP server portal**

| Field | What to Enter |
|---|---|
| Portal name | `Antigravity` |
| Portal ID | `antigravity` |
| Subdomain | `mcp` |
| Domain | Pick any domain from your Cloudflare account |

Your portal URL will be: `https://mcp.yourdomain.com/mcp`

### Step 2: Add MCP Servers

Click **Select existing servers** and add these 8 servers. Each one gives your agent a different set of capabilities:

| Server | What It Does |
|---|---|
| **Bindings** | **The big one.** D1 databases, R2 file storage, KV caching, Workers, Hyperdrive. Your entire backend in one server. Cloudflare has 50+ open-source AI models built in (Workers AI) that need no API key |
| **Builds** | Deploy and manage Workers. Build triggers, deployment status, rollback. Your CI/CD |
| **AI Gateway** | Route between AI providers (OpenAI, Anthropic, Google). Rate limiting, caching, cost analytics across all providers through one endpoint |
| **Observability** | Workers runtime logs, error traces, performance metrics. Debug production issues without leaving your editor |
| **GraphQL** | Query Cloudflare's analytics API directly. Bandwidth, requests, threats. Build monitoring dashboards |
| **DNS Analytics** | Manage DNS records and view query analytics. Point domains, check propagation |
| **AutoRAG** | Build RAG pipelines. Feed your docs to AI, create searchable knowledge bases. Build chatbots that actually know your product |
| **Docs** | Agent can search Cloudflare's official documentation. References real guides instead of hallucinating APIs |

### Step 3: Prune Tools (Recommended)

Click the **Tools authorized** count for each server to toggle individual tools. Two optimizations:

**Remove destructive operations** (do deletes manually in the dashboard for safety):
- Bindings: turn off `kv_namespace_delete`, `r2_bucket_delete`, `d1_database_delete`, `hyperdrive_config_delete`

**Remove redundant tools:**
- GraphQL: turn off `graphql_complete_schema`, `graphql_schema_overview`, `graphql_type_details` (all redundant with `graphql_schema_search`)

This brings you to about **52 active tools** across all 8 servers.

### Step 4: Create Access Policies

> [!CAUTION]
> This is the step most people miss, and it causes a "No allowed servers available" error. Cloudflare has deny-by-default security at **two levels** - the portal AND each individual server.

**4a: Portal Policy**

Go to your portal's **Policies** tab > Create new policy:
- Policy name: `admin`
- Action: Allow
- Selector: Emails
- Value: your Cloudflare account email

**4b: Per-Server Policies**

Go to **Access controls > Applications**. Each MCP server appears as a separate application. For **each one**:
1. Click the server name
2. Go to the Policies tab
3. Assign your `admin` policy
4. Save

Same policy, applied to every server. Without this step, the portal will authenticate you but show zero available servers.

### Step 5: Add to Your Agent Config

Add this single entry to your MCP configuration (`~/.gemini/antigravity/mcp_config.json`):

```json
"cloudflare": {
  "command": "npx",
  "args": ["-y", "mcp-remote", "https://mcp.yourdomain.com/mcp"]
}
```

One URL. One config entry. All 8 servers, 52 tools.

### Step 6: Authorize

1. Start (or restart) Antigravity
2. Your browser opens the portal: **"Connect to Antigravity"**
3. Check the servers you want and click **Authorize** for each
4. The OAuth callback completes and you're connected

> [!NOTE]
> Every time you start a new Antigravity session, you'll need to authorize through the Zero Trust page. This is a quick browser popup - click through and you're in. It's a security feature, not a bug.

---

## Servers We Skipped (and Why)

| Server | Why Not |
|---|---|
| Containers | Docker-style edge containers. Skip if your stack is Convex + Pages + Workers |
| Radar | 65 tools for internet traffic research. Exceeds the tool budget on its own |
| Browser Rendering | Redundant - Antigravity has built-in browser tools |
| Logpush | Enterprise log delivery configuration |
| Audit Logs | Tracks "who changed what" - unnecessary for solo use |

---

## Troubleshooting

**"No allowed servers available"**
Per-server Access policies are missing. See Step 4b.

**No login page appears**
Stale Zero Trust session cookie. Visit `https://mcp.yourdomain.com/cdn-cgi/access/logout`, then try again.

**Tools not showing after dashboard changes**
Restart Antigravity to refresh the tool list. Dashboard changes aren't picked up mid-session.

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
> The direct URLs above are listed as a reference. With the Portal approach, you don't use them individually. The Portal bundles everything behind one URL and lets you manage access from the Cloudflare dashboard.

---

## Activation

- Enable in `~/.gemini/settings/extensions.json`: `"cloudflare-mcp": true`
- Triggered when the user asks about Cloudflare setup, backend infrastructure, D1, R2, Workers, or deployment

---

## Rules for the Agent

- **Always verify** the user has authenticated before attempting operations - if OAuth hasn't been completed, guide them through it
- **Set active account first** - call `set_active_account` on each server before using its tools. Every server maintains its own account context independently
- **Start with Bindings** - most infrastructure tasks (D1, R2, KV) go through the Workers Bindings server
- **Explain what you're doing** - when creating resources, tell the user what was created and any IDs/bindings they should know about
- **Respect the free tier** - warn users before operations that require a paid plan (but also mention paid plans that are free to activate)
- **Don't over-connect** - only suggest adding more MCP servers if the user actually needs them
- **Security-first** - destructive operations (deleting databases, buckets, KV namespaces) should be done manually in the dashboard, not through MCP
