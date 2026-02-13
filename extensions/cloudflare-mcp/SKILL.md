---
name: cloudflare-mcp
description: "Connect to Cloudflare's infrastructure via MCP. Create databases, manage storage, deploy workers - all through natural language."
category: infrastructure
---

# Cloudflare MCP

## What Is This?

Cloudflare is a cloud platform where your apps, databases, storage, and domains live on the internet. Think of it as the infrastructure layer - the servers, the database, the file storage, the DNS. When you build a site and you want to take it online: 

1. you buy a domain (can do on cloudflare) 
2. you need to point that domain to your server, 
3. you need to deploy your code to a server, 
4. and if you are actually building an app that can do stuff and not just a static website, then you need a database to store data, 
5. you need storage for user uploads, or run background jobs, AI agents, etc. 
This can ALL be done on cloudflare AND this extension connects your AI agent directly to Cloudflare so it can set up and manage the entire infrastructure for you.
6. They also give the best secruity and speed of delivery of your stuff to the end user. ⚡️

The connection happens through **MCP (Model Context Protocol)** - a bridge that lets the agent talk to Cloudflare's systems. Instead of you clicking through dashboards and copying config values, you describe what you need, and the agent handles it.

## Why Does It Exist?

Without this extension, managing Cloudflare means:
- Logging into the dashboard
- Navigating menus to find the right service (and knowing where to go and what you are doing)
- Manually creating resources and copying IDs
- Context-switching between your editor and the browser constantly

With it, the agent becomes your infrastructure engineer you never need to leave Antigravity. 🫰

---

## Before vs After: Creating a D1 Database

### Without MCP (manual) 🌵

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
12. test, rewrite, go back, reconfigure 🔂

### With MCP (agent-assisted) 🫰

```
You: "Antigravity good ol buddy, please create a D1 database called 'my-app-db' and set up a users table 
     with id, email, name, and created_at and connect it to my feature in my project"

Agent: Done. Created the database, added the binding to your wrangler.toml, 
       and executed the schema. Here's the database ID: [abc123].
```

One message. Same result. No dashboard, no copy-paste, no typos.

---

## How to Set Up

### Step 1: Create a Cloudflare Account

If you don't have one yet:
1. Go to [cloudflare.com](https://www.cloudflare.com/) and sign up (free tier is VERY generous, truly, very, very generous)
2. You don't need a paid plan to start - D1, R2, Workers all have free tiers.

### Step 2: Add the MCP Servers to Your Agent

Ask your agent to add the following to your MCP configuration. The agent knows where the config file lives based on your editor (Antigravity, Claude Desktop, Cursor, etc.).

**I've chosen these 7 servers for you** out of the 15 that Cloudflare offers. These cover building, deploying, AI, DNS, data querying, and documentation - basically everything you need to ship and manage real apps. Each server only gets permissions for its specific area, so your entire Cloudflare account isn't exposed to a single connection.

#### The Essentials (recommended)

> [!TIP]
> You don't need to understand what any of this means. These are the tools your agent gets access to. Once they're connected, the agent can create databases, deploy code, manage domains, and more - all by itself, without you needing any experience or knowledge about how these things work. Just describe what you want built.

**Workers Bindings** - THE BIG ONE. D1 databases, R2 file storage, KV key-value stores, Queues, Durable Objects, AI bindings. Your entire backend in one server (well, not exactly one server, but it controls all of these things). If you are building an app with user data and file storage and cool AI features this is what you need. Cloudflare has 50+ open-source AI models built in (Workers AI) - no third-party API key needed. Your agent can wire them up through this server.

**Workers Builds** - Everything your agent needs to deploy and manage Workers (serverless functions that run your app logic). Build triggers, deployment status, rollback - the CI/CD layer. If you want your agent to actually push your app live to the internet or roll back a broken deploy, it needs this.

**AI Gateway** - If you want to use third-party AI providers (OpenAI, Anthropic, Google, etc.) instead of or alongside Cloudflare's built-in models, this is the router. It handles model selection, prompt caching, rate limiting, and usage analytics across all your providers through one endpoint. You only need this if you're using external API keys.

**DNS Analytics** - Manage DNS records and view analytics for your domains. Point domains, check propagation, monitor query traffic. You need DNS to put your app on the internet.

**AutoRAG** - Retrieval-Augmented Generation. Feed your own docs and data to AI models and build knowledge bases your app's AI features can search against. If you want to build a chatbot that answers questions about your company's docs, or a support tool that knows your product inside out, your agent needs this.

**GraphQL** - Query Cloudflare's analytics via GraphQL - bandwidth, requests, threats, and more. If you want to build an analytics dashboard for your app, or have your agent investigate traffic spikes and security threats, it needs this.

**Documentation** - Gives the agent access to Cloudflare's official documentation. So when it builds something, it can reference the actual docs, not guess.

```json
{
  "mcpServers": {
    "cloudflare-bindings": {
      "url": "https://bindings.mcp.cloudflare.com/mcp"
    },
    "cloudflare-workers-builds": {
      "url": "https://builds.mcp.cloudflare.com/mcp"
    },
    "cloudflare-ai-gateway": {
      "url": "https://ai-gateway.mcp.cloudflare.com/mcp"
    },
    "cloudflare-dns-analytics": {
      "url": "https://dns-analytics.mcp.cloudflare.com/mcp"
    },
    "cloudflare-autorag": {
      "url": "https://autorag.mcp.cloudflare.com/mcp"
    },
    "cloudflare-graphql": {
      "url": "https://graphql.mcp.cloudflare.com/mcp"
    },
    "cloudflare-docs": {
      "url": "https://docs.mcp.cloudflare.com/mcp"
    }
  }
}
```

| Server | What It Controls | Use It When You Need To... |
|---|---|---|
| **Workers Bindings** | D1 databases, R2 storage, KV, Queues, Durable Objects, AI bindings | Create a database, store files, set up caching, wire up AI - your entire backend |
| **Workers Builds** | Workers deployment, build triggers, rollbacks | Deploy serverless functions, check build status, roll back a bad deploy |
| **AI Gateway** | Multi-provider AI routing, caching, analytics, rate limiting | Choose models, route between providers, monitor AI usage and costs |
| **DNS Analytics** | DNS records, domain management, query analytics | Point domains, manage records, check DNS propagation and traffic |
| **AutoRAG** | Retrieval-Augmented Generation, knowledge bases | Feed your own documents to AI models, build searchable knowledge bases |
| **GraphQL** | Cloudflare analytics API - bandwidth, requests, threats | Query deep analytics data, build monitoring dashboards |
| **Documentation** | Cloudflare's official docs, searchable by the agent | Have the agent reference real guides instead of hallucinating APIs |

### Step 3: Authenticate

The first time the agent connects to a Cloudflare MCP server:
1. Your browser opens automatically with a Cloudflare login page
2. Log in and authorize the connection
3. That's it - tokens are cached, future connections are automatic

Each server authenticates independently with only the permissions it needs (OAuth scoped access).

---

## Good to Know: The Portal (For Teams) 💡
You don't need this for solo work. The individual servers above are simpler and work perfectly on their own.

...but, If you're working on a team, Cloudflare offers something called an **MCP Portal** - a single URL that bundles multiple MCP servers together. Instead of every developer on the team adding 3-5 server URLs each to their editor, an admin creates one portal URL and everyone connects to that with one url.

**Why it's awesome for teams:**
- One URL instead of many - new team members are set up instantly
- Admins can curate which tools each team sees (hide DNS tools from frontend devs, for example)
- Every MCP request from every team member is logged centrally for auditing
- Access policies control who can do what (ops gets full access, interns get read-only)

**How it works:**
1. Go to Cloudflare One > Access controls > AI controls
2. Create an MCP server portal with a custom domain from your CF account
3. Add the individual MCP servers you want in the portal
4. Share the single portal URL with your team


---

## All Available Servers (Reference)

If you're a power user and want more control, here's the full catalog:

| Server | URL |
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
| CASB | `https://casb.mcp.cloudflare.com/mcp` |
| DEX | `https://dex.mcp.cloudflare.com/mcp` |

Source: [cloudflare/mcp-server-cloudflare](https://github.com/cloudflare/mcp-server-cloudflare)

---

## Activation

- Enable in `~/.gemini/settings/extensions.json`: `"cloudflare-mcp": true`
- Triggered when the user asks about Cloudflare setup, backend infrastructure, D1, R2, Workers, or deployment

---

## Rules for the Agent

- **Always verify** the user has authenticated before attempting operations - if OAuth hasn't been completed, guide them through it
- **Start with Bindings** - most infrastructure tasks (D1, R2, KV) go through the Workers Bindings server
- **Explain what you're doing** - when creating resources, tell the user what was created and any IDs/bindings they should know about
- **Respect the free tier** - warn users before operations that require a paid plan (But also tell them about the paid plans that are free they just need to be activated as paid)
- **Don't over-connect** - only suggest adding more MCP servers if the user actually needs them
- **Security-first** - recommend the minimum set of servers needed for the task at hand
