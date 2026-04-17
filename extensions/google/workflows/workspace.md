---
name: google-workspace-workflow
description: "Post-setup: verify Google Workspace CLI connection and test operations."
---

# Google Workspace - CLI Workflow

> **Prerequisites:** Complete [SETUP.md](../SETUP.md) first. `gws` must be installed and authenticated with your chosen scopes.

> [!NOTE]
> **No MCP server.** Google removed MCP server mode from gws in v0.8.0. The agent accesses Google Workspace by running `gws` commands directly through the terminal. This works the same way - the agent just runs commands like `gws gmail +send` instead of calling MCP tools.

## Checklist

- [ ] Step 1: Verify gws is ready
- [ ] Step 2: Test real operations
- [ ] Step 3: Install gws agent skills (optional)

---

### Step 1: Verify gws Is Ready

```bash
gws --version
gws drive files list --params '{"pageSize": 1}'
```

Both should succeed. If the second fails with an auth error, re-run:

```bash
gws auth login -s drive,gmail,calendar,sheets,docs,meet
```

---

### Step 2: Test Real Operations

Use helper commands where available. Fall back to raw API calls for operations without helpers.

```bash
# Calendar - today's agenda (helper command)
gws calendar +agenda

# Gmail - inbox triage (helper command)
gws gmail +triage

# Drive - list recent files (raw API)
gws drive files list --params '{"pageSize": 3}'

# Sheets - list spreadsheets (raw API)
gws drive files list --params '{"pageSize": 3, "q": "mimeType=\"application/vnd.google-apps.spreadsheet\""}'
```

If any service returns "API not enabled," the agent enables it:

```bash
gcloud services enable <api>.googleapis.com --project=PROJECT_ID
```

> [!TIP]
> For the complete list of helper commands and raw API patterns, see [command-reference.md](./command-reference.md).

---

### Step 3: Install gws Agent Skills (Optional)

The gws repo ships 100+ agent skills for higher-level workflows. These enhance the `gws` CLI itself (they are NOT Antigravity extensions).

```bash
gws skills add https://github.com/googleworkspace/cli
```

Or pick specific services:

```bash
gws skills add https://github.com/googleworkspace/cli/tree/main/skills/gws-drive
gws skills add https://github.com/googleworkspace/cli/tree/main/skills/gws-gmail
```

> [!NOTE]
> Skills are optional. The `gws` CLI provides full API access without them. Skills add higher-level patterns the CLI can follow for common workflows.
>
> For the full catalog of available skills, see [skills-catalog.md](./skills-catalog.md).

### Adding More Services Later

No reinstall needed. Re-authenticate with additional services:

```bash
gws auth login -s drive,gmail,calendar,sheets,docs,meet,chat,keep
```

Stay under the 25-scope limit for unverified apps.

<!-- CREW BRIEF -->
> **After workflow is complete, tell the user:**
>
> "Google Workspace is connected! I can now:
>
> - **Gmail** - Read, search, and send emails (`gws gmail +send`, `+triage`)
> - **Drive** - Browse, upload, and organize files (`gws drive +upload`)
> - **Calendar** - Check your schedule and create events (`gws calendar +agenda`)
> - **Sheets** - Create and edit spreadsheets (`gws sheets +append`, `+read`)
> - **Docs** - Create and read documents (`gws docs +write`)
> - **Meet** - Access meeting information
>
> Just ask naturally - 'check my calendar for tomorrow' or 'find that invoice in Drive.'
>
> I access these through the `gws` command-line tool. Your credentials are encrypted with AES-256-GCM and stored in your OS keychain. To disconnect, disable the Google extension in your extensions.json."

> ✅ **Workflow complete.**
