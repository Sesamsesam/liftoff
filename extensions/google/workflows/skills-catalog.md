# Google Workspace CLI - Skills Catalog

> **Reference document.** The agent reads this when a user asks "what skills are available?" for Google Workspace. Skills are installed on demand, not during setup.

---

## What Are gws Skills?

The gws CLI ships with an optional library of **100+ skill files** that enhance the CLI's capabilities. These are distinct from Antigravity extensions:

| | Antigravity Extensions | gws CLI Skills |
|---|---|---|
| **Purpose** | Teach the agent how to use tools | Teach the `gws` CLI how to perform specific tasks |
| **Install** | Copy to `~/.gemini/extensions/` or `user-extensions/` | `gws skills add <url>` |
| **Used by** | The agent (reads SKILL.md) | The `gws` command itself |
| **Live in** | `~/.gemini/` | gws's own config directory |

**Do NOT install gws skills into `~/.gemini/user-extensions/`.** They are a different system.

---

## How to Install

Install the complete upstream skill library:

```bash
gws skills add https://github.com/googleworkspace/cli
```

Or install individual categories. The agent should explain what's available and let the user choose.

---

## Skill Categories

### Core Services (19 skills)

Service-specific skills that define how the CLI interacts with each Google API.

| Skill | Description |
|---|---|
| `gws-shared` | Auth patterns, global flags, output formatting |
| `gws-drive` | Files, folders, shared drives |
| `gws-sheets` | Spreadsheet read/write |
| `gws-gmail` | Email send, read, manage |
| `gws-calendar` | Calendar and event management |
| `gws-docs` | Document read/write |
| `gws-slides` | Presentation management |
| `gws-tasks` | Task lists and tasks |
| `gws-people` | Contacts and profiles |
| `gws-chat` | Chat spaces and messages |
| `gws-classroom` | Classes, rosters, coursework |
| `gws-forms` | Google Forms read/write |
| `gws-keep` | Google Keep notes |
| `gws-meet` | Meeting conferences |
| `gws-events` | Workspace event subscriptions |
| `gws-modelarmor` | Content safety filtering |
| `gws-workflow` | Cross-service productivity workflows |
| `gws-script` | Apps Script project management |
| `gws-admin-reports` | Audit logs and usage reports |

### Helper Commands (26 skills)

Shortcut commands for single operations. Each installs a `+command` shortcut.

| Helper | Service | What It Does |
|---|---|---|
| `+send` | Gmail | Send an email |
| `+reply` | Gmail | Reply to a message |
| `+reply-all` | Gmail | Reply-all to a message |
| `+forward` | Gmail | Forward a message |
| `+triage` | Gmail | Inbox summary |
| `+watch` | Gmail | Stream new emails |
| `+upload` | Drive | Upload a file |
| `+agenda` | Calendar | Today's agenda |
| `+insert` | Calendar | Create an event |
| `+append` | Sheets | Append a row |
| `+read` | Sheets | Read a cell range |
| `+write` | Docs | Append text to a doc |
| `+send` | Chat | Send a Chat message |
| `+push` | Tasks | Add a task |
| `+standup-report` | Workflow | Daily standup summary |
| `+meeting-prep` | Workflow | Prepare for next meeting |
| `+email-to-task` | Workflow | Convert email to task |
| `+weekly-digest` | Workflow | Weekly summary |
| `+file-announce` | Workflow | Announce file in Chat |
| `+subscribe` | Events | Subscribe to events |
| `+renew` | Events | Renew subscription |
| `+sanitize-prompt` | ModelArmor | Sanitize AI prompt |
| `+sanitize-response` | ModelArmor | Sanitize AI response |
| `+create-template` | ModelArmor | Create safety template |

### Persona Bundles (10 role-based skill sets)

Pre-configured skill bundles for specific roles. Each persona activates a curated combination of services and helpers.

| Persona | Description |
|---|---|
| `persona-exec-assistant` | Schedule, inbox, communications management |
| `persona-project-manager` | Task tracking, meetings, doc sharing |
| `persona-hr-coordinator` | Onboarding, announcements, employee comms |
| `persona-sales-ops` | Deal tracking, calls, client communications |
| `persona-it-admin` | Security monitoring, Workspace configuration |
| `persona-content-creator` | Content creation and distribution |
| `persona-customer-support` | Ticket tracking, responses, escalation |
| `persona-event-coordinator` | Event planning, invitations, logistics |
| `persona-team-lead` | Standups, task coordination, team comms |
| `persona-researcher` | References, notes, collaboration |

### Recipes (40+ multi-step task sequences)

Automated workflows that chain multiple commands together.

| Recipe | What It Does |
|---|---|
| `label-and-archive-emails` | Auto-label and archive emails matching criteria |
| `draft-email-from-doc` | Create a Gmail draft from a Google Doc |
| `organize-drive-folder` | Sort files into subfolders by type |
| `share-folder-with-team` | Bulk-share a folder with a list of emails |
| `create-expense-tracker` | Create a Sheets expense tracker from template |
| `block-focus-time` | Block recurring focus time on Calendar |
| `reschedule-meeting` | Move a meeting to a new time |
| `create-gmail-filter` | Create an auto-filter rule |
| `find-large-files` | Find files over a size threshold in Drive |
| `batch-invite-to-event` | Add multiple attendees to a Calendar event |
| `generate-report-from-sheet` | Create a Doc report from Sheets data |
| ...and 29+ more | See upstream repo for full list |

---

## Agent Behavior

When a user asks "what Google Workspace skills are available?" or "what can you do with Google?":

1. Read this catalog
2. Present the categories at a high level (services, helpers, personas, recipes)
3. Ask which category interests the user
4. Show the specific skills in that category
5. If the user wants to install, run:
   ```bash
   gws skills add https://github.com/googleworkspace/cli
   ```
6. Confirm installation succeeded

> [!NOTE]
> Installing all skills at once is fine - they're lightweight markdown files. The user can also browse individual skills at the upstream repository.

---

## Source

All skills maintained at: [github.com/googleworkspace/cli](https://github.com/googleworkspace/cli)
