---
name: google
description: "Google Cloud infrastructure + Google Workspace (Gmail, Drive, Calendar, Sheets, Docs, Meet) via CLI."
---

# Google Cloud + Workspace

> **You don't need to do any of this manually.** The agent handles setup and usage automatically. If it needs you to do something (like logging in), it will tell you exactly what and when.

## What This Extension Does

Gives the agent direct access to Google Cloud infrastructure and Google Workspace applications through two CLI tools:

| Tool | What It Controls |
|---|---|
| `gcloud` | Google Cloud Platform - projects, APIs, infrastructure |
| `gws` | Google Workspace - Gmail, Drive, Calendar, Sheets, Docs, Meet |

> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for installation and authentication.

---

## How It Works

> [!IMPORTANT]
> **No MCP server for gws.** Google removed MCP server mode from the gws CLI in v0.8.0. The agent accesses Google Workspace by running `gws` commands directly through the terminal. This works the same way - it just doesn't appear in the MCP servers list.

The agent runs commands like:
```bash
gws gmail +send --to user@example.com --subject "Hello" --body "Message body"
```

And receives structured JSON output it can parse. No MCP config entry needed.

---

## Quick Reference: 6 Core Services

Each service has **helper commands** (prefixed with `+`) for common operations, plus full Discovery API access for everything else.

For the complete command reference with all flags and examples, see [workflows/command-reference.md](./workflows/command-reference.md).

### Gmail

| Command | What It Does |
|---|---|
| `gws gmail +send --to X --subject Y --body Z` | Send an email |
| `gws gmail +reply --message-id ID --body Z` | Reply to a message |
| `gws gmail +reply-all --message-id ID --body Z` | Reply-all |
| `gws gmail +forward --message-id ID --to X` | Forward a message |
| `gws gmail +triage` | Show unread inbox summary |
| `gws gmail +watch` | Stream new emails as NDJSON |

### Drive

| Command | What It Does |
|---|---|
| `gws drive +upload ./file.pdf --name "Name"` | Upload a file |
| `gws drive files list --params '{...}'` | List/search files |
| `gws drive files create --json '{...}' --upload ./file` | Create with metadata |
| `gws drive files get --params '{...}'` | Get file metadata |

### Calendar

| Command | What It Does |
|---|---|
| `gws calendar +agenda` | Today's upcoming events (auto-timezone) |
| `gws calendar +agenda --today --timezone America/New_York` | Agenda in specific timezone |
| `gws calendar +insert` | Create a new event |
| `gws calendar events list --params '{...}'` | List events |

### Sheets

| Command | What It Does |
|---|---|
| `gws sheets +append --spreadsheet ID --values "A,B,C"` | Append a row |
| `gws sheets +read --spreadsheet ID --range "Sheet1!A1:C10"` | Read cell values |
| `gws sheets spreadsheets create --json '{...}'` | Create new spreadsheet |

### Docs

| Command | What It Does |
|---|---|
| `gws docs +write --document ID --text "Content"` | Append text to doc |
| `gws docs documents create --json '{...}'` | Create new document |
| `gws docs documents get --params '{...}'` | Read document content |

### Meet

| Command | What It Does |
|---|---|
| `gws meet spaces create` | Create a meeting space |
| `gws meet conferenceRecords list` | List recorded meetings |
| `gws meet conferenceRecords participants list` | See who attended |

---

## Cross-Service Workflows

These commands span multiple Google services for common productivity tasks:

| Command | What It Does |
|---|---|
| `gws workflow +standup-report` | Today's meetings + open tasks as standup summary |
| `gws workflow +meeting-prep` | Prepare for next meeting: agenda, attendees, linked docs |
| `gws workflow +email-to-task` | Convert a Gmail message into a Google Tasks entry |
| `gws workflow +weekly-digest` | Weekly summary: meetings + unread email count |
| `gws workflow +file-announce` | Announce a Drive file in a Chat space |

---

## Full Service Catalog

Beyond the 6 core services, `gws` supports every Google Workspace API through the Google Discovery Service. The CLI dynamically builds its command surface from these APIs.

| Service | Description |
|---|---|
| `drive` | Files, folders, shared drives |
| `sheets` | Spreadsheet read/write |
| `gmail` | Email send, read, manage |
| `calendar` | Calendar and event management |
| `docs` | Document read/write |
| `slides` | Presentation management |
| `tasks` | Task lists and tasks |
| `people` | Contacts and profiles |
| `chat` | Chat spaces and messages |
| `classroom` | Classes, rosters, coursework |
| `forms` | Google Forms read/write |
| `keep` | Google Keep notes |
| `meet` | Meeting conferences |
| `events` | Workspace event subscriptions |
| `modelarmor` | Content safety filtering |
| `script` | Apps Script project management |
| `admin-reports` | Audit logs and usage reports |

To use any service not in the default 6, add it during re-authentication:
```bash
gws auth login -s drive,gmail,calendar,sheets,docs,meet,chat,tasks
```

For the full catalog of 100+ upstream skills (helpers, personas, recipes), see [workflows/skills-catalog.md](./workflows/skills-catalog.md).

---

## Agent Skills & Recipes

The gws CLI ships with an optional library of 100+ skill files that enhance the CLI itself. These are separate from Antigravity extensions - they install into gws's own config and are used by the `gws` command.

To install them:
```bash
gws skills add https://github.com/googleworkspace/cli
```

See [workflows/skills-catalog.md](./workflows/skills-catalog.md) for the complete categorized listing and on-demand installation.

---

## Security & Credentials

- Credentials are encrypted at rest with **AES-256-GCM**
- Encryption key stored in the **OS keychain** (macOS Keychain / Windows Credential Manager)
- Credentials never leave the local machine
- No data is sent to third-party services
- The agent requires **explicit user confirmation** for sensitive actions (sending emails, sharing files, deleting content)

---

## Agent Behavior Rules

### Security-first
- **Always confirm** before sending emails, sharing files, or deleting content
- Show the user exactly what will be sent/shared/deleted before executing
- Never auto-send emails or share files without explicit approval

### Command execution
- Use **helper commands** (`+send`, `+agenda`, etc.) when available - they're simpler and safer
- Fall back to raw Discovery API commands only when no helper exists
- Always parse JSON output to extract meaningful data before presenting to user
- If a command fails, check `gws auth login` status before retrying

### Error handling
- If authentication expires, re-run `gws auth login -s drive,gmail,calendar,sheets,docs,meet`
- If an API is not enabled, run `gcloud services enable <service>.googleapis.com`
- Never assume a failed command succeeded - always verify output

### Scope awareness
- The agent has access to 6 services by default: Drive, Gmail, Calendar, Sheets, Docs, Meet
- If the user asks about Chat, Tasks, or other services, explain they can be added via re-authentication
- Never attempt to use a service that hasn't been authorized

Source: [googleworkspace/cli](https://github.com/googleworkspace/cli)
